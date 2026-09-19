#!/bin/bash
# MuMuAINovel 本地开发环境一键启动脚本
# 用法:
#   ./dev.sh        启动数据库 + 前后端
#   ./dev.sh stop   停止所有服务
#   ./dev.sh status 查看状态

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$PROJECT_DIR/docker-compose.yml"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC}  $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

stop_all() {
    log_info "停止所有服务..."
    
    # 停止后端
    if lsof -i:8000 -t >/dev/null 2>&1; then
        lsof -i:8000 -t | xargs kill 2>/dev/null || true
        log_info "后端已停止"
    fi
    
    # 停止前端
    if lsof -i:5173 -t >/dev/null 2>&1; then
        lsof -i:5173 -t | xargs kill 2>/dev/null || true
        log_info "前端已停止"
    fi
    
    # 停止数据库
    cd "$PROJECT_DIR"
    docker compose down 2>/dev/null || true
    log_info "数据库已停止"
    
    echo ""
    log_info "所有服务已停止"
}

start_dev() {
    echo ""
    log_info "========================================"
    log_info "  MuMuAINovel 开发环境启动"
    log_info "========================================"
    echo ""
    
    # 1. 启动数据库
    log_info "[1/3] 启动 PostgreSQL 数据库..."
    cd "$PROJECT_DIR"
    docker compose up -d postgres
    echo ""
    
    # 等待数据库就绪
    log_info "等待数据库就绪..."
    MAX_RETRIES=30
    for i in $(seq 1 $MAX_RETRIES); do
        if docker exec mumu-postgres-dev pg_isready -U mumuai >/dev/null 2>&1; then
            log_info "数据库就绪"
            break
        fi
        if [ $i -eq $MAX_RETRIES ]; then
            log_error "数据库启动超时"
            exit 1
        fi
        sleep 1
    done
    echo ""
    
    # 2. 启动后端
    log_info "[2/3] 启动后端 (uvicorn :8000)..."
    cd "$BACKEND_DIR"
    source .venv/bin/activate
    nohup .venv/bin/python -m uvicorn app.main:app \
        --host 0.0.0.0 --port 8000 --reload \
        > "$PROJECT_DIR/logs/backend.log" 2>&1 &
    BACKEND_PID=$!
    log_info "后端 PID: $BACKEND_PID  (日志: logs/backend.log)"
    
    # 等待后端就绪
    for i in $(seq 1 20); do
        if curl -s http://localhost:8000/health >/dev/null 2>&1; then
            log_info "后端就绪: http://localhost:8000"
            break
        fi
        if [ $i -eq 20 ]; then
            log_warn "后端可能还在启动中，请查看日志: logs/backend.log"
        fi
        sleep 1
    done
    echo ""
    
    # 3. 启动前端
    log_info "[3/3] 启动前端 (vite :5173)..."
    cd "$FRONTEND_DIR"
    nohup pnpm dev > "$PROJECT_DIR/logs/frontend.log" 2>&1 &
    FRONTEND_PID=$!
    log_info "前端 PID: $FRONTEND_PID  (日志: logs/frontend.log)"
    
    # 等待前端就绪
    for i in $(seq 1 20); do
        if curl -s http://localhost:5173 >/dev/null 2>&1; then
            log_info "前端就绪: http://localhost:5173"
            break
        fi
        if [ $i -eq 20 ]; then
            log_warn "前端可能还在启动中，请查看日志: logs/frontend.log"
        fi
        sleep 1
    done
    echo ""
    
    echo ""
    log_info "========================================"
    log_info "  全部启动完成"
    log_info "========================================"
    echo ""
    echo "  前端:  http://localhost:5173"
    echo "  后端:  http://localhost:8000"
    echo "  API:   http://localhost:8000/docs"
    echo ""
    echo "  后端日志:  tail -f $PROJECT_DIR/logs/backend.log"
    echo "  前端日志:  tail -f $PROJECT_DIR/logs/frontend.log"
    echo ""
    echo "  停止:  ./dev.sh stop"
    echo ""
}

show_status() {
    echo ""
    log_info "服务状态:"
    echo ""
    
    # 数据库
    if docker ps --filter "name=mumu-postgres-dev" --filter "status=running" | grep -q mumu-postgres-dev; then
        echo "  PostgreSQL    ✅ 运行中 (5432)"
    else
        echo "  PostgreSQL    ❌ 未运行"
    fi
    
    # 后端
    if curl -s http://localhost:8000/health >/dev/null 2>&1; then
        echo "  后端 uvicorn  ✅ 运行中 (8000)"
    else
        echo "  后端 uvicorn  ❌ 未运行"
    fi
    
    # 前端
    if lsof -i:5173 -t >/dev/null 2>&1; then
        echo "  前端 vite    ✅ 运行中 (5173)"
    else
        echo "  前端 vite    ❌ 未运行"
    fi
    echo ""
}

case "${1:-start}" in
    start)
        mkdir -p "$PROJECT_DIR/logs"
        start_dev
        ;;
    stop)
        stop_all
        ;;
    restart)
        stop_all
        sleep 2
        start_dev
        ;;
    status)
        show_status
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
