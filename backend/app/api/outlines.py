"""大纲管理API"""
from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, delete
from typing import List, AsyncGenerator, Dict, Any
import json

from app.database import get_db
from app.api.common import verify_project_access
from app.models.outline import Outline
from app.models.project import Project
from app.models.chapter import Chapter
from app.models.character import Character
from app.models.relationship import CharacterRelationship, Organization, OrganizationMember
from app.models.generation_history import GenerationHistory
from app.schemas.outline import (
    OutlineCreate,
    OutlineUpdate,
    OutlineResponse,
    OutlineListResponse,
    OutlineGenerateRequest,
    OutlineExpansionRequest,
    OutlineExpansionResponse,
    BatchOutlineExpansionRequest,
    BatchOutlineExpansionResponse,
    CreateChaptersFromPlansRequest,
    CreateChaptersFromPlansResponse
)
from app.services.ai_service import AIService
from app.services.json_helper import loads_json
from app.services.prompt_service import prompt_service, PromptService
from app.services.memory_service import memory_service
from app.services.plot_expansion_service import PlotExpansionService
from app.services.foreshadow_service import foreshadow_service
from app.services.memory_service import memory_service
from app.logger import get_logger
from app.api.settings import get_user_ai_service
from app.utils.sse_response import SSEResponse, create_sse_response, WizardProgressTracker

router = APIRouter(prefix="/outlines", tags=["大纲管理"])
logger = get_logger(__name__)


def _build_chapters_brief(outlines: List[Outline], max_recent: int = 20) -> str:
    """构建章节概览字符串"""
    target = outlines[-max_recent:] if len(outlines) > max_recent else outlines
    return "\n".join([f"第{o.order_index}章《{o.title}》" for o in target])


def _build_characters_info(characters: List[Character]) -> str:
    """构建角色信息字符串"""
    return "\n".join([
        f"- {char.name} ({'组织' if char.is_organization else '角色'}, {char.role_type}): "
        f"{char.personality[:100] if char.personality else '暂无描述'}"
        for char in characters
    ])


@router.post("", response_model=OutlineResponse, summary="创建大纲")
async def create_outline(
    outline: OutlineCreate,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """创建新的章节大纲（one-to-one模式会自动创建对应章节）"""
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    project = await verify_project_access(outline.project_id, user_id, db)
    
    # 创建大纲
    db_outline = Outline(**outline.model_dump())
    db.add(db_outline)
    await db.flush()  # 确保大纲有ID
    
    # 如果是one-to-one模式，自动创建对应的章节
    if project.outline_mode == 'one-to-one':
        chapter = Chapter(
            project_id=outline.project_id,
            title=db_outline.title,
            summary=db_outline.content,
            chapter_number=db_outline.order_index,
            sub_index=1,
            outline_id=db_outline.id,
            status='pending',
            content=""
        )
        db.add(chapter)
        logger.info(f"一对一模式：为手动创建的大纲 {db_outline.title} (序号{db_outline.order_index}) 自动创建了对应章节")
    
    await db.commit()
    await db.refresh(db_outline)
    return db_outline


@router.get("", response_model=OutlineListResponse, summary="获取大纲列表")
async def get_outlines(
    project_id: str,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """获取指定项目的所有大纲（优化版：后端完全解析structure，构建标准JSON返回）"""
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    await verify_project_access(project_id, user_id, db)
    
    # 获取总数
    count_result = await db.execute(
        select(func.count(Outline.id)).where(Outline.project_id == project_id)
    )
    total = count_result.scalar_one()
    
    # 获取大纲列表
    result = await db.execute(
        select(Outline)
        .where(Outline.project_id == project_id)
        .order_by(Outline.order_index)
    )
    outlines = result.scalars().all()

    # 批量查询是否已展开章节（避免前端 N+1 请求）
    outline_ids = [outline.id for outline in outlines]
    outline_has_chapters_map: Dict[str, bool] = {}
    if outline_ids:
        chapters_count_result = await db.execute(
            select(Chapter.outline_id, func.count(Chapter.id))
            .where(Chapter.outline_id.in_(outline_ids))
            .group_by(Chapter.outline_id)
        )
        outline_has_chapters_map = {
            str(outline_id): count > 0
            for outline_id, count in chapters_count_result.all()
            if outline_id
        }

    # 🔧 优化：后端完全解析structure，提取所有字段填充到outline对象
    for outline in outlines:
        # 动态附加是否已有章节展开状态，供前端直接使用
        setattr(outline, "has_chapters", outline_has_chapters_map.get(outline.id, False))

        if outline.structure:
            try:
                structure_data = json.loads(outline.structure)

                # 从structure中提取所有字段填充到outline对象
                outline.title = structure_data.get("title", f"第{outline.order_index}章")
                outline.content = structure_data.get("summary") or structure_data.get("content", "")

                # structure字段保持不变，供前端使用其他字段（如characters、scenes等）

            except json.JSONDecodeError:
                logger.warning(f"解析大纲 {outline.id} 的structure失败")
                outline.title = f"第{outline.order_index}章"
                outline.content = "解析失败"
        else:
            # 没有structure的异常情况
            outline.title = f"第{outline.order_index}章"
            outline.content = "暂无内容"

    return OutlineListResponse(total=total, items=outlines)


@router.get("/project/{project_id}", response_model=OutlineListResponse, summary="获取项目的所有大纲")
async def get_project_outlines(
    project_id: str,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """获取指定项目的所有大纲（路径参数版本，兼容旧API）"""
    return await get_outlines(project_id, request, db)


@router.get("/{outline_id}", response_model=OutlineResponse, summary="获取大纲详情")
async def get_outline(
    outline_id: str,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """根据ID获取大纲详情"""
    result = await db.execute(
        select(Outline).where(Outline.id == outline_id)
    )
    outline = result.scalar_one_or_none()
    
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")
    
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    await verify_project_access(outline.project_id, user_id, db)
    
    return outline


@router.put("/{outline_id}", response_model=OutlineResponse, summary="更新大纲")
async def update_outline(
    outline_id: str,
    outline_update: OutlineUpdate,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """更新大纲信息并同步更新structure字段和关联章节"""
    result = await db.execute(
        select(Outline).where(Outline.id == outline_id)
    )
    outline = result.scalar_one_or_none()
    
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")
    
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    project = await verify_project_access(outline.project_id, user_id, db)
    
    # 更新字段
    update_data = outline_update.model_dump(exclude_unset=True)
    
    # 🔧 特殊处理：如果直接传递了structure字段，优先使用它
    if 'structure' in update_data:
        # 直接使用前端传递的structure（前端已经处理好了完整的JSON）
        outline.structure = update_data['structure']
        logger.info(f"直接更新大纲 {outline_id} 的structure字段")
        # 从update_data中移除structure，避免后续重复处理
        structure_updated = True
        del update_data['structure']
    else:
        structure_updated = False
    
    # 更新其他字段
    for field, value in update_data.items():
        setattr(outline, field, value)
    
    # 如果没有直接更新structure，但修改了content或title，则同步更新structure字段
    if not structure_updated and ('content' in update_data or 'title' in update_data):
        try:
            # 尝试解析现有的structure
            if outline.structure:
                structure_data = json.loads(outline.structure)
            else:
                structure_data = {}
            
            # 更新structure中的对应字段
            if 'title' in update_data:
                structure_data['title'] = outline.title
            if 'content' in update_data:
                structure_data['summary'] = outline.content
                structure_data['content'] = outline.content
            
            # 保存更新后的structure
            outline.structure = json.dumps(structure_data, ensure_ascii=False)
            logger.info(f"同步更新大纲 {outline_id} 的structure字段")
        except json.JSONDecodeError:
            logger.warning(f"大纲 {outline_id} 的structure字段格式错误，跳过更新")
    
    # 🔧 传统模式（one-to-one）：同步更新关联章节的标题
    if 'title' in update_data and project.outline_mode == 'one-to-one':
        try:
            # 查找对应的章节（通过chapter_number匹配order_index）
            chapter_result = await db.execute(
                select(Chapter).where(
                    Chapter.project_id == outline.project_id,
                    Chapter.chapter_number == outline.order_index
                )
            )
            chapter = chapter_result.scalar_one_or_none()
            
            if chapter:
                # 同步更新章节标题
                chapter.title = outline.title
                logger.info(f"一对一模式：同步更新章节 {chapter.id} 的标题为 '{outline.title}'")
            else:
                logger.debug(f"一对一模式：未找到对应的章节（chapter_number={outline.order_index}）")
        except Exception as e:
            logger.error(f"同步更新章节标题失败: {str(e)}")
            # 不阻断大纲更新流程，仅记录错误
    
    await db.commit()
    await db.refresh(outline)
    return outline


@router.delete("/{outline_id}", summary="删除大纲")
async def delete_outline(
    outline_id: str,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """删除大纲，同时删除该大纲对应的所有章节和相关的伏笔数据"""
    result = await db.execute(
        select(Outline).where(Outline.id == outline_id)
    )
    outline = result.scalar_one_or_none()
    
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")
    
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    project = await verify_project_access(outline.project_id, user_id, db)
    
    project_id = outline.project_id
    deleted_order = outline.order_index
    
    # 获取要删除的章节并计算总字数
    deleted_word_count = 0
    deleted_foreshadow_count = 0
    if project.outline_mode == 'one-to-one':
        # one-to-one模式：通过chapter_number获取对应章节
        chapters_result = await db.execute(
            select(Chapter).where(
                Chapter.project_id == project_id,
                Chapter.chapter_number == outline.order_index
            )
        )
        chapters_to_delete = chapters_result.scalars().all()
        deleted_word_count = sum(ch.word_count or 0 for ch in chapters_to_delete)
        
        # 🔮 清理章节相关的伏笔数据和向量记忆
        for chapter in chapters_to_delete:
            try:
                # 清理向量数据库中的记忆数据
                await memory_service.delete_chapter_memories(
                    user_id=user_id,
                    project_id=project_id,
                    chapter_id=chapter.id
                )
                logger.info(f"✅ 已清理章节 {chapter.id[:8]} 的向量记忆数据")
            except Exception as e:
                logger.warning(f"⚠️ 清理章节 {chapter.id[:8]} 向量记忆失败: {str(e)}")
            
            try:
                # 清理伏笔数据（分析来源的伏笔）
                foreshadow_result = await foreshadow_service.delete_chapter_foreshadows(
                    db=db,
                    project_id=project_id,
                    chapter_id=chapter.id,
                    only_analysis_source=True
                )
                deleted_foreshadow_count += foreshadow_result.get('deleted_count', 0)
                if foreshadow_result.get('deleted_count', 0) > 0:
                    logger.info(f"🔮 已清理章节 {chapter.id[:8]} 的 {foreshadow_result['deleted_count']} 个伏笔数据")
            except Exception as e:
                logger.warning(f"⚠️ 清理章节 {chapter.id[:8]} 伏笔数据失败: {str(e)}")
        
        # 删除章节
        delete_result = await db.execute(
            delete(Chapter).where(
                Chapter.project_id == project_id,
                Chapter.chapter_number == outline.order_index
            )
        )
        deleted_chapters_count = delete_result.rowcount
        logger.info(f"一对一模式：删除大纲 {outline_id}（序号{outline.order_index}），同时删除了第{outline.order_index}章（{deleted_chapters_count}个章节，{deleted_word_count}字，{deleted_foreshadow_count}个伏笔）")
    else:
        # one-to-many模式：通过outline_id获取关联章节
        chapters_result = await db.execute(
            select(Chapter).where(Chapter.outline_id == outline_id)
        )
        chapters_to_delete = chapters_result.scalars().all()
        deleted_word_count = sum(ch.word_count or 0 for ch in chapters_to_delete)
        
        # 🔮 清理章节相关的伏笔数据和向量记忆
        for chapter in chapters_to_delete:
            try:
                # 清理向量数据库中的记忆数据
                await memory_service.delete_chapter_memories(
                    user_id=user_id,
                    project_id=project_id,
                    chapter_id=chapter.id
                )
                logger.info(f"✅ 已清理章节 {chapter.id[:8]} 的向量记忆数据")
            except Exception as e:
                logger.warning(f"⚠️ 清理章节 {chapter.id[:8]} 向量记忆失败: {str(e)}")
            
            try:
                # 清理伏笔数据（分析来源的伏笔）
                foreshadow_result = await foreshadow_service.delete_chapter_foreshadows(
                    db=db,
                    project_id=project_id,
                    chapter_id=chapter.id,
                    only_analysis_source=True
                )
                deleted_foreshadow_count += foreshadow_result.get('deleted_count', 0)
                if foreshadow_result.get('deleted_count', 0) > 0:
                    logger.info(f"🔮 已清理章节 {chapter.id[:8]} 的 {foreshadow_result['deleted_count']} 个伏笔数据")
            except Exception as e:
                logger.warning(f"⚠️ 清理章节 {chapter.id[:8]} 伏笔数据失败: {str(e)}")
        
        # 删除章节
        delete_result = await db.execute(
            delete(Chapter).where(Chapter.outline_id == outline_id)
        )
        deleted_chapters_count = delete_result.rowcount
        logger.info(f"一对多模式：删除大纲 {outline_id}，同时删除了 {deleted_chapters_count} 个关联章节（{deleted_word_count}字，{deleted_foreshadow_count}个伏笔）")
    
    # 更新项目字数
    if deleted_word_count > 0:
        project.current_words = max(0, project.current_words - deleted_word_count)
        logger.info(f"更新项目字数：减少 {deleted_word_count} 字")
    
    # 删除大纲
    await db.delete(outline)
    
    # 重新排序后续的大纲（序号-1）
    result = await db.execute(
        select(Outline).where(
            Outline.project_id == project_id,
            Outline.order_index > deleted_order
        )
    )
    subsequent_outlines = result.scalars().all()
    
    for o in subsequent_outlines:
        o.order_index -= 1
    
    # 如果是one-to-one模式，还需要重新排序后续章节的chapter_number
    if project.outline_mode == 'one-to-one':
        chapters_result = await db.execute(
            select(Chapter).where(
                Chapter.project_id == project_id,
                Chapter.chapter_number > deleted_order
            ).order_by(Chapter.chapter_number)
        )
        subsequent_chapters = chapters_result.scalars().all()
        
        for ch in subsequent_chapters:
            ch.chapter_number -= 1
        
        logger.info(f"一对一模式：重新排序了 {len(subsequent_chapters)} 个后续章节")
    
    await db.commit()
    
    return {
        "message": "大纲删除成功",
        "deleted_chapters": deleted_chapters_count,
        "deleted_foreshadows": deleted_foreshadow_count
    }




async def _build_outline_continue_context(
    project: Project,
    latest_outlines: List[Outline],
    characters: List[Character],
    chapter_count: int,
    plot_stage: str,
    story_direction: str,
    requirements: str,
    db: AsyncSession
) -> dict:
    """
    构建卷纲续写上下文（简化版）
    
    包含内容：
    1. 项目基础信息：title, theme, genre, world_time_period, world_location,
       world_atmosphere, world_rules, narrative_perspective
    2. 最近10个卷纲的完整大纲structure（解析JSON转化为文本）
    3. 所有角色的全部信息
    4. 用户输入：chapter_count（本批次卷数）, plot_stage, story_direction, requirements
    
    Args:
        project: 项目对象
        latest_outlines: 所有已有卷纲列表
        characters: 所有角色列表
        chapter_count: 本批次要生成的卷数
        plot_stage: 情节阶段
        story_direction: 故事发展方向
        requirements: 其他要求
        
    Returns:
        包含上下文信息的字典
    """
    context = {
        'project_info': '',
        'recent_outlines': '',
        'characters_info': '',
        'user_input': '',
        'stats': {
            'total_outlines': len(latest_outlines),
            'recent_outlines_count': 0,
            'characters_count': len(characters)
        }
    }
    
    try:
        # 1. 项目基础信息
        project_info_parts = [
            f"【项目基础信息】",
            f"标题：{project.title}",
            f"主题：{project.theme or '未设定'}",
            f"类型：{project.genre or '未设定'}",
            f"时代背景：{project.world_time_period or '未设定'}",
            f"地点设定：{project.world_location or '未设定'}",
            f"氛围基调：{project.world_atmosphere or '未设定'}",
            f"世界规则：{project.world_rules or '未设定'}",
            f"叙事视角：{project.narrative_perspective or '第三人称'}"
        ]
        context['project_info'] = "\n".join(project_info_parts)
        
        # 2. 最近10章的完整大纲structure（解析JSON转化为文本）
        recent_count = min(10, len(latest_outlines))
        if recent_count > 0:
            recent_outlines = latest_outlines[-recent_count:]
            context['stats']['recent_outlines_count'] = recent_count
            
            outline_texts = []
            outline_texts.append(f"【最近{recent_count}卷大纲详情】")
            
            for outline in recent_outlines:
                outline_text = f"\n第{outline.order_index}卷《{outline.title}》"
                
                # 尝试解析structure字段
                if outline.structure:
                    try:
                        structure_data = json.loads(outline.structure)
                        
                        # 提取各个字段（使用实际存储的字段名）
                        if structure_data.get('summary'):
                            outline_text += f"\n  概要：{structure_data['summary']}"
                        
                        # key_points 对应 关键事件
                        if structure_data.get('key_points'):
                            events = structure_data['key_points']
                            if isinstance(events, list):
                                outline_text += f"\n  关键事件：{', '.join(events)}"
                            else:
                                outline_text += f"\n  关键事件：{events}"
                        
                        # characters 对应 重点角色/组织（兼容新旧格式）
                        if structure_data.get('characters'):
                            chars = structure_data['characters']
                            if isinstance(chars, list):
                                # 新格式：[{"name": "xxx", "type": "character"/"organization"}]
                                # 旧格式：["角色名1", "角色名2"]
                                char_names = []
                                org_names = []
                                for c in chars:
                                    if isinstance(c, dict):
                                        name = c.get('name', '')
                                        if c.get('type') == 'organization':
                                            org_names.append(name)
                                        else:
                                            char_names.append(name)
                                    elif isinstance(c, str):
                                        char_names.append(c)
                                if char_names:
                                    outline_text += f"\n  重点角色：{', '.join(char_names)}"
                                if org_names:
                                    outline_text += f"\n  涉及组织：{', '.join(org_names)}"
                            else:
                                outline_text += f"\n  重点角色：{chars}"
                        
                        # emotion 对应 情感基调
                        if structure_data.get('emotion'):
                            outline_text += f"\n  情感基调：{structure_data['emotion']}"
                        
                        # goal 对应 叙事目标
                        if structure_data.get('goal'):
                            outline_text += f"\n  叙事目标：{structure_data['goal']}"
                        
                        # scenes 场景信息（可选显示）
                        if structure_data.get('scenes'):
                            scenes = structure_data['scenes']
                            if isinstance(scenes, list) and scenes:
                                outline_text += f"\n  场景：{', '.join(scenes)}"
                            
                    except json.JSONDecodeError:
                        # 如果解析失败，使用content字段
                        outline_text += f"\n  内容：{outline.content}"
                else:
                    # 没有structure，使用content
                    outline_text += f"\n  内容：{outline.content}"
                
                outline_texts.append(outline_text)
            
            context['recent_outlines'] = "\n".join(outline_texts)
            logger.info(f"  ✅ 最近大纲：{recent_count}章")
        
        # 3. 所有角色的全部信息(包括职业信息)
        if characters:
            from app.models.career import Career, CharacterCareer
            
            char_texts = []
            char_texts.append("【角色信息】")
            
            for char in characters:
                char_text = f"\n{char.name}（{'组织' if char.is_organization else '角色'}，{char.role_type}）"
                
                if char.personality:
                    char_text += f"\n  性格特点：{char.personality}"
                
                if char.background:
                    char_text += f"\n  背景故事：{char.background}"
                
                if char.appearance:
                    char_text += f"\n  外貌描述：{char.appearance}"
                
                if char.traits:
                    char_text += f"\n  特征标签：{char.traits}"
                
                # 从 character_relationships 表查询关系
                from sqlalchemy import or_
                rels_result = await db.execute(
                    select(CharacterRelationship).where(
                        CharacterRelationship.project_id == project.id,
                        or_(
                            CharacterRelationship.character_from_id == char.id,
                            CharacterRelationship.character_to_id == char.id
                        )
                    )
                )
                rels = rels_result.scalars().all()
                if rels:
                    # 收集相关角色名称
                    related_ids = set()
                    for r in rels:
                        related_ids.add(r.character_from_id)
                        related_ids.add(r.character_to_id)
                    related_ids.discard(char.id)
                    if related_ids:
                        names_result = await db.execute(
                            select(Character.id, Character.name).where(Character.id.in_(related_ids))
                        )
                        name_map = {row.id: row.name for row in names_result}
                        rel_parts = []
                        for r in rels:
                            if r.character_from_id == char.id:
                                target_name = name_map.get(r.character_to_id, "未知")
                            else:
                                target_name = name_map.get(r.character_from_id, "未知")
                            rel_name = r.relationship_name or "相关"
                            rel_parts.append(f"与{target_name}：{rel_name}")
                        char_text += f"\n  关系网络：{'；'.join(rel_parts)}"
                
                # 组织特有字段
                if char.is_organization:
                    if char.organization_type:
                        char_text += f"\n  组织类型：{char.organization_type}"
                    if char.organization_purpose:
                        char_text += f"\n  组织宗旨：{char.organization_purpose}"
                    # 从 OrganizationMember 表动态查询组织成员
                    org_result = await db.execute(
                        select(Organization).where(Organization.character_id == char.id)
                    )
                    org = org_result.scalar_one_or_none()
                    if org:
                        members_result = await db.execute(
                            select(OrganizationMember, Character.name).join(
                                Character, OrganizationMember.character_id == Character.id
                            ).where(OrganizationMember.organization_id == org.id)
                        )
                        members = members_result.all()
                        if members:
                            member_parts = [f"{name}（{m.position}）" for m, name in members]
                            char_text += f"\n  组织成员：{'、'.join(member_parts)}"
                
                # 查询角色的职业信息
                if not char.is_organization:
                    try:
                        career_result = await db.execute(
                            select(Career, CharacterCareer)
                            .join(CharacterCareer, Career.id == CharacterCareer.career_id)
                            .where(CharacterCareer.character_id == char.id)
                        )
                        career_data = career_result.first()
                        
                        if career_data:
                            career, char_career = career_data
                            char_text += f"\n  职业：{career.name}"
                            if char_career.current_stage:
                                char_text += f"（{char_career.current_stage}阶段）"
                            if char_career.career_type:
                                char_text += f"\n  职业类型：{char_career.career_type}"
                    except Exception as e:
                        logger.warning(f"查询角色 {char.name} 的职业信息失败: {str(e)}")
                
                char_texts.append(char_text)
            
            context['characters_info'] = "\n".join(char_texts)
            logger.info(f"  ✅ 角色信息：{len(characters)}个角色")
        else:
            context['characters_info'] = "【角色信息】\n暂无角色信息"
        
        # 4. 用户输入
        user_input_parts = [
            "【用户输入】",
            f"要生成卷数：{chapter_count}卷",
            f"情节阶段：{plot_stage}",
            f"故事发展方向：{story_direction}",
        ]
        if requirements:
            user_input_parts.append(f"其他要求：{requirements}")
        
        context['user_input'] = "\n".join(user_input_parts)
        
        # 计算总长度
        total_length = sum([
            len(context['project_info']),
            len(context['recent_outlines']),
            len(context['characters_info']),
            len(context['user_input'])
        ])
        context['stats']['total_length'] = total_length
        logger.info(f"📊 大纲续写上下文总长度: {total_length} 字符")
        
    except Exception as e:
        logger.error(f"❌ 构建大纲续写上下文失败: {str(e)}", exc_info=True)
    
    return context


async def _check_and_create_missing_characters_from_outlines(
    outline_data: list,
    project_id: str,
    db: AsyncSession,
    user_ai_service: AIService,
    user_id: str = None,
    enable_mcp: bool = True,
    tracker = None
) -> dict:
    """
    大纲生成/续写后，校验structure中的characters是否存在对应角色，
    不存在的自动根据大纲摘要生成角色信息。
    
    Args:
        outline_data: 大纲数据列表（原始JSON解析后的数据，包含characters、summary等字段）
        project_id: 项目ID
        db: 数据库会话
        user_ai_service: AI服务实例
        user_id: 用户ID
        enable_mcp: 是否启用MCP
        tracker: 可选，WizardProgressTracker用于发送进度
        
    Returns:
        {"created_count": int, "created_characters": list}
    """
    try:
        from app.services.auto_character_service import get_auto_character_service
        
        auto_char_service = get_auto_character_service(user_ai_service)
        
        # 定义进度回调
        async def progress_cb(message: str):
            if tracker:
                # 注意：这里不能直接yield，需要通过其他方式处理
                logger.info(f"  📌 {message}")
        
        result = await auto_char_service.check_and_create_missing_characters(
            project_id=project_id,
            outline_data_list=outline_data,
            db=db,
            user_id=user_id,
            enable_mcp=enable_mcp,
            progress_callback=progress_cb
        )
        
        if result["created_count"] > 0:
            logger.info(
                f"🎭 【角色校验完成】自动创建了 {result['created_count']} 个缺失角色: "
                f"{', '.join(c.name for c in result['created_characters'])}"
            )
        
        return result
        
    except Exception as e:
        logger.error(f"⚠️ 【角色校验】校验失败（不影响主流程）: {e}", exc_info=True)
        return {"created_count": 0, "created_characters": []}


async def _check_and_create_missing_organizations_from_outlines(
    outline_data: list,
    project_id: str,
    db: AsyncSession,
    user_ai_service: AIService,
    user_id: str = None,
    enable_mcp: bool = True,
    tracker = None
) -> dict:
    """
    大纲生成/续写后，校验structure中的characters（type=organization）是否存在对应组织，
    不存在的自动根据大纲摘要生成组织信息。
    
    Args:
        outline_data: 大纲数据列表（原始JSON解析后的数据，包含characters、summary等字段）
        project_id: 项目ID
        db: 数据库会话
        user_ai_service: AI服务实例
        user_id: 用户ID
        enable_mcp: 是否启用MCP
        tracker: 可选，WizardProgressTracker用于发送进度
        
    Returns:
        {"created_count": int, "created_organizations": list}
    """
    try:
        from app.services.auto_organization_service import get_auto_organization_service
        
        auto_org_service = get_auto_organization_service(user_ai_service)
        
        # 定义进度回调
        async def progress_cb(message: str):
            if tracker:
                logger.info(f"  📌 {message}")
        
        result = await auto_org_service.check_and_create_missing_organizations(
            project_id=project_id,
            outline_data_list=outline_data,
            db=db,
            user_id=user_id,
            enable_mcp=enable_mcp,
            progress_callback=progress_cb
        )
        
        if result["created_count"] > 0:
            logger.info(
                f"🏛️ 【组织校验完成】自动创建了 {result['created_count']} 个缺失组织: "
                f"{', '.join(c.name for c in result['created_organizations'])}"
            )
        
        return result
        
    except Exception as e:
        logger.error(f"⚠️ 【组织校验】校验失败（不影响主流程）: {e}", exc_info=True)
        return {"created_count": 0, "created_organizations": []}


class JSONParseError(Exception):
    """JSON解析失败异常，用于触发重试"""
    def __init__(self, message: str, original_content: str = ""):
        super().__init__(message)
        self.original_content = original_content


def _build_retry_prompt(original_prompt: str, partial_output: str, retry_count: int, max_retries: int, item_type: str = "卷纲") -> str:
    """
    构建重试提示词，包含之前生成的部分内容，让模型继续完成。

    Args:
        original_prompt: 原始提示词（未使用，保留参数以兼容调用方）
        partial_output: 上次生成的部分内容
        retry_count: 当前重试次数
        max_retries: 最大重试次数
        item_type: 生成项类型（用于提示文案）

    Returns:
        包含上下文的重试提示词
    """
    # 截取最后部分作为上下文（避免 prompt 过长）
    context_tail = partial_output[-2000:] if len(partial_output) > 2000 else partial_output

    # 使用简洁的重试提示，避免 prompt 过长导致上下文超限
    # 不包含原始 prompt，只提供续写指令和部分输出
    retry_instruction = (
        f"【重试 {retry_count}/{max_retries}】上次生成的内容不完整或格式有误。\n"
        f"以下是上次生成的部分内容，请在此基础上继续完成，确保返回完整的JSON数组：\n\n"
        f"```json\n{context_tail}\n```\n\n"
        f"请从上次中断的位置继续，补全剩余的{item_type}对象，确保：\n"
        f"1. 返回完整的JSON数组（包含所有对象）\n"
        f"2. 每个对象包含完整的title、summary等必要字段\n"
        f"3. 不要重复已生成的内容，直接从断点处继续"
    )

    return retry_instruction


def _normalize_character_entries(raw_characters: Any) -> list:
    """标准化大纲 characters 字段，兼容旧字符串格式。"""
    if not isinstance(raw_characters, list):
        return []

    normalized = []
    seen = set()
    org_keywords = ("宗", "门", "派", "阁", "会", "帮", "盟", "国", "军", "司", "院", "族", "府", "殿", "教", "堂", "队", "集团", "组织", "势力")

    for item in raw_characters:
        if isinstance(item, dict):
            name = str(item.get("name") or "").strip()
            item_type = str(item.get("type") or "character").strip().lower()
        else:
            name = str(item or "").strip()
            item_type = "organization" if any(keyword in name for keyword in org_keywords) else "character"

        if not name:
            continue
        if item_type not in {"character", "organization"}:
            item_type = "character"

        key = (name, item_type)
        if key in seen:
            continue
        seen.add(key)
        normalized.append({"name": name, "type": item_type})

    return normalized


def _normalize_outline_data(outline_data: list, expected_count: int, start_index: int) -> list:
    """校验并标准化 AI 返回的大纲数据。"""
    if not isinstance(outline_data, list):
        raise JSONParseError("大纲数据必须是数组", json.dumps(outline_data, ensure_ascii=False, default=str))

    if expected_count is not None and len(outline_data) != expected_count:
        raise JSONParseError(f"大纲数量不匹配：期望{expected_count}章，实际{len(outline_data)}章", json.dumps(outline_data, ensure_ascii=False, default=str))

    normalized = []
    for idx, chapter_data in enumerate(outline_data):
        if not isinstance(chapter_data, dict):
            raise JSONParseError(f"第{idx + 1}项不是有效对象", json.dumps(outline_data, ensure_ascii=False, default=str))

        chapter_number = start_index + idx
        title = str(chapter_data.get("title") or f"第{chapter_number}章").strip()
        summary = str(chapter_data.get("summary") or chapter_data.get("content") or "").strip()
        if not summary:
            raise JSONParseError(f"第{chapter_number}章缺少 summary/content", json.dumps(chapter_data, ensure_ascii=False, default=str))

        scenes = chapter_data.get("scenes")
        if not isinstance(scenes, list):
            scenes = []
        key_points = chapter_data.get("key_points")
        if not isinstance(key_points, list):
            key_points = []

        normalized_chapter = dict(chapter_data)
        normalized_chapter["chapter_number"] = chapter_number
        normalized_chapter["title"] = title
        normalized_chapter["summary"] = summary
        normalized_chapter["scenes"] = [str(scene).strip() for scene in scenes if str(scene).strip()]
        normalized_chapter["characters"] = _normalize_character_entries(chapter_data.get("characters", []))
        normalized_chapter["key_points"] = [str(point).strip() for point in key_points if str(point).strip()]
        normalized_chapter["emotion"] = str(chapter_data.get("emotion") or chapter_data.get("emotional_tone") or "未设定").strip()
        normalized_chapter["goal"] = str(chapter_data.get("goal") or chapter_data.get("narrative_goal") or "未设定").strip()
        normalized.append(normalized_chapter)

    return normalized


def _parse_ai_response(ai_response: str, raise_on_error: bool = False) -> list:
    """
    解析AI响应为章节数据列表（使用统一的JSON清洗方法）
    
    Args:
        ai_response: AI返回的原始文本
        raise_on_error: 如果为True，解析失败时抛出异常而不是返回fallback数据
        
    Returns:
        解析后的章节数据列表
        
    Raises:
        JSONParseError: 当raise_on_error=True且解析失败时抛出
    """
    try:
        # 使用统一的JSON清洗方法（从AIService导入）
        from app.services.ai_service import AIService
        ai_service_temp = AIService()
        cleaned_text = ai_service_temp._clean_json_response(ai_response)
        
        outline_data = loads_json(cleaned_text)
        
        # 确保是列表格式
        if not isinstance(outline_data, list):
            # 如果是对象，尝试提取chapters字段
            if isinstance(outline_data, dict):
                outline_data = outline_data.get("chapters", [outline_data])
            else:
                outline_data = [outline_data]
        
        # 验证解析结果是否有效（至少有一个有效章节）
        valid_chapters = [
            ch for ch in outline_data
            if isinstance(ch, dict) and (ch.get("title") or ch.get("summary") or ch.get("content"))
        ]
        
        if not valid_chapters:
            error_msg = "解析结果无效：未找到有效的章节数据"
            logger.error(f"❌ {error_msg}")
            if raise_on_error:
                raise JSONParseError(error_msg, ai_response)
            return [{
                "title": "AI生成的大纲",
                "content": ai_response[:1000],
                "summary": ai_response[:1000]
            }]
        
        logger.info(f"✅ 成功解析 {len(valid_chapters)} 个章节数据")
        return valid_chapters
        
    except json.JSONDecodeError as e:
        error_msg = f"JSON解析失败: {e}"
        logger.error(f"❌ AI响应解析失败: {e}")
        
        if raise_on_error:
            raise JSONParseError(error_msg, ai_response)
        
        # 返回一个包含原始内容的章节
        return [{
            "title": "AI生成的大纲",
            "content": ai_response[:1000],
            "summary": ai_response[:1000]
        }]
    except JSONParseError:
        # 重新抛出JSONParseError
        raise
    except Exception as e:
        error_msg = f"解析异常: {str(e)}"
        logger.error(f"❌ {error_msg}")
        
        if raise_on_error:
            raise JSONParseError(error_msg, ai_response)
        
        return [{
            "title": "解析异常的大纲",
            "content": "系统错误",
            "summary": "系统错误"
        }]


async def _save_outlines(
    project_id: str,
    outline_data: list,
    db: AsyncSession,
    start_index: int = 1
) -> List[Outline]:
    """
    保存大纲到数据库（修复版：从structure中提取title和content保存到数据库）
    
    如果项目为one-to-one模式，同时自动创建对应的章节
    """
    # 获取项目信息以确定outline_mode
    project_result = await db.execute(
        select(Project).where(Project.id == project_id)
    )
    project = project_result.scalar_one_or_none()
    
    outlines = []
    outline_data = _normalize_outline_data(outline_data, expected_count=len(outline_data), start_index=start_index)
    
    for idx, chapter_data in enumerate(outline_data):
        order_idx = chapter_data.get("chapter_number", start_index + idx)
        
        # 🔧 修复：从structure中提取title和summary/content保存到数据库
        chapter_title = chapter_data.get("title", f"第{order_idx}章")
        chapter_content = chapter_data.get("summary") or chapter_data.get("content", "")
        
        outline = Outline(
            project_id=project_id,
            title=chapter_title,  # 从JSON中提取title
            content=chapter_content,  # 从JSON中提取summary或content
            structure=json.dumps(chapter_data, ensure_ascii=False),
            order_index=order_idx
        )
        db.add(outline)
        outlines.append(outline)
    
    # 如果是one-to-one模式，自动创建章节
    if project and project.outline_mode == 'one-to-one':
        await db.flush()  # 确保大纲有ID
        
        for outline in outlines:
            await db.refresh(outline)
            
            # 🔧 从structure中提取title和summary用于创建章节
            try:
                structure_data = json.loads(outline.structure) if outline.structure else {}
                chapter_title = structure_data.get("title", f"第{outline.order_index}章")
                chapter_summary = structure_data.get("summary") or structure_data.get("content", "")
            except json.JSONDecodeError:
                logger.warning(f"解析大纲 {outline.id} 的structure失败，使用默认值")
                chapter_title = f"第{outline.order_index}章"
                chapter_summary = ""
            
            # 为每个大纲创建对应的章节
            chapter = Chapter(
                project_id=project_id,
                title=chapter_title,
                summary=chapter_summary,
                chapter_number=outline.order_index,
                sub_index=1,
                outline_id=outline.id,
                status='pending',
                content=""
            )
            db.add(chapter)
        
        logger.info(f"一对一模式：为{len(outlines)}个大纲自动创建了对应的章节")
    
    return outlines


async def new_outline_generator(
    data: Dict[str, Any],
    db: AsyncSession,
    user_ai_service: AIService
) -> AsyncGenerator[str, None]:
    """全新生成大纲SSE生成器（两步走：先概要后详细）"""
    db_committed = False
    tracker = WizardProgressTracker("大纲")
    
    try:
        yield await tracker.start()
        
        project_id = data.get("project_id")
        volume_count = int(data.get("volume_count", 10))
        enable_mcp = data.get("enable_mcp", True)
        
        # 验证项目
        yield await tracker.loading("加载项目信息...", 0.2)
        result = await db.execute(
            select(Project).where(Project.id == project_id)
        )
        project = result.scalar_one_or_none()
        if not project:
            yield await tracker.error("项目不存在", 404)
            return
        
        # 获取总目标字数
        target_words = int(data.get("target_words") or project.target_words or 100000)
        
        yield await tracker.loading(f"准备生成{volume_count}个卷纲...", 0.3)
        
        # 获取角色信息
        characters_result = await db.execute(
            select(Character).where(Character.project_id == project_id)
        )
        characters = characters_result.scalars().all()
        characters_info = _build_characters_info(characters)
        
        # 设置用户信息以启用MCP
        user_id_for_mcp = data.get("user_id")
        if user_id_for_mcp:
            user_ai_service.user_id = user_id_for_mcp
            user_ai_service.db_session = db
        
        # 清理旧数据
        yield await tracker.saving("清理旧数据...", 0.4)
        from sqlalchemy import delete as sql_delete
        await db.execute(sql_delete(Outline).where(Outline.project_id == project_id))
        await db.flush()
        
        # ========== 第1步：生成卷纲概要 ==========
        yield await tracker.preparing("第1步：生成卷纲概要...")
        
        template = await PromptService.get_template("OUTLINE_CREATE", user_id_for_mcp, db)
        prompt = PromptService.format_prompt(
            template,
            title=project.title,
            theme=data.get("theme") or project.theme or "未设定",
            genre=data.get("genre") or project.genre or "通用",
            volume_count=volume_count,
            target_words=target_words,
            narrative_perspective=data.get("narrative_perspective") or "第三人称",
            time_period=project.world_time_period or "未设定",
            location=project.world_location or "未设定",
            atmosphere=project.world_atmosphere or "未设定",
            rules=project.world_rules or "未设定",
            characters_info=characters_info or "暂无角色信息",
            requirements=data.get("requirements") or "",
            mcp_references=""
        )
        
        # 生成概要
        accumulated_text = ""
        async for chunk in user_ai_service.generate_text_stream(
            prompt=prompt,
            provider=data.get("provider"),
            model=data.get("model"),
            auto_mcp=enable_mcp,
            max_tokens=max(8000, volume_count * 1000)
        ):
            accumulated_text += chunk
            yield await tracker.generating_chunk(chunk)
        
        # 解析概要
        yield await tracker.parsing("解析卷纲概要...")
        try:
            summary_data = _parse_ai_response(accumulated_text, raise_on_error=True)
            if not isinstance(summary_data, list) or len(summary_data) == 0:
                raise ValueError("解析结果为空或格式错误")
        except (JSONParseError, ValueError, Exception) as e:
            logger.error(f"❌ 卷纲概要解析失败: {e}")
            yield await tracker.error(f"卷纲概要生成失败: {e}")
            return
        
        # 保存概要到数据库
        yield await tracker.saving("保存卷纲概要...")
        summary_outlines = _normalize_outline_data(summary_data, expected_count=volume_count, start_index=1)
        outlines = []
        for idx, vol_data in enumerate(summary_outlines):
            outline = Outline(
                project_id=project_id,
                title=vol_data.get("title", f"第{idx+1}卷"),
                content=vol_data.get("summary", ""),
                structure=json.dumps(vol_data, ensure_ascii=False),
                order_index=vol_data.get("volume_number", idx + 1)
            )
            db.add(outline)
            outlines.append(outline)
        
        await db.flush()
        for outline in outlines:
            await db.refresh(outline)
        
        yield await tracker.saving(f"✅ 已生成 {len(outlines)} 个卷纲概要", 0.5)
        
        # ========== 第2步：逐卷展开详细内容 ==========
        expand_template = await PromptService.get_template("OUTLINE_EXPAND_VOLUME", user_id_for_mcp, db)
        
        for vol_idx, outline in enumerate(outlines):
            progress = 0.5 + (vol_idx / len(outlines)) * 0.4
            yield await tracker.generating(
                message=f"第2步：展开第{vol_idx+1}/{len(outlines)}卷详细内容...",
            )
            
            # 获取上下文（上一卷和下一卷的概要）
            prev_summary = summary_outlines[vol_idx - 1].get("summary", "无") if vol_idx > 0 else "无（这是第一卷）"
            next_summary = summary_outlines[vol_idx + 1].get("summary", "无") if vol_idx < len(summary_outlines) - 1 else "无（这是最后一卷）"
            
            vol_data = summary_outlines[vol_idx]
            
            expand_prompt = PromptService.format_prompt(
                expand_template,
                title=project.title,
                theme=data.get("theme") or project.theme or "未设定",
                genre=data.get("genre") or project.genre or "通用",
                narrative_perspective=data.get("narrative_perspective") or "第三人称",
                time_period=project.world_time_period or "未设定",
                location=project.world_location or "未设定",
                atmosphere=project.world_atmosphere or "未设定",
                rules=project.world_rules or "未设定",
                characters_info=characters_info or "暂无角色信息",
                volume_number=vol_data.get("volume_number", vol_idx + 1),
                volume_title=vol_data.get("title", f"第{vol_idx+1}卷"),
                phase=vol_data.get("phase", ""),
                volume_summary=vol_data.get("summary", ""),
                estimated_words=vol_data.get("estimated_words", 0),
                narrative_goal=vol_data.get("narrative_goal", ""),
                previous_volume_summary=prev_summary,
                next_volume_summary=next_summary,
                mcp_references=""
            )
            
            # 生成详细内容
            vol_accumulated = ""
            async for chunk in user_ai_service.generate_text_stream(
                prompt=expand_prompt,
                provider=data.get("provider"),
                model=data.get("model"),
                auto_mcp=enable_mcp,
                max_tokens=8000
            ):
                vol_accumulated += chunk
            
            # 解析详细内容
            try:
                detail_data = loads_json(user_ai_service._clean_json_response(vol_accumulated))
                if not isinstance(detail_data, dict):
                    raise ValueError("返回格式错误")
                
                # 更新 outline
                outline.title = detail_data.get("title", outline.title)
                outline.content = detail_data.get("summary", vol_data.get("summary", ""))
                outline.structure = json.dumps(detail_data, ensure_ascii=False)
                
            except (json.JSONDecodeError, ValueError) as e:
                logger.warning(f"⚠️ 第{vol_idx+1}卷详细展开失败，保留概要: {e}")
                # 保留概要数据，不阻塞整体流程
            
            await db.flush()
            await db.refresh(outline)
        
        # 角色校验
        yield await tracker.saving("🎭 校验角色信息...", 0.9)
        try:
            all_structure_data = [json.loads(o.structure) if o.structure else {} for o in outlines]
            merged_data = []
            for s in all_structure_data:
                if isinstance(s, dict):
                    merged_data.append(s)
            await _check_and_create_missing_characters_from_outlines(
                outline_data=merged_data,
                project_id=project_id,
                db=db,
                user_ai_service=user_ai_service,
                user_id=data.get("user_id"),
                enable_mcp=enable_mcp,
                tracker=tracker
            )
        except Exception as e:
            logger.warning(f"⚠️ 角色校验失败（不影响主流程）: {e}")
        
        # 提交事务
        await db.commit()
        db_committed = True
        
        for outline in outlines:
            await db.refresh(outline)
        
        logger.info(f"✅ 两步走大纲生成完成：{len(outlines)} 卷")
        
        yield await tracker.complete()
        yield await tracker.result({
            "message": f"成功生成{len(outlines)}卷大纲（两步走：概要+详细展开）",
            "total_volumes": len(outlines),
            "outlines": [
                {
                    "id": o.id,
                    "project_id": o.project_id,
                    "title": o.title,
                    "content": o.content[:200] + "..." if len(o.content) > 200 else o.content,
                    "order_index": o.order_index,
                    "structure": o.structure,
                    "created_at": o.created_at.isoformat() if o.created_at else None,
                    "updated_at": o.updated_at.isoformat() if o.updated_at else None
                } for o in outlines
            ]
        })
        yield await tracker.done()
        
    except GeneratorExit:
        logger.warning("大纲生成器被提前关闭")
        if not db_committed and db.in_transaction():
            await db.rollback()
    except Exception as e:
        logger.error(f"大纲生成失败: {str(e)}", exc_info=True)
        if not db_committed and db.in_transaction():
            await db.rollback()
        yield await tracker.error(f"生成失败: {str(e)}")


async def continue_outline_generator(
    data: Dict[str, Any],
    db: AsyncSession,
    user_ai_service: AIService,
    user_id: str = "system"
) -> AsyncGenerator[str, None]:
    """大纲续写SSE生成器（逐卷生成）"""
    db_committed = False
    tracker = WizardProgressTracker("大纲续写")
    
    try:
        yield await tracker.start("开始续写大纲...")
        
        project_id = data.get("project_id")
        total_volumes_to_generate = int(data.get("volume_count", 5))
        
        # 验证项目
        yield await tracker.loading("加载项目信息...", 0.2)
        result = await db.execute(
            select(Project).where(Project.id == project_id)
        )
        project = result.scalar_one_or_none()
        if not project:
            yield await tracker.error("项目不存在", 404)
            return
        
        # 获取现有大纲
        yield await tracker.loading("分析已有大纲...", 0.3)
        existing_result = await db.execute(
            select(Outline)
            .where(Outline.project_id == project_id)
            .order_by(Outline.order_index)
        )
        existing_outlines = existing_result.scalars().all()
        
        if not existing_outlines:
            yield await tracker.error("续写模式需要已有大纲，当前项目没有大纲", 400)
            return
        
        last_volume_number = existing_outlines[-1].order_index
        current_volume_count = len(existing_outlines)
        
        yield await tracker.loading(
            f"当前已有{current_volume_count}卷，将续写{total_volumes_to_generate}卷",
            0.4
        )
        
        # 获取角色信息
        characters_result = await db.execute(
            select(Character).where(Character.project_id == project_id)
        )
        characters = characters_result.scalars().all()
        characters_info = _build_characters_info(characters)
        
        # 设置用户信息以启用MCP
        if user_id:
            user_ai_service.user_id = user_id
            user_ai_service.db_session = db
        
        # 获取伏笔提醒
        foreshadow_reminders_text = "暂无需要关注的伏笔"
        try:
            foreshadow_context = await foreshadow_service.build_chapter_context(
                db=db,
                project_id=project_id,
                chapter_number=last_volume_number + 1,
                include_pending=False,
                include_overdue=True,
                lookahead=10
            )
            if foreshadow_context and foreshadow_context.get("context_text"):
                foreshadow_reminders_text = foreshadow_context["context_text"]
        except Exception:
            pass
        
        # 逐卷生成
        expand_template = await PromptService.get_template("OUTLINE_EXPAND_VOLUME", user_id, db)
        all_new_outlines = []
        current_start_volume = last_volume_number + 1
        
        # 获取现有大纲的概要用于上下文
        existing_summaries = []
        for o in existing_outlines:
            existing_summaries.append(o.content or o.title)
        
        for vol_idx in range(total_volumes_to_generate):
            progress = 0.4 + (vol_idx / total_volumes_to_generate) * 0.5
            yield await tracker.generating(
                message=f"📝 生成第{current_start_volume + vol_idx}卷（{vol_idx+1}/{total_volumes_to_generate}）..."
            )
            
            # 构建上下文
            # 上一卷概要：如果有现有大纲且是第一卷续写，用最后一个现有大纲；否则用上一卷生成的
            if vol_idx == 0 and existing_summaries:
                prev_summary = existing_summaries[-1]
            elif vol_idx > 0:
                prev_summary = all_new_outlines[-1].content if all_new_outlines else "无"
            else:
                prev_summary = "无（这是第一卷）"
            
            next_summary = "无（这是最后一卷）"  # 续写时不知道下一卷
            
            # 构建卷标题和阶段信息
            vol_number = current_start_volume + vol_idx
            vol_title = f"第{vol_number}卷"
            
            # 根据情节阶段确定phase
            stage_instructions = {
                "development": "发展",
                "climax": "高潮",
                "ending": "结局"
            }
            phase = stage_instructions.get(data.get("plot_stage", "development"), "发展")
            
            # 构建简化的volume_summary（基于故事方向）
            story_direction = data.get("story_direction", "自然延续")
            volume_summary = f"本卷接续前一卷剧情，发展方向：{story_direction}"
            
            expand_prompt = PromptService.format_prompt(
                expand_template,
                title=project.title,
                theme=project.theme or "未设定",
                genre=project.genre or "通用",
                narrative_perspective=project.narrative_perspective or "第三人称",
                time_period=project.world_time_period or "未设定",
                location=project.world_location or "未设定",
                atmosphere=project.world_atmosphere or "未设定",
                rules=project.world_rules or "未设定",
                characters_info=characters_info or "暂无角色信息",
                volume_number=vol_number,
                volume_title=vol_title,
                phase=phase,
                volume_summary=volume_summary,
                estimated_words=20000,
                narrative_goal=story_direction,
                previous_volume_summary=prev_summary,
                next_volume_summary=next_summary,
                mcp_references=""
            )
            
            # 生成详细内容
            vol_accumulated = ""
            async for chunk in user_ai_service.generate_text_stream(
                prompt=expand_prompt,
                provider=data.get("provider"),
                model=data.get("model"),
                auto_mcp=data.get("enable_mcp", True),
                max_tokens=8000
            ):
                vol_accumulated += chunk
                yield await tracker.generating_chunk(chunk)
            
            # 解析
            try:
                detail_data = loads_json(user_ai_service._clean_json_response(vol_accumulated))
                if not isinstance(detail_data, dict):
                    raise ValueError("返回格式错误")
                
                outline = Outline(
                    project_id=project_id,
                    title=detail_data.get("title", f"第{vol_number}卷"),
                    content=detail_data.get("summary", ""),
                    structure=json.dumps(detail_data, ensure_ascii=False),
                    order_index=vol_number
                )
                db.add(outline)
                await db.flush()
                await db.refresh(outline)
                all_new_outlines.append(outline)
                
            except (json.JSONDecodeError, ValueError) as e:
                logger.warning(f"⚠️ 第{vol_number}卷生成失败: {e}，使用fallback")
                outline = Outline(
                    project_id=project_id,
                    title=f"第{vol_number}卷",
                    content=volume_summary,
                    structure=json.dumps({"title": f"第{vol_number}卷", "summary": volume_summary}, ensure_ascii=False),
                    order_index=vol_number
                )
                db.add(outline)
                await db.flush()
                await db.refresh(outline)
                all_new_outlines.append(outline)
        
        # 提交
        await db.commit()
        db_committed = True
        
        logger.info(f"✅ 续写完成：新增{len(all_new_outlines)}卷")
        
        yield await tracker.complete()
        yield await tracker.result({
            "message": f"续写完成！新增{len(all_new_outlines)}卷",
            "new_volumes": len(all_new_outlines),
            "total_volumes": current_volume_count + len(all_new_outlines),
            "outlines": [
                {
                    "id": o.id,
                    "title": o.title,
                    "content": o.content[:100] + "..." if len(o.content) > 100 else o.content,
                    "order_index": o.order_index
                } for o in all_new_outlines
            ]
        })
        yield await tracker.done()
        
    except GeneratorExit:
        logger.warning("大纲续写生成器被提前关闭")
        if not db_committed and db.in_transaction():
            await db.rollback()
    except Exception as e:
        logger.error(f"大纲续写失败: {str(e)}", exc_info=True)
        if not db_committed and db.in_transaction():
            await db.rollback()
        yield await tracker.error(f"续写失败: {str(e)}")


@router.post("/generate", summary="AI生成/续写大纲(后台任务)")
async def generate_outline_task(
    data: Dict[str, Any],
    request: Request,
    db: AsyncSession = Depends(get_db),
    user_ai_service: AIService = Depends(get_user_ai_service)
):
    """
    使用后台任务生成或续写小说大纲（不怕断连，关闭浏览器也继续运行）
    
    返回task_id，前端通过 GET /api/tasks/{task_id} 轮询进度
    
    支持模式：
    - auto/new/continue（同 generate-stream）
    """
    from app.services.background_task_service import background_task_service, TaskProgressTracker
    from app.database import get_engine
    from sqlalchemy.ext.asyncio import async_sessionmaker, AsyncSession as NewAsyncSession

    user_id = getattr(request.state, 'user_id', None)
    project = await verify_project_access(data.get("project_id"), user_id, db)

    # 判断模式
    mode = data.get("mode", "auto")
    existing_result = await db.execute(
        select(Outline)
        .where(Outline.project_id == data.get("project_id"))
        .order_by(Outline.order_index)
    )
    existing_outlines = existing_result.scalars().all()

    if mode == "auto":
        mode = "continue" if existing_outlines else "new"

    data["user_id"] = user_id
    data["mode"] = mode

    if mode == "continue" and not existing_outlines:
        raise HTTPException(status_code=400, detail="续写模式需要已有大纲")

    # 创建后台任务
    task_type = "outline_new" if mode == "new" else "outline_continue"
    task = await background_task_service.create_task(
        user_id=user_id,
        project_id=data.get("project_id"),
        task_type=task_type,
        task_input=data,
        db=db
    )

    # 后台执行的函数
    async def _run_outline_generation(task_id: str, user_id: str):
        engine = await get_engine(user_id)
        AsyncSessionLocal = async_sessionmaker(engine, class_=NewAsyncSession, expire_on_commit=False)
        
        async with AsyncSessionLocal() as bg_db:
            tracker = TaskProgressTracker(task_id, user_id, "大纲")
            try:
                await tracker.start()
                
                # 获取AI服务（需要在后台创建新实例）
                from app.api.settings import get_user_ai_service_from_db
                bg_ai_service = await get_user_ai_service_from_db(user_id, bg_db)
                
                if mode == "new":
                    await _run_new_outline_bg(data, bg_db, bg_ai_service, tracker)
                else:
                    await _run_continue_outline_bg(data, bg_db, bg_ai_service, tracker, user_id)
                    
            except Exception as e:
                logger.error(f"❌ 后台大纲生成失败: {e}", exc_info=True)
                await tracker.error(str(e))

    await background_task_service.spawn_background_task(
        task.id, user_id, _run_outline_generation
    )

    return {
        "task_id": task.id,
        "task_type": task_type,
        "status": "pending",
        "message": "任务已创建，请通过 GET /api/tasks/{task_id} 查询进度"
    }


async def _run_new_outline_bg(
    data: Dict[str, Any],
    db: AsyncSession,
    user_ai_service: AIService,
    tracker
):
    """后台执行全新大纲生成（两步走：先概要后详细）"""
    project_id = data.get("project_id")
    volume_count = int(data.get("volume_count", 10))
    user_id_for_mcp = data.get("user_id")
    enable_mcp = data.get("enable_mcp", True)

    await tracker.loading("加载项目信息...", 0.2)
    result = await db.execute(select(Project).where(Project.id == project_id))
    project = result.scalar_one_or_none()
    if not project:
        await tracker.error("项目不存在")
        return

    target_words = int(data.get("target_words") or project.target_words or 100000)

    await tracker.loading(f"准备生成{volume_count}个卷纲...", 0.3)
    characters_result = await db.execute(select(Character).where(Character.project_id == project_id))
    characters = characters_result.scalars().all()
    characters_info = _build_characters_info(characters)

    if user_id_for_mcp:
        user_ai_service.user_id = user_id_for_mcp
        user_ai_service.db_session = db

    # 清理旧数据
    await tracker.saving("清理旧数据...", 0.4)
    from sqlalchemy import delete as sql_delete
    from app.models.memory import PlotAnalysis, StoryMemory
    old_chapters_result = await db.execute(select(Chapter).where(Chapter.project_id == project_id))
    old_chapters = old_chapters_result.scalars().all()
    old_chapter_ids = [ch.id for ch in old_chapters]
    deleted_word_count = sum(ch.word_count or 0 for ch in old_chapters)
    for ch in old_chapters:
        try:
            await memory_service.delete_chapter_memories(
                user_id=user_id_for_mcp, project_id=project_id, chapter_id=ch.id
            )
        except Exception:
            pass
    try:
        await foreshadow_service.clear_project_foreshadows_for_reset(db, project_id)
    except Exception:
        pass
    await db.execute(sql_delete(PlotAnalysis).where(PlotAnalysis.project_id == project_id))
    await db.execute(sql_delete(StoryMemory).where(StoryMemory.project_id == project_id))
    await db.execute(sql_delete(Chapter).where(Chapter.project_id == project_id))
    await db.execute(sql_delete(Outline).where(Outline.project_id == project_id))
    if deleted_word_count > 0:
        project.current_words = max(0, (project.current_words or 0) - deleted_word_count)
    logger.info(f"✅ 旧数据清理完成")

    # ========== 第1步：生成卷纲概要 ==========
    await tracker.preparing("第1步：生成卷纲概要...")

    template = await PromptService.get_template("OUTLINE_CREATE", user_id_for_mcp, db)
    prompt = PromptService.format_prompt(
        template,
        title=project.title,
        theme=data.get("theme") or project.theme or "未设定",
        genre=data.get("genre") or project.genre or "通用",
        volume_count=volume_count,
        target_words=target_words,
        narrative_perspective=data.get("narrative_perspective") or "第三人称",
        time_period=project.world_time_period or "未设定",
        location=project.world_location or "未设定",
        atmosphere=project.world_atmosphere or "未设定",
        rules=project.world_rules or "未设定",
        characters_info=characters_info or "暂无角色信息",
        requirements=data.get("requirements") or "",
        mcp_references=""
    )

    accumulated_text = ""
    async for chunk in user_ai_service.generate_text_stream(
        prompt=prompt,
        provider=data.get("provider"),
        model=data.get("model"),
        auto_mcp=enable_mcp,
        max_tokens=max(8000, volume_count * 1000)
    ):
        accumulated_text += chunk

    await tracker.parsing("解析卷纲概要...")
    try:
        summary_data = _parse_ai_response(accumulated_text, raise_on_error=True)
        if not isinstance(summary_data, list) or len(summary_data) == 0:
            raise ValueError("解析结果为空或格式错误")
    except (JSONParseError, ValueError) as e:
        await tracker.error(f"卷纲概要生成失败: {e}")
        return

    # 保存概要
    summary_outlines = _normalize_outline_data(summary_data, expected_count=volume_count, start_index=1)
    outlines = []
    for idx, vol_data in enumerate(summary_outlines):
        outline = Outline(
            project_id=project_id,
            title=vol_data.get("title", f"第{idx+1}卷"),
            content=vol_data.get("summary", ""),
            structure=json.dumps(vol_data, ensure_ascii=False),
            order_index=vol_data.get("volume_number", idx + 1)
        )
        db.add(outline)
        outlines.append(outline)

    await db.flush()
    for outline in outlines:
        await db.refresh(outline)

    await tracker.saving(f"✅ 已生成 {len(outlines)} 个卷纲概要", 0.5)

    # ========== 第2步：逐卷展开详细内容 ==========
    expand_template = await PromptService.get_template("OUTLINE_EXPAND_VOLUME", user_id_for_mcp, db)

    for vol_idx, outline in enumerate(outlines):
        if await tracker.check_cancelled():
            await tracker.error("任务已取消")
            return

        progress = 0.5 + (vol_idx / len(outlines)) * 0.35
        await tracker.generating(
            message=f"第2步：展开第{vol_idx+1}/{len(outlines)}卷详细内容..."
        )

        prev_summary = summary_outlines[vol_idx - 1].get("summary", "无") if vol_idx > 0 else "无（这是第一卷）"
        next_summary = summary_outlines[vol_idx + 1].get("summary", "无") if vol_idx < len(summary_outlines) - 1 else "无（这是最后一卷）"

        vol_data = summary_outlines[vol_idx]

        expand_prompt = PromptService.format_prompt(
            expand_template,
            title=project.title,
            theme=data.get("theme") or project.theme or "未设定",
            genre=data.get("genre") or project.genre or "通用",
            narrative_perspective=data.get("narrative_perspective") or "第三人称",
            time_period=project.world_time_period or "未设定",
            location=project.world_location or "未设定",
            atmosphere=project.world_atmosphere or "未设定",
            rules=project.world_rules or "未设定",
            characters_info=characters_info or "暂无角色信息",
            volume_number=vol_data.get("volume_number", vol_idx + 1),
            volume_title=vol_data.get("title", f"第{vol_idx+1}卷"),
            phase=vol_data.get("phase", ""),
            volume_summary=vol_data.get("summary", ""),
            estimated_words=vol_data.get("estimated_words", 0),
            narrative_goal=vol_data.get("narrative_goal", ""),
            previous_volume_summary=prev_summary,
            next_volume_summary=next_summary,
            mcp_references=""
        )

        vol_accumulated = ""
        async for chunk in user_ai_service.generate_text_stream(
            prompt=expand_prompt,
            provider=data.get("provider"),
            model=data.get("model"),
            auto_mcp=enable_mcp,
            max_tokens=8000
        ):
            vol_accumulated += chunk

        try:
            detail_data = loads_json(user_ai_service._clean_json_response(vol_accumulated))
            if isinstance(detail_data, dict):
                outline.title = detail_data.get("title", outline.title)
                outline.content = detail_data.get("summary", vol_data.get("summary", ""))
                outline.structure = json.dumps(detail_data, ensure_ascii=False)
        except (json.JSONDecodeError, ValueError) as e:
            logger.warning(f"⚠️ 第{vol_idx+1}卷详细展开失败，保留概要: {e}")

        await db.flush()
        await db.refresh(outline)

    # 角色校验
    await tracker.saving("🎭 校验角色信息...", 0.9)
    try:
        all_structure_data = [json.loads(o.structure) if o.structure else {} for o in outlines]
        merged_data = [s for s in all_structure_data if isinstance(s, dict)]
        await _check_and_create_missing_characters_from_outlines(
            outline_data=merged_data,
            project_id=project_id,
            db=db,
            user_ai_service=user_ai_service,
            user_id=data.get("user_id"),
            enable_mcp=enable_mcp,
            tracker=tracker
        )
    except Exception:
        pass

    await db.commit()

    result_data = {
        "message": f"成功生成{len(outlines)}卷大纲（两步走：概要+详细展开）",
        "total_volumes": len(outlines),
        "outline_ids": [o.id for o in outlines]
    }

    # 更新任务结果
    from app.models.background_task import BackgroundTask
    task_result = await db.execute(select(BackgroundTask).where(BackgroundTask.id == tracker.task_id))
    bg_task = task_result.scalar_one_or_none()
    if bg_task:
        bg_task.task_result = result_data
        await db.commit()

    await tracker.complete(f"成功生成{len(outlines)}卷大纲")
    logger.info(f"✅ 后台两步走大纲生成完成: {len(outlines)} 卷")


async def _run_continue_outline_bg(
    data: Dict[str, Any],
    db: AsyncSession,
    user_ai_service: AIService,
    tracker,
    user_id: str
):
    """后台执行大纲续写（逐卷生成）"""
    project_id = data.get("project_id")
    total_volumes = int(data.get("volume_count", 5))
    enable_mcp = data.get("enable_mcp", True)

    await tracker.loading("加载项目信息...", 0.2)
    result = await db.execute(select(Project).where(Project.id == project_id))
    project = result.scalar_one_or_none()
    if not project:
        await tracker.error("项目不存在")
        return

    existing_result = await db.execute(
        select(Outline).where(Outline.project_id == project_id).order_by(Outline.order_index)
    )
    existing_outlines = existing_result.scalars().all()
    if not existing_outlines:
        await tracker.error("续写模式需要已有大纲")
        return

    last_volume_number = existing_outlines[-1].order_index
    current_volume_count = len(existing_outlines)

    characters_result = await db.execute(select(Character).where(Character.project_id == project_id))
    characters = characters_result.scalars().all()
    characters_info = _build_characters_info(characters)

    if user_id:
        user_ai_service.user_id = user_id
        user_ai_service.db_session = db

    # 获取伏笔提醒
    foreshadow_reminders_text = "暂无需要关注的伏笔"
    try:
        foreshadow_context = await foreshadow_service.build_chapter_context(
            db=db, project_id=project_id, chapter_number=last_volume_number + 1,
            include_pending=False, include_overdue=True, lookahead=10
        )
        if foreshadow_context and foreshadow_context.get("context_text"):
            foreshadow_reminders_text = foreshadow_context["context_text"]
    except Exception:
        pass

    # 逐卷生成
    expand_template = await PromptService.get_template("OUTLINE_EXPAND_VOLUME", user_id, db)
    all_new_outlines = []
    current_start_volume = last_volume_number + 1

    existing_summaries = [o.content or o.title for o in existing_outlines]

    for vol_idx in range(total_volumes):
        if await tracker.check_cancelled():
            await tracker.error("任务已取消")
            return

        progress = 0.4 + (vol_idx / total_volumes) * 0.5
        await tracker.generating(
            message=f"📝 生成第{current_start_volume + vol_idx}卷（{vol_idx+1}/{total_volumes}）..."
        )

        if vol_idx == 0 and existing_summaries:
            prev_summary = existing_summaries[-1]
        elif vol_idx > 0:
            prev_summary = all_new_outlines[-1].content if all_new_outlines else "无"
        else:
            prev_summary = "无（这是第一卷）"

        next_summary = "无（这是最后一卷）"
        vol_number = current_start_volume + vol_idx
        vol_title = f"第{vol_number}卷"

        stage_instructions = {"development": "发展", "climax": "高潮", "ending": "结局"}
        phase = stage_instructions.get(data.get("plot_stage", "development"), "发展")
        story_direction = data.get("story_direction", "自然延续")
        volume_summary = f"本卷接续前一卷剧情，发展方向：{story_direction}"

        expand_prompt = PromptService.format_prompt(
            expand_template,
            title=project.title, theme=project.theme or "未设定",
            genre=project.genre or "通用",
            narrative_perspective=project.narrative_perspective or "第三人称",
            time_period=project.world_time_period or "未设定",
            location=project.world_location or "未设定",
            atmosphere=project.world_atmosphere or "未设定",
            rules=project.world_rules or "未设定",
            characters_info=characters_info or "暂无角色信息",
            volume_number=vol_number, volume_title=vol_title, phase=phase,
            volume_summary=volume_summary, estimated_words=20000,
            narrative_goal=story_direction,
            previous_volume_summary=prev_summary, next_volume_summary=next_summary,
            mcp_references=""
        )

        vol_accumulated = ""
        async for chunk in user_ai_service.generate_text_stream(
            prompt=expand_prompt,
            provider=data.get("provider"), model=data.get("model"),
            auto_mcp=enable_mcp, max_tokens=8000
        ):
            vol_accumulated += chunk

        try:
            detail_data = loads_json(user_ai_service._clean_json_response(vol_accumulated))
            if not isinstance(detail_data, dict):
                raise ValueError("返回格式错误")
            outline = Outline(
                project_id=project_id,
                title=detail_data.get("title", f"第{vol_number}卷"),
                content=detail_data.get("summary", ""),
                structure=json.dumps(detail_data, ensure_ascii=False),
                order_index=vol_number
            )
        except (json.JSONDecodeError, ValueError) as e:
            logger.warning(f"⚠️ 第{vol_number}卷生成失败: {e}，使用fallback")
            outline = Outline(
                project_id=project_id,
                title=f"第{vol_number}卷",
                content=volume_summary,
                structure=json.dumps({"title": f"第{vol_number}卷", "summary": volume_summary}, ensure_ascii=False),
                order_index=vol_number
            )

        db.add(outline)
        await db.flush()
        await db.refresh(outline)
        all_new_outlines.append(outline)

    await db.commit()

    result_data = {
        "message": f"续写完成！新增{len(all_new_outlines)}卷",
        "new_volumes": len(all_new_outlines),
        "total_volumes": current_volume_count + len(all_new_outlines),
        "outline_ids": [o.id for o in all_new_outlines]
    }

    from app.models.background_task import BackgroundTask
    task_result = await db.execute(select(BackgroundTask).where(BackgroundTask.id == tracker.task_id))
    bg_task = task_result.scalar_one_or_none()
    if bg_task:
        bg_task.task_result = result_data
        await db.commit()

    await tracker.complete(f"续写完成！新增{len(all_new_outlines)}卷")
    logger.info(f"✅ 后台续写完成: 新增{len(all_new_outlines)}卷")



@router.post("/{outline_id}/regenerate", summary="AI重新生成单卷大纲(后台任务)")
async def regenerate_outline_task(
    outline_id: str,
    data: Dict[str, Any],
    request: Request,
    db: AsyncSession = Depends(get_db),
    user_ai_service: AIService = Depends(get_user_ai_service)
):
    """
    基于当前卷纲字段和项目全局信息，AI重新生成单卷大纲(后台任务)
    """
    from app.services.background_task_service import background_task_service, TaskProgressTracker
    from app.database import get_engine
    from sqlalchemy.ext.asyncio import async_sessionmaker, AsyncSession as NewAsyncSession
    from app.api.settings import get_user_ai_service_from_db

    user_id = getattr(request.state, 'user_id', None)

    result = await db.execute(select(Outline).where(Outline.id == outline_id))
    outline = result.scalar_one_or_none()
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")

    await verify_project_access(outline.project_id, user_id, db)

    task = await background_task_service.create_task(
        user_id=user_id,
        project_id=outline.project_id,
        task_type="outline_regenerate",
        task_input={"outline_id": outline_id, "data": data, "user_id": user_id},
        db=db
    )

    async def _run_regenerate(task_id: str, user_id: str):
        engine = await get_engine(user_id)
        AsyncSessionLocal = async_sessionmaker(engine, class_=NewAsyncSession, expire_on_commit=False)
        async with AsyncSessionLocal() as bg_db:
            tracker = TaskProgressTracker(task_id, user_id, "卷纲")
            try:
                bg_ai = await get_user_ai_service_from_db(user_id, bg_db)
                await _run_single_volume_regenerate(
                    outline_id=outline_id, data=data, db=bg_db,
                    user_ai_service=bg_ai, tracker=tracker, user_id=user_id
                )
            except Exception as e:
                logger.error(f"卷纲重新生成失败: {e}", exc_info=True)
                await tracker.error(str(e))

    await background_task_service.spawn_background_task(task.id, user_id, _run_regenerate)
    return {"task_id": task.id, "task_type": "outline_regenerate", "status": "pending", "message": "重新生成任务已创建"}


async def _run_single_volume_regenerate(
    outline_id: str,
    data: Dict[str, Any],
    db: AsyncSession,
    user_ai_service: AIService,
    tracker,
    user_id: str
):
    """执行单卷大纲重新生成"""
    await tracker.loading("加载项目信息...", 0.1)

    result = await db.execute(select(Outline).where(Outline.id == outline_id))
    outline = result.scalar_one_or_none()
    if not outline:
        await tracker.error("大纲不存在")
        return

    project_id = outline.project_id

    result = await db.execute(select(Project).where(Project.id == project_id))
    project = result.scalar_one_or_none()
    if not project:
        await tracker.error("项目不存在")
        return

    await tracker.loading("加载角色信息...", 0.2)
    characters_result = await db.execute(
        select(Character).where(Character.project_id == project_id)
    )
    characters = characters_result.scalars().all()
    characters_info = _build_characters_info(characters)

    await tracker.loading("分析上下文...", 0.3)
    outlines_result = await db.execute(
        select(Outline)
        .where(Outline.project_id == project_id)
        .order_by(Outline.order_index)
    )
    all_outlines = outlines_result.scalars().all()

    current_idx = next((i for i, o in enumerate(all_outlines) if o.id == outline_id), -1)
    prev_summary = all_outlines[current_idx - 1].content if current_idx > 0 else "无（这是第一卷）"
    next_summary = all_outlines[current_idx + 1].content if current_idx < len(all_outlines) - 1 else "无（这是最后一卷）"

    if user_id:
        user_ai_service.user_id = user_id
        user_ai_service.db_session = db

    await tracker.preparing("准备AI重新生成...", 0.4)

    current_title = data.get("title", outline.title)
    current_content = data.get("content", outline.content)
    current_characters = data.get("characters", [])
    current_organizations = data.get("organizations", [])
    current_scenes = data.get("scenes", [])
    current_key_points = data.get("key_points", [])
    current_emotion = data.get("emotion", "")
    current_goal = data.get("goal", "")

    current_characters_str = "、".join(current_characters) if current_characters else "无"
    current_organizations_str = "、".join(current_organizations) if current_organizations else "无"
    current_scenes_str = "\n".join(current_scenes) if current_scenes else "无"
    current_key_points_str = "\n".join(current_key_points) if current_key_points else "无"

    template = await PromptService.get_template("OUTLINE_REGENERATE_VOLUME", user_id, db)
    prompt = PromptService.format_prompt(
        template,
        title=project.title,
        theme=project.theme or "未设定",
        genre=project.genre or "通用",
        narrative_perspective=project.narrative_perspective or "第三人称",
        time_period=project.world_time_period or "未设定",
        location=project.world_location or "未设定",
        atmosphere=project.world_atmosphere or "未设定",
        rules=project.world_rules or "未设定",
        climate=project.world_climate or "未设定",
        clothing=project.world_clothing or "未设定",
        characters_info=characters_info or "暂无角色信息",
        volume_number=outline.order_index,
        volume_title=current_title,
        current_summary=current_content,
        current_emotion=current_emotion or "未设定",
        current_goal=current_goal or "未设定",
        current_characters=current_characters_str,
        current_organizations=current_organizations_str,
        current_scenes=current_scenes_str,
        current_key_points=current_key_points_str,
        estimated_words=20000,
        previous_volume_summary=prev_summary,
        next_volume_summary=next_summary,
        mcp_references=""
    )

    await tracker.generating("AI正在重新生成卷纲...", 0.5)

    vol_accumulated = ""
    async for chunk in user_ai_service.generate_text_stream(
        prompt=prompt,
        provider=data.get("provider"),
        model=data.get("model"),
        auto_mcp=True,
        max_tokens=8000
    ):
        vol_accumulated += chunk

    await tracker.parsing("解析生成结果...", 0.8)

    try:
        detail_data = loads_json(user_ai_service._clean_json_response(vol_accumulated))
        if not isinstance(detail_data, dict):
            raise ValueError("返回格式错误")

        outline.title = detail_data.get("title", current_title)
        outline.content = detail_data.get("summary", current_content)

        structure_data = {
            "volume_number": detail_data.get("volume_number", outline.order_index),
            "title": detail_data.get("title", current_title),
            "phase": detail_data.get("phase", ""),
            "summary": detail_data.get("summary", ""),
            "key_points": detail_data.get("key_points", []),
            "characters": [{"name": c, "type": "character"} for c in detail_data.get("characters", [])],
            "organizations": [{"name": o, "type": "organization"} for o in detail_data.get("organizations", [])],
            "scenes": detail_data.get("scenes", []),
            "emotion": detail_data.get("emotion", ""),
            "goal": detail_data.get("goal", ""),
            "narrative_goal": detail_data.get("narrative_goal", ""),
            "estimated_words": detail_data.get("estimated_words", 20000),
        }
        outline.structure = json.dumps(structure_data, ensure_ascii=False)

        await db.commit()
        await db.refresh(outline)

        await tracker.complete("卷纲重新生成完成！")
        logger.info(f"卷纲重新生成完成: {outline.title}")

    except (json.JSONDecodeError, ValueError) as e:
        logger.warning(f"卷纲重新生成解析失败: {e}")
        await tracker.error(f"解析失败: {e}")


async def expand_outline_to_chapters_stream(
    outline_id: str,
    data: Dict[str, Any],
    request: Request,
    db: AsyncSession = Depends(get_db),
    user_ai_service: AIService = Depends(get_user_ai_service)
):
    """
    使用SSE流式展开单个大纲，实时推送进度
    
    请求体示例：
    {
        "target_chapter_count": 3,  // 目标章节数
        "expansion_strategy": "balanced",  // balanced/climax/detail
        "auto_create_chapters": false,  // 是否自动创建章节
        "enable_scene_analysis": true,  // 是否启用场景分析
        "provider": "openai",  // 可选
        "model": "gpt-4"  // 可选
    }
    
    进度阶段：
    - 5% - 开始展开
    - 10% - 加载大纲信息
    - 15% - 加载项目信息
    - 20% - 准备展开参数
    - 30% - AI分析大纲（耗时）
    - 70% - 规划生成完成
    - 80% - 创建章节记录（如果auto_create_chapters=True）
    - 90% - 创建完成
    - 95% - 整理结果数据
    - 100% - 全部完成
    """
    # 获取大纲并验证权限
    result = await db.execute(
        select(Outline).where(Outline.id == outline_id)
    )
    outline = result.scalar_one_or_none()
    
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")
    
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    await verify_project_access(outline.project_id, user_id, db)
    
    return create_sse_response(expand_outline_generator(outline_id, data, db, user_ai_service))


@router.get("/{outline_id}/chapters", summary="获取大纲关联的章节")
async def get_outline_chapters(
    outline_id: str,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """
    获取指定大纲已展开的章节列表
    
    用于检查大纲是否已经展开过,如果有则返回章节信息
    """
    # 获取大纲
    result = await db.execute(
        select(Outline).where(Outline.id == outline_id)
    )
    outline = result.scalar_one_or_none()
    
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")
    
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    await verify_project_access(outline.project_id, user_id, db)
    
    # 查询该大纲关联的章节
    chapters_result = await db.execute(
        select(Chapter)
        .where(Chapter.outline_id == outline_id)
        .order_by(Chapter.sub_index)
    )
    chapters = chapters_result.scalars().all()
    
    # 如果有章节,解析展开规划
    expansion_plans = []
    if chapters:
        for chapter in chapters:
            plan_data = None
            if chapter.expansion_plan:
                try:
                    plan_data = json.loads(chapter.expansion_plan)
                except json.JSONDecodeError:
                    logger.warning(f"章节 {chapter.id} 的expansion_plan解析失败")
                    plan_data = None
            
            def _ensure_list(val):
                """确保字段为 list，AI 偶尔会返回字符串而非数组"""
                if isinstance(val, list):
                    return val
                if isinstance(val, str) and val.strip():
                    return [s.strip() for s in val.replace('、', '，').split('，') if s.strip()]
                return []

            expansion_plans.append({
                "sub_index": chapter.sub_index,
                "title": chapter.title,
                "plot_summary": chapter.summary or "",
                "key_events": _ensure_list(plan_data.get("key_events")) if plan_data else [],
                "character_focus": _ensure_list(plan_data.get("character_focus")) if plan_data else [],
                "emotional_tone": plan_data.get("emotional_tone", "") if plan_data else "",
                "narrative_goal": plan_data.get("narrative_goal", "") if plan_data else "",
                "conflict_type": plan_data.get("conflict_type", "") if plan_data else "",
                "estimated_words": plan_data.get("estimated_words", 0) if plan_data else 0,
                "scenes": plan_data.get("scenes") if plan_data else None
            })
    
    return {
        "has_chapters": len(chapters) > 0,
        "outline_id": outline_id,
        "outline_title": outline.title,
        "chapter_count": len(chapters),
        "chapters": [
            {
                "id": ch.id,
                "chapter_number": ch.chapter_number,
                "title": ch.title,
                "summary": ch.summary,
                "sub_index": ch.sub_index,
                "status": ch.status,
                "word_count": ch.word_count
            }
            for ch in chapters
        ],
        "expansion_plans": expansion_plans if expansion_plans else None
    }


async def batch_expand_outlines_generator(
    data: Dict[str, Any],
    db: AsyncSession,
    user_ai_service: AIService
) -> AsyncGenerator[str, None]:
    """批量展开大纲SSE生成器 - 实时推送进度"""
    db_committed = False
    # 初始化标准进度追踪器
    tracker = WizardProgressTracker("批量大纲展开")
    
    try:
        yield await tracker.start()
        
        project_id = data.get("project_id")
        chapters_per_outline = int(data.get("chapters_per_outline", 3))
        expansion_strategy = data.get("expansion_strategy", "balanced")
        auto_create_chapters = data.get("auto_create_chapters", False)
        outline_ids = data.get("outline_ids")
        
        # 获取项目信息
        yield await tracker.loading("加载项目信息...", 0.5)
        project_result = await db.execute(
            select(Project).where(Project.id == project_id)
        )
        project = project_result.scalar_one_or_none()
        if not project:
            yield await tracker.error("项目不存在", 404)
            return
        
        # 获取要展开的大纲列表
        yield await tracker.loading("获取大纲列表...", 0.8)
        if outline_ids:
            outlines_result = await db.execute(
                select(Outline)
                .where(
                    Outline.project_id == project_id,
                    Outline.id.in_(outline_ids)
                )
                .order_by(Outline.order_index)
            )
        else:
            outlines_result = await db.execute(
                select(Outline)
                .where(Outline.project_id == project_id)
                .order_by(Outline.order_index)
            )
        
        outlines = outlines_result.scalars().all()
        
        if not outlines:
            yield await tracker.error("没有找到要展开的大纲", 404)
            return
        
        total_outlines = len(outlines)
        yield await tracker.preparing(
            f"共找到 {total_outlines} 个大纲，开始批量展开..."
        )
        
        # 创建展开服务实例
        expansion_service = PlotExpansionService(user_ai_service)
        
        expansion_results = []
        total_chapters_created = 0
        skipped_outlines = []
        
        for idx, outline in enumerate(outlines):
            try:
                # 计算当前子进度 (0.0-1.0)，用于generating阶段
                sub_progress = idx / max(total_outlines, 1)
                
                yield await tracker.generating(
                    current_chars=idx * chapters_per_outline * 500,
                    estimated_total=total_outlines * chapters_per_outline * 500,
                    message=f"📝 处理第 {idx + 1}/{total_outlines} 个大纲: {outline.title}"
                )
                
                # 检查大纲是否已经展开过
                existing_chapters_result = await db.execute(
                    select(Chapter)
                    .where(Chapter.outline_id == outline.id)
                    .limit(1)
                )
                existing_chapter = existing_chapters_result.scalar_one_or_none()
                
                if existing_chapter:
                    logger.info(f"大纲 {outline.title} (ID: {outline.id}) 已经展开过，跳过")
                    skipped_outlines.append({
                        "outline_id": outline.id,
                        "outline_title": outline.title,
                        "reason": "已展开"
                    })
                    yield await tracker.generating(
                        current_chars=(idx + 1) * chapters_per_outline * 500,
                        estimated_total=total_outlines * chapters_per_outline * 500,
                        message=f"⏭️ {outline.title} 已展开过，跳过"
                    )
                    continue
                
                # 分析大纲生成章节规划（逐批入库 + 末尾一次性重排序）
                all_chapter_plans = []
                created_chapters = []
                
                async def _on_batch_progress(batch_plans, start_index, total_generated, total_target):
                    """每批生成完成后立即入库（不重排序）"""
                    all_chapter_plans.extend(batch_plans)
                    # 逐章报告进度
                    for i, plan in enumerate(batch_plans):
                        chapter_number = start_index + i
                        plan_title = plan.get("title", f"第{chapter_number}节")
                        await tracker.generating(
                            current_chars=(idx * chapters_per_outline + total_generated - len(batch_plans) + i + 1) * 500,
                            estimated_total=total_outlines * chapters_per_outline * 500,
                            message=f"💾 第 {chapter_number} 章《{plan_title}》已保存 ({total_generated}/{total_target})"
                        )
                    # 逐批立即入库（跳过重排序，最后统一做）
                    if auto_create_chapters and batch_plans:
                        try:
                            chapters = await expansion_service.create_chapters_from_plans(
                                outline_id=outline.id,
                                chapter_plans=batch_plans,
                                project_id=outline.project_id,
                                db=db,
                                start_chapter_number=None,
                                no_renumber=True
                            )
                            for ch in chapters:
                                created_chapters.append({
                                    "id": ch.id,
                                    "chapter_number": ch.chapter_number,
                                    "title": ch.title,
                                    "summary": ch.summary,
                                    "outline_id": ch.outline_id,
                                    "sub_index": ch.sub_index,
                                    "status": ch.status
                                })
                            total_chapters_created += len(chapters)
                        except Exception as save_err:
                            logger.error(f"第 {start_index}-{start_index + len(batch_plans) - 1} 批入库失败: {save_err}", exc_info=True)
                
                await tracker.generating(
                    current_chars=idx * chapters_per_outline * 500,
                    estimated_total=total_outlines * chapters_per_outline * 500,
                    message=f"🤖 AI分析大纲: {outline.title}（{chapters_per_outline} 章）"
                )
                
                await expansion_service.analyze_outline_for_chapters(
                    outline=outline,
                    project=project,
                    db=db,
                    target_chapter_count=chapters_per_outline,
                    expansion_strategy=expansion_strategy,
                    enable_scene_analysis=data.get("enable_scene_analysis", True),
                    provider=data.get("provider"),
                    model=data.get("model"),
                    on_batch_complete=_on_batch_progress
                )
                
                chapter_plans = all_chapter_plans
                
                # 所有批次入库完成后，统一做一次重排序
                if auto_create_chapters and created_chapters:
                    await tracker.generating(
                        current_chars=(idx + 0.85) * chapters_per_outline * 500,
                        estimated_total=total_outlines * chapters_per_outline * 500,
                        message=f"🔄 {outline.title} 正在统一排序..."
                    )
                    await expansion_service._renumber_subsequent_chapters(
                        project_id=outline.project_id,
                        current_outline_id=outline.id,
                        db=db
                    )
                save_status = f"，已入库 {len(created_chapters)} 章" if auto_create_chapters and created_chapters else "（未入库）"
                logger.info(f"大纲 {outline.title} 展开完成，生成 {len(chapter_plans)} 个章节规划{save_status}")
                
            except Exception as e:
                logger.error(f"展开大纲 {outline.id} 失败: {str(e)}", exc_info=True)
                yield await tracker.warning(
                    f"❌ {outline.title} 展开失败: {str(e)}"
                )
                expansion_results.append({
                    "outline_id": outline.id,
                    "outline_title": outline.title,
                    "target_chapter_count": chapters_per_outline,
                    "actual_chapter_count": 0,
                    "expansion_strategy": expansion_strategy,
                    "chapter_plans": [],
                    "created_chapters": None,
                    "error": str(e)
                })
        
        yield await tracker.parsing("整理结果数据...")
        
        db_committed = True
        
        logger.info(f"批量展开完成: {len(expansion_results)} 个大纲，跳过 {len(skipped_outlines)} 个，共生成 {total_chapters_created} 个章节")
        
        yield await tracker.complete()
        
        # 发送最终结果
        result_data = {
            "project_id": project_id,
            "total_outlines_expanded": len(expansion_results),
            "total_chapters_created": total_chapters_created,
            "skipped_count": len(skipped_outlines),
            "skipped_outlines": skipped_outlines,
            "expansion_results": [
                {
                    "outline_id": result["outline_id"],
                    "outline_title": result["outline_title"],
                    "target_chapter_count": result["target_chapter_count"],
                    "actual_chapter_count": result["actual_chapter_count"],
                    "expansion_strategy": result["expansion_strategy"],
                    "chapter_plans": result["chapter_plans"],
                    "created_chapters": result.get("created_chapters")
                }
                for result in expansion_results
            ]
        }
        
        yield await tracker.result(result_data)
        yield await tracker.done()
        
    except GeneratorExit:
        logger.warning("批量展开生成器被提前关闭")
        if not db_committed and db.in_transaction():
            await db.rollback()
            logger.info("批量展开事务已回滚（GeneratorExit）")
    except Exception as e:
        logger.error(f"批量展开失败: {str(e)}")
        if not db_committed and db.in_transaction():
            await db.rollback()
            logger.info("批量展开事务已回滚（异常）")
        yield await SSEResponse.send_error(f"批量展开失败: {str(e)}")




async def _run_batch_outline_expansion_background(task_id: str, user_id: str, task_input: Dict[str, Any]):
    """后台执行批量大纲展开任务"""
    from app.services.background_task_service import TaskProgressTracker
    from app.database import get_engine
    from sqlalchemy.ext.asyncio import async_sessionmaker, AsyncSession
    
    engine = await get_engine(user_id)
    AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    
    async with AsyncSessionLocal() as bg_db:
        tracker = TaskProgressTracker(task_id, user_id, "批量大纲展开")
        try:
            await tracker.start()
            
            # 获取AI服务
            from app.api.settings import get_user_ai_service_from_db
            bg_ai_service = await get_user_ai_service_from_db(user_id, bg_db)
            
            project_id = task_input.get("project_id")
            chapters_per_outline = int(task_input.get("chapters_per_outline", 3))
            expansion_strategy = task_input.get("expansion_strategy", "balanced")
            auto_create_chapters = task_input.get("auto_create_chapters", True)
            outline_ids = task_input.get("outline_ids")
            enable_scene_analysis = task_input.get("enable_scene_analysis", True)
            
            # 获取项目信息
            await tracker.loading("加载项目信息...", 0.2)
            project_result = await bg_db.execute(
                select(Project).where(Project.id == project_id)
            )
            project = project_result.scalar_one_or_none()
            if not project:
                await tracker.error("项目不存在")
                return
            
            # 获取要展开的大纲列表
            await tracker.loading("获取大纲列表...", 0.5)
            if outline_ids:
                outlines_result = await bg_db.execute(
                    select(Outline)
                    .where(
                        Outline.project_id == project_id,
                        Outline.id.in_(outline_ids)
                    )
                    .order_by(Outline.order_index)
                )
            else:
                outlines_result = await bg_db.execute(
                    select(Outline)
                    .where(Outline.project_id == project_id)
                    .order_by(Outline.order_index)
                )
            
            outlines = outlines_result.scalars().all()
            
            if not outlines:
                await tracker.error("没有找到要展开的大纲")
                return
            
            total_outlines = len(outlines)
            await tracker.preparing(f"共找到 {total_outlines} 个大纲，开始批量展开...")
            
            # 创建展开服务实例
            expansion_service = PlotExpansionService(bg_ai_service)
            
            expansion_results = []
            total_chapters_created = 0
            skipped_outlines = []
            
            for idx, outline in enumerate(outlines):
                try:
                    # 检查大纲是否已经展开过
                    existing_chapters_result = await bg_db.execute(
                        select(Chapter)
                        .where(Chapter.outline_id == outline.id)
                        .limit(1)
                    )
                    existing_chapter = existing_chapters_result.scalar_one_or_none()
                    
                    if existing_chapter:
                        logger.info(f"大纲 {outline.title} (ID: {outline.id}) 已经展开过，跳过")
                        skipped_outlines.append({
                            "outline_id": outline.id,
                            "outline_title": outline.title,
                            "reason": "已展开"
                        })
                        await tracker.generating(
                            current_chars=(idx + 1) * chapters_per_outline * 500,
                            estimated_total=total_outlines * chapters_per_outline * 500,
                            message=f"⏭️ {outline.title} 已展开过，跳过"
                        )
                        continue
                    
                    # 分析大纲生成章节规划（逐批入库 + 末尾一次性重排序）
                    all_chapter_plans = []
                    created_chapters = []
                    
                    async def _on_batch_progress(batch_plans, start_index, total_generated, total_target):
                        """每批生成完成后立即入库（不重排序）"""
                        all_chapter_plans.extend(batch_plans)
                        # 逐章报告进度
                        for i, plan in enumerate(batch_plans):
                            chapter_number = start_index + i
                            plan_title = plan.get("title", f"第{chapter_number}节")
                            await tracker.generating(
                                current_chars=(idx * chapters_per_outline + total_generated - len(batch_plans) + i + 1) * 500,
                                estimated_total=total_outlines * chapters_per_outline * 500,
                                message=f"💾 第 {chapter_number} 章《{plan_title}》已保存 ({total_generated}/{total_target})"
                            )
                        # 逐批立即入库（跳过重排序，最后统一做）
                        if auto_create_chapters and batch_plans:
                            try:
                                chapters = await expansion_service.create_chapters_from_plans(
                                    outline_id=outline.id,
                                    chapter_plans=batch_plans,
                                    project_id=outline.project_id,
                                    db=bg_db,
                                    start_chapter_number=None,
                                    no_renumber=True
                                )
                                for ch in chapters:
                                    created_chapters.append({
                                        "id": ch.id,
                                        "chapter_number": ch.chapter_number,
                                        "title": ch.title,
                                        "summary": ch.summary,
                                        "outline_id": ch.outline_id,
                                        "sub_index": ch.sub_index,
                                        "status": ch.status
                                    })
                                total_chapters_created += len(chapters)
                            except Exception as save_err:
                                logger.error(f"第 {start_index}-{start_index + len(batch_plans) - 1} 批入库失败: {save_err}", exc_info=True)
                    
                    await tracker.generating(
                        current_chars=idx * chapters_per_outline * 500,
                        estimated_total=total_outlines * chapters_per_outline * 500,
                        message=f"🤖 AI分析大纲: {outline.title}（{chapters_per_outline} 章）"
                    )
                    
                    await expansion_service.analyze_outline_for_chapters(
                        outline=outline,
                        project=project,
                        db=bg_db,
                        target_chapter_count=chapters_per_outline,
                        expansion_strategy=expansion_strategy,
                        enable_scene_analysis=enable_scene_analysis,
                        provider=task_input.get("provider"),
                        model=task_input.get("model"),
                        on_batch_complete=_on_batch_progress
                    )
                    
                    chapter_plans = all_chapter_plans
                    
                    # 所有批次入库完成后，统一做一次重排序
                    if auto_create_chapters and created_chapters:
                        await tracker.generating(
                            current_chars=(idx + 0.85) * chapters_per_outline * 500,
                            estimated_total=total_outlines * chapters_per_outline * 500,
                            message=f"🔄 {outline.title} 正在统一排序..."
                        )
                        await expansion_service._renumber_subsequent_chapters(
                            project_id=outline.project_id,
                            current_outline_id=outline.id,
                            db=bg_db
                        )
                    save_status = f"，已入库 {len(created_chapters)} 章" if auto_create_chapters and created_chapters else "（未入库）"
                    logger.info(f"大纲 {outline.title} 展开完成，生成 {len(chapter_plans)} 个章节规划{save_status}")
                    
                except Exception as e:
                    logger.error(f"展开大纲 {outline.id} 失败: {str(e)}", exc_info=True)
                    await tracker.warning(f"❌ {outline.title} 展开失败: {str(e)}")
                    expansion_results.append({
                        "outline_id": outline.id,
                        "outline_title": outline.title,
                        "target_chapter_count": chapters_per_outline,
                        "actual_chapter_count": 0,
                        "expansion_strategy": expansion_strategy,
                        "chapter_plans": [],
                        "created_chapters": None,
                        "error": str(e)
                    })
            
            await tracker.parsing("整理结果数据...")
            
            logger.info(f"批量展开完成: {len(expansion_results)} 个大纲，跳过 {len(skipped_outlines)} 个，共生成 {total_chapters_created} 个章节")
            
            await tracker.complete()
            
        except Exception as e:
            logger.error(f"❌ 后台批量大纲展开失败: {e}", exc_info=True)
            await tracker.error(str(e))

@router.post("/batch-expand-background", summary="后台批量展开大纲为多章")
async def batch_expand_outlines_background(
    data: Dict[str, Any],
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """创建后台任务批量展开大纲，任务完成后可在右下角后台任务面板查看结果。"""
    user_id = getattr(request.state, 'user_id', None)
    project = await verify_project_access(data.get("project_id"), user_id, db)

    from app.services.background_task_service import background_task_service

    task_input = dict(data or {})
    task_input.setdefault("auto_create_chapters", True)

    task = await background_task_service.create_task(
        user_id=user_id,
        project_id=project.id,
        task_type="outline_batch_expand",
        task_input=task_input,
        db=db
    )

    await background_task_service.spawn_background_task(
        task.id, user_id, _run_batch_outline_expansion_background, task_input
    )

    return {
        "task_id": task.id,
        "task_type": "outline_batch_expand",
        "status": "pending",
        "message": "批量大纲展开任务已创建，请通过后台任务面板查看进度"
    }


@router.post("/batch-expand-stream", summary="批量展开大纲为多章(SSE流式)")
async def batch_expand_outlines_stream(
    data: Dict[str, Any],
    request: Request,
    db: AsyncSession = Depends(get_db),
    user_ai_service: AIService = Depends(get_user_ai_service)
):
    """
    使用SSE流式批量展开大纲，实时推送每个大纲的处理进度
    
    请求体示例：
    {
        "project_id": "项目ID",
        "outline_ids": ["大纲ID1", "大纲ID2"],  // 可选，不传则展开所有大纲
        "chapters_per_outline": 3,  // 每个大纲展开几章
        "expansion_strategy": "balanced",  // balanced/climax/detail
        "auto_create_chapters": false,  // 是否自动创建章节
        "enable_scene_analysis": true,  // 是否启用场景分析
        "provider": "openai",  // 可选
        "model": "gpt-4"  // 可选
    }
    """
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    await verify_project_access(data.get("project_id"), user_id, db)
    
    return create_sse_response(batch_expand_outlines_generator(data, db, user_ai_service))


@router.post("/{outline_id}/create-chapters-from-plans", response_model=CreateChaptersFromPlansResponse, summary="根据已有规划创建章节")
async def create_chapters_from_existing_plans(
    outline_id: str,
    plans_request: CreateChaptersFromPlansRequest,
    request: Request,
    db: AsyncSession = Depends(get_db),
    user_ai_service: AIService = Depends(get_user_ai_service)
):
    """
    根据前端缓存的章节规划直接创建章节记录，避免重复调用AI
    
    使用场景：
    1. 用户第一次调用 /outlines/{outline_id}/expand?auto_create_chapters=false 获取规划预览
    2. 前端展示规划给用户确认
    3. 用户确认后，前端调用此接口，传递缓存的规划数据，直接创建章节
    
    优势：
    - 避免重复的AI调用，节省Token和时间
    - 确保用户看到的预览和实际创建的章节完全一致
    - 提升用户体验
    
    参数：
    - outline_id: 要展开的大纲ID
    - plans_request: 包含之前AI生成的章节规划列表
    
    返回：
    - 创建的章节列表和统计信息
    """
    # 验证用户权限
    user_id = getattr(request.state, 'user_id', None)
    
    # 获取大纲
    result = await db.execute(
        select(Outline).where(Outline.id == outline_id)
    )
    outline = result.scalar_one_or_none()
    
    if not outline:
        raise HTTPException(status_code=404, detail="大纲不存在")
    
    # 验证项目权限
    await verify_project_access(outline.project_id, user_id, db)
    
    try:
        # 验证规划数据
        if not plans_request.chapter_plans:
            raise HTTPException(status_code=400, detail="章节规划列表不能为空")
        
        logger.info(f"根据已有规划为大纲 {outline_id} 创建 {len(plans_request.chapter_plans)} 个章节")
        
        # 创建展开服务实例
        expansion_service = PlotExpansionService(user_ai_service)
        
        # 将Pydantic模型转换为字典列表
        chapter_plans_dict = [plan.model_dump() for plan in plans_request.chapter_plans]
        
        # 直接使用传入的规划创建章节记录（不调用AI）
        created_chapters = await expansion_service.create_chapters_from_plans(
            outline_id=outline_id,
            chapter_plans=chapter_plans_dict,
            project_id=outline.project_id,
            db=db,
            start_chapter_number=None  # 自动计算章节序号
        )
        
        await db.commit()
        
        # 刷新章节数据
        for chapter in created_chapters:
            await db.refresh(chapter)
        
        logger.info(f"成功根据已有规划创建 {len(created_chapters)} 个章节记录")
        
        # 构建响应
        return CreateChaptersFromPlansResponse(
            outline_id=outline_id,
            outline_title=outline.title,
            chapters_created=len(created_chapters),
            created_chapters=[
                {
                    "id": ch.id,
                    "chapter_number": ch.chapter_number,
                    "title": ch.title,
                    "summary": ch.summary,
                    "outline_id": ch.outline_id,
                    "sub_index": ch.sub_index,
                    "status": ch.status
                }
                for ch in created_chapters
            ]
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"根据已有规划创建章节失败: {str(e)}", exc_info=True)
        await db.rollback()
        raise HTTPException(status_code=500, detail=f"创建章节失败: {str(e)}")
