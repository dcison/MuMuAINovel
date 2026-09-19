"""添加刷新令牌表

Revision ID: b8e9f0a1c2d3
Revises: acdb1d611064
Create Date: 2026-09-19 14:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, use Alembic.
revision: str = 'b8e9f0a1c2d3'
down_revision: Union[str, None] = 'b2c3d4e5f6a7'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table('refresh_tokens',
        sa.Column('id', sa.String(length=36), nullable=False, comment='UUID'),
        sa.Column('user_id', sa.String(length=100), nullable=False, comment='用户ID'),
        sa.Column('token_hash', sa.String(length=128), nullable=False, comment='Token SHA-256 哈希'),
        sa.Column('device_info', sa.String(length=500), nullable=True, comment='设备信息摘要'),
        sa.Column('ip_network', sa.String(length=45), nullable=True, comment='IP网段'),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, comment='创建时间'),
        sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False, comment='过期时间'),
        sa.Column('last_used_at', sa.DateTime(timezone=True), nullable=True, comment='最后使用时间'),
        sa.Column('is_revoked', sa.Boolean(), nullable=False, comment='是否已吊销'),
        sa.Column('replaced_by', sa.String(length=36), nullable=True, comment='被哪个token轮换'),
        sa.PrimaryKeyConstraint('id', name='pk_refresh_tokens'),
        sa.UniqueConstraint('token_hash', name='uq_refresh_tokens_token_hash')
    )
    op.create_index('ix_refresh_tokens_user_id', 'refresh_tokens', ['user_id'])
    op.create_index('ix_refresh_tokens_token_hash', 'refresh_tokens', ['token_hash'])
    op.create_index('ix_refresh_tokens_expires_at', 'refresh_tokens', ['expires_at'])


def downgrade() -> None:
    op.drop_index('ix_refresh_tokens_expires_at', table_name='refresh_tokens')
    op.drop_index('ix_refresh_tokens_token_hash', table_name='refresh_tokens')
    op.drop_index('ix_refresh_tokens_user_id', table_name='refresh_tokens')
    op.drop_table('refresh_tokens')
