"""大纲剧情展开服务 - 将大纲节点展开为多个章节"""
from typing import List, Dict, Any, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
import json

from app.models.outline import Outline
from app.models.project import Project
from app.models.character import Character
from app.models.chapter import Chapter
from app.services.ai_service import AIService
from app.services.json_helper import loads_json
from app.services.prompt_service import prompt_service, PromptService
from app.logger import get_logger, safe_preview

logger = get_logger(__name__)


class PlotExpansionService:
    """大纲剧情展开服务"""
    
    def __init__(self, ai_service: AIService):
        self.ai_service = ai_service
    
    async def analyze_outline_for_chapters(
        self,
        outline: Outline,
        project: Project,
        db: AsyncSession,
        target_chapter_count: int = 3,
        expansion_strategy: str = "balanced",
        enable_scene_analysis: bool = True,
        provider: Optional[str] = None,
        model: Optional[str] = None,
        batch_size: int = 3,
        rolling_window_size: int = 3,
        progress_callback: Optional[callable] = None,
        on_batch_complete: Optional[callable] = None
    ) -> List[Dict[str, Any]]:
        """
        分析单个大纲,生成多章节规划（支持分批生成）
        
        Args:
            outline: 大纲对象
            project: 项目对象
            db: 数据库会话
            target_chapter_count: 目标生成章节数
            expansion_strategy: 展开策略(balanced/climax/detail)
            enable_scene_analysis: 是否启用场景级分析
            provider: AI提供商
            model: AI模型
            batch_size: 每批生成的章节数（默认3章，减少单次AI调用负担）
            rolling_window_size: 滚动窗口大小（默认3，每次只参考前N章摘要）
            progress_callback: 进度回调函数(可选)
            on_batch_complete: 每批生成完成时的回调(可选)，签名: (batch_plans, start_index, total_generated) -> None
            
        Returns:
            章节规划列表
        """
        logger.info(f"开始分析大纲 {outline.id}，目标生成 {target_chapter_count} 章")
        
        # 如果章节数较少（<= batch_size），直接单次生成
        if target_chapter_count <= batch_size:
            results = await self._generate_chapters_single_batch(
                outline=outline,
                project=project,
                db=db,
                target_chapter_count=target_chapter_count,
                expansion_strategy=expansion_strategy,
                enable_scene_analysis=enable_scene_analysis,
                provider=provider,
                model=model
            )
            # 单次也触发回调
            if on_batch_complete:
                await on_batch_complete(
                    batch_plans=results,
                    start_index=1,
                    total_generated=len(results),
                    total_target=target_chapter_count
                )
            return results
        
        # 章节数较多，分批生成（使用滚动窗口，每次只参考前N章）
        logger.info(f"章节数({target_chapter_count})超过批次大小({batch_size})，启用滚动窗口分批生成(窗口={rolling_window_size})")
        return await self._generate_chapters_in_batches(
            outline=outline,
            project=project,
            db=db,
            target_chapter_count=target_chapter_count,
            expansion_strategy=expansion_strategy,
            enable_scene_analysis=enable_scene_analysis,
            provider=provider,
            model=model,
            batch_size=batch_size,
            rolling_window_size=rolling_window_size,
            progress_callback=progress_callback,
            on_batch_complete=on_batch_complete
        )
    
    async def _generate_chapters_single_batch(
        self,
        outline: Outline,
        project: Project,
        db: AsyncSession,
        target_chapter_count: int,
        expansion_strategy: str,
        enable_scene_analysis: bool,
        provider: Optional[str],
        model: Optional[str]
    ) -> List[Dict[str, Any]]:
        """单批次生成章节规划"""
        # 从卷纲 structure 中提取角色名称
        outline_structure = {}
        if outline.structure:
            try:
                import json
                outline_structure = json.loads(outline.structure) if isinstance(outline.structure, str) else outline.structure
            except (json.JSONDecodeError, TypeError):
                outline_structure = {}
        
        structure_characters = outline_structure.get("characters", [])
        character_names = []
        for char_entry in structure_characters:
            if isinstance(char_entry, str):
                # 容错：如果包含冒号，提取冒号前的部分
                name = char_entry.split('：')[0].strip() if '：' in char_entry else char_entry.strip()
                if name:
                    character_names.append(name)
            elif isinstance(char_entry, dict):
                name = char_entry.get("name", "").strip()
                char_type = char_entry.get("type", "character")
                if name and char_type != "organization":
                    character_names.append(name)
        
        # 只查询卷纲中提到的角色
        if character_names:
            characters_result = await db.execute(
                select(Character).where(
                    Character.project_id == project.id,
                    Character.name.in_(character_names)
                )
            )
            characters = characters_result.scalars().all()
        else:
            characters = []
        
        characters_info = "\n".join([
            f"- {char.name} ({'组织' if char.is_organization else '角色'}, {char.role_type}): "
            f"{char.personality[:100] if char.personality else '暂无描述'}"
            for char in characters
        ])
        
        # 记录传递给 AI 的角色信息
        logger.info(f"📋 [章纲展开] 传递的角色信息: {characters_info[:500]}{'...' if len(characters_info) > 500 else ''}")
        logger.info(f"📋 [章纲展开] 卷纲 structure 中的角色: {structure_characters}")
        
        # 获取大纲上下文（前后大纲）
        context_info = await self._get_outline_context(outline, project.id, db)
        
        # 获取自定义提示词模板
        template = await PromptService.get_template("OUTLINE_EXPAND_SINGLE", project.user_id, db)
        # 格式化提示词
        prompt = PromptService.format_prompt(
            template,
            project_title=project.title,
            project_genre=project.genre or '通用',
            project_theme=project.theme or '未设定',
            project_narrative_perspective=project.narrative_perspective or '第三人称',
            project_world_time_period=project.world_time_period or '未设定',
            project_world_location=project.world_location or '未设定',
            project_world_atmosphere=project.world_atmosphere or '未设定',
            characters_info=characters_info or '暂无角色',
            outline_order_index=outline.order_index,
            outline_title=outline.title,
            outline_content=outline.content,
            context_info=context_info,
            strategy_instruction=expansion_strategy,
            target_chapter_count=target_chapter_count,
            scene_instruction="",  # 暂时为空
            scene_field=""  # 暂时为空
        )
        
        # 调用AI生成章节规划
        logger.info(f"调用AI生成章节规划...")
        accumulated_text = ""
        async for chunk in self.ai_service.generate_text_stream(
            prompt=prompt,
            provider=provider,
            model=model
        ):
            accumulated_text += chunk
        
        # 提取内容
        ai_content = accumulated_text
        
        # 解析AI响应
        chapter_plans = self._parse_expansion_response(ai_content, outline.id, expected_count=target_chapter_count)
        
        logger.info(f"成功生成 {len(chapter_plans)} 个章节规划")
        return chapter_plans
    
    async def _generate_chapters_in_batches(
        self,
        outline: Outline,
        project: Project,
        db: AsyncSession,
        target_chapter_count: int,
        expansion_strategy: str,
        enable_scene_analysis: bool,
        provider: Optional[str],
        model: Optional[str],
        batch_size: int,
        rolling_window_size: int = 3,
        progress_callback: Optional[callable] = None,
        on_batch_complete: Optional[callable] = None
    ) -> List[Dict[str, Any]]:
        """分批生成章节规划（增强差异化版本）"""
        # 计算批次数
        total_batches = (target_chapter_count + batch_size - 1) // batch_size
        logger.info(f"分批生成计划: 总共{target_chapter_count}章，分{total_batches}批，每批{batch_size}章")
        
        # 获取角色信息（所有批次共用）
        characters_result = await db.execute(
            select(Character).where(Character.project_id == project.id)
        )
        characters = characters_result.scalars().all()
        characters_info = "\n".join([
            f"- {char.name} ({'组织' if char.is_organization else '角色'}, {char.role_type}): "
            f"{char.personality[:100] if char.personality else '暂无描述'}"
            for char in characters
        ])
        
        # 获取大纲上下文
        context_info = await self._get_outline_context(outline, project.id, db)
        
        all_chapter_plans = []
        
        # 🔧 收集所有已使用的关键事件，用于防止重复
        used_key_events = set()
        
        for batch_num in range(total_batches):
            # 计算当前批次的章节数
            remaining_chapters = target_chapter_count - len(all_chapter_plans)
            current_batch_size = min(batch_size, remaining_chapters)
            current_start_index = len(all_chapter_plans) + 1
            
            logger.info(f"开始生成第{batch_num + 1}/{total_batches}批，章节范围: {current_start_index}-{current_start_index + current_batch_size - 1}")
            
            # 回调通知进度
            if progress_callback:
                await progress_callback(batch_num + 1, total_batches, current_start_index, current_batch_size)
            
            # 🔧 滚动窗口上下文构建（仅参考前N章，避免上下文过长）
            previous_context = ""
            if all_chapter_plans:
                # 滚动窗口：只取最近 rolling_window_size 章的摘要
                window_chapters = all_chapter_plans[-rolling_window_size:]
                
                previous_summaries = []
                for ch in window_chapters:
                    key_events_str = "、".join(ch.get('key_events', [])[:3]) if ch.get('key_events') else "无"
                    previous_summaries.append(
                        f"第{ch['sub_index']}节《{ch['title']}》:\n"
                        f"  - 剧情：{ch.get('plot_summary', '')[:150]}\n"
                        f"  - 关键事件：{key_events_str}\n"
                        f"  - 结尾方式：{ch.get('ending_type', '未知')}"
                    )
                
                # 提取最近已使用的关键事件（窗口内 + 少量历史事件防重复）
                recent_events = []
                for ch in window_chapters:
                    recent_events.extend(ch.get('key_events', []))
                # 额外取更早的关键事件摘要（仅标题级，防大跨度重复）
                earlier_chapters = all_chapter_plans[:-rolling_window_size] if len(all_chapter_plans) > rolling_window_size else []
                earlier_events = []
                for ch in earlier_chapters:
                    earlier_events.extend(ch.get('key_events', [])[:1])  # 每章只取1个代表性事件
                
                all_recent_events = recent_events + earlier_events
                used_events_str = "、".join(all_recent_events[-20:]) if all_recent_events else "暂无"
                
                # 计算总进度信息
                total_generated = len(all_chapter_plans)
                
                previous_context = f"""
【🔴 最近已生成章节（滚动窗口，共{len(window_chapters)}/{total_generated}节）】
{chr(10).join(previous_summaries)}

【🔴 已使用的关键事件（不可重复）】
{used_events_str}

【🔴 差异化强制要求】
⚠️ 当前是第{current_start_index}-{current_start_index + current_batch_size}节（共{target_chapter_count}节中的第{batch_num + 1}批）
⚠️ 每个新章节必须有完全不同的：
   1. 开场场景（不同地点/时间/人物状态）
   2. 核心事件（不与已生成章节的关键事件重复）
   3. 结尾悬念（不同类型的钩子）
⚠️ 新章节的key_events不得与上面【已使用的关键事件】中的任何事件相同或相似
"""
            # 获取自定义提示词模板
            template = await PromptService.get_template("OUTLINE_EXPAND_MULTI", project.user_id, db)

            # 查询后续大纲的章节（用于衔接）
            next_chapters_context_batch = ""
            next_chapters_after_result = await db.execute(
                select(Chapter)
                .join(Outline, Chapter.outline_id == Outline.id)
                .where(
                    Chapter.project_id == project.id,
                    Outline.order_index > outline.order_index,
                )
                .order_by(Chapter.chapter_number)
                .limit(3)
            )
            next_chapters_after = next_chapters_after_result.scalars().all()
            next_chapters_after_parts = []
            for ch in next_chapters_after:
                plan_data = {}
                if ch.expansion_plan:
                    try:
                        plan_data = json.loads(ch.expansion_plan) if isinstance(ch.expansion_plan, str) else ch.expansion_plan
                    except (json.JSONDecodeError, TypeError):
                        pass
                key_events = plan_data.get("key_events", [])
                key_events_str = "、".join(key_events[:3]) if key_events else "无"
                next_chapters_after_parts.append(
                    f"第{ch.chapter_number}章《{ch.title}》:\n"
                    f"  - 剧情：{(ch.summary or '')[:150]}\n"
                    f"  - 关键事件：{key_events_str}"
                )
            if next_chapters_after_parts:
                next_chapters_context_batch = "\n\n".join(next_chapters_after_parts)
            else:
                next_chapters_context_batch = "（无后续章节，当前大纲结尾）"

            # 格式化提示词
            prompt = PromptService.format_prompt(
                template,
                project_title=project.title,
                project_genre=project.genre or '通用',
                project_theme=project.theme or '未设定',
                project_narrative_perspective=project.narrative_perspective or '第三人称',
                project_world_time_period=project.world_time_period or '未设定',
                project_world_location=project.world_location or '未设定',
                project_world_atmosphere=project.world_atmosphere or '未设定',
                characters_info=characters_info or '暂无角色',
                outline_order_index=outline.order_index,
                outline_title=outline.title,
                outline_content=outline.content,
                context_info=context_info,
                previous_context=previous_context,
                next_chapters_context=next_chapters_context_batch,
                strategy_instruction=expansion_strategy,
                start_index=current_start_index,
                end_index=current_start_index + current_batch_size - 1,
                target_chapter_count=current_batch_size,
                scene_instruction="", # 暂时为空
                scene_field="" # 暂时为空
            )
            
            # 调用AI生成当前批次（带错误处理）
            logger.info(f"调用AI生成第{batch_num + 1}批...")
            batch_plans = []
            try:
                accumulated_text = ""
                async for chunk in self.ai_service.generate_text_stream(
                    prompt=prompt,
                    provider=provider,
                    model=model
                ):
                    accumulated_text += chunk
                
                # 提取内容
                ai_content = accumulated_text
                
                # 解析AI响应
                batch_plans = self._parse_expansion_response(ai_content, outline.id, expected_count=current_batch_size)
                
                if not batch_plans:
                    logger.warning(f"第{batch_num + 1}批返回 0 章，AI响应长度: {len(ai_content)} 字符")
                    logger.debug(f"AI响应内容: {ai_content[:500]}...")
                
            except Exception as batch_error:
                logger.error(f"第{batch_num + 1}批生成失败: {batch_error}", exc_info=True)
                logger.debug(f"失败的AI响应: {ai_content[:500] if ai_content else '空'}...")
                # 继续下一批，不中断整体流程
            
            # 调整sub_index以保持连续性
            for i, plan in enumerate(batch_plans):
                plan["sub_index"] = current_start_index + i
            
            all_chapter_plans.extend(batch_plans)
            
            logger.info(f"第{batch_num + 1}批生成完成，本批生成{len(batch_plans)}章，累计{len(all_chapter_plans)}/{target_chapter_count}章")
            
            # 🔔 每批生成完成触发回调（供调用方逐批入库和报告进度）
            if on_batch_complete and batch_plans:
                try:
                    await on_batch_complete(
                        batch_plans=batch_plans,
                        start_index=current_start_index,
                        total_generated=len(all_chapter_plans),
                        total_target=target_chapter_count
                    )
                except Exception as cb_error:
                    logger.error(f"第{batch_num + 1}批回调处理失败: {cb_error}", exc_info=True)
                    # 回调失败不影响后续批次
        
        logger.info(f"分批生成完成，共生成 {len(all_chapter_plans)} 个章节规划")
        return all_chapter_plans
    
    async def batch_expand_outlines(
        self,
        project_id: str,
        db: AsyncSession,
        ai_service: AIService,
        target_chapters_per_outline: int = 3,
        expansion_strategy: str = "balanced",
        provider: Optional[str] = None,
        model: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        批量展开所有大纲为章节
        
        Returns:
            {
                "total_outlines": 总大纲数,
                "total_chapters_planned": 规划的总章节数,
                "expansions": [每个大纲的展开结果]
            }
        """
        logger.info(f"开始批量展开项目 {project_id} 的所有大纲")
        
        # 获取项目
        project_result = await db.execute(
            select(Project).where(Project.id == project_id)
        )
        project = project_result.scalar_one_or_none()
        if not project:
            raise ValueError(f"项目 {project_id} 不存在")
        
        # 获取所有大纲
        outlines_result = await db.execute(
            select(Outline)
            .where(Outline.project_id == project_id)
            .order_by(Outline.order_index)
        )
        outlines = outlines_result.scalars().all()
        
        if not outlines:
            logger.warning(f"项目 {project_id} 没有大纲")
            return {
                "total_outlines": 0,
                "total_chapters_planned": 0,
                "expansions": []
            }
        
        # 逐个展开大纲
        expansions = []
        total_chapters = 0
        
        for outline in outlines:
            try:
                chapter_plans = await self.analyze_outline_for_chapters(
                    outline=outline,
                    project=project,
                    db=db,
                    target_chapter_count=target_chapters_per_outline,
                    expansion_strategy=expansion_strategy,
                    provider=provider,
                    model=model
                )
                
                expansions.append({
                    "outline_id": outline.id,
                    "outline_title": outline.title,
                    "chapter_plans": chapter_plans,
                    "chapter_count": len(chapter_plans)
                })
                
                total_chapters += len(chapter_plans)
                logger.info(f"大纲 {outline.title} 展开为 {len(chapter_plans)} 章")
                
            except Exception as e:
                logger.error(f"展开大纲 {outline.id} 失败: {str(e)}")
                expansions.append({
                    "outline_id": outline.id,
                    "outline_title": outline.title,
                    "error": str(e),
                    "chapter_count": 0
                })
        
        result = {
            "total_outlines": len(outlines),
            "total_chapters_planned": total_chapters,
            "expansions": expansions
        }
        
        logger.info(f"批量展开完成: {len(outlines)} 个大纲 → {total_chapters} 个章节规划")
        return result

    async def regenerate_chapters_from_position(
        self,
        outline: Outline,
        project: Project,
        db: AsyncSession,
        target_chapter_count: int = 3,
        expansion_strategy: str = "balanced",
        provider: Optional[str] = None,
        model: Optional[str] = None,
        on_batch_complete: Optional[callable] = None,
        start_chapter_number: int = 1,
        start_sub_index: int = 1
    ) -> List[Dict[str, Any]]:
        """
        从指定章节位置重新生成章纲规划

        与 analyze_outline_for_chapters 类似，但额外注入前文上下文（已有章节的摘要和关键事件），
        确保重新生成的章纲与之前的故事内容连贯。

        Args:
            outline: 章节所属的大纲对象
            project: 项目对象
            db: 数据库会话
            target_chapter_count: 要重新生成的章节数
            expansion_strategy: 展开策略
            provider/model: AI 提供商和模型
            on_batch_complete: 生成完成回调
            start_chapter_number: 起始章节号（全局编号，用于 prompt 告知 AI 当前位置）
            start_sub_index: 起始子序号（大纲内编号，用于 sub_index 编号）
        Returns:
            章节规划列表
        """
        logger.info(f"重新生成章纲: 大纲 {outline.id}, 目标 {target_chapter_count} 章")

        # 从卷纲 structure 中提取角色名称（与 _generate_chapters_single_batch 一致）
        outline_structure = {}
        if outline.structure:
            try:
                outline_structure = json.loads(outline.structure) if isinstance(outline.structure, str) else outline.structure
            except (json.JSONDecodeError, TypeError):
                outline_structure = {}

        structure_characters = outline_structure.get("characters", [])
        character_names = []
        for char_entry in structure_characters:
            if isinstance(char_entry, str):
                name = char_entry.split('：')[0].strip() if '：' in char_entry else char_entry.strip()
                if name:
                    character_names.append(name)
            elif isinstance(char_entry, dict):
                name = char_entry.get("name", "").strip()
                char_type = char_entry.get("type", "character")
                if name and char_type != "organization":
                    character_names.append(name)

        if character_names:
            characters_result = await db.execute(
                select(Character).where(
                    Character.project_id == project.id,
                    Character.name.in_(character_names)
                )
            )
            characters = characters_result.scalars().all()
        else:
            characters = []

        characters_info = "\n".join([
            f"- {char.name} ({'组织' if char.is_organization else '角色'}, {char.role_type}): "
            f"{char.personality[:100] if char.personality else '暂无描述'}"
            for char in characters
        ])

        # 获取大纲上下文（前后大纲）
        context_info = await self._get_outline_context(outline, project.id, db)

        # 获取前文章节上下文：取同一大纲中前面的章节 + 前面大纲的最近章节，确保新章纲与前文衔接
        # 先查同一大纲中，子序号小于 start_sub_index 的最近 3 章
        same_outline_prev_result = await db.execute(
            select(Chapter)
            .where(
                Chapter.project_id == project.id,
                Chapter.outline_id == outline.id,
                Chapter.sub_index < start_sub_index,
            )
            .order_by(Chapter.sub_index.desc())
            .limit(3)
        )
        same_outline_prev_chapters = same_outline_prev_result.scalars().all()

        # 再查前面大纲的最近章节（最多 3 章，不足 3 章时用同一大纲的章节补充）
        prev_outline_limit = 3 - len(same_outline_prev_chapters)
        prev_outline_chapters = []
        if prev_outline_limit > 0:
            prev_outline_chapters_result = await db.execute(
                select(Chapter)
                .join(Outline, Chapter.outline_id == Outline.id)
                .where(
                    Chapter.project_id == project.id,
                    Outline.order_index < outline.order_index,
                )
                .order_by(Chapter.chapter_number.desc())
                .limit(prev_outline_limit)
            )
            prev_outline_chapters = prev_outline_chapters_result.scalars().all()

        # 构建前文上下文
        previous_context_parts = []

        # 前面大纲的章节（按 chapter_number 正序）
        for ch in reversed(prev_outline_chapters):
            plan_data = {}
            if ch.expansion_plan:
                try:
                    plan_data = json.loads(ch.expansion_plan) if isinstance(ch.expansion_plan, str) else ch.expansion_plan
                except (json.JSONDecodeError, TypeError):
                    pass
            key_events = plan_data.get("key_events", [])
            key_events_str = "、".join(key_events[:3]) if key_events else "无"
            previous_context_parts.append(
                f"第{ch.chapter_number}章《{ch.title}》:\n"
                f"  - 剧情：{(ch.summary or '')[:150]}\n"
                f"  - 关键事件：{key_events_str}"
            )

        # 同一大纲中前面的章节（按 chapter_number 正序，排在前面大纲章节之后）
        for ch in reversed(same_outline_prev_chapters):
            plan_data = {}
            if ch.expansion_plan:
                try:
                    plan_data = json.loads(ch.expansion_plan) if isinstance(ch.expansion_plan, str) else ch.expansion_plan
                except (json.JSONDecodeError, TypeError):
                    pass
            key_events = plan_data.get("key_events", [])
            key_events_str = "、".join(key_events[:3]) if key_events else "无"
            previous_context_parts.append(
                f"第{ch.chapter_number}章《{ch.title}》:\n"
                f"  - 剧情：{(ch.summary or '')[:150]}\n"
                f"  - 关键事件：{key_events_str}"
            )

        if previous_context_parts:
            previous_context = "【前文回顾（已有章节的摘要，新章纲需要与之衔接）】\n" + "\n\n".join(previous_context_parts)
        else:
            previous_context = "（无前文章节，可作为开篇处理）"

        # 添加全局章节位置信息，让 AI 明确知道当前在整本书的位置
        if start_chapter_number > 1:
            previous_context = (
                f"【📍 当前进度：这是整本书第 {start_chapter_number} 章起，共需生成 {target_chapter_count} 章】\n\n"
                + previous_context
            )

        logger.info(f"前文上下文构建完成: {len(previous_context_parts)} 章摘要, 起始章节号={start_chapter_number}")

        # 查询重新生成范围之后的 3 章，让 AI 知道后面有什么内容可以衔接
        next_chapters_context = ""
        after_regen_chapter_number = start_chapter_number + target_chapter_count
        next_chapters_result = await db.execute(
            select(Chapter)
            .where(
                Chapter.project_id == project.id,
                Chapter.chapter_number >= after_regen_chapter_number,
            )
            .order_by(Chapter.chapter_number)
            .limit(3)
        )
        next_chapters = next_chapters_result.scalars().all()

        next_chapters_parts = []
        for ch in next_chapters:
            plan_data = {}
            if ch.expansion_plan:
                try:
                    plan_data = json.loads(ch.expansion_plan) if isinstance(ch.expansion_plan, str) else ch.expansion_plan
                except (json.JSONDecodeError, TypeError):
                    pass
            key_events = plan_data.get("key_events", [])
            key_events_str = "、".join(key_events[:3]) if key_events else "无"
            next_chapters_parts.append(
                f"第{ch.chapter_number}章《{ch.title}》:\n"
                f"  - 剧情：{(ch.summary or '')[:150]}\n"
                f"  - 关键事件：{key_events_str}"
            )

        if next_chapters_parts:
            next_chapters_context = "\n\n".join(next_chapters_parts)
        else:
            next_chapters_context = "（无后续章节，当前大纲结尾）"

        logger.info(f"后续章节上下文构建完成: {len(next_chapters)} 章摘要")

        # 获取提示词模板（复用 OUTLINE_EXPAND_MULTI，它支持 previous_context 参数）
        template = await PromptService.get_template("OUTLINE_EXPAND_MULTI", project.user_id, db)
        prompt = PromptService.format_prompt(
            template,
            project_title=project.title,
            project_genre=project.genre or '通用',
            project_theme=project.theme or '未设定',
            project_narrative_perspective=project.narrative_perspective or '第三人称',
            project_world_time_period=project.world_time_period or '未设定',
            project_world_location=project.world_location or '未设定',
            project_world_atmosphere=project.world_atmosphere or '未设定',
            characters_info=characters_info or '暂无角色',
            outline_order_index=outline.order_index,
            outline_title=outline.title,
            outline_content=outline.content,
            context_info=context_info,
            previous_context=previous_context,
            next_chapters_context=next_chapters_context,
            strategy_instruction=expansion_strategy,
            start_index=start_sub_index,
            end_index=start_sub_index + target_chapter_count - 1,
            target_chapter_count=target_chapter_count,
            scene_instruction="",
            scene_field=""
        )

        logger.info("调用AI重新生成章纲规划...")
        accumulated_text = ""
        async for chunk in self.ai_service.generate_text_stream(
            prompt=prompt,
            provider=provider,
            model=model
        ):
            accumulated_text += chunk

        chapter_plans = self._parse_expansion_response(accumulated_text, outline.id, expected_count=target_chapter_count)

        # 调整 sub_index 从 start_sub_index 开始
        for i, plan in enumerate(chapter_plans):
            plan["sub_index"] = start_sub_index + i

        logger.info(f"成功重新生成 {len(chapter_plans)} 个章节规划")

        if on_batch_complete and chapter_plans:
            try:
                await on_batch_complete(
                    batch_plans=chapter_plans,
                    start_index=start_sub_index,
                    total_generated=len(chapter_plans),
                    total_target=target_chapter_count
                )
            except Exception as cb_error:
                logger.error(f"重新生成回调处理失败: {cb_error}", exc_info=True)

        return chapter_plans

    async def create_chapters_from_plans(
        self,
        outline_id: str,
        chapter_plans: List[Dict[str, Any]],
        project_id: str,
        db: AsyncSession,
        start_chapter_number: int = None,
        no_renumber: bool = False
    ) -> List[Chapter]:
        """
        根据章节规划创建实际的章节记录
        
        Args:
            outline_id: 大纲ID
            chapter_plans: 章节规划列表
            project_id: 项目ID
            db: 数据库会话
            start_chapter_number: 起始章节号（如果为None，则自动计算）
            no_renumber: 是否跳过末尾的重排序（批量入库时用，最后统一重排序）
            
        Returns:
            创建的章节列表
        """
        logger.info(f"根据规划创建 {len(chapter_plans)} 个章节记录")
        
        # 如果没有指定起始章节号，根据大纲顺序自动计算
        if start_chapter_number is None:
            # 1. 获取当前大纲信息
            outline_result = await db.execute(
                select(Outline).where(Outline.id == outline_id)
            )
            current_outline = outline_result.scalar_one_or_none()
            
            if not current_outline:
                raise ValueError(f"大纲 {outline_id} 不存在")
            
            # 2. 查询所有在当前大纲之前的大纲（按order_index排序）
            prev_outlines_result = await db.execute(
                select(Outline)
                .where(
                    Outline.project_id == project_id,
                    Outline.order_index < current_outline.order_index
                )
                .order_by(Outline.order_index)
            )
            prev_outlines = prev_outlines_result.scalars().all()
            
            # 3. 计算前面所有大纲已展开的章节总数
            total_prev_chapters = 0
            for prev_outline in prev_outlines:
                count_result = await db.execute(
                    select(func.count(Chapter.id))
                    .where(
                        Chapter.project_id == project_id,
                        Chapter.outline_id == prev_outline.id
                    )
                )
                total_prev_chapters += count_result.scalar() or 0
            
            # 4. 当前大纲已有章节数（分批入库时，前几批已 commit 的章节）
            current_outline_count_result = await db.execute(
                select(func.count(Chapter.id))
                .where(
                    Chapter.project_id == project_id,
                    Chapter.outline_id == outline_id
                )
            )
            current_outline_chapters = current_outline_count_result.scalar() or 0
            
            # 5. 起始章节号 = 前面所有大纲的章节数 + 当前大纲已有章节数 + 1
            start_chapter_number = total_prev_chapters + current_outline_chapters + 1
            logger.info(f"自动计算起始章节号: {start_chapter_number} (基于大纲order_index={current_outline.order_index}, 前置章节数={total_prev_chapters}, 当前大纲已有章节数={current_outline_chapters})")
        
        chapters = []
        for idx, plan in enumerate(chapter_plans):
            # 归一化 AI 返回的字段类型，防止 key_events/character_focus 被返回为字符串
            def _ensure_list(val):
                if isinstance(val, list):
                    return val
                if isinstance(val, str) and val.strip():
                    return [s.strip() for s in val.replace('、', '，').split('，') if s.strip()]
                return []

            # 保存完整的展开规划数据（JSON格式）
            expansion_plan_json = json.dumps({
                "key_events": _ensure_list(plan.get("key_events")),
                "character_focus": _ensure_list(plan.get("character_focus")),
                "emotional_tone": plan.get("emotional_tone", ""),
                "narrative_goal": plan.get("narrative_goal", ""),
                "conflict_type": plan.get("conflict_type", ""),
                "estimated_words": plan.get("estimated_words", 3000),
                "scenes": plan.get("scenes", []) if plan.get("scenes") else None
            }, ensure_ascii=False)
            
            chapter = Chapter(
                project_id=project_id,
                outline_id=outline_id,
                chapter_number=start_chapter_number + idx,
                sub_index=plan.get("sub_index", idx + 1),
                title=plan.get("title", f"第{start_chapter_number + idx}章"),
                summary=plan.get("plot_summary", ""),
                expansion_plan=expansion_plan_json,
                status="draft"
            )
            db.add(chapter)
            chapters.append(chapter)
        
        await db.commit()
        
        for chapter in chapters:
            await db.refresh(chapter)
        
        logger.info(f"成功创建 {len(chapters)} 个章节记录（已保存展开规划数据）")
        
        # 重新排序当前大纲之后的所有章节（no_renumber=True 时跳过，由调用方统一处理）
        if not no_renumber:
            await self._renumber_subsequent_chapters(
                project_id=project_id,
                current_outline_id=outline_id,
                db=db
            )
        
        return chapters
    
    async def _get_outline_context(
        self,
        outline: Outline,
        project_id: str,
        db: AsyncSession
    ) -> str:
        """获取大纲的上下文（前后大纲）"""
        # 获取前一个大纲
        prev_result = await db.execute(
            select(Outline)
            .where(
                Outline.project_id == project_id,
                Outline.order_index < outline.order_index
            )
            .order_by(Outline.order_index.desc())
            .limit(1)
        )
        prev_outline = prev_result.scalar_one_or_none()
        
        # 获取后一个大纲
        next_result = await db.execute(
            select(Outline)
            .where(
                Outline.project_id == project_id,
                Outline.order_index > outline.order_index
            )
            .order_by(Outline.order_index)
            .limit(1)
        )
        next_outline = next_result.scalar_one_or_none()
        
        context = ""
        if prev_outline:
            context += f"【前一节】{prev_outline.title}: {prev_outline.content[:200]}...\n\n"
        if next_outline:
            context += f"【后一节】{next_outline.title}: {next_outline.content[:200]}...\n"
        
        return context if context else "（无前后文）"
    
    
    def _build_fallback_chapter_plans(
        self,
        outline_id: str,
        expected_count: int = 1,
        title_prefix: str = "AI解析失败的默认章节"
    ) -> List[Dict[str, Any]]:
        """构造失败兜底章节，确保按批次数量补齐。"""
        count = max(1, expected_count)
        return [{
            "outline_id": outline_id,
            "sub_index": idx + 1,
            "title": f"{title_prefix} {idx + 1}/{count}",
            "plot_summary": "AI返回内容无法解析，已按默认章节补齐以保证章节数量完整性。",
            "key_events": ["解析失败"],
            "character_focus": [],
            "emotional_tone": "未知",
            "narrative_goal": "需要重新生成",
            "conflict_type": "未知",
            "ending_type": "未知",
            "estimated_words": 3000
        } for idx in range(count)]

    @staticmethod
    def compute_shifted_following_chapter_numbers(
        start_chapter_number: int,
        target_chapter_count: int,
        existing_after_chapter_numbers: List[int],
    ) -> List[int]:
        """计算从当前章节之后顺移的章节号。

        例如：当前第8章重新生成3章，后续已有9、10章时，重排后应为 8、9、10（新生成）
        而原来的9、10顺移到11、12，因此后续章节需要整体右移 target_chapter_count - 1。
        """
        shift_amount = max(0, int(target_chapter_count) - 1)
        if shift_amount == 0:
            return list(existing_after_chapter_numbers)
        return [chapter_number + shift_amount for chapter_number in existing_after_chapter_numbers]

    def _parse_expansion_response(
        self,
        ai_response: str,
        outline_id: str,
        expected_count: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """解析AI的展开响应（使用统一的JSON清洗方法，增强差异化字段）"""
        target_count = max(1, expected_count or 1)
        try:
            # 使用统一的JSON清洗方法
            cleaned_text = self.ai_service._clean_json_response(ai_response)

            # 解析JSON
            chapter_plans = loads_json(cleaned_text)

            # 确保是列表
            if not isinstance(chapter_plans, list):
                chapter_plans = [chapter_plans]

            if len(chapter_plans) < target_count:
                logger.warning(f"⚠️ 解析成功但章节数不足: 期望 {target_count}，实际 {len(chapter_plans)}，补齐默认章节")
                chapter_plans.extend(
                    self._build_fallback_chapter_plans(outline_id, expected_count=target_count - len(chapter_plans), title_prefix="AI补齐的默认章节")
                )

            # 为每个章节规划添加outline_id和差异化标识
            for idx, plan in enumerate(chapter_plans[:target_count]):
                plan["outline_id"] = outline_id

                # 🔧 确保有 ending_type 字段（用于差异化追踪）
                if "ending_type" not in plan:
                    # 根据叙事目标推断结尾类型
                    narrative_goal = plan.get("narrative_goal", "")
                    if "悬念" in narrative_goal or "疑问" in narrative_goal:
                        plan["ending_type"] = "悬念"
                    elif "冲突" in narrative_goal or "对抗" in narrative_goal:
                        plan["ending_type"] = "冲突升级"
                    elif "转折" in narrative_goal:
                        plan["ending_type"] = "情节转折"
                    elif "情感" in narrative_goal or "情绪" in narrative_goal:
                        plan["ending_type"] = "情感收尾"
                    else:
                        plan["ending_type"] = f"自然过渡-{idx + 1}"

                # 🔧 确保 key_events 是列表且非空
                if not plan.get("key_events"):
                    plan["key_events"] = [f"章节{idx + 1}核心事件"]
                elif isinstance(plan["key_events"], str):
                    plan["key_events"] = [s.strip() for s in plan["key_events"].replace('、', '，').split('，') if s.strip()] or [f"章节{idx + 1}核心事件"]

                # 🔧 确保 character_focus 是列表
                if not isinstance(plan.get("character_focus"), list):
                    val = plan.get("character_focus")
                    if isinstance(val, str) and val.strip():
                        plan["character_focus"] = [s.strip() for s in val.replace('、', '，').split('，') if s.strip()]
                    else:
                        plan["character_focus"] = []

            logger.info(f"✅ 成功解析 {len(chapter_plans[:target_count])} 个章节规划（含差异化标识）")
            return chapter_plans[:target_count]

        except (json.JSONDecodeError, ValueError) as e:
            logger.error(f"❌ 解析AI响应失败: {e}, 响应预览: {safe_preview(ai_response, 300)}")
            return self._build_fallback_chapter_plans(outline_id, expected_count=target_count)
        except Exception as e:
            logger.error(f"❌ 解析异常: {str(e)}")
            return self._build_fallback_chapter_plans(outline_id, expected_count=target_count, title_prefix="解析异常的默认章节")


    async def _renumber_subsequent_chapters(
        self,
        project_id: str,
        current_outline_id: str,
        db: AsyncSession
    ):
        """
        重新计算当前大纲之后所有大纲的章节序号
        
        Args:
            project_id: 项目ID
            current_outline_id: 当前大纲ID
            db: 数据库会话
        """
        logger.info(f"开始重新排序大纲 {current_outline_id} 之后的所有章节")
        
        # 1. 获取当前大纲信息
        current_outline_result = await db.execute(
            select(Outline).where(Outline.id == current_outline_id)
        )
        current_outline = current_outline_result.scalar_one_or_none()
        
        if not current_outline:
            logger.warning(f"大纲 {current_outline_id} 不存在，跳过重新排序")
            return
        
        # 2. 获取当前大纲及之后的所有大纲（按order_index排序）
        subsequent_outlines_result = await db.execute(
            select(Outline)
            .where(
                Outline.project_id == project_id,
                Outline.order_index >= current_outline.order_index
            )
            .order_by(Outline.order_index)
        )
        subsequent_outlines = subsequent_outlines_result.scalars().all()
        
        # 3. 计算每个大纲的起始章节号
        current_chapter_number = 1
        
        # 先计算前面大纲的章节总数
        prev_outlines_result = await db.execute(
            select(Outline)
            .where(
                Outline.project_id == project_id,
                Outline.order_index < current_outline.order_index
            )
            .order_by(Outline.order_index)
        )
        prev_outlines = prev_outlines_result.scalars().all()
        
        for prev_outline in prev_outlines:
            count_result = await db.execute(
                select(func.count(Chapter.id))
                .where(
                    Chapter.project_id == project_id,
                    Chapter.outline_id == prev_outline.id
                )
            )
            current_chapter_number += count_result.scalar() or 0
        
        # 4. 逐个大纲更新章节序号
        updated_count = 0
        for outline in subsequent_outlines:
            # 获取该大纲的所有章节（按sub_index排序）
            chapters_result = await db.execute(
                select(Chapter)
                .where(
                    Chapter.project_id == project_id,
                    Chapter.outline_id == outline.id
                )
                .order_by(Chapter.sub_index)
            )
            chapters = chapters_result.scalars().all()
            
            # 更新每个章节的chapter_number 和 title
            for chapter in chapters:
                if chapter.chapter_number != current_chapter_number:
                    old_number = chapter.chapter_number
                    logger.debug(f"更新章节 {chapter.id}: {chapter.chapter_number} -> {current_chapter_number}")
                    chapter.chapter_number = current_chapter_number
                    # 同步更新标题中的章节号（仅替换首次出现）
                    if chapter.title:
                        chapter.title = chapter.title.replace(
                            f'第{old_number}章',
                            f'第{current_chapter_number}章',
                            1
                        )
                    updated_count += 1
                current_chapter_number += 1
        
        # 5. 提交更新
        await db.commit()
        logger.info(f"重新排序完成，共更新 {updated_count} 个章节的序号")


# 工厂函数
def create_plot_expansion_service(ai_service: AIService) -> PlotExpansionService:
    """创建剧情展开服务实例"""
    return PlotExpansionService(ai_service)



