import { useEffect, useState } from 'react';
import type { ReactNode } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { Spin, message } from 'antd';
import { authApi } from '../services/api';
import { sessionManager } from '../utils/sessionManager';

interface ProtectedRouteProps {
  children: ReactNode;
}

export default function ProtectedRoute({ children }: ProtectedRouteProps) {
  const [isAuthenticated, setIsAuthenticated] = useState<boolean | null>(null);
  const location = useLocation();

  useEffect(() => {
    const checkAuth = async () => {
      // 先尝试通过 session_token 获取用户
      try {
        await authApi.getCurrentUser();
        setIsAuthenticated(true);
        sessionManager.setWarningCallback((msg) => {
          message.warning({ content: msg, duration: 10 });
        });
        sessionManager.start();
        return;
      } catch {
        // session_token 过期或不存在，尝试静默登录（refresh_token）
      }

      // 尝试通过 refresh_token 自动重登
      try {
        await authApi.silentLogin();
        setIsAuthenticated(true);
        sessionManager.setWarningCallback((msg) => {
          message.warning({ content: msg, duration: 10 });
        });
        sessionManager.start();
      } catch {
        // 静默登录失败，需要用户手动登录
        setIsAuthenticated(false);
        sessionManager.stop();
      }
    };
    checkAuth();

    return () => {
      sessionManager.stop();
    };
  }, []);

  if (isAuthenticated === null) {
    return (
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        minHeight: '100vh',
      }}>
        <Spin size="large" />
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to={`/login?redirect=${encodeURIComponent(location.pathname)}`} replace />;
  }

  return <>{children}</>;
}