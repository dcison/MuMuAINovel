import React from 'react';
import { Checkbox, Button, Space, Empty, theme } from 'antd';

export interface ReferenceItem {
  id: string;
  /** 完整显示文案，例如「第3章：标题 (3000字)」或「[必须回收] 第3章埋入: 标题」 */
  label: string;
}

interface ChapterReferenceSelectorProps {
  /** 控制栏标题，例如「📚 选择参考章节」 */
  title: string;
  /** 列表项 */
  items: ReferenceItem[];
  /** 已勾选的 ID 列表 */
  value: string[];
  /** 勾选变化回调 */
  onChange: (ids: string[]) => void;
  /** 计数单位，例如「章」「伏笔」 */
  unit?: string;
  /** 列表最大高度，超出滚动 */
  maxHeight?: number;
}

/**
 * 章节 / 伏笔 参考选择器（受控 checkbox 列表）
 * 复用为 AI 创作弹窗内的章节/伏笔列表，以及右侧浮动写作上下文面板。
 */
const ChapterReferenceSelector: React.FC<ChapterReferenceSelectorProps> = ({
  title,
  items,
  value,
  onChange,
  unit = '章',
  maxHeight = 180,
}) => {
  const { token } = theme.useToken();
  const total = items.length;
  const allSelected = total > 0 && value.length >= total;

  const handleSelectAll = () => {
    onChange(items.map((item) => item.id));
  };

  const handleClear = () => {
    onChange([]);
  };

  const countText = allSelected
    ? `已全选 ${total} ${unit}`
    : `已选 ${value.length}/${total} ${unit}`;

  return (
    <div
      style={{
        border: `1px solid ${token.colorBorderSecondary}`,
        borderRadius: token.borderRadius,
        background: token.colorFillQuaternary,
        overflow: 'hidden',
      }}
    >
      {/* 控制栏 */}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '8px 12px',
          background: token.colorFillSecondary,
          borderBottom: `1px solid ${token.colorBorderSecondary}`,
        }}
      >
        <span style={{ fontWeight: 600, fontSize: 13 }}>{title}</span>
        <Space size={4}>
          <Button size="small" type="link" onClick={handleSelectAll} disabled={total === 0}>
            全选
          </Button>
          <Button size="small" type="link" onClick={handleClear} disabled={total === 0}>
            取消
          </Button>
        </Space>
      </div>

      {/* 计数 */}
      <div
        style={{
          padding: '4px 12px',
          fontSize: 12,
          color: token.colorTextSecondary,
          textAlign: 'right',
        }}
      >
        {countText}
      </div>

      {/* 列表 */}
      <div style={{ maxHeight, overflowY: 'auto', padding: '4px 12px 12px' }}>
        {items.length === 0 ? (
          <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description="暂无数据" />
        ) : (
          <Checkbox.Group
            value={value}
            onChange={(checkedValues) => onChange(checkedValues as string[])}
            style={{ display: 'flex', flexDirection: 'column', gap: 4 }}
          >
            {items.map((item) => (
              <Checkbox key={item.id} value={item.id} style={{ fontSize: 13 }}>
                {item.label}
              </Checkbox>
            ))}
          </Checkbox.Group>
        )}
      </div>
    </div>
  );
};

export default ChapterReferenceSelector;
