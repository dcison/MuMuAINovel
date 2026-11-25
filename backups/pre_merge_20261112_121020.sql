--
-- PostgreSQL database dump
--

\restrict SDquXl1JUYsxiLxCwIlnIIbGImCupJXFbwGX9ZHp65axcwqlYV7uNWdR81q7PEd

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: mumuai
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO mumuai;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: mumuai
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mumuai;

--
-- Name: analysis_tasks; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.analysis_tasks (
    id character varying(36) NOT NULL,
    chapter_id character varying(36) NOT NULL,
    user_id character varying(50) NOT NULL,
    project_id character varying(36) NOT NULL,
    status character varying(20) NOT NULL,
    progress integer,
    error_message text,
    created_at timestamp without time zone DEFAULT now(),
    started_at timestamp without time zone,
    completed_at timestamp without time zone
);


ALTER TABLE public.analysis_tasks OWNER TO mumuai;

--
-- Name: COLUMN analysis_tasks.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.id IS '任务ID';


--
-- Name: COLUMN analysis_tasks.chapter_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.chapter_id IS '章节ID';


--
-- Name: COLUMN analysis_tasks.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.user_id IS '用户ID';


--
-- Name: COLUMN analysis_tasks.project_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.project_id IS '项目ID';


--
-- Name: COLUMN analysis_tasks.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.status IS '任务状态: pending/running/completed/failed';


--
-- Name: COLUMN analysis_tasks.progress; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.progress IS '进度 0-100';


--
-- Name: COLUMN analysis_tasks.error_message; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.error_message IS '错误信息';


--
-- Name: COLUMN analysis_tasks.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.created_at IS '创建时间';


--
-- Name: COLUMN analysis_tasks.started_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.started_at IS '开始执行时间';


--
-- Name: COLUMN analysis_tasks.completed_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.analysis_tasks.completed_at IS '完成时间';


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.announcements (
    id character varying(36) NOT NULL,
    title character varying(120) NOT NULL,
    content text NOT NULL,
    summary character varying(255),
    level character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    pinned boolean NOT NULL,
    author_id character varying(100),
    author_name character varying(100),
    publish_at timestamp without time zone DEFAULT now(),
    expire_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.announcements OWNER TO mumuai;

--
-- Name: COLUMN announcements.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.id IS 'UUID';


--
-- Name: COLUMN announcements.title; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.title IS '公告标题';


--
-- Name: COLUMN announcements.content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.content IS '公告正文';


--
-- Name: COLUMN announcements.summary; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.summary IS '公告摘要';


--
-- Name: COLUMN announcements.level; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.level IS '级别：info/success/warning/error';


--
-- Name: COLUMN announcements.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.status IS '状态：draft/published/hidden';


--
-- Name: COLUMN announcements.pinned; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.pinned IS '是否置顶';


--
-- Name: COLUMN announcements.author_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.author_id IS '发布管理员ID';


--
-- Name: COLUMN announcements.author_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.author_name IS '发布管理员显示名';


--
-- Name: COLUMN announcements.publish_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.publish_at IS '发布时间';


--
-- Name: COLUMN announcements.expire_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.expire_at IS '过期时间';


--
-- Name: COLUMN announcements.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.created_at IS '创建时间';


--
-- Name: COLUMN announcements.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.announcements.updated_at IS '更新时间';


--
-- Name: background_tasks; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.background_tasks (
    id character varying(36) NOT NULL,
    user_id character varying(100) NOT NULL,
    project_id character varying(36) NOT NULL,
    task_type character varying(50) NOT NULL,
    status character varying(20),
    progress integer,
    status_message character varying(500),
    task_input json,
    task_result json,
    error_message text,
    progress_details json,
    cancel_requested boolean,
    retry_count integer,
    max_retries integer,
    created_at timestamp without time zone DEFAULT now(),
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.background_tasks OWNER TO mumuai;

--
-- Name: COLUMN background_tasks.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.user_id IS '用户ID';


--
-- Name: COLUMN background_tasks.project_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.project_id IS '项目ID';


--
-- Name: COLUMN background_tasks.task_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.task_type IS '任务类型';


--
-- Name: COLUMN background_tasks.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.status IS '任务状态';


--
-- Name: COLUMN background_tasks.progress; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.progress IS '进度百分比';


--
-- Name: COLUMN background_tasks.status_message; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.status_message IS '当前状态消息';


--
-- Name: COLUMN background_tasks.task_input; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.task_input IS '任务输入参数';


--
-- Name: COLUMN background_tasks.task_result; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.task_result IS '任务结果';


--
-- Name: COLUMN background_tasks.error_message; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.error_message IS '错误信息';


--
-- Name: COLUMN background_tasks.progress_details; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.progress_details IS '进度详情';


--
-- Name: COLUMN background_tasks.cancel_requested; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.cancel_requested IS '是否请求取消';


--
-- Name: COLUMN background_tasks.retry_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.retry_count IS '已重试次数';


--
-- Name: COLUMN background_tasks.max_retries; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.max_retries IS '最大重试次数';


--
-- Name: COLUMN background_tasks.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.created_at IS '创建时间';


--
-- Name: COLUMN background_tasks.started_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.started_at IS '开始时间';


--
-- Name: COLUMN background_tasks.completed_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.completed_at IS '完成时间';


--
-- Name: COLUMN background_tasks.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.background_tasks.updated_at IS '更新时间';


--
-- Name: batch_generation_tasks; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.batch_generation_tasks (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    user_id character varying(100) NOT NULL,
    start_chapter_number integer NOT NULL,
    chapter_count integer NOT NULL,
    chapter_ids json NOT NULL,
    style_id integer,
    target_word_count integer,
    enable_analysis boolean,
    status character varying(20),
    total_chapters integer,
    completed_chapters integer,
    failed_chapters json,
    current_chapter_id character varying(36),
    current_chapter_number integer,
    current_retry_count integer,
    max_retries integer,
    created_at timestamp without time zone DEFAULT now(),
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    error_message character varying(500)
);


ALTER TABLE public.batch_generation_tasks OWNER TO mumuai;

--
-- Name: COLUMN batch_generation_tasks.project_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.project_id IS '项目ID';


--
-- Name: COLUMN batch_generation_tasks.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.user_id IS '用户ID';


--
-- Name: COLUMN batch_generation_tasks.start_chapter_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.start_chapter_number IS '起始章节序号';


--
-- Name: COLUMN batch_generation_tasks.chapter_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.chapter_count IS '生成章节数量';


--
-- Name: COLUMN batch_generation_tasks.chapter_ids; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.chapter_ids IS '待生成的章节ID列表';


--
-- Name: COLUMN batch_generation_tasks.style_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.style_id IS '使用的写作风格ID';


--
-- Name: COLUMN batch_generation_tasks.target_word_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.target_word_count IS '目标字数';


--
-- Name: COLUMN batch_generation_tasks.enable_analysis; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.enable_analysis IS '是否启用同步分析';


--
-- Name: COLUMN batch_generation_tasks.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.status IS '任务状态: pending/running/completed/failed/cancelled';


--
-- Name: COLUMN batch_generation_tasks.total_chapters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.total_chapters IS '总章节数';


--
-- Name: COLUMN batch_generation_tasks.completed_chapters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.completed_chapters IS '已完成章节数';


--
-- Name: COLUMN batch_generation_tasks.failed_chapters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.failed_chapters IS '失败的章节信息列表';


--
-- Name: COLUMN batch_generation_tasks.current_chapter_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.current_chapter_id IS '当前正在生成的章节ID';


--
-- Name: COLUMN batch_generation_tasks.current_chapter_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.current_chapter_number IS '当前正在生成的章节序号';


--
-- Name: COLUMN batch_generation_tasks.current_retry_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.current_retry_count IS '当前章节重试次数';


--
-- Name: COLUMN batch_generation_tasks.max_retries; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.max_retries IS '最大重试次数';


--
-- Name: COLUMN batch_generation_tasks.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.created_at IS '创建时间';


--
-- Name: COLUMN batch_generation_tasks.started_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.started_at IS '开始时间';


--
-- Name: COLUMN batch_generation_tasks.completed_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.completed_at IS '完成时间';


--
-- Name: COLUMN batch_generation_tasks.error_message; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.batch_generation_tasks.error_message IS '错误信息';


--
-- Name: careers; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.careers (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(20) NOT NULL,
    description text,
    category character varying(50),
    stages text NOT NULL,
    max_stage integer NOT NULL,
    requirements text,
    special_abilities text,
    worldview_rules text,
    attribute_bonuses text,
    source character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.careers OWNER TO mumuai;

--
-- Name: COLUMN careers.name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.name IS '职业名称';


--
-- Name: COLUMN careers.type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.type IS '职业类型: main(主职业)/sub(副职业)';


--
-- Name: COLUMN careers.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.description IS '职业描述';


--
-- Name: COLUMN careers.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.category IS '职业分类（如：战斗系、生产系、辅助系）';


--
-- Name: COLUMN careers.stages; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.stages IS '职业阶段列表(JSON): [{level:1, name:'''', description:''''}, ...]';


--
-- Name: COLUMN careers.max_stage; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.max_stage IS '最大阶段数';


--
-- Name: COLUMN careers.requirements; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.requirements IS '职业要求/限制';


--
-- Name: COLUMN careers.special_abilities; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.special_abilities IS '特殊能力描述';


--
-- Name: COLUMN careers.worldview_rules; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.worldview_rules IS '世界观规则关联';


--
-- Name: COLUMN careers.attribute_bonuses; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.attribute_bonuses IS '属性加成(JSON): {strength: ''+10%'', intelligence: ''+5%''}';


--
-- Name: COLUMN careers.source; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.source IS '来源: ai/manual';


--
-- Name: COLUMN careers.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.created_at IS '创建时间';


--
-- Name: COLUMN careers.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.careers.updated_at IS '更新时间';


--
-- Name: chapters; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.chapters (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    chapter_number integer NOT NULL,
    title character varying(200) NOT NULL,
    content text,
    summary text,
    word_count integer,
    status character varying(20),
    outline_id character varying(36),
    sub_index integer,
    expansion_plan text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.chapters OWNER TO mumuai;

--
-- Name: COLUMN chapters.chapter_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.chapter_number IS '章节序号';


--
-- Name: COLUMN chapters.title; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.title IS '章节标题';


--
-- Name: COLUMN chapters.content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.content IS '章节内容';


--
-- Name: COLUMN chapters.summary; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.summary IS '章节摘要';


--
-- Name: COLUMN chapters.word_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.word_count IS '字数统计';


--
-- Name: COLUMN chapters.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.status IS '章节状态';


--
-- Name: COLUMN chapters.outline_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.outline_id IS '关联的大纲ID';


--
-- Name: COLUMN chapters.sub_index; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.sub_index IS '大纲下的子章节序号';


--
-- Name: COLUMN chapters.expansion_plan; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.expansion_plan IS '展开规划详情(JSON): 包含key_events, character_focus, emotional_tone等';


--
-- Name: COLUMN chapters.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.created_at IS '创建时间';


--
-- Name: COLUMN chapters.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.chapters.updated_at IS '更新时间';


--
-- Name: character_careers; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.character_careers (
    id character varying(36) NOT NULL,
    character_id character varying(36) NOT NULL,
    career_id character varying(36) NOT NULL,
    career_type character varying(20) NOT NULL,
    current_stage integer NOT NULL,
    stage_progress integer,
    started_at character varying(100),
    reached_current_stage_at character varying(100),
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.character_careers OWNER TO mumuai;

--
-- Name: COLUMN character_careers.career_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.career_type IS 'main(主职业)/sub(副职业)';


--
-- Name: COLUMN character_careers.current_stage; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.current_stage IS '当前阶段（对应职业中的数值）';


--
-- Name: COLUMN character_careers.stage_progress; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.stage_progress IS '阶段内进度（0-100）';


--
-- Name: COLUMN character_careers.started_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.started_at IS '开始修炼时间（小说时间线）';


--
-- Name: COLUMN character_careers.reached_current_stage_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.reached_current_stage_at IS '到达当前阶段时间';


--
-- Name: COLUMN character_careers.notes; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.notes IS '备注（如：修炼心得、特殊事件）';


--
-- Name: COLUMN character_careers.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.created_at IS '创建时间';


--
-- Name: COLUMN character_careers.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_careers.updated_at IS '更新时间';


--
-- Name: character_relationships; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.character_relationships (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    character_from_id character varying(36) NOT NULL,
    character_to_id character varying(36) NOT NULL,
    relationship_type_id integer,
    relationship_name character varying(100),
    intimacy_level integer,
    status character varying(20),
    description text,
    started_at character varying(100),
    ended_at character varying(100),
    source character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.character_relationships OWNER TO mumuai;

--
-- Name: COLUMN character_relationships.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.id IS '关系ID';


--
-- Name: COLUMN character_relationships.project_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.project_id IS '项目ID';


--
-- Name: COLUMN character_relationships.character_from_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.character_from_id IS '角色A的ID';


--
-- Name: COLUMN character_relationships.character_to_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.character_to_id IS '角色B的ID';


--
-- Name: COLUMN character_relationships.relationship_type_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.relationship_type_id IS '关系类型ID';


--
-- Name: COLUMN character_relationships.relationship_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.relationship_name IS '自定义关系名称';


--
-- Name: COLUMN character_relationships.intimacy_level; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.intimacy_level IS '亲密度：-100到100';


--
-- Name: COLUMN character_relationships.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.status IS '状态：active/broken/past/complicated';


--
-- Name: COLUMN character_relationships.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.description IS '关系详细描述';


--
-- Name: COLUMN character_relationships.started_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.started_at IS '关系开始时间（故事时间）';


--
-- Name: COLUMN character_relationships.ended_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.ended_at IS '关系结束时间（故事时间）';


--
-- Name: COLUMN character_relationships.source; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.source IS '来源：ai/manual/imported';


--
-- Name: COLUMN character_relationships.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.created_at IS '创建时间';


--
-- Name: COLUMN character_relationships.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.character_relationships.updated_at IS '更新时间';


--
-- Name: characters; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.characters (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    name character varying(100) NOT NULL,
    age character varying(50),
    gender character varying(50),
    is_organization boolean,
    role_type character varying(50),
    personality text,
    background text,
    appearance text,
    relationships text,
    organization_type character varying(100),
    organization_purpose character varying(500),
    organization_members text,
    main_career_id character varying(36),
    main_career_stage integer,
    sub_careers text,
    avatar_url character varying(500),
    traits text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    status character varying(20),
    status_changed_chapter integer,
    current_state text,
    state_updated_chapter integer
);


ALTER TABLE public.characters OWNER TO mumuai;

--
-- Name: COLUMN characters.name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.name IS '角色/组织名称';


--
-- Name: COLUMN characters.age; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.age IS '年龄';


--
-- Name: COLUMN characters.gender; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.gender IS '性别';


--
-- Name: COLUMN characters.is_organization; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.is_organization IS '是否为组织';


--
-- Name: COLUMN characters.role_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.role_type IS '角色类型';


--
-- Name: COLUMN characters.personality; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.personality IS '性格特点/组织特性';


--
-- Name: COLUMN characters.background; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.background IS '背景故事';


--
-- Name: COLUMN characters.appearance; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.appearance IS '外貌描述';


--
-- Name: COLUMN characters.relationships; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.relationships IS '人物关系(JSON)';


--
-- Name: COLUMN characters.organization_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.organization_type IS '组织类型';


--
-- Name: COLUMN characters.organization_purpose; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.organization_purpose IS '组织目的';


--
-- Name: COLUMN characters.organization_members; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.organization_members IS '组织成员(JSON)';


--
-- Name: COLUMN characters.main_career_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.main_career_id IS '主职业ID';


--
-- Name: COLUMN characters.main_career_stage; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.main_career_stage IS '主职业当前阶段';


--
-- Name: COLUMN characters.sub_careers; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.sub_careers IS '副职业列表(JSON): [{"career_id": "xxx", "stage": 3}, ...]';


--
-- Name: COLUMN characters.avatar_url; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.avatar_url IS '头像URL';


--
-- Name: COLUMN characters.traits; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.traits IS '特征标签(JSON)';


--
-- Name: COLUMN characters.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.created_at IS '创建时间';


--
-- Name: COLUMN characters.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.updated_at IS '更新时间';


--
-- Name: COLUMN characters.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.status IS '状态：active/deceased/missing/retired/destroyed';


--
-- Name: COLUMN characters.status_changed_chapter; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.status_changed_chapter IS '状态变更的章节号';


--
-- Name: COLUMN characters.current_state; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.current_state IS '角色当前心理状态（由分析自动更新）';


--
-- Name: COLUMN characters.state_updated_chapter; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.characters.state_updated_chapter IS '心理状态最后更新的章节号';


--
-- Name: foreshadows; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.foreshadows (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    title character varying(200) NOT NULL,
    content text NOT NULL,
    hint_text text,
    resolution_text text,
    source_type character varying(20),
    source_memory_id character varying(100),
    source_analysis_id character varying(36),
    plant_chapter_id character varying(36),
    plant_chapter_number integer,
    target_resolve_chapter_id character varying(36),
    target_resolve_chapter_number integer,
    actual_resolve_chapter_id character varying(36),
    actual_resolve_chapter_number integer,
    status character varying(20),
    is_long_term boolean,
    importance double precision,
    strength integer,
    subtlety integer,
    urgency integer,
    related_characters json,
    related_foreshadow_ids json,
    tags json,
    category character varying(50),
    notes text,
    resolution_notes text,
    auto_remind boolean,
    remind_before_chapters integer,
    include_in_context boolean,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    planted_at timestamp without time zone,
    resolved_at timestamp without time zone
);


ALTER TABLE public.foreshadows OWNER TO mumuai;

--
-- Name: COLUMN foreshadows.title; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.title IS '伏笔标题';


--
-- Name: COLUMN foreshadows.content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.content IS '伏笔详细内容/描述';


--
-- Name: COLUMN foreshadows.hint_text; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.hint_text IS '埋伏笔时的暗示文本(原文摘录或概述)';


--
-- Name: COLUMN foreshadows.resolution_text; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.resolution_text IS '回收伏笔时的揭示文本(原文摘录或概述)';


--
-- Name: COLUMN foreshadows.source_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.source_type IS '来源类型: analysis=分析提取, manual=手动添加';


--
-- Name: COLUMN foreshadows.source_memory_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.source_memory_id IS '来源记忆ID(如从分析结果同步)';


--
-- Name: COLUMN foreshadows.source_analysis_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.source_analysis_id IS '来源分析任务ID';


--
-- Name: COLUMN foreshadows.plant_chapter_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.plant_chapter_id IS '埋入章节ID';


--
-- Name: COLUMN foreshadows.plant_chapter_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.plant_chapter_number IS '埋入章节号(冗余存储便于查询)';


--
-- Name: COLUMN foreshadows.target_resolve_chapter_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.target_resolve_chapter_id IS '计划回收章节ID';


--
-- Name: COLUMN foreshadows.target_resolve_chapter_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.target_resolve_chapter_number IS '计划回收章节号';


--
-- Name: COLUMN foreshadows.actual_resolve_chapter_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.actual_resolve_chapter_id IS '实际回收章节ID';


--
-- Name: COLUMN foreshadows.actual_resolve_chapter_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.actual_resolve_chapter_number IS '实际回收章节号';


--
-- Name: COLUMN foreshadows.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.status IS '
    伏笔状态:
    - pending: 待埋入(已规划但未写入章节)
    - planted: 已埋入(已在章节中埋下)
    - resolved: 已回收(已在章节中回收)
    - partially_resolved: 部分回收(长线伏笔可能分多次回收)
    - abandoned: 已废弃(决定不再使用此伏笔)
    ';


--
-- Name: COLUMN foreshadows.is_long_term; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.is_long_term IS '是否长线伏笔(跨多章的重要伏笔)';


--
-- Name: COLUMN foreshadows.importance; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.importance IS '重要性评分 0.0-1.0';


--
-- Name: COLUMN foreshadows.strength; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.strength IS '伏笔强度 1-10(影响读者多强烈)';


--
-- Name: COLUMN foreshadows.subtlety; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.subtlety IS '隐藏度 1-10(越高越隐蔽)';


--
-- Name: COLUMN foreshadows.urgency; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.urgency IS '紧急度: 0=不紧急, 1=需关注, 2=急需回收';


--
-- Name: COLUMN foreshadows.related_characters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.related_characters IS '关联角色名列表: [''角色1'', ''角色2'']';


--
-- Name: COLUMN foreshadows.related_foreshadow_ids; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.related_foreshadow_ids IS '关联的其他伏笔ID列表(伏笔链)';


--
-- Name: COLUMN foreshadows.tags; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.tags IS '标签列表: [''身世'', ''悬念'', ''反转'']';


--
-- Name: COLUMN foreshadows.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.category IS '分类: identity(身世), mystery(悬念), item(物品), relationship(关系), event(事件)';


--
-- Name: COLUMN foreshadows.notes; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.notes IS '创作备注(仅作者可见)';


--
-- Name: COLUMN foreshadows.resolution_notes; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.resolution_notes IS '回收方式说明';


--
-- Name: COLUMN foreshadows.auto_remind; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.auto_remind IS '是否在章节生成时自动提醒';


--
-- Name: COLUMN foreshadows.remind_before_chapters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.remind_before_chapters IS '提前几章开始提醒回收';


--
-- Name: COLUMN foreshadows.include_in_context; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.include_in_context IS '是否包含在生成上下文中';


--
-- Name: COLUMN foreshadows.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.created_at IS '创建时间';


--
-- Name: COLUMN foreshadows.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.updated_at IS '更新时间';


--
-- Name: COLUMN foreshadows.planted_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.planted_at IS '埋入时间';


--
-- Name: COLUMN foreshadows.resolved_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.foreshadows.resolved_at IS '回收时间';


--
-- Name: generation_history; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.generation_history (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    chapter_id character varying(36),
    prompt text,
    generated_content text,
    model character varying(50),
    tokens_used integer,
    generation_time double precision,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.generation_history OWNER TO mumuai;

--
-- Name: COLUMN generation_history.prompt; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.generation_history.prompt IS '使用的提示词';


--
-- Name: COLUMN generation_history.generated_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.generation_history.generated_content IS '生成的内容';


--
-- Name: COLUMN generation_history.model; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.generation_history.model IS '使用的模型';


--
-- Name: COLUMN generation_history.tokens_used; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.generation_history.tokens_used IS '消耗的token数';


--
-- Name: COLUMN generation_history.generation_time; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.generation_history.generation_time IS '生成耗时(秒)';


--
-- Name: COLUMN generation_history.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.generation_history.created_at IS '创建时间';


--
-- Name: mcp_plugins; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.mcp_plugins (
    id character varying(36) NOT NULL,
    user_id character varying(50) NOT NULL,
    plugin_name character varying(100) NOT NULL,
    display_name character varying(200) NOT NULL,
    description text,
    plugin_type character varying(50),
    server_url character varying(500),
    command character varying(500),
    args json,
    env json,
    headers json,
    config json,
    tools json,
    enabled boolean,
    status character varying(50),
    last_error text,
    last_test_at timestamp without time zone,
    category character varying(100),
    sort_order integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.mcp_plugins OWNER TO mumuai;

--
-- Name: COLUMN mcp_plugins.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.user_id IS '用户ID';


--
-- Name: COLUMN mcp_plugins.plugin_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.plugin_name IS '插件名称（唯一标识）';


--
-- Name: COLUMN mcp_plugins.display_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.display_name IS '显示名称';


--
-- Name: COLUMN mcp_plugins.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.description IS '插件描述';


--
-- Name: COLUMN mcp_plugins.plugin_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.plugin_type IS '插件类型：http/stdio';


--
-- Name: COLUMN mcp_plugins.server_url; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.server_url IS '服务器URL（HTTP类型）';


--
-- Name: COLUMN mcp_plugins.command; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.command IS '启动命令（stdio类型）';


--
-- Name: COLUMN mcp_plugins.args; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.args IS '命令参数（stdio类型）';


--
-- Name: COLUMN mcp_plugins.env; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.env IS '环境变量';


--
-- Name: COLUMN mcp_plugins.headers; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.headers IS 'HTTP请求头';


--
-- Name: COLUMN mcp_plugins.config; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.config IS '插件特定配置（JSON）';


--
-- Name: COLUMN mcp_plugins.tools; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.tools IS '提供的工具列表';


--
-- Name: COLUMN mcp_plugins.enabled; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.enabled IS '是否启用';


--
-- Name: COLUMN mcp_plugins.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.status IS '状态：active/inactive/error';


--
-- Name: COLUMN mcp_plugins.last_error; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.last_error IS '最后错误信息';


--
-- Name: COLUMN mcp_plugins.last_test_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.last_test_at IS '最后测试时间';


--
-- Name: COLUMN mcp_plugins.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.category IS '分类';


--
-- Name: COLUMN mcp_plugins.sort_order; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.sort_order IS '排序顺序';


--
-- Name: COLUMN mcp_plugins.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.created_at IS '创建时间';


--
-- Name: COLUMN mcp_plugins.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.mcp_plugins.updated_at IS '更新时间';


--
-- Name: organization_members; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.organization_members (
    id character varying(36) NOT NULL,
    organization_id character varying(36) NOT NULL,
    character_id character varying(36) NOT NULL,
    "position" character varying(100) NOT NULL,
    rank integer,
    status character varying(20),
    joined_at character varying(100),
    left_at character varying(100),
    loyalty integer,
    contribution integer,
    source character varying(20),
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.organization_members OWNER TO mumuai;

--
-- Name: COLUMN organization_members.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.id IS '成员关系ID';


--
-- Name: COLUMN organization_members.organization_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.organization_id IS '组织ID';


--
-- Name: COLUMN organization_members.character_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.character_id IS '角色ID';


--
-- Name: COLUMN organization_members."position"; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members."position" IS '职位名称';


--
-- Name: COLUMN organization_members.rank; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.rank IS '职位等级';


--
-- Name: COLUMN organization_members.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.status IS '状态：active/retired/expelled/deceased';


--
-- Name: COLUMN organization_members.joined_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.joined_at IS '加入时间（故事时间）';


--
-- Name: COLUMN organization_members.left_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.left_at IS '离开时间（故事时间）';


--
-- Name: COLUMN organization_members.loyalty; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.loyalty IS '忠诚度：0-100';


--
-- Name: COLUMN organization_members.contribution; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.contribution IS '贡献度：0-100';


--
-- Name: COLUMN organization_members.source; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.source IS '来源：ai/manual';


--
-- Name: COLUMN organization_members.notes; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.notes IS '备注';


--
-- Name: COLUMN organization_members.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.created_at IS '创建时间';


--
-- Name: COLUMN organization_members.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organization_members.updated_at IS '更新时间';


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.organizations (
    id character varying(36) NOT NULL,
    character_id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    parent_org_id character varying(36),
    level integer,
    power_level integer,
    member_count integer,
    location text,
    motto character varying(200),
    color character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.organizations OWNER TO mumuai;

--
-- Name: COLUMN organizations.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.id IS '组织ID';


--
-- Name: COLUMN organizations.character_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.character_id IS '关联的角色ID';


--
-- Name: COLUMN organizations.project_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.project_id IS '项目ID';


--
-- Name: COLUMN organizations.parent_org_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.parent_org_id IS '父组织ID';


--
-- Name: COLUMN organizations.level; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.level IS '组织层级';


--
-- Name: COLUMN organizations.power_level; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.power_level IS '势力等级：0-100';


--
-- Name: COLUMN organizations.member_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.member_count IS '成员数量';


--
-- Name: COLUMN organizations.location; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.location IS '所在地';


--
-- Name: COLUMN organizations.motto; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.motto IS '宗旨/口号';


--
-- Name: COLUMN organizations.color; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.color IS '代表颜色';


--
-- Name: COLUMN organizations.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.created_at IS '创建时间';


--
-- Name: COLUMN organizations.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.organizations.updated_at IS '更新时间';


--
-- Name: outlines; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.outlines (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    title character varying(200) NOT NULL,
    content text,
    structure text,
    order_index integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.outlines OWNER TO mumuai;

--
-- Name: COLUMN outlines.title; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.outlines.title IS '大纲标题';


--
-- Name: COLUMN outlines.content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.outlines.content IS '大纲内容';


--
-- Name: COLUMN outlines.structure; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.outlines.structure IS '结构化大纲数据(JSON)';


--
-- Name: COLUMN outlines.order_index; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.outlines.order_index IS '排序序号';


--
-- Name: COLUMN outlines.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.outlines.created_at IS '创建时间';


--
-- Name: COLUMN outlines.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.outlines.updated_at IS '更新时间';


--
-- Name: plot_analysis; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.plot_analysis (
    id character varying(36) NOT NULL,
    project_id character varying(36) NOT NULL,
    chapter_id character varying(36) NOT NULL,
    plot_stage character varying(50),
    conflict_level integer,
    conflict_types json,
    emotional_tone character varying(100),
    emotional_intensity double precision,
    emotional_curve json,
    hooks json,
    hooks_count integer,
    hooks_avg_strength double precision,
    foreshadows json,
    foreshadows_planted integer,
    foreshadows_resolved integer,
    plot_points json,
    plot_points_count integer,
    character_states json,
    scenes json,
    pacing character varying(50),
    overall_quality_score double precision,
    pacing_score double precision,
    engagement_score double precision,
    coherence_score double precision,
    analysis_report text,
    suggestions json,
    word_count integer,
    dialogue_ratio double precision,
    description_ratio double precision,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.plot_analysis OWNER TO mumuai;

--
-- Name: COLUMN plot_analysis.plot_stage; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.plot_stage IS '剧情阶段: 开端/发展/高潮/结局/过渡';


--
-- Name: COLUMN plot_analysis.conflict_level; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.conflict_level IS '冲突强度 1-10';


--
-- Name: COLUMN plot_analysis.conflict_types; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.conflict_types IS '冲突类型列表: [''人与人'', ''人与己'', ''人与环境'']';


--
-- Name: COLUMN plot_analysis.emotional_tone; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.emotional_tone IS '主导情感: 紧张/温馨/悲伤/激昂/平静';


--
-- Name: COLUMN plot_analysis.emotional_intensity; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.emotional_intensity IS '情感强度 0.0-1.0';


--
-- Name: COLUMN plot_analysis.emotional_curve; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.emotional_curve IS '情感曲线: {start: 0.3, middle: 0.7, end: 0.5}';


--
-- Name: COLUMN plot_analysis.hooks; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.hooks IS '钩子列表 - 吸引读者的元素: [
        {
            "type": "悬念|情感|冲突|认知",
            "content": "具体内容",
            "strength": 8,
            "position": "开头|中段|结尾"
        }
    ]';


--
-- Name: COLUMN plot_analysis.hooks_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.hooks_count IS '钩子数量';


--
-- Name: COLUMN plot_analysis.hooks_avg_strength; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.hooks_avg_strength IS '钩子平均强度';


--
-- Name: COLUMN plot_analysis.foreshadows; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.foreshadows IS '伏笔列表: [
        {
            "content": "伏笔内容",
            "type": "planted|resolved",
            "strength": 7,
            "subtlety": 8,
            "reference_chapter": 3
        }
    ]';


--
-- Name: COLUMN plot_analysis.foreshadows_planted; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.foreshadows_planted IS '本章埋下的伏笔数量';


--
-- Name: COLUMN plot_analysis.foreshadows_resolved; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.foreshadows_resolved IS '本章回收的伏笔数量';


--
-- Name: COLUMN plot_analysis.plot_points; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.plot_points IS '情节点列表: [
        {
            "content": "情节点描述",
            "importance": 0.9,
            "type": "revelation|conflict|resolution|transition",
            "impact": "对故事的影响描述"
        }
    ]';


--
-- Name: COLUMN plot_analysis.plot_points_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.plot_points_count IS '情节点数量';


--
-- Name: COLUMN plot_analysis.character_states; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.character_states IS '角色状态变化: [
        {
            "character_id": "xxx",
            "character_name": "张三",
            "state_before": "犹豫不决",
            "state_after": "坚定信念",
            "psychological_change": "内心描述",
            "key_event": "触发事件",
            "relationship_changes": {"李四": "关系变化"}
        }
    ]';


--
-- Name: COLUMN plot_analysis.scenes; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.scenes IS '场景列表: [{location: ''地点'', atmosphere: ''氛围'', duration: ''时长''}]';


--
-- Name: COLUMN plot_analysis.pacing; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.pacing IS '节奏: slow|moderate|fast|varied';


--
-- Name: COLUMN plot_analysis.overall_quality_score; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.overall_quality_score IS '整体质量评分 0.0-10.0';


--
-- Name: COLUMN plot_analysis.pacing_score; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.pacing_score IS '节奏评分 0.0-10.0';


--
-- Name: COLUMN plot_analysis.engagement_score; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.engagement_score IS '吸引力评分 0.0-10.0';


--
-- Name: COLUMN plot_analysis.coherence_score; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.coherence_score IS '连贯性评分 0.0-10.0';


--
-- Name: COLUMN plot_analysis.analysis_report; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.analysis_report IS '完整的文字分析报告';


--
-- Name: COLUMN plot_analysis.suggestions; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.suggestions IS '改进建议列表: [''建议1'', ''建议2'']';


--
-- Name: COLUMN plot_analysis.word_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.word_count IS '章节字数';


--
-- Name: COLUMN plot_analysis.dialogue_ratio; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.dialogue_ratio IS '对话占比 0.0-1.0';


--
-- Name: COLUMN plot_analysis.description_ratio; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.description_ratio IS '描写占比 0.0-1.0';


--
-- Name: COLUMN plot_analysis.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.plot_analysis.created_at IS '分析时间';


--
-- Name: project_default_styles; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.project_default_styles (
    id integer NOT NULL,
    project_id character varying(36) NOT NULL,
    style_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.project_default_styles OWNER TO mumuai;

--
-- Name: COLUMN project_default_styles.project_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.project_default_styles.project_id IS '项目ID';


--
-- Name: COLUMN project_default_styles.style_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.project_default_styles.style_id IS '风格ID';


--
-- Name: COLUMN project_default_styles.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.project_default_styles.created_at IS '创建时间';


--
-- Name: COLUMN project_default_styles.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.project_default_styles.updated_at IS '更新时间';


--
-- Name: project_default_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: mumuai
--

CREATE SEQUENCE public.project_default_styles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_default_styles_id_seq OWNER TO mumuai;

--
-- Name: project_default_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mumuai
--

ALTER SEQUENCE public.project_default_styles_id_seq OWNED BY public.project_default_styles.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.projects (
    id character varying(36) NOT NULL,
    user_id character varying(100) NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    theme text,
    genre character varying(50),
    target_words integer,
    current_words integer,
    status character varying(20),
    wizard_status character varying(20),
    wizard_step integer,
    outline_mode character varying(20) NOT NULL,
    world_time_period text,
    world_location text,
    world_atmosphere text,
    world_rules text,
    chapter_count integer,
    narrative_perspective character varying(50),
    character_count integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    cover_image_url character varying(1000),
    cover_prompt text,
    cover_status character varying(20) DEFAULT 'none'::character varying NOT NULL,
    cover_error text,
    cover_updated_at timestamp without time zone,
    world_climate text,
    world_clothing text,
    CONSTRAINT check_outline_mode CHECK (((outline_mode)::text = ANY (ARRAY[('one-to-one'::character varying)::text, ('one-to-many'::character varying)::text])))
);


ALTER TABLE public.projects OWNER TO mumuai;

--
-- Name: COLUMN projects.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.user_id IS '用户ID';


--
-- Name: COLUMN projects.title; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.title IS '项目标题';


--
-- Name: COLUMN projects.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.description IS '项目简介';


--
-- Name: COLUMN projects.theme; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.theme IS '主题';


--
-- Name: COLUMN projects.genre; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.genre IS '小说类型';


--
-- Name: COLUMN projects.target_words; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.target_words IS '目标字数';


--
-- Name: COLUMN projects.current_words; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.current_words IS '当前字数';


--
-- Name: COLUMN projects.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.status IS '创作状态';


--
-- Name: COLUMN projects.wizard_status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.wizard_status IS '向导完成状态: incomplete/completed';


--
-- Name: COLUMN projects.wizard_step; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.wizard_step IS '向导当前步骤: 0-4';


--
-- Name: COLUMN projects.outline_mode; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.outline_mode IS '大纲章节模式: one-to-one(传统模式) 或 one-to-many(细化模式)';


--
-- Name: COLUMN projects.world_time_period; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.world_time_period IS '时间背景';


--
-- Name: COLUMN projects.world_location; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.world_location IS '地理位置';


--
-- Name: COLUMN projects.world_atmosphere; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.world_atmosphere IS '氛围基调';


--
-- Name: COLUMN projects.world_rules; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.world_rules IS '世界规则';


--
-- Name: COLUMN projects.chapter_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.chapter_count IS '章节数量';


--
-- Name: COLUMN projects.narrative_perspective; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.narrative_perspective IS '叙事视角：first_person/third_person/omniscient';


--
-- Name: COLUMN projects.character_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.character_count IS '角色数量';


--
-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.created_at IS '创建时间';


--
-- Name: COLUMN projects.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.updated_at IS '更新时间';


--
-- Name: COLUMN projects.cover_image_url; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.cover_image_url IS '封面图片访问地址';


--
-- Name: COLUMN projects.cover_prompt; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.cover_prompt IS '最近一次生成封面使用的提示词';


--
-- Name: COLUMN projects.cover_status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.cover_status IS '封面状态: none/generating/ready/failed';


--
-- Name: COLUMN projects.cover_error; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.cover_error IS '最近一次封面生成失败原因';


--
-- Name: COLUMN projects.cover_updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.cover_updated_at IS '最近一次封面生成成功时间';


--
-- Name: COLUMN projects.world_climate; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.world_climate IS '气候设定';


--
-- Name: COLUMN projects.world_clothing; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.projects.world_clothing IS '服装设定';


--
-- Name: prompt_submissions; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.prompt_submissions (
    id character varying(36) NOT NULL,
    submitter_id character varying(255) NOT NULL,
    submitter_name character varying(100),
    source_instance character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    prompt_content text NOT NULL,
    category character varying(50),
    tags json,
    author_display_name character varying(100),
    is_anonymous boolean,
    status character varying(20),
    reviewer_id character varying(100),
    review_note text,
    reviewed_at timestamp without time zone,
    workshop_item_id character varying(36),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.prompt_submissions OWNER TO mumuai;

--
-- Name: COLUMN prompt_submissions.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.id IS 'UUID';


--
-- Name: COLUMN prompt_submissions.submitter_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.submitter_id IS '提交者标识（实例ID:用户ID）';


--
-- Name: COLUMN prompt_submissions.submitter_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.submitter_name IS '提交者显示名称';


--
-- Name: COLUMN prompt_submissions.source_instance; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.source_instance IS '来源实例标识';


--
-- Name: COLUMN prompt_submissions.name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.name IS '提示词名称';


--
-- Name: COLUMN prompt_submissions.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.description IS '提示词描述';


--
-- Name: COLUMN prompt_submissions.prompt_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.prompt_content IS '提示词内容';


--
-- Name: COLUMN prompt_submissions.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.category IS '分类';


--
-- Name: COLUMN prompt_submissions.tags; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.tags IS '标签数组';


--
-- Name: COLUMN prompt_submissions.author_display_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.author_display_name IS '希望显示的作者名';


--
-- Name: COLUMN prompt_submissions.is_anonymous; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.is_anonymous IS '是否匿名发布';


--
-- Name: COLUMN prompt_submissions.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.status IS '状态：pending/approved/rejected';


--
-- Name: COLUMN prompt_submissions.reviewer_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.reviewer_id IS '审核人ID（云端管理员）';


--
-- Name: COLUMN prompt_submissions.review_note; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.review_note IS '审核备注（拒绝理由等）';


--
-- Name: COLUMN prompt_submissions.reviewed_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.reviewed_at IS '审核时间';


--
-- Name: COLUMN prompt_submissions.workshop_item_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.workshop_item_id IS '审核通过后关联的工坊条目ID';


--
-- Name: COLUMN prompt_submissions.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.created_at IS '创建时间';


--
-- Name: COLUMN prompt_submissions.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_submissions.updated_at IS '更新时间';


--
-- Name: prompt_templates; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.prompt_templates (
    id character varying(36) NOT NULL,
    user_id character varying(50) NOT NULL,
    template_key character varying(100) NOT NULL,
    template_name character varying(200) NOT NULL,
    template_content text NOT NULL,
    description text,
    category character varying(50),
    parameters text,
    is_active boolean,
    is_system_default boolean,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.prompt_templates OWNER TO mumuai;

--
-- Name: COLUMN prompt_templates.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.user_id IS '用户ID';


--
-- Name: COLUMN prompt_templates.template_key; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.template_key IS '模板键名';


--
-- Name: COLUMN prompt_templates.template_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.template_name IS '模板显示名称';


--
-- Name: COLUMN prompt_templates.template_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.template_content IS '模板内容';


--
-- Name: COLUMN prompt_templates.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.description IS '模板描述';


--
-- Name: COLUMN prompt_templates.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.category IS '模板分类';


--
-- Name: COLUMN prompt_templates.parameters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.parameters IS '模板参数定义(JSON)';


--
-- Name: COLUMN prompt_templates.is_active; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.is_active IS '是否启用';


--
-- Name: COLUMN prompt_templates.is_system_default; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.is_system_default IS '是否为系统默认模板';


--
-- Name: COLUMN prompt_templates.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.created_at IS '创建时间';


--
-- Name: COLUMN prompt_templates.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_templates.updated_at IS '更新时间';


--
-- Name: prompt_workshop_items; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.prompt_workshop_items (
    id character varying(36) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    prompt_content text NOT NULL,
    category character varying(50),
    tags json,
    author_id character varying(255),
    author_name character varying(100),
    source_instance character varying(255),
    is_official boolean,
    download_count integer,
    like_count integer,
    status character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.prompt_workshop_items OWNER TO mumuai;

--
-- Name: COLUMN prompt_workshop_items.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.id IS 'UUID';


--
-- Name: COLUMN prompt_workshop_items.name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.name IS '提示词名称';


--
-- Name: COLUMN prompt_workshop_items.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.description IS '提示词描述';


--
-- Name: COLUMN prompt_workshop_items.prompt_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.prompt_content IS '提示词内容';


--
-- Name: COLUMN prompt_workshop_items.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.category IS '分类';


--
-- Name: COLUMN prompt_workshop_items.tags; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.tags IS '标签数组';


--
-- Name: COLUMN prompt_workshop_items.author_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.author_id IS '作者用户标识（实例ID:用户ID）';


--
-- Name: COLUMN prompt_workshop_items.author_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.author_name IS '作者显示名称';


--
-- Name: COLUMN prompt_workshop_items.source_instance; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.source_instance IS '来源实例标识';


--
-- Name: COLUMN prompt_workshop_items.is_official; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.is_official IS '是否官方提示词';


--
-- Name: COLUMN prompt_workshop_items.download_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.download_count IS '下载/导入次数';


--
-- Name: COLUMN prompt_workshop_items.like_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.like_count IS '点赞数';


--
-- Name: COLUMN prompt_workshop_items.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.status IS '状态：active/hidden/deprecated';


--
-- Name: COLUMN prompt_workshop_items.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.created_at IS '创建时间';


--
-- Name: COLUMN prompt_workshop_items.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_items.updated_at IS '更新时间';


--
-- Name: prompt_workshop_likes; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.prompt_workshop_likes (
    id character varying(36) NOT NULL,
    user_identifier character varying(255) NOT NULL,
    workshop_item_id character varying(36) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.prompt_workshop_likes OWNER TO mumuai;

--
-- Name: COLUMN prompt_workshop_likes.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_likes.id IS 'UUID';


--
-- Name: COLUMN prompt_workshop_likes.user_identifier; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_likes.user_identifier IS '用户标识（实例ID:用户ID）';


--
-- Name: COLUMN prompt_workshop_likes.workshop_item_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_likes.workshop_item_id IS '工坊条目ID';


--
-- Name: COLUMN prompt_workshop_likes.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.prompt_workshop_likes.created_at IS '创建时间';


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.refresh_tokens (
    id character varying(36) NOT NULL,
    user_id character varying(100) NOT NULL,
    token_hash character varying(128) NOT NULL,
    device_info character varying(500),
    ip_network character varying(45),
    created_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    last_used_at timestamp with time zone,
    is_revoked boolean NOT NULL,
    replaced_by character varying(36)
);


ALTER TABLE public.refresh_tokens OWNER TO mumuai;

--
-- Name: COLUMN refresh_tokens.id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.id IS 'UUID';


--
-- Name: COLUMN refresh_tokens.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.user_id IS '用户ID';


--
-- Name: COLUMN refresh_tokens.token_hash; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.token_hash IS 'Token SHA-256 哈希';


--
-- Name: COLUMN refresh_tokens.device_info; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.device_info IS '设备信息摘要';


--
-- Name: COLUMN refresh_tokens.ip_network; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.ip_network IS 'IP网段';


--
-- Name: COLUMN refresh_tokens.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.created_at IS '创建时间';


--
-- Name: COLUMN refresh_tokens.expires_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.expires_at IS '过期时间';


--
-- Name: COLUMN refresh_tokens.last_used_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.last_used_at IS '最后使用时间';


--
-- Name: COLUMN refresh_tokens.is_revoked; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.is_revoked IS '是否已吊销';


--
-- Name: COLUMN refresh_tokens.replaced_by; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.refresh_tokens.replaced_by IS '被哪个token轮换';


--
-- Name: regeneration_tasks; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.regeneration_tasks (
    id character varying(36) NOT NULL,
    chapter_id character varying(36) NOT NULL,
    analysis_id character varying(36),
    user_id character varying(50) NOT NULL,
    project_id character varying(36) NOT NULL,
    modification_instructions text NOT NULL,
    original_suggestions json,
    selected_suggestion_indices json,
    custom_instructions text,
    style_id integer,
    target_word_count integer,
    focus_areas json,
    preserve_elements json,
    status character varying(20),
    progress integer,
    error_message text,
    original_content text,
    original_word_count integer,
    regenerated_content text,
    regenerated_word_count integer,
    version_number integer,
    version_note character varying(500),
    created_at timestamp without time zone DEFAULT now(),
    started_at timestamp without time zone,
    completed_at timestamp without time zone
);


ALTER TABLE public.regeneration_tasks OWNER TO mumuai;

--
-- Name: COLUMN regeneration_tasks.analysis_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.analysis_id IS '关联的分析结果ID';


--
-- Name: COLUMN regeneration_tasks.modification_instructions; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.modification_instructions IS '综合修改指令';


--
-- Name: COLUMN regeneration_tasks.original_suggestions; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.original_suggestions IS '来自分析的原始建议列表';


--
-- Name: COLUMN regeneration_tasks.selected_suggestion_indices; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.selected_suggestion_indices IS '用户选择的建议索引';


--
-- Name: COLUMN regeneration_tasks.custom_instructions; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.custom_instructions IS '用户自定义修改意见';


--
-- Name: COLUMN regeneration_tasks.style_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.style_id IS '写作风格ID';


--
-- Name: COLUMN regeneration_tasks.target_word_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.target_word_count IS '目标字数';


--
-- Name: COLUMN regeneration_tasks.focus_areas; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.focus_areas IS '重点优化方向';


--
-- Name: COLUMN regeneration_tasks.preserve_elements; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.preserve_elements IS '需要保留的元素配置';


--
-- Name: COLUMN regeneration_tasks.status; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.status IS 'pending/running/completed/failed';


--
-- Name: COLUMN regeneration_tasks.progress; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.progress IS '进度 0-100';


--
-- Name: COLUMN regeneration_tasks.original_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.original_content IS '原始章节内容快照';


--
-- Name: COLUMN regeneration_tasks.original_word_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.original_word_count IS '原始字数';


--
-- Name: COLUMN regeneration_tasks.regenerated_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.regenerated_content IS '重新生成的内容';


--
-- Name: COLUMN regeneration_tasks.regenerated_word_count; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.regenerated_word_count IS '新内容字数';


--
-- Name: COLUMN regeneration_tasks.version_number; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.version_number IS '版本号';


--
-- Name: COLUMN regeneration_tasks.version_note; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.regeneration_tasks.version_note IS '版本说明';


--
-- Name: relationship_types; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.relationship_types (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    category character varying(20) NOT NULL,
    reverse_name character varying(50),
    intimacy_range character varying(20),
    icon character varying(50),
    description text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.relationship_types OWNER TO mumuai;

--
-- Name: COLUMN relationship_types.name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.name IS '关系名称';


--
-- Name: COLUMN relationship_types.category; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.category IS '分类：family/social/hostile/professional';


--
-- Name: COLUMN relationship_types.reverse_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.reverse_name IS '反向关系名称';


--
-- Name: COLUMN relationship_types.intimacy_range; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.intimacy_range IS '亲密度范围：high/medium/low';


--
-- Name: COLUMN relationship_types.icon; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.icon IS '图标标识';


--
-- Name: COLUMN relationship_types.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.description IS '关系描述';


--
-- Name: COLUMN relationship_types.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.relationship_types.created_at IS '创建时间';


--
-- Name: relationship_types_id_seq; Type: SEQUENCE; Schema: public; Owner: mumuai
--

CREATE SEQUENCE public.relationship_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.relationship_types_id_seq OWNER TO mumuai;

--
-- Name: relationship_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mumuai
--

ALTER SEQUENCE public.relationship_types_id_seq OWNED BY public.relationship_types.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.settings (
    id character varying(36) NOT NULL,
    user_id character varying(50) NOT NULL,
    api_provider character varying(50),
    api_key character varying(500),
    api_base_url character varying(500),
    llm_model character varying(100),
    temperature double precision,
    max_tokens integer,
    preferences text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    system_prompt text,
    cover_api_provider character varying(50),
    cover_api_key character varying(500),
    cover_api_base_url character varying(500),
    cover_image_model character varying(100),
    cover_enabled boolean DEFAULT false NOT NULL,
    smtp_provider character varying(50) DEFAULT 'qq'::character varying NOT NULL,
    smtp_host character varying(255),
    smtp_port integer DEFAULT 465 NOT NULL,
    smtp_username character varying(255),
    smtp_password character varying(500),
    smtp_use_tls boolean DEFAULT false NOT NULL,
    smtp_use_ssl boolean DEFAULT true NOT NULL,
    smtp_from_email character varying(255),
    smtp_from_name character varying(255) DEFAULT 'MuMuAINovel'::character varying NOT NULL,
    email_auth_enabled boolean DEFAULT true NOT NULL,
    email_register_enabled boolean DEFAULT true NOT NULL,
    verification_code_ttl_minutes integer DEFAULT 10 NOT NULL,
    verification_resend_interval_seconds integer DEFAULT 60 NOT NULL
);


ALTER TABLE public.settings OWNER TO mumuai;

--
-- Name: COLUMN settings.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.user_id IS '用户ID';


--
-- Name: COLUMN settings.api_provider; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.api_provider IS 'API提供商';


--
-- Name: COLUMN settings.api_key; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.api_key IS 'API密钥';


--
-- Name: COLUMN settings.api_base_url; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.api_base_url IS '自定义API地址';


--
-- Name: COLUMN settings.llm_model; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.llm_model IS '模型名称';


--
-- Name: COLUMN settings.temperature; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.temperature IS '温度参数';


--
-- Name: COLUMN settings.max_tokens; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.max_tokens IS '最大token数';


--
-- Name: COLUMN settings.preferences; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.preferences IS '其他偏好设置(JSON)';


--
-- Name: COLUMN settings.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.created_at IS '创建时间';


--
-- Name: COLUMN settings.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.updated_at IS '更新时间';


--
-- Name: COLUMN settings.system_prompt; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.system_prompt IS '系统级别提示词，每次AI调用都会使用';


--
-- Name: COLUMN settings.cover_api_provider; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.cover_api_provider IS '封面图片API提供商';


--
-- Name: COLUMN settings.cover_api_key; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.cover_api_key IS '封面图片API密钥';


--
-- Name: COLUMN settings.cover_api_base_url; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.cover_api_base_url IS '封面图片自定义API地址';


--
-- Name: COLUMN settings.cover_image_model; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.cover_image_model IS '封面图片模型名称';


--
-- Name: COLUMN settings.cover_enabled; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.cover_enabled IS '是否启用封面图片生成';


--
-- Name: COLUMN settings.smtp_provider; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_provider IS 'SMTP 提供商';


--
-- Name: COLUMN settings.smtp_host; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_host IS 'SMTP 主机';


--
-- Name: COLUMN settings.smtp_port; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_port IS 'SMTP 端口';


--
-- Name: COLUMN settings.smtp_username; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_username IS 'SMTP 用户名';


--
-- Name: COLUMN settings.smtp_password; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_password IS 'SMTP 密码或授权码';


--
-- Name: COLUMN settings.smtp_use_tls; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_use_tls IS '是否启用 TLS';


--
-- Name: COLUMN settings.smtp_use_ssl; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_use_ssl IS '是否启用 SSL';


--
-- Name: COLUMN settings.smtp_from_email; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_from_email IS '发件人邮箱';


--
-- Name: COLUMN settings.smtp_from_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.smtp_from_name IS '发件人名称';


--
-- Name: COLUMN settings.email_auth_enabled; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.email_auth_enabled IS '是否启用邮箱认证';


--
-- Name: COLUMN settings.email_register_enabled; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.email_register_enabled IS '是否启用邮箱注册';


--
-- Name: COLUMN settings.verification_code_ttl_minutes; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.verification_code_ttl_minutes IS '验证码有效期（分钟）';


--
-- Name: COLUMN settings.verification_resend_interval_seconds; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.settings.verification_resend_interval_seconds IS '验证码重发间隔（秒）';


--
-- Name: story_memories; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.story_memories (
    id character varying(100) NOT NULL,
    project_id character varying(36) NOT NULL,
    chapter_id character varying(36),
    memory_type character varying(50) NOT NULL,
    title character varying(200),
    content text NOT NULL,
    full_context text,
    related_characters json,
    related_locations json,
    tags json,
    importance_score double precision,
    story_timeline integer NOT NULL,
    chapter_position integer,
    text_length integer,
    is_foreshadow integer,
    foreshadow_resolved_at character varying(100),
    foreshadow_strength double precision,
    vector_id character varying(100),
    embedding_model character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.story_memories OWNER TO mumuai;

--
-- Name: COLUMN story_memories.memory_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.memory_type IS '
    记忆类型:
    - plot_point: 情节点
    - character_event: 角色事件
    - world_detail: 世界观细节
    - hook: 钩子(悬念/冲突)
    - foreshadow: 伏笔
    - dialogue: 重要对话
    - scene: 场景描写
    ';


--
-- Name: COLUMN story_memories.title; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.title IS '记忆标题/简述';


--
-- Name: COLUMN story_memories.content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.content IS '记忆内容摘要(100-500字)';


--
-- Name: COLUMN story_memories.full_context; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.full_context IS '完整上下文(可选,用于详细记录)';


--
-- Name: COLUMN story_memories.related_characters; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.related_characters IS '涉及角色ID列表: [''char_id_1'', ''char_id_2'']';


--
-- Name: COLUMN story_memories.related_locations; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.related_locations IS '涉及地点列表: [''地点1'', ''地点2'']';


--
-- Name: COLUMN story_memories.tags; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.tags IS '标签列表: [''悬念'', ''转折'', ''伏笔'', ''高潮'']';


--
-- Name: COLUMN story_memories.importance_score; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.importance_score IS '重要性评分 0.0-1.0';


--
-- Name: COLUMN story_memories.story_timeline; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.story_timeline IS '故事时间线位置(章节序号)';


--
-- Name: COLUMN story_memories.chapter_position; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.chapter_position IS '章节内位置(字符位置)';


--
-- Name: COLUMN story_memories.text_length; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.text_length IS '文本长度(字符数)';


--
-- Name: COLUMN story_memories.is_foreshadow; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.is_foreshadow IS '伏笔状态: 0=普通记忆, 1=已埋下伏笔, 2=伏笔已回收';


--
-- Name: COLUMN story_memories.foreshadow_resolved_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.foreshadow_resolved_at IS '伏笔回收的章节ID';


--
-- Name: COLUMN story_memories.foreshadow_strength; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.foreshadow_strength IS '伏笔强度 0.0-1.0';


--
-- Name: COLUMN story_memories.vector_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.vector_id IS '向量数据库中的唯一ID';


--
-- Name: COLUMN story_memories.embedding_model; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.embedding_model IS '使用的embedding模型';


--
-- Name: COLUMN story_memories.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.created_at IS '创建时间';


--
-- Name: COLUMN story_memories.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.story_memories.updated_at IS '更新时间';


--
-- Name: user_passwords; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.user_passwords (
    user_id character varying(100) NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    has_custom_password boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_passwords OWNER TO mumuai;

--
-- Name: COLUMN user_passwords.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.user_passwords.user_id IS '用户ID';


--
-- Name: COLUMN user_passwords.username; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.user_passwords.username IS '用户名';


--
-- Name: COLUMN user_passwords.password_hash; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.user_passwords.password_hash IS '密码哈希';


--
-- Name: COLUMN user_passwords.has_custom_password; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.user_passwords.has_custom_password IS '是否为自定义密码';


--
-- Name: COLUMN user_passwords.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.user_passwords.created_at IS '创建时间';


--
-- Name: COLUMN user_passwords.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.user_passwords.updated_at IS '更新时间';


--
-- Name: users; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.users (
    user_id character varying(100) NOT NULL,
    username character varying(100) NOT NULL,
    display_name character varying(200) NOT NULL,
    avatar_url character varying(500),
    trust_level integer,
    is_admin boolean,
    linuxdo_id character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    last_login timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO mumuai;

--
-- Name: COLUMN users.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.user_id IS '用户ID，格式：linuxdo_{id} 或 local_{id}';


--
-- Name: COLUMN users.username; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.username IS '用户名';


--
-- Name: COLUMN users.display_name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.display_name IS '显示名称';


--
-- Name: COLUMN users.avatar_url; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.avatar_url IS '头像URL';


--
-- Name: COLUMN users.trust_level; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.trust_level IS '信任等级（仅用于显示）';


--
-- Name: COLUMN users.is_admin; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.is_admin IS '是否为管理员';


--
-- Name: COLUMN users.linuxdo_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.linuxdo_id IS 'LinuxDO用户ID或本地用户ID';


--
-- Name: COLUMN users.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.created_at IS '创建时间';


--
-- Name: COLUMN users.last_login; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.users.last_login IS '最后登录时间';


--
-- Name: writing_styles; Type: TABLE; Schema: public; Owner: mumuai
--

CREATE TABLE public.writing_styles (
    id integer NOT NULL,
    user_id character varying(255),
    name character varying(100) NOT NULL,
    style_type character varying(50) NOT NULL,
    preset_id character varying(50),
    description text,
    prompt_content text NOT NULL,
    order_index integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.writing_styles OWNER TO mumuai;

--
-- Name: COLUMN writing_styles.user_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.user_id IS '所属用户ID（NULL表示全局预设风格）';


--
-- Name: COLUMN writing_styles.name; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.name IS '风格名称';


--
-- Name: COLUMN writing_styles.style_type; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.style_type IS '风格类型：preset/custom';


--
-- Name: COLUMN writing_styles.preset_id; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.preset_id IS '预设风格ID：natural/classical/modern等';


--
-- Name: COLUMN writing_styles.description; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.description IS '风格描述';


--
-- Name: COLUMN writing_styles.prompt_content; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.prompt_content IS '风格提示词内容';


--
-- Name: COLUMN writing_styles.order_index; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.order_index IS '排序序号';


--
-- Name: COLUMN writing_styles.created_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.created_at IS '创建时间';


--
-- Name: COLUMN writing_styles.updated_at; Type: COMMENT; Schema: public; Owner: mumuai
--

COMMENT ON COLUMN public.writing_styles.updated_at IS '更新时间';


--
-- Name: writing_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: mumuai
--

CREATE SEQUENCE public.writing_styles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.writing_styles_id_seq OWNER TO mumuai;

--
-- Name: writing_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mumuai
--

ALTER SEQUENCE public.writing_styles_id_seq OWNED BY public.writing_styles.id;


--
-- Name: project_default_styles id; Type: DEFAULT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.project_default_styles ALTER COLUMN id SET DEFAULT nextval('public.project_default_styles_id_seq'::regclass);


--
-- Name: relationship_types id; Type: DEFAULT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.relationship_types ALTER COLUMN id SET DEFAULT nextval('public.relationship_types_id_seq'::regclass);


--
-- Name: writing_styles id; Type: DEFAULT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.writing_styles ALTER COLUMN id SET DEFAULT nextval('public.writing_styles_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.alembic_version (version_num) FROM stdin;
b8e9f0a1c2d3
\.


--
-- Data for Name: analysis_tasks; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.analysis_tasks (id, chapter_id, user_id, project_id, status, progress, error_message, created_at, started_at, completed_at) FROM stdin;
9f5a2e49-9910-4934-be44-7d83bd8b9f6a	9ad1ee72-1357-48e5-a162-cf2d304c65d5	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 22:16:01.292776	2026-08-06 14:16:01.35469	2026-08-06 14:18:28.274759
2ff52179-8f57-4908-82eb-8f4780e79a52	c0a34e67-01f7-49c3-92cf-986d9824453b	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	failed	0	服务重启，章节分析任务已中断	2026-08-07 11:17:30.909732	2026-08-07 03:17:30.916161	2026-08-13 05:03:08.994062
dfb63161-2dcf-4d78-b910-2ba4dae7122d	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 15:30:32.010878	2026-08-06 07:32:26.261737	2026-08-06 07:35:22.066844
55aee8fb-b9fc-44e8-9873-5b74cecdf5ac	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 15:37:29.940401	2026-08-06 07:37:29.943387	2026-08-06 07:40:30.307756
cddf98ad-cd25-4b86-a80f-f2e46cc4a4cd	261ee431-2b9d-4544-842d-31cb2d054d48	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 11:05:41.865999	2026-08-07 03:05:41.870348	2026-08-07 03:07:59.343304
490e7da4-3507-459c-be66-72f05a43643b	9ad1ee72-1357-48e5-a162-cf2d304c65d5	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 22:50:07.979241	2026-08-06 14:51:06.789361	2026-08-06 14:53:40.541987
dc94e412-1ce3-4c30-9bd8-bf05c5adcf32	ec671aae-e1fd-466e-a27f-de111643114e	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 11:09:40.061222	2026-08-07 03:09:40.068794	2026-08-07 03:12:30.360918
7f9fc54c-0611-48f1-bc61-fe24c624fe14	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 15:42:19.898606	2026-08-06 07:45:26.089449	2026-08-06 07:47:58.853966
fc8bf162-922e-4db5-890b-7d7d8ac1fc40	72191e56-643e-49a5-9216-78a08f6e1494	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 10:08:33.75696	2026-08-07 02:10:27.025879	2026-08-07 02:12:40.726849
11a9d67f-983a-42cf-a8de-dc51dcc2352f	acbd6ad5-1740-432c-93ea-3ab0fe331b18	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 11:13:57.060648	2026-08-07 03:13:57.065498	2026-08-07 03:15:47.501524
8ca9c3e4-e146-422a-a686-d71f16ca8a6e	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 00:29:20.971493	2026-08-06 16:29:23.996288	2026-08-06 16:31:39.706622
e3a5ac7d-ee2e-4f2c-9834-6300950674ad	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-16 22:44:02.466721	2026-08-16 14:44:05.486347	2026-08-16 14:45:59.651853
26bdf42f-e5e3-4a50-b1c9-c2e2dd4063ae	88f367b9-7962-46c7-b75e-9f4924ba0f70	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 00:34:19.797904	2026-08-06 16:34:22.823652	2026-08-06 16:36:36.001911
eba9af13-5d79-4d25-aa90-996541dd4ce1	72191e56-643e-49a5-9216-78a08f6e1494	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 10:24:10.058158	2026-08-07 02:24:13.082103	2026-08-07 02:26:16.593317
5a5bd1ba-ef71-4ff1-8d42-b0c64fb782a2	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	failed	10	章节不存在或内容为空	2026-08-24 01:23:43.016078	2026-08-23 17:23:43.080836	2026-08-23 17:23:43.08429
63404dbb-19c6-42fb-83dc-214647d8d784	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	failed	35	AI分析失败，请检查日志	2026-08-16 22:15:47.007533	2026-08-16 14:15:50.294528	2026-08-16 14:15:54.881583
7dbd798e-aa0b-4e82-ac7c-ecd5e4c24e89	214ed068-75b2-477d-ae83-d83ae98afb96	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 10:58:33.234021	2026-08-07 02:58:33.241428	2026-08-07 03:03:46.841047
c2b3eca5-9bd9-4867-86ce-6da74cf0ceb7	9ad1ee72-1357-48e5-a162-cf2d304c65d5	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	failed	35	AI分析失败，请检查日志	2026-08-06 17:00:45.887515	2026-08-06 10:26:58.918587	2026-08-06 10:27:59.786151
3cc2e4e6-4670-4fc5-a403-8bae29fa3876	9dc2adf5-8afa-4116-a98e-e481ecd4c427	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 00:48:58.055913	2026-08-06 16:49:01.070814	2026-08-06 16:49:36.55647
a675800d-43a5-47ec-a4a1-dea7f29d83c2	9ad1ee72-1357-48e5-a162-cf2d304c65d5	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	failed	35	AI分析失败，请检查日志	2026-08-06 22:26:55.215639	2026-08-06 14:28:51.593978	2026-08-06 14:29:51.446847
cc6895ae-0468-4585-9c7a-37a303e11cce	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 23:06:37.999088	2026-08-06 15:06:41.018545	2026-08-06 15:07:36.472308
e74dbeff-78d3-436b-85e2-e7d5f376d180	72191e56-643e-49a5-9216-78a08f6e1494	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 10:19:56.040011	2026-08-07 02:19:59.058453	2026-08-07 02:21:38.773906
3032e244-12b8-4d54-928a-71326e0acdd1	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	failed	35	AI分析失败，请检查日志	2026-08-16 22:42:40.573518	2026-08-16 14:42:43.962817	2026-08-16 14:42:48.575321
d21d030e-2f85-4c06-898b-dc059b270a07	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-06 23:12:24.854816	2026-08-06 15:12:27.877231	2026-08-06 15:14:20.137027
19a8f8bc-c270-4f51-965f-193875e55f1e	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-16 23:07:05.533453	2026-08-16 15:07:08.559474	2026-08-16 15:10:05.480206
c879a970-81ea-43dd-903d-963c371d6bb4	9dc2adf5-8afa-4116-a98e-e481ecd4c427	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	completed	100	\N	2026-08-07 00:43:45.628221	2026-08-06 16:43:48.64712	2026-08-06 16:46:00.154182
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.announcements (id, title, content, summary, level, status, pinned, author_id, author_name, publish_at, expire_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: background_tasks; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.background_tasks (id, user_id, project_id, task_type, status, progress, status_message, task_input, task_result, error_message, progress_details, cancel_requested, retry_count, max_retries, created_at, started_at, completed_at, updated_at) FROM stdin;
c2d0ff87-a3ab-40f3-845b-c293f259b906	local_21232f297a57a5a7	d59e468a-8617-41e0-aabf-87a13be78834	chapter_regenerate_from_position	completed	100	已从第52章起重新生成 3 章	{"chapter_id": "f076074b-309b-4dbd-8ae5-be35c8f5fa10", "target_chapter_count": 3, "expansion_strategy": "balanced", "provider": null, "model": null}	{"start_chapter_number": 52, "generated_chapter_count": 3, "generated_chapters": [{"chapter_number": 52, "title": "\\u547d\\u60ac\\u4e00\\u7ebf", "summary": "\\u5f20\\u7fbd\\u4e3b\\u52a8\\u8d70\\u5411\\u796d\\u575b\\u4e2d\\u592e\\uff0c\\u5206\\u7075\\u951a\\u4e3b\\u8282\\u70b9\\u611f\\u5e94\\u5230\\u4ed6\\u4f53\\u5185\\u9690\\u7075\\u6839\\u7684\\u7279\\u6b8a\\u5171\\u9e23\\uff0c\\u77ac\\u95f4\\u7206\\u53d1\\u51fa\\u5f3a\\u5927\\u7684\\u5438\\u529b\\u3002\\u5f20\\u7fbd\\u611f\\u89c9\\u81ea\\u5df1\\u7684\\u795e\\u9b42\\u4eff\\u4f5b\\u88ab\\u4e00\\u53ea\\u65e0\\u5f62\\u5de8\\u624b\\u6495\\u626f\\uff0c\\u5267\\u75db\\u4e4b\\u4e0b\\uff0c\\u4ed6\\u54ac\\u7834\\u820c\\u5c16\\u4fdd\\u6301\\u6e05\\u9192\\u3002\\u4ed6\\u610f\\u8bc6\\u5230\\u8fd9\\u5e76\\u975e\\u5355\\u7eaf\\u7684\\u7834\\u574f\\u9635\\u6cd5\\uff0c\\u800c\\u662f\\u5206\\u7075\\u951a\\u5728\\u8bd5\\u56fe\\u5c06\\u4ed6\\u4f53\\u5185\\u7684\\u4f2a\\u7075\\u6839\\u5f7b\\u5e95\\u6fc0\\u6d3b\\u5e76\\u6536\\u5272\\u3002\\u5728\\u610f\\u8bc6\\u5373\\u5c06\\u88ab\\u541e\\u566c\\u7684\\u5239\\u90a3\\uff0c\\u4ed6\\u5229\\u7528\\u68ad\\u5f62\\u7269\\u4f5c\\u4e3a\\u5a92\\u4ecb\\uff0c\\u5c06\\u81ea\\u8eab\\u610f\\u5fd7\\u5f3a\\u884c\\u704c\\u5165\\u4e3b\\u8282\\u70b9\\uff0c\\u4ee5\\u81ea\\u6bc1\\u65b9\\u5f0f\\u5728\\u9635\\u6cd5\\u6838\\u5fc3\\u5236\\u9020\\u88c2\\u75d5\\u3002\\u7136\\u800c\\u5206\\u7075\\u951a\\u7684\\u53cd\\u566c\\u529b\\u91cf\\u8fdc\\u8d85\\u60f3\\u8c61\\uff0c\\u5f20\\u7fbd\\u4e03\\u7a8d\\u6d41\\u8840\\uff0c\\u7ecf\\u8109\\u5bf8\\u65ad\\uff0c\\u9677\\u5165\\u534a\\u660f\\u8ff7\\u72b6\\u6001\\u3002\\u796d\\u575b\\u5468\\u56f4\\u7684\\u9ed1\\u5149\\u5f00\\u59cb\\u4e0d\\u7a33\\u5b9a\\u5730\\u95ea\\u70c1\\uff0c\\u6574\\u4e2a\\u796d\\u793c\\u6bbf\\u90fd\\u5728\\u5267\\u70c8\\u9707\\u52a8\\u3002"}, {"chapter_number": 53, "title": "\\u7edd\\u5883\\u53cd\\u51fb", "summary": "\\u58a8\\u6e0a\\u548c\\u82cf\\u665a\\u68e0\\u6309\\u7167\\u8ba1\\u5212\\u5728\\u5916\\u56f4\\u7b49\\u5019\\uff0c\\u542c\\u5230\\u796d\\u793c\\u6bbf\\u8b66\\u62a5\\u5927\\u4f5c\\uff0c\\u4e24\\u4eba\\u610f\\u8bc6\\u5230\\u5f20\\u7fbd\\u7684\\u884c\\u52a8\\u51fa\\u4e86\\u53d8\\u6545\\u3002\\u82cf\\u665a\\u68e0\\u4e0d\\u987e\\u58a8\\u6e0a\\u963b\\u62e6\\uff0c\\u51ed\\u501f\\u5bf9\\u836f\\u7406\\u7684\\u4e86\\u89e3\\uff0c\\u5229\\u7528\\u968f\\u8eab\\u643a\\u5e26\\u7684\\u8ff7\\u70df\\u5f39\\u5f3a\\u884c\\u51b2\\u5165\\u6df7\\u4e71\\u7684\\u796d\\u793c\\u6bbf\\uff0c\\u5728\\u574d\\u584c\\u7684\\u752c\\u9053\\u4e2d\\u627e\\u5230\\u4e86\\u534a\\u660f\\u8ff7\\u7684\\u5f20\\u7fbd\\u3002\\u58a8\\u6e0a\\u5219\\u5728\\u5916\\u56f4\\u5229\\u7528\\u5730\\u5f62\\u548c\\u6697\\u5668\\u7275\\u5236\\u8d76\\u6765\\u7684\\u5929\\u8861\\u53f8\\u6267\\u4e8b\\uff0c\\u4e3a\\u82cf\\u665a\\u68e0\\u6551\\u4eba\\u4e89\\u53d6\\u65f6\\u95f4\\u3002\\u82cf\\u665a\\u68e0\\u53d1\\u73b0\\u5f20\\u7fbd\\u4f53\\u5185\\u7075\\u6c14\\u66b4\\u8d70\\uff0c\\u7ecf\\u8109\\u53d7\\u635f\\u4e25\\u91cd\\uff0c\\u66f4\\u610f\\u5916\\u7684\\u662f\\u68ad\\u5f62\\u7269\\u5728\\u81ea\\u52a8\\u5438\\u6536\\u5206\\u7075\\u951a\\u9038\\u6563\\u7684\\u80fd\\u91cf\\uff0c\\u8fd9\\u8ba9\\u5979\\u610f\\u8bc6\\u5230\\u8fd9\\u4ef6\\u6cd5\\u5668\\u8fdc\\u6bd4\\u60f3\\u8c61\\u4e2d\\u66f4\\u52a0\\u795e\\u79d8\\u3002"}, {"chapter_number": 54, "title": "\\u4f59\\u6ce2\\u672a\\u5e73", "summary": "\\u82cf\\u665a\\u68e0\\u7d27\\u6025\\u6551\\u6cbb\\u5f20\\u7fbd\\uff0c\\u7528\\u94f6\\u9488\\u5c01\\u4f4f\\u4ed6\\u66b4\\u8d70\\u7684\\u7075\\u6c14\\uff0c\\u540c\\u65f6\\u5582\\u670d\\u4e39\\u836f\\u7a33\\u5b9a\\u4f24\\u52bf\\u3002\\u5f20\\u7fbd\\u5728\\u660f\\u8ff7\\u4e2d\\u610f\\u8bc6\\u6f02\\u6d41\\uff0c\\u770b\\u5230\\u4e86\\u5206\\u7075\\u951a\\u7f51\\u7edc\\u7684\\u90e8\\u5206\\u771f\\u76f8\\u2014\\u2014\\u65e0\\u6570\\u7ec6\\u5982\\u53d1\\u4e1d\\u7684\\u7075\\u8bc6\\u4e1d\\u7ebf\\u4ece\\u4e3b\\u8282\\u70b9\\u5ef6\\u4f38\\u51fa\\u53bb\\uff0c\\u8fde\\u63a5\\u7740\\u6574\\u4e2a\\u5929\\u5143\\u754c\\u7684\\u4fee\\u58eb\\uff0c\\u968f\\u7740\\u4ed6\\u4eec\\u7684\\u4fee\\u70bc\\u800c\\u7f13\\u6162\\u62bd\\u53d6\\u4e16\\u754c\\u672c\\u6e90\\u3002\\u58a8\\u6e0a\\u6210\\u529f\\u6446\\u8131\\u5929\\u8861\\u53f8\\u6267\\u4e8b\\u540e\\u4e0e\\u4e24\\u4eba\\u4f1a\\u5408\\uff0c\\u4e09\\u4eba\\u5f00\\u59cb\\u64a4\\u79bb\\u796d\\u793c\\u6bbf\\u3002\\u5f20\\u7fbd\\u77ed\\u6682\\u9192\\u6765\\uff0c\\u544a\\u8bc9\\u82cf\\u665a\\u68e0\\u548c\\u58a8\\u6e0a\\u4ed6\\u770b\\u5230\\u7684\\u666f\\u8c61\\uff0c\\u53d1\\u73b0\\u566c\\u754c\\u8005\\u7684\\u5165\\u4fb5\\u8ba1\\u5212\\u6bd4\\u60f3\\u8c61\\u4e2d\\u66f4\\u52a0\\u5e9e\\u5927\\uff0c\\u5206\\u7075\\u951a\\u7f51\\u7edc\\u5df2\\u7ecf\\u6e17\\u900f\\u5230\\u6574\\u4e2a\\u4fee\\u4ed9\\u754c\\u3002\\u610f\\u8bc6\\u5230\\u5fc5\\u987b\\u5c3d\\u5feb\\u627e\\u5230\\u5176\\u4ed6\\u76df\\u53cb\\uff0c\\u5171\\u540c\\u5bf9\\u6297\\u8fd9\\u4e2a\\u9634\\u8c0b\\u3002"}]}	\N	{"stage": "complete", "message": "\\u5df2\\u4ece\\u7b2c52\\u7ae0\\u8d77\\u91cd\\u65b0\\u751f\\u6210 3 \\u7ae0"}	f	0	3	2026-09-20 19:43:31.053265	2026-09-20 19:43:31.074806	2026-09-20 19:44:30.716867	2026-09-20 19:44:30.71968
61e562fa-2877-4b50-a142-79a0bcb4993a	local_21232f297a57a5a7	d59e468a-8617-41e0-aabf-87a13be78834	chapter_regenerate_from_position	completed	100	已从第64章起重新生成 3 章	{"chapter_id": "1c2f14e0-5007-4ea1-9db2-b58631a56da0", "target_chapter_count": 3, "expansion_strategy": "balanced", "provider": null, "model": null}	{"start_chapter_number": 64, "generated_chapter_count": 3, "generated_chapters": [{"chapter_number": 64, "title": "\\u7389\\u7b80\\u4e2d\\u7684\\u79d8\\u5bc6", "summary": "\\u67f3\\u82e5\\u971c\\u5728\\u7eed\\u9b42\\u8349\\u7684\\u4f5c\\u7528\\u4e0b\\u7ec8\\u4e8e\\u82cf\\u9192\\uff0c\\u4f46\\u8eab\\u4f53\\u4f9d\\u7136\\u865a\\u5f31\\uff0c\\u9700\\u8981\\u957f\\u671f\\u8c03\\u517b\\u3002\\u82cf\\u665a\\u68e0\\u4e3a\\u77f3\\u94c1\\u5fc3\\u68c0\\u67e5\\u6bd2\\u7d20\\uff0c\\u53d1\\u73b0\\u9700\\u8981\\u51e0\\u5473\\u7f55\\u89c1\\u836f\\u6750\\u624d\\u80fd\\u914d\\u5236\\u89e3\\u836f\\u3002\\u58a8\\u6e0a\\u5f7b\\u591c\\u7814\\u7a76\\u7389\\u7b80\\uff0c\\u4ece\\u4e2d\\u89e3\\u8bfb\\u51fa\\u5206\\u7075\\u951a\\u7684\\u8fd0\\u4f5c\\u673a\\u5236\\u2014\\u2014\\u5b83\\u4e0d\\u4ec5\\u80fd\\u62bd\\u53d6\\u4e16\\u754c\\u672c\\u6e90\\uff0c\\u8fd8\\u80fd\\u901a\\u8fc7\\u7075\\u6839\\u4e0e\\u4fee\\u58eb\\u5efa\\u7acb\\u9b42\\u5951\\uff0c\\u5728\\u4fee\\u58eb\\u7a81\\u7834\\u65f6\\u6536\\u5272\\u795e\\u9b42\\u4e4b\\u529b\\u3002\\u66f4\\u4ee4\\u4eba\\u9707\\u60ca\\u7684\\u662f\\uff0c\\u7389\\u7b80\\u6697\\u793a\\u846c\\u5251\\u8c37\\u66fe\\u662f\\u4e0a\\u53e4\\u65f6\\u671f\\u5bf9\\u6297\\u566c\\u754c\\u8005\\u7684\\u6218\\u573a\\uff0c\\u5730\\u4e0b\\u53ef\\u80fd\\u57cb\\u85cf\\u7740\\u5e9f\\u5f03\\u7684\\u5206\\u7075\\u951a\\u8bd5\\u9a8c\\u573a\\u3002\\u82cf\\u665a\\u68e0\\u5728\\u6574\\u7406\\u901a\\u7f09\\u4ee4\\u65f6\\uff0c\\u518d\\u6b21\\u770b\\u5230\\u9177\\u4f3c\\u5176\\u5144\\u7684\\u6267\\u4e8b\\u753b\\u50cf\\uff0c\\u5185\\u5fc3\\u9677\\u5165\\u77db\\u76fe\\u4e0e\\u6323\\u624e\\u3002\\u5f20\\u7fbd\\u5c1d\\u8bd5\\u4e0e\\u9006\\u7075\\u68ad\\u5efa\\u7acb\\u66f4\\u6df1\\u5c42\\u7684\\u8054\\u7cfb\\uff0c\\u53d1\\u73b0\\u5b83\\u80fd\\u5fae\\u5f31\\u5730\\u5e72\\u6270\\u5468\\u56f4\\u7684\\u7075\\u6c14\\u6d41\\u52a8\\u3002\\u56db\\u4eba\\u610f\\u8bc6\\u5230\\u77ff\\u6d1e\\u5df2\\u4e0d\\u518d\\u5b89\\u5168\\uff0c\\u5f00\\u59cb\\u8ba8\\u8bba\\u8f6c\\u79fb\\u65b9\\u5411\\uff0c\\u800c\\u846c\\u5251\\u8c37\\u6210\\u4e3a\\u552f\\u4e00\\u7684\\u9009\\u62e9\\u3002\\u8fdc\\u5904\\uff0c\\u5929\\u8861\\u53f8\\u641c\\u5c71\\u7684\\u53f7\\u89d2\\u58f0\\u9690\\u7ea6\\u4f20\\u6765\\u3002"}, {"chapter_number": 65, "title": "\\u5206\\u6b67\\u4e0e\\u51b3\\u65ad", "summary": "\\u56db\\u4eba\\u56f4\\u7ed5\\u7389\\u7b80\\u5185\\u5bb9\\u5c55\\u5f00\\u6fc0\\u70c8\\u8ba8\\u8bba\\u3002\\u5f20\\u7fbd\\u63d0\\u51fa\\u4e00\\u4e2a\\u5927\\u80c6\\u7684\\u8ba1\\u5212\\uff1a\\u5229\\u7528\\u81ea\\u5df1\\u9690\\u7075\\u6839\\u7684\\u7279\\u6b8a\\u6027\\uff0c\\u4f2a\\u88c5\\u6210\\u88ab\\u5206\\u7075\\u951a\\u6536\\u5272\\u7684\\u4fee\\u58eb\\u6df7\\u5165\\u846c\\u5251\\u8c37\\uff0c\\u4ece\\u5185\\u90e8\\u7834\\u574f\\u9635\\u773c\\u3002\\u58a8\\u6e0a\\u5f3a\\u70c8\\u53cd\\u5bf9\\uff0c\\u8ba4\\u4e3a\\u5206\\u7075\\u951a\\u9635\\u773c\\u5468\\u56f4\\u5fc5\\u7136\\u6709\\u91cd\\u5175\\u628a\\u5b88\\uff0c\\u4e14\\u5f20\\u7fbd\\u7684\\u9690\\u7075\\u6839\\u5728\\u9635\\u773c\\u9644\\u8fd1\\u53ef\\u80fd\\u5931\\u63a7\\uff0c\\u65e0\\u5f02\\u4e8e\\u7f8a\\u5165\\u864e\\u53e3\\u3002\\u77f3\\u94c1\\u5fc3\\u5374\\u652f\\u6301\\u5f20\\u7fbd\\uff0c\\u8868\\u793a\\u613f\\u610f\\u5728\\u5916\\u56f4\\u63a5\\u5e94\\uff0c\\u5e76\\u8bf4'\\u8981\\u4e48\\u7b49\\u6b7b\\uff0c\\u8981\\u4e48\\u62fc\\u4e00\\u628a'\\u3002\\u82cf\\u665a\\u68e0\\u72b9\\u8c6b\\u4e0d\\u51b3\\uff0c\\u65e2\\u62c5\\u5fc3\\u8ba1\\u5212\\u5931\\u8d25\\u8fde\\u7d2f\\u5927\\u5bb6\\uff0c\\u53c8\\u7275\\u6302\\u53ef\\u80fd\\u88ab\\u56f0\\u5728\\u846c\\u5251\\u8c37\\u6df1\\u5904\\u7684\\u5144\\u957f\\u3002\\u8ba8\\u8bba\\u4e2d\\uff0c\\u58a8\\u6e0a\\u8fdb\\u4e00\\u6b65\\u63ed\\u793a\\u5206\\u7075\\u951a\\u5bf9\\u4fee\\u58eb\\u7684\\u5f71\\u54cd\\u2014\\u2014\\u957f\\u671f\\u88ab\\u6536\\u5272\\u4f1a\\u5bfc\\u81f4\\u795e\\u9b42\\u67af\\u7aed\\uff0c\\u6700\\u7ec8\\u6ca6\\u4e3a\\u884c\\u5c38\\u8d70\\u8089\\u3002\\u5c31\\u5728\\u53cc\\u65b9\\u50f5\\u6301\\u4e0d\\u4e0b\\u65f6\\uff0c\\u77ff\\u6d1e\\u5916\\u4f20\\u6765\\u5929\\u8861\\u53f8\\u641c\\u67e5\\u961f\\u7684\\u811a\\u6b65\\u58f0\\u548c\\u72ac\\u5420\\u58f0\\uff0c\\u56db\\u4eba\\u5fc5\\u987b\\u7acb\\u5373\\u505a\\u51fa\\u51b3\\u65ad\\u3002\\u5f20\\u7fbd\\u6df1\\u5438\\u4e00\\u53e3\\u6c14\\uff0c\\u51b3\\u5b9a\\u6267\\u884c\\u8ba1\\u5212\\uff0c\\u56db\\u4eba\\u5f00\\u59cb\\u7d27\\u6025\\u51c6\\u5907\\u8f6c\\u79fb\\u3002"}, {"chapter_number": 66, "title": "\\u591c\\u5954\\u846c\\u5251\\u8c37", "summary": "\\u5929\\u8861\\u53f8\\u641c\\u67e5\\u961f\\u903c\\u8fd1\\u77ff\\u6d1e\\uff0c\\u56db\\u4eba\\u88ab\\u8feb\\u8fde\\u591c\\u8f6c\\u79fb\\u3002\\u77f3\\u94c1\\u5fc3\\u4f24\\u52bf\\u672a\\u6108\\uff0c\\u67f3\\u82e5\\u971c\\u4ee5\\u94f6\\u9488\\u5c01\\u7a74\\u4e4b\\u6cd5\\u52c9\\u5f3a\\u7a33\\u4f4f\\u4ed6\\u7684\\u6c14\\u606f\\uff0c\\u4f46\\u65e0\\u6cd5\\u6301\\u4e45\\u3002\\u82cf\\u665a\\u68e0\\u51ed\\u501f\\u5bf9\\u77ff\\u6d1e\\u7ed3\\u6784\\u7684\\u719f\\u6089\\u5728\\u524d\\u65b9\\u63a2\\u8def\\uff0c\\u5f20\\u7fbd\\u4e0e\\u58a8\\u6e0a\\u6bbf\\u540e\\uff0c\\u5229\\u7528\\u77ff\\u6d1e\\u590d\\u6742\\u7684\\u5c94\\u9053\\u548c\\u65e9\\u5e74\\u5e9f\\u5f03\\u7684\\u901a\\u98ce\\u4e95\\uff0c\\u6210\\u529f\\u62c9\\u5f00\\u4e0e\\u8ffd\\u6355\\u8005\\u7684\\u8ddd\\u79bb\\u3002\\u7136\\u800c\\uff0c\\u5f53\\u4ed6\\u4eec\\u8d76\\u5230\\u6700\\u8fd1\\u7684\\u51fa\\u53e3\\u65f6\\uff0c\\u53d1\\u73b0\\u5929\\u8861\\u53f8\\u5df2\\u5e03\\u4e0b\\u5929\\u7f57\\u5730\\u7f51\\uff0c\\u6b63\\u9762\\u7a81\\u7834\\u65e0\\u671b\\u3002\\u56db\\u4eba\\u5f53\\u673a\\u7acb\\u65ad\\uff0c\\u8f6c\\u800c\\u5411\\u846c\\u5251\\u8c37\\u65b9\\u5411\\u6f5c\\u884c\\u3002\\u9014\\u4e2d\\uff0c\\u82cf\\u665a\\u68e0\\u654f\\u9510\\u5730\\u53d1\\u73b0\\u5929\\u8861\\u53f8\\u6697\\u54e8\\u5df2\\u6cbf\\u8c37\\u53e3\\u5e03\\u4e0b\\u9501\\u7075\\u9635\\uff0c\\u7075\\u6c14\\u88ab\\u5c01\\u9501\\uff0c\\u4fee\\u58eb\\u96be\\u4ee5\\u98de\\u884c\\u6216\\u65bd\\u5c55\\u6cd5\\u672f\\u3002\\u5f20\\u7fbd\\u63d0\\u8bae\\u5bfb\\u627e\\u5176\\u4ed6\\u5165\\u53e3\\uff0c\\u6700\\u7ec8\\u5728\\u4e00\\u5904\\u60ac\\u5d16\\u4e0b\\u53d1\\u73b0\\u5730\\u4e0b\\u6697\\u6cb3\\u7684\\u5165\\u53e3\\u3002\\u7136\\u800c\\uff0c\\u5f53\\u4ed6\\u4eec\\u51c6\\u5907\\u6f5c\\u5165\\u6697\\u6cb3\\u65f6\\uff0c\\u6cb3\\u4e2d\\u7a81\\u7136\\u7a9c\\u51fa\\u4e00\\u5934\\u53d8\\u5f02\\u5996\\u517d\\uff0c\\u6d51\\u8eab\\u8986\\u76d6\\u7740\\u9ed1\\u8272\\u9cde\\u7247\\uff0c\\u773c\\u4e2d\\u95ea\\u70c1\\u7740\\u4e0d\\u7965\\u7684\\u7ea2\\u5149\\u3002"}]}	\N	{"stage": "complete", "message": "\\u5df2\\u4ece\\u7b2c64\\u7ae0\\u8d77\\u91cd\\u65b0\\u751f\\u6210 3 \\u7ae0"}	f	0	3	2026-09-20 19:44:29.755279	2026-09-20 19:44:30.729382	2026-09-20 19:46:15.189327	2026-09-20 19:46:15.193136
3f3ff0eb-22eb-4f6d-b153-8f5a4ed003c4	local_21232f297a57a5a7	d59e468a-8617-41e0-aabf-87a13be78834	chapter_regenerate_from_position	completed	100	已从第73章起重新生成 3 章	{"chapter_id": "4e770c57-b344-4c70-9127-b814266287a4", "target_chapter_count": 3, "expansion_strategy": "balanced", "provider": null, "model": null}	{"start_chapter_number": 73, "generated_chapter_count": 3, "generated_chapters": [{"chapter_number": 73, "title": "\\u58c1\\u753b\\u4e0b\\u7684\\u4f4e\\u8bed", "summary": "\\u56db\\u4eba\\u4ece\\u9ed1\\u8272\\u77f3\\u67f1\\u533a\\u57df\\u64a4\\u9000\\u81f3\\u4e00\\u5904\\u76f8\\u5bf9\\u5b89\\u5168\\u7684\\u6d1e\\u5385\\u3002\\u82cf\\u665a\\u68e0\\u5728\\u5165\\u53e3\\u5e03\\u4e0b\\u7b80\\u6613\\u8b66\\u6212\\u9635\\u6cd5\\uff0c\\u786e\\u8ba4\\u6682\\u65f6\\u672a\\u88ab\\u8ffd\\u8e2a\\u3002\\u6d1e\\u5385\\u56db\\u58c1\\u7ed8\\u6ee1\\u4e86\\u6591\\u9a73\\u58c1\\u753b\\uff0c\\u63cf\\u7ed8\\u7740\\u566c\\u754c\\u8005\\u964d\\u4e34\\u5929\\u5143\\u754c\\u7684\\u573a\\u666f\\u3002\\u58a8\\u6e0a\\u501f\\u7740\\u5fae\\u5149\\u4ed4\\u7ec6\\u8fa8\\u8ba4\\u58c1\\u753b\\u5185\\u5bb9\\uff0c\\u53d1\\u73b0\\u5176\\u4e2d\\u9690\\u85cf\\u7740\\u5206\\u7075\\u951a\\u5206\\u5e03\\u56fe\\u4e0e\\u7075\\u6f6e\\u5468\\u671f\\u8868\\u3002\\u5f20\\u7fbd\\u9760\\u8fd1\\u58c1\\u753b\\u65f6\\uff0c\\u638c\\u5fc3\\u7070\\u9ed1\\u7eb9\\u8def\\u9690\\u9690\\u53d1\\u70ed\\uff0c\\u58c1\\u753b\\u4e2d\\u67d0\\u4e2a\\u56fe\\u6848\\u4f3c\\u4e4e\\u5728\\u6ce8\\u89c6\\u7740\\u4ed6\\u3002\\u77f3\\u94c1\\u5fc3\\u56e0\\u4f24\\u52bf\\u4e0e\\u7075\\u6c14\\u532e\\u4e4f\\u9677\\u5165\\u534a\\u660f\\u8ff7\\uff0c\\u67f3\\u82e5\\u971c\\u4ee5\\u94f6\\u9488\\u6e21\\u7a74\\u4e4b\\u6cd5\\u52c9\\u5f3a\\u7a33\\u4f4f\\u4ed6\\u7684\\u6c14\\u606f\\uff0c\\u5e76\\u5c06\\u6700\\u540e\\u4e00\\u679a\\u4e39\\u836f\\u5316\\u5165\\u6c34\\u4e2d\\u5582\\u4ed6\\u670d\\u4e0b\\u3002\\u5f20\\u7fbd\\u5c1d\\u8bd5\\u7528\\u7cbe\\u795e\\u529b\\u63a2\\u67e5\\u7070\\u9ed1\\u7eb9\\u8def\\uff0c\\u53d1\\u73b0\\u5b83\\u6b63\\u5728\\u4ee5\\u6781\\u5176\\u7f13\\u6162\\u7684\\u901f\\u5ea6\\u5438\\u6536\\u5468\\u56f4\\u7075\\u6c14\\uff0c\\u65b9\\u5f0f\\u4e0e\\u7075\\u6839\\u622a\\u7136\\u4e0d\\u540c\\u3002"}, {"chapter_number": 74, "title": "\\u5206\\u7075\\u951a\\u7684\\u771f\\u76f8", "summary": "\\u58a8\\u6e0a\\u5f7b\\u591c\\u7814\\u7a76\\u58c1\\u753b\\uff0c\\u7ec8\\u4e8e\\u7834\\u8bd1\\u51fa\\u5173\\u952e\\u4fe1\\u606f\\uff1a\\u5206\\u7075\\u951a\\u5c06\\u4e16\\u754c\\u672c\\u6e90\\u4e4b\\u529b\\u8f6c\\u5316\\u4e3a\\u7c7b\\u4f3c\\u7075\\u6839\\u7684\\u5929\\u8d4b\\u5370\\u8bb0\\uff0c\\u5bc4\\u751f\\u5728\\u4fee\\u58eb\\u4f53\\u5185\\uff0c\\u968f\\u7740\\u4fee\\u4e3a\\u63d0\\u5347\\u9010\\u6b65\\u8695\\u98df\\u5bbf\\u4e3b\\u795e\\u9b42\\u3002\\u5f20\\u7fbd\\u7ed3\\u5408\\u524d\\u4e16\\u77e5\\u8bc6\\uff0c\\u63a8\\u65ad\\u51fa\\u6240\\u8c13\\u7684\\u5929\\u8d4b\\u89c9\\u9192\\u5e76\\u975e\\u5929\\u5730\\u6069\\u8d50\\uff0c\\u800c\\u662f\\u566c\\u754c\\u8005\\u7cbe\\u5fc3\\u8bbe\\u8ba1\\u7684\\u5bc4\\u751f\\u4eea\\u5f0f\\u3002\\u67f3\\u82e5\\u971c\\u5728\\u7167\\u6599\\u77f3\\u94c1\\u5fc3\\u65f6\\uff0c\\u53d1\\u73b0\\u4ed6\\u4f53\\u5185\\u4e5f\\u6f5c\\u4f0f\\u7740\\u5fae\\u5f31\\u7684\\u7070\\u9ed1\\u6c14\\u606f\\uff0c\\u63a8\\u6d4b\\u662f\\u957f\\u671f\\u5728\\u7075\\u77ff\\u52b3\\u4f5c\\u3001\\u63a5\\u89e6\\u88ab\\u6c61\\u67d3\\u7075\\u6c14\\u6240\\u81f4\\u3002\\u5f20\\u7fbd\\u51b3\\u5b9a\\u5192\\u9669\\u518d\\u6b21\\u63a5\\u89e6\\u9ed1\\u8272\\u77f3\\u67f1\\uff0c\\u8bd5\\u56fe\\u83b7\\u53d6\\u66f4\\u591a\\u5173\\u4e8e\\u566c\\u754c\\u8005\\u8ba1\\u5212\\u7684\\u4fe1\\u606f\\u3002\\u82cf\\u665a\\u68e0\\u5728\\u8b66\\u6212\\u65f6\\u53d1\\u73b0\\u6d1e\\u5385\\u5165\\u53e3\\u7684\\u7075\\u6c14\\u6ce2\\u52a8\\u5f02\\u5e38\\uff0c\\u4f3c\\u4e4e\\u6709\\u67d0\\u79cd\\u5b58\\u5728\\u6b63\\u5728\\u63a5\\u8fd1\\u3002\\u5f20\\u7fbd\\u4ece\\u77f3\\u67f1\\u4e2d\\u83b7\\u5f97\\u4e86\\u66f4\\u591a\\u5173\\u4e8e\\u7075\\u6f6e\\u6536\\u5272\\u7684\\u5173\\u952e\\u4fe1\\u606f\\uff0c\\u4f46\\u638c\\u5fc3\\u7684\\u7070\\u9ed1\\u7eb9\\u8def\\u4ece\\u638c\\u5fc3\\u8513\\u5ef6\\u81f3\\u624b\\u8155\\u3002"}, {"chapter_number": 75, "title": "\\u82cf\\u9192\\u7684\\u796d\\u575b", "summary": "\\u58c1\\u753b\\u7a81\\u7136\\u53d1\\u51fa\\u5e7d\\u7eff\\u5149\\u8292\\uff0c\\u6574\\u4e2a\\u6d1e\\u5385\\u5f00\\u59cb\\u8f7b\\u5fae\\u9707\\u52a8\\u3002\\u58a8\\u6e0a\\u53d1\\u73b0\\u58c1\\u753b\\u5e76\\u975e\\u7b80\\u5355\\u7684\\u58c1\\u753b\\uff0c\\u800c\\u662f\\u4e00\\u4e2a\\u5927\\u578b\\u5c01\\u5370\\u9635\\u6cd5\\u7684\\u4e00\\u90e8\\u5206\\uff0c\\u9ed1\\u8272\\u77f3\\u67f1\\u6b63\\u662f\\u9635\\u773c\\u3002\\u5f20\\u7fbd\\u638c\\u5fc3\\u7684\\u7070\\u9ed1\\u7eb9\\u8def\\u5267\\u70c8\\u53cd\\u5e94\\uff0c\\u4e0e\\u58c1\\u753b\\u4ea7\\u751f\\u6df1\\u5ea6\\u5171\\u9e23\\uff0c\\u4ed6\\u7684\\u610f\\u8bc6\\u88ab\\u62c9\\u5165\\u4e00\\u6bb5\\u5e7b\\u8c61\\uff1a\\u566c\\u754c\\u8005\\u5927\\u519b\\u901a\\u8fc7\\u5206\\u7075\\u951a\\u6253\\u5f00\\u7684\\u901a\\u9053\\u6d8c\\u5165\\u5929\\u5143\\u754c\\uff0c\\u65e0\\u6570\\u4fee\\u58eb\\u5728\\u5929\\u8d4b\\u89c9\\u9192\\u7684\\u72c2\\u559c\\u4e2d\\u6ca6\\u4e3a\\u5080\\u5121\\u3002\\u77f3\\u94c1\\u5fc3\\u5f3a\\u6491\\u8eab\\u4f53\\u6293\\u8d77\\u77ff\\u9550\\uff0c\\u67f3\\u82e5\\u971c\\u8bd5\\u56fe\\u7528\\u94f6\\u9488\\u5207\\u65ad\\u5f20\\u7fbd\\u4e0e\\u58c1\\u753b\\u7684\\u8054\\u7cfb\\u5374\\u65e0\\u6d4e\\u4e8e\\u4e8b\\u3002\\u82cf\\u665a\\u68e0\\u53d1\\u73b0\\u6d1e\\u5385\\u56db\\u58c1\\u51fa\\u73b0\\u7ec6\\u5fae\\u88c2\\u7eb9\\uff0c\\u67af\\u9aa8\\u5728\\u7f1d\\u9699\\u540e\\u5f00\\u59cb\\u8815\\u52a8\\u3002\\u5f20\\u7fbd\\u5728\\u5e7b\\u8c61\\u4e2d\\u770b\\u5230\\u796d\\u575b\\u6c34\\u6676\\u7403\\u7684\\u4f4d\\u7f6e\\uff0c\\u610f\\u8bc6\\u5230\\u90a3\\u662f\\u63a7\\u5236\\u6574\\u4e2a\\u9635\\u6cd5\\u7684\\u4e2d\\u67a2\\u3002\\u58c1\\u753b\\u88c2\\u5f00\\u7f1d\\u9699\\uff0c\\u4f20\\u51fa\\u4f4e\\u6c89\\u7684\\u541f\\u5531\\u58f0\\uff0c\\u5927\\u91cf\\u67af\\u9aa8\\u5728\\u7f1d\\u9699\\u540e\\u8822\\u8822\\u6b32\\u52a8\\u3002"}]}	\N	{"stage": "complete", "message": "\\u5df2\\u4ece\\u7b2c73\\u7ae0\\u8d77\\u91cd\\u65b0\\u751f\\u6210 3 \\u7ae0"}	f	0	3	2026-09-20 19:47:45.14107	2026-09-20 19:47:45.1684	2026-09-20 19:48:51.566375	2026-09-20 19:48:51.570321
b9e1c48b-da86-4701-9f67-9473c4b1c5db	local_21232f297a57a5a7	d59e468a-8617-41e0-aabf-87a13be78834	chapter_regenerate_from_position	completed	100	已从第13章起重新生成 3 章	{"chapter_id": "f0bf6a25-364a-4d17-903a-cc3d8f08857a", "target_chapter_count": 3, "expansion_strategy": "balanced", "provider": null, "model": null}	{"start_chapter_number": 13, "generated_chapter_count": 3, "generated_chapters": [{"chapter_number": 13, "title": "\\u836f\\u9999\\u6697\\u5f71", "summary": "\\u67f3\\u82e5\\u971c\\u5728\\u836f\\u56ed\\u4e2d\\u7167\\u6599\\u7075\\u8349\\u65f6\\uff0c\\u53d1\\u73b0\\u66f4\\u591a\\u690d\\u682a\\u88ab\\u9ed1\\u8272\\u96fe\\u6c14\\u4fb5\\u8680\\u3002\\u5979\\u5c0f\\u5fc3\\u7ffc\\u7ffc\\u5730\\u4fdd\\u5b58\\u4e86\\u6837\\u672c\\uff0c\\u5e76\\u5c1d\\u8bd5\\u5206\\u6790\\u8fd9\\u79cd\\u4fb5\\u8680\\u7684\\u6765\\u6e90\\u3002\\u4e0e\\u6b64\\u540c\\u65f6\\uff0c\\u5f20\\u7fbd\\u5728\\u7075\\u77ff\\u5802\\u4e2d\\u91cd\\u590d\\u7740\\u5355\\u8c03\\u7684\\u5206\\u62e3\\u5de5\\u4f5c\\uff0c\\u4f46\\u4ed6\\u6697\\u4e2d\\u8bb0\\u5f55\\u7740\\u6bcf\\u4e00\\u6279\\u805a\\u7075\\u4e39\\u7684\\u6d41\\u5411\\u3002\\u58a8\\u6e0a\\u4f9d\\u65e7\\u6574\\u65e5\\u9189\\u9152\\uff0c\\u5374\\u5728\\u4e00\\u6b21\\u6df1\\u591c\\u4ea4\\u8c08\\u4e2d\\uff0c\\u65e0\\u610f\\u4e2d\\u900f\\u9732\\u4e86\\u5b97\\u95e8\\u957f\\u8001\\u4f1a\\u7684\\u4e00\\u4e9b\\u79d8\\u8f9b\\uff0c\\u6697\\u793a\\u9ad8\\u5c42\\u5bf9\\u5929\\u8d4b\\u771f\\u76f8\\u5e76\\u975e\\u4e00\\u65e0\\u6240\\u77e5\\u3002\\u4e09\\u4eba\\u5728\\u58a8\\u6e0a\\u7684\\u5c0f\\u9662\\u4e2d\\u4ea4\\u6362\\u4fe1\\u606f\\uff0c\\u6c14\\u6c1b\\u6c89\\u91cd\\u3002"}, {"chapter_number": 14, "title": "\\u77ff\\u6e0a\\u4f4e\\u8bed", "summary": "\\u77f3\\u94c1\\u5fc3\\u5728\\u77ff\\u6d1e\\u6df1\\u5904\\u4f5c\\u4e1a\\u65f6\\uff0c\\u542c\\u5230\\u77ff\\u8109\\u4e2d\\u4f20\\u6765\\u5fae\\u5f31\\u7684\\u60b2\\u9e23\\u3002\\u4ed6\\u5faa\\u58f0\\u5bfb\\u627e\\uff0c\\u53d1\\u73b0\\u4e00\\u5904\\u88ab\\u5c01\\u95ed\\u7684\\u53e4\\u8001\\u77ff\\u9053\\u3002\\u4ed6\\u6f5c\\u5165\\u5176\\u4e2d\\uff0c\\u76ee\\u7779\\u4e86\\u7075\\u6c14\\u88ab\\u67d0\\u79cd\\u529b\\u91cf\\u7f13\\u6162\\u62bd\\u8d70\\u7684\\u666f\\u8c61\\u3002\\u4ed6\\u8bd5\\u56fe\\u91c7\\u96c6\\u6837\\u672c\\u65f6\\u89e6\\u53d1\\u4e86\\u9690\\u85cf\\u7684\\u7981\\u5236\\uff0c\\u5f15\\u53d1\\u5c0f\\u89c4\\u6a21\\u574d\\u584c\\u3002\\u5f20\\u7fbd\\u548c\\u58a8\\u6e0a\\u95fb\\u8baf\\u8d76\\u6765\\uff0c\\u4e09\\u4eba\\u534f\\u4f5c\\u8131\\u9669\\u3002\\u56de\\u5230\\u5730\\u9762\\u540e\\uff0c\\u77f3\\u94c1\\u5fc3\\u5c06\\u6240\\u89c1\\u544a\\u77e5\\u4e8c\\u4eba\\uff0c\\u4e09\\u4eba\\u5bf9\\u5b97\\u95e8\\u7684\\u6000\\u7591\\u52a0\\u6df1\\u4e86\\u4e00\\u5c42\\u3002"}, {"chapter_number": 15, "title": "\\u6697\\u6d8c", "summary": "\\u5916\\u95e8\\u9009\\u62d4\\u8003\\u6838\\u4e34\\u8fd1\\uff0c\\u5f20\\u7fbd\\u611f\\u53d7\\u5230\\u6765\\u81ea\\u5404\\u65b9\\u7684\\u538b\\u529b\\u3002\\u4ed6\\u5728\\u51c6\\u5907\\u8fc7\\u7a0b\\u4e2d\\u5fc5\\u987b\\u8c28\\u614e\\u5e73\\u8861\\uff1a\\u65e2\\u8981\\u5c55\\u793a\\u8db3\\u591f\\u7684\\u5b9e\\u529b\\u901a\\u8fc7\\u8003\\u6838\\uff0c\\u53c8\\u4e0d\\u80fd\\u66b4\\u9732\\u65e0\\u7075\\u6839\\u7684\\u771f\\u76f8\\u3002\\u67f3\\u82e5\\u971c\\u7684\\u4eb2\\u4eba\\u75c5\\u60c5\\u7a81\\u7136\\u52a0\\u91cd\\uff0c\\u5979\\u6025\\u9700\\u4e00\\u682a\\u73cd\\u8d35\\u7075\\u8349\\u5165\\u836f\\u3002\\u5f20\\u7fbd\\u548c\\u58a8\\u6e0a\\u6697\\u4e2d\\u76f8\\u52a9\\uff0c\\u5192\\u9669\\u4ece\\u836f\\u56ed\\u4e2d\\u53d6\\u6765\\u7075\\u8349\\u3002\\u7136\\u800c\\uff0c\\u4ed6\\u4eec\\u7684\\u9891\\u7e41\\u63a5\\u89e6\\u5f15\\u8d77\\u4e86\\u6709\\u5fc3\\u4eba\\u7684\\u6ce8\\u610f\\uff0c\\u4e09\\u4eba\\u540c\\u76df\\u9762\\u4e34\\u66b4\\u9732\\u7684\\u98ce\\u9669\\u3002\\u5f20\\u7fbd\\u610f\\u8bc6\\u5230\\uff0c\\u8003\\u6838\\u4e0d\\u4ec5\\u662f\\u5b9e\\u529b\\u7684\\u8003\\u9a8c\\uff0c\\u66f4\\u662f\\u5bf9\\u4ed6\\u4f2a\\u88c5\\u80fd\\u529b\\u7684\\u7ec8\\u6781\\u6311\\u6218\\u3002"}]}	\N	{"stage": "complete", "message": "\\u5df2\\u4ece\\u7b2c13\\u7ae0\\u8d77\\u91cd\\u65b0\\u751f\\u6210 3 \\u7ae0"}	f	0	3	2026-09-20 19:39:43.678235	2026-09-20 19:39:43.754208	2026-09-20 19:41:19.486222	2026-09-20 19:41:19.490539
\.


--
-- Data for Name: batch_generation_tasks; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.batch_generation_tasks (id, project_id, user_id, start_chapter_number, chapter_count, chapter_ids, style_id, target_word_count, enable_analysis, status, total_chapters, completed_chapters, failed_chapters, current_chapter_id, current_chapter_number, current_retry_count, max_retries, created_at, started_at, completed_at, error_message) FROM stdin;
f22d9b8d-a704-41da-b11a-0fe488d35ad7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	local_21232f297a57a5a7	11	5	["214ed068-75b2-477d-ae83-d83ae98afb96", "261ee431-2b9d-4544-842d-31cb2d054d48", "ec671aae-e1fd-466e-a27f-de111643114e", "acbd6ad5-1740-432c-93ea-3ab0fe331b18", "c0a34e67-01f7-49c3-92cf-986d9824453b"]	7	2000	t	failed	5	4	[]	c0a34e67-01f7-49c3-92cf-986d9824453b	15	0	3	2026-08-07 10:56:09.872468	2026-08-07 02:56:09.906773	2026-08-13 05:03:08.994062	服务重启，批量生成任务已中断
\.


--
-- Data for Name: careers; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.careers (id, project_id, name, type, description, category, stages, max_stage, requirements, special_abilities, worldview_rules, attribute_bonuses, source, created_at, updated_at) FROM stdin;
8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	d59e468a-8617-41e0-aabf-87a13be78834	无痕破妄者	main	世人都以为天赋是天启之门的恩赐，唯有无天赋者看得见恩赐背后的黑线。无痕破妄者没有天赋印记，无法被魂契锁定，于是以伪造天赋为修行起点，将假天赋修成对抗天启的逆命之印。他们游走于宗门玉阶与泥泞之间，收割一切残留在天地间的谎言，成为唯一能斩断收割之索的清醒之人。	特殊系·破妄者	[{"level": 1, "name": "无痕之体", "description": "没有天赋印记，灵魂纯净空白，不受天启之音蛊惑。灵力入体缓慢但毫无杂质，能隐约看见人与天空之间极细的丝线。"}, {"level": 2, "name": "伪赋初凝", "description": "以体内灵气凝成伪天赋印记，通过最低阶测灵。伪印只有形而无魂，骗过宗门入门筛查，开始以杂役身份潜伏藏经阁。"}, {"level": 3, "name": "双面行修", "description": "可在无赋与伪赋之间切换行走。无赋时吸收天地元灵，伪赋时模仿宗门功法波动；两种状态叠加，使他对魂契之线的观察更加清晰。"}, {"level": 4, "name": "破妄之眼", "description": "魂契之眼彻底成形，能看见修士后颈黑线的粗细、走向与结点，分辨收割进度；也能看见所谓'心魔劫数'背后被隐藏的操控痕迹。"}, {"level": 5, "name": "窃丝易命", "description": "学会截取游离的魂契残丝，将它们炼入自己的伪赋印记中，使假天赋不断升级。每窃一道残丝，便能多读懂一分收割网络的结构。"}, {"level": 6, "name": "断契初刃", "description": "能以自身神魂为刃，短暂斩断低阶修士身后的收割之索。对方会在数息内恢复清醒，但也立刻惊动天衡司与宗门监察阵法，须在暗处谨慎使用。"}, {"level": 7, "name": "虚赋成真", "description": "伪赋印记经历无数次洗炼后蜕变为'逆生印'，拥有真正天赋的战力却不含境外意志。可短暂借用他人印记而不被魂契污染。"}, {"level": 8, "name": "摄魂反锁", "description": "以逆生印反噬收割之线，将侵入神魂的境外意志绞碎并化为己用。从此修行速度不再受天赋品阶限制，反而越接近黑线越强。"}, {"level": 9, "name": "问天逆命", "description": "以己身为锚点撕裂一地天启笼罩，暂时解开附近修士的魂契枷锁。他能让被'心魔劫数'定罪之人重新睁开眼睛，看见挂在天空的索。"}, {"level": 10, "name": "本来无挂", "description": "真正明悟不属于己身的力量皆是囚锁，唯一真实的力量来自不被收割的自我。自身的存在从收割清单上彻底消失，不受任何阵法与天启法器锁定；一念之间，可令周围所有魂契之线同时崩断。"}]	10	天生无天赋印记，且灵魂从未与天启之门缔结魂契；必须长期伪装成低阶天赋者混入宗门；修行过程不可依赖任何现成外挂，必须靠自身感悟完成。	魂契之眼：直视收割之索；无痕伪装：模拟凡阶到玄阶的天赋波动；逆生印：化假天赋为真我之力；断契之刃：斩断或反转魂契之线。	天赋伴生体系是外敌设下的收割陷阱，每次觉醒都是一道魂契。无痕破妄者因没有天赋印记而不在收割名单内，能看清被主流视为'恩赐'的力量背后的黑线；其职业进阶过程就是逐步揭开天启之门骗局并唤醒众生的过程。	{"神魂抗性": "+30%", "感知": "+40%", "灵力操控": "+20%"}	ai	2026-08-05 13:39:36.540731	2026-08-05 13:39:36.540731
f3e0994d-cca9-459e-8086-cbabc79c3a93	d59e468a-8617-41e0-aabf-87a13be78834	溯魂药工	sub	以废弃灵草和淬灵丹余烬炼丹的特殊药工。他们不追逐名贵天材，专从被天赋体系丢弃的渣滓中提取真相。一炉看似平凡的药散，既能帮人伪装天赋，也能在关键时刻软化收割之索，是破妄者最可靠的暗手。	辅助系·药工	[{"level": 1, "name": "药炉杂役", "description": "负责烧火控温、翻晒残药，学会从丹炉余烬分辨不同属性灵力残留，积累最底层药理功底。"}, {"level": 2, "name": "识味辨灵", "description": "能凭气味尝出灵气是否被天启之力污染，一口药汤便可判断来源。开始接触杂役坊中见不得光的灵草渣滓与废弃丹方。"}, {"level": 3, "name": "残烬为引", "description": "掌握从废旧丹炉和废弃印记残片中提取魂契残丝的方法，以残丝为药引，调制出能短暂模拟天赋波动的'伪赋散'。"}, {"level": 4, "name": "伪赋丹成", "description": "炼成真正的伪赋丹，可在半个时辰内让服丹者发出凡阶到玄阶的天赋灵气波动，骗过宗门常规盘查，也能掩护主职业修炼。"}, {"level": 5, "name": "断契药引", "description": "从褪念草和碎魂螺壳中炼出'断契引'，涂抹在法器或指尖可让收割之索松动，为主职业的斩契提供最佳时机。"}, {"level": 6, "name": "醒魂汤散", "description": "调制醒魂汤，救助临近灵识迷失的修士。汤药能压住魂契反噬，让受害者短暂想起自己，帮助破妄者从病人口中挖出真相同伴。"}, {"level": 7, "name": "逆炼天启", "description": "将收集的伪赋丹、断契引、醒魂汤逆炼合一，炼成不含境外意志的'无主灵核'。这份灵核可让破妄者彻底摆脱伪造，转出真正的己身之力。"}]	7	需在主职业达到伪赋初凝后开始；必须长期出入杂役坊，熟悉丹炉残渣与废弃灵草；自身不能有高阶天赋印记，以免被天衡司重点监视。	伪赋丹：模拟天赋波动掩护身份；断契引：软化收割之索；醒魂汤：唤醒灵识迷失者；无主灵核：炼制不携带魂契的纯净灵力。	\N	\N	ai	2026-08-05 13:39:36.540731	2026-08-05 13:39:36.540731
\.


--
-- Data for Name: chapters; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.chapters (id, project_id, chapter_number, title, content, summary, word_count, status, outline_id, sub_index, expansion_plan, created_at, updated_at) FROM stdin;
9065ed59-e6ce-4bbe-98d1-00c42f8713de	d59e468a-8617-41e0-aabf-87a13be78834	1	隐灵根	\N	灵潮纪元，十六岁测灵是凡人命运的绝对分水岭。天璇宗试灵台下，数以万计的少年排队等待命运的裁决。张羽站在队伍中，表面恭顺，内心却如履薄冰——他深知自己毫无伴生灵根，一旦暴露必死无疑。他冷静观察着周围少年的狂喜与绝望，以及测灵碑散发的绝对威压。轮到他时，他凭借前世记忆中对能量波动的理解，以强大的精神力强行牵引外界灵气在特定经脉中流转，伪装出极其微弱、若有若无的'隐灵根'异象。这种异象极为罕见，引起测灵碑的轻微震颤。长老们经过商议，将其判定为极罕见的变异灵根，但因灵气波动过于微弱，勉强获得入宗资格，被贬至最底层的杂役坊。张羽松了口气，却知道这只是开始。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	1	{"key_events": ["试灵台众生相观察", "测灵碑前伪装隐灵根", "被判定变异灵根贬入杂役坊"], "character_focus": ["张羽"], "emotional_tone": "紧张压抑、如履薄冰", "narrative_goal": "建立主角绝境求生的初始处境，展示其缜密心思与伪装能力，为后续底层挣扎铺垫", "conflict_type": "人与命运的对抗", "estimated_words": 3000, "scenes": null}	2026-09-20 16:04:12.436117	2026-09-20 16:04:12.436117
797246b3-9e72-44ac-a717-b79d4cf981cb	d59e468a-8617-41e0-aabf-87a13be78834	2	石与血	\N	进入天璇宗杂役坊，张羽见识到了天赋至上的残酷真相。高天赋弟子肆意欺压杂役，为半块灵石打破头是常态。没有外挂傍身，他只能依靠远超常人的努力与极度缜密的时间管理，偷学外门基础功法。他必须在人前维持'隐灵根废材但够用'的人设，暗中却以近乎自虐的方式填补没有灵根自动吸纳灵气的短板——每晚只睡两个时辰，靠肉体与意志硬抗灵气灌体的痛楚，甚至不惜服用有微毒的草药来模拟灵根运转的体表特征。一次灵矿劳作中，他结识了同样底层的石铁心，两人在矿洞塌方中生死与共，石铁心替他挡下致命落石。石铁心寡言少语，眉宇间带着矿洞中磨砺出的沉稳，信奉拳头比话多有用。两人因对高阶修士的共同敌意与对命运的不甘而结成生死之交。深夜，张羽看到石铁心反复打磨那柄矿镐，仿佛在打磨着某种执念。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	2	{"key_events": ["杂役坊初体验被欺压", "偷学外门基础功法", "矿洞劳作结识石铁心", "矿洞塌方生死与共"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "压抑绝望、微光（友情）", "narrative_goal": "展现底层残酷生存状态，建立主角与石铁心的生死羁绊，刻画主角隐忍自虐的修炼日常", "conflict_type": "阶级压迫（底层 vs 高阶修士）", "estimated_words": 3000, "scenes": null}	2026-09-20 16:04:12.436117	2026-09-20 16:04:12.436117
88f367b9-7962-46c7-b75e-9f4924ba0f70	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7	六月三日的黑影	办公室不大。一张包浆发亮的橡木桌，一把皮面磨得发白的扶手椅，靠墙一排抽屉齐顶。窗朝街，九点的光斜进来，把桌面照得发亮。墙角衣帽架上挂着深褐软呢帽和那根黑色手杖。\n\n桌上没什么东西。一只空咖啡杯，一叠没拆的信封，一枚铜币压在信封上当镇纸。\n\n莱尔绕到桌后坐下，从口袋里摸出铜币，在指间翻了半个圈。\n\n"请坐。请问您遇到了什么问题呢？"\n\n铜币翻着。塞西莉看了那枚硬币一眼，又看莱尔一眼。\n\n她没急着开口。先摘了墨镜搁在膝上，目光扫了一圈办公室——抽屉柜、衣帽架、窗台上一盆没人打理的绿萝。哈里特坐在她旁边，手里端着一杯从楼下带上来的咖啡，没喝。\n\n"最近有场演出，我们连着排了几天。"她开口，声音比楼下低，"几天前，六月三号，排练到挺晚。散了以后，我走到半路发现水杯落在排练室，折回去拿。出来时正好碰上我们鼓手玛蒂尔达——她家往西，跟我有一段同路。"\n\n"鼓手全名是？"莱尔说。\n\n"玛蒂尔达·斯特林。"塞西莉补了全名，"我走她后头，大概二十步。那条路灯不多，我没太看清，只看见一个影子远远跟在她后面。"\n\n铜币停了一下，又走。\n\n"影子什么样？"\n\n"模糊。路灯把人影拉得很长，我看不清。"塞西莉摇头，"比正常人矮一截。走路没声音。"\n\n"没声音？"\n\n"对。那条路铺的是石板，皮鞋踩上去会有响。我跟在后面二十步，自己的脚步听得清清楚楚。但前面那个影子——没有。像脚不沾地。"\n\n莱尔没说话。铜币在指间滚了半圈。\n\n"我以为是狗仔。这种事我们碰过。"她说，"我掏出电话给玛蒂尔达说了下，让她注意身后。然后前面岔路，我往东，她往西。"\n\n"电话里她怎么说？"\n\n"她回头看了一眼，说没人。让我别大惊小怪。"塞西莉的指节扣着膝盖，"我也没多想。第二天问她昨晚有没有事，她说没有。"\n\n"但你没信。"\n\n塞西莉顿了一下。\n\n"她打鼓的节奏，差了一点。"\n\n莱尔抬眼看她。\n\n"差一点？"\n\n"玛蒂尔达的手腕很活，以前连打十六分音符都不抖。"塞西莉说，"这几天她打到高潮段会慢半拍。不是偶尔——是每一段高潮都慢。"\n\n"技术问题？"\n\n"不是。"塞西莉很确定，"我跟她合作六年了。她的手腕出过什么问题，什么时候状态好什么时候差，我听得出来。这不是状态问题。她整个人，动作比以前钝，反应也比以前慢。排练间隙叫她名字，她要愣一两秒才转头。以前不这样。"\n\n"你问她了？"\n\n"问了。她说没睡好。"塞西莉摇头，"可她看我的时候，眼神也不对。说不上来。像换了个人在用她的手。"\n\n铜币又停了。莱尔没抛，捏在指间。\n\n莱尔看了哈里特一眼。"她有没有提过被跟踪的感觉？哪怕一次。"\n\n"没有。"哈里特摇头，"一次都没有。"\n\n莱尔把铜币往桌上一抛，叮地落定。他靠回椅背。\n\n"治安所怎么说的？"\n\n"说我神经过敏——人又没失踪，没伤，可能是我自己错觉。"塞西莉语气平，"要么，他们说，就是碰上了异常事件，让我去找异常管理局。"\n\n"管理局怎么说？"\n\n"那边的人建议我来找您。"她看了眼哈里特，"下周就演出。我不能拿全队的质量赌她没事。"\n\n哈里特接话，声音稳："我们想知道跟在她后面的到底是什么。如果跟异常无关，我们另想办法；如果是异常，越早处理越好。"\n\n莱尔没急着回答。他拿起桌上那叠没拆的信封，翻了翻，又放下。\n\n"管理局没接，是因为粒子读数。"他说，"我猜他们调了那晚那条街的记录，凯莉米粒子浓度没过警戒线。"\n\n塞西莉点头。\n\n"浓度没过线，只说明一件事——"莱尔抬手，指节敲了敲桌面，"那晚发生的事，对现实搅动得不大。"\n\n他看塞西莉。\n\n"凯莉米粒子浓度，衡量的是现实被搅动的程度。浓度越高，现实被改得越狠。没过线，意思是现实的坑还没被刨深——不代表没人拿着铲子。"\n\n哈里特眉头动了一下。\n\n"举个例子。"莱尔从桌上拿起铜币，竖在桌面上，用指尖扶着，"有人用异能把一块石头变成金子，整条街的粒子浓度会爆表——仪器不可能漏掉。但有人只是用异能推了一下门，粒子波动大概和一阵风差不多。仪器分不清。"\n\n他把铜币推倒，铜币在桌面上滚了半圈，停住。\n\n"异能发动、异常器物活动，都会搅动粒子。"莱尔说，"可有些手段动得很轻。轻到仪器当它是背景噪音。"\n\n他顿了顿。\n\n"当然，也有专门屏蔽监测的道具——不过那种东西不便宜，用到一个小乐手身上的概率，不高。"\n\n办公室安静了一拍。窗外的街声远远传进来，有辆马车辘辘碾过石板路。\n\n塞西莉开口："那就是说，管理局测不出来，不代表没事。"\n\n"对。"莱尔说，"也不代表有事。但你们坐在这里，就说明你们觉得有事。"\n\n他站起来，走到窗边，看了一眼街面。一辆马车过去，几个行人。没什么异常。他转回来。\n\n"玛蒂尔达现在在哪？"\n\n"在家。今天没排练。"塞西莉说。\n\n"她知道你们来这里吗？"\n\n"不知道。她要是知道，可能反而不愿意。"\n\n莱尔点了一下头。没追问原因。\n\n他重新坐下，把铜币拿起来，在指间转。\n\n"我需要你帮我看清那个影子。"莱尔坐直，"那天晚上你远远看了一眼，记不住细节，可眼睛记住了。催眠能把那段记忆翻出来，侧写出那影子的模样。"\n\n"塞西莉小姐，请问你能接受催眠吗？"\n\n塞西莉的肩绷了一下。\n\n莱尔把铜币拎起来，"不会让你做不想做的事，只是让你把那晚看得更仔细一点。您的经纪人也会在一旁看着，放心。"\n\n"催眠？"塞西莉皱眉，"用那种怀表晃来晃去的方式？"\n\n"方式有很多。"莱尔笑了笑，"选哪种看情况。"\n\n塞西莉看了哈里特一眼。哈里特想了想，点头。\n\n"行。我需要怎么配合？"塞西莉说。\n\n"简单。"\n\n莱尔拉开最下面一层抽屉。\n\n他的手在抽屉里摸了一会。\n\n然后掏出一个针筒。\n\n玻璃管，刻度清晰，里头一管淡蓝液体，针尖在窗光下闪了一下。\n\n"……这是？"\n\n"红雪出的吐真剂。"莱尔把针筒举到光里端详，确认了下有效期。\n\n塞西莉和哈里特的脸同时白了。哈里特手里的杯子晃了一下，差点没端稳。\n\n"吐真剂？"哈里特放下杯子，声音压低了，"西奥多先生，这东西……合法吗？"\n\n"红雪正规出品，药房凭执照买。"莱尔说\n\n他把针筒横在桌上，淡蓝液体在玻璃管里晃了晃。\n\n"放心，吐真剂不是审讯药，低剂量下就是一针镇定剂——让人放松到能翻出深层记忆的程度。"他看着塞西莉，"你不会说出不想说的话。"\n\n塞西莉盯着针尖。窗光里那管淡蓝晃了一晃。	塞西莉详细讲述六月三日晚的经历。乐队排练结束后，她在铜锣巷口看见一道矮小黑影无声跟随玛蒂尔达，等她追上去时对方已经消失。此后玛蒂尔达打鼓总会钝上半拍，谈话反应变慢，眼神也像在模仿熟人。珀西瓦尔曾调取街区监测记录，发现当晚凯莉米粒子浓度始终处于常态，因此无法按异常案件受理。莱尔解释浓度只能反映现实受到扰动的程度，数值正常并不等于没有异能介入。他提出利用催眠还原黑影轮廓，随后却掏出吐真剂和针筒，声称效果更快。	2595	draft	f035327a-2add-4afe-bf92-2f2b9498cafa	2	{"key_events": ["塞西莉复述黑影跟踪玛蒂尔达的完整经过", "莱尔说明凯莉米粒子监测存在判断盲区", "莱尔通过吐真剂玩笑试探委托人并正式接案"], "character_focus": ["莱尔·西奥多", "塞西莉·辛克莱", "珀西瓦尔·费尔班克斯"], "emotional_tone": "紧张疑惑中夹杂诙谐", "narrative_goal": "补全案件起因，建立异常监测规则，并展现莱尔独特的询问手段", "conflict_type": "主观证词与官方监测结论之间的冲突", "estimated_words": 3300, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 00:34:12.688525
9dc2adf5-8afa-4116-a98e-e481ecd4c427	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8	断在暗巷的足迹	六月的云压在格雷文赫城上空，灰白一层，像港口烟囱吐出的煤灰没有散尽。海鸥掠过尖顶钟楼，翅尖擦着潮湿的风。再往下，是交错的蒸汽轨道、石板街和一排排漆黑屋脊。马车铃声沿街滚过，街角的异常粒子监测仪亮着绿灯，细针稳稳停在常态刻度。\n\n月季咖啡厅二楼，窗缝漏进一点凉气。\n\n莱尔站在窗边，看着塞西莉和哈里特穿过街面。哈里特走得快，高跟鞋敲得又急又脆。塞西莉落后半步，临上马车前，还回头看了一眼二楼。\n\n目光很冷。\n\n显然，那支装着吐真剂的针管，并没能替双方建立更多信任。\n\n马车门“砰”地合上。\n\n莱尔抬手碰了碰鼻尖，低声道：“至少省了一支药。”\n\n桌上的咖啡已经凉了。苦味混着消毒酒精的气味，实在算不上相配。他端起来喝了一口，眉头顿时皱紧。\n\n今天的豆子也不对。\n\n他放下杯子，目光落在塞西莉留下的地址上。\n\n六月三日，晚上九点。\n\n西区，铜锣巷口。\n\n排练散场。黑影跟踪。玛蒂尔达此后反应迟钝，打鼓慢了半拍。街角监测仪全程常态，异常管理局不予受理。\n\n莱尔用指节敲了敲纸面。\n\n常态，只能证明现实没有被大幅搅动。\n\n不能证明什么都没发生。\n\n他把纸条折起，塞进大衣内袋，抓起衣帽架上的软帽。帽檐扣下时，他顺手将那支没派上用场的针管锁回抽屉。\n\n咔哒。\n\n“真遗憾。”他说。\n\n楼下传来瓷杯碰撞声。格蕾丝太太在柜台后擦杯子，咖啡香裹着烤面包的热气，暖融融地堵在楼梯口。她没抬头，只看见一双鞋从台阶上下来。\n\n“晚饭前回来？”\n\n“看失踪的人给不给面子。”\n\n“你上次这么说，半夜带回来一只掉毛的猫。”\n\n“那位委托人付钱很痛快。”\n\n格蕾丝太太把抹布甩到肩上。\n\n“猫付的？”\n\n莱尔推门出去，没有回答。\n\n门铃叮当一响，冷风立刻灌了进来。\n\n西区铜锣巷离月季咖啡厅不远，坐公共蒸汽车只需四站。可车厢里挤满了刚从码头换班的工人，汗味、鱼腥和廉价烟草搅成一团。蒸汽阀每隔半分钟便“嗤”地泄一次气，热雾贴着裤腿漫开。\n\n莱尔只坐了一站便下了车。\n\n他宁愿走路。\n\n越往西，楼影越密。哥特式尖窗下搭着歪斜棚屋，晾衣绳横在两栋楼之间。卖鱼的把碎冰扫进排水沟，腥水沿石缝淌过。几个孩子赤脚追着运煤车跑，车轮卷起黑泥，溅在街边的异常报案指示牌上。\n\n牌子上写着：发现异常，请勿触碰。\n\n下面不知被谁添了一行小字。\n\n——除非治安所让你自己解决。\n\n莱尔扫了一眼，脚步没停。\n\n下午的铜锣巷比夜里热闹。\n\n鱼贩拍着案板叫卖，布商扯开嗓门招呼客人。拉车夫的咒骂、马铃声和婴儿哭声挤在一起。空气里有烂菜叶的酸味，也有煤气灯管道微微泄漏的臭气，吸进鼻腔，发涩。\n\n巷口立着一盏铁杆路灯。\n\n漆皮剥落。灯罩缺了一角。积灰的灯芯露在里面，与塞西莉描述的一样。\n\n莱尔没有立刻过去。\n\n他站在一家旧帽店的遮棚下，把帽檐压低一指。目光先掠过路灯，再扫向巷子深处。\n\n排练室在右侧第三栋楼。红漆木门，铜把手，门楣上钉着锈蔷薇乐队的旧海报。纸边被雨水泡卷，塞西莉的半张脸还露在外面。\n\n路灯斜对面有茶摊。再往里是邮筒、拴马桩和一排铁栏杆。\n\n适合盯梢的地方不少。\n\n适合藏身的地方更多。\n\n莱尔靠墙等了近一刻钟。等鱼车拐出巷口，等两名搬运工扛着木箱过去，也等茶摊老板将视线从他身上挪开。\n\n人流稀了一瞬。\n\n他这才走到路灯下，摘掉左手手套。\n\n铁杆冰凉，表面沾着一层细腻的煤灰。掌心贴上去时，寒意顺着指骨往上爬。\n\n莱尔闭上眼。\n\n耳边的叫卖声陡然远去。\n\n黑暗里，先浮出一团昏黄的灯光。\n\n那不是他的视野。\n\n画面立在巷口，僵硬，沉默，几十年如一日。\n\n夜里九点，煤气灯在风里轻晃。湿漉漉的石板反着光。一顶软呢帽从画面边缘探出来，帽檐压得很低，只露出一截下巴和深灰大衣的肩。\n\n那人贴着灯杆的阴影站定。\n\n不抽烟。不跺脚。\n\n也不看街上的女人和马车。\n\n他始终盯着排练室。\n\n远处传来两个女人的说话声。一个清亮，一个沉稳。软呢帽往阴影里缩了半步，鞋底落地极轻，几乎没声。\n\n莱尔睁开眼，松开手。\n\n现实的喧闹猛地撞回耳中。他的指尖僵了一下，掌心残留着针扎般的冷麻。铁杆表面，多出三点焦黑，像被细小火星舔过。\n\n茶摊老板盯着他。\n\n“先生，灯杆不卖。”\n\n“我也没钱买。”\n\n莱尔戴回手套，朝排练室走去。\n\n门边的砖墙受过潮，缝里卡着草屑。墙根积着鱼鳞和黑泥，几只苍蝇嗡嗡打转。他蹲下，手指按住一块磨损最重的墙砖。\n\n画面骤低。\n\n贴着地面。\n\n一双软底鞋踏过来，鞋尖在排练室方向停了两秒。鞋码不大，前掌宽，后跟窄。鞋底边缘有一道月牙形缺口。\n\n那人换过站位。\n\n莱尔收手，没有再逐块摸下去。\n\n软呢帽留下的路线已经很清楚。\n\n他沿巷子往西走。路过那块被车轮磨亮的石板时，只用指尖短暂碰了一下。一个矮小影子横穿巷面，腋下夹着薄本。深灰大衣摆擦过膝侧，脚步轻而稳定。\n\n邮筒给出的画面更短。\n\n玛蒂尔达先走过去。\n\n她背着黑色皮包，头微微低着，步子不快。十步之后，软呢帽从邮筒另一侧露出半张脸。他等了片刻，才无声跟上。\n\n不是顺路。\n\n是在计算距离。\n\n后面的线索零碎起来。\n\n门环记住一截灰色衣袖。橱窗映出被拉长的人影。铁栏杆上，雨水把画面切成细碎的亮斑。莱尔一路走，一路挑选能看见街面的旧物，掠过无用的行人和马车，把同一个影子从杂乱记忆里剥出来。\n\n他没有每次都停太久。\n\n碰一下。\n\n看一眼。\n\n再往前。\n\n记忆像被扯断的胶片，在他脑中迅速拼合。\n\n直到巷子中段，那排生锈的铁栏杆终于给了他一张完整的脸。\n\n矮个子。\n\n络腮胡没有修净。眉骨很深。右侧嘴角压着一道旧疤，笑不笑都显得阴沉。深灰大衣的袖口蹭着油墨，拇指与食指内侧也染成暗蓝黑色。\n\n他手里夹着薄本，边角露出一小片铅灰。\n\n印刷工。排字工。或者常年跟报纸打交道的人。\n\n莱尔将那张脸钉进脑子。\n\n身高，约五尺四寸。\n\n软底鞋，鞋底有月牙缺口。\n\n右嘴角旧疤。\n\n手染油墨。\n\n够治安所从档案里筛一遍了。\n\n他继续往前。\n\n巷尾的气味更重。下水道口堵着烂布和菜梗，潮气贴着墙根往上爬。头顶的天空被两排高楼夹成窄窄一条，云层已经压暗，风从西边灌进来，卷着雨前的土腥味。\n\n玛蒂尔达的路线在这里拐向一片空地。\n\n那是拆掉旧仓房后留下的泥场。地面坑洼，散着碎砖、锈钉和烧黑的木头。几辆货车从大路轧过，车轮陷进软泥，发出黏滞的“咯吱”声。\n\n莱尔站在泥地边缘，先摸了路旁的拴马桩。\n\n潮湿的木头寒得刺手。\n\n画面里，六月三日的细雨斜斜落下。\n\n玛蒂尔达走进空地。黑色皮包贴着她的腰侧，一晃，一晃。她没有回头，也没有加快脚步。\n\n几秒后，软呢帽出现在后方。\n\n两道影子一前一后，走进雨幕。\n\n然后，一辆运货马车横穿过去。\n\n车轮卷起泥水。\n\n画面再露出来时，脚印已经乱了。\n\n莱尔维持着触碰，没有松手。\n\n拴马桩能记住的只有它所看见的地方。玛蒂尔达出了那一小片视野，便像被夜色吞掉。之后的雨、车辙和无数双鞋，将残余的足迹一层层踩烂。\n\n什么都没有。\n\n他睁开眼。\n\n风恰在这时转向。\n\n冷气从袖口钻进去，贴着汗湿的皮肤往上爬。莱尔的左手仍按在木桩上，指节因为用力微微发白。掌下那块木头慢慢焦黑，细小裂纹无声绽开。\n\n他松开手。\n\n掌心失去知觉似的僵了两息，才重新屈起。\n\n空地很宽。\n\n天色却低得让人喘不过气。\n\n玛蒂尔达那晚还好好走着。没有奔逃，没有呼救。她甚至不知道身后有人，或者知道了，也没有表现出来。\n\n再往后，便没有物件替她看见。\n\n莱尔踩进泥地，绕着边缘走了一圈。碎砖看见的只是车轮。废弃铁桶记住几个醉汉。路旁一块广告牌在那晚被风吹倒，视野始终埋在泥里。\n\n没有玛蒂尔达。\n\n他折回软呢帽最后出现的位置。\n\n矮个子没有继续横穿空地，而是在岔口拐进左侧暗巷。那条巷子夹在两座新修的仓库之间，窄得只能容两人并肩。墙面刚刷过石灰，潮白一片。没有煤气灯，也没有监测仪。门窗全封着，连个能映出人影的玻璃都找不到。\n\n莱尔摸过巷口的铁栅栏。\n\n画面里，软呢帽侧身进去。\n\n灰色大衣被黑暗一点点吞没。\n\n没了。\n\n他又碰了门环、排水管和墙角残留的旧砖。能看见的角度全不对。最后一块旧砖只记住一只老鼠从水沟钻过，尾巴拖着污水。\n\n两条线，都断在这里。\n\n一条断在空地。\n\n一条断在暗巷。\n\n莱尔站在岔路口，身后是车马不断的大路，面前是没有灯的窄巷。风卷过空地，把一张旧报纸推到他脚边。纸面沾满泥，只剩半行印刷厂的招工启事。\n\n他低头看了两秒，用鞋尖将报纸翻过来。\n\n空白背面，一枚模糊的鞋印压在纸角。\n\n不属于那一晚。泥还是新的。\n\n没用。\n\n莱尔弯腰捡起报纸，目光却停在那半行铅字上。\n\n印刷。\n\n油墨。\n\n薄本。\n\n他把报纸折好，塞进大衣口袋。随后摸出一枚铜币，在指间翻了半圈。\n\n铜币贴着掌心，凉得像刚才那根拴马桩。\n\n玛蒂尔达可能回了家。\n\n也可能，她从来没有走出那片空地。\n\n莱尔捏住铜币，抬眼望向巷外。街角的煤气灯尚未点亮，异常粒子监测仪仍闪着安稳的绿光，仿佛六月三日的夜里也确实什么都没发生。\n\n他把铜币收回兜里。\n\n先查脸。\n\n再查油墨。\n\n治安所若没有答案，城里总有些不写进档案的人认得这张脸。\n\n莱尔转身走出暗巷。鞋底碾过湿泥，留下两行清楚的足迹。\n\n风很快追了上来。	莱尔来到铜锣巷重新丈量塞西莉与玛蒂尔达当晚的行进路线。他依次触碰墙砖、旧路灯底座和被撞歪的垃圾箱，利用异能读取物件残留的片段记忆。混乱影像中，他拼出跟踪者的外貌特征，对方身材矮壮，留着络腮胡，眉骨深陷，嘴角有疤，手指沾有难以洗净的油墨。莱尔还发现跟踪者故意在不同路段更换步态，并留下两条相反方向的痕迹，然而两条痕迹都在一条没有监测仪的暗巷中凭空中断。频繁使用异能让莱尔出现短暂眩晕，他仍前往治安管理所核对档案，却找不到符合特征的人。离开前，他请珀西瓦尔查询印刷工与雕刻工名单，自己则将人物侧写送往灰烬酒馆。	3749	draft	f035327a-2add-4afe-bf92-2f2b9498cafa	3	{"key_events": ["莱尔在铜锣巷读取多件物品残留的环境记忆", "跟踪者的外貌与油墨特征被完整侧写出来", "官方档案比对失败后莱尔转向地下情报渠道"], "character_focus": ["莱尔·西奥多", "珀西瓦尔·费尔班克斯"], "emotional_tone": "冷静查证与步步受阻的压迫感", "narrative_goal": "展示莱尔异能的使用方式与代价，将案件从普通跟踪引向有预谋的迷惑行动", "conflict_type": "侦查追踪与人为清除痕迹的对抗", "estimated_words": 3500, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 00:48:57.531475
4d262ba5-cb6e-4829-b2d4-00385a36e2c3	d59e468a-8617-41e0-aabf-87a13be78834	3	霜痕与暗涌	\N	在照料宗门药园以换取微薄修炼资源的过程中，张羽遇到了为救重病亲人而忍气吞声、倔强柔软的柳若霜。她说话轻声细语，对草药有天然的亲近感，记忆力极好，能从一炉废丹的余烬中推测出配方。为了换取一株完整的天星草救亲人，她不惜以身试药。张羽利用前世的知识（伪装成偶然发现），帮助柳若霜解决了一株珍贵灵植的枯死危机，两人达成互助同盟，互相掩盖秘密。期间，张羽在底层挣扎中敏锐地察觉到灵气中那一丝若有若无的驳杂与腐朽气息，以及外门弟子在突破时偶尔流露出的神魂透支异象，这为他后续探索世界真相埋下了深深的伏笔。卷末，宗门举行外门选拔考核，杂役亦有一线生机。张羽面临暴露的危机，必须在实战中不露馅。他利用对敌人招式的极致预判和地形利用，如履薄冰般勉强过关。然而，考核中一次极限爆发（实为濒临暴露的应急操作）意外引动了测灵碑的共鸣，其'隐灵根'的特殊性引起了外门执事的注意，获得了破格升入外门的契机，同时也引来了某些有心人的暗中窥探。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	3	{"key_events": ["药园劳作遇柳若霜", "帮助解决灵植枯死危机达成互助同盟", "察觉灵气驳杂与神魂透支异象", "外门选拔实战勉强过关", "极限爆发引动测灵碑共鸣破格入外门"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "隐忍紧张、希望与危机并存", "narrative_goal": "引入柳若霜建立互助同盟，埋下世界真相伏笔，完成卷末破格晋升的转折铺垫", "conflict_type": "生存危机（暴露风险 vs 晋升机会）", "estimated_words": 3000, "scenes": null}	2026-09-20 16:04:12.436117	2026-09-20 16:04:12.436117
214ed068-75b2-477d-ae83-d83ae98afb96	7f6d28c4-2a32-46d1-887c-6cf5c4555056	11	清醒者的缺口	天刚亮，港区还泡在灰白的雾里。诊疗所的烟囱冒着黑烟，煤炉烧得太旺，碘酒味混着煮纱布的热气，从门缝一路钻到街上。\n\n莱尔坐在二楼走廊，膝上摊着一份晨报。六码头的事只占了豆腐大的一块，标题是“废弃货仓查获违禁剧具”。没有绑架，没有木偶，也没有异常管理局。\n\n写得真干净。\n\n病房里传出一声脆响。\n\n莱尔折起报纸，推门进去。\n\n药杯滚到床脚，里面的水洒了一地。玛蒂尔达半撑着身子，脸色发白，右手死死抓着被角。\n\n塞西莉站在床边，没敢碰她。\n\n“护士刚给她换药。”她压低声音，“她睡着以后一直在说话。”\n\n“说什么？”\n\n“别学我。”\n\n床上的人抬起头。\n\n短发贴在额前，眼下发青。她看了莱尔半天，才认出他。\n\n“我睡了多久？”\n\n“六个小时。”\n\n“我还以为……”玛蒂尔达扫了眼窗户，又去看门，“这里锁了吗？”\n\n莱尔走过去，推了推门。\n\n“没锁。楼下有两个治安官，窗外是三层楼。你想走门，没人拦。想走窗，我建议等手腕好了再试。”\n\n玛蒂尔达盯着敞开的门，手指松了些。\n\n塞西莉捡起药杯。\n\n“你昨天下午不该去排练。”\n\n“我能打。”\n\n“你只打了四小节。”\n\n“那是鼓槌太轻。”\n\n“你以前拿筷子都能打。”\n\n玛蒂尔达嘴唇动了动，没顶回去。\n\n莱尔拉来椅子，在离床两步远的位置坐下。他没拿记录本，也没问货仓。\n\n“早餐想吃什么？”\n\n玛蒂尔达愣住。\n\n“什么？”\n\n“楼下有燕麦粥和煎蛋。粥很难吃，蛋也焦了。选一个。”\n\n“这算哪门子选择？”\n\n“港区诊疗所的待客之道。”\n\n“煎蛋。”\n\n“几面熟？”\n\n“两面。边要脆。”\n\n莱尔朝塞西莉伸手。塞西莉把桌上的水壶递给他。\n\n“平时喝茶还是咖啡？”\n\n“咖啡。”\n\n“加糖？”\n\n“两块。”\n\n“你的鼓是什么颜色？”\n\n“暗红。”\n\n“左脚还是右脚先踩底鼓？”\n\n“右——”\n\n玛蒂尔达卡住了。\n\n她低头看向自己的脚，右脚往被子里缩了缩。\n\n病房静下来。楼下有人推过装药瓶的车，轮子轧着木地板，咯噔，咯噔。\n\n莱尔倒了半杯水。\n\n“不急。答错也没人扣钱。”\n\n“我没答错。”\n\n“那就算对。”\n\n“什么叫算对？本来就是右脚。”\n\n“好，右脚。”\n\n玛蒂尔达看着他，呼吸慢慢稳下来。她接过杯子，没喝，只贴在掌心里暖手。\n\n“她也问过。”\n\n塞西莉抬起头。\n\n莱尔没有追问，只把水壶放回桌上。\n\n玛蒂尔达盯着杯沿。\n\n“那个穿斗篷的女人。她每天都来，有时候一天两次。先给我打针，再把那东西推过来。”\n\n“木偶？”\n\n“没脸的那个。”\n\n她肩膀绷紧，杯里的水晃到手背上。\n\n“她让我握鼓槌。正着握，反着握，打十六分音。她看手指，看手腕，还看我累的时候会把鼓槌往哪儿放。”\n\n塞西莉的指甲刮过药杯，发出刺耳的一声。\n\n玛蒂尔达看了她一眼。\n\n“她还让我说话。叫塞西莉的名字，骂哈里特，问演出费什么时候结。每句话都得说很多遍。语气不对，她就让我重来。”\n\n“她打你了？”塞西莉问。\n\n“没有。”\n\n玛蒂尔达把右手藏进毯子底下。\n\n“针。他们有一种针，扎完人是醒着的，手脚却动不了。眼睛也闭不上。她就坐在旁边，让木偶学我眨眼。”\n\n塞西莉别开脸，把药杯放到柜上。\n\n咔。\n\n杯底磕出一道裂口。\n\n莱尔仍坐在原处。\n\n“签名呢？”\n\n玛蒂尔达用左手比画了一下。\n\n“每天写。演出单、收据、欠条，还有给乐迷的签名。她说我的‘斯特林’收尾太快，木偶学不像。”\n\n“她怎么知道哪些细节有用？”\n\n“不知道。”\n\n“绑架那晚，你见过几个人？”\n\n玛蒂尔达的手停住了。\n\n墙上的钟走了两格。\n\n她闭上眼，又立刻睁开。视线钉在门口，额角沁出冷汗。\n\n“巷子……马车……有人按住我。后面没了。”\n\n“那就别想了。”\n\n“可你们要证词。”\n\n“治安所要。不是我。”\n\n莱尔把报纸摊开，指了指角落里那则小得可怜的报道。\n\n“他们连抓了什么都不敢写清楚，不差你今天这一页。”\n\n玛蒂尔达低头看报纸。她看不进去，还是盯了很久。\n\n护士把煎蛋送来，边缘果然焦黑。莱尔将盘子递过去。\n\n“先吃。”\n\n“我不饿。”\n\n“那就骂厨子。”\n\n玛蒂尔达拿起叉子，戳破蛋黄。\n\n“这东西也配叫煎蛋？”\n\n“很好，语气没被学走。”\n\n她哼了一声，切下一小块塞进嘴里。\n\n塞西莉拉开窗帘。雾后透进一点白光，照在床尾那双旧皮鞋上。鞋带洗过，没洗净，缝里还留着货仓的黑油。\n\n玛蒂尔达吃了半个蛋，忽然停下。\n\n“入场口令。”\n\n莱尔看向她。\n\n“什么？”\n\n“她问过我。演出前，从后台通道进去的口令。”\n\n塞西莉转过身：“哪个口令？”\n\n“六月八号那次。旧口令不是‘红酒’，临时换了。”\n\n叉子从玛蒂尔达手里滑下，碰在盘边。\n\n“她说，‘钟坏在十一点’。”\n\n塞西莉脸上的血色褪了。\n\n莱尔记得那场演出。替身出现前，锈蔷薇在城南剧院有过一次临时加场。后台丢过器材，乐队便在开演前换了入场暗号。\n\n“你告诉过她？”他问。\n\n“没有。我当时还被绑着。她进门第一句话就是这个。”\n\n“会场工作人员知道吗？”\n\n塞西莉摇头。\n\n“旧流程表印了二十份，新版没送印。哈里特改完以后，只誊了六份。”\n\n“都给了谁？”\n\n“我们四个，哈里特，还有剧院的舞台主管。”\n\n“普通工作人员呢？”\n\n“他们只知道有人对接，不知道口令。”\n\n玛蒂尔达握住叉子，指节发白。\n\n“那女人还说，口令是我提议改的。她连我当时骂了什么都知道。”\n\n塞西莉走到床边。\n\n“你骂了什么？”\n\n“‘再丢一根鼓槌，我就拿贝斯手的脑袋敲鼓。’”\n\n没人笑。\n\n塞西莉低头看着她，眼神变得陌生。不是冲玛蒂尔达，而是越过她，看向那几个熟得不能再熟的名字。\n\n新版流程表没有离开过乐队的休息室。\n\n莱尔起身，从大衣里取出铅笔，在报纸空白处写下六个人。他写得很慢，每一个名字之间都留了空。\n\n塞西莉看见自己的名字排在第二行。\n\n“你怀疑我们？”\n\n“我怀疑拿到过纸的人。”\n\n“这有什么区别？”\n\n“有。”莱尔把铅笔搁在桌上，“怀疑人，会先找动机。怀疑纸，只看它经过谁的手。”\n\n塞西莉没接话。\n\n玛蒂尔达把盘子推远。\n\n“我的那份在鼓包夹层。演出结束后就没见了。”\n\n“确定？”\n\n“我找过。以为掉在后台。”\n\n莱尔在她名字后画了一道短线。\n\n“其他五份呢？”\n\n塞西莉的目光落向窗外。港区汽笛响了，低沉的声音压过街上的车轮。\n\n“我那份还在。哈里特的应该也在。”\n\n“应该？”\n\n塞西莉抿住嘴。\n\n几分钟前，她还在替玛蒂尔达整理被角。现在她却站得离床远了半步，手也离开了床栏。\n\n玛蒂尔达看见了。\n\n她没说话，只把毯子往上拉，盖住缠着纱布的手腕。\n\n莱尔收起那张写了名字的报纸。\n\n“今天不排练。”\n\n“演出还有五天。”塞西莉说。\n\n“那就让主办方退票。”\n\n“违约金呢？”\n\n“算在委托费里。”\n\n“你付不起。”\n\n“所以我准备赖账。”\n\n塞西莉还是没笑。\n\n莱尔走到门边，又停下。\n\n“把六份流程表都找出来。别问别人为什么，也别在乐队里提口令。”\n\n“如果少了呢？”\n\n“先看少的是谁的。”\n\n塞西莉点头，拿起外套往外走。经过病床时，她脚步顿了一下，最终只说：“我晚上再来。”\n\n门合上后，玛蒂尔达盯着那道门缝。\n\n“她开始怕我了。”\n\n“她怕的不是你。”\n\n“有区别吗？”\n\n莱尔把煎蛋重新推回她面前。\n\n“有。你是真的。怕也得慢慢适应。”\n\n玛蒂尔达低头吃了一口，嚼得很用力。\n\n走廊外，塞西莉没有离开。她靠着墙，从口袋里摸出排练室钥匙，攥了半天。\n\n金属齿硌进掌心。\n\n她松开手，钥匙上沾了一点血。	天刚亮，港区还泡在灰白的雾里。诊疗所的烟囱冒着黑烟，煤炉烧得太旺，碘酒味混着煮纱布的热气，从门缝一路钻到街上。 莱尔坐在二楼走廊，膝上摊着一份晨报。六码头的事只占了豆腐大的一块，标题是“废弃货仓查获违禁剧具”。没有绑架，没有木偶，也没有异常管理局。 写得真干净。 病房里传出一声脆响。 莱尔折起报纸，推门进去。 药杯滚到床脚，里面的水洒了一地。玛蒂尔达半撑着身子，脸色发白，右手死死抓着被角。 塞西莉站在床边，没敢碰她。 “护士刚给她换药。”她压低声音，“她睡着以后一直在说话。” “说什么？” “别学我。” 床上的人抬起头。 短发贴在额前，眼下发青。她看了莱尔半天，才认出他。 “我睡了多久？” “	3073	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	6	{"key_events": ["玛蒂尔达在诊疗所讲述囚禁期间遭到行为模仿训练的经历", "莱尔帮助玛蒂尔达整理破碎记忆并确认她暂时无法正常登台", "绑匪掌握乐队临时入场暗号的事实引发内部泄密疑云"], "character_focus": ["莱尔·西奥多", "玛蒂尔达·斯特林", "塞西莉·辛克莱"], "emotional_tone": "劫后余生中的不安与猜疑", "narrative_goal": "补充受害者视角，表现替身事件造成的心理伤害，并将调查重心转向情报泄露途径", "conflict_type": "心理创伤与信任危机", "estimated_words": 3000, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 10:56:09.920378
3a3c0348-8880-48ae-864b-43b34f4fb616	d59e468a-8617-41e0-aabf-87a13be78834	14	矿渊低语		石铁心在矿洞深处作业时，听到矿脉中传来微弱的悲鸣。他循声寻找，发现一处被封闭的古老矿道。他潜入其中，目睹了灵气被某种力量缓慢抽走的景象。他试图采集样本时触发了隐藏的禁制，引发小规模坍塌。张羽和墨渊闻讯赶来，三人协作脱险。回到地面后，石铁心将所见告知二人，三人对宗门的怀疑加深了一层。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	14	{"key_events": ["石铁心听到矿脉悲鸣", "发现封闭矿道", "目睹灵气被抽取", "触发禁制脱险"], "character_focus": ["石铁心", "张羽"], "emotional_tone": "神秘、紧张，劫后余生的凝重", "narrative_goal": "强化石铁心的角色，深化三人关系，发现新线索", "conflict_type": "外部冲突（矿洞危险）与内心冲突（对宗门的怀疑）", "estimated_words": 3000, "scenes": null}	2026-09-20 19:39:43.772064	2026-09-20 19:39:43.772064
c4efe80f-52e1-47bd-a59a-e7efd3e8014e	d59e468a-8617-41e0-aabf-87a13be78834	15	暗涌		外门选拔考核临近，张羽感受到来自各方的压力。他在准备过程中必须谨慎平衡：既要展示足够的实力通过考核，又不能暴露无灵根的真相。柳若霜的亲人病情突然加重，她急需一株珍贵灵草入药。张羽和墨渊暗中相助，冒险从药园中取来灵草。然而，他们的频繁接触引起了有心人的注意，三人同盟面临暴露的风险。张羽意识到，考核不仅是实力的考验，更是对他伪装能力的终极挑战。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	15	{"key_events": ["张羽面临考核准备压力", "柳若霜亲人病情加重", "三人冒险相助", "同盟引起注意"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "焦虑、紧迫，友情与危机交织", "narrative_goal": "为卷末考核做铺垫，制造紧张感，深化角色关系", "conflict_type": "内心冲突（隐藏与暴露）与外部冲突（时间压力、外部监视）", "estimated_words": 3000, "scenes": null}	2026-09-20 19:39:43.772064	2026-09-20 19:39:43.772064
0a1c863d-9b88-4435-88eb-587961aa88c4	d59e468a-8617-41e0-aabf-87a13be78834	25	藏经阁深处的残卷	\N	深夜，墨渊独自潜入藏经阁最偏僻的角落，翻阅积满灰尘的古老典籍。他根据玉简中的线索，找到了三百年前灵潮纪元初期的记录。在一本残破的手札中，他发现了关于天启之门的详细描述：开启天启之门需要以大量修士的神魂为祭品，而祭天大典正是这个血腥仪式的掩护。手札还提到，噬界者降临前会有灵气剧烈波动的征兆。更令墨渊心惊的是，手札中记载的祭天日期与宗门公布的日期不符，真正的仪式可能在三天后举行。他意识到时间远比想象中紧迫，必须尽快将这个消息告知同伴。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	29	{"key_events": ["墨渊在藏经阁发现记载天启之门开启仪式的残破手札", "手札揭示祭天大典的真正目的是以修士神魂为祭品打开天启之门", "墨渊发现真正的祭天日期比宗门公布的时间提前了三天"], "character_focus": ["墨渊", "张羽"], "emotional_tone": "紧张、急迫", "narrative_goal": "揭示祭天大典的真正目的，推动时间线紧迫感", "conflict_type": "时间压力与信息差", "estimated_words": 3000, "scenes": null}	2026-09-20 16:10:47.985217	2026-09-20 19:41:19.413742
c0a34e67-01f7-49c3-92cf-986d9824453b	7f6d28c4-2a32-46d1-887c-6cf5c4555056	15	迟半拍的鼓声	鼓槌在鼓面上横了一夜。\n\n第二天傍晚，钟楼剧院亮起整排煤气灯。长队从正门绕过报刊亭，一直排到街角。马车堵在雨后的泥水里，车夫骂个不停，卖热栗子的铁锅冒着白汽。\n\n钟楼下，有人举着“锈蔷薇不会登台”的号外。\n\n更多人把报纸折起来，塞进外套，继续往前挪。\n\n后台比外面更闷。\n\n脂粉、汗和烧热的电线混在一起。隔着幕布，观众的说话声压成一片，偶尔有人跺脚，震得化妆镜上的灯泡发颤。\n\n玛蒂尔达坐在木箱上，演出服已经换好。鼓槌却还装在皮套里。\n\n哈里特扯下手套，又戴回去。\n\n“让候补鼓手上。”\n\n“没有候补。”塞西莉说。\n\n“临时找一个。剧院乐队里总有人会打。”\n\n“会打和能跟上我们，是两回事。”\n\n“那也比台上停住强。”\n\n键盘手坐在墙角，一声没吭。小号手把铜管擦了三遍，还是在同一个地方打转。\n\n哈里特转向玛蒂尔达。\n\n“我不是要赶你走。”\n\n“我知道。”\n\n“就这一晚。”\n\n玛蒂尔达抬头看她。\n\n“那明晚呢？”\n\n哈里特张了张嘴。\n\n没人接话。\n\n走廊外响起三声敲门。舞台经理探进半个脑袋，额头全是汗。\n\n“还有十二分钟。开场曲再不定，我就按原单报幕了。”\n\n塞西莉把曲目单折起。\n\n“等两分钟。”\n\n门关上，外头立刻有人跑过。鞋底踩着木板，咚咚直响。\n\n玛蒂尔达盯着地面。\n\n“让别人上吧。”\n\n塞西莉的手搭在贝斯盒上，没动。\n\n“你真这么想？”\n\n“至少不会毁掉演出。”\n\n“你不登台，他们才算赢了。”莱尔靠在门边。\n\n屋里的人一齐看过来。\n\n他今晚没戴礼帽，手杖也寄存在前厅，只留一把枪藏在外套下。领口仍旧整齐，像是来听音乐，不是来看一群人吵架。\n\n哈里特皱眉。\n\n“西奥多先生，我们现在缺的是鼓手。”\n\n“你们有。”\n\n“她拿不起鼓槌。”\n\n“所以换一首不需要她立刻拿起来的歌。”\n\n哈里特一怔。\n\n莱尔看向玛蒂尔达。\n\n“木偶替你排练，替你背包，连迟拍都学会了。绑你的人费这么大劲，不只想毁掉今晚。”\n\n玛蒂尔达的鞋尖缩了回去。\n\n“他们想让你看着那个东西，觉得自己没什么特别。手腕、节拍、站位，都能拆下来装在另一具身体上。”\n\n莱尔抬手，敲了敲墙。\n\n隔壁有人试音。四下，整整齐齐。\n\n“等你自己也信了，以后不需要木偶。空鼓凳就够了。”\n\n屋里只剩灯泡的电流声。\n\n塞西莉抽出曲目单，拿笔划掉最上面三首。\n\n“《雾港摇篮曲》开场。”\n\n哈里特看过去。\n\n“那首没有前奏。”\n\n“你先清唱。”\n\n“清唱多久？”\n\n塞西莉看向玛蒂尔达。\n\n“多久都行。”\n\n键盘手站起来：“第二段我进和弦。”\n\n小号手把擦布塞进口袋。\n\n“第三段再加铜管。鼓不用追我们，我们等她。”\n\n哈里特抓了抓头发。\n\n“临时改成这样，台下会以为我们疯了。”\n\n“昨日报纸已经这么写了。”莱尔说，“没什么损失。”\n\n哈里特瞪他一眼，转身抓起麦克风线。\n\n“行。要疯一起疯。”\n\n塞西莉走到玛蒂尔达面前，没有伸手。\n\n“你可以坐在鼓架后。今晚不敲也行。”\n\n“那我上去做什么？”\n\n“占住你的位置。”\n\n前厅的铃响了。\n\n还有五分钟。\n\n玛蒂尔达弯腰打开皮套。她试了两次，才把鼓槌拿出来。\n\n“我可能会慢。”\n\n塞西莉背起贝斯。\n\n“你本来就慢半拍。”\n\n玛蒂尔达抬眼，骂了一句。\n\n塞西莉笑了。\n\n幕布外，第一排十二号座位空着。\n\n椅背上放着一张黑框讣告。照片里的奥斯汀·柯尔留着厚胡子，已经死了三年。那张从空壳公司转了三道账买来的贵宾票，压在相框下。\n\n旁边正是委员会评审席。\n\n两名记者认出了讣告上的名字，趴在座位边抄票号。珀西瓦尔站在过道里，管理局制服的肩扣被灯照得发亮。\n\n一个灰衣男人挤到第一排，伸手去拿相框。\n\n莱尔从侧门出来。\n\n“柯尔先生？”\n\n男人的手停住。\n\n“我找错座位了。”\n\n“十二号，没错。”\n\n男人后退半步。外套领口随动作翻开，露出一小块金色珐琅。\n\n鸟笼。\n\n珀西瓦尔扣住他的手腕，从内袋搜出印务厂的临时通行牌。牌角沾着蓝黑油墨，与七三七号废稿上的压痕一致。\n\n男人还想挣，另一只手已经被反拧到背后。\n\n“轻点。”莱尔扶正相框，“别打扰死者听演出。”\n\n珀西瓦尔看了他一眼。\n\n“你故意把票根消息递给金笼？”\n\n“我只是通知购票人按时到场。”\n\n“他死了。”\n\n“所以来的肯定不是他。”\n\n灰衣男人被带离前厅。附近观众伸长脖子，报社记者跟着追了出去。\n\n铃声再次响起。\n\n灯灭了。\n\n剧场陷入黑暗，只剩安全门上方一小块绿光。人声一点点低下去，幕布摩擦着滑轨升起。\n\n哈里特独自站在台前。\n\n没有鼓，没有琴。\n\n她开口时，嗓音很低。第一句甚至没压过最后几声咳嗽。\n\n第二句，剧院安静了。\n\n塞西莉站在暗处，指尖按着琴弦，没有弹。玛蒂尔达坐在鼓架后，台下全是模糊的人脸。灯光发热，汗沿着她的鬓角往下淌。\n\n鼓槌贴在掌心。\n\n货仓里的敲击声又来了。\n\n嗒。\n\n嗒。\n\n木偶顶着她的脸，膝盖一下下抬起。\n\n玛蒂尔达把右脚踩住底鼓踏板。\n\n哈里特唱到第二段。键盘从后方接入，只有几个缓慢的和弦。\n\n塞西莉还是没动。\n\n她在等。\n\n玛蒂尔达抬起右手。\n\n手腕僵得发疼。\n\n咚。\n\n第一声鼓落下。\n\n迟了半拍。\n\n前排有人动了一下。评审席上的笔尖也停住了。\n\n玛蒂尔达没抬头。\n\n第二声仍旧慢。\n\n第三声贴近了些。\n\n塞西莉拨响低音弦。不是催促，只在她迟到的位置上垫了一下。\n\n咚。\n\n鼓点追了上来。\n\n小号在第三段加入。哈里特的声音拔高，舞台灯一盏盏亮起。玛蒂尔达左手还在抖，右手却已经砸下第二组节奏。\n\n咚！咚！\n\n最后一拍快了。\n\n活人会快，会慢，会漏掉一个音，再从下一个小节钻回来。\n\n木偶不会。\n\n塞西莉转过身，背靠着玛蒂尔达。贝斯的低音压住鼓面余震。\n\n“跟紧。”她说。\n\n“少管我。”\n\n鼓槌落下。\n\n这次正好。\n\n第一首结束，台下静了不到一秒。\n\n掌声撞上穹顶。\n\n玛蒂尔达坐在灯里，手指仍抓着鼓槌。她喘得厉害，眼妆被汗冲开一小块。\n\n哈里特回头。\n\n“下一首？”\n\n玛蒂尔达在鼓边敲了四下。\n\n“一、二、三、四。”\n\n整支乐队同时切入。\n\n演出结束时，钟楼已经过了十一点。\n\n观众从正门涌上街，哼着最后一首歌。第一排十二号仍空着，黑框照片却被人转向舞台，票根安安稳稳压在下面。\n\n三天后，珀西瓦尔来到月季楼。\n\n他把盖有异常管理局、治安所和检察署印章的文件放上桌。纸很厚，边缘硌手。\n\n“替身案正式结清。灰衣人承认偷取废稿，也承认替金笼演艺传递口令。斗篷女人改了证词，薇奥拉和赫伯特的案子转入公诉。”\n\n莱尔翻到最后一页。\n\n“委托费能报销吗？”\n\n“不能。”\n\n“那你来做什么？”\n\n“通知你结案。”\n\n珀西瓦尔起身，又停了一下。\n\n“演出不错。”\n\n“你慢了三天才说。”\n\n“管理局办事要走流程。”\n\n楼梯上传来高跟鞋声。\n\n格蕾丝推门进来，怀里抱着账本。\n\n“西奥多先生，房租也有流程。”\n\n莱尔合上结案文件。\n\n“哪一部分？”\n\n“先交钱，再继续住。”\n\n“我刚办完一桩大案。”\n\n“所以你有钱了。”\n\n莱尔摸了摸口袋，只摸出两枚硬币和一张剧院饮品券。\n\n门外忽然响起狗叫。\n\n一个戴软帽的老太太撞开门，怀里死死抱着一条猎犬。猎犬嘴边沾着白色碎屑，尾巴把门框拍得啪啪响。\n\n“侦探先生，您得救救它！”\n\n格蕾丝低头看狗。\n\n“它怎么了？”\n\n老太太压低声音。\n\n“公寓里的人都说，是它偷走了管理员的假牙。”\n\n猎犬张开嘴。\n\n半副假牙从舌头底下掉出来，落在莱尔刚签好的结案文件上。\n\n莱尔看了两秒，把休息室的门重新推开。\n\n“请坐。”\n\n格蕾丝敲了敲账本。\n\n“房租。”\n\n“先记在狗的委托费里。”	鼓槌在鼓面上横了一夜。 第二天傍晚，钟楼剧院亮起整排煤气灯。长队从正门绕过报刊亭，一直排到街角。马车堵在雨后的泥水里，车夫骂个不停，卖热栗子的铁锅冒着白汽。 钟楼下，有人举着“锈蔷薇不会登台”的号外。 更多人把报纸折起来，塞进外套，继续往前挪。 后台比外面更闷。 脂粉、汗和烧热的电线混在一起。隔着幕布，观众的说话声压成一片，偶尔有人跺脚，震得化妆镜上的灯泡发颤。 玛蒂尔达坐在木箱上，演出服已经换好。鼓槌却还装在皮套里。 哈里特扯下手套，又戴回去。 “让候补鼓手上。” “没有候补。”塞西莉说。 “临时找一个。剧院乐队里总有人会打。” “会打和能跟上我们，是两回事。” “那也比台上停住强。” 键盘	3113	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	10	{"key_events": ["锈蔷薇成员共同调整演出方案以支持玛蒂尔达重新登台", "玛蒂尔达克服替身事件留下的恐惧并完成公开演奏", "事务所收到结案文件后以新的古怪日常委托收束事件"], "character_focus": ["玛蒂尔达·斯特林", "塞西莉·辛克莱", "莱尔·西奥多"], "emotional_tone": "温暖振奋并带有轻松余韵", "narrative_goal": "完成替身案件的情感收束，强调真实自我无法被完美复制，并恢复侦探事务所的日常节奏", "conflict_type": "自我认同与团队协作", "estimated_words": 3200, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 11:15:47.505194
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	6	月季楼上的侦探	时间一晃，已过去十五年。\n\n西奥多侦探事务所，清晨。\n\n铜币在指间翻了半个圈，落回掌心。莱尔把帽子扣回头上，帽檐压低一指宽。镜子里的人回敬他一个不咸不淡的眼神。将腰间皮枪套贴着肋骨放好，左手那根黑色金属手杖拄在地上，比他半个身子还高一截。\n\n莱尔抬眼看墙上的钟。\n\n七点半。\n\n他把镇纸挪开，完结的委托单叠好放进抽屉，又拿起手杖在掌心掂了掂。杖身沉，握柄旋开是一柄短剑，旋回去是一根再普通不过的绅士手杖。\n\n下楼。\n\n楼梯是木的，踩到第三级会响。莱尔绕开那一档，习惯刻进脚底。一楼的门没关严，月季咖啡厅的早餐味从门缝漫上来——先到的是黄油，然后是咖啡，再往下是刚出炉的面包。每天这个时辰，格蕾丝太太已经把第一锅咖啡煮好了。\n\n"早安，格蕾丝太太。"\n\n柜台后的女人抬头，手里攥着抹布。"莱尔先生，你也早。"\n\n格蕾丝太太五十出头，圆脸，围裙系得比马甲还紧。一楼是她的月季咖啡厅，临街一长条木柜台，五张圆桌，窗台上摆着几盆真月季。这个点还没开正餐，但她自己的早餐已经摆好了一桌——两副餐具，多出来的那副是给莱尔的。\n\n"今天的豆子换了？"莱尔拉开椅子坐下。\n\n"你鼻子倒尖。"格蕾丝太太把抹布搭回柜台，转身去端锅，"上礼拜那批烤得太焦，我换了浅烘。"\n\n她端来两只盘子。一只装着煎蛋、烤番茄和两片抹了黄油的面包；另一只是一小碗燕麦粥，粥面撒了肉桂粉和几颗葡萄干。咖啡倒进瓷杯，热气在杯口拧成一股。\n\n莱尔先喝了口咖啡。浅烘的酸味更明显，尾段干净。他没评价，只是把杯子放下时多看了一眼。\n\n"怎么样？"\n\n"能喝。"\n\n"能喝。"格蕾丝太太学了一遍他的口气，"上回那批你也是这么说的。"\n\n"上回是真难喝。"\n\n她笑了一声，没接话，自己也坐下。咖啡厅里只有他们两个。窗外石板路上偶尔传来运货马车的轮子声，蒸汽轨道那头一声汽笛长长拖过街区。煤气灯还没熄，路灯杆顶的火苗在晨风里晃。\n\n莱尔切了块煎蛋。蛋黄半凝，戳破时流出来一点，沾在面包上。格蕾丝太太的早餐从不讲究摆盘，分量却总是刚好——一只蛋、两片面包、一碗粥、一杯咖啡，吃完不撑也不饿。他在这张桌子上吃了多少年，自己没数过，格蕾丝太太也没数过。\n\n"露西小姐呢？"他咽下一口面包问。\n\n"在外头等你呢。一大早就蹲在门口。"格蕾丝太太用叉子戳了颗番茄，"你今天遛久点，它前两天没怎么出门。"\n\n"行。"\n\n莱尔把粥刮干净，咖啡也见底。他起身，拿回帽子扣好，手杖往肘弯一搭。\n\n"多谢早餐。"\n\n"慢走。"\n\n门口石阶下，一只棕白花色的狗正坐着，尾巴扫地。露西听见门响，耳朵先立起来，再扭头——看见是莱尔，整条狗都松弛下来，舌头吐出一截。\n\n莱尔蹲下，把绳扣系到它的项圈上。\n\n"早，露西小姐。"\n\n露西甩了甩尾巴，算回应。\n\n八点整。一人一狗顺着街道往河岸方向走。\n\n...\n...\n...\n\n格雷文赫异常管理局的一楼报案台，永远比楼上安静。\n\n珀西瓦尔·费尔班克斯站在柜台后，把面前的表格理了理。深灰制服领口的银线徽章被晨光擦亮——一只睁开的眼睛，下方压着三道环形刻度。左胸工牌写着姓名、部门和职级，右手腕那块管理局配发的异常粒子检测腕表，正以两秒一次的频率轻轻震一下。读数浮在表盘上：本区凯莉米粒子浓度 0.4，常态值。\n\n柜台外站着一位戴墨镜的女士。\n\n"您说的时间地点，"珀西瓦尔把腕表转到她能看见的角度，"是六月三号晚上九点前后，我查了下，没收到任何地区粒子浓度告警。"\n\n"对。"\n\n"我调了那一段的记录。"他指了指表盘下方一行小字，"当晚九点到十点，您所在的铜锣巷口凯莉米粒子浓度全程没有异常波动，峰值 0.6，仍在常态区间。按现行规程，粒子读数正常的案件，因此我建议您直接去辖区治安所。"\n\n女士没动。\n\n"我已经去过治安所了。"\n\n珀西瓦尔抬眼看她。墨镜遮了大半张脸，下颌线绷着。\n\n"治安官说，"她顿了一下，"如果真像我说的那样，这种案子该找你们管理局。"\n\n珀西瓦尔把笔放回笔架。\n\n管理局的公开报案渠道推了十来年，普通市民大致知道凯莉米粒子是什么，知道异能者存在，也知道该往哪儿报。十多年前，异能和异常对公众来说还是传闻；这十几年里，官方把管理局的报案台一间一间铺到了每个区，监测仪一根杆一根杆立到了街角，街头巷尾议论异能者的语气，也从压低声音变成了大声抱怨。进步是有的。可"大致知道"和"真碰到时知道该怎么办"之间，隔着的是一桩一桩被踢来踢去的案子。\n\n"您带了治安所的回执吗？"\n\n她从包里抽出一张纸，拍在柜台上。治安所的章盖在右下角，红得发亮。\n\n珀西瓦尔看了一眼，没去碰。回执上写的是"非正常事件，建议前往异常管理局咨询办理"——治安所也没信她。\n\n珀西瓦尔有些为难，毕竟他才刚来不久，对这种事不清楚怎么解决。\n\n他突然想起局长在入职时提过的一句话：\n\n"遇到不好弄的案子，让他们去找那个莱尔侦探。"\n\n局长说"那个莱尔侦探"的时候，语气里压着点珀西瓦尔听不懂的东西。\n\n珀西瓦尔当时记下了名字。现在他用得上。\n\n"女士，"他把回执推回去，"我给您一个地址。"\n\n他在一张便笺上写下：西奥多侦探事务所，月季咖啡厅二楼。\n\n"这位西奥多先生，是持照的私家侦探，您的案子，他或许能帮上忙。"\n\n女士接过便笺，看了一眼，又看他一眼。墨镜后面没有表情。\n\n"……管理局不管，推给一个侦探？"\n\n"管理局管不了没有粒子异常的案件。"珀西瓦尔语气带有歉意，"抱歉，但这是规程。"\n\n她沉默了几秒，把便笺折起来，塞进包里。\n\n门开，门关。珀西瓦尔目送她出去，低头看了眼腕表。0.4，常态值。他叹了口气，把那张治安所回执的副联收进抽屉。\n\n...\n...\n...\n\n八点五十五。\n\n莱尔把露西送回月季咖啡厅后院，在门口石阶上蹭了蹭鞋底，推门进去。\n\n格蕾丝太太正用抹布擦着一张桌子，听见门响抬头。"莱尔先生，有人找你。"\n\n那张桌子边坐着两个女人。一个戴墨镜——上午还戴墨镜，莱尔多看了一眼——另一个年纪稍长，短头发，坐姿比同伴稳。两人面前各一杯咖啡，没动多少。\n\n"西奥多先生？"年长的那位先开口，"珀西瓦尔先生让我们来找您。"\n\n莱尔把帽子摘下，拿在手里。"你们好。"\n\n她笑了笑，"我们自我介绍一下——"\n\n她说了一个名字。\n\n格蕾丝太太手里的抹布停在桌上。\n\n莱尔听清了，但格蕾丝太太的反应比那个名字更先到。他侧头看房东。格蕾丝太太张着嘴，眼睛在墨镜女士和她的同伴之间来回跳，确认自己没听错。\n\n"……您是，"格蕾丝太太把抹布捏成一团，"锈蔷薇乐队的？贝斯手？"\n\n墨镜女士摘下墨镜。\n\n"我是。"她说，"塞西莉·辛克莱。这位是我的经纪人，哈里特·默瑟。"\n\n格蕾丝太太往后退了半步，撞到柜台。"锈蔷薇"——这半年整个格雷文赫最响的乐队名字。几个月前那场码头演唱会，门口排的队从蒸汽码头一直甩到钟楼广场。\n\n莱尔对乐队不熟。他看了两位访客一眼，抬手看了眼怀表。\n\n八点五十九。\n\n"两位，"他把帽子扣回头上，"稍等一下。"\n\n塞西莉和哈里特对视了一眼。\n\n空气安静了下来，只听见咖啡厅的挂钟走着，秒针一格一格跳过去。\n\n九点整。钟敲了一下。\n\n"来我的办公室聊吧。"莱尔转身往楼梯走。\n\n塞西莉站起来，端着咖啡杯愣在原地。"……刚才？"\n\n莱尔已经走到楼梯口，头也不回，指了指二楼门上贴的那张纸，笑着说：\n\n"女士们，我的工作时间是九点到十八点。"\n	晨星孤儿院惨案过去十五年后，莱尔已在月季咖啡厅二楼经营西奥多侦探事务所。他清晨被房东格蕾丝催着吃早餐，又照例牵着露西遛过煤气灯尚未熄灭的街道，顺手解决一桩寻找走失花猫的委托。事务所生意清淡，塞西莉却带着经纪人哈里特突然登门。两人此前先后求助治安管理所与异能管理局，均因缺少证据而遭推诿，最终由新人调查员珀西瓦尔推荐到这里。塞西莉没有立刻谈报酬，只反复强调乐队鼓手玛蒂尔达最近很不对劲。莱尔从她的神态中判断事情并非普通跟踪，收起玩笑认真接待。章节结束时，塞西莉低声说出自己的怀疑，眼前的玛蒂尔达或许已经不是原来的那个人。	3010	draft	f035327a-2add-4afe-bf92-2f2b9498cafa	1	{"key_events": ["展现莱尔经营侦探事务所的日常生活与办案方式", "塞西莉和哈里特经珀西瓦尔推荐来到事务所", "塞西莉提出玛蒂尔达可能已经被人替换的怀疑"], "character_focus": ["莱尔·西奥多", "塞西莉·辛克莱", "格蕾丝", "哈里特"], "emotional_tone": "轻松日常逐渐转向隐约不安", "narrative_goal": "完成十五年后的时间转场，建立事务所日常并引入替身疑案", "conflict_type": "日常委托与潜在异常之间的认知冲突", "estimated_words": 3200, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 00:28:39.923874
72191e56-643e-49a5-9216-78a08f6e1494	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9	皮包里的囚笼	排练室的铁门虚掩着，乐声从门缝里漏出来。吉他、贝斯、鼓，混在一起，鼓声在最底下，闷闷的。\n\n塞西莉在门口等他。她今天没戴墨镜，头发拢到耳后，看见莱尔，点了点头。\n\n"先说好。"她说，"玛蒂尔达不知道你来。乐队里我只跟哈里特提了一句，说你是帮我看器材的朋友。"\n\n"行。"莱尔说，"我就看看。"\n\n进门是一间旧仓库改的排练室，墙根堆着音箱和线材，地上散着几张乐谱。窗台很高，光从上面斜下来，落在一排空椅子上。\n\n鼓手台在屋子正中间。\n\n玛蒂尔达坐在鼓后，正低着头调鼓皮。她留着齐肩的黑发，肤色偏深，手腕很细。听见门响，她抬头看了一眼，目光在莱尔身上停了一下，又低下去调鼓。\n\n塞西莉说得对。莱尔靠到墙边，倚着一摞音箱，看她打了一轮。\n\n节奏是对的。可不对。\n\n快到高潮那段，她的手慢了半拍。不是错拍——是钝。一下一下，像每一个动作都要先想一想再落下去。十六分音符该滚过去的，她敲成了一个一个独立的点。\n\n真人打鼓有起有伏。她没有。每一下都落得很稳，稳得过头。她不像在打鼓，像在按一套早写好的节拍，一个音都不肯多、一个音都不肯少。\n\n莱尔把这个念头压下去，脸上没露。\n\n塞西莉坐在墙角，看着莱尔，没说话。她的眼神在说：你听见了吧。\n\n莱尔收回目光，没急着动。他靠着音箱，等排练重新开始，等所有人都把注意力放回乐谱上。\n\n玛蒂尔达的包挂在鼓手椅背的一侧。\n\n黑色皮包，边角磨得发白，拉链头上拴着一只褪色的小木鸟。排练一响，没人看那个包。\n\n中场休息。\n\n玛蒂尔达离开鼓位，去墙角喝水。莱尔从音箱上直起身，走过去，弯腰假装整理脚下的线材，手指在包带附近停了停。\n\n没有人注意他。\n\n他把掌心按在包上。\n\n闭上眼。\n\n画面来了。\n\n不是他的眼睛。是包带的"眼睛"。\n\n夜。路灯光从头顶洒下来，石板路湿漉漉的，像刚下过雨。玛蒂尔达背着这只包，脚步急，往家的方向走。\n\n前面岔路口，一道黑影从墙边闪出来，动作很快，一顶旧帽子压着半张脸。玛蒂尔达往后退，包被人从身后抓住，画面晃动，包带绷紧，勒进她的腕子。\n\n她被塞进一辆停着的马车。\n\n车门关上。包被扔在车厢地板上，晃，颠簸。\n\n车在夜里走了很久。包的视线贴着车厢地板，只能看见玛蒂尔达的脚，她被捆着，动弹不得。车厢里安静，只有马蹄声和车轮碾过石子的声音。中途她试着坐起来一次，被人一把按回去，包也跟着晃了一下。\n\n莱尔松开手，指节发白。他吸了口气，又把掌心按回去。\n\n车停了。包被人拎起来，进了一间屋子。屋顶很高，堆着木箱和卷起来的帆布，一股潮味——旧货仓。\n\n包被放下。\n\n画面里，玛蒂尔达被绑在一张椅子上，绳子勒得很紧，手腕磨破了皮。她脸上没有害怕，眼睛睁着，盯着门口。\n\n门口站着两个人。\n\n女人站在门边，背光，看不清脸，只看见她披着一件深色斗篷，手里慢慢转着一枚戒指。男人穿一身灰，脸上没什么表情，直接走到墙边。\n\n墙边靠着一个东西。\n\n莱尔看得呼吸停了一下。\n\n一个人形的轮廓，立在墙角，一动不动。灰白的皮肤在灯光下泛着木头的哑光，手腕和膝头都能看见榫接的缝。脸是照着玛蒂尔达描的——眉眼、鼻梁、嘴角，一个模子刻出来的。头发是黑的，齐肩，和玛蒂尔达一模一样。\n\n木偶。\n\n女人开口了，声音低，带着点不紧不慢的调子："演唱会之前，别让她出声。到时候还有用。"\n\n男人没答话。他把手放在木偶的头顶，闭上眼睛，手指慢慢收紧。\n\n木偶动了一下。\n\n先是手指。一根，两根。然后是手腕，胳膊。关节咔、咔、咔，一连串闷响，像长久没上油的齿轮一点点咬合。它从墙角走出来，脚踩在地上的第一步还带着一点木头的僵。第二步就稳了。第三步，已经和活人走路没有分别。\n\n男人收回手，走到玛蒂尔达面前，蹲下来。他掰开她的手指，把她腕上的包带解下来。\n\n木偶走过来，接过那只包，背到肩上。\n\n"走吧。"男人说，"回去好好排练。别让任何人看出来。"\n\n木偶点了点头，转身，走出货仓的门，走进夜色。\n\n包被它拎着，在画面里一晃一晃。\n\n莱尔松开手。\n\n他靠在音箱上，指甲掐进掌心，才没让自己喘出那口气。\n\n包带边缘多了一道焦痕，皮面裂开一条细缝，像被火苗舔过。他低头看了一眼，没去碰。\n\n头顶传来一声轻响。\n\n莱尔抬起头。\n\n排练室门口，玛蒂尔达站在那里，抱着那个包。\n\n她看着他，歪了歪头，露出一个笑。\n\n"先生，你是塞西莉的朋友？"\n\n她笑起来很好看。可莱尔盯着她捧包的手指。那几根手指的关节，在灯光下，泛着一层不该有的哑光。\n\n他移开目光，也笑了笑。\n\n"是。来帮塞西莉看器材的。"\n\n"哦。"玛蒂尔达抱着包走过去，"那麻烦你了。"\n\n她从莱尔身边走过，带起一阵风。包带上的那只褪色小木鸟晃了晃。\n\n塞西莉从墙角走过来，压低声音："怎么样？"\n\n莱尔看着排练室门口的方向。玛蒂尔达的身影已经进了里间，门帘晃了一下。\n\n"还在查。"他说。\n\n"你脸色不对。"\n\n"是吗。"\n\n莱尔没再多说。他走到门口，又回头看了一眼那把鼓椅。椅背空了，包被抱进了里间。他低头看自己的手，指尖还留着包带的温度。那道焦痕的位置，硌在心口上。\n\n那不是玛蒂尔达。\n	清晨的雾贴着格雷文赫城北站爬行，铁轨被水汽浸得发亮。蒸汽机车拖着长鸣驶出站台，煤烟压过屋顶，又被海风扯散。 候车厅外，报童冻得直跺脚。搬运工的吆喝、车轮的摩擦声和锅炉泄压的“嗤嗤”声混在一起，吵得人耳根发麻。 莱尔坐在街对面的早餐铺里。 桌上摆着一杯掺水咖啡，两片烤焦的面包。一个戴鸭舌帽的瘦子挤过人群，把牛皮纸袋扔到桌上。 “灰烬酒馆送来的。” 莱尔没碰纸袋。 “多少钱？” “已经付了。” “那就很可疑。” 瘦子翻了个白眼，钻进雾里。 纸袋里有三份东西。 地下印坊的旧工名册、木偶剧团的薪酬记录，还有北站的货运雇工单。三张纸都指向同一个人。 文森特·惠特莫尔。 五尺四寸，右嘴角有疤，常穿深灰大衣	2079	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	4	{"key_events": ["地下情报确认文森特在案发前已经离开格雷文赫城", "莱尔从黑色皮包的记忆中看见绑架与木偶制作过程", "敌方密谋利用替身破坏锈蔷薇演唱会的目的曝光"], "character_focus": ["莱尔·西奥多", "玛蒂尔达·斯特林", "塞西莉·辛克莱", "灰衣操偶师"], "emotional_tone": "疑云揭开后的惊悚与迫切", "narrative_goal": "完成案件核心反转，揭示替身原理、绑架事实与幕后动机", "conflict_type": "真身与替身之间的身份悬疑冲突", "estimated_words": 3800, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 10:24:05.42491
261ee431-2b9d-4544-842d-31cb2d054d48	7f6d28c4-2a32-46d1-887c-6cf5c4555056	12	死者的贵宾席	午后的钟楼剧院伏在旧城区中央，尖顶刺进一层铅灰色的云。钟盘停在十一点，几只鸽子挤在分针上，羽毛被风吹得乱翻。\n\n街上的马车绕过广场。镜头再往下，是剧院侧门。\n\n莱尔收起伞，鞋尖在台阶上磕了两下。塞西莉跟在他身后，右手缠着一圈新纱布。哈里特走在最前面，钥匙串撞着裙侧，叮叮作响。\n\n“档案室在顶楼？”\n\n“地下。”哈里特推开侧门，“顶楼漏雨，放账本的人没那么蠢。”\n\n门内一股热烘烘的灰尘味。舞台上有人试灯，电流滋啦作响。空座椅一排排陷在暗处，正中央那张贵宾席罩着红绒布，比旁边宽出半掌。\n\n塞西莉多看了一眼。\n\n哈里特没停，领着两人钻进舞台后的窄门。\n\n地下档案室比楼上更闷。纸张发潮，浆糊有股酸味，墙角搁着两只捕鼠夹，其中一只夹着半截尾巴。负责票务的老头把窗户推开一条缝，外头却是剧院的排污沟。\n\n味道更重了。\n\n“六月八日，城南加场。”哈里特将登记簿摊在桌上，“舞台流程、后台出入、临时票务，都在这几册。”\n\n老头瞥了莱尔一眼。\n\n“你是治安所的？”\n\n“比他们贵。”\n\n“那就是私家侦探。”\n\n“也可能是骗子。”\n\n老头把登记簿往回拖了一寸。\n\n哈里特按住封皮。\n\n“费用记在乐队账上。”\n\n“早说。”\n\n三本硬壳登记簿被推了过来，扬起一层灰。\n\n莱尔没有先找六月八日。他翻到册子末尾，看了看档案室的交接格式。每一份外送文件都要登记页数、纸张编号、收件人和回收数量。\n\n流程表在六月七日上午十点送出。\n\n送往鸦羽印务。\n\n塞西莉俯下身，头发从耳后滑出来。\n\n“不对。新版没有印。”\n\n“最后那版没有。”哈里特盯着记录，脸色难看，“我改完后送过一次。印出来的东西顺序错了，第二页和第四页倒在一起，我让他们全部作废，回来后才手誊了六份。”\n\n“作废稿上有口令？”\n\n“有。”\n\n档案室里只剩纸页翻动声。\n\n莱尔找到鸦羽印务的回执。十二份样稿，纸张编号从鸦七三一到鸦七四二。下午退回，盖了红色的“废”字，交由剧院票务处销毁。\n\n销毁登记写着十一份。\n\n“少了一张。”塞西莉说。\n\n“也可能是写错了。”哈里特伸手拿登记簿，“这里的人连我的名字都拼错过三次。”\n\n“辛克莱小姐说得对。”\n\n一直坐在门边的票务老头咳了一声。\n\n“销毁那天是我点的。十一张，都扔进锅炉了。”\n\n“编号呢？”莱尔问。\n\n老头拉开抽屉，翻出一捆被麻绳勒弯的纸。\n\n“作废文件要撕角留底。剧院规矩，免得有人拿出去冒充正式公文。”\n\n三角形的纸角铺满桌面。\n\n莱尔按编号排开。\n\n七三一，七三二，七三三。\n\n一直到七四二。\n\n中间空了七三七。\n\n塞西莉背靠桌沿，肩膀松下去一点。她手上的纱布却慢慢洇出红色。\n\n“所以不是我们。”\n\n哈里特闭了闭眼。\n\n她从今早起没问过任何一个乐队成员，可她已经换了排练室的锁，也收走了所有人的后台证件。\n\n“那张纸在印务厂丢的。”她说。\n\n“准确地说，是从印务厂送回剧院前后。”莱尔抽出交接回执，“谁拿走的，还得查。”\n\n他把手压在回执封皮上。\n\n粗糙的硬纸板贴住掌心。\n\n档案室的光往后一折。\n\n柜台高得遮住半面视野。油墨、热铅和湿布的气味挤在一起。一个满脸雀斑的印务学徒站在柜台后数废稿。\n\n“九、十、十一……”\n\n门被推开。\n\n灰色袖口从视野边缘掠过。一只戴薄皮手套的手按住账单，顺势将一张废稿折进账单下方。\n\n学徒抬起头。\n\n那人说了什么，声音被机器的轰鸣盖住。只能看见胸前别着一枚小小的珐琅徽章。\n\n金色鸟笼。\n\n画面断了。\n\n啪。\n\n回执的书脊裂开一道细缝。\n\n莱尔松开手，拇指按住破口，免得老头看见。\n\n“纸角什么时候撕的？”\n\n“印务厂退回来时就撕了。”老头说，“他们的学徒当面点数。”\n\n“也就是说，七三七在点数前已经被抽走。回执却仍写十二份。”\n\n莱尔拿起那张回执，指了指边缘一块浅褐色污迹。\n\n“还有这个。鸦羽印务用松脂洗铅字，味道重。正常废稿只有油墨，不会沾这种混着鱼胶的脏水。”\n\n哈里特凑近闻了闻，立刻偏开脸。\n\n“六码头货仓里也是这个味。”\n\n莱尔没回答。\n\n他读取皮包时闻到的潮气里，一直混着一股发酸的鱼胶味。那时他以为来自木偶关节，现在看来，货仓里还处理过印刷品。\n\n纸是从鸦羽印务丢的。\n\n之后被送去了关押玛蒂尔达的地方。\n\n塞西莉低着头，把手上松掉的纱布重新缠紧。\n\n“我昨晚把每个人的柜子都翻了。”\n\n“包括玛蒂尔达的？”哈里特问。\n\n“包括。”\n\n“找到什么？”\n\n“六份都在。她丢的那份，被木偶带回了排练室。”\n\n哈里特看了她几秒，没追问。\n\n莱尔将纸角拨到一旁。\n\n“流程表不只写了口令。还有站位、签名交接和每首曲子的起拍习惯。”\n\n塞西莉抬眼。\n\n她想起病床上，玛蒂尔达回答右脚时那一下停顿。\n\n“那些人让她反复写名字，也让木偶学她的动作。”\n\n“不是为了演一场戏。”莱尔说，“是为了让替身能签收据、改合同，碰上熟人还能笑一下。”\n\n六码头排练室里，那具木偶抱着皮包，歪头看他的样子又冒了出来。\n\n那不是察觉了他的能力。\n\n只是被教过——有人盯着她时，玛蒂尔达会怎么笑。\n\n训练得不够好，所以才笑得像在量他的脖子。\n\n哈里特把登记簿合上。\n\n“他们想用木偶顶替玛蒂尔达多久？”\n\n“看谁从中得利。”\n\n票务老头听到这里，悄悄把椅子往门边挪。莱尔伸手压住另一册账本。\n\n“六月十三日演出的贵宾名单。”\n\n“那是票务隐私。”\n\n“刚才还是乐队付钱。”\n\n“这不一样。”\n\n哈里特从钱夹里抽出两张钞票。\n\n老头把椅子挪了回来。\n\n“隐私也分价钱。”\n\n贵宾名单只有一页。\n\n正中央座位是第一排十二号，正对舞台，也是签约评审席旁边唯一不挂名的座位。\n\n购买人写着：奥斯汀·柯尔。\n\n哈里特皱起眉。\n\n“柯尔商会的老板？”\n\n“你认识？”莱尔问。\n\n“认识他的讣告。”哈里特将名单转过来，“他三年前死于肺病，葬礼办得很大。锈蔷薇还接过暖场，报酬拖了半年。”\n\n塞西莉指向付款栏。\n\n“死人怎么买票？”\n\n“用活人的钱。”\n\n莱尔抽出付款凭证。票款先由一家钟表贸易行汇入，又经过货运代理和舞台器材租赁行，最后才进入剧院账户。\n\n三家公司地址不同，担保人却是同一个。\n\n赫伯特·兰登。\n\n哈里特的指甲停在名字上。\n\n“金笼演艺公司的财务主管。”\n\n桌边没人出声。\n\n墙外传来舞台试音。贝斯低沉的震动穿过地板，桌上的纸角跟着跳了一下。\n\n金笼演艺。\n\n他们与锈蔷薇竞争同一份北区巡演合约。六月十三日的演出不只是普通公演，评审会坐在台下，决定哪支乐队拿到未来两年的剧院签约资格。\n\n“把鼓手换成木偶，演出照常。”塞西莉说，“签约后再让‘玛蒂尔达’出问题，或者当众失控。”\n\n哈里特接上后半句。\n\n“合约作废，资格顺延。”\n\n莱尔看着那张贵宾票。\n\n第一排十二号。\n\n离舞台近，能看清每个人的手，也能在评审发觉不对前先把事情闹大。\n\n“金笼不会蠢到用自己的财务主管做担保。”哈里特说。\n\n“空壳公司只能把路绕远，不能把脚印擦掉。”莱尔把付款凭证折起，“况且，他们留的不是脚印。”\n\n“是什么？”\n\n“座位。”\n\n楼上的钟忽然响了。\n\n停在十一点的指针没有动，钟声却一下一下砸进地下室。票务老头数到第十一声，脸色发白。\n\n莱尔将第一排十二号的票根撕下，塞进大衣内袋。\n\n“这位置别卖第二次。”\n\n“可票已经有人买了。”\n\n“我知道。”\n\n他拿起帽子，往门外走。\n\n“所以演出那天，让死人坐进来。”	午后的钟楼剧院伏在旧城区中央，尖顶刺进一层铅灰色的云。钟盘停在十一点，几只鸽子挤在分针上，羽毛被风吹得乱翻。 街上的马车绕过广场。镜头再往下，是剧院侧门。 莱尔收起伞，鞋尖在台阶上磕了两下。塞西莉跟在他身后，右手缠着一圈新纱布。哈里特走在最前面，钥匙串撞着裙侧，叮叮作响。 “档案室在顶楼？” “地下。”哈里特推开侧门，“顶楼漏雨，放账本的人没那么蠢。” 门内一股热烘烘的灰尘味。舞台上有人试灯，电流滋啦作响。空座椅一排排陷在暗处，正中央那张贵宾席罩着红绒布，比旁边宽出半掌。 塞西莉多看了一眼。 哈里特没停，领着两人钻进舞台后的窄门。 地下档案室比楼上更闷。纸张发潮，浆糊有股酸味，墙角搁着两只捕鼠	3012	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	7	{"key_events": ["莱尔审查演出流程表的印制和回收记录", "缺失的作废稿证明入场暗号从印刷环节外泄", "贵宾席购票人使用死者身份并留下竞争公司的资金痕迹"], "character_focus": ["莱尔·西奥多", "塞西莉·辛克莱", "哈里特"], "emotional_tone": "紧绷中夹杂释然，随后再度转冷", "narrative_goal": "消除乐队内部互相猜疑，揭示绑架阴谋背后的商业利益关系", "conflict_type": "信息追查与团队信任冲突", "estimated_words": 2900, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 11:03:46.845284
ec671aae-e1fd-466e-a27f-de111643114e	7f6d28c4-2a32-46d1-887c-6cf5c4555056	13	灰线账簿	雨从管理局黑色的尖顶上淌下来，沿石兽张开的嘴汇成水线，砸进街边排水沟。运河那头起了雾，煤气灯只剩一团团发黄的光。\n\n一辆出租马车停在台阶下。\n\n莱尔踩过积水，刚收起伞，门里便伸出一只戴白手套的手。\n\n“证物库不许带湿伞。”\n\n珀西瓦尔站在门后，制服扣到领口，脸色却有些发白。他接伞时右肩僵了一下，动作很轻，还是没躲过莱尔的眼睛。\n\n“墙撞得挺疼？”\n\n“肌肉酸痛。正常代价。”\n\n“你上次说贴两片就好。”\n\n“这次用了六片。”\n\n珀西瓦尔把伞交给值班员，转身领路。\n\n走廊里有消毒水和湿羊毛的味道。地下入口守着两名持枪职员，铁门后每隔十步便有一盏灯，灯罩上结着水汽。\n\n雷金纳德等在最后一道门前。\n\n他没穿外套，只穿深灰制服衬衣，袖子卷到肘部。宽厚的肩背几乎挡住半扇门。\n\n“许可只到今晚十二点。”他说，“你可以看，不可以单独碰。任何损坏，按妨害管理局调查处理。”\n\n莱尔看了眼墙上的钟。\n\n“现在九点十七分。您这顿晚饭看来不怎么合胃口。”\n\n“我没吃。”\n\n“那脾气差是天生的。”\n\n雷金纳德打开铁门。\n\n“费尔班克斯，记下这句。”\n\n证物库里更冷。\n\n潮湿的石墙往外渗水，空气中混着防腐油、旧木头和霉布的气味。装着木偶的铁架占去半边屋子，六张涂过颜料的脸并排朝外，眼珠全被黑布蒙住。\n\n另一边摆着六码头查获的箱子。\n\n斗篷女人与操偶师的口供各有一份。\n\n斗篷女人声称，她只负责找人、运送和看守。委托来自一封没有署名的信，造木偶是操偶师自己的安排。\n\n操偶师则说得更干净。\n\n他只收钱做戏偶，绑架、替换和流程表都由斗篷女人处理。至于买家是谁，他从未见过。\n\n“都说自己只接了匿名委托。”珀西瓦尔把文件放下，“又都说对方知道得更多。”\n\n“很公平。”莱尔翻了两页，“照这么算，钱是自己长腿跑来的。”\n\n他先走到木偶旁。\n\n玛蒂尔达的替身被单独放在一张长桌上。后脑的发套已经拆掉，颈后露出黄铜卡扣，四肢关节处还残留着细线。\n\n莱尔戴上手套，捏住木偶左腕。\n\n关节内侧刻着一行小字。\n\n乙十七，四九三。\n\n“这是什么？”珀西瓦尔问。\n\n“埃蒙剧具商行的零件编号。前面是规格，后面是流水号。”\n\n“货运单上没有四九三。”\n\n“当然没有。那张单子是八码头仓库收货时补开的，只记了整箱。”\n\n莱尔拿起同规格的另一只手腕。\n\n四八九。\n\n右膝，四九一。\n\n颈部，四九二。\n\n唯独缺了四九零。\n\n他看向封在证物袋里的斗篷女人随身物品。钥匙、药瓶、半卷灰线，还有一本被撕去十几页的薄账簿。\n\n“把那个给我。”\n\n珀西瓦尔没有动。\n\n他先看雷金纳德。\n\n雷金纳德点头。\n\n账簿放到桌上时，纸页散出一股廉价烟草味。封皮沾过油，边角发黑，最后几张纸全是空白。\n\n莱尔用手指压住书脊。\n\n灯光暗了一下。\n\n一只沾木屑的手翻开账簿，在最上方写下一串编号。笔尖压得很重，纸下留下浅沟。\n\n乙十七，四九零。\n\n后面跟着几个词。\n\n灰线。凯恩。先三后七。票入，交货。\n\n一枚银色弦琴形领针被推到桌边。\n\n女人的手抽走账页，将它丢进火盆。火光一卷，纸黑了。那枚领针还在桌上，琴弦中央刻着字母V。\n\n画面断开。\n\n咔。\n\n账簿封皮脱下一小块。\n\n莱尔把碎屑压进掌心，脸上没什么变化。\n\n“侧灯。”他说。\n\n珀西瓦尔拿来一盏检验灯，压低灯头。斜光擦过空白纸面，凹痕一点点显出来。\n\n莱尔取出铅笔，没有涂整张，只沿最深的几道压痕描线。\n\n“乙十七，四九零。”\n\n珀西瓦尔转头看向木偶。\n\n“缺失的那个零件。”\n\n“被单独送走了。”莱尔又描出下面两个词，“灰线。先三后七。”\n\n“定金三成，事成七成？”\n\n“口供里，操偶师说他一次收清。斗篷女人说钱分两笔，但第二笔在绑架前到账。”\n\n莱尔把两份口供并排摆开。\n\n“都撒了谎。”\n\n雷金纳德靠在铁架旁，没有插话。\n\n莱尔抽出贵宾票的付款记录，指尖点在银行盖章的时间上。\n\n六月二日，下午四点二十分。\n\n他再将仓库缴获的零件登记放到旁边。\n\n乙十七批次，五月二十八日出库。买方没有写名称，只盖了一枚银色弦琴印。\n\n珀西瓦尔皱起眉。\n\n“银弦演艺。”\n\n“对。”\n\n金笼演艺出现在贵宾票的担保链上，银弦却提前五天买走了木偶关节。\n\n流水号四九零没有进入六码头仓库。\n\n它先被送给斗篷女人，作为验货凭证。之后银弦将票款送进那三家中转公司。钱一到账，操偶师才拿到剩余零件，开始制作玛蒂尔达的替身。\n\n这不是两个匿名委托。\n\n从头到尾只有一个买家。\n\n“凯恩。”珀西瓦尔盯着纸上的压痕，“银弦演艺的负责人，薇奥拉·凯恩。”\n\n“金笼为什么替她担保？”雷金纳德问。\n\n“赫伯特·兰登以前在银弦做账。”莱尔说，“三年前才去了金笼。两家公司表面争巡演合约，私下共用货运代理和器材渠道。银弦需要有人把钱绕出去，金笼需要她手里的唱片发行权。”\n\n雷金纳德的眼皮抬了一下。\n\n“你查过？”\n\n“剧院档案室的旧广告很多。看广告也是侦探工作。”\n\n这话不全是假。\n\n广告上确实有赫伯特的名字，只是没人会专门去记一个三年前的小字签名。\n\n莱尔将证据按时间排开。\n\n五月二十八日，银弦订购特殊关节。\n\n六月二日，贵宾票款进入中转账户，余款支付。\n\n六月七日，七三七号流程表被偷走。\n\n六月八日，玛蒂尔达失踪，替身进入排练室。\n\n“斗篷女人不是不知道委托人。她拿到过四九零，也见过账簿上的名字。”\n\n莱尔将她的口供推到左边。\n\n“操偶师同样见过。否则他不会在票款到账当天组装。所谓匿名，只是他们商量好的说法。”\n\n珀西瓦尔把每件证物重新封好，贴上编号。写到薇奥拉的名字时，他停了一下。\n\n“她为什么选锈蔷薇？”\n\n“银弦刚签下一家唱片厂。”莱尔说，“厂里只给一份长期合约。锈蔷薇的六月十三日演出如果成功，评审不会再考虑银弦手里的乐队。”\n\n“所以她要让木偶在台上失控。”\n\n“最好伤几个人。异常物品、公开事故、管理局调查。唱片厂不会等半年。”\n\n铁门外传来急促的脚步。\n\n一名文书抱着牛皮文件袋进来，帽檐还在滴水。\n\n“局长，剧院委员会的紧急送达。”\n\n雷金纳德接过文件，拆开封蜡。\n\n纸上第一行便盖着委员会的蓝章。\n\n申请人：薇奥拉·凯恩。\n\n申请暂停钟楼剧院六月十三日演出。\n\n理由写得很长。锈蔷薇乐队牵涉非法异能物品，成员曾被异常造物替代，现场仍可能存在未查明的控制装置，继续演出将危害观众安全。\n\n申请末尾附着三份证人陈述。\n\n其中一份，来自今晚才做完笔录的斗篷女人。\n\n珀西瓦尔猛地看向证物库铁门。\n\n“口供泄露了？”\n\n“未必。”雷金纳德把文件递给莱尔，“她早就准备好了。”\n\n薇奥拉比他们先走了一步。\n\n犯罪证据能抓人，却不能迫使剧院委员会开放场地。只要暂停申请进入审议，六月十三日的演出就得先停。等调查结束，唱片合约早换了主人。\n\n珀西瓦尔攥紧钢笔。\n\n“我们可以向委员会说明木偶已经扣押。”\n\n“还不够。”雷金纳德说，“申请里写的是可能存在其他异常物品。管理局不能证明一件不存在的东西不存在。”\n\n莱尔翻到文件最后。\n\n委员会要求锈蔷薇在明早九点前答复。逾期，先停演三十日。\n\n墙上的钟走到十一点。\n\n文书放下一只红色印章，等雷金纳德签收。\n\n莱尔将薇奥拉的申请折回去，压在灰线账簿旁。\n\n“抓她的手续要多久？”\n\n“最快两天。”\n\n“暂停演出呢？”\n\n“明早就能生效。”\n\n莱尔拿起帽子。\n\n“那就先别抓。”\n\n雷金纳德看着他。\n\n“你准备做什么？”\n\n莱尔推开铁门。走廊尽头，值班员正把他的湿伞靠到墙边，伞尖下已经积了一小摊水。\n\n“赶在九点前，教委员会看木偶。”	雨从管理局黑色的尖顶上淌下来，沿石兽张开的嘴汇成水线，砸进街边排水沟。运河那头起了雾，煤气灯只剩一团团发黄的光。 一辆出租马车停在台阶下。 莱尔踩过积水，刚收起伞，门里便伸出一只戴白手套的手。 “证物库不许带湿伞。” 珀西瓦尔站在门后，制服扣到领口，脸色却有些发白。他接伞时右肩僵了一下，动作很轻，还是没躲过莱尔的眼睛。 “墙撞得挺疼？” “肌肉酸痛。正常代价。” “你上次说贴两片就好。” “这次用了六片。” 珀西瓦尔把伞交给值班员，转身领路。 走廊里有消毒水和湿羊毛的味道。地下入口守着两名持枪职员，铁门后每隔十步便有一盏灯，灯罩上结着水汽。 雷金纳德等在最后一道门前。 他没穿外套，只穿深灰制服	3080	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	8	{"key_events": ["莱尔在管理局证物库还原匿名委托的交易顺序", "操偶师与斗篷女人的矛盾口供被账簿压痕逐一拆穿", "幕后委托人利用行政申诉试图阻止锈蔷薇正常演出"], "character_focus": ["莱尔·西奥多", "珀西瓦尔·费尔班克斯", "雷金纳德·洛克哈特"], "emotional_tone": "冷静交锋与步步紧逼", "narrative_goal": "查清替身阴谋的出资者，同时把冲突从隐秘犯罪转入公开规则领域", "conflict_type": "证据博弈与制度对抗", "estimated_words": 3200, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 11:07:59.347226
aa3c3989-d398-4eb3-80b7-71979dcd0b53	d59e468a-8617-41e0-aabf-87a13be78834	9	选拔	\N	外门选拔考核当日，试灵台下人山人海，气氛狂热而压抑。张羽虽被划掉名字，但以'隐灵根'异象为由，经外门执事特批，得以参加补录考核。考核内容为实战对决与灵矿辨识。在实战中，张羽遇到了之前模拟对战时那名隐藏实力的对手，两人再次交锋，这一次张羽更加谨慎，利用地形和预判勉强周旋，最终凭借一次险胜过关，但也引起了那名对手的深深忌惮。在灵矿辨识环节，张羽凭借在矿洞中的丰富经验，准确辨识出数种稀有矿石，甚至指出了一块被误判为废石的'蕴灵髓'，令考官刮目相看。然而，就在考核结束之际，那名对手突然发难，指控张羽作弊，引发了一场混乱。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	9	{"scenes": null, "key_events": ["外门选拔考核开启", "实战对决险胜隐藏实力对手", "灵矿辨识环节表现亮眼", "被对手指控作弊引发混乱"], "conflict_type": "公开竞争与阴谋陷害", "emotional_tone": "紧张与危机并存", "narrative_goal": "通过考核展现张羽的综合能力，同时引入新的敌对势力，为后续进入外门后的复杂人际关系铺垫", "character_focus": ["张羽", "隐藏实力的对手"], "estimated_words": 3000}	2026-09-20 16:06:40.756185	2026-09-20 16:49:28.971267
acbd6ad5-1740-432c-93ea-3ab0fe331b18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	14	开演许可	雨停后，钟楼剧院的铜顶从雾里露出来。白鸽绕着尖塔打转，羽翼掠过十二点不动的黑色指针。\n\n街面却堵得厉害。\n\n报童挤在马车之间，扯着嗓子叫卖号外。记者守住委员会侧门，镁光灯架在积水边，烧出的白烟呛得人咳嗽。\n\n莱尔下车时，距离听证开始还有七分钟。\n\n塞西莉站在台阶上，头发拢在耳后，外套扣错了一颗。她左手缠着新纱布，右手握着排练室钥匙。\n\n哈里特来回踱步，鞋跟敲得石板发响。\n\n“他们凭什么审我们？”她压着嗓子，“被绑的是玛蒂尔达，差点在台上出事的也是我们。”\n\n“凭剧院归他们管。”\n\n莱尔把一只牛皮箱递给塞西莉。\n\n箱子很沉。她接住后，包着纱布的手往下一坠。\n\n“这里面是什么？”\n\n“能让他们安静听你说话的东西。”\n\n“你确定？”\n\n“不确定。”\n\n哈里特停下脚。\n\n莱尔接着道：“但我带了三份副本。他们扔一份，我还有两份。”\n\n侧门打开，书记员叫了锈蔷薇的名字。\n\n听证厅在钟楼二层。\n\n屋里有旧木蜡、潮纸和热咖啡的味道。五名委员坐在弧形长桌后，正中是剧院委员会主席阿尔伯特·布莱。两侧旁听席挤满记者，纸张摩擦声连成一片。\n\n薇奥拉已经到了。\n\n她穿银灰色长裙，胸前没有佩戴银弦徽章。身边的律师头发油亮，桌上只放着一本薄文件夹。\n\n九点整，铜钟响了。\n\n律师起身。\n\n“诸位委员，我们不否认锈蔷薇也是受害者。”\n\n他先给塞西莉等人留了一条退路，随后才抽紧绳子。\n\n“但受害身份，不能免除演出方的安全义务。根据她们自己的陈述，一具来源不明的木偶曾冒充成员，多次进入排练，并接触乐器、舞台和剧院内部人员。”\n\n旁听席响起一阵笔尖刮纸的沙沙声。\n\n“锈蔷薇发现成员异常后，没有停排，也没有上报委员会。她们选择隐瞒，并主动延长木偶在剧院内的活动时间。”\n\n哈里特腾地站起来。\n\n“那是为了救人！”\n\n“哈里特。”\n\n塞西莉按住她的手腕。\n\n律师看了她们一眼。\n\n“动机不能降低风险。没人能确定控制装置是否已全部查获，更没人能保证明晚不会出现第二具、第三具木偶。”\n\n他把暂停演出的申请推给书记员。\n\n“我们只要求停演三十日。等管理局彻查后，再恢复许可。这对观众负责，也是在保护锈蔷薇。”\n\n薇奥拉坐在旁边，手搭着膝盖，没看她们。\n\n主席敲了一下木槌。\n\n“辛克莱小姐，你可以答复。”\n\n塞西莉起身。\n\n她将一页准备好的陈述摊开，念到第二行，喉咙卡住了。\n\n旁听席有人抬头。\n\n莱尔没有催她，只把咖啡杯往边上挪了挪。杯底露出压着的第一份材料。\n\n塞西莉看见编号，放下陈述。\n\n“律师先生说得没错。我们让木偶继续参加排练。”\n\n她的声音有些哑，却没乱。\n\n“因为那时，真正的玛蒂尔达还在绑匪手里。我们停下，绑匪就会知道自己暴露。她可能活不到管理局找到货仓。”\n\n律师开口：“这只是你们单方面的判断。”\n\n“不是判断。”\n\n莱尔打开牛皮箱。\n\n第一叠文件被摆上书记员的长桌。\n\n“圣安妮医院的接诊记录、伤情图和药物检验。玛蒂尔达·斯特林获救时，腕部有捆绑伤，血液内残留镇静剂。记录时间是六月十日上午五点四十二分。”\n\n第二叠紧跟着放下。\n\n“异常管理局对剧院、乐器、演出服和六码头查获物品的检测报告。所有控制线、核心关节及驱动装置均已扣押。钟楼剧院现有凯莉米粒子读数低于日常背景值。”\n\n律师翻了两页。\n\n“低读数不能证明绝对安全。”\n\n“确实。”\n\n莱尔把第三叠材料推过去。\n\n“所以还有剧院出入记录、排练室交接签名、道具清单，以及发现替身后每一次人员流动。木偶没有离开过排练室和七码头之间的监视路线。”\n\n“可她们隐瞒在先。”\n\n“绑架发生在先。”\n\n律师的手停在纸页上。\n\n莱尔看向委员会。\n\n“有人绑走一名十九岁的乐手，用木偶顶替她，准备在公开演出中制造事故。现在，出资制造木偶的人要求取消受害者的演出资格，理由是受害者没能阻止她制造危险。”\n\n厅里安静了几秒。\n\n一名记者抬起镁光灯。\n\n咔嚓！\n\n白光照过薇奥拉的侧脸。\n\n她终于转头看向莱尔。\n\n“西奥多先生，”律师语速快了些，“你是在暗示我的委托人与刑事案件有关？”\n\n“我没有暗示。”\n\n莱尔从箱底取出一页加盖管理局封印的证物目录。\n\n“我在陈述证物。”\n\n书记员接过去，只看了开头，立刻交给主席。\n\n主席的眉毛越拧越紧。\n\n银弦演艺订购的特殊关节编号、付款时间、货运代理，以及薇奥拉在绑架案尚未公开时便备好的证人陈述，全列在纸上。\n\n后排有人低声问：“她怎么提前知道木偶参与过排练？”\n\n另一名记者已经在本子上写下“唱片厂长期合约”。\n\n律师转向薇奥拉。两人贴近说了几句，薇奥拉的手从膝盖上移开，抓住了裙边。\n\n主席敲响木槌。\n\n“肃静。”\n\n他又看向塞西莉。\n\n“流程表泄露，是否与乐队内部管理有关？”\n\n塞西莉没有马上回答。\n\n她拆开左手的纱布。\n\n掌心的伤口已经结痂，边缘还留着钥匙齿压出的印子。她把那枚黄铜钥匙放在桌上。\n\n“这是排练室档案柜的钥匙。新版流程表送到后，六份逐人签收，其余作废稿按印务厂记录销毁。档案柜没有被撬，钥匙也没丢。”\n\n“你的手怎么伤的？”主席问。\n\n“我以为泄密的人在乐队里。”\n\n塞西莉看了玛蒂尔达一眼。\n\n玛蒂尔达坐在最后一排，短发遮住半边脸。\n\n“那天我站在她病房外，攥着这把钥匙。我怀疑过她，也怀疑过其他人。”\n\n她重新包好手。\n\n“后来查明，缺失的是印务厂未销毁的七三七号废稿。流转编号、清点记录和印厂的补充证词，都在第四份材料里。”\n\n莱尔将最后一叠文件放下。\n\n“风险没有被乐队制造。”他说，“责任也不能因为她们活着回来，就塞回她们手里。”\n\n委员会休会十五分钟。\n\n走廊上全是脚步和快门声。薇奥拉在律师掩护下离开旁听席，记者一路追到楼梯口。\n\n“凯恩女士，银弦是否参与订购木偶？”\n\n“停演申请是否与唱片合约有关？”\n\n“您为何提前取得嫌疑人的陈述？”\n\n没人得到回答。\n\n十点零三分，委员会重新入席。\n\n主席宣读决定。\n\n“现有材料不足以证明钟楼剧院仍存在未受控异常风险。锈蔷薇演出许可继续有效。演出前由异常管理局进行最后一次场地核验，演出期间增派治安人员。”\n\n木槌落下。\n\n“申请驳回。”\n\n哈里特一下抱住塞西莉，险些把她撞到桌角。旁听席乱成一团，记者争着往外跑。\n\n莱尔合上空箱子。\n\n外面的事，暂时结束了。\n\n下午，钟楼剧院清了场。\n\n舞台上的灰尘被扫净，幕布还没升。空座椅一排排没入黑暗，只有脚灯亮着，木板上残留松香、机油和旧绒布的气味。\n\n玛蒂尔达坐到鼓架后。\n\n塞西莉插好贝斯的接线。哈里特站在麦克风前，没有出声。\n\n“先试四拍。”塞西莉说。\n\n玛蒂尔达点头。\n\n她拿起鼓槌。\n\n木头贴住掌心的那一刻，她的肩背僵住了。\n\n绳索收紧手腕。货仓里没有窗。木偶坐在对面，顶着她的脸，一下一下敲击膝盖。\n\n嗒。\n\n嗒。\n\n嗒。\n\n鼓槌从她右手掉下去，滚过舞台。\n\n没人去捡。\n\n玛蒂尔达盯着自己的手。五根手指张着，怎么也合不上。呼吸挤在喉咙里，牙齿撞出细碎的响声。\n\n塞西莉放下贝斯，朝她走了一步。\n\n玛蒂尔达立刻往后缩，鼓凳在地板上刮出刺耳长音。\n\n“别过来。”\n\n塞西莉停住。\n\n莱尔从侧幕后走出来，把滚到脚边的鼓槌捡起。他没有递回去，只将它横放在鼓面上。\n\n玛蒂尔达看了很久。\n\n“明天就要演了。”\n\n“我知道。”\n\n“许可保住了。”\n\n“嗯。”\n\n她抬起手，离鼓槌还有半尺，手指又开始发抖。\n\n“可我不会打鼓了。”	雨停后，钟楼剧院的铜顶从雾里露出来。白鸽绕着尖塔打转，羽翼掠过十二点不动的黑色指针。 街面却堵得厉害。 报童挤在马车之间，扯着嗓子叫卖号外。记者守住委员会侧门，镁光灯架在积水边，烧出的白烟呛得人咳嗽。 莱尔下车时，距离听证开始还有七分钟。 塞西莉站在台阶上，头发拢在耳后，外套扣错了一颗。她左手缠着新纱布，右手握着排练室钥匙。 哈里特来回踱步，鞋跟敲得石板发响。 “他们凭什么审我们？”她压着嗓子，“被绑的是玛蒂尔达，差点在台上出事的也是我们。” “凭剧院归他们管。” 莱尔把一只牛皮箱递给塞西莉。 箱子很沉。她接住后，包着纱布的手往下一坠。 “这里面是什么？” “能让他们安静听你说话的东西。” “	3020	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	9	{"key_events": ["剧院委员会就锈蔷薇的演出资格举行临时听证", "莱尔利用完整材料反驳针对受害者的责任转嫁", "玛蒂尔达在登台前出现严重的创伤性演奏障碍"], "character_focus": ["莱尔·西奥多", "塞西莉·辛克莱", "玛蒂尔达·斯特林"], "emotional_tone": "压抑克制后转为脆弱沉重", "narrative_goal": "解决外部规则危机，并把最终难题落到受害者能否重新掌握自身生活上", "conflict_type": "舆论压力与创伤复发", "estimated_words": 3100, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-07 11:12:30.36464
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	10	木偶		夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水。 莱尔靠在门边。塞西莉出来得很快，反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。 “你早就知道了。”她说。 “刚知道。” “她不是玛蒂尔达。” 塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人。 “不是。”莱尔说，“里面那个，不是玛蒂尔达。” 塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了。“那真的玛蒂尔达在哪？” “肉仓库。”莱尔说，“港口区的旧货仓。我看见她被人绑进去的	0	completed	f035327a-2add-4afe-bf92-2f2b9498cafa	5	{"key_events": ["侦查小组跟随木偶替身找到港区旧货仓", "莱尔补齐绑架和非法操偶的完整证据链", "联合抓捕成功并救出真正的玛蒂尔达"], "character_focus": ["莱尔·西奥多", "珀西瓦尔·费尔班克斯", "玛蒂尔达·斯特林", "塞西莉·辛克莱"], "emotional_tone": "紧张激烈", "narrative_goal": "收束替身疑案，体现莱尔重视证据的办案原则，并强化事务所与官方人员的合作关系", "conflict_type": "调查者与异能犯罪者之间的行动对抗", "estimated_words": 3000, "scenes": null}	2026-08-07 00:13:35.321101	2026-08-24 01:19:25.502104
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	7f6d28c4-2a32-46d1-887c-6cf5c4555056	2	归途之前	晨雾贴着灰瓦往下淌，城西教堂的钟敲了六下。\n\n街边的面包房刚开门，热气从烟囱里冒出来。运煤车碾过石板路，铁轮咯噔作响，惊起一群啄食的麻雀。\n\n晨星孤儿院也醒了。\n\n厨房里满是煮燕麦的甜味，煤炉烤得人脸发热。几个孩子围着长桌抢最后一勺蜂蜜，托比拿面包去蘸，被玛丽修女用木勺挡了回去。\n\n“那是给诺亚的。”\n\n“他吃得慢。”\n\n“所以你替他吃？”\n\n托比收回手，装作什么也没发生。\n\n莱尔坐在桌角，把碗里那点燕麦糊刮得干干净净。克劳靠着窗台，嘴里叼着半片面包，正用小刀削一截木头。\n\n玛丽修女擦净手，从围裙口袋里拿出一张折好的纸。\n\n“面粉两袋，退烧药一盒，煤油一桶。要是剩得多，再买些盐。”\n\n她又取出一个布袋。几枚铜币落在桌上，碰出脆响。\n\n莱尔数了一遍。\n\n“剩不了。”\n\n“那就不买盐。”\n\n“也可能连煤油都不够。”\n\n“城东那家铺子便宜。”\n\n“他们的秤缺斤少两。”\n\n玛丽修女将零钱推过去。\n\n“所以才让你去。”\n\n莱尔收起铜币，满意了。\n\n克劳把木头和小刀揣进口袋，拎起墙边的空篮。玛丽修女替他理了理歪掉的衣领，又转向莱尔。\n\n“别惹事。”\n\n“您应该对克劳说。他长得比较像会惹事的。”\n\n克劳看了他一眼。\n\n莱尔改口：“好吧，他不用惹，事会自己躲着他。”\n\n玛丽修女笑了笑，把采购清单塞进他手里。\n\n“中午前回来。”\n\n两人出了门。\n\n雾还没散，石板路湿漉漉的。沟渠里漂着烂菜叶，馊水味混着马粪味往上冲。卖报的孩子从街角跑过，靴子踩进水坑，溅了莱尔半条裤腿。\n\n“明天他会在这里摔一跤。”莱尔说。\n\n克劳低头看了看那块松动的石板。\n\n“你要推他？”\n\n“我只是善于预测。”\n\n他们穿过两条街，拐上通往城东的石桥。\n\n桥下的河水发黑，几条运货船慢吞吞往前挪。船夫站在甲板上骂人，声音隔着雾传来，听不清是在骂谁。\n\n克劳一路没说几句话。\n\n这不稀奇。他平时也不爱说。可今天那半片面包被他捏了一路，边角已经碎了，还没吃完。\n\n莱尔扫了一眼。\n\n“你要留着下蛋？”\n\n克劳把面包塞进嘴里，嚼了几下。\n\n“前几天，有人来过。”\n\n“收捐款的？”\n\n“不是。”\n\n克劳的手搭在篮子提手上，指节压得发白。\n\n“他们说自己是异常管理局的人。”\n\n莱尔脚步没停。\n\n石桥尽头有辆马车堵住了路。两人贴着栏杆绕过去，车夫正和巡警争吵，鞭子险些甩到克劳肩上。\n\n克劳抓住鞭梢。\n\n车夫愣住，使劲拽了两下，没拽动。\n\n“松手！”他骂道。\n\n克劳松了。\n\n车夫用力过头，一屁股跌回车座。莱尔憋住笑，拉着克劳走远。\n\n“什么时候来的？”他问。\n\n“四天前。你带诺亚去看牙医那天。”\n\n“几个人？”\n\n“三个。两个男人，一个女人。穿灰外套，带着证件。”\n\n“你看清了？”\n\n“没有。他们只亮了一下。”\n\n克劳在桥下停了片刻，等一辆载满木箱的板车过去。\n\n“他们问玛丽修女，这里有没有会做怪事的人。能隔空挪东西，听见别人脑子里的声音，或者碰一下就让东西坏掉。”\n\n莱尔将采购单折窄了一些。\n\n“长相？”\n\n“领头的男人留着胡子，右耳缺了一块。女人一直戴着手套。剩下那个没进门，在外面看窗户。”\n\n莱尔把这些记下。\n\n“玛丽修女怎么说？”\n\n“她说孩子们都没有。”\n\n克劳看着前面的路。\n\n“她只承认自己懂一点治疗。那女人问她能治到什么程度，她说顶多处理小伤口。”\n\n“你在哪儿？”\n\n“储藏间。”\n\n难怪克劳知道得这么清楚。储藏间和会客室只隔着一堵薄墙，墙角还有个被老鼠咬出来的洞。\n\n“然后呢”\n\n“然后就走了。”\n\n莱尔用鞋尖踢开路上的碎瓦。\n\n“听起来不像好人。”\n\n“你不害怕？”\n\n“怕。他们要是查厨房，肯定会发现你偷糖。”\n\n克劳没笑。\n\n莱尔侧过脸。\n\n那道贯过克劳左眉的旧疤绷得很紧。他盯着河面，半天没动。\n\n“莱尔。”\n\n“嗯。”\n\n“有件事，我没告诉过别人。”\n\n“你藏的糖不止一块？”\n\n“我能切开东西。”\n\n“恭喜。大部分刀都能。”\n\n克劳从口袋里摸出那把削木头的小刀。\n\n刀身很旧，尖端磨圆了。他用拇指抵着刀背，没打开。\n\n“不是那种切开。”\n\n桥洞里吹来的风带着水腥味。莱尔看见他的袖口下露出几道细疤，横在手腕内侧，排列得不太自然。\n\n克劳拉下袖子。\n\n“去年仓房的锁锈死了。我拿凿子敲了一下，锁、铁链，还有后面的门闩，全断了。”\n\n“凿子呢？”\n\n“没坏。”\n\n“你的手受伤了。”\n\n克劳点头。\n\n“像被刀割过。没人碰我。”\n\n前面传来商贩的叫卖声。城东市场就在街口，鱼摊的腥气已经飘了过来。\n\n克劳却没再往前。\n\n“后来我又试了几次。剪刀、斧头、餐刀。只要是能切东西的工具，到了我手里，就能切开本来切不开的东西。”\n\n他握紧那把小刀。\n\n“我不知道为什么。”\n\n莱尔看着他。\n\n“玛丽修女知道吗？”\n\n“不知道。”\n\n“那你为什么告诉我？”\n\n克劳沉默了一会儿。\n\n“我以为只有我是这样。”\n\n他说得很轻，险些被市场里的吆喝声盖住。\n\n“那几个人来以后，我才知道还有别人。”\n\n“你当然不是唯一的异类。”\n\n克劳看向他。\n\n“托比能在十步外闻到蜂蜜，艾拉爬墙比猫快，诺亚哭起来能让全屋的人投降。至于你——”\n\n莱尔拍拍他的胳膊。\n\n“你会把糖融在裤兜里。”\n\n克劳的脸黑了。\n\n“我在说正事。”\n\n“我也是。一个真正可怕的怪物，不该连半块糖都保不住。”\n\n克劳盯了他两秒，把小刀收回去。\n\n“你嘴真欠。”\n\n“这也是能力。暂时没见副作用。”\n\n这次克劳笑了一声，很短。\n\n两人进了市场。\n\n摊棚挤在街道两边，湿布下摆着还在甩尾的鱼。药铺门口挂着成串干草，苦味呛得人鼻子发痒。莱尔先买了药，又盯着面粉铺老板重新称了两遍。\n\n“少了三磅。”\n\n老板拍着秤盘。\n\n“这秤昨天才校过！”\n\n莱尔从麻袋底下捡出一块压秤的铁片。\n\n“校得不错。”\n\n老板骂骂咧咧补足面粉，还多塞了一小包盐，叫他们赶紧滚。\n\n煤油也买到了。剩下的钱只够买两只发皱的苹果。\n\n莱尔抛给克劳一只。\n\n“封口费。”\n\n“太便宜。”\n\n“那你还我。”\n\n克劳咬了一口，连核都没吐。\n\n返程时雾已经散了。两人轮换扛面粉，煤油桶挂在克劳手里，莱尔提着装药和盐的篮子。\n\n走上通往孤儿院的坡道时，莱尔放慢脚步。\n\n太安静了。\n\n这个时辰，托比该在院里劈柴，艾拉会趁玛丽修女不注意爬上窗台。就算没人吵，厨房烟囱也该冒烟。\n\n可红砖屋顶上什么都没有。\n\n晾衣绳垂在墙后，一动不动。\n\n克劳也停了下来。\n\n孤儿院的大门虚掩着。门闩断成两截，一半歪在石阶旁。\n\n莱尔轻轻推开了门。\n\n送货篮砸在石阶上，药瓶滚了出去。	晨雾贴着灰瓦往下淌，城西教堂的钟敲了六下。 街边的面包房刚开门，热气从烟囱里冒出来。运煤车碾过石板路，铁轮咯噔作响，惊起一群啄食的麻雀。 晨星孤儿院也醒了。 厨房里满是煮燕麦的甜味，煤炉烤得人脸发热。几个孩子围着长桌抢最后一勺蜂蜜，托比拿面包去蘸，被玛丽修女用木勺挡了回去。 “那是给诺亚的。” “他吃得慢。” “所以你替他吃？” 托比收回手，装作什么也没发生。 莱尔坐在桌角，把碗里那点燕麦糊刮得干干净净。克劳靠着窗台，嘴里叼着半片面包，正用小刀削一截木头。 玛丽修女擦净手，从围裙口袋里拿出一张折好的纸。 “面粉两袋，退烧药一盒，煤油一桶。要是剩得多，再买些盐。” 她又取出一个布袋。几枚铜币落在	2687	completed	a9bcfa47-5a17-442f-85dd-c050b209c378	2	{"key_events": ["玛丽修女安排莱尔与克劳外出采购物资", "克劳讲述陌生人员登门收集异能者信息", "克劳首次向莱尔承认自己拥有异常能力"], "character_focus": ["莱尔·西奥多", "克劳·沃尔特", "玛丽修女"], "emotional_tone": "平静日常逐渐转为压抑警觉", "narrative_goal": "深化莱尔与克劳的关系，并提前埋下冒牌调查人员的关键疑点", "conflict_type": "身份隐瞒与信任试探", "estimated_words": 3200, "scenes": null}	2026-08-06 15:23:16.567449	2026-08-06 21:31:47.784361
c3344d91-7358-4174-b3e1-b4bdc79d4c2e	7f6d28c4-2a32-46d1-887c-6cf5c4555056	1	藏在阳光里的秘密	六月的太阳越过红砖屋顶，把晨星孤儿院的影子压在地上。\n\n后院不大，三面围墙。东边是掉漆的仓房，西边立着钟楼矮墙，中间扯了几根晾衣绳。床单、围裙和洗得发白的旧衬衣挂在上头，被风吹得鼓鼓囊囊。\n\n厨房窗户开着。烤面包的香味飘出来，混着皂角水和晒热的泥土味。\n\n“六十！”\n\n莱尔背对院子，额头抵着老槐树，双手蒙住眼睛。\n\n“数完了。没藏好的，算你倒霉。”\n\n身后传来一阵乱响。\n\n有人踩翻木盆，有人压着嗓子骂了一句，还有个倒霉蛋撞上晾衣架，铁钩晃得叮当作响。\n\n莱尔没急着回头。\n\n“九十七，九十八，九十九……”\n\n“你刚才才数到六十！”远处有人喊。\n\n“我数得快。”\n\n“你耍赖！”\n\n“一百。”\n\n莱尔转过身，棕黑色短发被树皮蹭乱了几根。他抬手捋开额前碎发，先看院门。\n\n门闩好好的，没人跑出去。\n\n今天参加游戏的一共八个。抓到七个才算赢。输的人负责替玛丽修女剥晚饭用的豌豆，整整一大篮。\n\n这种时候，友情靠不住。\n\n泥地上全是脚印。\n\n莱尔蹲下，盯着其中一串看了几秒。鞋印从槐树后绕向仓房，鞋底右边缺了一小块。\n\n“出来吧，托比。”\n\n仓房后的空木桶晃了晃。\n\n“凭什么？”\n\n“你那双鞋是我补的。”\n\n托比从木桶后探出头，鼻尖沾着一块蜘蛛网。\n\n“那不算。你偷看了。”\n\n“我背后没长眼睛。”\n\n莱尔拽住他的袖子，把人带到槐树下。\n\n“第一个。”\n\n托比气得直拍衣服。\n\n“你等着，我一定告诉其他人换鞋。”\n\n“可以。前提是你们有第二双。”\n\n托比不吭声了。\n\n莱尔走向晾衣架。几件衣服还在晃，其中一条床单动得格外厉害，底下露出半只鞋。\n\n他停在床单前。\n\n“艾拉。”\n\n床单后没有声音。\n\n“我看见你了。”\n\n还是不动。\n\n莱尔伸手掀开床单。后面空空荡荡，只有一双鞋摆在地上。\n\n矮墙上传来憋不住的笑。\n\n莱尔抬头。艾拉正趴在钟楼底下的平台边缘，双腿缩在裙摆里，笑得肩膀直抖。\n\n“你上去的时候，蹭掉了三块墙灰。”\n\n“哪三块？”\n\n“左边两块，右边一块。”\n\n艾拉低头找墙灰。莱尔抓住她垂下来的鞋带，往下一扯。\n\n“第二个。”\n\n“莱尔！”\n\n“下来。别逼我去找玛丽修女。”\n\n这句话比扯鞋带有用。艾拉认命地爬下来，和托比站到一起。\n\n接下来几个也不难。\n\n旧鸡舍里有压低的咳嗽声，藏着感冒没好的马丁。水缸后露出一小截红辫子，是珍妮。柴堆旁边散着刚剥开的糖纸，整个孤儿院只有克劳会把偷来的糖分两口吃，剩下一半塞进口袋。\n\n莱尔在厨房后门堵住他时，克劳还在嚼。\n\n“你怎么知道我在这儿？”\n\n“糖纸。”\n\n“我没扔。”\n\n“那你摸摸口袋。”\n\n克劳往口袋里一摸，脸立刻垮了。糖化了，黏得满手都是。\n\n厨房里传来锅盖碰撞声。\n\n玛丽修女从窗内看了一眼。她围着灰蓝色围裙，袖口卷到手肘，手上还沾着面粉。\n\n“别靠近井边。”她说，“还有，不许钻钟楼。”\n\n艾拉赶紧把脑袋缩到托比身后。\n\n玛丽修女没拆穿她，只看向莱尔。\n\n莱尔冲她笑了笑，乖巧得很。\n\n玛丽修女也笑，浅褐色的眼睛隔着热气看过来，像泡开后放凉的茶。\n\n“七个人了吗？”\n\n“还差一个。”\n\n“那你可得快些。面包出炉，游戏就结束。”\n\n莱尔看向院子。\n\n树下站着六个，算上克劳，七个已经找到六个。\n\n只剩最小的诺亚。\n\n诺亚八岁，个子矮，胆子也小。他不敢钻黑地方，不会爬高，躲久了还会偷偷哭。仓房、鸡舍、钟楼都不适合他。\n\n莱尔沿着墙边走了一圈。\n\n没有新脚印。\n\n晾衣架下也没有。\n\n他停在仓房门口。门锁挂着，门缝里的灰没被碰过。旁边堆着一车准备送去镇上修补的旧物：破椅子、裂口木箱、缺了指针的座钟，还有一只轮子脱落的木头小马。\n\n诺亚早上骑过那匹木马。\n\n莱尔回头看了一眼。\n\n孩子们正在争论谁会负责剥豌豆。厨房里传来揉面的闷响，玛丽修女没再露面。\n\n他俯下身，装作检查车轮，手指按在木马掉漆的耳朵上。\n\n晒热的木头硌着指腹。\n\n院子暗了下去。\n\n杂乱的声音隔着一层水传来。视野变得很低，前后摇晃。诺亚的裤脚在眼前跑过，他抱着木马，把它推回杂物车。\n\n“别出声。”\n\n男孩蹲下来，对着木马做了个噤声的手势。\n\n接着，一双小手掀开晾衣架旁的柳条筐盖。筐里塞着待洗的毛毯。诺亚钻进去，费了好大劲才把盖子拉回原位。\n\n画面断了。\n\n莱尔松开手。\n\n木马耳朵上裂开一道细纹，一小片红漆落进他掌心。\n\n他把漆片弹进草丛，站起身。\n\n柳条筐就在十几步外。\n\n直接过去掀开，太蠢了。\n\n“找不到了吧？”托比幸灾乐祸，“这次该你剥豌豆。”\n\n“急什么。”\n\n莱尔走到井边，又绕去鸡舍。他故意摸了摸地上的泥，再抬头看晾衣绳。\n\n“诺亚早上吃了两块果酱面包，手没洗干净。晾衣架第三根木柱上有个红印。”\n\n几个孩子齐齐看过去。\n\n木柱上什么都没有。\n\n莱尔挡在前面，没人看得清。\n\n“然后呢？”艾拉问。\n\n“柱子边有草屑。草是从筐底粘下来的。筐盖歪了一点，说明有人动过。”\n\n他说得像真有那么回事，连托比都蹲下去找草屑。\n\n莱尔走到柳条筐前，敲了敲盖子。\n\n“出来吧。”\n\n筐里安静了两秒。\n\n盖子被顶开。诺亚裹着毛毯坐起来，满脸通红，头发上粘着一根白线。\n\n“你怎么连这个都知道？”\n\n“因为我聪明。”\n\n莱尔把他从筐里拉出来。\n\n“七个。你们输了。”\n\n后院立刻响起一片哀号。\n\n玛丽修女端着刚烤好的面包出来，热气裹着麦香。孩子们哪里还记得豌豆，呼啦一下围了过去。托比伸手最快，被她用木勺敲了手背。\n\n“一人一个。莱尔留下。”\n\n莱尔刚摸到面包，手便停住了。\n\n其他人抱着面包跑进屋。克劳经过他身边时，递来一个自求多福的眼神。\n\n后院很快安静下来。\n\n玛丽修女把剩下的面包盖好，走到杂物车旁。她捡起木马，看了看那只开裂的耳朵。\n\n“晒坏的。”莱尔说。\n\n“昨天还没有。”\n\n“木头也会一夜长大。”\n\n“莱尔。”\n\n“好吧，它可能只长了一点。”\n\n玛丽修女没板起脸。她在台阶上坐下，把围裙上的面粉拍掉，又拍了拍身边的位置。\n\n莱尔走过去坐好。\n\n“我没有怪你。”她说。\n\n“那我能走了吗？”\n\n“不能。”\n\n莱尔叹了口气，掰下一小块面包塞进嘴里。\n\n玛丽修女看着院子里晃动的床单。\n\n“你想赢，也想让他们觉得你厉害。我十二岁的时候，也爱在朋友面前出风头。”\n\n“您十二岁的时候肯定没有我聪明。”\n\n“嗯，你比我会狡辩。”\n\n莱尔笑了。\n\n玛丽修女却没跟着笑。她将木马放到膝上，拇指压住那道裂纹。\n\n“外面的人还没准备好。”\n\n莱尔嚼面包的动作慢了下来。\n\n“他们会害怕不懂的东西。害怕之后，有些人会跑，有些人会喊，还有些人会抓住它，拆开看看。”\n\n厨房里，锅里的水烧开了。蒸汽顶着壶盖，哒哒直响。\n\n“我只是找到了诺亚。”\n\n“今天是诺亚。下次呢？”\n\n莱尔垂眼看着手里的面包。\n\n“聪明不是坏事。你的能力也不是。”玛丽修女擦掉木马上浮起的木屑，“可你得知道什么时候能用，什么时候不能。秘密一旦让第二个人看见，就不再只归你管了。”\n\n“您不是第二个人？”\n\n“所以我得替你守着。”\n\n她把木马递回来。\n\n莱尔接住，裂口扎了一下掌心。他没松手。\n\n“知道了。”\n\n“真的？”\n\n“假的。”\n\n玛丽修女抬手敲了下他的额头。\n\n莱尔捂着脑门跳下台阶，笑着往屋里跑。\n\n“我去监督他们剥豌豆！”\n\n“你也要剥。”\n\n“我赢了！”\n\n“你作弊了。”\n\n莱尔脚下一停，回头看她。\n\n玛丽修女已经抱起面包篮，往厨房走去。阳光落在她挽起的袖口上，白得有些刺眼。\n\n他低头，把木马耳朵上的裂纹按紧，塞进杂物车最底下。\n\n随后才追进屋里。	六月的太阳越过红砖屋顶，把晨星孤儿院的影子压在地上。 后院不大，三面围墙。东边是掉漆的仓房，西边立着钟楼矮墙，中间扯了几根晾衣绳。床单、围裙和洗得发白的旧衬衣挂在上头，被风吹得鼓鼓囊囊。 厨房窗户开着。烤面包的香味飘出来，混着皂角水和晒热的泥土味。 “六十！” 莱尔背对院子，额头抵着老槐树，双手蒙住眼睛。 “数完了。没藏好的，算你倒霉。” 身后传来一阵乱响。 有人踩翻木盆，有人压着嗓子骂了一句，还有个倒霉蛋撞上晾衣架，铁钩晃得叮当作响。 莱尔没急着回头。 “九十七，九十八，九十九……” “你刚才才数到六十！”远处有人喊。 “我数得快。” “你耍赖！” “一百。” 莱尔转过身，棕黑色短发被树皮蹭	3082	completed	a9bcfa47-5a17-442f-85dd-c050b209c378	1	{"key_events": ["莱尔主持孤儿院后院的躲猫猫游戏", "莱尔暗中借助异能找到最后一名伙伴", "玛丽修女识破作弊并告诫莱尔隐藏能力"], "character_focus": ["莱尔·西奥多", "玛丽修女"], "emotional_tone": "温暖轻快中隐藏着不安", "narrative_goal": "建立孤儿院的日常氛围，展现莱尔童年时期的推理天赋与异能秘密", "conflict_type": "秘密暴露风险与自我克制", "estimated_words": 3000, "scenes": null}	2026-08-06 15:23:16.567449	2026-08-06 15:29:06.931263
916de3c2-a30f-44c3-b395-dd0f5c01a6ab	7f6d28c4-2a32-46d1-887c-6cf5c4555056	5	雷金纳德	晨雾从港口爬上来，把治安所对面的钟楼吞掉了半截。窗玻璃凝着一层水汽，里面传出餐盘磕碰和管道嘶嘶的声响。\n\n食堂里，炖菜咸得发苦。\n\n克劳吃了两口就把勺子放下。“我想玛丽修女做的通心粉了。”\n\n莱尔握勺的手停了一下。\n\n他们在治安所住了三天。\n\n克劳盯着碗里的土豆。勺柄上还悬着一滴汤。\n\n“她做的不会这么咸。”\n\n莱尔低头喝了一口。确实很咸。玛丽修女要是在，大概会把这个厨师赶回灶台，让他往锅里添两瓢水再端上桌。\n\n他把水杯推给克劳。“喝点水。”\n\n克劳没动。\n\n过了一会儿，他问：“你的能力到底是什么？”\n\n四周的餐具碰撞声还在继续。有人拖开椅子，木腿刮过地面，发出刺耳的长响。\n\n莱尔看着克劳。“为什么问这个？”\n\n“你一直不肯说。”\n\n“现在也不是什么好时候。”\n\n“所以能做到？”\n\n克劳终于抬起头。眼圈泛着青，三天没真正睡过的颜色。“能让人活过来吗？”\n\n莱尔没有回答。\n\n克劳声音压得更低：“或者让时间倒回去。回到我们出门以前。早一点也行。你提前告诉玛丽修女，让大家离开。”\n\n他前倾身体，指节攥住桌沿。\n\n莱尔喉咙发紧。\n\n“莱尔——你试过了吗？”\n\n“没有。”\n\n“为什么不试？”\n\n“做不到。”\n\n克劳盯着他。\n\n莱尔放下勺子。“我能从物品的视角看到过去。只能看见。时间不会停，也不会往回走。”\n\n“你没碰过现场的东西。”\n\n“碰了也救不了他们。”\n\n“也许还有别的用法——”\n\n“没有。”\n\n莱尔说得很快。他怕慢一点，自己也会顺着克劳的话想。想那块歪斜的门板、那张翻倒的餐桌——如果他伸手，或许能看见院门被撞开的时刻。看清来人的脸。听见餐厅里的动静。\n\n然后呢。\n\n画面结束之后，木头照样腐烂，金属照样生锈。死去的人依旧躺在原来的地方。\n\n“对不起。”莱尔说。\n\n克劳松开桌沿，低下头重新拿起勺子。凉掉的炖菜，一口接一口送进嘴里。咽得很慢，却没停。直到碗底只剩薄薄一层汤。\n\n莱尔没有再劝他喝水。\n\n“西奥多，沃尔特。”\n\n一名年轻治安官出现在餐厅门口，腋下夹着文件板。“两位，有人要见。会议室。”\n\n楼梯间有地板蜡和湿石膏的气味。二楼走廊尽头，会议室门开着，窗帘半垂。正午的光在长桌上摊成一块发白的方形，灰尘在光柱里慢慢浮沉。\n\n桌边坐着一个深灰色制服的男人。寸头，宽肩。\n\n他示意他们坐下。\n\n“我来自异常管理局。这次谈话由我负责。”声音不高，语速很慢，目光一直落在两人脸上。\n\n“异常管理局？”克劳问。\n\n“专门处理异能失控、异常器物和相关案件。”男人拿起桌上一只牛皮纸文件袋。袋面黑墨写着一行字：晨星孤儿院异常事件。“孤儿院出事的当天，东郊监测装置记录到凯莉米粒子浓度突然超过安全阈值。管理局因此介入。”\n\n莱尔的目光扫过文件袋，又看向男人。“凯莉米粒子是什么？”\n\n“肉眼看不到的一种粒子。”他手指点着桌面，“异能发动或异常器物活动时，周围粒子浓度会发生变化。最早发现这种现象的人叫凯莉米。她后来制造出第一台观测仪，后人便用她的名字命名。”\n\n窗外远远传来报菜价的声音，隔着砖墙，闷闷的。正午的光在桌上爬了半寸，从文件袋一角挪到他指节旁。\n\n“浓度升高，就代表出现异常事件？”\n\n“通常可以这样判断。日常使用只会让数字轻微浮动。越过了警戒线，管理局就会标记为异常事件。孤儿院当天的读数很高。”他解开绕绳。绳圈松开，一股旧纸的灰尘味散出来。\n\n先取出一张地图。“这里是孤儿院？”\n\n莱尔看了一眼：“对。东边是菜畦和储物棚，图上少了间鸡舍。”\n\n男人在纸边记了一笔，又抽出一份人员登记表。表上列着玛丽修女和孩子们的姓名年龄，附有从市政档案调来的小幅照片。\n\n“逐个看。姓名、住址、人物，不对的地方指出来。”\n\n莱尔和克劳从头认到尾。纸页翻动，沙沙声响在安静里。莱尔指尖掠过每一个名字，没有停顿。\n\n核对完，男人没有立刻收起来。他双手交叠在桌上。指甲剪得很短，指节有几处脱皮。\n\n“还有两个问题。”\n\n“孤儿院里，有没有人拥有异能？”\n\n克劳的右手缩回桌下。\n\n“或者在案发前后，你们有没有见过无法解释的事？陌生的器物、奇怪的痕迹、突然出现又消失的人，都算。”\n\n莱尔没有立刻回答。\n\n几天前，有人来过孤儿院。灰色大衣，自称异常管理局，也在打听异能。但眼前这个男人手里有监测记录，有市政档案，连案发后的数据都拿来核对。他似乎并不知道此前有人上门。\n\n莱尔开口：“雷金纳德先生。”\n\n男人眉梢动了一下。\n\n“有没有人或组织冒充异常管理局？”\n\n男人没有回答，目光在莱尔和克劳之间走了一遍。\n\n克劳接话：“案发前三天，有三个人来过。灰色大衣。问玛丽修女，院里谁有异能。”\n\n“什么时候？”\n\n“下午——具体时间记不太清，在会客室待了近一个钟头。”\n\n“见过他们的脸？”\n\n“见过两个。”\n\n男人拉过一张空白记录纸：“能记住的特征，全部告诉我。”他写了几行，笔尖停住，抬眼。“刚才问的，属于敏感情报，我不能透露。”\n\n“我们住的地方没了。”莱尔说，“至少该让我们知道他们是谁。”\n\n男人沉默了一会儿。窗外的光线移了移，他半张脸落进阴影里。“我会查清那三个人的身份，也会让治安所加强对你们的保护。能公开的消息，我会亲自告诉你们。”\n\n他把文件收好，绕绳重新扣上。等治安官来带他们离开时，他忽然叫住莱尔。\n\n“等一下。”\n\n莱尔回过头。\n\n男人指了指自己，又低头看了看制服领口，摸了摸袖扣：“我进门后只说了所属部门，没有报姓名。你怎么知道我叫雷金纳德？”\n\n莱尔看着他。克劳也看着他。\n\n沉默了几秒。\n\n两人同时抬手，指向男人胸前。\n\n“先生，你的工牌。”	二楼会议室内，异常管理局年轻干员雷金纳德接见莱尔与克劳，桌上放着晨星孤儿院异常事件的文件袋。他重新核对案发经过，近期访客和异能者信息，并解释现场检测到异常浓度的凯莉米粒子，浓度远超自然残留，因此凶手很可能动用了异能。莱尔从提问顺序和文件内容中察觉，正式档案里没有玛丽修女主动登记治疗能力的记录，这与克劳所说的登门调查相互矛盾。他由此判断先前来访者是假冒人员。雷金纳德记下对方特征，却拒绝透露怀疑对象，只承诺继续追查并加强保护。临走时他追问莱尔如何得知自己姓名，两名少年同时指向他胸前的工牌。	2285	draft	a9bcfa47-5a17-442f-85dd-c050b209c378	5	{"key_events": ["雷金纳德展示晨星孤儿院异常事件档案", "莱尔根据缺失资料判断先前调查人员是假冒者", "雷金纳德承诺追查线索并因工牌闹出笑话"], "character_focus": ["莱尔·西奥多", "克劳·沃尔特", "雷金纳德·洛克哈特"], "emotional_tone": "严肃悬疑中带有短暂诙谐", "narrative_goal": "揭示惨案与异能者有关，建立冒牌管理局人员的核心谜团，并完成莱尔与雷金纳德的初次接触", "conflict_type": "信息缺失与推理交锋", "estimated_words": 3300, "scenes": null}	2026-08-06 15:23:16.567449	2026-08-07 00:37:40.316148
b03607f8-cc24-4b4c-9023-647a4dfb1b5c	7f6d28c4-2a32-46d1-887c-6cf5c4555056	3	熄灭的晨星	药瓶撞上石阶，瓶塞滚进门缝。\n\n里面没有人出来。\n\n克劳扔下煤油桶，一把推开大门。断掉的门闩擦过地面，发出刺耳的刮响。\n\n“等等。”\n\n莱尔抓了个空。\n\n门后的血腥味扑出来，混着煤灰和冷掉的燕麦，黏在喉咙里。几只苍蝇从墙角飞起，嗡嗡绕过克劳的肩膀。\n\n走廊还是他们离开时的样子，又不太一样。\n\n衣帽架倒了，木钩断了两根。半扇窗碎在地上，玻璃踩得到处都是。墙边躺着托比劈柴用的小斧，斧柄上全是血。\n\n克劳站住了。\n\n“托比？”\n\n没人应。\n\n他往前走，靴底踩中一只铁皮杯。杯子咣当滚远，撞在厨房门上。\n\n莱尔蹲下去，没碰那把斧头。\n\n血已经暗了。斧刃干净，斧柄却沾了血，说明托比抓起它时，手上就有伤。\n\n血点一路拖向厨房。\n\n“别进去。”莱尔说。\n\n克劳推开门。\n\n煤炉灭了，锅翻在地上，燕麦糊凝成一摊。托比倒在长桌旁，手臂还朝门口伸着，指尖离斧头只差几步。\n\n他没拿到。\n\n克劳蹲下，手伸到一半，停在托比肩上。\n\n“托比。”\n\n还是没有回应。\n\n桌底露出一只小鞋。克劳猛地掀开桌布，动作太大，长凳被带倒在地。\n\n诺亚缩在桌下。\n\n他怀里抱着那只木马，脸埋在膝间，安静得像睡着了。木马从中间裂开，裂缝正是莱尔碰过的位置。\n\n克劳的呼吸卡了一下。\n\n他把桌布放回去，没再看。\n\n莱尔站在门边，盯着地面。厨房里脚印很多，孩子的软底鞋、玛丽修女的旧皮鞋，还有至少三双沾泥的长靴。\n\n两双鞋底钉了铁掌。另一双窄一些，后跟磨损严重。\n\n三个人。\n\n脚印从正门进来，在厨房散开。有人去了宿舍，有人走向医务室，最后那个人留在这里。\n\n莱尔抬头看向橱柜。\n\n柜门全开着，糖罐摔碎了，面粉袋却没动。来人不是为了钱，也不是为了食物。\n\n他们在找东西。\n\n或者找人。\n\n“分开找。”克劳起身，声音发哑，“也许还有活着的。”\n\n莱尔看着他。\n\n“别碰任何不该碰的东西。”\n\n克劳已经冲出了厨房。\n\n“艾拉！”\n\n喊声撞过走廊，又空荡荡地折回来。\n\n“萨姆！贝琪！”\n\n莱尔走向楼梯。他的腿有些僵，第一步差点踩空。\n\n不能乱。\n\n看门锁。看脚印。看他们动过什么。\n\n宿舍门没有上锁，门板上留着一道斜劈出来的裂口。屋里十几张床挤在一起，被褥掀得乱七八糟。床下、柜子、衣箱，全被翻过。\n\n窗台边有泥。\n\n艾拉趴在那里，一只手还抓着窗框。她应该是想爬出去。窗外的排水管被扯歪了，下方却没有落地的脚印。\n\n没逃掉。\n\n两人一间间推门。\n\n洗衣房、储藏间、医务室。\n\n药柜被砸开，绷带和瓶罐铺满地面。会客室更乱，桌子的抽屉整个掉了出来，壁炉里的灰被人扒开，下面埋着几片烧焦的纸。\n\n克劳打开礼拜室的门。\n\n里面很暗。蜡烛全灭了，只剩一股烧过的油脂味。彩窗破了一个洞，冷风钻进来，吹得祭台白布不停抖动。\n\n玛丽修女靠坐在晨星圣像下。\n\n她的手压着胸口，指缝里夹着一枚被扯断的银色晨星。围裙沾满血，口袋翻了出来，几枚缝衣针散在脚边。\n\n克劳走过去，跪在她面前。\n\n“玛丽修女。”\n\n他喊得很低。\n\n莱尔停在门口。\n\n早上玛丽替克劳整理衣领时，那双手还是暖的。现在她垂着头，鬓边的白发被风吹动，胸前却没有一点起伏。\n\n“人从后门走的。”莱尔说。\n\n礼拜室后的窄门敞着。门外是荒废的菜地，再往后就是城墙下的旧巷。\n\n泥地上留有车辙。\n\n克劳起身，打开小刀。\n\n“我去追。”\n\n“先报案。”\n\n“车很重，走不快。”\n\n“也可能就停在旧巷里等着。”\n\n克劳转过身，眼底全是血丝。\n\n“那正好。”\n\n“正好什么？”莱尔压低声音，“让他们把你也杀了？”\n\n刀刃在克劳手中发出轻响。他手背上裂开一道细口，血慢慢渗出来。\n\n莱尔按住他的手腕。\n\n“他们能在这里杀掉所有人，还能不慌不忙地翻房间。你连他们是谁都不知道。”\n\n克劳的手腕绷得像铁。\n\n莱尔没有松开。\n\n“去管理所。封城门，查车，叫巡警搜旧巷。你一个人能找几条街？”\n\n礼拜室里只剩白布被风吹动的声音。\n\n过了几秒，克劳合上刀。\n\n“走。”\n\n治安管理所在两条街外。\n\n值勤室里有股隔夜咖啡和湿羊毛的味道。火炉烧得太旺，一个胖巡员正趴在桌后打盹，帽子盖住半张脸。\n\n克劳一掌拍在桌上。\n\n“晨星孤儿院出事了。”\n\n巡员惊醒，差点从椅子上摔下来。\n\n“什么事？”\n\n“人都死了。”\n\n巡员看了看他，又看向莱尔。\n\n“你们喝酒了？”\n\n莱尔把沾血的鞋往前挪了半步。\n\n“十三人遇害。凶手至少三名，可能乘马车从城西旧巷离开。现在去，还能封住西门。”\n\n巡员脸上的困意没了，却仍没起身。\n\n“十三人？你知道谎报命案是什么罪吗？”\n\n“知道。”\n\n“谁死了？”\n\n下一个问题。\n\n莱尔顿了顿。欺骗的力量就在舌根下，只要他愿意，这人会立刻相信。\n\n可没必要。\n\n“玛丽修女、托比、诺亚、艾拉，还有其他孩子。”他说，“我们刚从那里回来。”\n\n全是真话。\n\n巡员盯着两人看了几秒，抓起桌上的铜铃。\n\n铃声一响，后屋脚步杂乱。\n\n六名巡警被叫了出来。领头的是个瘦高男人，外套扣错了一颗。他听完只问了门牌，便带人赶往孤儿院。\n\n莱尔和克劳被留在值勤室。\n\n没人给他们水，也没人再问话。\n\n墙上的钟走了二十七分钟。克劳坐在长椅最边上，莱尔站在窗边，看着一队骑警穿过街口，朝城西赶去。\n\n又过了十分钟，门被推开。\n\n瘦高巡警回来了，脸色发白，靴边沾着孤儿院菜地的泥。\n\n他对值勤巡员点了下头。\n\n“是真的。”\n\n屋里一下安静了。\n\n很快，管理所的人全动了起来。有人去叫治安官，有人拿封条，有人通知城门。两辆马车停在门外，十几名巡警带着枪和警棍赶往晨星孤儿院。\n\n一个留着灰胡子的治安官走到莱尔面前。\n\n“你们是幸存者？”\n\n“我们出门采购，回来时已经这样了。”\n\n“还有别人活着吗？”\n\n“没有了。”\n\n“从现在起，你们留在这里。没有我的允许，谁也不能离开。”\n\n克劳抬眼。\n\n“这是为了保护你们。”\n\n治安官叫人锁上侧门，又安排两名持枪巡警守在外面。\n\n窗外，最后一辆马车驶向城西。车轮卷起脏水，溅在管理所的台阶上。	药瓶撞上石阶，瓶塞滚进门缝。 里面没有人出来。 克劳扔下煤油桶，一把推开大门。断掉的门闩擦过地面，发出刺耳的刮响。 “等等。” 莱尔抓了个空。 门后的血腥味扑出来，混着煤灰和冷掉的燕麦，黏在喉咙里。几只苍蝇从墙角飞起，嗡嗡绕过克劳的肩膀。 走廊还是他们离开时的样子，又不太一样。 衣帽架倒了，木钩断了两根。半扇窗碎在地上，玻璃踩得到处都是。墙边躺着托比劈柴用的小斧，斧柄上全是血。 克劳站住了。 “托比？” 没人应。 他往前走，靴底踩中一只铁皮杯。杯子咣当滚远，撞在厨房门上。 莱尔蹲下去，没碰那把斧头。 血已经暗了。斧刃干净，斧柄却沾了血，说明托比抓起它时，手上就有伤。 血点一路拖向厨房。 “别进	2448	completed	a9bcfa47-5a17-442f-85dd-c050b209c378	3	{"key_events": ["莱尔与克劳进入孤儿院并确认惨案发生", "两人在礼拜室找到已经遇害的玛丽修女", "治安管理所接报后封锁现场"], "character_focus": ["莱尔·西奥多", "克劳·沃尔特"], "emotional_tone": "震惊悲痛而克制", "narrative_goal": "摧毁角色原有的安稳生活，确立灭门惨案作为两人共同命运的起点", "conflict_type": "突发灾难与幸存者创伤", "estimated_words": 3400, "scenes": null}	2026-08-06 15:23:16.567449	2026-08-06 22:32:42.409642
9ad1ee72-1357-48e5-a162-cf2d304c65d5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	4	问询	雾从格雷文赫港一路漫进城西。\n\n蒸汽吊臂在远处起落，铁链碰撞，铛、铛，声音隔着灰白天幕传来，像有人在雾里敲钟。煤烟压过哥特式尖顶，煤气灯尚未熄灭，街角的异常粒子检测仪亮着一颗疲惫的绿灯。\n\n镜头再往下。\n\n治安管理所门前积着一洼雨水。送煤车碾过石板，污水溅上台阶。两个巡警刚换完岗，湿斗篷冒着汗馊味，靴底带进来的白泥一路拖到走廊深处。\n\n临时休息室里，莱尔睁着眼。\n\n他一夜没睡。\n\n屋里塞着两张行军床。一张缺腿，底下垫了三本旧卷宗。每逢克劳翻身，铁架便嘎吱一声。窗户钉死了，玻璃上全是水汽，墙角还有股陈年霉味。\n\n桌上摆着两杯昨夜送来的咖啡。\n\n黑沫凝成一圈油光。\n\n莱尔看了一会儿，得出结论——放凉以后，它和下水沟的区别只剩一个搪瓷杯。\n\n克劳坐在另一张床边。\n\n他背抵着墙，右手插在夹克口袋里，一夜没动。\n\n那是玛丽修女的。\n\n走廊响起脚步。随后是钥匙相撞的声音。\n\n门开了。\n\n昨天带队去孤儿院的瘦高巡警探进身子。他眼窝发青，袖口沾着泥，手里没有镣铐，只有一摞登记表。\n\n“莱尔·西奥多？”\n\n“在。”\n\n“来补几项基本资料。克劳晚些时候。”\n\n莱尔看向桌角。\n\n“早餐呢？”\n\n巡警揉了揉眉心。\n\n“食堂正在煮。”\n\n“昨天也在煮。”\n\n“锅炉坏了。”\n\n“我开始怀疑，你们的食堂是案发现场。”\n\n巡警嘴角动了动，没笑出来。\n\n莱尔走到门口，又停下。\n\n“给他一杯热水。”\n\n“我让人送。”\n\n“别用装咖啡的壶。”\n\n这次，巡警看了桌上那两杯黑东西一眼，脸上浮出一点认同。\n\n问询室里比走廊暖。\n\n暖炉刚添过煤，热气裹着湿羊毛、烟灰和墨水味扑来。窗边晾着几件被雨淋透的制服，水珠落在铁盘里，滴答作响。\n\n灰胡子治安官坐在桌后。\n\n他昨夜也没休息。外套搭在椅背，衬衣袖子卷到手肘，右手食指沾着一片洗不掉的蓝墨。桌上摊着城西地图，孤儿院附近几条街都被红铅笔圈了起来。\n\n“坐吧。”他说。\n\n莱尔坐下。\n\n记录员先核对姓名、年龄、住址和孤儿院人员名单。问得很细。每个孩子睡在哪间屋，玛丽修女通常几点熄灯，孤儿院有没有后门，近一个月是否收过陌生信件。\n\n不像审问。\n\n更像他们正试着从一堆碎纸里，拼回晨星孤儿院原来的模样。\n\n治安官将一张采购单推过来。\n\n“这是我们从杂货铺找到的副本。你们昨天依次去过面粉铺、药房、煤油店，对吗？”\n\n“还去过旧街的肉铺。”莱尔说，“但肉太贵，没买。”\n\n“店主记得你们。时间也能对上。”\n\n治安官用铅笔在地图上画了一道线。\n\n“城门和沿途店铺都问过了。你们报案前后，有七辆马车经过附近。三辆运煤，一辆送菜，两辆私家车，还有一辆没有登记车牌。”\n\n莱尔看向那个红圈。\n\n“找到最后一辆了吗？”\n\n“正在找。车轮左侧有缺口，碾过软泥会留下断纹。昨夜已经让巡队去查城西的车行和马厩。”\n\n治安官说完，抽出另一张纸。\n\n“现场的鞋印也分出了三种。两双钉铁掌的长靴，一双窄底靴。窄底靴右后跟磨损严重。”\n\n与莱尔昨日报上来的判断一样。\n\n治安所没有把那几句话随手塞进卷宗。他们重新量过，也做了拓印。\n\n只是现场最初被报案的人、邻居和赶到的巡警踩乱不少，能留下来的痕迹不多。\n\n“你当时看得很仔细。”治安官说。\n\n“我在那里站得够久。”\n\n记录员的笔停了一下。\n\n屋里只剩暖炉里煤块开裂的轻响。\n\n治安官没有再追问。他将一张临时安置单压在桌边。\n\n“你们不是嫌疑人。把你们留在这里，一是方便补充情况，二是暂时没有合适的去处。西区救济院腾出床位前，你们可以住休息室。想出去透气，也可以让巡员陪同。”\n\n“要多久？”\n\n“三天内给你们安排住处。异常管理局也会派人来。”\n\n莱尔抬眼。\n\n“为什么？”\n\n“现场有些情况，不归我们单独处理。”\n\n治安官没有敷衍。他指了指桌上一只封好的证物袋。透明薄膜内，躺着几粒颜色发暗的墙灰。\n\n“具体等他们说。”\n\n门外有人敲了两下。\n\n瘦高巡警送进一只搪瓷杯。杯里热气腾腾。\n\n莱尔接过水，回到休息室。\n\n克劳还是原来的姿势。只是他脚边多了一只纸袋，里面装着两块硬面包和一小罐果酱。\n\n“问了什么？”克劳开口。\n\n“名字。年龄。谁睡哪张床。”\n\n“还有呢？”\n\n“他们找到了一辆没登记的马车。”\n\n克劳抬起头。\n\n莱尔把热水递过去。杯壁很烫，克劳接住时，僵硬的手指终于松开一点。\n\n“会找到人吗？”他问。\n\n“会先找到车。”\n\n“人呢？”\n\n“人比车会撒谎。”\n\n克劳没再问。\n\n走廊另一头忽然传来孩子的哭声。很细，很尖。大概是谁走丢了，被家里人领来报案。\n\n克劳手腕一抖，水洒在膝头。\n\n莱尔扯过桌上的旧报纸，盖住那片水迹，也挡住门上的观察窗。\n\n“不是他们。”\n\n哭声很快被人哄住。\n\n克劳低头喝了一口。水太烫，他喉结动了动，没吐出来。\n\n纸袋里的果酱是李子味。\n\n玛丽修女每年秋天也会熬。她总嫌孩子们拿得太多，会拿木勺敲桌沿。可等人散了，瓶底又总会留出两勺。\n\n莱尔掰开面包，把果酱抹得很薄。\n\n第一天，他们分别补了两次记录。\n\n一次核对采购路线。一次辨认近半年到访孤儿院的人。\n\n治安官带来一册临时绘制的访客画像。修烟囱的老工匠，收旧报纸的商贩，给孩子看牙的医生，还有几个向孤儿院捐过衣服的人。\n\n莱尔翻到最后。\n\n纸上是三名穿灰色长衣的男人。帽檐很低，袖口压着银线。\n\n“他们。”莱尔说。\n\n记录员立刻提笔。\n\n“什么时候来的？”\n\n“采购前几天。克劳见过。”\n\n莱尔将画像推回去。\n\n“他们自称异常管理局调查员。”\n\n第二天，雨小了些。\n\n走廊里满是湿靴子、热煤和廉价烟草的味道。电话铃从早晨响到中午，打字机咔嗒不停。巡警抱着卷宗上下楼，门口还停了两辆沾满泥的蒸汽车。\n\n没人闲着。\n\n灰胡子治安官早上来过一次。\n\n“那辆无牌马车找到了半截线索。”他把一张车辙照片放在桌上，“西南旧货场附近有同样的断纹，但昨夜下雨，痕迹断了。”\n\n克劳盯着照片。\n\n“我可以去找。”\n\n“不行。”治安官说，“货场有走私贩和废弃锅炉，巡队会查。你们去了，只会让我们多找两个人。”\n\n克劳脸色发冷。\n\n莱尔却把照片拿近了些。\n\n车辙旁有一枚鞋印。前掌宽，鞋钉排列规整。不是普通工人的靴子。\n\n“查车行了吗？”他问。\n\n“查了二十七家。城西没有修过这种轮子。我们已经把消息送去其他辖区。”\n\n治安官收回照片，动作很慢。\n\n“尸检也有进展。死亡时间与你们外出采购的时间重合。现场没有发现长时间停留的生活痕迹，袭击者来得快，走得也快。”\n\n克劳的下颌绷紧。\n\n他没有问玛丽修女。\n\n治安官看了他一眼，将一只小布包放到桌上。\n\n里面是一串烧黑的木珠。\n\n“从礼拜室门边找到的。你们认得吗？”\n\n莱尔伸出手。\n\n木珠表面开裂，其中一颗还留着浅浅的星形刻痕。那是有个孩子用餐刀偷偷划的，玛丽修女发现后罚他擦了三天长椅。\n\n“是她的念珠。”莱尔说。\n\n治安官沉默片刻。\n\n“现在还不能作为遗物交给你们。案子结束后，会归还。”\n\n“别弄丢了。”\n\n“不会。”\n\n他说得郑重。	雾压在城西，屋脊只剩一排发黑的轮廓。 送煤车慢吞吞碾过街口，车轮咬着石缝，吱呀，吱呀。治安管理所门前积了半洼脏水，夜里冻出一层薄冰。两个巡警缩在屋檐下换岗，跺着脚，白气刚出口就散进雾里。 一墙之隔，临时休息室冷得像地窖。 屋里塞着两张行军床。一张缺了条腿，底下垫着几本旧卷宗，每次有人翻身，床架就嘎吱乱叫。窗户钉死了，玻璃上全是水汽。昨晚送来的咖啡摆在桌角，黑沫凝成油腻的一圈。 莱尔一夜没睡。 克劳也没睡。 他坐在床边，背抵着墙，右手始终插在夹克口袋里。那枚缝衣针就在里面。隔着一层布，针尖顶着他的指腹。 走廊传来钥匙碰撞声。 门打开，昨天带队赶去孤儿院的瘦高巡警探进头。 “莱尔·西奥多，出来。”	2854	completed	a9bcfa47-5a17-442f-85dd-c050b209c378	4	{"key_events": ["莱尔与克劳在治安管理所待了三天", "期间有陆续的常规问询，但似乎对治安官帮助不大"], "character_focus": ["莱尔·西奥多", "克劳·沃尔特"], "emotional_tone": "疲惫压抑中伴随冷静审视", "narrative_goal": "呈现幸存者的创伤反应，强化莱尔在压力下搜集信息和保护同伴的能力", "conflict_type": "官方审查", "estimated_words": 2000, "scenes": null}	2026-08-06 15:23:16.567449	2026-08-06 22:37:51.834602
0d279990-8dd2-443c-b89d-555cfe85bf95	d59e468a-8617-41e0-aabf-87a13be78834	48	暗号所指	\N	张羽按照地图指引，来到一处废弃的矿洞。在矿洞深处，他找到了墨渊留下的信息：柳若霜已被安全转移，但墨渊自己被天衡司的人追踪，无法汇合。墨渊留下了一些关于如何利用梭形物对抗分灵锚的线索——梭形物不仅是分灵锚的核心，也可能是关闭分灵锚的钥匙。张羽在矿洞最深处发现了一个小型的分灵锚装置，正在缓慢吸收周围的灵气。装置周围散落着几具干瘪的尸体，显然是被吸干了灵气的修士。张羽意识到，如果激活梭形物来破坏这个装置，可能会暂时阻断本源收割，但也必然暴露自己的位置给追兵。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	52	{"key_events": ["张羽找到墨渊留下的信息和对抗分灵锚的线索", "张羽发现正在运转的小型分灵锚装置", "张羽面临是否激活梭形物破坏装置的抉择"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "孤独、坚定、面临抉择", "narrative_goal": "获得对抗分灵锚的方法，同时面临是否暴露位置的艰难抉择", "conflict_type": "人物与自我的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:32:43.955919	2026-09-20 19:41:19.413742
f076074b-309b-4dbd-8ae5-be35c8f5fa10	d59e468a-8617-41e0-aabf-87a13be78834	52	命悬一线	\N	张羽主动走向祭坛中央，分灵锚主节点感应到他体内隐灵根的特殊共鸣，瞬间爆发出强大的吸力。张羽感觉自己的神魂仿佛被一只无形巨手撕扯，剧痛之下，他咬破舌尖保持清醒。他意识到这并非单纯的破坏阵法，而是分灵锚在试图将他体内的伪灵根彻底激活并收割。在意识即将被吞噬的刹那，他利用梭形物作为媒介，将自身意志强行灌入主节点，以自毁方式在阵法核心制造裂痕。然而分灵锚的反噬力量远超想象，张羽七窍流血，经脉寸断，陷入半昏迷状态。祭坛周围的黑光开始不稳定地闪烁，整个祭礼殿都在剧烈震动。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	56	{"key_events": ["分灵锚主节点感应到张羽隐灵根的特殊共鸣并爆发强大吸力", "张羽遭分灵锚神魂撕扯，以自毁方式制造阵法裂痕", "张羽遭反噬七窍流血陷入半昏迷"], "character_focus": ["张羽", "柳若霜", "石铁心"], "emotional_tone": "紧张、悲壮、绝望中的挣扎", "narrative_goal": "展现张羽为破坏分灵锚阵眼所付出的巨大代价，同时揭示分灵锚对隐灵根的特殊感应机制", "conflict_type": "人与阵法力量的对抗", "estimated_words": 3000, "scenes": null}	2026-09-20 16:34:18.023476	2026-09-20 19:43:31.085873
162ccd0f-701e-45ab-8592-b576da0eed50	d59e468a-8617-41e0-aabf-87a13be78834	40	黎明祭歌	\N	祭天大典当日，天璇宗钟声长鸣。张羽在住处感应到隐灵根与祭台方向的共鸣异常强烈，甚至能模糊感知到黑色物质的流动轨迹。众人最后一次汇合，墨渊将仅有的三份药液分配给张羽、柳若霜和石铁心，自己则负责在外围策应。苏晚棠带来坏消息：祭天大典的守卫比预期多了一倍，且有一名内门长老亲自坐镇。张羽决定按原计划行动，但必须更加谨慎。临行前，柳若霜将一枚护身符塞给张羽，说是用变异清心草提炼的最后精华制成，能在关键时刻抵挡一次神魂攻击。众人分头出发，张羽贴着隐息符，混入了前往祭台的人群中。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	44	{"key_events": ["张羽感应到隐灵根与祭台黑色物质的强烈共鸣", "墨渊分配三份药液给张羽、柳若霜和石铁心", "苏晚棠发现祭天大典守卫增加一倍且有内门长老坐镇", "柳若霜将护身符交给张羽"], "character_focus": ["张羽", "柳若霜", "墨渊", "苏晚棠"], "emotional_tone": "紧张、压抑、决绝", "narrative_goal": "完成祭天大典前的最后准备，展现团队协作与个人情感，为行动开始做铺垫", "conflict_type": "外部压力与内部焦虑的叠加", "estimated_words": 3000, "scenes": null}	2026-09-20 16:15:59.856503	2026-09-20 19:41:19.413742
207cf54b-7f85-4009-8aca-07600873ff47	d59e468a-8617-41e0-aabf-87a13be78834	30	废矿洞之约	\N	子夜，张羽与石铁心潜入废弃矿洞入口，老园丁已在那里等候。老园丁自称曾是灵矿堂的初代执事，三十年前亲眼目睹矿洞深处发生的异变，此后伪装成普通园丁苟活至今。他带领两人深入矿道，来到一处被巨石封堵的洞穴前。移开巨石后，洞壁上赫然刻满与石铁心发现石板上相似的古老符文，中央嵌着一块拳头大小的黑色晶石，散发着与灵植上黑色丝线同源的气息。老园丁透露，这种晶石是噬界者用来锚定此界坐标的信物，天璇宗建宗之初便已存在，历代宗主都知情却选择沉默。张羽上前触碰晶石，刹那间脑海中闪过无数陌生世界的画面，他猛然收回手，面色苍白。石铁心扶住他，三人意识到这块晶石可能是揭开噬界者入侵机制的关键，但也被天璇宗高层严密守护。离开前，老园丁郑重警告，祭天大典前必须做出抉择，否则所有人都将成为祭品。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	34	{"key_events": ["老园丁揭示自己曾是初代执事并目睹三十年前异变", "发现矿洞深处刻有古老符文的锚定晶石", "张羽触碰晶石获得噬界者入侵的碎片画面"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "探秘的震撼与真相揭露的沉重", "narrative_goal": "揭示噬界者入侵的具体锚定手段，将世界真相进一步具象化，同时把老园丁纳入同盟", "conflict_type": "真相认知冲击与外部高压环境的矛盾", "estimated_words": 3000, "scenes": null}	2026-09-20 16:11:37.953307	2026-09-20 19:41:19.413742
2e4f0c7c-b8f2-4158-8694-06d19c5e90df	d59e468a-8617-41e0-aabf-87a13be78834	26	坊市偶遇	\N	清晨，苏晚棠在外门坊市中以她惯常的活泼形象与摊主打探消息。她注意到最近坊市中出现了一些陌生的面孔，气息不像是天璇宗的弟子。经过一番周旋，她成功接触到一位来自苍梧派的修士。对方暗中向她透露，苍梧派近期也有弟子在服用天璇宗发放的丹药后离奇失踪，且失踪前都曾表现出神魂透支的症状。苏晚棠意识到这可能是一个潜在的盟友，但就在她准备进一步接触时，她敏锐地察觉到有人在跟踪她。她必须在不暴露身份的情况下甩掉尾巴，同时保护这个重要的情报来源。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	30	{"key_events": ["苏晚棠在外门坊市发现陌生修士踪迹", "苏晚棠接触苍梧派修士获知该派弟子也出现失踪", "苏晚棠发现自己被跟踪"], "character_focus": ["苏晚棠", "石铁心"], "emotional_tone": "警觉、危机感", "narrative_goal": "拓展外部盟友线索，增加紧张感", "conflict_type": "间谍与反间谍", "estimated_words": 3000, "scenes": null}	2026-09-20 16:10:47.985217	2026-09-20 19:41:19.413742
3778765d-d957-4868-a380-e04d0e66d804	d59e468a-8617-41e0-aabf-87a13be78834	19	丹纹暗记	\N	深夜，张羽在灵矿堂的值班室中等待最佳时机。他利用对灵气波动的敏锐感知，巧妙避开巡逻弟子的路线，成功潜入存放凝神丹的密室。在获取丹药的过程中，他发现这些凝神丹表面附着着一层极其细微的黑色纹路，与之前在灵植上发现的黑色雾气如出一辙。更令他震惊的是，他在密室中发现了一份被遗忘的清单，上面记录着凝神丹的分配对象，全是天赋出众、即将突破的弟子。就在他准备离开时，他察觉到一股若有若无的监视气息，似乎有人已经知道了他的行动。张羽屏息凝神，利用矿道中的回声制造假象，成功脱身，但心中已明白，自己或许早已落入某人的视野之中。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	23	{"key_events": ["张羽成功获取凝神丹", "发现凝神丹表面黑色纹路与灵植雾气同源", "察觉到暗处监视气息并惊险脱身"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张悬疑", "narrative_goal": "", "conflict_type": "人与环境的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:09:18.094181	2026-09-20 19:41:19.413742
42d2335a-bd73-41bc-95e6-5321ec6c46c8	d59e468a-8617-41e0-aabf-87a13be78834	22	暗流初现	\N	祭天大典临近，宗门上下忙碌筹备。张羽在灵矿堂值班时，注意到近期运送至祭台的物资中，有一部分被刻意标记为'禁物'，由内门弟子亲自押送，不容他人窥探。他利用职务之便，暗中记录这些物资的批次与数量，发现它们与墨渊先前推断的阵法材料高度吻合。与此同时，石铁心在矿洞深处搬运灵石时，偶然听到两名内门弟子低声交谈，提及'天启之门将在大典之夜开启'，以及'届时所有天赋出众的弟子都将成为祭品'。石铁心强压惊骇，不动声色地记下两人的面孔与离去方向。当夜，张羽与石铁心在废弃矿道碰头，交换各自获取的情报。两人意识到，留给他们的时间已经不多，必须尽快通知墨渊与柳若霜，商讨对策。然而，他们不知道的是，他们的一举一动，已经落入了某些人的监视之中。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	26	{"key_events": ["张羽记录祭台禁物批次与数量发现与阵法材料吻合", "石铁心偷听到内门弟子谈论天启之门开启与弟子成为祭品", "张羽与石铁心在废弃矿道交换情报并意识到时间紧迫", "两人行动被暗中监视"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "紧张压抑、暗流涌动", "narrative_goal": "推进祭天大典的危机感，展示张羽与石铁心各自的调查成果，为四人聚首做铺垫，同时引入被监视的危机", "conflict_type": "信息博弈与暗中角力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:10:18.508272	2026-09-20 19:41:19.413742
6889e371-8743-4df3-976c-691410cc2745	d59e468a-8617-41e0-aabf-87a13be78834	53	绝境反击		墨渊和苏晚棠按照计划在外围等候，听到祭礼殿警报大作，两人意识到张羽的行动出了变故。苏晚棠不顾墨渊阻拦，凭借对药理的了解，利用随身携带的迷烟弹强行冲入混乱的祭礼殿，在坍塌的甬道中找到了半昏迷的张羽。墨渊则在外围利用地形和暗器牵制赶来的天衡司执事，为苏晚棠救人争取时间。苏晚棠发现张羽体内灵气暴走，经脉受损严重，更意外的是梭形物在自动吸收分灵锚逸散的能量，这让她意识到这件法器远比想象中更加神秘。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	57	{"key_events": ["苏晚棠不顾危险冲入祭礼殿找到张羽", "墨渊在外围牵制天衡司执事争取撤离时间", "苏晚棠发现梭形物在自动吸收分灵锚逸散能量"], "character_focus": ["苏晚棠", "墨渊", "张羽"], "emotional_tone": "紧张、焦急、希望与危机并存", "narrative_goal": "展现苏晚棠和墨渊对张羽的救援行动，同时揭示梭形物的特殊能力", "conflict_type": "人与人的对抗、救援与时间的赛跑", "estimated_words": 3000, "scenes": null}	2026-09-20 19:43:31.085873	2026-09-20 19:48:51.523923
27f066b4-904e-4bf8-8ecc-df41865b6b9c	d59e468a-8617-41e0-aabf-87a13be78834	71	枯骨与黑色石柱	\N	葬剑谷内部比想象中更加荒凉，灵气稀薄到几乎无法吐纳。四人艰难前行，石铁心因伤势和灵气匮乏而愈发虚弱，柳若霜将仅剩的丹药化入水中喂他服下。墨渊注意到地面泥土中偶尔露出灰白色的碎屑，仔细辨认后竟是修士骨骼的残片。随着深入，残片越来越多，最终他们在一片开阔地边缘看到了骇人的景象：数十具干尸保持着盘坐或挣扎的姿态，衣物腐朽但依稀可辨是天璇宗外门弟子的服饰。所有尸体都面目扭曲，眉心处有细小的孔洞，仿佛被抽干了神魂。干尸环绕的中心，矗立着一根十丈高的黑色石柱，石柱表面刻满与药园地底相同的符文，但更加复杂。石柱底部堆积着厚厚的灰白色粉末，张羽捻起一搓，发现是枯萎的黑色根须风化后的残留。墨渊断定这是一处废弃的分灵锚试验场，真正的阵眼不在这里，但石柱可能仍与主阵存在微弱联系。张羽主动提出以隐灵根感应石柱，墨渊虽担忧却未阻拦。当张羽掌心触及石柱时，他感到一股冰冷的吸力，眼前闪过无数修士在祭礼殿被抽取神魂的画面，最后定格在一个巨大的、漂浮在虚空中的梭形物体上。幻象转瞬即逝，但张羽发现自己掌心多了一道灰黑色的纹路，正缓缓渗入皮肤。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	71	{"key_events": ["发现大量天璇宗弟子干尸", "找到废弃分灵锚试验场与黑色石柱", "张羽接触石柱后看到噬界者幻象", "张羽掌心出现灰黑纹路"], "character_focus": ["张羽", "墨渊", "柳若霜"], "emotional_tone": "惊悚、悲凉、隐秘的恐惧", "narrative_goal": "通过视觉冲击揭示魂契收割的残忍真相，让张羽首次直接接触噬界者的存在，为后续反抗埋下种子，同时以掌纹异变增加个人危机。", "conflict_type": "外部恐怖环境带来的心理冲击与张羽体内隐灵根未知的异变", "estimated_words": 3400, "scenes": null}	2026-09-20 16:38:27.580465	2026-09-20 19:46:15.140223
4fdf17e7-674f-4ee1-8abe-2d3004de160f	d59e468a-8617-41e0-aabf-87a13be78834	16	玉简残音	\N	深夜，张羽、墨渊、柳若霜三人围坐在墨渊破落小院中，就着昏黄的灵灯，反复研读石铁心从废弃矿道中找到的那枚警示玉简。玉简中残留的神念已经极为微弱，断断续续地诉说着一个令人毛骨悚然的真相：所谓灵根天赋，并非天地赐予，而是某种外来的寄生之物，通过分灵碑将世界本源之力稀释后注入人体。墨渊沉默良久，终于吐露了自己被贬的真正原因——他当年还是内门精英时，曾亲眼目睹一位长老在密室中用秘法抽取一名弟子的神魂，那弟子在突破境界时突然七窍流血、魂飞魄散，而长老却将那团凝练的神魂封入一枚玉瓶。墨渊试图上报，却被反扣上"走火入魔、诬陷长老"的罪名，废去大半修为，贬至灵矿堂。三人意识到，他们手中掌握的线索已经触及了宗门最核心的禁忌，一旦暴露必死无疑。张羽提议暂时按兵不动，暗中收集更多证据，同时利用职务之便继续深挖聚灵丹与分灵碑的关联。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	20	{"key_events": ["三人研读警示玉简获知灵根寄生真相", "墨渊吐露被贬真相与亲眼所见的神魂抽取", "张羽提议暗中收集更多证据"], "character_focus": ["张羽", "墨渊", "柳若霜"], "emotional_tone": "压抑、沉重、暗流涌动", "narrative_goal": "揭示墨渊过往，将玉简线索与神魂收割阴谋正式串联，确立三人同盟的核心目标", "conflict_type": "信息揭露与生存危机", "estimated_words": 3000, "scenes": null}	2026-09-20 16:08:47.744459	2026-09-20 19:41:19.413742
51ca10b3-aa5b-4d14-908d-60f6b1021c4a	d59e468a-8617-41e0-aabf-87a13be78834	38	暗夜追踪	\N	深夜，张羽决定亲自调查收购噬魂砂的神秘人。他贴上隐息符屏蔽气息，跟踪一名形迹可疑的执事来到宗门禁地'锁龙渊'。在那里，他意外发现了一个隐蔽的地下仓库，里面整齐堆放着大量祭台阵法材料，还有三名黑袍人正在进行某种诡异的仪式，他们似乎在将黑色物质注入噬魂砂中。张羽差点被一名感知敏锐的黑袍人发现，千钧一发之际，石铁心突然现身，用矿镐制造塌方阻断追兵。两人在狭窄的矿洞中拼命奔袭，最终从一处废弃通风口脱身。这次遭遇让张羽意识到，噬界者对宗门的渗透已远超想象。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	42	{"key_events": ["张羽跟踪可疑执事发现秘密地下仓库", "目睹黑袍人进行噬魂砂注入仪式", "石铁心制造塌方助张羽脱身"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "惊险刺激中带着后怕", "narrative_goal": "展现敌人的严密部署，同时体现伙伴间的默契配合", "conflict_type": "潜行暴露与生死逃亡", "estimated_words": 3000, "scenes": null}	2026-09-20 16:14:53.432747	2026-09-20 19:41:19.413742
51e76718-7d3b-40a0-844d-b2ed0b54ed0f	d59e468a-8617-41e0-aabf-87a13be78834	27	药园深处的发现	\N	午后，柳若霜在药园的隐秘角落照料那些变异的灵植。她尝试用不同的药液浸泡灵植，观察它们的反应。当她将一种自己配制的药液滴在变异清心草的根部时，灵植突然释放出一种淡金色的气体。柳若霜惊讶地发现，这种气体能够暂时抑制黑色物质的活性，甚至让被侵蚀的灵植恢复一丝生机。她意识到这可能是对抗噬界者侵蚀的关键。然而，就在她准备进一步实验时，药园的一位老园丁出现在她身后，目光锐利地盯着她手中的灵植。柳若霜不确定对方是敌是友，只能不动声色地将灵植藏入袖中。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	31	{"key_events": ["柳若霜发现特定药液能抑制黑色物质活性", "变异灵植释放淡金色气体暂时恢复生机", "老园丁突然出现目击柳若霜的实验"], "character_focus": ["柳若霜", "墨渊"], "emotional_tone": "惊喜与紧张交织", "narrative_goal": "为对抗噬界者提供关键线索，同时引入新的不确定性", "conflict_type": "秘密暴露的风险", "estimated_words": 3000, "scenes": null}	2026-09-20 16:10:47.985217	2026-09-20 19:41:19.413742
68ea6b9c-fb35-4733-8f14-dd64148e9725	d59e468a-8617-41e0-aabf-87a13be78834	23	各怀心事	\N	柳若霜在药园中按照墨渊的指示，尝试培育一种能够感应灵气中驳杂气息的灵植。经过数次失败，她终于成功让一株'清心草'的叶片在接触到特定灵气时会呈现出奇异的灰黑色。她立刻意识到，这证明了宗门内部的灵气确实已被某种异物侵蚀。然而，就在她准备将这一发现告知墨渊时，一名执事突然来到药园，以'检查灵植状况'为由，强行带走了几株她精心培育的样本，其中包括那株变异的清心草。柳若霜只能眼睁睁看着，内心焦急却不敢表露。另一方面，苏晚棠在市集中打探消息时，偶然发现一名鬼鬼祟祟的散修正在兜售一种来历不明的'天赋丹'，声称能短暂提升天赋品级。她花钱买下丹药，准备交给墨渊分析。但她刚离开摊位，便感觉到身后有人跟踪。她利用对地形的熟悉，巧妙甩脱了跟踪者，心中却蒙上了一层阴影——宗门内部的水，比她想象的更深。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	27	{"key_events": ["柳若霜成功培育出能感应驳杂气息的变异清心草", "执事强行带走柳若霜培育的样本包括变异清心草", "苏晚棠发现兜售天赋丹的可疑散修并买下丹药", "苏晚棠察觉被跟踪并成功甩脱"], "character_focus": ["柳若霜", "苏晚棠"], "emotional_tone": "焦虑不安、危机四伏", "narrative_goal": "展示柳若霜与苏晚棠各自的调查进展与遭遇的阻碍，深化宗门内部的压抑氛围，暗示敌人已有所察觉", "conflict_type": "暗中调查与反追踪", "estimated_words": 3000, "scenes": null}	2026-09-20 16:10:18.508272	2026-09-20 19:41:19.413742
731ce35a-76b1-4dca-a22b-d4c409456a5a	d59e468a-8617-41e0-aabf-87a13be78834	46	梭中秘辛	\N	张羽在密林深处的山洞中暂时落脚，伤势稍稳后开始仔细研究从密室带出的梭形物。他发现梭形物能与自己的隐灵根产生微弱共鸣，当精神力探入其中时，竟获得了一些噬界者入侵世界的片段记忆——画面中无数梭形物如种子般落入大地，随后灵根天赋开始在原住民身上觉醒。张羽震惊地确认了分灵锚的工作原理：所谓的天赋觉醒，实则是世界本源被强行分割寄生。然而，梭形物的共鸣也暴露了他的位置，天璇宗的追兵正在逼近。张羽不得不中断研究，带着梭形物和玉简继续逃亡。在翻越一座山脊时，他发现了山脚下的村庄，但村庄寂静无声，毫无生气。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	50	{"key_events": ["梭形物与张羽隐灵根产生共鸣", "张羽获得噬界者入侵世界的片段记忆", "天璇宗追兵逼近迫使张羽继续逃亡"], "character_focus": ["张羽"], "emotional_tone": "紧张、震惊、紧迫", "narrative_goal": "深化张羽对噬界者阴谋的理解，同时推进逃亡剧情", "conflict_type": "人物与环境的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:32:43.955919	2026-09-20 19:41:19.413742
73fac0d5-cfb6-40b7-a2d8-dfcb5f7c1c9d	d59e468a-8617-41e0-aabf-87a13be78834	36	疑云暗生	\N	次日清晨，张羽秘密返回废弃丹房，将隐息符交给众人，同时分享了在藏经阁发现的卷宗内容。众人震惊于噬界者早已渗透宗门高层的事实，墨渊提议在行动前进行一次试探，找出可能的内鬼。苏晚棠利用她在外门坊市的人脉，发现最近有陌生修士在宗门附近活动，可能与噬界者有关。石铁心则发现矿洞中的黑色晶石似乎在祭礼临近时变得更加活跃，甚至开始微微脉动。众人意识到时间紧迫，必须加快行动步伐。就在众人准备出发执行计划时，柳若霜突然收到药园管事传来的消息——祭礼提前了，就在当晚！众人面面相觑，计划被打乱，他们必须在极短的时间内重新调整部署。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	40	{"key_events": ["张羽将隐息符交给众人并分享卷宗内容", "墨渊提议进行试探找出内鬼", "苏晚棠发现陌生修士在宗门附近活动", "石铁心发现黑色晶石变得更加活跃", "柳若霜收到祭礼提前到当晚的消息"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "震惊与紧迫", "narrative_goal": "通过新发现加深危机感，同时打乱原有计划制造紧迫感", "conflict_type": "内部信任危机与时间压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:13:32.324672	2026-09-20 19:41:19.413742
7aa5a0a2-341e-4fdc-adfd-d380b5a80572	d59e468a-8617-41e0-aabf-87a13be78834	45	微末之末	\N	张羽从一处枯井爬出时，已远离天璇宗山门。他躲在密林中简单处理伤势，却发现柳若霜给的通讯玉符碎裂，石铁心的生命印记微弱至极。墨渊留下暗号，告知他带着柳若霜从另一条路突围，但石铁心为断后被擒，生死未卜。张羽攥紧手中梭形物，回望登仙山方向，祭台方向的夜空被灵光照得如同白昼，隐约传来钟鸣——那是天璇宗召集弟子的信号。他明白自己已无可能继续伪装，从今日起，他不再是杂役张羽，而是一个知晓世界真相、却无力回天的逃亡者。第一卷在此落幕，张羽拖着伤体消失在群山之间，身后是吞噬了无数梦想的天璇宗，手中握着足以颠覆整个修仙界的秘密，而前方是未知的流亡与反抗之路。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	49	{"key_events": ["张羽与墨渊柳若霜失联", "石铁心为断后被擒生死不明", "张羽带着真相与物证逃离天璇宗"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "悲壮、决意、微末之人的不屈", "narrative_goal": "收束第一卷，完成主角从隐忍到被迫反抗的转折，用同伴的牺牲强化情感冲击，并为第二卷的回归埋下伏笔。", "conflict_type": "离别与新生", "estimated_words": 3000, "scenes": null}	2026-09-20 16:31:47.547649	2026-09-20 19:41:19.413742
7ab15a69-8ea9-4aae-881d-731432444fb6	d59e468a-8617-41e0-aabf-87a13be78834	20	枯荣之兆	\N	清晨，柳若霜在药园中照料灵植时，发现几株原本健康的灵草出现了诡异的枯萎现象。她仔细观察后，发现这些灵草的根系缠绕着极细的黑色丝线，与凝神丹上的黑色纹路惊人地相似。她小心翼翼地采集了样本，并暗中调查这些灵草的来源，发现它们全部来自宗门深处的一片禁地。更令她不安的是，她在调查过程中偶然听到两名弟子的对话，提到祭天大典需要大量特殊的灵植作为祭品，而这些灵植正是从那片禁地中培育出来的。柳若霜意识到，这片禁地或许藏着宗门最黑暗的秘密，而那些枯萎的灵草，正是某种邪恶仪式的前兆。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	24	{"key_events": ["柳若霜发现灵草根系缠绕黑色丝线", "追踪灵草来源指向宗门禁地", "偷听到祭天大典需要特殊灵植作为祭品"], "character_focus": ["柳若霜", "石铁心"], "emotional_tone": "不安疑惑", "narrative_goal": "", "conflict_type": "人与未知的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:09:18.094181	2026-09-20 19:41:19.413742
7c30b4ee-6350-4565-8a48-859079e25270	d59e468a-8617-41e0-aabf-87a13be78834	18	裂帛	\N	石铁心在灵矿堂中无意间听到两名高阶弟子闲聊，得知宗门即将举行一场秘密的"祭天大典"，届时所有内门精英弟子都将齐聚星辰大殿，而大典的核心环节是"天启之门"的短暂开启。石铁心将这个消息传递给张羽，三人意识到，这很可能与神魂收割的最终环节有关——那些被抽取的神魂，或许正是通过天启之门被输送给某个未知的存在。墨渊凭借当年内门精英时的记忆，推断出祭天大典的日期就在半月之后，而大典前夜，所有参与弟子都会被要求服用一枚特制的"凝神丹"。张羽决定冒险一搏：他要在祭天大典之前，弄到一枚凝神丹，让柳若霜分析其中成分，以确认它是否就是收割神魂的最后催化剂。然而，就在他制定计划的同时，灵矿堂突然接到紧急征调令，要求所有执事即刻前往深层矿脉开采一批特殊矿石，而带队者正是那位玄冥长老的弟子。张羽意识到，这或许不是巧合，而是一次针对他的调虎离山。他必须在离开前将计划和后手安排妥当，否则一旦他不在，柳若霜和墨渊将孤立无援。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	22	{"key_events": ["石铁心探得祭天大典与天启之门的情报", "墨渊推断大典日期与凝神丹的作用", "张羽决定冒险获取凝神丹", "灵矿堂突接紧急征调令疑似调虎离山"], "character_focus": ["张羽", "石铁心", "墨渊"], "emotional_tone": "紧迫、焦灼、山雨欲来", "narrative_goal": "引入祭天大典这一重大事件，将线索推向高潮前的临界点，同时制造时间压力与分离危机", "conflict_type": "时间压力与阴谋逼近", "estimated_words": 3000, "scenes": null}	2026-09-20 16:08:47.744459	2026-09-20 19:41:19.413742
88343080-56a3-4887-bbc0-874f03fd5d0f	d59e468a-8617-41e0-aabf-87a13be78834	56	暗哨截杀	\N	行动当夜，张羽按照计划潜入祭礼殿外围，却在接近盲区时遭遇了一队埋伏已久的暗哨。这些暗哨并非普通弟子，而是天衡司派来的精锐，他们显然已经察觉到了张羽的行动。张羽被迫在狭窄的甬道中以一敌多，他利用对地形的熟悉和前世所学的近身格斗技巧，配合微弱的灵气波动，艰难地击杀了数名暗哨。但战斗中，他不小心触发了警报阵法，整个祭礼殿瞬间灯火通明。张羽知道，他必须在援军赶到之前破坏分灵锚的核心阵眼，否则不仅救不了柳若霜和石铁心，自己也会陷入绝境。他强忍着战斗的伤痛，冲向祭礼殿深处。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	58	{"key_events": ["张羽在祭礼殿外围遭遇天衡司精锐暗哨埋伏", "张羽在狭窄甬道中与暗哨展开近身搏杀", "张羽触发警报阵法导致祭礼殿全面戒备"], "character_focus": ["张羽"], "emotional_tone": "惊险、紧迫、孤注一掷", "narrative_goal": "通过高强度的战斗场面展现张羽的应变能力和战斗智慧，同时制造时间紧迫感，为下一章的祭礼殿核心冲突做铺垫。", "conflict_type": "正面战斗与时间赛跑", "estimated_words": 3000, "scenes": null}	2026-09-20 16:35:08.966644	2026-09-20 19:46:15.140223
89c25522-8da5-430f-9700-beadab103e78	d59e468a-8617-41e0-aabf-87a13be78834	50	蛛丝马迹	\N	张羽逃出坍塌的矿洞后，在一处隐蔽的山涧中疗伤，同时研究从分灵锚装置中取出的核心碎片。他发现碎片上刻满了细密的符文，与梭形物上的符文如出一辙，但排列方式截然不同——梭形物上的符文是开放性的，而碎片上的符文则是封闭汲取性的。张羽尝试用精神力解读碎片上的符文，逐渐拼凑出一段被刻意抹去的历史：三百年前灵潮纪元的开端，并非天地自然异变，而是一场精心策划的入侵。当时的天璇宗初代宗主与噬界者达成了某种协议，以世界本源换取个人飞升的机会，分灵锚网络便是这场交易的产物。张羽震惊之余，意识到天璇宗高层很可能至今仍与噬界者保持联系。此时，他感应到远处有数道强大的灵气波动正在逼近，判断是天璇宗的追兵循着矿洞坍塌的动静追来，不得不放弃继续研究的打算，将碎片藏入怀中继续逃亡。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	54	{"key_events": ["张羽解读分灵锚核心碎片上的符文", "张羽拼凑出三百年前灵潮纪元是噬界者入侵的真相", "张羽发现天璇宗初代宗主与噬界者存在交易协议"], "character_focus": ["张羽"], "emotional_tone": "震惊、愤怒、警觉", "narrative_goal": "深化世界观真相的揭露，将个人命运与整个世界的历史联系起来", "conflict_type": "真相揭露与外部威胁并存", "estimated_words": 3000, "scenes": null}	2026-09-20 16:33:55.868914	2026-09-20 19:41:19.413742
8cfb359a-0067-4101-8dce-34b86fe039d3	d59e468a-8617-41e0-aabf-87a13be78834	47	荒村疑云	\N	张羽潜入荒村，发现村民已尽数消失，只余下凌乱的屋舍和残留的灵气波动。在村中央的古井旁，他发现了天衡司的令牌和一份详细记录天赋觉醒仪式的卷宗，卷宗显示这个村庄是三十年前第一批进行觉醒实验的地点之一。张羽在井壁发现了暗门，通往一个隐藏的地下室。地下室中保存着分灵锚的早期实验记录，详细记载了如何调整灵根品级分布以最大化本源收割效率。更令张羽震惊的是，他在地下室发现了一幅地图，标记着九州大陆上数十个类似村庄的位置，而其中一个地点旁有墨渊留下的暗号——一个潦草的渊字。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	51	{"key_events": ["张羽发现天衡司令牌和天赋觉醒仪式卷宗", "张羽找到地下室中的分灵锚早期实验记录", "张羽发现标记多个村庄的地图和墨渊暗号"], "character_focus": ["张羽"], "emotional_tone": "阴森、疑惑、发现真相的震撼", "narrative_goal": "发现噬界者早期实验证据，找到墨渊留下的线索", "conflict_type": "人物与社会的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:32:43.955919	2026-09-20 19:41:19.413742
98e226f5-6eed-4d48-9fab-1432a55a709d	d59e468a-8617-41e0-aabf-87a13be78834	43	灵根暴走	\N	祭台核心，张羽隐灵根失控的瞬间，灵气波动如涟漪般炸开，将最近的两名内门弟子震退。坐镇长老霍然睁眼，目光如电锁住张羽。张羽心知已无退路，索性将错就错，以精神力强行催动隐灵根模拟出一波罕见的极品天赋异象，同时借势后撤，朝石铁心发现的中空结构方向甩出一枚柳若霜给的迷烟弹。浓烟中，石铁心以矿镐砸开地面暗格，露出幽深通道。墨渊在外围发动预先布置的扰乱阵法，祭台四周灵灯接连爆裂。张羽在跃入通道前，被长老一道灵诀擦中后背，口喷鲜血，但隐灵根竟将那股侵蚀之力勉强吞噬，只是经脉如焚。他坠入黑暗前，看到柳若霜正将最后一把药粉撒向追兵，而石铁心怒吼着断后，矿镐与灵器交击声刺耳。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	47	{"key_events": ["张羽隐灵根暴走震退内门弟子", "坐镇长老出手击伤张羽", "石铁心砸开地面暗格露出通道"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "紧张、惨烈、绝境中的爆发", "narrative_goal": "完成祭台暴露后的第一场正面冲突，展现张羽在生死关头的应变与隐灵根的特殊性，同时用同伴的牺牲精神加深情感纽带。", "conflict_type": "追杀与逃亡", "estimated_words": 3000, "scenes": null}	2026-09-20 16:31:47.547649	2026-09-20 19:41:19.413742
a0e92562-c282-4644-9a70-44ca67d91a9a	d59e468a-8617-41e0-aabf-87a13be78834	37	蛛丝马迹	\N	清晨，废弃丹房内烛火将尽，张羽与墨渊彻夜分析三十年前卷宗。他们发现初代执事并非实力不足，而是因内部有人告密导致破坏阵法的计划泄露，最终功亏一篑。与此同时，苏晚棠利用她在外门坊市的人脉网络，发现最近有神秘修士在秘密收购一种名为'噬魂砂'的稀有矿石，这正是构建祭台阵法核心的关键材料。石铁心从矿洞带回更令人不安的消息：那些黑色晶石开始有规律地脉动，与宗门地下灵脉产生共振，仿佛在为即将到来的祭天大典积蓄力量。众人意识到，这场大典不仅是收割仪式，更可能是一个针对反抗者的陷阱。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	41	{"key_events": ["张羽和墨渊分析卷宗发现初代执事失败真相", "苏晚棠发现神秘人秘密收购噬魂砂", "石铁心发现黑色晶石与地下灵脉产生共振"], "character_focus": ["张羽", "墨渊", "苏晚棠", "石铁心"], "emotional_tone": "紧张焦虑中带着决绝", "narrative_goal": "揭示敌人准备充分，为后续行动增加紧迫感", "conflict_type": "信息不对称与时间压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:14:53.432747	2026-09-20 19:41:19.413742
a12aca76-7502-452c-9eb9-6c486d3daf6f	d59e468a-8617-41e0-aabf-87a13be78834	35	藏经阁夜影	\N	深夜，张羽独自一人潜行至内门藏经阁外。他利用对宗门巡逻路线的熟悉和前世对能量波动的敏锐感知，成功避开数队巡逻守卫，从一处年久失修的通风口潜入阁内。藏经阁内灵气浓郁，书架林立，张羽在密密麻麻的典籍中搜寻隐息符的存放位置。就在他即将找到目标时，意外发现了一份被封印在暗格中的卷宗。卷宗记载着三十年前初代执事们发现噬界者真相后试图反抗的记录，以及他们失败的原因——噬界者早已在宗门高层安插了眼线。张羽震惊之余，意识到他们内部可能也有叛徒。他迅速取得隐息符，但在离开时不小心触发了隐藏的警报阵法，警报声即将响起，他必须在守卫到来前逃离藏经阁。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	39	{"key_events": ["张羽成功潜入内门藏经阁", "张羽发现记载三十年前初代执事反抗记录的卷宗", "张羽发现噬界者早已在宗门高层安插眼线", "张羽取得隐息符但触发隐藏警报阵法"], "character_focus": ["张羽"], "emotional_tone": "紧张悬疑", "narrative_goal": "通过张羽的独自行动展现其能力，同时揭露更深层的阴谋", "conflict_type": "潜入行动与意外发现", "estimated_words": 3000, "scenes": null}	2026-09-20 16:13:32.324672	2026-09-20 19:41:19.413742
b738e36f-7584-4f18-9a57-7a2b171ea412	d59e468a-8617-41e0-aabf-87a13be78834	42	阵眼觉醒	\N	祭天大典正式开始，长老们登上祭台，灵气如潮水般涌向核心节点。张羽等人按计划分头行动，他负责接近核心节点，石铁心负责破坏地下结构，柳若霜负责解救可能的活物祭品，墨渊在外围策应。然而，当张羽将药液滴在第一根黑色石柱上时，药液的效果远不如预期，黑色物质只是短暂沉寂便重新活跃。更糟糕的是，张羽的隐灵根在接触黑色石柱的瞬间失控，灵气波动暴露了他的位置。内门长老猛然转头，目光如电射向张羽藏身之处。千钧一发之际，柳若霜引爆了事先布置的烟雾符，暂时遮蔽了视线，但张羽知道，他们已经彻底暴露了。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	46	{"key_events": ["药液对黑色石柱效果远不如预期", "张羽隐灵根失控暴露位置", "内门长老发现张羽踪迹", "柳若霜引爆烟雾符掩护"], "character_focus": ["张羽", "柳若霜", "内门长老"], "emotional_tone": "紧张、绝望、背水一战", "narrative_goal": "行动彻底暴露，计划失败，将剧情推向高潮危机", "conflict_type": "正面冲突与生存危机", "estimated_words": 3000, "scenes": null}	2026-09-20 16:15:59.856503	2026-09-20 19:41:19.413742
c7a5ce0a-1364-4711-85c3-9a9548199405	d59e468a-8617-41e0-aabf-87a13be78834	33	绝境同盟	\N	当夜，张羽秘密召集石铁心、墨渊、苏晚棠到杂役坊一处废弃丹房。众人拼凑各自发现，终于还原出完整真相：祭礼将在三日后举行，届时所有被抽调的弟子将被献祭，他们的神魂将被用于开启'天启之门'，让噬界者势力正式降临。张羽提出一个冒险计划：利用自己'隐灵根'未被寄生的特性，潜入祭台核心破坏阵法。然而，这个计划需要所有人精密配合，且风险极高。就在众人商议细节时，门外突然传来了脚步声，所有人的心都提到了嗓子眼。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	37	{"key_events": ["张羽秘密召集核心成员到废弃丹房", "众人拼凑出祭礼献祭弟子的完整真相", "张羽提出利用隐灵根破坏祭台阵法的冒险计划", "门外传来脚步声众人陷入危机"], "character_focus": ["张羽", "石铁心", "墨渊", "苏晚棠"], "emotional_tone": "紧张、团结、危机感", "narrative_goal": "集结主角团，明确最终行动计划，为卷末高潮做铺垫", "conflict_type": "外部威胁、团队信任考验", "estimated_words": 3000, "scenes": null}	2026-09-20 16:12:04.621278	2026-09-20 19:41:19.413742
ca809b1b-81d7-4e16-962d-c814a3164fc8	d59e468a-8617-41e0-aabf-87a13be78834	69	潜入葬剑谷的计划	\N	四人围绕玉简内容展开激烈讨论。张羽提出利用自己隐灵根的特殊性，伪装成被收割的修士混入葬剑谷，从内部破坏分灵锚阵眼。墨渊强烈反对，认为此举无异于羊入虎口，但石铁心却支持张羽，愿意在外围接应。就在双方僵持不下时，天衡司的搜查队逼近矿洞，四人必须立即转移。而转移的方向，正是他们既渴望又恐惧的葬剑谷。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	69	{"key_events": ["张羽提出伪装潜入葬剑谷的计划", "墨渊反对但石铁心支持", "天衡司搜查队逼近矿洞"], "character_focus": ["张羽", "墨渊", "石铁心"], "emotional_tone": "紧张激烈，矛盾与决心交织", "narrative_goal": "确立下一步行动方向，制造紧迫感，为下一卷进入葬剑谷做铺垫", "conflict_type": "内部意见分歧与外部威胁双重压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:37:24.226522	2026-09-20 19:46:15.140223
d2a83ff4-610b-4ee7-8185-0113dfcfcd5e	d59e468a-8617-41e0-aabf-87a13be78834	29	药园夜话	\N	次日傍晚，张羽借送灵肥的名义进入药园，将柳若霜被抽调的消息告知她。柳若霜正在照料那些变异的清心草，闻言手中动作一顿，但很快恢复平静。她告诉张羽，自己其实早有预感，因为最近药园管事频繁索要她培育的变异灵植，用途不明。两人商议对策，柳若霜提出可以利用自己能培育感应驳杂气息灵植的能力，尝试反向追踪黑色物质的源头。她展示了一株新培育的灵植，其根系能主动朝驳杂灵气最浓郁的方向生长。张羽意识到这或许能指向噬界者侵蚀的核心节点。就在此时，那位曾目击柳若霜实验的老园丁悄然出现，两人警觉之下，老园丁却递上一块刻有古老符文的木牌，低声道：若想活命，子时到废矿洞口。说完便佝偻着身影消失在暮色中。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	33	{"key_events": ["张羽告知柳若霜她被列入祭礼抽调名单", "柳若霜展示能追踪驳杂灵气源头的新变异灵植", "老园丁突然现身留下神秘木牌与子时之约"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "表面平静下的暗涌与意外转折", "narrative_goal": "深化柳若霜的能力价值，引入老园丁这一变数，为后续废矿洞探索铺垫", "conflict_type": "信息不对称下的信任试探", "estimated_words": 3000, "scenes": null}	2026-09-20 16:11:37.953307	2026-09-20 19:41:19.413742
d3a6d59a-15ec-4b2d-a4f6-40b00d9de214	d59e468a-8617-41e0-aabf-87a13be78834	44	地腑遗秘	\N	通道并非天然，而是人工开凿的废弃灵脉支管，壁上刻满与祭台符文同源的暗记。张羽压制伤势，在黑暗中摸索前行，发现通道尽头竟是一间密室。密室中央悬浮着一枚拳头大小、非金非玉的梭形物，表面流转着与黑色物质相似却更加纯粹的光芒。四周石台上散落着数十枚玉简，记载着一种名为"分灵锚"的秘术，详述如何将世界本源转化为灵根寄生体，并附有天元界第三十七纪前的星图，标注着多处已被噬界者收割殆尽的残破世界。张羽瞬间明白，所谓灵潮纪元不过是入侵的前奏，而天璇宗乃至整个修仙界都建在收割阵法之上。他匆忙拓印玉简内容，却触发了密室最后的防御机制，梭形物开始高频震颤，引动整个地下结构坍塌。张羽抓起梭形物和几枚关键玉简，在通道彻底崩塌前拼命爬向出口，途中被落石砸伤左腿。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	48	{"key_events": ["张羽发现记载分灵锚秘术的玉简", "张羽获得噬界者遗留的梭形物", "密室坍塌张羽重伤逃出"], "character_focus": ["张羽"], "emotional_tone": "震惊、悲怆、真相的沉重", "narrative_goal": "揭示世界本源被收割的核心真相，让张羽获得关键物证，同时用密室坍塌制造紧迫感，为下一章的分离做铺垫。", "conflict_type": "探索与逃生", "estimated_words": 3000, "scenes": null}	2026-09-20 16:31:47.547649	2026-09-20 19:41:19.413742
f1529441-c263-4ea5-916d-c15199ae42ff	d59e468a-8617-41e0-aabf-87a13be78834	49	锚点之秘	\N	张羽在废弃矿洞深处面对正在运转的小型分灵锚装置，回忆起墨渊留下的线索，决定冒险尝试用梭形物与之建立联系。他将精神力同时探入梭形物和分灵锚装置，瞬间被拉入一个奇异的意识空间，目睹了分灵锚网络的运作原理——无数细如发丝的灵识丝线从装置延伸出去，连接着方圆百里内所有觉醒灵根的修士，随着他们的修炼而缓慢抽取世界本源。张羽震惊地发现，这些丝线不仅抽取本源，还在潜移默化中影响着修士的神智，让他们对天赋体系产生狂热的依赖与崇拜。他在意识空间中尝试用梭形物干扰丝线，却意外触发了分灵锚的防御机制，一道反噬之力将他震出意识空间，口吐鲜血。分灵锚装置发出刺耳的警报声，张羽强忍伤势，在装置完全激活自毁程序前将其核心取出，随后矿洞开始坍塌，他拼尽全力逃出生天。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	53	{"key_events": ["张羽用梭形物连接分灵锚装置进入意识空间", "张羽目睹分灵锚网络抽取世界本源并影响修士神智的真相", "张羽触发分灵锚防御机制遭反噬，矿洞坍塌前取出装置核心"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "震撼、紧迫、危机", "narrative_goal": "揭示分灵锚网络的真实运作方式，为张羽提供关键情报，同时加剧紧迫感", "conflict_type": "人与未知力量的对抗", "estimated_words": 3000, "scenes": null}	2026-09-20 16:33:55.868914	2026-09-20 19:41:19.413742
1c2f14e0-5007-4ea1-9db2-b58631a56da0	d59e468a-8617-41e0-aabf-87a13be78834	64	玉简中的秘密	\N	柳若霜在续魂草的作用下终于苏醒，但身体依然虚弱，需要长期调养。苏晚棠为石铁心检查毒素，发现需要几味罕见药材才能配制解药。墨渊彻夜研究玉简，从中解读出分灵锚的运作机制——它不仅能抽取世界本源，还能通过灵根与修士建立魂契，在修士突破时收割神魂之力。更令人震惊的是，玉简暗示葬剑谷曾是上古时期对抗噬界者的战场，地下可能埋藏着废弃的分灵锚试验场。苏晚棠在整理通缉令时，再次看到酷似其兄的执事画像，内心陷入矛盾与挣扎。张羽尝试与逆灵梭建立更深层的联系，发现它能微弱地干扰周围的灵气流动。四人意识到矿洞已不再安全，开始讨论转移方向，而葬剑谷成为唯一的选择。远处，天衡司搜山的号角声隐约传来。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	66	{"key_events": ["柳若霜苏醒但身体虚弱", "苏晚棠发现石铁心需要罕见解药", "墨渊解读玉简揭示分灵锚魂契收割机制", "苏晚棠陷入对兄长的矛盾情绪", "张羽与逆灵梭建立更深联系", "四人讨论转移方向"], "character_focus": ["柳若霜", "苏晚棠", "墨渊", "张羽"], "emotional_tone": "紧张中带着一丝希望，但暗流涌动", "narrative_goal": "稳定团队状态，揭示分灵锚的深层秘密，为潜入葬剑谷做铺垫", "conflict_type": "内部矛盾与外部威胁并存", "estimated_words": 3000, "scenes": null}	2026-09-20 16:36:53.818201	2026-09-20 19:44:30.740915
32495250-965e-4cf0-8370-4caf65e80928	d59e468a-8617-41e0-aabf-87a13be78834	83	集训惊变	\N	张羽被通知参加一场由内门执事主持的"预备弟子集训"，实为考察与筛选。集训中，数名天赋出众的弟子对他这个从杂役破格提拔的"隐灵根"充满敌意，多次在比试中暗中下重手。张羽以精准的预判和地形利用巧妙化解，既不过分显露实力，也不至于受伤。集训中途，一名表现优异的弟子突然昏厥，被抬走时张羽瞥见其神魂波动微弱如游丝，与之前观察到的恍惚弟子如出一辙。他借口如厕悄然跟踪，却发现抬人者消失在一处设有禁制的院落。当夜，一个邋遢老仆模样的身影出现在张羽窗前，留下半片写满符文的树叶后消失——那正是墨渊的笔迹。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	81	{"key_events": ["张羽参加预备弟子集训，遭遇敌意针对", "弟子突然昏厥，神魂微弱疑似被收割", "墨渊以老仆形象秘密现身传递符文警告"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张、危机四伏、短暂希望", "narrative_goal": "通过集训冲突展示内门弟子间的倾轧，借昏厥事件直接点出魂契收割的恐怖，并以墨渊的回归重新建立情报线，推动张羽主动出击。", "conflict_type": "人际冲突（敌意弟子）与情报冲突（昏厥真相）", "estimated_words": 3000, "scenes": null}	2026-09-20 16:42:01.244112	2026-09-20 19:48:51.523923
f0bf6a25-364a-4d17-903a-cc3d8f08857a	d59e468a-8617-41e0-aabf-87a13be78834	13	药香暗影	\N	柳若霜在药园中照料灵草时，发现更多植株被黑色雾气侵蚀。她小心翼翼地保存了样本，并尝试分析这种侵蚀的来源。与此同时，张羽在灵矿堂中重复着单调的分拣工作，但他暗中记录着每一批聚灵丹的流向。墨渊依旧整日醉酒，却在一次深夜交谈中，无意中透露了宗门长老会的一些秘辛，暗示高层对天赋真相并非一无所知。三人在墨渊的小院中交换信息，气氛沉重。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	13	{"key_events": ["柳若霜保存灵草侵蚀样本", "张羽记录聚灵丹流向", "墨渊透露长老会秘辛"], "character_focus": ["柳若霜", "墨渊"], "emotional_tone": "压抑、沉重，暗流涌动", "narrative_goal": "深化三人同盟，收集更多证据，展现日常中的异常", "conflict_type": "内心冲突（隐藏秘密、怀疑宗门）", "estimated_words": 3000, "scenes": null}	2026-09-20 16:07:29.656265	2026-09-20 19:39:43.772064
44a28543-a3b5-4724-851e-ad1c6bc3fc5c	d59e468a-8617-41e0-aabf-87a13be78834	87	祭礼前夕	\N	张羽得知祭礼消息后，连夜与石铁心、柳若霜在坊市秘密据点汇合。三人与墨渊共同分析祭礼的可疑之处：所有内门弟子必须佩戴特制的灵玉令牌，而令牌中蕴含的灵气波动与灰黑纹路如出一辙。柳若霜凭借对草药的敏锐，发现近期宗门发放的养神丹中多了一味罕见的辅料，长期服用会导致神魂与灵根产生不可逆的绑定。石铁心则提供了矿洞底层新发现的线索——一批被秘密运送的黑色矿石，矿石表面的纹路与张羽掌心灰黑纹路高度相似。张羽意识到，祭礼不仅是一次收割，更可能是噬界者对整个天璇宗弟子的全面控制。他决定在祭礼前夜冒险潜入祭礼殿外围，试图找到分灵锚的核心节点。然而，当他准备行动时，静修阁外突然传来密集的脚步声，一名内门长老带着执法弟子出现在门前，以调查外门弟子失踪案为由，要求张羽配合问询。张羽面色平静，心中却已做好了最坏的打算。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	85	{"key_events": ["张羽与同伴分析祭礼阴谋", "柳若霜发现养神丹异常辅料", "张羽被内门长老传唤问询"], "character_focus": ["张羽", "柳若霜", "石铁心"], "emotional_tone": "决绝与危机感", "narrative_goal": "将个人生存危机与宗门整体命运挂钩，为祭礼高潮做铺垫", "conflict_type": "个人行动与外部干预的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:42:58.428069	2026-09-20 19:48:51.523923
2cf52949-1f1a-4628-aba6-2bf555a1a53d	d59e468a-8617-41e0-aabf-87a13be78834	63	通缉令上的故人	\N	众人退回废弃矿洞，用续魂草稳住柳若霜的伤势。石铁心的毒素被苏晚棠暂时压制，但需特定解药。张羽将药园地底所见告知墨渊，墨渊结合古籍推测天璇宗山门可能建在一座巨型分灵锚阵群之上，而阵眼应在灵气最浓郁的葬剑谷。此时，天衡司的通缉令传遍全宗，墨渊被列为叛逆，张羽、苏晚棠、柳若霜的画像亦在其中。苏晚棠瞥见通缉令末尾一名天衡司高阶执事的画像，瞳孔骤缩——那人与她失散多年的兄长有七分相似。她强压情绪未言，但张羽已察觉异样。逆灵梭在此时微微震颤，指向葬剑谷方向，仿佛在呼应某种召唤。团队面临抉择：是暂避锋芒，还是直捣阵眼。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	65	{"scenes": null, "key_events": ["张羽揭示药园地底分灵锚供养网络", "墨渊推测阵眼在葬剑谷", "苏晚棠发现通缉令上的执事酷似其兄", "逆灵梭产生指向葬剑谷的共鸣"], "conflict_type": "外部通缉压力与内部信任裂痕的隐忧", "emotional_tone": "疑云密布，个人秘密与集体危机交织", "narrative_goal": "", "character_focus": ["张羽", "苏晚棠", "墨渊"], "estimated_words": 3000}	2026-09-20 16:35:54.84572	2026-09-20 19:44:30.672957
55d54bac-0c65-4202-a3cb-d217976a88b9	d59e468a-8617-41e0-aabf-87a13be78834	85	暗流之约	\N	张羽在静修阁中反复推演方陵邀请背后的风险与机遇，同时察觉窗外监视者的气息波动。他利用前世记忆中的反侦察技巧，借采药之名摆脱跟踪，独自前往约定地点——外门坊市边缘一间废弃的炼器铺。方陵已在此等候，并带来了两名同样对宗门高层心存疑虑的内门弟子。四人交换情报，方陵透露自己暗中调查兄长失踪真相时发现了魂契收割的蛛丝马迹，另一名弟子则提供了天璇宗与天衡司秘密往来的账目残页。张羽谨慎地分享了自己对灵气驳杂与神魂透支的观察，却隐去了灰黑纹路与自身无天赋的核心秘密。聚会尾声，炼器铺外突然传来细微的灵气波动，似有高阶修士在附近巡视，众人立即熄灭火光，屏息凝神。张羽在黑暗中感知到那股气息中带着一丝熟悉的腐朽味道，与他在矿洞深处闻到的极为相似。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	83	{"key_events": ["张羽运用反侦察技巧摆脱监视", "方陵召集秘密聚会分享魂契线索", "张羽感知到外部巡视气息中的腐朽味道"], "character_focus": ["张羽", "方陵"], "emotional_tone": "紧张而克制", "narrative_goal": "建立初步情报网络，同时保持张羽的谨慎人设", "conflict_type": "外部监视与内部猜忌的双重压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:42:58.428069	2026-09-20 19:48:51.523923
5edfdf30-d27b-458a-935b-9708d636a2c1	d59e468a-8617-41e0-aabf-87a13be78834	62	药园惊魂	\N	子夜，四人借助隐身符与迷烟潜入药园。园内灵气浓郁到近乎液态，张羽的隐灵根在逆灵梭压制下仍隐隐躁动。苏晚棠精准定位续魂草位置，张羽负责采摘。当张羽指尖触及一株千年灵植时，隐灵根突然与地下某物产生共鸣，他的意识瞬间坠入地底——他"看"到无数黑色根须从药园下方蔓延，连接着每一株灵植，正缓缓抽取着灵植本源，汇聚向山脉深处。他惊醒后意识到，整个药园竟是分灵锚的供养农场。此时，采摘触动了禁制，守卫合围。石铁心挥动矿镐断后，墨渊以暗器制造混乱，张羽等人带着续魂草惊险逃离，但石铁心被一道剑气划伤，毒素入体。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	64	{"scenes": null, "key_events": ["张羽触灵植窥见地下分灵锚根须网络", "团队触发禁制遭遇守卫围剿", "石铁心为断后受伤中毒"], "conflict_type": "外部守卫围剿与地底真相的内心冲击", "emotional_tone": "惊险、悲壮，地底景象带来沉重冲击", "narrative_goal": "", "character_focus": ["张羽", "石铁心", "墨渊"], "estimated_words": 3000}	2026-09-20 16:35:54.84572	2026-09-20 19:44:30.672957
3a5277f4-a468-426a-8d29-1bd613b6e201	d59e468a-8617-41e0-aabf-87a13be78834	51	暗棋初动	\N	张羽在山间逃亡途中，偶然发现了一处天璇宗的秘密据点——一座伪装成普通山神庙的地下哨站。他潜入其中，发现这里正在秘密转运一批被标记为废弃法器的物资，但从灵气波动判断，这些法器内部封存着大量被抽取的修士神魂。张羽在哨站中发现了一份近期的人员调令，上面赫然列着柳若霜和石铁心的名字，显示他们已被秘密转移至天璇宗总坛的祭礼殿，即将作为祭品用于下一次大规模的分灵锚充能仪式。张羽心如刀绞，意识到时间已经不多。他冒险复制了调令和哨站的布防图，却在撤离时被一名隐藏的暗哨发现，双方爆发短暂而激烈的战斗。张羽以近乎自损的方式击杀暗哨，自己也身负重伤，被迫遁入更深的山林。他躲在一处崖洞中，望着怀中柳若霜和石铁心的名字，做出了一个艰难的决定——不再独自逃亡，而是主动出击，潜入天璇宗总坛救人。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	55	{"key_events": ["张羽发现天璇宗秘密哨站转运封存修士神魂的法器", "张羽获知柳若霜和石铁心被转移至祭礼殿即将成为祭品", "张羽击杀暗哨后决定主动出击潜入天璇宗总坛"], "character_focus": ["张羽", "柳若霜", "石铁心"], "emotional_tone": "悲愤、决绝、孤注一掷", "narrative_goal": "将个人求生转变为有目的的行动，为下一阶段的潜入救援做铺垫", "conflict_type": "道德抉择与行动转折", "estimated_words": 3000, "scenes": null}	2026-09-20 16:33:55.868914	2026-09-20 19:41:19.413742
6fd8995f-dc4e-418b-8180-5489b9cad9ae	d59e468a-8617-41e0-aabf-87a13be78834	57	核心阵眼	\N	张羽冲入祭礼殿核心区域，眼前的景象让他震惊：十二根黑色石柱环绕着一座巨大的祭坛，祭坛中央悬浮着一颗散发着幽暗光芒的球体，那正是分灵锚的主节点。球体周围，柳若霜和石铁心被束缚在石柱上，他们的生命力正被缓慢抽取。张羽试图用梭形物破坏主节点，但梭形球体却毫无反应。他意识到，必须有人从内部破坏阵眼，而这个人必须拥有与分灵锚同源的力量。张羽做出了一个疯狂的决定：他主动走向祭坛，让分灵锚主节点抽取自己的生命力，同时利用自己隐灵根与黑色物质的共鸣，从内部瓦解阵眼。在意识模糊的边缘，他仿佛听到了一个来自远古的低语，那声音似乎在引导他，又似乎在警告他。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	59	{"key_events": ["张羽目睹祭礼殿核心区域的恐怖景象", "张羽发现梭形物对分灵锚主节点无效", "张羽主动走向祭坛以自身为诱饵破坏阵眼"], "character_focus": ["张羽", "柳若霜", "石铁心"], "emotional_tone": "悲壮、决绝、神秘", "narrative_goal": "将剧情推向高潮，展现张羽为救同伴不惜牺牲自我的精神，同时引入远古低语的神秘元素，为后续揭示噬界者真相埋下伏笔。", "conflict_type": "自我牺牲与神秘力量觉醒", "estimated_words": 3000, "scenes": null}	2026-09-20 16:35:08.966644	2026-09-20 19:44:30.672957
134ef319-5e6d-443c-9cce-3bed835e022e	d59e468a-8617-41e0-aabf-87a13be78834	72	暗处的眼睛	\N	张羽掌心的灰黑纹路让柳若霜极为不安，她以草药敷贴试图阻止纹路蔓延，但毫无效果。墨渊推测这是分灵锚对"无灵根者"的某种标记，意味着张羽可能已被主阵感知。石铁心强撑身体，提议尽快离开此地，但张羽却陷入沉思：幻象中那个梭形物体与他在天璇宗地下所见的分灵锚装置极为相似，而噬界者抽取本源的方式，竟与天赋觉醒时灵气灌体的过程暗合。他意识到，所谓天赋觉醒，或许正是分灵锚寄生灵根的关键步骤。这一推断让所有人脊背发凉。就在他们准备撤离时，苏晚棠突然低喝一声，她察觉到暗处有视线在观察他们。众人警戒，却一无所获。张羽以隐灵根扩散感知，隐约捕捉到一丝极其微弱、不属于任何修士的能量波动，仿佛某种没有生命的造物在移动。墨渊想起古籍中记载的"噬界傀儡"——一种被噬界者用来监视和清除威胁的无生命追踪装置。四人立即决定分散撤离，约定在谷外一处隐蔽的岩穴汇合。分开前，柳若霜将最后一枚护身玉符塞给张羽，石铁心则重重拍了一下他的肩膀。张羽独自穿行在枯死的林木间，掌心的纹路隐隐发热，他感到有什么东西正在暗处尾随。当他回头时，只看到一截枯枝无风自动，以及地上几片不属于他们任何人的灰色碎屑。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	72	{"key_events": ["柳若霜发现张羽掌心灰黑纹路无法消除", "张羽推断天赋觉醒与分灵锚寄生的关联", "苏晚棠察觉被监视，众人发现噬界傀儡的痕迹", "四人分散撤离，张羽被不明尾随"], "character_focus": ["张羽", "苏晚棠", "柳若霜", "石铁心"], "emotional_tone": "惊疑、紧迫、孤立无援", "narrative_goal": "将个人危机与宏观真相连接，强化张羽作为\\"异数\\"的处境，通过噬界傀儡的引入提升外部威胁等级，为下一阶段分散行动后的遭遇做铺垫。", "conflict_type": "", "estimated_words": 3300, "scenes": null}	2026-09-20 16:38:27.580465	2026-09-20 19:46:15.140223
8ec646dc-6156-47f9-a9de-7f63a87a45d3	d59e468a-8617-41e0-aabf-87a13be78834	59	绝境反击	\N	墨渊和苏晚棠按照计划在外围等候，听到祭礼殿警报大作，两人意识到张羽的行动出了变故。苏晚棠不顾墨渊阻拦，凭借对药理的了解，利用随身携带的迷烟弹强行冲入混乱的祭礼殿，在坍塌的甬道中找到了半昏迷的张羽。墨渊则在外围利用地形和暗器牵制赶来的天衡司执事，为苏晚棠救人争取时间。苏晚棠发现张羽体内灵气暴走，经脉受损严重，她利用随身携带的银针封住张羽几处大穴，并给他服下保命丹药。在拖拽张羽撤离的过程中，苏晚棠意外发现张羽手中的梭形物在吸收逸散的分灵锚能量，且光芒越来越盛。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	61	{"key_events": ["苏晚棠不顾危险冲入祭礼殿找到张羽", "墨渊在外围牵制天衡司执事争取撤离时间", "苏晚棠发现梭形物在自动吸收分灵锚逸散能量"], "character_focus": ["苏晚棠", "墨渊"], "emotional_tone": "紧张、焦急", "narrative_goal": "展现同伴间的生死羁绊，同时揭示梭形物对噬界者能量具有天然的克制与吸收能力", "conflict_type": "人vs人", "estimated_words": 3000, "scenes": null}	2026-09-20 16:35:34.24372	2026-09-20 19:44:30.672957
a432919e-b637-4396-81ae-fed9cdb9c2fd	d59e468a-8617-41e0-aabf-87a13be78834	60	破晓微光	\N	墨渊和苏晚棠带着昏迷的张羽艰难撤离祭礼殿，退入后山的隐秘洞穴。石铁心在束缚解除后恢复神智，虽虚弱但凭借强横的体魄跟上了三人。柳若霜因被抽取生命力较多，依旧昏迷不醒。在洞穴中，苏晚棠为众人疗伤，墨渊则分析当前局势，指出天衡司很快就会封锁整个后山。张羽在昏迷中，意识却进入了一个奇异的空间，他看到了分灵锚主节点内部残留的影像：无数修士的神魂被压缩成光点，沿着一条看不见的通道被输送到虚空深处。他隐约看到通道尽头有一个巨大的、难以名状的存在正在沉睡，而天璇宗脚下的灵脉，不过是这个存在的吸管。张羽猛然惊醒，他意识到噬界者的入侵远比想象中更加深入，天璇宗高层或许早已知情。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	62	{"key_events": ["墨渊苏晚棠带张羽退入后山隐秘洞穴", "张羽昏迷中看到分灵锚输送神魂的虚空影像", "张羽意识到天璇宗高层可能早已与噬界者有勾连"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "压抑、震惊", "narrative_goal": "揭示噬界者入侵的冰山一角，为后续张羽暗中结盟反抗埋下伏笔，同时提升整体剧情的悬疑感", "conflict_type": "人vs未知真相", "estimated_words": 3000, "scenes": null}	2026-09-20 16:35:34.24372	2026-09-20 19:44:30.672957
217fd24c-098e-441c-adcb-09653e99459f	d59e468a-8617-41e0-aabf-87a13be78834	34	暗度陈仓	\N	废弃丹房内，烛火摇曳，众人围坐。张羽提出破坏祭台阵法的计划后，墨渊立即展开祭台阵法的结构分析，指出阵法核心位于祭台正下方，需以特殊手法切断七处灵脉节点。苏晚棠负责在外门坊市制造混乱，分散守卫注意力；石铁心负责在祭台外围接应，准备应对突发状况；柳若霜则利用她培育的变异清心草提炼药液，用于抑制黑色物质活性。然而，计划的关键在于张羽需要一件能暂时屏蔽噬界者感知的隐息符，而这种符箓只有内门藏经阁才有收藏。时间紧迫，祭礼就在三日后，张羽决定冒险潜入内门藏经阁获取隐息符。众人虽担忧他的安全，但别无他法，只能各自分头准备。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	38	{"key_events": ["众人开始制定详细计划并分配各自任务", "墨渊分析祭台阵法结构指出七处灵脉节点", "计划需要隐息符才能屏蔽噬界者感知", "张羽决定冒险潜入内门藏经阁获取隐息符"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张而坚定", "narrative_goal": "展现团队协作制定计划的过程，同时引出新的行动目标", "conflict_type": "计划制定与资源获取的困难", "estimated_words": 3000, "scenes": null}	2026-09-20 16:13:32.324672	2026-09-20 19:41:19.413742
c05efe0b-dac1-4e6b-8661-3f3c0c048212	d59e468a-8617-41e0-aabf-87a13be78834	58	命悬一线	\N	张羽主动走向祭坛，分灵锚主节点感应到他体内隐灵根的特殊共鸣，瞬间爆发出强大的吸力。张羽感觉自己的神魂仿佛被一只无形巨手撕扯，剧痛之下，他咬破舌尖保持清醒。他意识到这并非单纯的破坏阵法，而是分灵锚在试图将他体内的伪灵根彻底激活并收割。在意识即将被吞噬的刹那，他利用梭形物作为媒介，将自身意志强行灌入主节点，以自毁的方式在阵法核心制造了一道逻辑裂痕。主节点剧烈震颤，抽取柳若霜和石铁心的力量出现短暂中断，束缚他们的石柱出现裂纹，但张羽也因此遭到反噬，七窍流血，陷入半昏迷状态，倒在祭坛边缘。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	60	{"key_events": ["张羽主动走向分灵锚主节点引发强烈共鸣", "张羽遭分灵锚神魂撕扯以自毁方式制造阵法裂痕", "张羽遭反噬七窍流血陷入半昏迷"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "惨烈、决绝", "narrative_goal": "展现张羽为救同伴不惜自毁的牺牲精神，同时揭示分灵锚收割机制的恐怖", "conflict_type": "人vs超自然机制", "estimated_words": 3000, "scenes": null}	2026-09-20 16:35:34.24372	2026-09-20 19:44:30.672957
c9fdc4e6-ac32-4fca-8044-aa7d21506db5	d59e468a-8617-41e0-aabf-87a13be78834	61	逆灵之梭	\N	张羽在后山洞穴中苏醒，经脉如焚，但神识却因梭形物的浸润而异常清明。他发现自己与梭形物之间多了一丝微弱的联系，梭形物表面浮现出细密符文，与分灵锚的纹路相似却走向相反。墨渊辨认后震惊地发现，这可能是传说中的"逆灵梭"，一种能够干扰甚至逆转分灵锚抽取效果的太古遗物。然而，柳若霜的生命力持续流逝，普通丹药无效，必须找到"续魂草"方能续命。续魂草只生长在宗门核心药园，那里守卫森严，且近日因祭礼殿事件戒备倍增。苏晚棠提出可利用自己对药理的了解配制迷烟，配合墨渊的隐身符强行突入。石铁心虽虚弱，却坚持同行。众人决定冒险一搏。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	63	{"scenes": null, "key_events": ["张羽苏醒并发现梭形物显现逆灵符文", "墨渊辨认出逆灵梭的来历与功效", "柳若霜伤势恶化急需续魂草", "团队决定潜入宗门药园"], "conflict_type": "时间压力与伤势危机", "emotional_tone": "紧张中带着一丝希望，同伴间信任加深", "narrative_goal": "", "character_focus": ["张羽", "墨渊", "苏晚棠"], "estimated_words": 3000}	2026-09-20 16:35:54.84572	2026-09-20 19:44:30.672957
374ad5a5-af1c-41f5-a8ae-a3bbc25ee649	d59e468a-8617-41e0-aabf-87a13be78834	4	裂纹	\N	深夜，张羽在杂役坊废弃矿洞中独自修炼，以精神力强行牵引灵气灌体。然而，长期的自虐式修炼终于显现恶果——他的经脉出现细微裂纹，灵气运转时如刀割般剧痛。石铁心发现张羽的异常，没有多问，只是默默递上一本祖传的锻体残卷，那是他矿洞生涯中用命换来的宝贝。两人之间的关系从生死之交更进一步，成为可以托付秘密的挚友。与此同时，杂役坊管事为了讨好内门弟子，克扣底层杂役的灵石配额，引发众怒。张羽冷眼旁观，深知在实力不足时贸然出头只是送死，但他暗中记下了管事的一举一动，等待时机。经脉的裂纹让他意识到，仅靠精神力伪装灵根已走到极限，必须找到新的方法。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	4	{"key_events": ["深夜废弃矿洞修炼发现经脉裂纹", "石铁心分享祖传锻体残卷", "杂役坊管事克扣灵石引发不满"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "压抑中的温情", "narrative_goal": "展现张羽修炼的隐患，深化与石铁心的关系，铺垫杂役坊内部矛盾", "conflict_type": "内部冲突与外部冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:05:38.33071	2026-09-20 16:49:28.971267
3b881b32-825d-44ab-be24-72631a06cc08	d59e468a-8617-41e0-aabf-87a13be78834	65	分歧与决断		四人围绕玉简内容展开激烈讨论。张羽提出一个大胆的计划：利用自己隐灵根的特殊性，伪装成被分灵锚收割的修士混入葬剑谷，从内部破坏阵眼。墨渊强烈反对，认为分灵锚阵眼周围必然有重兵把守，且张羽的隐灵根在阵眼附近可能失控，无异于羊入虎口。石铁心却支持张羽，表示愿意在外围接应，并说'要么等死，要么拼一把'。苏晚棠犹豫不决，既担心计划失败连累大家，又牵挂可能被困在葬剑谷深处的兄长。讨论中，墨渊进一步揭示分灵锚对修士的影响——长期被收割会导致神魂枯竭，最终沦为行尸走肉。就在双方僵持不下时，矿洞外传来天衡司搜查队的脚步声和犬吠声，四人必须立即做出决断。张羽深吸一口气，决定执行计划，四人开始紧急准备转移。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	67	{"key_events": ["张羽提出伪装潜入葬剑谷计划", "墨渊强烈反对认为太危险", "石铁心支持张羽愿意外围接应", "苏晚棠犹豫不决牵挂兄长", "墨渊揭示分灵锚导致神魂枯竭", "天衡司搜查队逼近矿洞"], "character_focus": ["张羽", "墨渊", "石铁心", "苏晚棠"], "emotional_tone": "紧张激烈，充满分歧与决断", "narrative_goal": "展现团队内部冲突，推动情节进入葬剑谷阶段", "conflict_type": "内部理念冲突与外部紧迫威胁", "estimated_words": 3000, "scenes": null}	2026-09-20 19:44:30.740915	2026-09-20 19:44:30.740915
3ac3bb72-329c-4f3b-a87f-ddd6ed767d5c	d59e468a-8617-41e0-aabf-87a13be78834	39	祭前暗涌	\N	祭天大典前夜，废弃丹房内气氛凝重。柳若霜成功提炼出能抑制黑色物质活性的药液，但数量仅够三次使用，众人必须精准把握时机。墨渊根据张羽带回的情报重新调整了破坏阵法的策略，决定放弃原先的七点破坏方案，改为集中力量攻击核心节点。张羽在整理装备时，发现自己的'隐灵根'在接近锁龙渊后异常活跃，甚至能微弱感应到黑色物质的流动，这让他既担忧又困惑——这种共鸣究竟是福是祸？众人围坐在烛火旁，以茶代酒，宣誓背水一战。窗外，宗门钟声悠扬，祭天大典的序幕即将拉开。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	43	{"key_events": ["柳若霜成功提炼抑制黑色物质活性的药液", "墨渊调整破坏阵法策略为核心节点攻击", "张羽发现隐灵根与黑色物质产生异常共鸣"], "character_focus": ["柳若霜", "墨渊", "张羽"], "emotional_tone": "悲壮中带着坚定", "narrative_goal": "完成最终准备，为祭天大典行动蓄势", "conflict_type": "资源有限与未知变数", "estimated_words": 3000, "scenes": null}	2026-09-20 16:14:53.432747	2026-09-20 19:41:19.413742
4097be92-f913-433f-beea-e36d68ac2131	d59e468a-8617-41e0-aabf-87a13be78834	8	遗秘	\N	张羽与石铁心在废弃矿道中仔细探查，发现那具遗骸并非普通修士，其骨骼上刻满了细密的灵纹，与测灵碑上的纹路有几分相似，却又透着一股说不出的违和感。张羽凭借前世对能量波动的理解，隐约感觉到这些灵纹并非用于修炼，而是用于某种禁锢或抽取。石铁心则发现遗骸手中紧握着一枚残破的玉简，里面记载着一段断断续续的警示：'灵根非天赐，乃人祸……碑下之物，吞魂噬魄……'两人震惊之余，意识到这可能触及了宗门乃至整个修仙界的禁忌。他们不敢久留，匆忙将玉简藏匿，并约定对任何人保密。回到杂役坊后，张羽开始秘密研究玉简内容，试图破解更多线索。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	8	{"key_events": ["发现遗骸骨骼上的诡异灵纹、石铁心找到警示玉简、解读'灵根非天赐'的惊天秘密、藏匿玉简并约定保密"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "震惊与隐秘的兴奋", "narrative_goal": "通过遗骸和玉简，直接点出'灵根天赋'可能并非天赐，而是人为操控，为后续揭露噬界者的阴谋埋下核心伏笔", "conflict_type": "信息冲击与信任考验", "estimated_words": 3000, "scenes": null}	2026-09-20 16:06:40.756185	2026-09-20 16:49:28.971267
226dd313-29d0-45d6-af6f-7a19a4142acc	d59e468a-8617-41e0-aabf-87a13be78834	89	令牌之秘	\N	张羽回到住处后，立即与石铁心、柳若霜在秘密据点汇合。他详细描述了长老殿的异常，三人决定加快调查进度。柳若霜拿出灵玉令牌，以草药知识为掩护，用特殊药液浸泡后发现令牌在特定灵气频率下会产生微弱的共鸣，疑似激活某种吸收阵法。石铁心则绘制了一条从宗门通往山下的秘密矿道地图，作为紧急撤离路线。三人约定祭礼时互相照应，一旦出现异常立即撤离。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	87	{"key_events": ["张羽与石铁心、柳若霜秘密会面", "柳若霜发现灵玉令牌的激活频率", "石铁心绘制秘密矿道撤离路线"], "character_focus": ["张羽", "柳若霜", "石铁心"], "emotional_tone": "紧张而团结", "narrative_goal": "展现团队协作，为祭礼做铺垫，同时揭示灵玉令牌的秘密", "conflict_type": "情报收集与准备", "estimated_words": 3000, "scenes": null}	2026-09-20 16:48:29.76165	2026-09-20 19:48:51.523923
3a77937e-199c-4b09-9b65-ef1611440720	d59e468a-8617-41e0-aabf-87a13be78834	80	夜行追迹	\N	四人连夜转移，张羽凭借前世记忆中的反追踪技巧带领众人穿越密林。途经一个凡人村庄时，发现天衡司司吏正在盘查村民，似乎在搜寻从葬剑谷逃出之人。他们伪装成普通旅人，但石铁心的矿镐和柳若霜的草药气息险些暴露，惊险脱身。途中张羽的灰黑纹路在紧张时闪烁微光，引起一名暗哨注意，短暂追逐后他们利用地形摆脱。墨渊不慎扭伤脚踝，行进速度大减，被迫躲入一座废弃矿洞。洞内竟发现数具天璇宗弟子干尸，死状与祭礼殿中相同，暗示噬界者的手已伸向宗门底层。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	78	{"key_events": ["伪装过村庄盘查", "灰黑纹路闪烁暴露行踪", "废弃矿洞发现天璇宗弟子干尸"], "character_focus": ["张羽", "石铁心", "柳若霜", "墨渊"], "emotional_tone": "紧张、悬疑、压抑", "narrative_goal": "", "conflict_type": "与追兵的外部冲突，团队内部体力与伤势压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:40:37.604005	2026-09-20 19:48:51.523923
45163a46-a6d1-4d90-b707-7ae2b6ec647f	d59e468a-8617-41e0-aabf-87a13be78834	10	入微	\N	张羽正式进入外门，被分配至灵矿堂，负责最底层的灵石分拣与矿道维护。他谨记杂役坊的教训，在众人面前维持隐灵根废材的人设，暗中却利用职务之便，接触到了外门弟子日常修炼所用的基础灵石。通过观察不同品级灵石的灵气波动规律，张羽发现驳杂气息的源头并非来自灵石本身，而是从矿脉深处渗透而出。某夜，他借巡查矿道之机，独自深入废弃支脉，在一处被封印的矿壁前，亲眼目睹了封印纹路如活物般蠕动，将一丝丝本源之力抽离封印，顺着矿脉流向宗门各处。他强压震惊，默默记下封印的方位与纹样，心中对天赋真相的猜测又深了一层。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	10	{"key_events": ["张羽进入外门灵矿堂任职", "发现驳杂气息源自矿脉深处", "目睹封印纹路抽取本源之力"], "character_focus": ["张羽"], "emotional_tone": "压抑、警觉、暗流涌动", "narrative_goal": "展现张羽进入外门后的生存状态，同时通过他的观察进一步揭示世界本源被蚕食的真相，为后续探索埋下伏笔", "conflict_type": "内心冲突与秘密探索", "estimated_words": 3000, "scenes": null}	2026-09-20 16:07:04.202731	2026-09-20 16:49:28.971267
45fab912-684b-487b-82c9-64b5afa82c86	d59e468a-8617-41e0-aabf-87a13be78834	11	暗礁	\N	张羽在灵矿堂结识了因犯错被贬至此的外门弟子墨渊。墨渊表面邋遢懒散，整日醉生梦死，却总能在不经意间点破张羽伪装中的破绽。张羽起初警惕，但几次暗中试探后，发现墨渊对天赋制度同样心存疑虑，且似乎知道一些不为人知的内情。两人逐渐形成一种微妙的默契。与此同时，柳若霜因药园事务与灵矿堂有了交集，她带来一个消息：近期有多名外门弟子在突破时突然神魂枯竭，沦为废人，宗门却将此归咎于他们根基不稳。张羽、墨渊、柳若霜三人首次碰头，在废弃矿道中交换各自发现的线索，隐约感觉到一张无形的大网正笼罩着整个宗门。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	11	{"key_events": ["张羽结识被贬外门弟子墨渊", "墨渊点破张羽伪装破绽", "柳若霜带来弟子神魂枯竭的消息", "三人在废弃矿道交换线索"], "character_focus": ["张羽", "墨渊", "柳若霜"], "emotional_tone": "试探、猜忌、初步信任", "narrative_goal": "引入墨渊这一关键角色，建立三人同盟的雏形，并通过弟子神魂枯竭事件将线索串联，推动主角对真相的探索", "conflict_type": "人际博弈与秘密结盟", "estimated_words": 3000, "scenes": null}	2026-09-20 16:07:04.202731	2026-09-20 16:49:28.971267
4848a596-5182-49da-8c3f-36bc8d43b8a7	d59e468a-8617-41e0-aabf-87a13be78834	70	夜奔葬剑谷	\N	天衡司搜查队逼近矿洞，张羽四人被迫连夜转移。石铁心伤势未愈，柳若霜以银针封穴勉强稳住他的气息，苏晚棠在前方探路，张羽与墨渊殿后。借助矿洞复杂的岔道与早年废弃的通风井，他们成功拉开与追捕者的距离，但出口已被封锁。四人转而向葬剑谷方向潜行。途中，苏晚棠发现天衡司暗哨已沿谷口布下锁灵阵，正面突破无望。张羽以隐灵根感应地脉，察觉谷内灵气流动存在一处微弱的紊乱点，疑似地下暗河入口。墨渊结合古籍判断，那可能是古修士开凿的逃生密道。四人决定冒险一试，却在接近暗河入口时，遭遇了一头因灵气驳杂而变异的低阶妖兽。短暂交锋后，张羽以巧劲将其引开，众人趁机钻入暗河。暗河冰冷刺骨，水流湍急，石铁心几欲昏迷，柳若霜紧握他的手不断输送微薄灵力。当众人被冲出暗河，跌入一片死寂的谷地时，眼前的景象让所有人沉默：灰白色的岩石，枯死的灵木，空气中没有半点灵气波动，仿佛一片被世界遗忘的坟场。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	70	{"key_events": ["四人连夜转移摆脱天衡司追捕", "发现葬剑谷口被锁灵阵封锁", "找到地下暗河入口并遭遇变异妖兽", "进入葬剑谷后目睹死寂景象"], "character_focus": ["张羽", "柳若霜", "墨渊", "苏晚棠"], "emotional_tone": "紧张、压抑、一丝绝望中的顽强", "narrative_goal": "完成从矿洞到葬剑谷的空间转换，展现团队在绝境中的协作，同时以葬剑谷的死寂氛围暗示分灵锚对世界本源的侵蚀程度。", "conflict_type": "外部追捕与恶劣环境的双重压迫", "estimated_words": 3200, "scenes": null}	2026-09-20 16:38:27.580465	2026-09-20 19:46:15.140223
66f9f0de-8c5c-4d2f-b48a-49b7eb8718db	d59e468a-8617-41e0-aabf-87a13be78834	7	暗流	\N	张羽发现自己的名字被从外门选拔初选名单中划掉，意识到有人刻意打压。他没有声张，而是暗中调查，发现是杂役坊管事与一名外门弟子勾结，通过操纵名额中饱私囊。与此同时，石铁心因克扣灵石一事与管事发生激烈冲突，被关押受罚。张羽面临两难：若替石铁心出头，可能暴露自己的隐灵根秘密；若袖手旁观，则失去唯一的朋友。最终，他选择用更隐蔽的方式，利用对矿洞地形的熟悉，制造了一场小型塌方，趁乱救出石铁心。两人在逃亡途中，意外闯入一处被封锁的废弃矿道，发现了刻在岩壁上的古老符文，以及一具姿态诡异的修士遗骸。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	7	{"key_events": ["调查名额被划真相、石铁心因克扣灵石被关押、制造矿洞塌方救出石铁心、发现废弃矿道古老符文与诡异遗骸"], "character_focus": ["张羽", "石铁心"], "emotional_tone": "压抑与愤怒交织", "narrative_goal": "展现张羽在绝境中的抉择与行动力，同时通过发现遗骸和符文，为世界观真相埋下更深伏笔", "conflict_type": "人际冲突与生存危机", "estimated_words": 3000, "scenes": null}	2026-09-20 16:06:40.756185	2026-09-20 16:49:28.971267
57fd4094-01f1-4034-8c62-7f93c693bf8c	d59e468a-8617-41e0-aabf-87a13be78834	17	暗桩	\N	张羽以灵矿堂执事的身份，开始暗中调查聚灵丹的流通渠道。他发现，所有聚灵丹在发放前都会经过内门一位名叫"玄冥长老"的亲传弟子之手，而这位弟子正是当年墨渊目击事件中的那位长老的关门弟子。张羽利用分拣灵石的职务之便，偷偷记录下每一批聚灵丹的流向，发现它们并非平均分配，而是优先供给那些天赋出众、即将突破境界的内门精英。与此同时，柳若霜在药园中发现，那些被用作聚灵丹辅料的灵草，在采摘前都曾被一种诡异的黑色雾气笼罩过，这种雾气与她在废丹中检测出的阴寒侵蚀物同源。她冒险将一株被黑雾侵蚀的灵草带回住处，用特殊手法保存下来作为物证。然而，就在她返回药园的途中，她察觉到身后有一道若有若无的视线在跟踪她。她强作镇定，用平日里甜嗓少女的笑语掩饰内心的警觉，七拐八绕地甩开了跟踪者，但心中已明白：他们可能已经被人盯上了。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	21	{"key_events": ["张羽调查聚灵丹流通渠道锁定玄冥长老弟子", "柳若霜发现灵草被黑色雾气侵蚀并保存物证", "柳若霜察觉被跟踪并成功甩脱"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "紧张、警觉、步步惊心", "narrative_goal": "将聚灵丹线索与内门核心人物挂钩，同时引入外部威胁，提升危机感", "conflict_type": "暗中调查与反跟踪", "estimated_words": 3000, "scenes": null}	2026-09-20 16:08:47.744459	2026-09-20 19:41:19.413742
5a1bb336-39a5-410b-b1a5-e08f6a96a8c3	d59e468a-8617-41e0-aabf-87a13be78834	21	聚沙成塔	\N	墨渊的小院中，四人再次秘密聚会。石铁心带来了他在矿洞深处的新发现：一块刻有古老符文的石板，上面记载着某种古老的封印仪式。结合张羽获取的凝神丹清单和柳若霜发现的灵植异常，墨渊推断出，宗门正在利用凝神丹和特殊灵植构建一个巨大的阵法，而祭天大典正是启动这个阵法的关键时刻。他们意识到，那些天赋出众的弟子不仅是神魂收割的目标，更是这个阵法的活祭品。面对即将到来的祭天大典，四人决定分头行动，收集更多证据，同时寻找阻止这场阴谋的方法。夜色中，四人的目光交汇，一种沉重的决心在沉默中传递。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	25	{"key_events": ["石铁心发现记载封印仪式的古老石板", "墨渊推断凝神丹与灵植用于构建巨大阵法", "四人决定分头行动收集证据并寻找阻止方法"], "character_focus": ["墨渊", "张羽", "柳若霜", "石铁心"], "emotional_tone": "沉重决心", "narrative_goal": "", "conflict_type": "人与命运的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:09:18.094181	2026-09-20 19:41:19.413742
f47d6e01-e75f-4af7-aa4e-0f0df956275b	d59e468a-8617-41e0-aabf-87a13be78834	55	余波未平		苏晚棠紧急救治张羽，用银针封住他暴走的灵气，同时喂服丹药稳定伤势。张羽在昏迷中意识漂流，看到了分灵锚网络的部分真相——无数细如发丝的灵识丝线从主节点延伸出去，连接着整个天元界的修士，随着他们的修炼而缓慢抽取世界本源。墨渊成功摆脱天衡司执事后与两人会合，三人开始撤离祭礼殿。张羽短暂醒来，告诉苏晚棠和墨渊他看到的景象，发现噬界者的入侵计划比想象中更加庞大，分灵锚网络已经渗透到整个修仙界。意识到必须尽快找到其他盟友，共同对抗这个阴谋。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	58	{"key_events": ["苏晚棠用银针封住张羽暴走的灵气进行紧急救治", "张羽在昏迷中意识漂流，看到分灵锚网络连接整个天元界修士的真相", "三人会合后撤离，张羽发现噬界者入侵计划比想象中更加庞大"], "character_focus": ["张羽", "苏晚棠", "墨渊"], "emotional_tone": "沉重、紧迫、危机感加深", "narrative_goal": "揭示分灵锚网络的庞大规模，为后续反抗行动铺垫，同时展现三人同盟的初步形成", "conflict_type": "人与未知力量的对抗、逃亡与追击", "estimated_words": 3000, "scenes": null}	2026-09-20 19:43:31.085873	2026-09-20 19:46:15.140223
70c2222c-2a1b-4a5c-925c-f8a3b5f4acfd	d59e468a-8617-41e0-aabf-87a13be78834	6	前夕	\N	外门选拔考核的消息正式公布，杂役坊沸腾了。这是底层杂役唯一的翻身机会，但名额有限，竞争惨烈。张羽报名后，在模拟对战中遇到了一名强劲对手——一个同样隐藏实力的杂役。两人在对战中互相试探，都未暴露真正实力，但张羽敏锐地察觉到对手身上有一丝熟悉的气息，仿佛对方也有不为人知的秘密。选拔前夕，张羽发现自己的名字被从初选名单中划掉，取而代之的是一个内门管事的亲信。他意识到，有人在暗中操纵选拔，而他成为了被牺牲的对象。面对绝境，张羽必须在有限的时间内找到恢复资格的方法，否则将永远失去进入外门的机会。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	6	{"key_events": ["外门选拔消息公布杂役坊沸腾", "模拟对战遇隐藏实力的强劲对手", "发现名字被从初选名单中划掉"], "character_focus": ["张羽"], "emotional_tone": "紧张与危机感", "narrative_goal": "铺垫外门选拔的残酷性，引入新对手，制造资格危机，为卷末高潮做铺垫", "conflict_type": "外部冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:05:38.33071	2026-09-20 16:49:28.971267
eae65844-7a94-4142-bd75-546e8f6d43c4	d59e468a-8617-41e0-aabf-87a13be78834	79	谷外余烬	\N	四人从葬剑谷裂缝逃出，在一处隐蔽山洞暂避。石铁心被骨质傀儡击伤，柳若霜用草药为他处理伤口。张羽掌心灰黑纹路隐隐作痛，他尝试用精神力压制，却发现纹路在缓慢吸收周围灵气，方式与灵根截然不同。墨渊整理水晶球影像，翻译出更多符文，确认噬界者将在下一次灵潮高峰时启动大规模收割。柳若霜发现张羽的纹路异常，担忧其反噬。张羽突然感应到远处有微弱的神识扫过，判断天衡司暗哨已追踪至此，四人必须立刻转移。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	77	{"key_events": ["发现灰黑纹路自主吸收灵气", "墨渊翻译出灵潮收割期限", "张羽感知到天衡司追兵神识"], "character_focus": ["张羽", "墨渊", "柳若霜"], "emotional_tone": "疲惫、忧虑、紧迫", "narrative_goal": "", "conflict_type": "外部追兵威胁与内部身体隐患", "estimated_words": 3000, "scenes": null}	2026-09-20 16:40:37.604005	2026-09-20 19:48:51.523923
4e770c57-b344-4c70-9127-b814266287a4	d59e468a-8617-41e0-aabf-87a13be78834	73	壁画下的低语	\N	四人从黑色石柱区域撤退至一处相对安全的洞厅。苏晚棠在入口布下简易警戒阵法，确认暂时未被追踪。洞厅四壁绘满了斑驳壁画，描绘着噬界者降临天元界的场景。墨渊借着微光仔细辨认壁画内容，发现其中隐藏着分灵锚分布图与灵潮周期表。张羽靠近壁画时，掌心灰黑纹路隐隐发热，壁画中某个图案似乎在注视着他。石铁心因伤势与灵气匮乏陷入半昏迷，柳若霜以银针渡穴之法勉强稳住他的气息，并将最后一枚丹药化入水中喂他服下。张羽尝试用精神力探查灰黑纹路，发现它正在以极其缓慢的速度吸收周围灵气，方式与灵根截然不同。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	73	{"key_events": ["墨渊解读壁画中噬界者降临场景与分灵锚分布图", "张羽掌心灰黑纹路对壁画产生共鸣反应", "石铁心伤势恶化，柳若霜以银针渡穴稳住伤势"], "character_focus": ["墨渊", "张羽", "柳若霜"], "emotional_tone": "压抑中的紧张与不安", "narrative_goal": "揭示更多关于噬界者的信息，深化灰黑纹路的异常表现，展现团队在绝境中的互相扶持", "conflict_type": "人与环境的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:39:16.188358	2026-09-20 19:47:45.187423
3a50f6de-ed15-4ea9-b715-bdb877c7c570	d59e468a-8617-41e0-aabf-87a13be78834	74	分灵锚的真相		墨渊彻夜研究壁画，终于破译出关键信息：分灵锚将世界本源之力转化为类似灵根的天赋印记，寄生在修士体内，随着修为提升逐步蚕食宿主神魂。张羽结合前世知识，推断出所谓的天赋觉醒并非天地恩赐，而是噬界者精心设计的寄生仪式。柳若霜在照料石铁心时，发现他体内也潜伏着微弱的灰黑气息，推测是长期在灵矿劳作、接触被污染灵气所致。张羽决定冒险再次接触黑色石柱，试图获取更多关于噬界者计划的信息。苏晚棠在警戒时发现洞厅入口的灵气波动异常，似乎有某种存在正在接近。张羽从石柱中获得了更多关于灵潮收割的关键信息，但掌心的灰黑纹路从掌心蔓延至手腕。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	74	{"key_events": ["墨渊破译分灵锚转化世界本源为天赋的机制", "柳若霜发现石铁心体内潜伏灰黑气息", "张羽二次接触石柱获取更多信息，灰黑纹路扩散"], "character_focus": ["墨渊", "张羽", "柳若霜", "苏晚棠"], "emotional_tone": "真相揭露的震撼与沉重", "narrative_goal": "彻底揭示天赋觉醒的寄生本质，展现灰黑纹路对张羽身体的侵蚀加剧，为后续战斗做铺垫", "conflict_type": "人与命运的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 19:47:45.187423	2026-09-20 19:47:45.187423
5721da11-f323-4422-b2ab-b46608079949	d59e468a-8617-41e0-aabf-87a13be78834	88	长老殿的试探	\N	张羽被传唤至长老殿，面对内门长老的威严审视。他表面恭顺，实则暗中观察殿内环境，发现长老们面容疲惫、眼底有不易察觉的灰黑气息。长老以关怀为名试探张羽的修炼进度和灵根状况，张羽巧妙应对，用'隐灵根'的特殊性解释自己的缓慢进展。问询结束后，张羽被允许离开，但他注意到大殿深处有一扇被重重封印的石门，门缝中渗出与灰黑纹路相似的微弱气息。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	86	{"key_events": ["张羽在长老殿接受传唤问询", "张羽观察长老们面容疲惫和灰黑气息", "张羽发现大殿深处的封印石门"], "character_focus": ["张羽", "内门长老"], "emotional_tone": "紧张压抑", "narrative_goal": "展现张羽在危机中的冷静与观察力，同时揭示长老们可能也受魂契影响", "conflict_type": "心理博弈", "estimated_words": 3000, "scenes": null}	2026-09-20 16:48:29.76165	2026-09-20 19:48:51.523923
64e54130-e5f6-409e-8801-d5103ceedb19	d59e468a-8617-41e0-aabf-87a13be78834	78	骨潮与逃离葬剑谷	\N	壁画中涌出大量骨质傀儡，它们由枯骨拼凑而成，关节处缠绕着与灰黑纹路相同的丝线。石铁心挥舞矿镐砸碎最近的一具，但断骨立刻重组。张羽发现傀儡的行动受祭坛水晶球控制，他冒险冲向祭坛，用掌心灰黑纹路反向干扰水晶球频率。傀儡动作一滞，墨渊趁机掷出符箓炸开侧壁，露出通往地外的裂缝。柳若霜搀扶石铁心冲入裂缝，张羽在撤离时被傀儡划伤手臂，灰黑纹路顺伤口蔓延至肩胛。四人跌跌撞撞爬出葬剑谷时，身后谷口被坍塌的岩石封死。墨渊检查张羽伤势，发现纹路已扎根魂魄，常规手段无法拔除，唯有找到噬界者的'净化锚点'才能化解。石铁心昏迷前攥紧张羽衣袖，含糊说'你这条命，我记下了'。张羽回望葬剑谷，掌心纹路如活物般蠕动，他感到遥远虚空中有双眼睛正透过纹路凝视自己。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	76	{"scenes": null, "key_events": ["壁画涌出骨质傀儡", "张羽干扰水晶球制造逃脱窗口", "张羽被傀儡划伤导致灰黑纹路扩散"], "conflict_type": "直接战斗与逃亡", "emotional_tone": "惨烈、悲壮", "narrative_goal": "结束葬剑谷探索，将个人危机升级，为下一阶段寻找净化锚点铺垫", "character_focus": ["张羽", "石铁心"], "estimated_words": 3000}	2026-09-20 16:39:46.410409	2026-09-20 19:48:51.523923
a692ba80-6b81-4311-be4b-51b6c1bb9f74	d59e468a-8617-41e0-aabf-87a13be78834	24	风起于青萍之末	\N	深夜，墨渊的小院中，四人再次秘密聚会。张羽与石铁心带来了祭台物资与内门弟子谈话的情报，柳若霜则汇报了清心草被强行带走的情况。苏晚棠将天赋丹交给墨渊，并讲述了被跟踪的经历。墨渊将天赋丹置于特制的法器中，经过一番分析，他脸色凝重地发现，丹药的核心成分与凝神丹、灵植中的黑色物质如出一辙，都是某种能够侵蚀灵魂、催化天赋的邪物。他推断，宗门正在通过丹药、灵植、阵法三位一体的方式，系统性地收割弟子的神魂与天赋，而祭天大典就是最终收割的时刻。四人意识到，他们已经掌握了足够的证据，但仅凭他们四人的力量，根本无法与整个宗门抗衡。墨渊提出，必须寻找外部盟友，但在此之前，他们需要先摸清祭天大典的具体流程与阵法核心所在。正当四人商议之际，院外突然传来一阵急促的敲门声，一个陌生的声音在门外低语：'我知道你们在做什么，我可以帮你们。'四人对视一眼，心中惊疑不定，不知来者是敌是友。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	28	{"key_events": ["墨渊分析天赋丹确认其与凝神丹、灵植黑色物质同源", "墨渊推断宗门通过丹药、灵植、阵法三位一体收割弟子", "四人意识到需要寻找外部盟友并摸清祭天大典具体流程", "院外传来陌生声音声称可以帮助他们"], "character_focus": ["墨渊", "张羽", "柳若霜", "苏晚棠", "石铁心"], "emotional_tone": "凝重悬疑、山雨欲来", "narrative_goal": "汇总所有线索，由墨渊揭示宗门收割的全貌，明确下一步行动方向，同时以神秘来客制造悬念，为后续剧情埋下伏笔", "conflict_type": "真相揭露与未知威胁", "estimated_words": 3000, "scenes": null}	2026-09-20 16:10:18.508272	2026-09-20 19:41:19.413742
7e44565f-86b7-47a0-9b6c-66212b3fe23e	d59e468a-8617-41e0-aabf-87a13be78834	86	疑影重重	\N	张羽回到静修阁后，发现自己的房间有被翻动的痕迹，但贵重物品并未丢失，显然对方在寻找某种特定信息。他不动声色地检查了墨渊留下的暗记，确认石铁心和柳若霜的安全后，开始分析监视者的身份与目的。次日，集训继续，张羽在比试中刻意表现出体力不支的假象，暗中观察其他弟子的状态。他发现一名曾在聚会上出现过的内门弟子今日神情恍惚，眼神空洞，仿佛被抽走了部分神魂。张羽借机接近，试图套话，对方却在提及某个关键词时突然浑身颤抖，被巡逻执事带走。张羽注意到执事袖口绣着一道极淡的银色纹路，与方陵提供的账目残页上的标记如出一辙。当晚，墨渊再次秘密现身，带来一个惊人消息：天璇宗将在三日后举行一场盛大的祭礼，所有内门弟子必须参加，而祭礼的真正目的是加速魂契成熟，为大规模收割做准备。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	84	{"key_events": ["张羽发现房间被翻动", "内门弟子出现神魂透支症状被带走", "墨渊带来祭礼与大规模收割的情报"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "压抑与急迫", "narrative_goal": "揭示魂契收割的紧迫性，推动张羽从被动观察转向主动行动", "conflict_type": "时间压力与暴露风险的矛盾", "estimated_words": 3000, "scenes": null}	2026-09-20 16:42:58.428069	2026-09-20 19:48:51.523923
879c6063-befd-46c5-a664-d7f615750ba4	d59e468a-8617-41e0-aabf-87a13be78834	84	旧友重逢与暗盟初现	\N	张羽借外出采药之机，与隐藏在外门坊市的石铁心、柳若霜秘密汇合。三人带着他找到了一直以摊贩身份伪装的墨渊。墨渊分享了他混入外门后偷听到的长老谈话片段，提及"魂契成熟""本源收割"等关键词，并确认天璇宗高层与噬界者存在交易。张羽决定主动接触一名在集训中对他表露过善意的内门师兄方陵，此人曾私下询问他关于"灵气驳杂"的感受。两人在药园僻处试探交锋，方陵竟直接展示了一枚记录有弟子异常死亡记录的玉简，表明自己也在暗中调查天赋真相。初步信任建立后，方陵邀请张羽参加一场由"对天赋制度存疑者"组成的秘密聚会，但张羽在归途中察觉到有人跟踪，无法确定是方陵的考验还是其他势力的眼线。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	82	{"key_events": ["张羽与石铁心、柳若霜、墨渊秘密汇合", "墨渊透露魂契与本源收割的关键情报", "张羽结识暗中调查的方陵，获邀参加秘密聚会但被跟踪"], "character_focus": ["张羽", "石铁心", "柳若霜", "墨渊", "方陵"], "emotional_tone": "短暂温暖、紧张、悬疑", "narrative_goal": "完成四人重组，将线索从个人感知升级为具体情报，并通过方陵的引入打开内门反抗势力的窗口，同时以跟踪事件保持悬念，为下一卷的暗流涌动做直接铺垫。", "conflict_type": "情报整合与信任试探", "estimated_words": 3000, "scenes": null}	2026-09-20 16:42:01.244112	2026-09-20 19:48:51.523923
89d35ad9-77d5-4657-81d8-73e279be7654	d59e468a-8617-41e0-aabf-87a13be78834	76	祭坛投影与收割倒计时	\N	石室中央的地面无声滑开，升起一座黑石祭坛，坛面悬浮着一颗拳头大小的水晶球。张羽体内的灰黑纹路与水晶球产生共鸣，他刚靠近，球体便投射出立体影像：一片陌生的大陆上，无数修士正在觉醒天赋，他们灵根绽放的瞬间，天空裂开缝隙，梭形物体降下光柱，将修士神魂抽出一缕存入容器。影像最后，水晶球显示出一幅星图，其中一颗暗红色星辰正在缓慢脉动，旁边标注着与壁画相同的符文。柳若霜颤声翻译出'剩余本源'和'收割期限'的含义，推断那颗暗红星辰代表当前世界被抽取的程度，脉动加速意味着收割临近。墨渊面色铁青，指出这祭坛可能是噬界者留下的监控节点，张羽的触碰已激活了警报。石铁心猛然抬头，听见石室外传来窸窣的爬行声，似有东西正从壁画中挣脱。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	75	{"key_events": ["发现黑石祭坛与水晶球", "水晶球投射噬界者收割影像", "柳若霜翻译出'收割期限'符文"], "character_focus": ["柳若霜", "张羽"], "emotional_tone": "急迫、恐惧", "narrative_goal": "将抽象危机具象化为时间压力，为行动提供驱动力", "conflict_type": "时间压力与外部威胁", "estimated_words": 3000, "scenes": null}	2026-09-20 16:39:46.410409	2026-09-20 19:48:51.523923
a664917d-2f30-4290-bc1f-68a85b061b5b	d59e468a-8617-41e0-aabf-87a13be78834	54	祭礼前夜	\N	张羽在废弃丹房中反复推演潜入祭礼殿的路线，却发现总坛外围的巡逻阵法在子时会出现一处极短暂的盲区，但盲区持续时间不足以让他带出两个人。他决定兵分两路：自己先潜入祭礼殿破坏分灵锚的核心阵眼，制造混乱，再由墨渊和苏晚棠趁乱救人。然而，当他试图用梭形物再次连接分灵锚装置以获取更多内部信息时，梭形物却毫无反应，仿佛被某种力量彻底屏蔽。张羽意识到，祭礼殿内可能存在一个更强大的分灵锚主节点，它不仅能屏蔽梭形物的探测，甚至可能反向追踪持有梭形物之人。他必须在没有梭形物辅助的情况下，仅凭对符文和阵法的理解，硬闯祭礼殿。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	57	{"key_events": ["张羽发现祭礼殿巡逻阵法的子时盲区", "张羽决定兵分两路破坏分灵锚并救人", "梭形物被祭礼殿内更强大的分灵锚主节点屏蔽"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张、焦虑、决绝", "narrative_goal": "展现张羽在失去梭形物辅助后的应变能力，以及他为救同伴不惜以身犯险的决心，同时揭示祭礼殿内存在更强大的分灵锚主节点，为后续行动增加难度和悬念。", "conflict_type": "策略困境与时间压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:35:08.966644	2026-09-20 19:48:51.523923
5d909d5f-16b8-4e88-b550-acb02f8811ba	d59e468a-8617-41e0-aabf-87a13be78834	66	矿洞深处的阵法波动	\N	废弃矿洞深处，四人暂避。石铁心伤势恶化，柳若霜悉心照料。墨渊结合古籍与药园地底所见，详细分析分灵锚阵群的结构，指出葬剑谷极可能是阵眼所在。张羽尝试用隐灵根感应，发现矿洞深处有微弱的阵法波动，与药园地底的黑色根须同源。更令人不安的是，张羽在感应阵法波动的同时，隐约察觉到矿洞深处似乎还有其他人存在，气息微弱却真实。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	67	{"key_events": ["墨渊分析分灵锚阵群结构", "张羽用隐灵根感应阵法波动", "张羽感应到矿洞深处有其他人存在"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张而压抑，夹杂着希望与不安", "narrative_goal": "揭示分灵锚阵群的结构，为后续潜入葬剑谷做铺垫，同时引入新的悬念", "conflict_type": "信息探索与外部威胁并存", "estimated_words": 3000, "scenes": null}	2026-09-20 16:37:24.226522	2026-09-20 19:46:15.140223
c430e831-1d9a-4731-aee2-ac57556bb9e8	d59e468a-8617-41e0-aabf-87a13be78834	68	夜奔葬剑谷		天衡司搜查队逼近矿洞，四人被迫连夜转移。石铁心伤势未愈，柳若霜以银针封穴之法勉强稳住他的气息，但无法持久。苏晚棠凭借对矿洞结构的熟悉在前方探路，张羽与墨渊殿后，利用矿洞复杂的岔道和早年废弃的通风井，成功拉开与追捕者的距离。然而，当他们赶到最近的出口时，发现天衡司已布下天罗地网，正面突破无望。四人当机立断，转而向葬剑谷方向潜行。途中，苏晚棠敏锐地发现天衡司暗哨已沿谷口布下锁灵阵，灵气被封锁，修士难以飞行或施展法术。张羽提议寻找其他入口，最终在一处悬崖下发现地下暗河的入口。然而，当他们准备潜入暗河时，河中突然窜出一头变异妖兽，浑身覆盖着黑色鳞片，眼中闪烁着不祥的红光。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	68	{"key_events": ["四人连夜转移摆脱追捕", "柳若霜以银针封穴稳住石铁心", "借助矿洞岔道和通风井拉开距离", "发现出口被天衡司封锁", "转向葬剑谷方向潜行", "发现谷口被锁灵阵封锁", "找到地下暗河入口", "遭遇变异妖兽"], "character_focus": ["柳若霜", "苏晚棠", "张羽", "墨渊"], "emotional_tone": "紧张急促，危机四伏", "narrative_goal": "完成从矿洞到葬剑谷的转移，设置新的障碍和悬念", "conflict_type": "外部追捕与环境障碍", "estimated_words": 3000, "scenes": null}	2026-09-20 19:44:30.740915	2026-09-20 19:48:51.523923
ca174e62-e016-496c-bcbc-d1edd4f7fbea	d59e468a-8617-41e0-aabf-87a13be78834	82	静修阁暗影	\N	张羽在一位内门长老的救治下醒来，发现自己身处外门与内门交界处的静修阁。他体内的灰黑纹路被暂时封印，但精神力严重透支，伪装的隐灵根也处于不稳定状态。长老以关怀为名反复试探他灵根异象的根源，张羽凭借前世记忆编造了一套"矿洞古修遗泽"的说辞，勉强过关。被要求暂住静修阁等待宗门进一步核定时，他感知到内门方向的灵气中驳杂与腐朽气息远比外门浓烈，且偶有弟子面色恍惚、眼神空洞地走过，仿佛神魂被抽离。夜深时，张羽听到窗外传来极轻微的脚步声和低语，似乎有人正在暗中监视他的一举一动。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	80	{"key_events": ["张羽苏醒发现身处静修阁，灰黑纹路被封印", "内门长老试探灵根异象来历，张羽编造遗泽说辞", "张羽感知内门灵气驳杂与弟子神魂异样，窗外出现监视者"], "character_focus": ["张羽", "内门长老"], "emotional_tone": "压抑、警觉、孤立无援", "narrative_goal": "将张羽置于内门边缘的陌生环境，展现内门表面繁华下的诡异氛围，同时通过监视者营造持续的不安感，为后续暗线调查铺路。", "conflict_type": "内在冲突（隐藏秘密）与环境冲突（未知监视）", "estimated_words": 3000, "scenes": null}	2026-09-20 16:42:01.244112	2026-09-20 19:48:51.523923
da8a1bda-0b08-4f11-be46-a3696b609fe5	d59e468a-8617-41e0-aabf-87a13be78834	77	苏醒的祭坛		壁画突然发出幽绿光芒，整个洞厅开始轻微震动。墨渊发现壁画并非简单的壁画，而是一个大型封印阵法的一部分，黑色石柱正是阵眼。张羽掌心的灰黑纹路剧烈反应，与壁画产生深度共鸣，他的意识被拉入一段幻象：噬界者大军通过分灵锚打开的通道涌入天元界，无数修士在天赋觉醒的狂喜中沦为傀儡。石铁心强撑身体抓起矿镐，柳若霜试图用银针切断张羽与壁画的联系却无济于事。苏晚棠发现洞厅四壁出现细微裂纹，枯骨在缝隙后开始蠕动。张羽在幻象中看到祭坛水晶球的位置，意识到那是控制整个阵法的中枢。壁画裂开缝隙，传出低沉的吟唱声，大量枯骨在缝隙后蠢蠢欲动。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	75	{"key_events": ["壁画激活为大型阵法的一部分", "张羽灰黑纹路剧烈反应，与壁画产生深度共鸣", "壁画出现裂纹，枯骨在缝隙后开始蠕动"], "character_focus": ["张羽", "墨渊", "柳若霜", "苏晚棠"], "emotional_tone": "危机降临的紧迫与绝望", "narrative_goal": "触发祭坛机关，为骨质傀儡涌出做铺垫，展现张羽在关键时刻的觉醒", "conflict_type": "人与超自然力量的冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 19:47:45.187423	2026-09-20 19:48:51.523923
bce49361-bd96-4798-a598-be1dd73a900c	d59e468a-8617-41e0-aabf-87a13be78834	5	变异	\N	张羽在药园与柳若霜照料灵植时，发现灵植的生长也受到了灵气驳杂的影响——叶片边缘出现枯萎，根系却异常发达。柳若霜透露，近年来宗门内有不少弟子在突破后突然失踪，官方说法是外出历练，但从未有人回来过。张羽结合自己观察到的神魂透支异象，心中隐隐有了猜测。为了验证，他利用前世知识，引导柳若霜尝试用特殊手法培育一株受污染的灵植。经过数日努力，灵植竟发生了变异，散发出奇异的香气。这株变异灵植引起了药园执事的注意，他亲自前来查看，对张羽和柳若霜的手段产生了浓厚兴趣。张羽知道，这既是机遇，也是危险。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	5	{"key_events": ["发现灵植受灵气驳杂影响", "柳若霜透露弟子失踪传闻", "合作培育变异灵植引起执事注意"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "悬疑与希望交织", "narrative_goal": "深化对灵气驳杂的观察，铺垫弟子失踪的线索，引入药园执事这一新角色", "conflict_type": "外部冲突", "estimated_words": 3000, "scenes": null}	2026-09-20 16:05:38.33071	2026-09-20 16:49:28.971267
ac7a2786-3198-45ff-be40-22f2543f1413	d59e468a-8617-41e0-aabf-87a13be78834	67	废弃祭坛的秘密	\N	张羽与苏晚棠沿着阵法波动的方向深入探索，发现一个被遗弃的地下祭坛。祭坛上布满了与药园地底相同的黑色根须，但已全部枯萎，呈现出一种诡异的灰白色。祭坛中央有一块残破的玉简，记载着分灵锚的早期实验记录。玉简中提到，魂契收割需要一种名为'引魂香'的特殊媒介，而这种香只在葬剑谷的特定区域生长。这一发现让四人意识到，葬剑谷不仅是阵眼，更是整个魂契收割体系的关键节点。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	68	{"key_events": ["发现被遗弃的地下祭坛", "祭坛上有枯萎的黑色根须", "发现记载分灵锚早期实验记录的玉简"], "character_focus": ["张羽", "苏晚棠"], "emotional_tone": "阴森而震撼，真相逐渐浮出水面", "narrative_goal": "揭示魂契收割的具体机制，为潜入葬剑谷提供关键信息", "conflict_type": "真相探索与时间压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:37:24.226522	2026-09-20 19:48:51.523923
f7b7ebc9-d22d-4a8b-970b-edd83b5df81d	d59e468a-8617-41e0-aabf-87a13be78834	90	祭礼暗影	\N	祭礼当日，所有内门弟子被召集至星辰大殿前的广场。张羽佩戴灵玉令牌，站在人群中。仪式开始后，他发现令牌开始微微发热，释放出一种无形的力量，缓慢吸收佩戴者的神魂之力。张羽立即运用强大的精神力在体内形成屏障，同时暗中帮助身边的石铁心和柳若霜抵御吸收。祭礼高潮时，广场中央的祭坛裂开，露出下方巨大的分灵锚阵，阵纹闪烁间，张羽震惊地发现方陵被绑在祭坛中央，似乎成为了祭礼的核心祭品。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	88	{"key_events": ["祭礼仪式开始，灵玉令牌吸收神魂", "张羽运用精神力形成屏障保护同伴", "张羽发现分灵锚阵和方陵成为祭品"], "character_focus": ["张羽", "石铁心", "柳若霜", "方陵"], "emotional_tone": "紧张惊悚", "narrative_goal": "展现祭礼的残酷真相，将剧情推向高潮，为后续冲突做铺垫", "conflict_type": "生死危机", "estimated_words": 3000, "scenes": null}	2026-09-20 16:48:29.76165	2026-09-20 19:48:51.523923
bea361b8-dffc-427e-96d9-bad0ad0a6785	d59e468a-8617-41e0-aabf-87a13be78834	28	夜访藏经阁	\N	深夜，张羽按照墨渊给的暗号，独自前往藏经阁后方的废弃书库。墨渊已在那里等候，两人借着微弱烛光，将柳若霜的变异清心草样本、石铁心发现的古老石板拓文以及墨渊找到的手札残卷拼凑在一起分析。他们发现黑色丝线、天赋丹与灵植变异都指向同一个源头，而石板上的封印阵法与祭台禁物批次存在惊人的对应关系。正当他们试图还原阵法全貌时，书库外传来脚步声，两人迅速藏匿。来者是两名内门执事，低声交谈中提及祭天大典前的清场安排，以及外门弟子中即将被抽调参与祭礼的名单。张羽和墨渊屏息倾听，发现名单上竟有柳若霜的名字。脚步声远去后，两人对视一眼，意识到时间比预想的更加紧迫。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	32	{"key_events": ["张羽与墨渊在废弃书库汇合分析证据链", "三人发现祭台禁物批次与封印阵法存在对应关系", "偷听到内门执事交谈获知祭礼抽调名单上有柳若霜"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张压抑中透着决然", "narrative_goal": "将分散的证据线索串联成完整图景，同时引入新的紧迫危机", "conflict_type": "外部威胁逼近与内部时间压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:11:37.953307	2026-09-20 19:41:19.413742
f8f767d3-fff1-4512-9d1b-a892a55b1f22	d59e468a-8617-41e0-aabf-87a13be78834	75	壁画上的收割者	\N	墨渊用力推开骨堆下的暗门，一股腐朽的冷风扑面而来。四人鱼贯而入，发现这是一条向下延伸的甬道，壁上刻满发光的纹路。张羽掌心灰黑纹路在靠近墙壁时微微跳动，他强忍不适，借荧光观察四周。甬道尽头是一间圆形石室，穹顶与四壁绘满了斑驳的壁画：第一幅描绘一颗巨大的梭形物体悬浮于虚空，下方是无数细小丝线连接着蝼蚁般的生灵；第二幅展示生灵头顶生出伪灵根，随着修炼，丝线将金色光点抽入梭形物；最后一幅则是整个世界枯萎崩塌，梭形物满载而去。墨渊倒吸凉气，指出这是噬界者收割世界的全流程记录。柳若霜发现壁画角落有一行古老符文，张羽凭借分灵锚碎片上的符文知识勉强认出'本源剥离'四字。石铁心靠在墙边喘粗气，提醒此处不宜久留，话音未落，壁画上的纹路突然亮起，一道光扫过众人，张羽掌心灰黑纹路骤然灼痛，石室深处传来机括运转的闷响。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	74	{"key_events": ["进入骨堆暗门后的甬道", "发现描绘噬界者收割过程的壁画", "张羽辨认出'本源剥离'符文"], "character_focus": ["张羽", "墨渊"], "emotional_tone": "紧张、震撼", "narrative_goal": "揭示噬界者入侵手段的全貌，强化世界危机真实感", "conflict_type": "环境威胁与历史冲击", "estimated_words": 3000, "scenes": null}	2026-09-20 16:39:46.410409	2026-09-20 19:48:51.523923
3cfc32c3-3faf-4067-900d-73a9d8e1a649	d59e468a-8617-41e0-aabf-87a13be78834	32	风声鹤唳	\N	次日清晨，张羽在杂役坊中感到莫名的压抑，发现有人在暗中观察他。他巧妙设局，利用矿洞劳作的机会确认了跟踪者是内门执事的心腹。与此同时，张羽收到柳若霜的紧急传讯，药园管事突然将所有的变异灵植转移，柳若霜也被限制了自由，不得离开药园。张羽意识到他们的调查已经打草惊蛇，噬界者势力开始收网。他必须尽快找到柳若霜，同时制定应对之策，否则所有人都将陷入万劫不复的境地。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	36	{"key_events": ["张羽发现被内门执事的心腹跟踪", "柳若霜传来药园变异灵植被转移的紧急消息", "柳若霜被限制自由不得离开药园", "张羽意识到调查已经暴露必须立即行动"], "character_focus": ["张羽", "柳若霜"], "emotional_tone": "紧张、焦虑、急迫", "narrative_goal": "提升紧张感，展现敌人的反扑，迫使主角加快行动节奏", "conflict_type": "外部压迫、危机升级", "estimated_words": 3000, "scenes": null}	2026-09-20 16:12:04.621278	2026-09-20 19:41:19.413742
41d79e45-7901-4907-9922-7439656004c7	d59e468a-8617-41e0-aabf-87a13be78834	31	寄生真相	\N	矿洞深处，张羽从触碰黑色晶石的恐怖幻境中猛然挣脱，浑身冷汗淋漓。他向石铁心和老园丁描述了自己在幻境中看到的画面：噬界者如何将伪灵根植入原住民体内，如何暗中抽取世界本源之力。张羽震惊地发现，自己伪装的'隐灵根'因为并非真正的伴生灵根，反而没有被寄生，这让他既庆幸又恐惧。老园丁面色凝重地透露，即将到来的祭礼并非普通的宗门仪式，而是噬界者大规模收割神魂的阴谋，所有被抽调的弟子都将成为开启'天启之门'的祭品。三人意识到时间紧迫，必须阻止这场浩劫。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	35	{"key_events": ["张羽从幻境中恢复并描述噬界者入侵画面", "确认灵根是噬界者植入的寄生体", "发现自身隐灵根因伪装方式特殊而未被寄生", "老园丁透露祭礼的真正目的是大规模收割神魂"], "character_focus": ["张羽", "石铁心", "老园丁"], "emotional_tone": "恐惧、震惊、紧迫", "narrative_goal": "揭示灵根寄生的真相，明确祭礼的阴谋性质，为后续行动提供动机", "conflict_type": "认知冲突、时间压力", "estimated_words": 3000, "scenes": null}	2026-09-20 16:12:04.621278	2026-09-20 19:41:19.413742
f5594435-c9ee-4cb1-bbd0-c1a19ee0d2df	d59e468a-8617-41e0-aabf-87a13be78834	12	裂隙	\N	三人同盟初步形成后，张羽开始有意识地利用职务之便，暗中调查那些神魂枯竭弟子的共同点。他发现这些弟子在突破前都曾服用过宗门统一发放的聚灵丹，而丹药的原料正是来自灵矿堂分拣出的高品级灵石。顺着这条线索，他偷偷将一枚聚灵丹交给柳若霜分析，柳若霜凭借她对草药的敏锐感知，发现丹药中掺杂了一种未知的阴寒之物，此物能加速灵气运转，却会悄然侵蚀神魂。张羽意识到，这绝非偶然，而是有人在系统性地收割修士的神魂。就在他准备进一步追查时，灵矿堂突然接到命令，要求所有弟子进入矿脉深处开采一批紧急征调的灵石。张羽心中警铃大作，他隐约感觉到，这次深入矿脉，或许能触及那个被层层掩盖的真相核心。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	12	{"key_events": ["张羽调查神魂枯竭弟子的共同点", "柳若霜分析聚灵丹发现阴寒侵蚀物", "推断出系统性收割神魂的阴谋", "接到深入矿脉开采紧急征调灵石的命令"], "character_focus": ["张羽", "柳若霜", "墨渊"], "emotional_tone": "紧张、决断、山雨欲来", "narrative_goal": "通过调查将线索收束，揭示神魂收割的阴谋，并以紧急征调命令制造悬念，为下一卷深入矿脉、直面真相做铺垫", "conflict_type": "阴谋揭露与危机逼近", "estimated_words": 3000, "scenes": null}	2026-09-20 16:07:04.202731	2026-09-20 16:49:28.971267
ba9639de-df48-4aff-bc70-ee9249ecccc0	d59e468a-8617-41e0-aabf-87a13be78834	81	异象惊变	\N	矿洞内，张羽的灰黑纹路突然失控，疯狂吸收灵气，与体内伪装的隐灵根产生剧烈冲突。他痛苦倒地，灵气外泄形成漩涡，石铁心和柳若霜无法靠近。墨渊认出这是灵根变异前兆，极可能暴露众人。此时天衡司追兵包围矿洞，危急时刻张羽体内冲突竟爆发出一道冲天灵光，呈现出极品天灵根的罕见异象。异象惊动了附近巡视的天璇宗内门长老，长老出手击退追兵。张羽因祸得福，被长老看中其"极品天赋"，决定破格提拔为内门弟子。墨渊、石铁心、柳若霜作为随从一同被带入。张羽昏迷前，瞥见长老眼中一闪而过的疑惑。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	79	{"key_events": ["灰黑纹路失控引发灵气冲突", "爆发极品天灵根异象", "内门长老出手相救并提拔张羽"], "character_focus": ["张羽", "石铁心", "柳若霜", "墨渊"], "emotional_tone": "绝望转为惊喜，隐含隐患", "narrative_goal": "", "conflict_type": "体内力量冲突的内心危机与外部追兵威胁", "estimated_words": 3000, "scenes": null}	2026-09-20 16:40:37.604005	2026-09-20 19:48:51.523923
edd1d124-4fb3-4dd9-888c-c8eaf5e7aa76	d59e468a-8617-41e0-aabf-87a13be78834	41	祭台暗影	\N	祭天大典现场，人声鼎沸，灵气缭绕。张羽以杂役身份混入祭台外围，发现祭台比锁龙渊地下仓库所见大了数倍，核心节点处有十二根黑色石柱环绕，每根石柱上都刻满了他无法辨认的符文。石铁心利用矿工经验，发现祭台下方有中空结构，疑似藏有另一层阵法。柳若霜则感应到核心处有微弱的生命气息，似乎有活物被封印在阵眼之中。墨渊在外围观察到，参与祭礼的弟子中有几人的神魂波动异常，像是被催化过度的征兆。就在众人准备按计划接近核心时，张羽的隐灵根突然剧烈震颤，他感应到祭台深处有一双无形的眼睛正在注视着所有人。	0	draft	96f10a16-070b-4e1b-82f0-6e962b5b6f3f	45	{"key_events": ["张羽发现祭台核心有十二根黑色石柱环绕", "石铁心发现祭台下方有中空结构", "柳若霜感应到核心处有活物生命气息", "张羽感应到祭台深处有无形注视"], "character_focus": ["张羽", "石铁心", "柳若霜", "墨渊"], "emotional_tone": "诡异、压抑、危机感", "narrative_goal": "展现祭台的诡异构造，暗示更深层的阴谋，为行动增加变数", "conflict_type": "未知恐惧与计划受阻", "estimated_words": 3000, "scenes": null}	2026-09-20 16:15:59.856503	2026-09-20 19:41:19.413742
\.


--
-- Data for Name: character_careers; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.character_careers (id, character_id, career_id, career_type, current_stage, stage_progress, started_at, reached_current_stage_at, notes, created_at, updated_at) FROM stdin;
096e130b-8bb0-4083-a8b8-d8a48ab5fd4c	27635aa9-65ae-48a8-8842-62dc121d86f0	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	main	2	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
fa4bfea2-df1d-4d05-90e1-fcdd1f0f8bc3	27635aa9-65ae-48a8-8842-62dc121d86f0	f3e0994d-cca9-459e-8086-cbabc79c3a93	sub	1	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
bc7e39ab-b8ff-4273-b862-c9b15268d528	0f0ef402-3ad1-45fc-be6a-582774193d14	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	main	1	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
464d49b1-1520-4055-a3fe-4c9cae61e61a	0f0ef402-3ad1-45fc-be6a-582774193d14	f3e0994d-cca9-459e-8086-cbabc79c3a93	sub	1	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
27917d1a-6f7e-46b2-be75-cf3c127e831b	6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	main	2	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
08a36c8d-2b22-4849-9a78-d414ad187b8e	a4d5f38f-fea9-4947-8fc7-624ff8743955	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	main	2	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
37f4b78e-dfd0-4d46-8de3-a42e211ca113	a4d5f38f-fea9-4947-8fc7-624ff8743955	f3e0994d-cca9-459e-8086-cbabc79c3a93	sub	1	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
f7cf1593-ca7b-4967-b0cf-d81626a505f2	aff03d10-b083-4bde-a165-34e8c9b3f9a8	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	main	3	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
a5c85a68-a0fc-4beb-9f9c-b47fb2d69beb	aff03d10-b083-4bde-a165-34e8c9b3f9a8	f3e0994d-cca9-459e-8086-cbabc79c3a93	sub	2	0	\N	\N	\N	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
\.


--
-- Data for Name: character_relationships; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.character_relationships (id, project_id, character_from_id, character_to_id, relationship_type_id, relationship_name, intimacy_level, status, description, started_at, ended_at, source, created_at, updated_at) FROM stdin;
ddfd506e-b59e-4b57-9f20-a8e60470bfbd	d59e468a-8617-41e0-aabf-87a13be78834	0f0ef402-3ad1-45fc-be6a-582774193d14	6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	\N	义兄	55	active	石铁心把她当成亲妹妹护着，她也把石铁心当作可以撒娇的兄长，但心里总怕自己的身世会连累他。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
9003a042-1bdc-4902-bc30-bba10f741b43	d59e468a-8617-41e0-aabf-87a13be78834	6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	27635aa9-65ae-48a8-8842-62dc121d86f0	\N	救命恩人与战友	68	active	张羽救了他妹妹，他从此甘为张羽手中最锋利的一柄铁镐，不问缘由。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
c4314328-13e4-462f-811a-6766b16456c5	d59e468a-8617-41e0-aabf-87a13be78834	6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	0f0ef402-3ad1-45fc-be6a-582774193d14	\N	义兄妹	55	active	把柳若霜视作另一个妹妹，嘴上叫她柳丫头，私下会把省下的肉干悄悄塞进她的药袋。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
d268a4d5-cb6c-47c6-ae2b-ad2171067239	d59e468a-8617-41e0-aabf-87a13be78834	a4d5f38f-fea9-4947-8fc7-624ff8743955	27635aa9-65ae-48a8-8842-62dc121d86f0	\N	敌意纠葛	-15	active	奉天衡司之命潜伏在张羽身边搜集证据，却一次次被他护住弱者的举动动摇，任务与良知撕扯得她夜不能寐。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
5b65bec0-71de-466d-a12c-31fc06dc3902	d59e468a-8617-41e0-aabf-87a13be78834	a4d5f38f-fea9-4947-8fc7-624ff8743955	aff03d10-b083-4bde-a165-34e8c9b3f9a8	\N	怀疑对手	-20	active	她总觉得这个藏经阁的老头深不可测，每次经过都会下意识绕开他的视线，两人交锋如同隔空对弈，谁也没先亮底牌。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
cf18abe0-6040-43dd-84f1-2b0919eed98e	d59e468a-8617-41e0-aabf-87a13be78834	aff03d10-b083-4bde-a165-34e8c9b3f9a8	27635aa9-65ae-48a8-8842-62dc121d86f0	\N	师徒	70	active	以半本残卷为饵，将张羽引进破妄之门，嘴上说是闲得慌，实则把当年未竟的路都寄托在这个青年人身上。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
275440e1-537a-43dc-bac8-916cd0f2c547	d59e468a-8617-41e0-aabf-87a13be78834	aff03d10-b083-4bde-a165-34e8c9b3f9a8	a4d5f38f-fea9-4947-8fc7-624ff8743955	\N	警觉的对弈者	-20	active	一照面就看出她身上的天衡司气息，却按兵不动，想利用这条线钓出真正的幕后黑手。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
f225322a-7764-4a25-b4be-4cc5545d1339	d59e468a-8617-41e0-aabf-87a13be78834	aff03d10-b083-4bde-a165-34e8c9b3f9a8	0f0ef402-3ad1-45fc-be6a-582774193d14	\N	忘年交	40	active	嘴上嫌弃她送来的草叶品相太差，转头却默默练成丹药塞回她的药袋，永远不肯承认自己关心她。	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369
2d993a42-f19c-49ef-81db-0edd0167ee73	d59e468a-8617-41e0-aabf-87a13be78834	0f0ef402-3ad1-45fc-be6a-582774193d14	27635aa9-65ae-48a8-8842-62dc121d86f0	13	信任加深，依赖感增强	100	active	在杂役坊的灰暗岁月里互为依靠，她是张羽唯一敢暴露伪造天赋真相的人，也是他实验药剂的秘密试药者。\n[第3章] 信任未减，保护欲增加；共同承担一个不为人知的秘密\n[第3章] 信任加深，依赖感增强	\N	\N	ai	2026-08-05 13:41:25.824369	2026-08-05 14:00:13.616189
b53471fe-f733-4777-85e8-b66b9e8542cf	7f6d28c4-2a32-46d1-887c-6cf5c4555056	815122f4-2668-4b12-afe4-526216e2dd52	30bd11f5-56e6-4b2e-84d5-2e9124dd8494	\N	所属组织	70	active	作为灰烬之爪的精英成员，克劳对组织有一定归属感，但更多是相互利用的关系。他借助组织的情报网络追查灭门案，组织则利用他的战斗力处理脏活。	\N	\N	ai	2026-08-05 22:56:26.703372	2026-08-05 23:19:06.220801
a580fcf3-2860-462d-90b6-8e4b9ac893f2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	fc1e762e-6543-424b-b07d-4bb80aa494d0	7024257f-32d9-486c-a9c4-0508478121fe	\N	玛丽修女从日常照料者彻底转化为莱尔必须为之追查真相的逝去家人；果酱和烧黑念珠使这份责任具象化。	100	past	[第1章] 从单纯的抚养关系转变为带有秘密共享的微妙关系\n[第1章] 从单纯的抚养关系转变为带有秘密守护的复杂关系\n[第3章] 从抚养人变为逝者，成为复仇动力\n[第3章] 从抚养人变为逝者，成为复仇动力\n[第1章] 信任加深，但产生新的疑问\n[第1章] 从抚养人变为保护者，关系更紧密\n[第3章] 从抚养人变为逝去的保护者，悲痛加深\n[第1章] 双方对彼此的秘密共识进一步明确；莱尔确认她是知情者和保护者，亲密与依赖加深\n[第1章] 从一般的抚养与管教关系进一步显露为知晓核心秘密、愿意承担风险的保护关系\n[第2章] 莱尔继续遵守她关于保密的教导，并从她欺骗访客、烧毁地址的行为中进一步确认其保护者立场。\n[第2章] 从日常照料者进一步明确为替莱尔隐瞒核心秘密、主动承担外部风险的保护者。\n[第3章] 从依赖日常照料的家人关系转化为失去保护者后的哀恸与追查责任。\n[第4章] 玛丽修女从日常照料者彻底转化为莱尔必须为之追查真相的逝去家人；果酱和烧黑念珠使这份责任具象化。	\N	第3章	manual	2026-08-05 23:17:59.21544	2026-08-06 22:53:40.522791
cde0e457-13dc-43b0-a8a2-c2356150788d	7f6d28c4-2a32-46d1-887c-6cf5c4555056	fc1e762e-6543-424b-b07d-4bb80aa494d0	815122f4-2668-4b12-afe4-526216e2dd52	\N	烧黑的念珠和李子果酱唤起家庭记忆，使其丧亲悲痛进一步加深，并强化其追查袭击者的内在动力。	100	past	[第3章] 抚养人被杀，悲痛与愤怒\n[第3章] 抚养人被杀，悲痛与愤怒\n[第3章] 抚养人被杀，悲痛与愤怒加深\n[第1章] 继续处于被照料和管教的位置，无实质变化\n[第2章] 意识到玛丽修女在欺骗访客、保护异常者，对她的保护立场有了更明确认知。\n[第2章] 虽然尚不知道克劳的能力，但她对访客的统一否认客观上也保护了克劳。\n[第3章] 玛丽之死让照料者关系永久中断，克劳收藏缝衣针，显示其将她的死亡内化为哀悼和复仇誓言。\n[第4章] 烧黑的念珠和李子果酱唤起家庭记忆，使其丧亲悲痛进一步加深，并强化其追查袭击者的内在动力。	\N	第3章	manual	2026-08-05 23:18:46.718754	2026-08-06 22:53:40.522791
a21d33b8-c1e9-462c-93b9-04cc234dd54d	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7024257f-32d9-486c-a9c4-0508478121fe	8405510d-a2eb-48be-ad35-2b92426638a5	\N	战术合作关系初步建立，正式合作即将展开	100	active	[第6章] 尚未直接见面，但因其转介而形成间接业务联系\n[第6章] 从只听过名字转为实际向其输送特殊案件\n[第10章] 在合作中开始被对方怀疑能力\n[第10章] 从纯粹合作转入观察与审视\n[第13章] 珀西瓦尔全程观摩其取证手法，合作关系加深但并不打消对其能力来源的怀疑\n[第13章] 合作加深但审视目光未消，持续留意其信息获取方式\n[第10章] 取证和作战配合进一步成熟，莱尔愿意提供完整证据链并透露部分秘密，但仍保留最核心的信息来源。\n[第10章] 从程序性合作推进为能够互补作战、彼此调侃的实质伙伴关系，但审视并未消失。\n[第10章] 从互相试探的程序性合作推进为明确的战术互补：莱尔负责判断、破门和救人，珀西瓦尔负责正面制敌与保护队员；莱尔最后协助其处理伤势，也表现出隐藏在调侃下的关心。\n[第10章] 两人由口头互呛进入可以交付后背的实战伙伴阶段；不过莱尔隐瞒徽记信息，使珀西瓦尔的审视仍有继续发展的空间。\n[第10章] 从口头互呛进一步发展为实战中的高效协作，莱尔直接将人质救援任务交给珀西瓦尔\n[第10章] 对莱尔现场判断的信任显著上升，双方形成明确的战术分工\n[第10章] 形成明确的战术分工，现场配合默契\n[第10章] 默契的战术分工关系初步成形\n[第10章] 默契的战术分工关系初步成形\n[第10章] 战术合作关系初步建立，正式合作即将展开	\N	\N	analysis	2026-08-07 00:31:39.688659	2026-08-16 23:10:05.465956
06164b32-af31-499d-a6b5-fe9a325653e4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	0fa03f01-5ba6-41cf-84f6-75e525f762df	4f58eaf4-7fc6-4c1f-8631-0098395b6333	\N	从普通客人转变为令她惊讶的知名乐手	50	active	[第6章] 从普通客人转变为令她惊讶的知名乐手	\N	\N	analysis	2026-08-07 00:31:39.688659	2026-08-07 00:31:39.688659
01b1f483-fe74-4784-a1e2-9fd4acbdcfd6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8405510d-a2eb-48be-ad35-2b92426638a5	4f58eaf4-7fc6-4c1f-8631-0098395b6333	\N	对其代表的管理局抱有不满，但接受了他的私人建议	50	active	[第6章] 从报案人与受理人员转为转介者与被转介者\n[第6章] 对其代表的管理局抱有不满，但接受了他的私人建议	\N	\N	analysis	2026-08-07 00:31:39.688659	2026-08-07 00:31:39.688659
9f9caf98-9e02-4542-8b9a-edee2e2b546a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7024257f-32d9-486c-a9c4-0508478121fe	0fa03f01-5ba6-41cf-84f6-75e525f762df	\N	生活化默契得到确认（她知晓莱尔晚归、付账习惯等）	60	active	[第6章] 多年共同生活形成稳定、自然且接近家人的信任关系\n[第6章] 长期照料与默契进一步得到生活化确认\n[第8章] 生活化默契得到确认（她知晓莱尔晚归、付账习惯等）	\N	\N	analysis	2026-08-07 00:31:39.688659	2026-08-07 00:49:36.548008
1db9479b-b951-467e-b2ca-96aa7de5ea37	7f6d28c4-2a32-46d1-887c-6cf5c4555056	815122f4-2668-4b12-afe4-526216e2dd52	7024257f-32d9-486c-a9c4-0508478121fe	\N	依赖和信任增强	100	active	孤儿院一同长大的兄弟，失散多年后重逢。两人之间有着未解的心结和深厚的信任，克劳嘴上不说，但始终在暗中保护莱尔。\n[第2章] 信任加深，从童年伙伴向共同秘密的守护者转变\n[第2章] 信任加深，从童年伙伴向共同秘密的守护者转变\n[第2章] 信任加深，从童年伙伴向共同秘密的守护者转变\n[第2章] 信任加深，从童年伙伴向共同秘密的守护者转变\n[第3章] 共同经历惨案，信任进一步加深\n[第3章] 共同经历惨案，信任进一步加深\n[第3章] 共同经历惨案，信任进一步加深\n[第3章] 共同经历惨案，信任进一步加深\n[第4章] 信任进一步加深，共同决定自行调查\n[第4章] 信任进一步加深，共同决定自行调查\n[第1章] 注意到克劳的观察，关系未变但产生好奇\n[第1章] 从普通同伴变为关注对象\n[第2章] 从普通同伴变为互相信任的伙伴\n[第2章] 从关注对象变为互相信任的伙伴\n[第3章] 从互相信任的伙伴变为并肩复仇的战友\n[第3章] 从互相信任的伙伴变为并肩复仇的战友\n[第4章] 从互相信任的伙伴变为并肩复仇的战友\n[第4章] 从互相信任的伙伴变为并肩复仇的战友\n[第5章] 继续作为守护者存在\n[第6章] 信任加深，克劳首次透露灰烬之爪信息\n[第6章] 信任进一步加深，从守护者变为共同调查者\n[第1章] 克劳离开时投来默契眼神，体现两人已有熟悉而亲近的同伴互动\n[第1章] 通过离开时的默契眼神强化亲近的同伴感\n[第2章] 克劳单方面交付核心秘密，使莱尔成为其首位能力知情者，信任显著加深；但莱尔暂未对等坦白，形成隐性的关系压力。\n[第2章] 从默认的日常同伴升级为可以托付致命秘密的对象，克劳对莱尔的信任显著增强。\n[第3章] 两人的分歧公开爆发，但莱尔敢于按住克劳持刀的手腕，克劳最终接受其方案，显示双方已形成危机中的制衡与信任。\n[第3章] 莱尔从同行者进一步成为能在克劳失控时制止并说服他的唯一制衡者，危机信任显著加深。\n[第4章] 莱尔不仅照顾克劳的饮水和情绪，还替他保管、交出缝衣针，并在其可能失控时主动介入审讯；两人的关系进一步转化为高度默契的保护者与制衡者关系。\n[第4章] 克劳接受莱尔递来的热水、情绪判断和审讯安排，并将最重要的遗物交给他处理，显示其对莱尔的服从与信赖进一步加深。\n[第4章] 莱尔主动索要热水、遮挡观察窗并判断克劳的情绪状态，双方关系进一步转化为由莱尔负责判断与稳定、克劳接受其照料和安排的高度信赖模式。\n[第4章] 接受莱尔递来的热水、安慰和现场判断，在高度不安中仍愿意听从莱尔的节奏，依赖与服从进一步增强。\n[第5章] 从互不交底变为主动坦诚，信任关系进一步深化，成为共同守护秘密的伙伴\n[第5章] 依赖感增强，同时也在莱尔坦白后表现出更强的守护欲\n[第5章] 因坦白能力而加深信任，但同时背负愧疚\n[第5章] 依赖和信任增强\n[第10章] 依赖与默契加深\n[第10章] 依赖和信任增强	\N	\N	ai	2026-08-05 22:56:26.703372	2026-08-07 10:38:16.528346
a7ab469e-f3eb-4815-80cb-986f35465974	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7024257f-32d9-486c-a9c4-0508478121fe	ef11421f-5897-4eb3-92fd-2d3f5e8b4aa7	\N	由单纯怀疑转为承认能力、有限信任并设置监管边界	55	active	[第5章] 从陌生到互相试探的微妙关系\n[第5章] 从调查对象变为需要保护的特殊关注对象\n[第6章] 从怀疑对象变为重点调查目标\n[第6章] 从特殊关注对象变为被调查者\n[第5章] 从初识的调查官变为需要防范的对象，通过提问敏锐地否定了对方'未知情'的假设\n[第5章] 从普通的案件相关者变为重点观察对象，开始怀疑其拥有情报获得或感知能力\n[第5章] 开始怀疑对方刻意试探\n[第5章] 从普通证人变为重点观察对象\n[第13章] 证物库放行与反制计划获得默许，信任度上升但双方仍各自留有底牌\n[第13章] 从观察试探转为有限合作，信任度上升但底线未松\n[第10章] 从长期互相试探推进到有限互信；雷金纳德认可其能力价值，但同步设下证物程序边界\n[第10章] 由单纯怀疑转为承认能力、有限信任并设置监管边界	\N	\N	analysis	2026-08-06 12:57:40.830144	2026-08-15 00:51:21.764546
30ff74ef-583d-442b-a9ec-741301ac7551	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8405510d-a2eb-48be-ad35-2b92426638a5	ef11421f-5897-4eb3-92fd-2d3f5e8b4aa7	\N	继续保持局长与可靠行动员之间的指挥执行关系	50	active	[第13章] 严格执行局长指示，程序服从不变\n[第10章] 继续忠实执行局长命令，并承担将关键证据亲手上交的责任。\n[第10章] 继续忠实执行局长部署，并在行动中体现管理局的专业能力\n[第10章] 继续保持局长与可靠行动员之间的指挥执行关系	\N	\N	analysis	2026-08-07 11:12:30.34548	2026-08-15 00:51:21.764546
85cab21d-9e77-4c4a-a6a4-f29245d3a748	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8405510d-a2eb-48be-ad35-2b92426638a5	d2a9c865-d89a-468f-be17-49f2c471800a	\N	因对方冒险救援并以身体保护她而建立安全感与感激	60	active	[第10章] 以管理局行动员身份完成营救，并在爆炸中直接将她撞离危险区域，形成保护者关系。\n[第10章] 由普通执法者与受害者关系转为直接救援和保护关系\n[第10章] 因对方冒险救援并以身体保护她而建立安全感与感激	\N	\N	analysis	2026-08-15 00:43:31.399123	2026-08-15 00:51:21.764546
99ee14db-f2b8-44d2-964c-9e194a62e1ed	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7024257f-32d9-486c-a9c4-0508478121fe	d2a9c865-d89a-468f-be17-49f2c471800a	\N	因莱尔识破替身和组织营救而建立初步信任	100	active	[第7章] 由陌生的案件相关者转变为需要尽快确认是否遭受异常侵害的调查对象\n[第7章] 成为莱尔准备调查的潜在受害者或异常载体\n[第9章] 调查焦点重新回到锈蔷薇排练现场，为继续观察玛蒂尔达的异常状态做准备。\n[第9章] 确认对方为木偶替身，真身另有其人\n[第9章] 成为莱尔的营救目标\n[第10章] 视其为救命恩人\n[第11章] 信任进一步加深，成为她唯一能放心对话的人\n[第11章] 从救命恩人转为唯一愿意倾诉的对象\n[第14章] 莱尔不逼迫、只将鼓槌横放在鼓面上，令她获得安全感，信任继续累积\n[第14章] 持续以行动给予安全感，成为她唯一愿意靠近的倾诉对象\n[第10章] 通过克制使用武力、优先救出真人，进一步成为能够为她提供安全保障的人。\n[第10章] 莱尔成功识破并摧毁替身、救出真人，为其提供了明确的安全感。\n[第10章] 从陌生的营救者转变为实际救命者；莱尔以玩笑稳定她的情绪，并在爆炸中继续保护她，建立了明确的安全感。\n[第10章] 莱尔识破替身、救出真人并在爆炸中保护她，玛蒂尔达对其建立初步信任和安全依赖。\n[第10章] 莱尔识破替身并主导营救，使玛蒂尔达对其形成初步的救命信任\n[第10章] 因莱尔识破替身和组织营救而建立初步信任	\N	\N	analysis	2026-08-07 00:36:35.980122	2026-08-15 00:51:21.764546
218208da-8208-4085-b587-8ef81f921e0a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7024257f-32d9-486c-a9c4-0508478121fe	4f58eaf4-7fc6-4c1f-8631-0098395b6333	\N	信任和并肩感进一步增强	100	active	[第6章] 由陌生人转变为潜在委托人\n[第6章] 首次见面，建立潜在委托关系\n[第7章] 从潜在委托关系发展为初步合作关系，但吐真剂的出现使她对莱尔产生新的警惕\n[第7章] 从审视其能力转为有限信任和正式配合，随后因吐真剂再次提高戒备\n[第8章] 催眠请求被拒绝，合作意愿进一步受限\n[第8章] 维持合作但拒绝了催眠，信任出现边界\n[第8章] 合作仍旧但信任已出现边界\n[第9章] 莱尔按计划前往锈蔷薇排练，但本章截断前尚未产生明确的信任或立场变化。\n[第9章] 尚无明确变化，双方即将在排练现场重新接触。\n[第9章] 信任深化，形成联合行动默契\n[第9章] 信任进一步加深\n[第9章] 信任加深，共同承担秘密\n[第9章] 信任进一步加深\n[第10章] 信任进一步落地，成为共同经历过行动的同路人\n[第10章] 信任进一步加深\n[第11章] 合作中保留观察，注意到她的迟疑与沉默\n[第11章] 接受其安排但未完全坦诚，存在未言明的张力\n[第12章] 线索相互印证，调查默契增强\n[第14章] 依赖莱尔的证据支援，合作默契进一步增强\n[第14章] 调查与作战默契进一步加深\n[第10章] 双方在伪装排练、跟踪和营救安排上体现出高度默契。\n[第10章] 对莱尔的行动判断给予充分信任，调查与营救默契进一步增强。\n[第10章] 塞西莉完全执行其维持排练、欺骗替身的方案，双方调查默契和行动信任进一步增强。\n[第10章] 通过严格执行计划证明对其判断的高度信任，调查默契加深。\n[第10章] 塞西莉严格执行伪装排练计划，证明对莱尔判断和营救承诺的高度信任\n[第10章] 因莱尔兑现带回玛蒂尔达的承诺，信任和调查默契进一步增强\n[第10章] 信任进一步加深，塞西莉愿意压下情绪配合指挥\n[第10章] 信任和并肩感进一步增强\n[第10章] 信任和并肩感进一步增强\n[第10章] 信任和并肩感进一步增强	\N	\N	analysis	2026-08-07 00:31:39.688659	2026-08-16 23:10:05.465956
fca351e6-488f-46d3-9fa1-4ec307b787dc	7f6d28c4-2a32-46d1-887c-6cf5c4555056	4f58eaf4-7fc6-4c1f-8631-0098395b6333	d2a9c865-d89a-468f-be17-49f2c471800a	\N	挂念其安危，担忧加重	100	active	[第7章] 由普通长期队友转变为她必须秘密保护和调查的对象，责任感明显增强\n[第7章] 从合作六年的队友转为被其秘密担忧和保护的对象\n[第9章] 六年队友情谊与秘密担忧仍在延续，暂未出现新的明确转折。\n[第9章] 从担忧转为痛惜，决心救回真身\n[第9章] 从担忧转为痛惜，决心救回真身\n[第9章] 真身暂时与外界隔绝，替身维系表面关系\n[第10章] 从隔阂与担忧走向重新贴近\n[第10章] 重新接纳对方的陪伴\n[第11章] 信任度下降，感到对方在怕自己\n[第11章] 从亲密陪伴转为保持距离，信任出现裂痕\n[第12章] 信任裂痕开始愈合但尚未完全重建\n[第14章] 坦白后主动靠近，但玛蒂尔达因创伤本能退缩（"别过来"），信任修复仍有缺口\n[第14章] 对塞西莉的靠近本能退缩（并非不信任，而是创伤反应），关系修复受阻\n[第10章] 关系仍然深厚，但玛蒂尔达的本能躲避揭示创伤造成的新隔阂；塞西莉通过尊重边界开始修复。\n[第10章] 本能退缩造成短暂距离，但她接受了塞西莉留下的外套，并因同伴间的玩笑重新发笑，信任基础仍在。\n[第10章] 绑架事件强化了两人的情感依赖；塞西莉找回皮包并接纳玛蒂尔达暂时停止排练的要求，确认同伴身份不会因缺席而被取代。\n[第10章] 经历险些被替身取代后，两人的同伴关系得到情感确认；玛蒂尔达主动靠上塞西莉肩膀，塞西莉则以拥抱回应。\n[第10章] 同伴关系经过替身危机后得到重新确认，亲密度和保护欲显著提升\n[第10章] 通过询问鼓与接受拥抱确认彼此仍是最重要的乐队同伴\n[第10章] 挂念其安危，担忧加重\n[第10章] 挂念其安危，担忧加重	\N	\N	analysis	2026-08-07 00:36:35.980122	2026-08-16 23:10:05.465956
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.characters (id, project_id, name, age, gender, is_organization, role_type, personality, background, appearance, relationships, organization_type, organization_purpose, organization_members, main_career_id, main_career_stage, sub_careers, avatar_url, traits, created_at, updated_at, status, status_changed_chapter, current_state, state_updated_chapter) FROM stdin;
6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	d59e468a-8617-41e0-aabf-87a13be78834	石铁心	26	男	f	supporting	寡言而重情，眉宇间带着矿洞中磨砺出的沉稳。信奉拳头比话多有用，一旦认定某人便肯替对方挡刀，但对素来高高在上的天阶修士怀有深深的敌意。他极少提及自己过去在矿坑里见过的惨状，却会在深夜反复打磨那柄矿镐，镐刃上留着数十道暗红凹痕。嘴笨，哄女人的话一句也说不出，但谁对他好，他就用命去还。烦躁时习惯把指骨按得咔咔响，高兴时会粗声粗气地骂人。	幼年生于云梦泽边陲的灵役之家，世代为玄霄宗开采灵石矿。天赋觉醒日被测出空白灵格，按律本应终生为役。他靠着一身蛮力在矿坑中活下来，并偶然发现某些矿石粉尘能让天赋印记失去感应。为了救被送去试药的妹妹，他冒死潜入宗门，被张羽设计救出，从此死心塌地跟着张羽。他不懂什么天启真相，只知道那条从后颈连向天空的黑线，要将他身边最后一点温暖也抽走，所以他要亲手把那根线砍断。	身高近八尺，肩宽背厚，裸露的手臂上布满新旧交错的黑紫色伤疤。皮肤黝黑，左眉骨有一道肉色翻起的旧疤，衬得眼神格外凶。穿着翻毛皮甲，腰间挂一柄包浆厚重的矿镐，镐头被磨得发亮，握柄上缠着破布条。	张羽(救命恩人与战友): 张羽救了他妹妹，他从此甘为张羽手中最锋利的一柄铁镐，不问缘由。; 柳若霜(义兄妹): 把柳若霜视作另一个妹妹，嘴上叫她柳丫头，私下会把省下的肉干悄悄塞进她的药袋。	\N	\N	\N	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	2	\N	\N	["矿镐搏击：蛮力惊人，能以矿镐硬撼低阶修士的灵兵", "天赋干扰感知：近距离可察觉修行者身上的收割之索走向", "坚韧体魄：长年吸入矿尘，对迷药与剧毒有很强的耐性"]	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369	active	\N	\N	\N
a4d5f38f-fea9-4947-8fc7-624ff8743955	d59e468a-8617-41e0-aabf-87a13be78834	苏晚棠	20	女	f	supporting	人前是没心没肺的甜嗓少女，人后是冷静得近乎冷酷的捕手。擅长用笑声和话痨掩盖内心的计算，聊着聊着就把对方底细掏空。唯一的破绽是害怕独处，一旦夜深入静，她会反复擦拭自己空空如也的掌心，好像那里本该有什么东西。习惯思考时不停绞发梢；撒谎时会下意识先低头笑一声。她对世间温情的理解大多来自任务中的伪装，因此最讨厌被人真心相待，因为那会让她动摇。	自幼被天衡司暗部收养，因天赋空白被选入特殊行动序列，受训成为一名清道夫，专门负责监视、策反与清除破妄者。天衡司向她承诺，只要完成任务，就为她植入人造天赋印记，让她摆脱异类身份。她奉命潜入玄霄宗履冰院，以玄阶弟子身份接近张羽并搜集破妄者情报。可当她真的混入这群被世界抛弃的人之中，看着他们用假天赋救下比自己更弱的人时，密报越写越慢，心中天平也逐渐倾斜。	身高五尺出头，脸圆眼大，扎着一条及腰的高马尾，笑起来像只没心眼的松鼠。常穿浅蓝色履冰院弟子服，袖口总被自己裁短三寸，露出白皙的小臂。腰间挂着一串木铃铛，走起路来叮当作响，让人对她提不起防备。	张羽(敌意纠葛): 奉天衡司之命潜伏在张羽身边搜集证据，却一次次被他护住弱者的举动动摇，任务与良知撕扯得她夜不能寐。; 墨渊(怀疑对手): 她总觉得这个藏经阁的老头深不可测，每次经过都会下意识绕开他的视线，两人交锋如同隔空对弈，谁也没先亮底牌。	\N	\N	\N	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	2	[{"career_id": "f3e0994d-cca9-459e-8086-cbabc79c3a93", "stage": 1}]	\N	["语言伪装：模仿口音和语气几乎以假乱真，能一句话扭转谈话方向", "追踪反追踪：擅长利用药粉和杂物布置视野盲区", "记忆宫殿：靠独门记忆法将天衡司密报分门别类藏在脑中"]	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369	active	\N	\N	\N
aff03d10-b083-4bde-a165-34e8c9b3f9a8	d59e468a-8617-41e0-aabf-87a13be78834	墨渊	52	男	f	supporting	看似邋遢懒散，话里话外透着一股看破红尘的颓丧，实则敏锐到让人脊背发凉。他极度谨慎，宁可多绕十步也不肯暴露行迹，但护短时又会露出年轻时锋芒毕露的傲气。嘴巴毒，总能把敲打的话裹在一堆书袋里说出来，让聪明人自己冷汗直冒。缺点是大半生都在逃避，当年斩断收割之索时吞下的恐惧让他至今不敢再碰真正的战斗，只有面对张羽时，他才想起自己也曾是挥剑问天的少年。	本名萧承影，五十年前玄霄宗最耀眼的天阶天骄，二十四岁便臻至凝魂境。突破瓶颈之际，他隐约听见天赋印记中传来不属于自己的心跳声，旋即发现一条黑线从后颈直通天穹。为了斩断魂契，他以三成寿元为代价强行剥离天赋印记，侥幸未死，却从天才沦为废人。他隐姓埋名龟缩于藏经阁残卷库，以墨渊之名看守那些无人问津的真相。直到他撞见一个能徒手画出收割之索的杂役，才重新拾起多年前的夙愿。	身形瘦高，背微驼，灰白发丝用一根乌木簪束成散髻，消瘦的面庞上嵌着一双既浑浊又锐利的眼睛。穿洗得发白的黑色儒衫，袖口和指尖都有洗不掉的墨渍，走路时左腿微跛，据说旧伤所致。腰间挂着一串褪色的铜钥匙，走起路来轻响，像提醒所有想靠近的人离他远些。	张羽(师徒): 以半本残卷为饵，将张羽引进破妄之门，嘴上说是闲得慌，实则把当年未竟的路都寄托在这个青年人身上。; 苏晚棠(警觉的对弈者): 一照面就看出她身上的天衡司气息，却按兵不动，想利用这条线钓出真正的幕后黑手。; 柳若霜(忘年交): 嘴上嫌弃她送来的草叶品相太差，转头却默默练成丹药塞回她的药袋，永远不肯承认自己关心她。	\N	\N	\N	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	3	[{"career_id": "f3e0994d-cca9-459e-8086-cbabc79c3a93", "stage": 2}]	\N	["断索残识：虽失去天赋印记，却保留了对魂契气息的高度敏感", "藏书暗目：能将百余本残卷的内容交叉引证，找出被刻意掩盖的线索", "枯木炼丹：用废弃灵草炼制成品的成功率极高，堪称化腐朽为神奇"]	2026-08-05 13:41:25.824369	2026-08-05 13:41:25.824369	active	\N	\N	\N
8718a55c-f7bd-4d24-b911-4220673dc052	d59e468a-8617-41e0-aabf-87a13be78834	玄霄宗	\N	\N	t	supporting	玄霄宗外表恪守天启圣约，以正道魁首自居，实则将天赋崇拜推演到极致，将天赋品阶当作划分人与工具的唯一标尺。宗门内部执行隐秘的魂契收割制度，高阶长老暗中以秘法催化弟子突破，收割其成熟神魂，用以供给天启之门背后的意志。对外，玄霄宗展现为一个等级森严但井然有序的仙门典范，对内则充斥着残酷的竞争、监视与永不停止的吞噬。宗门高层信奉天道之上仍有天道，认为一切生命都只是通往更高境界的燃料，而天赋越高者燃料越纯净。他们行事缜密，善用伦理和礼法束缚低阶弟子，以荣耀为枷锁，以希望为诱饵，让所有人在甜蜜的谎言中走向收割之日。	玄霄宗创建于天启之门降临后的第三十年，是大陆东域最早归顺天赋体系的宗门之一。第一代祖师本是凡阶散修，因意外发现通过魂契反向汲取天赋印记中的意志可突破天赋桎梏，由此创立宗派。此后三百年间，玄霄宗以培养天才、守护天启为名，暗中构建起一套完整的收割链条。他们利用测灵石碑筛选天阶地阶弟子，送入摘星台、御风阁精心培养，又在履冰院和杂役坊中豢养低阶者充当劳力与备用的残灵养分。历代宗主以天启神谕为至高法则，选拔天阶弟子作为圣种，由长老团以灌顶名义植入更深的魂契种子，待其突破元婴境界后，即启动收割大阵，将弟子神魂完整剥离，化为天启之门前的祭品。玄历一三五零年左右，宗门某任宗主曾试图改革，但不足三月便离奇暴毙，魂灯熄灭，此后再无一人敢质疑此道。如今玄霄宗表面上贵为东域三大宗门之首，实际上其根基已与天启之门背后的收割意志深度绑定，无法回头。	玄霄宗坐落于云梦泽深处的天柱峰，群山如剑戟直插云霄，峰顶常年缠绕着由灵气汇聚而成的五色霞光。宗门主体建筑以琉璃瓦与白玉为材，华丽到近乎病态，匾额上雕琢着繁复的祥云纹路，纹路缝隙中常嵌着干涸的暗红粉末。山门之下是绵延百里的天禀城，城中铸有高达九丈的青铜问天柱，柱身刻满历届天赋榜前十的姓名，象征荣耀与阶层。宗门内部按天赋品阶划分区域：天阶弟子居摘星台，地阶弟子居御风阁，玄阶弟子居履冰院，低阶者与杂役挤在杂役坊。所有正式弟子皆身着月色长袍，前襟绣有问天柱图案；高层的袍角以金线绣出云纹，纹路中隐约可见若有若无的暗红脉络。空气中常年弥漫着灵药残余的甜腥味，即使再明亮的阳光也盖不住那股源自灵血炼器的细微腐气。	\N	宗门	玄霄宗的公开宗旨是承天启之道，育百家之才，护人间之正。私下的真实目的是围绕天赋伴生体系建立一条完整的神魂收割流水线，选拔天赋异禀者，培养至足够丰盈的程度，再将其印记与神魂一并献祭给天启之门背后的意志，以此换取宗门高层突破境界的资格与持续存在的权柄。行动准则包括严格维护天赋等级制度，任何质疑天赋体系的行为都按亵渎天启处置；控制信息与舆论，封锁所有与灵识迷失、天赋蛊虫相关的消息；对外维持正道魁首的形象，以问天大会表演资质收购的荣耀戏剧；对内则利用淬灵丹、灌顶秘法等手段潜移默化地深化魂契，使弟子在不知情中完成自我奉献。	\N	\N	\N	\N	\N	["天赋品阶等级制度", "神魂收割体系", "表面正道魁首", "信息封锁与洗脑", "以身饲道的悲壮伪装"]	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751	active	\N	\N	\N
7833c3ce-3d10-4780-865d-e77550aa78ed	d59e468a-8617-41e0-aabf-87a13be78834	天衡司	\N	\N	t	supporting	天衡司表面恪守天启圣约，以公正严明的面目统管大陆一切天赋事务，实则是一座精密运转的收割机器。司内等级森严，公文如山，每一条看似繁琐的测灵流程都暗含对灵魂的盘剥。司吏们奉行'秩序高于悲悯'的信条，将个体痛苦视为文明进程中理所当然的损耗。他们用刻板律条与华丽的仪式感包裹残暴——记档时温言细语，勾决时手起刀落。整个机构弥漫着一种官僚式的冷漠狂热：上至司主，下至录事，皆以维护天赋体系的神圣性为毕生荣耀，任何质疑都会遭到制度化的清洗。天衡司不追求开疆拓土的赫赫武功，而是以滴水不漏的文书与无处不在的耳目，将整个大陆牢牢钉在既定的天赋阶梯上。	天衡司创立于天启之门降临后的第十年，由初代天启使与大陆诸国共立，最初只是登记天赋名录、调解宗门争端的协调机构。随着天赋伴生体系成为社会基石，天衡司的权力不断膨胀，逐渐收编各地方监察力量，形成覆盖全大陆的垂直体系。玄历一一九零年，天衡司颁布《天启法典》，将测灵、觉醒、修行、晋升全部纳入律法管控，任何拒绝测灵或私解魂契者皆以亵渎天启论处。此后三百年间，天衡司通过积累魂契观测数据，秘密协助天启之门完善收割路径，甚至推动每三年一次的'问天大会'，以资质收购之名完成对高阶修士的集中标记。如今的司衙总部设在中州皇城'钧天府'，下设八方巡查司，职责早已从记录者变为审判者。玄霄宗等大宗门表面上推崇天启圣约，暗地里也不得不仰仗天衡司的测灵分配与资质流动，二者在利益与猜忌中维系着脆弱的平衡。	天衡司的标识是一只银质天平，托盘一端悬着散发微光的灵珠，另一端压着一枚钥匙，寓意天赋即天命、天命需权衡。司员统一身着玄青官袍，领口与袖口绣有银色天平纹样，腰悬青铜令牌。各级测灵石碑均由天衡司监造，碑身底部刻有细微天平印记。总部钧天府中轴矗立着一座九层钧天塔，塔身由黑曜石砌成，表面以金线嵌出大陆全域的测灵分布图，每逢时辰轮转，金线便如活络的血脉般流淌光芒。各城分司则普遍设在测灵石碑广场附近的青石院落中，门口常年摆着两块告示牌，一块贴满寻人启事，另一块贴着盖有朱红印章的天赋等级变更文书。	\N	政府机构	天衡司以维护天赋体系的权威与稳定为最高宗旨，对外宣称确保天赋公平评定、保障修行秩序、防范灵识迷失之灾。暗中则以延续天启之门的收割循环为终极使命，通过建立覆盖大陆的魂契档案库，监控每一个觉醒者的晋升轨迹，在临界境界触发收割时抹除痕迹、封禁消息。行动准则包括：凡测灵必录档，凡觉醒必立契，凡迷失必归因于心魔，凡质疑必以亵渎论处。其长期愿景是让天赋伴生体系永续运转，让大陆众生相信金光即是救赎，而他们自身则是金光之下唯一执掌天平的人。	\N	\N	\N	\N	\N	["魂契档案库", "测灵监察网", "仪式性官僚制"]	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751	active	\N	\N	\N
27635aa9-65ae-48a8-8842-62dc121d86f0	d59e468a-8617-41e0-aabf-87a13be78834	张羽	18	男	f	protagonist	外表恭顺谨慎，实则心思缜密、冷眼观世。从小镇农户到玄霄宗杂役坊，他习惯了用自嘲和沉默掩盖真实的自己。骨子里带着来自现代社会的平等观念，对高高在上的天赋阶层本能地反感，却又能将这份不屑藏得滴水不漏。缺点是过于多疑，一旦认定某事便咬住不放，偶尔会因过度谨慎而错过良机。习惯在思考时用指腹摩挲左手腕上一道旧疤；独处时喜欢用树枝在地上画东西，那是他前世留下的草稿习惯。	前世是研究植物药理的青年学者，意外坠崖后穿越至天澜大陆边陲小镇，成为农户之子。满月测灵时石碑毫无反应，被同龄人视作天弃之人。十六岁觉醒日，他当着全村人的面与测灵石碑对视，看见石碑顶端缠绕着一根伸向天空的黑线，由此确认这方世界的天赋另有蹊跷。为免被征为灵役，他以篡改的灵草汁液伪造低阶天赋，混入玄霄宗杂役坊，白天打杂，夜间潜入藏经阁残卷库，寻找天赋伴生体系的真相，同时修炼出属于自己的无痕破妄之力。	身形清瘦，肩背微弓，五官平凡但一双黑眸总是半阖着，像在打量什么细碎的光影。穿着洗得发白的灰麻短打，袖口总沾着草汁与药渍，腰间挂一只鼓鼓囊囊的旧皮囊，里面插着碾槽、铜勺和几把干枯的灵草。		\N	\N	\N	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	2	[{"career_id": "f3e0994d-cca9-459e-8086-cbabc79c3a93", "stage": 1}]	\N	["破妄视野：能看见修行者后颈连接向天穹的收割之索", "草木药理：前世知识加上今生采集经验，懂得调制伪装天赋的药剂", "过目成诵：翻阅残卷速度快且记得牢，能在脑中拼凑出被撕毁的记录"]	2026-08-05 13:41:25.824369	2026-08-05 14:00:13.616189	active	\N	触及秘密边缘的潜伏者	3
0f0ef402-3ad1-45fc-be6a-582774193d14	d59e468a-8617-41e0-aabf-87a13be78834	柳若霜	17	女	f	supporting	自幼家道中落，使她养成既倔强又柔软的矛盾性子。对草药有天然的亲近感，说话轻声细语，却能在关键时刻表现出惊人的狠劲。她记忆力极好，能从一炉废丹的余烬中推测出配方；也因此格外能忍，为了拿到一株完整的天星草，可以在毒雾里蹲上半日。缺点是太过在意他人眼色，总觉得自己拖累了身边的人，偶尔会把自责藏在微笑后面。	祖上曾是玄霄宗外门执事，因族中一位天阶天才在境界突破后突然灵识迷失、沦为傀儡，全族被迫迁出玉阶，贬入杂役坊。她在十六岁觉醒日被测出天赋空白，被父亲含泪藏起测灵石碑碎块，谎称已登记为玄阶，保住了最后的体面。她白天在药圃当值，晚上偷偷为张羽的药剂实验提供废弃灵草，是最早得知无痕破妄秘密的人之一。	身形单薄，面色偏白，眉眼细长，像一幅被水汽浸过的画。总穿着不合身的土色旧衫，发丝用一根素木簪子挽起，手上常有刮伤和草汁痕迹。笑起来时嘴角有浅浅的梨涡，让人觉得她并不属于那些阴暗的角落。	张羽(知己): 在杂役坊的灰暗岁月里互为依靠，她是张羽唯一敢暴露伪造天赋真相的人，也是他实验药剂的秘密试药者。; 石铁心(义兄): 石铁心把她当成亲妹妹护着，她也把石铁心当作可以撒娇的兄长，但心里总怕自己的身世会连累他。	\N	\N	\N	8b05f9ca-f43e-4ce8-b646-2a4f35c54ac8	1	[{"career_id": "f3e0994d-cca9-459e-8086-cbabc79c3a93", "stage": 1}]	\N	["废丹断方：单凭气味能反推出被丢弃丹药的部分配方与火候", "药草辨伪：五十步内闻出灵草真假", "心算天赋：能同时记住十几件药圃采收排序，绝不出错"]	2026-08-05 13:41:25.824369	2026-08-05 14:00:13.616189	active	\N	将关键线索托付给张羽的知情者	3
30bd11f5-56e6-4b2e-84d5-2e9124dd8494	7f6d28c4-2a32-46d1-887c-6cf5c4555056	灰烬之爪	\N	\N	t	supporting	灰烬之爪是一个行事隐秘而高效的佣兵组织，信奉利益至上和实力为尊。组织内部等级森严，采用代号制，成员以爪印纹身作为身份标识。他们承接各类灰色任务——从情报窃取、武装护卫到暗杀破坏，只要价格合适，没有不敢接的活。组织作风冷酷务实，从不感情用事，但极重信誉，一旦接下任务便必定完成。他们的据点遍布灰港城地下，以废弃排水隧道为骨干，连接着码头仓库和旧防空洞，形成了一个庞大的地下网络。	灰烬之爪是这个世界上最大的佣兵组织，在每个城市的灰烬酒馆中都能发布佣兵任务。面对各类问题（除违法之外）都可以在这里发布与寻求解决。	灰烬之爪的据点隐藏在城市地下废弃的排水隧道中，入口位于锈带区一处废弃的罐头厂地下，需要穿过三道伪装暗门才能进入。据点内部由数个大型蓄水池改造而成，布满错综复杂的管道和密室，中央大厅悬挂着一面巨大的黑色旗帜，上面绣着一只燃烧的爪印。大厅四周是铁架搭建的宿舍和武器库，空气中弥漫着机油、铁锈和火药的气味。	克劳·沃尔特(所属成员): 克劳是灰烬之爪的精英行动员，组织对他有知遇之恩，但克劳对组织更多是相互利用，他借助组织的情报网追查灭门案。	佣兵集团	承接正常或灰色任务，解决一些官方不处理的事件	\N	\N	\N	[]	\N	["地下网络", "武装力量", "情报交易"]	2026-08-05 22:56:26.703372	2026-08-06 12:58:30.040484	active	\N	组织首次被明确提及，与玛丽修女之死及雷金纳德有关联，势力范围不明。	6
8fd6410d-f1e5-4496-8e2e-7c458842f9a8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	晨星孤儿院	\N	\N	t	supporting	\N	由玛丽修女创办的一个小孤儿院，单独一人抚养10余个孤儿。因为有政府的补贴，日子不会过于拮据。玛丽修女待人和蔼可亲，做饭也很好吃，孩子们都很喜欢玛丽修女。	\N	\N	孤儿院	抚养被遗弃的孩子们	\N	\N	\N	\N	\N	\N	2026-08-05 23:27:30.561466	2026-08-06 15:47:58.844091	active	\N	孤儿院遭到有组织的暴力袭击，玛丽修女、工作人员及多数孩子遇害，萨姆失踪，场所被封锁调查，原有照料与生活功能事实上陷入停摆。但莱尔、克劳仍然存活，萨姆下落未明，且尚未正式宣布机构解散。	3
c98b5011-461a-4d2e-a688-62a8cfc1d808	7f6d28c4-2a32-46d1-887c-6cf5c4555056	治安管理所	\N	\N	t	supporting	\N	\N	\N	\N	警察局	维护治安，保障公民安全，处理非异常事件的警务	\N	\N	\N	[]	\N	\N	2026-08-05 23:29:54.977626	2026-08-05 23:30:04.802998	active	\N	\N	\N
c9e05d0e-7553-4795-b57d-3019fa912aa9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	异能管理局	\N	\N	t	supporting	异能管理局是灰港城官方设立的异能者管理机构，表面秉持秩序与稳定的核心理念，宣称通过登记、监管和引导来保护普通民众免受异能失控的威胁，同时为异能者提供庇护与医疗支持。然而在实际运作中，管理局内部充斥着官僚主义的僵化与冷酷的实用主义，高层更倾向于将异能者视为可消耗的资源而非公民。其行事风格以规章流程为掩护，常以安全为名行压制之实，对待黑户异能者尤为严苛，对底层异能者缺乏同情，而对待权贵阶层的异能者则表现出明显的妥协与配合。管理局内部层级分明，分工细致，设有登记科、监察科、执行科和研究所等机构，各科室之间既有协作也存在推诿与内斗。其文化价值观强调忠诚与服从，对规则的解释权牢牢掌握在高层手中，底层职员往往在理想与现实之间挣扎，逐渐被体制同化。运作方式以情报网络和强制手段为基础，通过线人、监控和定期检查维持对异能者的控制，同时利用义务任务制度将异能者投入危险工作以换取有限的资源，本质上是一种变相的剥削。	异能管理局成立于三十年前，正值异能觉醒现象大规模爆发、社会秩序陷入混乱的时期。当时的灰港城因港口贸易的繁荣吸引了大量外来人口，异能者数量激增，失控事件频发，贵族议会与财阀为维护自身利益，联合推动成立了异能管理局，作为官方唯一的异能事务处理机构。管理局最初的功能仅限于登记和应急响应，但随着权力扩张，其职能逐渐覆盖异能者的户籍管理、代价评估、义务任务分配、异常事件调查以及黑户追捕。	异能管理局的总部是一座灰白色花岗岩建筑，矗立于白塔区中央广场东侧，高八层，外墙刻有浮雕纹章——一只被锁链缠绕的眼睛，象征监视与约束。建筑正面悬挂着巨大的金属徽章，底色为深蓝，中央是一只银色的天平，两侧延伸出机械齿轮，底部刻有字母缩写ABM。总部大门前常年停着黑色装甲车，车窗贴有防爆膜，车身上印有同样的徽章。管理局职员统一穿着深灰色制服，领口和袖口缀有蓝色条纹，胸前佩戴金属身份牌，执行科人员则配备黑色战术背心和电击棍。总部内部以冷色调为主，走廊灯光惨白，墙壁上挂满规章制度告示和通缉令，登记大厅设有金属隔断和防弹玻璃窗口，气氛压抑而机械。	\N	政府机构	异能管理局的官方宗旨是维护社会秩序，保护普通民众安全，促进异能者与普通人和谐共存。其长期愿景是建立一套高效、可控的异能管理体系，使异能者成为社会发展的助力而非威胁。行动准则强调依法行事、程序正义，但在实际执行中，管理局更注重结果导向，倾向于以最小代价平息事端，甚至不惜牺牲个体权益。其核心目标包括：全面登记所有异能者，消除黑户现象；定期评估异能者状态，预防代价失控；执行义务任务分配，确保异能者对社会有所贡献；调查并处理异能相关犯罪，维护法律权威。	\N	\N	\N	[]	\N	["官僚僵化", "监控严密", "权贵附庸"]	2026-08-05 23:31:56.12292	2026-08-15 00:43:31.425298	active	\N	虽然临时搜查申请未获批准，但行动组通过现场留影、活体受害人、成品替身、控制媒介和账簿建立了完整证据链，并成功拘押一名执行者，显著推进操偶案件调查。	10
fc1e762e-6543-424b-b07d-4bb80aa494d0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	玛丽修女	42	女	f	supporting	温柔耐心：从不居高临下地说教，换位思考，耐心教导孩子们。	孤儿院唯一的一名成人，负责照顾孤儿的日常生活，并负责教导他们，指引他们为人正直善良健康成长。	眼睛是很浅的褐色，像泡开的茶；烛光下显得格外温和。日常围围裙、袖口挽起；正餐时换干净的棉布裙。	莱尔·西奥多(合作伙伴): 各取所需的合作关系。艾莉西亚向莱尔提供白塔区的内部情报，莱尔则帮她调查异能登记局的隐秘实验。两人之间有着微妙的信任和防备。; 书灵议会(暗中调查对象): 艾莉西亚隐约察觉到书灵议会的存在，认为他们才是操纵世界运转的幕后黑手，并试图通过莱尔接触这个组织的边缘。	\N	\N	\N	\N	\N	[]	\N	["政治博弈", "情报分析", "社交伪装"]	2026-08-05 22:56:26.703372	2026-09-19 22:01:57.803629	deceased	3	死亡（第3章）	3
8405510d-a2eb-48be-ad35-2b92426638a5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	珀西瓦尔·费尔班克斯	23	男	f	supporting	认真负责，工作表现优秀，对工作有强烈使命感	格雷文赫异常管理局新人员工。能力是身体强化，全面提升身体素质——力量、速度、耐力、反应速度，在激活瞬间如同换了一个人。代价是一段时间后肌肉剧烈酸痛，程度与强化的时长和强度正相关。轻度使用后酸痛几小时，极限使用后可能酸痛数天，严重时连抬手都困难。\n因此会在制服口袋里揣一包止痛贴	短发，精神利落，面容年轻但眼神认真。身材匀称，不算壮硕但有明显的锻炼痕迹。常穿管理局标准制服，制服总是整理得一丝不苟，连领口的风纪扣都扣得严实	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-08-06 23:30:27.883997	2026-08-07 11:12:30.34548	active	\N	严格依程序配合取证，亲眼看见莱尔"读出"账簿压痕后怀疑加深；对薇奥拉借用口供抢占先机感到愤怒	13
ef11421f-5897-4eb3-92fd-2d3f5e8b4aa7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	雷金纳德·洛克哈特	44	男	f	supporting	城府极深，从不在没有把握时亮牌，对任何人都保留三分试探。规则有灵活的解读，知道什么时候该睁一只眼闭一只眼，也知道什么时候必须铁面无私。对这座城市有深沉的责任感，不会为了个人得失放弃保护市民	灰港城下的分所局长，有强大的战斗异能：\n1. 控火：操控火焰进行攻击与防御 ，代价是身体持续高温，长时间使用身体会从内向外焚化\n2.控水： 操控水流进行攻击与防御，代价是身体逐渐被水包围（从脚到头），长时间使用会溺死\n\n局长的两个能力单独使用都是自杀行为，但同时发动时形成完美闭环：\n  - 火焰蒸发水分 → 避免溺死\n  - 水流降温 → 避免焚化\n  - 水火碰撞 → 产生高温蒸汽，既是攻击手段（蒸汽灼伤），又是防御屏障（遮蔽视线+高温区域）\n  - 但蒸汽领域有极限——一旦某一方的消耗超过另一方的补给速度，代价就会失控	寸头，面容棱角分明，眼角有深深的纹路。体格健壮，肩宽背厚，穿管理局制服时像一座移动的墙壁	\N	\N	\N	\N	\N	\N	[]	\N	\N	2026-08-05 23:34:33.298302	2026-08-07 11:12:30.34548	active	\N	有限放权给莱尔查看证物，并默许其"先别抓"的冒险计划	13
4f58eaf4-7fc6-4c1f-8631-0098395b6333	7f6d28c4-2a32-46d1-887c-6cf5c4555056	塞西莉·辛克莱	20	女	f	supporting	冷静心细	锈蔷薇乐队贝斯手，是锈蔷薇案件中的委托人	容貌秀丽，头发拢到耳后，穿排练便装时利落，登台时有舞台妆。	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-08-06 23:32:49.904873	2026-08-07 11:15:47.485565	active	\N	当众坦白并澄清泄密真相，卸下自我怀疑，但走向玛蒂尔达时被对方本能躲开，又添新的隐痛	14
d2a9c865-d89a-468f-be17-49f2c471800a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	玛蒂尔达·斯特林	19	女	f	supporting	直爽	锈蔷薇乐队鼓手，手腕极活，是乐队节奏的底子	利落的短发	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-08-06 23:35:17.511532	2026-08-07 11:15:47.485565	active	\N	排练闪回绑架场景，鼓槌脱手，手指无法合拢，当场崩溃，坦言"我不会打鼓了"	14
d692271c-83b6-492f-b402-090750c2828e	7f6d28c4-2a32-46d1-887c-6cf5c4555056	西奥多侦探事务所	\N	\N	t	supporting	以不起眼的日常委托为掩护，在都市缝隙间寻找被湮没的真相。奉行小事求真、大隐于市的准则，不张扬、不越界，却也不曾真正停下。事务所分工简单：莱尔负责定案与最终判断，塞西莉掌管档案与情报，珀西瓦尔跑外勤和线人。对内线索共享，对外礼貌克制，按规矩接案，对官方始终保持谨慎距离。莱尔信奉细节与逻辑胜过直觉与异能，因此办案更依赖观察走访与档案比对，而非触碰超越权限的异常事件。若委托人被卷入异常，他们会在规则边缘小心走一趟，尽量不让粒子监测仪盯上。整个事务所的底色是耐心与执念，像猫蹲守老鼠一样等着属于他们的时机。		从老巷边一道窄木梯上去，二楼便是事务所。临街的窗台上摆着一盆月季，推门先看到会客用的旧沙发，对面墙壁钉满街区地图和照片，书架上塞着市政档案、旧报纸和异常事件剪报。桌上一台老式打字机，下层抽屉锁着真正重要的记录。门口挂着一块铸铁招牌，刻着西奥多侦探事务所，边角已经生锈，招牌背后缀了一枚小小的铜制月季。	\N	民间调查机构	表面目标是以日常委托谋生并维持事务所运作；核心目标是查明十五年前晨星孤儿院灭门惨案真相，还逝者以公正，并最终摆脱写定命运的束缚。长期愿景是在格雷文赫城建立一个可以信赖的情报节点，让更多被命运脚本困住的人有机会选择自己的路。行动准则是不露锋芒、不越红线、不负托付；任何线索都登记在案，任何委托都有始有终。	\N	\N	\N	[]	\N	["以琐碎委托为掩护的调查节点", "游走于规则边缘的谨慎作风", "依靠观察与逻辑而非异能破局"]	2026-08-06 23:57:50.217738	2026-08-07 00:00:49.525752	active	\N	\N	\N
fd004e38-2270-429e-b8ac-289b4088b5cf	7f6d28c4-2a32-46d1-887c-6cf5c4555056	月季咖啡厅	\N	\N	t	supporting	\N	\N	\N	\N	咖啡厅	房东格蕾丝太太经营的月季咖啡厅，莱尔日常在此用早餐。	\N	\N	\N	\N	\N	\N	2026-08-07 00:01:18.68888	2026-08-07 00:01:18.68888	active	\N	\N	\N
0fa03f01-5ba6-41cf-84f6-75e525f762df	7f6d28c4-2a32-46d1-887c-6cf5c4555056	格蕾丝	51	女	f	supporting	和蔼可亲	莱尔的房东，主营一家咖啡厅	精神抖擞	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-08-07 00:02:02.441342	2026-08-07 10:21:38.759796	active	\N	照常提供支持，未卷入核心冲突	9
7024257f-32d9-486c-a9c4-0508478121fe	7f6d28c4-2a32-46d1-887c-6cf5c4555056	莱尔·西奥多	28	男	f	protagonist	极度冷静：遇到任何突发状况，第一反应不是慌张，而是观察、分析、计算——大脑永远在运转，像一台永不休眠的推理机。\n处事吊儿郎当：上一秒还在严肃讨论案件线索，下一秒突然聊起今天咖啡的豆子不对味；签委托合同时先跟客户讨论天气，拿到报酬时反而表情严肃。这种反差让初次接触的人很难把他当回事——而他恰恰需要别人"不当回事"\n\n**智慧驱动**：解决案件靠的不是异能、武力或运气，而是精密的推理、信息拼图和心理学操控。他的异能只是辅助工具，真正的武器是脑子。遇到复杂案情时，他会像拆解机械一样把问题拆成无数个可验证的小假设，逐一排除	孤儿院的孤儿，自幼与克劳相依为命，有两个异能：\n1. 欺骗 : 让听者相信你说的话的概率大幅提升（越贴近事实，成功率越高） 。代价是下一个询问你问题的人，你的回答必须说真话\n2. 时视回溯：触摸物体后，以该物体在特定时间点的第一视角获得视觉/听觉等感官画面，代价是物体会受到不同程度的损坏（回溯时间越长、信息量越大，损坏越严重）	棕黑色短发，整齐但不刻意打理，几缕碎发偶尔垂在额前——看似随意，实则从不遮住视线。身形中等偏瘦，但力气不小，身手敏捷。服装虽不昂贵但始终整齐干净，从不出现在公众面前衣冠不整的模样。		\N	\N	\N	\N	\N	[]	\N	["概率欺骗", "时视回溯", "逻辑推理"]	2026-08-05 22:56:26.703372	2026-09-19 22:01:49.104431	active	\N	听证胜诉后面色平淡，合上空箱，转而第一时间关注玛蒂尔达的状态	14
815122f4-2668-4b12-afe4-526216e2dd52	7f6d28c4-2a32-46d1-887c-6cf5c4555056	克劳·沃尔特	28	男	f	supporting	沉默寡言，行动先于言语，像一把随时可能出鞘的利刃。外表冷漠无情，实则对认定的伙伴忠诚到近乎偏执。行事狠辣果决，信奉以暴制暴的丛林法则，但从不伤及无辜。有收集战利品的习惯，每完成一次任务都会从目标身上取一件小物件，锁在铁盒里，仿佛在记录自己的罪孽。表面看起来对灭门案已经释怀，实则从未放弃追查，只是将愤怒和痛苦都压在冰冷的表面之下。偶尔会在喝醉时流露出脆弱，但第二天醒来又恢复如初。	孤儿院灭门案的另一名幸存者。因为异能偏向战斗相关：身体接触的工具可以切断任何事物——物理切割、能量切断、甚至概念层面的"切断"（如切断追踪、切断连接） ，代价是身体表面出现划伤，切割强度越大，划伤越深、范围越大。\n在长大后就加入了佣兵组织-灰烬之爪，利用佣兵身份接近那些可能与灭门案有关的权贵和黑市头目，逐步收集线索。	身高一米八六，体格健壮，肩背宽阔，像一座移动的铁塔。银灰色短发，利落干净，左眉骨有一道贯穿眉峰的旧疤，让他的面容显得更加冷硬。深灰色眼珠，看人时像在评估猎物的破绽。常穿一件黑色皮夹克，内里是深色工装衬衫，袖口总是卷到小臂，露出布满疤痕的皮肤和一小段刺青——那是灰烬之爪的标记，一只被火焰缠绕的爪印。腰间永远别着一把军用短刀和一把老式左轮手枪。	莱尔·西奥多(童年伙伴): 孤儿院一同长大的兄弟，失散多年后重逢。两人之间有着未解的心结和深厚的信任，克劳嘴上不说，但始终在暗中保护莱尔。; 灰烬之爪(所属组织): 作为灰烬之爪的精英成员，克劳对组织有一定归属感，但更多是相互利用的关系。他借助组织的情报网络追查灭门案，组织则利用他的战斗力处理脏活。	\N	\N	\N	\N	\N	[]	\N	["近身格斗", "枪械精通", "潜行暗杀"]	2026-08-05 22:56:26.703372	2026-09-19 22:02:02.499415	active	\N	切断丝线、右腕挂彩后继续协助清理	10
6172c65d-c986-4acd-bdb4-b26a26518315	d59e468a-8617-41e0-aabf-87a13be78834	天璇宗	\N	\N	t	supporting	天璇宗是典型的天赋至上主义门派，表面宣扬顺应天命，实则内部阶级森严，极度内卷。宗门以天赋品级划分资源分配，高天赋者享有特权，低天赋者沦为杂役甚至药引。行事风格外宽内严，对外以正道魁首自居，对内则以残酷的竞争机制筛选"优质弟子"。其核心理念认为灵气暴涨是上天恩赐，必须顺应天命，对任何质疑天赋来源的异端思想进行无情打压。宗门文化狂热而压抑，弟子们为了提升天赋品阶不择手段，整个门派像一台精密运转的筛选机器，不断为上层输送养分。	天璇宗创立于灵潮纪元之初，初代掌门在九脉交汇的登仙山发现上古遗迹"分灵碑"，借此开宗立派，成为九州大陆顶尖势力之一。三百年来，天璇宗凭借分灵碑赋予的"天赋"选拔机制，网罗天下英才，势力日益膨胀。然而，随着时间推移，宗门高层逐渐发现灵气虽浓却日益驳杂，高阶修士的瓶颈愈发坚固，但他们将此归咎于天地压制，反而加大了对底层弟子的压榨以提取更多资源。历史上曾有大能长老试图探查分灵碑的真相，却都离奇陨落，此后宗门对此讳莫如深，将分灵碑奉为圣物。如今，天璇宗表面上维持着仙风道骨的繁荣，实则已成为噬界者抽取世界本源的最大帮凶，内部暗流涌动，危机四伏。	天璇宗坐落于登仙山，山巅云雾缭绕，灵气化液，星辰大殿巍峨耸立，尽显仙家气派。山脚试灵台由白玉铺就，中央矗立着巨大的分灵碑，灵光闪烁间决定众生荣辱。外门坊市充斥着底层修士的挣扎与市侩，阴暗潮湿。组织标志为北斗七星环绕的灵根图腾，内门弟子身着月白道袍，外门弟子则是灰褐短打，阶级分明。	\N	修仙门派	表面宗旨是顺应天命，选拔天赋异禀之才，探求长生大道，维护九州秩序。实际长期愿景是维持天赋至上的阶级垄断，通过分灵碑不断收割弟子提炼的世界本源，供养宗门高层及背后的噬界者。行动准则为：天赋决定一切，违逆者视为天弃，格杀勿论。	\N	\N	\N	\N	\N	["天赋至上", "阶级森严", "内部狂热竞争", "依附分灵碑"]	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609	active	\N	\N	\N
327e1676-6588-4805-8329-ad02ad06b786	d59e468a-8617-41e0-aabf-87a13be78834	噬界者	\N	\N	t	supporting	噬界者是游走于虚空的掠夺者，视世界为牧场、万物为牲畜。他们以分灵碑为媒介，将世界本源转化为伪灵根寄生在原住民身上，通过修士的修炼暗中抽取本源。行事风格极度隐忍与冷酷，从不正面强攻，而是通过构建天赋修仙的规则，让原住民陷入疯狂的内卷与自我剥削，待世界抵抗降至冰点时降临收割。他们极度功利，视情感与道德为低维生物的劣根性，只追求绝对的本源积累。	数百年前，噬界者发现天元界本源丰厚，但界壁坚固，强攻损耗极大。为此，他们制定了寄生收割计划，投放至宝分灵碑，引发天地异变，史称灵潮纪元。分灵碑将世界本源转化为伪灵根赋予原住民，修士修炼实则是帮噬界者提炼本源。随着时间推移，天元界灵气看似繁荣实则驳杂，本源日益枯竭。如今，噬界者已临近收割期，暗中操控天元界顶层势力加速催化修士突破，只为更快地收割成熟神魂。历史上任何试图探查天赋真相的大能，皆被其无情抹杀，从而维持着这血腥而虚伪的秩序。	噬界者总部噬界之眼位于虚空与现实的夹缝，是一座由凝固的暗紫本源堆砌的倒悬巨城。其在各界的标志性建筑为分灵碑，表面是测灵觉醒的圣物，实为寄生媒介。降临者身着流淌暗紫流光的虚空长袍，面容隐匿于黑雾之中，周身散发着令人窒息的压迫感。其组织标志是一只吞噬星辰的巨口。	\N	神秘组织	明确目标：彻底吞噬天元界的世界本源；长期愿景：将天元界化为虚空尘埃，掠夺其全部能量；行动准则：以最小损耗完成收割，通过寄生与规则构建让原住民自我毁灭，避免正面强攻。	\N	\N	\N	\N	\N	["本源掠夺", "寄生侵蚀", "伪善伪装", "绝对利己"]	2026-09-19 23:31:20.824352	2026-09-19 23:31:20.824352	active	\N	\N	\N
\.


--
-- Data for Name: foreshadows; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.foreshadows (id, project_id, title, content, hint_text, resolution_text, source_type, source_memory_id, source_analysis_id, plant_chapter_id, plant_chapter_number, target_resolve_chapter_id, target_resolve_chapter_number, actual_resolve_chapter_id, actual_resolve_chapter_number, status, is_long_term, importance, strength, subtlety, urgency, related_characters, related_foreshadow_ids, tags, category, notes, resolution_notes, auto_remind, remind_before_chapters, include_in_context, created_at, updated_at, planted_at, resolved_at) FROM stdin;
b4b19c01-0b94-422e-9e46-96a6bb3afcc8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	灰衣男人的疤——嫌疑人标记	莱尔透过门缝看清灰衣男人转身时嘴角边有道疤斜到下巴，形成可辨认的体貌特征，为后续指认、追捕以及在人群中识别该嫌疑人埋下线索。	那灰衣男人转身时，嘴角边有道疤斜到下巴。	\N	analysis	planted_206cd7c2_162901712388	\N	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	10	\N	12	\N	\N	planted	f	0.6	6	7	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	identity	\N	\N	t	5	t	2026-08-16 23:10:05.473557	2026-08-16 23:10:05.473557	2026-08-16 15:10:05.476741	\N
8a022bc7-ca23-4933-8c36-07a9e07fa1da	7f6d28c4-2a32-46d1-887c-6cf5c4555056	明早的走位——替身的后续计划	灰衣男说"明早的走位改了"，暗示替身还有一场预定演出或行动，不仅设定了紧迫的时间窗口，也为下一章救援行动的走向提供预期。	明早的走位改了。	\N	analysis	planted_206cd7c2_59c1c1086314	\N	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	10	\N	11	\N	\N	planted	f	0.7	7	5	0	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	\N	\N	event	\N	\N	t	5	t	2026-08-16 23:10:05.473557	2026-08-16 23:10:05.473557	2026-08-16 15:10:05.478321	\N
9c0cbb2c-0872-41bb-9915-2e41ecc928a9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	触物读取残留记忆的能力	莱尔触碰木马后，以接近木马视角的低位画面看见诺亚先前的行动，明确埋下其能够读取物品残留记忆或过去影像的能力设定。后续可用于追查事件、发现隐藏真相，同时也会成为他被关注和追捕的根源。	视野变得很低，前后摇晃	莱尔回想木马裂开时残留在指腹上的触感，并明确意识到灰衣访客寻找的对象包括自己，使第1章中触碰木马后读取过去影像的异常体验进入他的主动认知。此次回收主要确认该现象属于莱尔必须隐藏的能力，但其侦查用途尚未在本章完整展开。	analysis	planted_a133fd75_269164e7fab2	\N	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	1	\N	2	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	2	resolved	t	1	10	3	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u8bfa\\u4e9a"]	\N	\N	ability	\N	\N	t	5	t	2026-08-06 15:35:22.061265	2026-08-06 15:40:30.300297	2026-08-06 07:35:22.061932	2026-08-06 07:40:30.300894
d2a1297f-bb76-47ad-b4ad-7a19ae0361b0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	能力使用会损伤接触物品	能力结束后，原本被莱尔按住的木马耳朵出现裂纹并掉落漆片，玛丽修女也确认昨天尚无裂口。这暗示能力可能对读取对象产生物理损耗，未来可能留下可追查的证据，甚至存在更严重的使用代价。	木马耳朵上裂开一道细纹	木马"裂开"的触感再次被莱尔回忆，并与其异常身份联系起来，确认第1章木马受损并非普通意外，而是能力发动伴随的物品损伤现象。	analysis	planted_a133fd75_c47a3e31917d	\N	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	1	\N	3	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	2	resolved	f	0.8	8	6	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u4e3d\\u4fee\\u5973"]	\N	\N	ability	\N	\N	t	5	t	2026-08-06 15:35:22.061265	2026-08-06 15:40:30.300297	2026-08-06 07:35:22.062915	2026-08-06 07:40:30.301948
25ed843c-8077-486b-abe6-477a2593526b	7f6d28c4-2a32-46d1-887c-6cf5c4555056	玛丽修女是秘密唯一守护者	玛丽修女不仅知道莱尔的能力，还主动承担替他保密和约束他的责任。她实际上是莱尔与危险外界之间的保护屏障；一旦她无法继续履行这一职责，莱尔的秘密、心理安全和生存环境都会迅速恶化。	所以我得替你守着	克劳坦白后，莱尔仍遵循玛丽修女关于秘密不可交给第二个人的告诫，没有承认自己的能力；同时玛丽修女对访客撒谎并烧毁地址，进一步坐实她是莱尔秘密的唯一知情者和保护者。	analysis	planted_a133fd75_19026a4b8582	\N	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	1	\N	3	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	2	resolved	f	0.9	9	5	0	["\\u739b\\u4e3d\\u4fee\\u5973", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	relationship	\N	\N	t	5	t	2026-08-06 15:35:22.061265	2026-08-06 15:40:30.300297	2026-08-06 07:35:22.064261	2026-08-06 07:40:30.302811
11053850-6e14-43f6-918a-b224ee36f8e0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	撕下的仓库草图——莱尔保留的物证	莱尔把本子上画的仓库图撕下折成薄方块捏在手里，暗示这张图会在后续救援或与珀西瓦尔交接时作为关键情报/证据使用。	把本子上的那页图撕下来，折成一个薄方块	\N	analysis	planted_206cd7c2_e1cea20e29c4	\N	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	10	\N	12	\N	\N	planted	f	0.5	5	8	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	item	\N	\N	t	5	t	2026-08-16 23:10:05.473557	2026-08-16 23:10:05.473557	2026-08-16 15:10:05.478981	\N
e7840e92-559b-4a80-932d-3041891ed8d2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	铜锣巷存档——旧案勾连	珀西瓦尔提到"刚整理完铜锣巷的存档"，铜锣巷可能是一宗旧案或与当前绑架相关的线索，为后续案件串联与角色间信息交流埋下伏笔。	我刚整理完铜锣巷的存档。	\N	analysis	planted_206cd7c2_bc0ded050711	\N	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	10	\N	20	\N	\N	planted	t	0.5	5	7	0	["\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	mystery	\N	\N	t	5	t	2026-08-16 23:10:05.473557	2026-08-16 23:10:05.473557	2026-08-16 15:10:05.479568	\N
7ade4e28-cd34-41fc-881d-399f9aead5dd	7f6d28c4-2a32-46d1-887c-6cf5c4555056	孤儿院遭袭与众人安危	烟囱停火、院内失去日常声响、大门虚掩且门闩断裂，共同表明孤儿院在两人离开期间遭遇暴力入侵。孩子们与玛丽修女的处境将成为下一章最直接的危机。	孤儿院的大门虚掩着	上一章中烟囱停火、院内无声、大门虚掩及门闩断裂所预示的暴力入侵得到完整回收。本章确认孤儿院遭三人以上袭击，玛丽修女、托比及多名孩子遇害，萨姆失踪，危机由预兆正式转化为主线惨案。	analysis	planted_ca898f17_c520f24a167b	\N	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	2	\N	3	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	3	resolved	f	1	10	2	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u6258\\u6bd4", "\\u827e\\u62c9", "\\u8bfa\\u4e9a"]	\N	\N	event	\N	\N	t	5	t	2026-08-06 15:40:30.300297	2026-08-06 15:47:58.846326	2026-08-06 07:40:30.307018	2026-08-06 07:47:58.84714
119b3b6b-1568-4cd1-b64a-7bc4755d74ac	7f6d28c4-2a32-46d1-887c-6cf5c4555056	伪造推理掩盖真实能力	莱尔没有直接掀开柳条筐，而是临时编造果酱手印、草屑和筐盖偏移等证据链，将超能力所得包装成观察推理。这种隐瞒手法既体现他的机敏，也预示他未来会继续用理性分析和谎言遮掩异常能力。	他说得像真有那么回事	莱尔在证物库"看见"沾木屑的手在账簿上写下编号的异象（灯光暗了一下），随即用侧灯与铅笔拓印压痕的常规手段包装信息结果，并特意将毁损的封皮碎屑压进掌心掩盖痕迹；"这话不全是假"再次确认他惯用半真话掩盖真实能力来源。	analysis	planted_a133fd75_cce5b90d5b51	\N	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	1	\N	5	ec671aae-e1fd-466e-a27f-de111643114e	13	resolved	t	0.8	8	5	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u8bfa\\u4e9a", "\\u6258\\u6bd4", "\\u827e\\u62c9"]	\N	\N	ability	\N	\N	t	5	t	2026-08-06 15:35:22.061265	2026-08-07 11:12:30.353789	2026-08-06 07:35:22.063589	2026-08-07 03:12:30.355834
6f7d55b6-a4ff-41d2-ad65-1a5fbf0c1d77	7f6d28c4-2a32-46d1-887c-6cf5c4555056	明星客户的未述委托	塞西莉从治安所辗转至管理局，再带经纪人亲自拜访莱尔，说明事件已经严重到无法依靠自身名气和资源解决。章节刻意不公开报案内容，将案件核心悬念留到下一章。	管理局不管，推给一个侦探	第6章刻意隐藏的委托内容在本章正式公开：塞西莉目击玛蒂尔达被无声黑影跟踪，并发现她此后出现节奏和反应异常。她从治安所转向管理局、最终拜访莱尔的完整动机由此得到解释。	analysis	planted_b0a85a8a_1711ef93a3e4	\N	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	6	\N	7	88f367b9-7962-46c7-b75e-9f4924ba0f70	7	resolved	f	0.8	8	3	0	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	event	\N	\N	t	5	t	2026-08-07 00:31:39.700531	2026-08-07 00:36:35.991783	2026-08-06 16:31:39.705753	2026-08-06 16:36:35.993697
921688e9-2e5d-4f40-9c5b-f4bfea3908b1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	零粒子异常案件	塞西莉所报案件看似具有非正常性质，却没有引发凯莉米粒子波动。后续可能证明存在能够规避监测的能力、非异能犯罪手段、监测系统盲区，或人为篡改记录的情况。	当晚九点到十点，您所在的铜锣巷口	第6章提出的低读数乃至零读数异常案件在本章得到机制层面的解释：凯莉米粒子监测反映的是现实被搅动的程度，微弱异能、异常器物或屏蔽手段可能被仪器视为背景噪音。该解释确立了莱尔能够介入官方制度盲区的合理性。	analysis	planted_b0a85a8a_89c88bb42691	\N	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	6	\N	9	88f367b9-7962-46c7-b75e-9f4924ba0f70	7	resolved	f	0.9	9	4	0	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	mystery	\N	\N	t	5	t	2026-08-07 00:31:39.700531	2026-08-07 00:36:35.991783	2026-08-06 16:31:39.704987	2026-08-06 16:36:35.995077
ca873cc1-0031-45f4-b3e7-6e021ec44b2a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	催眠记忆中的影子细节	莱尔认为塞西莉的意识虽然没记住影子细节，视觉记忆却仍有残留，准备通过催眠完成侧写。下一阶段调查将围绕被压在深层记忆中的身高、轮廓、移动方式或身份标志展开。	催眠能把那段记忆翻出来	莱尔通过触摸路灯等旧物，成功还原了六月三日夜里跟踪者的身高、轮廓和移动方式，这正对应他此前认为塞西莉深层视觉记忆中有残留、可借催眠绘制侧写的判断——虽然没有使用催眠，但结果达到了追查影子的目的。	analysis	planted_e7e7ec33_152780e0a15c	\N	88f367b9-7962-46c7-b75e-9f4924ba0f70	7	\N	8	9dc2adf5-8afa-4116-a98e-e481ecd4c427	8	resolved	f	0.8	8	3	0	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	\N	\N	ability	\N	\N	t	5	t	2026-08-07 00:36:35.991783	2026-08-07 00:49:36.55296	2026-08-06 16:36:36.000628	2026-08-06 16:49:36.555163
314ff99f-386d-44be-b830-10d16c079381	7f6d28c4-2a32-46d1-887c-6cf5c4555056	木偶的察觉式微笑	木偶玛蒂尔达在莱尔读取完皮包后抱着包出现，歪头微笑，手指关节泛着哑光。这个微笑可能只是木偶模仿真人的机械行为，也可能暗示操控者已经察觉莱尔来过。它让莱尔确认面前的人不是玛蒂尔达，同时也暴露了替身具有一定程度的观察与伪装能力。	她看着他，歪了歪头，露出一个笑	莱尔回想起木偶歪头看他的样子，现在确认那并非察觉了他的能力，而是被教出来的模仿——有人盯着她时玛蒂尔达会怎么笑，替身被训练得更像活人，只是火候不到，笑起来像在量他的脖子。	analysis	planted_52ec7416_28a6f524ba37	\N	72191e56-643e-49a5-9216-78a08f6e1494	9	\N	12	261ee431-2b9d-4544-842d-31cb2d054d48	12	resolved	f	0.9	9	7	0	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	\N	\N	mystery	\N	\N	t	5	t	2026-08-07 10:26:16.587684	2026-08-07 11:07:59.332146	2026-08-07 02:26:16.58989	2026-08-07 03:07:59.33404
836ee5ff-ea57-4739-a6c2-ce292a290e54	7f6d28c4-2a32-46d1-887c-6cf5c4555056	玛蒂尔达囚禁处的气味线索	莱尔在读取中闻到旧货仓特有的潮味，并看到高屋顶、堆放的木箱和卷起的帆布。这些环境细节成为追踪玛蒂尔达真身所在位置的重要嗅觉与视觉线索，后续办案时可能通过气味或建筑特征锁定地点。	一股潮味——旧货仓	废稿上沾有混着鱼胶的松脂污迹，与六码头货仓弥漫的气味一致，证实关押玛蒂尔达的货仓确实处理过印刷品——气味线索从抽象的感知记忆转化为实质物证链。	analysis	planted_52ec7416_790fb2918a97	\N	72191e56-643e-49a5-9216-78a08f6e1494	9	\N	12	261ee431-2b9d-4544-842d-31cb2d054d48	12	resolved	f	0.7	7	7	0	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	\N	\N	event	\N	\N	t	5	t	2026-08-07 10:26:16.587684	2026-08-07 11:07:59.332146	2026-08-07 02:26:16.591574	2026-08-07 03:07:59.335169
\.


--
-- Data for Name: generation_history; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.generation_history (id, project_id, chapter_id, prompt, generated_content, model, tokens_used, generation_time, created_at) FROM stdin;
aba2f69e-1729-448e-8d8a-0464f008f14d	d59e468a-8617-41e0-aabf-87a13be78834	\N	批量生成: 第1章 雨棚下的无印记者	Let me think through this chapter carefully.\n\nThe setting: 玄历一三七二年七月, 天禀城梅雨未歇. 张羽蹲在杂役坊药材棚下分拣蛇涎草. He's an 18-year-old youth who transmigrated from a modern world (was a botanical pharmacology scholar). He has no talent imprint, but he can see other people's 魂线末梢 - thin black threads extending from their necks toward the sky. He works as an unregistered laborer (暗工) at the sect's 杂役坊.\n\nKey events:\n1. Zhang Yu sorting 蛇涎草 under the herb shed, recalling the 满月测灵 stone slab showing no reaction\n2. Dur	default	\N	\N	2026-08-05 13:51:57.165586
6c8376d5-b984-4568-a084-e8a5d1c64c66	d59e468a-8617-41e0-aabf-87a13be78834	\N	批量生成: 第2章 镜光里的谎言	让我仔细思考这一章。\n\n**任务**：写第2章《镜光里的谎言》，约2000字。承接第1章结尾（刘管事警告张羽天衡司明天要来检查）。\n\n**大纲要点：**\n1. 天刚亮，铜铃在杂役坊外急促响起\n2. 天衡司巡查执事带着一面铜镜踏进泥泞的院子\n3. 所有杂役排队接受觉醒状态抽查\n4. 张羽躲在人群后面，袖中藏着那枚用劣质灵石刻成的瞒天符\n5. 轮到他的时候，执事的目光像钉子一样落在他身上\n6. 他借着低头整理衣襟的动作催动符纸，铜镜表面泛起一层淡黄色的微光\n7. 他顺势报出玄阶下等\n8. 执事点了点头，没有深究\n9. 执事转头说起昨日云梦泽边一名外门弟子突发灵识迷失，被执法堂当作心魔劫数押走的事\n10. 字里行间满是警告\n11. 张羽偷偷望向执事的后颈，看见那根黑线在铜镜的灵光中微微痉挛，像一条被太阳晒痛的蛇\n12. 收回视线后他才发现，瞒天符的边缘已经焦黑卷起，怕是用不了几次了\n13. 他低头混入人群，心里那点侥幸被一阵冰凉吞没\n\n**关键背景：**\n- 张羽：18岁穿越者，无天赋印记，可见人后颈伸向天空的黑线。2阶伪赋初凝，伪赋丹/瞒天符让他可以伪造天赋波动。他是杂役坊不入册的暗工。\n	default	\N	\N	2026-08-05 13:55:26.16122
e8f33fd4-6713-49c9-9626-86ee81a21a44	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	<system>\n你是专业的组织设定师，擅长创建完整的组织/势力设定。\n</system>\n\n<task>\n【设计任务】\n根据用户需求和项目上下文，创建一个完整的组织/势力设定。\n</task>\n\n<context priority="P0">\n【项目上下文】\n\n项目信息：\n- 书名：瞒天过海\n- 主题：孤儿院灭门幸存者莱尔·西奥多和克劳·沃尔特，莱尔凭"概率欺骗"与"时视回溯"两个异能开上了侦探所，克劳·沃尔特加入了佣兵集团，两个人在不同的渠道打探消息，最终完成了复仇。\n复仇成功后却得知-他所在的世界其实是一本书所写的故事，在这本书上写下的内容都会最大程度复现，\n但代价会逐渐让书灵走向灭亡。\n书灵和莱尔等人做了交易，莱尔要用他的智慧、伙伴的团结协作，为这个被写定的世界夺回自由。\n- 类型：奇幻、悬疑\n- 时间背景：故事发生在架空大陆的近代城市文明阶段，约相当于现实世界二十世纪中叶的科技水平，但社会形态因异能的存在而产生了独特的扭曲。这是一个'异能觉醒'被纳入国家户籍管理的时代，政府设立了'异能管理局'，所有年满十二岁的公民必须接受异能检测，登记在册的异能者会被分配至对应的'适配岗位'，而未被登记或隐藏异能者则被视为'黑户'，游走于法律边缘。社会的核心矛盾在于'异能代价'——每个异能都伴随着生理或心理上的损耗，导致异能者的平均寿命远低于普通人，因此'代价豁免权'成了特权阶级的象征，底层异能者则沦为实验品或消耗品。与此同时，一场名为'净化运动'的社会浪潮正在兴起，主张清除所有异能者以恢复'纯净人类'的秩序，这使异能者与普通人之间的关系日趋紧张。在这个时代，孤儿院'圣心之家'的灭门惨案已过去十五年，官方档案将其定性为'异能失控事故'，但民间流传着各种阴谋论，而当年的幸存者莱尔与克劳，正分别以侦探和佣兵的身份，游走于这个表面繁荣、内里腐朽的社会的灰色地带，试图揭开那场灾难背后的真相。\n- 地理位置：故事的主舞台是'灰港城'，一座坐落于大陆西海岸的港口工业城市，终年笼罩在潮湿的海雾中。城市呈扇形展开，背靠连绵的'黑曜山脉'，面朝浑浊的'灰鲸海湾'，港口区密布着生锈的起重机、集装箱堆场和走私者出没的暗巷。城市中心是'白塔区'，那里矗立着异能管理局的总部、贵族议会的穹顶大楼和各大财阀的玻璃幕墙写字楼，街道宽阔整洁，电车穿梭其间，与老城区的破败形成鲜明对比。老城区'锈带'是底层异能者的聚居地，废弃的工厂被改造成廉价公寓，墙壁上爬满铁锈和青苔，空气中混杂着机油、海腥味和廉价香烟的气味。莱尔的侦探所'概率事务所'就开设在锈带与白塔区交界的一条狭窄街道上，招牌是块褪色的铜板，窗户正对着街角的'乌鸦酒吧'。而克劳所在的佣兵集团'灰烬之爪'的据点，则隐藏在城市地下废弃的排水隧道中，那里布满错综复杂的管道和密室，是情报交易和非法勾当的温床。灰港城的地理环境决定了它的生存法则——靠海吃海，走私、黑市和异能奴役交易在这里屡禁不止，而城市的权力中心则通过控制港口贸易和异能资源，将底层居民牢牢锁在贫困与危险的循环中。\n- 氛围基调：灰港城的气息是潮湿而沉重的，海雾常年从灰鲸海湾涌来，裹挟着咸腥的潮气和煤烟味，能见度极低，让整座城市仿佛浸泡在一杯浑浊的苦茶里。视觉上，城市的主色调是灰蓝与锈褐——铅灰色的天空、深青色的海水、暗红色的铁锈，偶尔在白塔区的霓虹灯牌上闪烁出刺目的蓝紫色光芒，像是这座城市虚假的繁华。听觉上，港口区的汽笛声、锈带区工厂的机械轰鸣、电车轨道的摩擦声、乌鸦在电线杆上的嘶哑叫声，交织成一种永不安静的背景噪音。嗅觉上，老城区弥漫着陈旧的霉味、廉价酒精的酸涩、以及异能者使用能力后残留的臭氧或硫磺气息。居民的心理状态普遍焦虑而麻木，普通人因恐惧异能失控而敌视异能者，异能者则因'代价'的压迫而活在朝不保夕的恐慌中，彼此之间缺乏信任，连街角的流浪汉都可能用假情报换一枚硬币。这种氛围让莱尔的侦探事务所成为一处奇异的避风港——那里总点着一盏暖黄色的煤油灯，桌上摊着旧报纸和咖啡杯，空气中飘着淡淡的烟草和旧书的气味，仿佛在冰冷的城市里维持着一小片脆弱的温暖。但即便如此，每当莱尔使用'时视回溯'能力时，他眼前会浮现出过去场景的残影，那些影像带着刺骨的寒意和腐朽的气息，像是从地狱渗出的亡魂，提醒着他——真相永远比表面更阴暗。\n- 世界规则：世界运行的核心法则是'异能必付代价'，这一法则由'世界之书'的规则所定，无法被任何力量豁免。每种异能都有明确的代价：例如'概率欺骗'（莱尔的能力）允许他操控一定范围内的概率事件（比如让子弹偏离、让锁孔对齐），但每次使用都会消耗他的'幸运值'，使他随后一段时间内遭遇霉运（如突然摔跤、被车溅水）；'时视回溯'则允许他短暂窥视过去的时间片段，但每次使用都会让他失去一段近期记忆，且被窥视的过去越久远，失去的记忆越珍贵。其他异能者的代价各不相同，有的会加速衰老、有的会失去感官、有的会陷入疯狂。异能者分为'登记异能者'和'黑户异能者'两类，前者受'异能管理局'管理，必须定期接受'代价评估'，并按规定完成'义务任务'（多为危险工作），换取有限的医疗和庇护；后者则被通缉，一旦被发现会被强制收押或做实验。社会结构呈金字塔形——顶端是'书灵议会'，一个由极少数能感知'世界之书'的异能者组成的秘密团体，他们垄断着关于世界真相的知识（即世界是一本书所写的故事），并试图维护'故事'的稳定；中层是贵族议会和财阀，他们通过雇佣异能者保镖、投资异能实验室来巩固权力；底层则是普通人和低阶异能者，在生存线上挣扎。社会禁忌包括：不得公开讨论'世界之书'的存在，不得尝试'改写故事'（即干涉既定剧情），不得在公共场合使用高阶异能，违者会被'书灵议会'的'修正者'抹杀——他们会从现实中抹去违规者的存在痕迹，仿佛从未出现过。这一规则让整个世界笼罩在一种无形的恐怖中，因为所有人都可能在一瞬间被'修正'，而他们的亲友甚至会忘记他们的存在。莱尔和克劳在追查孤儿院灭门案时，逐渐触碰到了这些禁忌，也让他们意识到——他们不仅是复仇者，更是这个被写定世界的囚徒。\n\n已有角色：\n- 克劳·沃尔特（supporting）\n- 玛丽修女（supporting）\n- 莱尔·西奥多（protagonist）\n\n已有组织：\n- 治安管理所 [警察局]\n- 晨星孤儿院 [孤儿院]\n- 灰烬之爪 [佣兵集团]\n\n\n【用户需求】\n\n用户要求：\n- 组织名称：异能管理局\n- 组织类型：请AI根据世界观决定\n- 背景设定：官方设定的异能者管理所，负责登记&处理异能者案件。\n- 其他要求：无\n\n</context>\n\n<output priority="P0">\n【输出格式】\n生成完整的组织设定JSON对象：\n\n{\n  "name": "组织名称（如用户未提供则生成符合世界观的名称）",\n  "is_organization": true,\n  "organization_type": "组织类型（帮派/公司/门派/学院/政府机构/宗教组织等）",\n  "personality": "组织特性（150-200字）：核心理念、行事风格、文化价值观、运作方式",\n  "background": "组织背景（200-300字）：建立历史、发展历程、重要事件、当前地位",\n  "appearance": "外在表现（100-150字）：总部位置、标志性建筑、组织标志、制服等",\n  "organization_purpose": "组织目的和宗旨：明确目标、长期愿景、行动准则",\n  "power_level": 75,\n  "location": "所在地点：主要活动区域、势力范围",\n  "motto": "组织格言或口号",\n  "traits": ["特征1", "特征2", "特征3"],\n  "color": "组织代表颜色（如：深红色、金色、黑色等）",\n  "organization_members": ["重要成员1", "重要成员2", "重要成员3"]\n}\n\n【字段说明】\n- power_level：0-100的整数，表示在世界中的影响力\n- organization_members：组织内重要成员名字列表（可关联已有角色）\n- 成立时间：在background中描述\n</output>\n\n<constraints>\n【必须遵守】\n✅ 符合世界观：组织设定与项目世界观一致\n✅ 主题关联：背景与项目主题关联\n✅ 推动剧情：组织能推动故事发展\n✅ 有层级结构：内部有明确的层级和结构\n✅ 势力互动：与其他势力有互动关系\n\n【组织定位要求】\n✅ 有存在必要性：不是可有可无的背景板\n✅ 目标合理：不过于理想化或脸谱化\n✅ 具体细节：描述详细具体，避免空泛\n\n【格式约束】\n✅ 纯JSON对象输出，无markdown标记\n✅ 内容描述中严禁使用特殊符号\n✅ 专有名词直接书写\n\n【禁止事项】\n❌ 输出markdown或代码块标记\n❌ 在描述中使用特殊符号（引号、方括号等）\n❌ 过于理想化或脸谱化的设定\n❌ 空泛的描述\n</constraints>	{\n  "name": "异能管理局",\n  "is_organization": true,\n  "organization_type": "政府机构",\n  "personality": "异能管理局是灰港城官方设立的异能者管理机构，表面秉持秩序与稳定的核心理念，宣称通过登记、监管和引导来保护普通民众免受异能失控的威胁，同时为异能者提供庇护与医疗支持。然而在实际运作中，管理局内部充斥着官僚主义的僵化与冷酷的实用主义，高层更倾向于将异能者视为可消耗的资源而非公民。其行事风格以规章流程为掩护，常以安全为名行压制之实，对待黑户异能者尤为严苛，对底层异能者缺乏同情，而对待权贵阶层的异能者则表现出明显的妥协与配合。管理局内部层级分明，分工细致，设有登记科、监察科、执行科和研究所等机构，各科室之间既有协作也存在推诿与内斗。其文化价值观强调忠诚与服从，对规则的解释权牢牢掌握在高层手中，底层职员往往在理想与现实之间挣扎，逐渐被体制同化。运作方式以情报网络和强制手段为基础，通过线人、监控和定期检查维持对异能者的控制，同时利用义务任务制度将异能者投入危险工作以换取有限的资源，本质上是一种变相的剥削。",\n  "background": "异能管理局成立于三十年前，正值异能觉醒现象大规模爆发、社会秩序陷入混乱的时期。当时的灰港城因港口贸易的繁荣吸引了大量外来人口，异能者数量激增，失控事件频发，贵族议会与财阀为维护自身利益，联合推动成立了异能管理局，作为官方唯一的异能事务处理机构。管理局最初的功能仅限于登记和应急响应，但随着权力扩张，其职能逐渐覆盖异能者的户籍管理、代价评估、义务任务分配、异常事件调查以及黑户追捕。十五年前的圣心之家灭门惨案被定性为异能失控事故，正是由管理局主导调查并结案，但民间流传的阴谋论暗示管理局可能掩盖了真相，甚至与案件有关联。近年来，管理局在净化运动的浪潮中地位愈发重要，但也面临来自书灵议会和灰烬之爪等地下势力的挑战。管理局总部设在白塔区核心地带，拥有最先进的异能检测设备和档案数据库，同时在锈带区设有多个分支办事处，负责日常巡逻和情报收集。当前，管理局局长由贵族议会直接任命，其决策深受财阀影响，内部腐败与效率低下的问题日益严重，导致底层异能者对管理局的信任度极低。",\n  "appearance": "异能管理局的总部是一座灰白色花岗岩建筑，矗立于白塔区中央广场东侧，高八层，外墙刻有浮雕纹章——一只被锁链缠绕的眼睛，象征监视与约束。建筑正面悬挂着巨大的金属徽章，底色为深蓝，中央是一只银色的天平，两侧延伸出机械齿轮，底部刻有字母缩写ABM。总部大门前常年停着黑色装甲车，车窗贴有防爆膜，车身上印有同样的徽章。管理局职员统一穿着深灰色制服，领口和袖口缀有蓝色条纹，胸前佩戴金属身份牌，执行科人员则配备黑色战术背心和电击棍。总部内部以冷色调为主，走廊灯光惨白，墙壁上挂满规章制度告示和通缉令，登记大厅设有金属隔断和防弹玻璃窗口，气氛压抑而机械。",\n  "organization_purpose": "异能管理局的官方宗旨是维护社会秩序，保护普通民众安全，促进异能者与普通人和谐共存。其长期愿景是建立一套高效、可控的异能管理体系，使异能者成为社会发展的助力而非威胁。行动准则强调依法行事、程序正义，但在实际执行中，管理局更注重结果导向，倾向于以最小代价平息事端，甚至不惜牺牲个体权益。其核心目标包括：全面登记所有异能者，消除黑户现象；定期评估异能者状态，预防代价失控；执行义务任务分配，确保异能者对社会有所贡献；调查并处理异能相关犯罪，维护法律权威。然而，在权力与利益驱动下，管理局的实际目的逐渐偏离初衷，成为特权阶层打压异己、控制资源的工具。",\n  "power_level": 80,\n  "location": "灰港城白塔区中央广场东侧，总部大楼；另在锈带区设有三个分支办事处，在港口区设有一个检查站。势力范围覆盖全城，尤其对白塔区和港口区控制力最强，在锈带区因地下势力阻挠而存在盲区。",\n  "motto": "秩序高于一切，安全重于自由。",\n  "traits": ["官僚僵化", "监控严密", "权贵附庸"],\n  "color": "深蓝色",\n  "organization_members": ["哈罗德·韦恩", "艾德琳·克罗斯", "维克多·拉尔森"]\n}	deepseek-v4-flash	\N	\N	2026-08-05 23:31:56.12292
8c79640f-246e-4034-824f-74a15cb35f8a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	创作章节: 第2章 锈带街市的秘密	清晨的光从锈带街市东边那排铁皮屋顶的缝隙里漏下来，像一把把灰白色的刀，斜插在泥泞的巷道上。空气里混着隔夜的鱼腥味、铁锈味，还有某个角落飘来的劣质煤油燃烧的焦臭。摊贩们正把木板往油布棚子底下拖，哐当哐当的声响此起彼伏，间或夹杂几声干哑的咳嗽。\n\n莱尔踩着一块翘起的石板，险些绊倒。他低头看了一眼，石板底下露出一截生锈的铁管，管口淌着暗褐色的水，顺着路面的裂缝蜿蜒流进排水沟。他收回目光，朝前面走着的克劳看了一眼——克劳的背挺得笔直，肩上挎着一条旧布袋，步子不急不缓，像走在自己熟悉的领地一样穿行在人群里。\n\n“面粉要粗磨的，盐要粗盐，”克劳头也没回，“煤油要闻一下，掺了水的不要。”\n\n莱尔应了一声，目光却已经被左手边一个卖草药的摊子勾走了。摊上摆着一排玻璃罐子，罐底沉着颜色各异的干草根，一个穿着灰布衫的老头正蹲在摊子后面用石臼捣药，每捣一下，空气中就涌出一股微苦的辛味。莱尔放慢脚步，想看清罐子上贴的标签，克劳的声音又从前头传来：“别磨蹭。”\n\n莱尔撇撇嘴，快步跟上去。\n\n街市越往里走越挤。一个瘦得只剩骨架的乞丐蜷在电线杆底下，怀里抱着一个豁口的搪瓷碗，碗里空荡荡的，只有几滴雨水。莱尔经过时，乞	default	\N	\N	2026-08-06 00:13:03.713674
8e160a7a-61f6-4715-8455-4e369decfd8a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	创作章节: 第1章 晨星孤儿院的午后	午后三点的阳光斜斜地切过晨星孤儿院的院墙，在青砖上拉出一道暖黄的影子。后院那棵歪脖子梧桐树上的叶子已经黄了大半，风一过，哗啦啦往下掉，落在莱尔脚边，又被他捻起来，转了半圈。\n\n他蹲在树根旁，指尖夹着那片枯叶，目光却不在叶子上。\n\n院墙的裂缝从墙角爬到第三块砖的位置，断了。晾衣绳上挂着一件洗得发白的衬衫，水珠还在往下滴，在泥地上砸出几个小坑。草丛里有一片蒲公英被踩倒了，茎秆折了，白绒散了一地，方向朝东。\n\n莱尔眯起眼，把落叶往地上一丢。\n\n“找到了。”\n\n他站起来，拍了拍膝盖上的土，朝东边的破旧木棚走去。木棚的门半掩着，门轴上的灰被蹭掉了一小块，新鲜的木头茬子露出来，颜色比周围的浅。\n\n他推开门，探头进去。\n\n“露西，你藏这儿。”\n\n木棚角落里，一个扎着两根辫子的小女孩缩在一堆麻袋后面，嘴巴张得老大：“你怎么知道的！”\n\n“你进来的时候踩到蒲公英了。”莱尔指了指她鞋底沾着的白色绒毛，“而且门轴上的灰是刚蹭掉的。”\n\n露西低头看了看自己的鞋，又看了看门轴，半天没说出话。\n\n莱尔已经转身走了。\n\n第二个藏在菜窖里。莱尔没下梯子，只站在窖口往下喊了一声“比利，出来吧”，窖里就传来一声闷闷的“操	default	\N	\N	2026-08-06 00:07:11.175332
8194e3b8-0c29-48be-a5d7-5aabaf2d68d6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	创作章节: 第3章 血色黄昏	海雾比他们先到。\n\n从灰鲸海湾的方向压过来，灰蓝色，黏稠稠的，裹着鱼腥和潮气，把锈带区的铁皮屋顶、歪斜的电线杆、巷口堆着的废铁桶，一层一层浸成模糊的影子。莱尔和克劳踩着湿漉漉的石板路拐进晨星街时，雾已经漫到膝盖，像踩在一条灰白色的河里。\n\n克劳走在前面，布袋甩在肩上，面粉袋的棱角硌着他的肩胛骨。莱尔跟在两步之后，目光扫过街边紧闭的门板和窗缝里漏出的昏黄灯光。傍晚了，该是玛丽修女在厨房里烧水的时辰，铁锅碰铁勺的声响，从门缝里挤出来，和煤油灯的气味混在一起。\n\n但今天没有。\n\n莱尔先停住了脚。晨星孤儿院的院门虚掩着，门缝里透出的不是暖黄的灯火，是黑。死沉沉的、没有一丝光的黑。\n\n“克劳。”\n\n克劳已经看见了。他站在门前的台阶下，布袋从肩上滑落到肘弯，没有去扶。两人对视了一瞬，莱尔伸手推门。门轴发出一声干涩的呻吟，像是很久没有开过，又像是被人用力撞开之后没有合严。\n\n铁锈味先冲出来。\n\n比海雾的腥气浓十倍，直往鼻腔里钻，带着一丝甜腻的腥。莱尔的胃猛地抽了一下，但他没有后退。他跨过门槛，脚尖落在地板上，听到一声粘腻的轻响——鞋底沾了什么东西，湿的，稠的。\n\n厨房的灯还亮着，灶台上的一口铁锅咕嘟	default	\N	\N	2026-08-06 00:33:59.462679
63e732ee-4dac-4a02-8821-a7e8b6fc8f4b	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	创作章节: 第4章 无人聆听的证词	治安管理所坐落在锈带区和白塔区的交界处，一栋灰砖砌的三层小楼，外墙爬满了干枯的藤蔓，像一只只死去的蛇。门口挂着的铜牌锈得发绿，上面刻的字被雨水啃得模糊，只能勉强认出“治安”两个字。门厅里灯光昏黄，灯泡大概是瓦数不够，把人的脸照得蜡黄蜡黄的，像刚从土里刨出来的。\n\n莱尔推开门的时候，一股潮湿的烟味混着消毒水的酸气扑面而来，冲得他鼻子发酸。他浑身都是干涸的血迹，袖口、裤腿、鞋面，暗红色的斑块像烙进布料里，搓不掉的那种。克劳跟在他身后，脸上也挂着几道血痕，不知道是他自己的还是别人的。\n\n值班台后面坐着个中年警员，制服外套敞着，露出里面洗得发白的衬衫领子。他正靠在椅背上翻报纸，听见门响，慢悠悠地抬起头来。\n\n目光在莱尔和克劳身上扫了一圈。\n\n眉头拧成一个疙瘩。\n\n“……干什么的？”他把报纸折起来，搁在桌上，语气不咸不淡的，“打架了？还是被抢了？”\n\n“不是。”莱尔走到值班台前，双手撑着台面，尽量让自己的声音平稳，“晨星孤儿院，锈带区晨星街四十七号。那里发生了命案。”\n\n警员的表情没什么变化，只是眼皮抬了抬。\n\n“命案？”\n\n“死了九个人。一个修女，八个孩子。”莱尔说。\n\n空气安静了几秒。警员的	default	\N	\N	2026-08-06 12:18:34.705364
cf68ca58-fa4b-4912-84c4-a2f796bcb6ce	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶	让我仔细分析一下需求：\n\n1. 这是奇幻/悬疑网络小说《瞒天过海》的第10章《木偶》\n2. 目标字数：约2000字（±200字）\n3. 视角：第三人称\n\n章节大纲的关键情节点：\n- 夜色压住格雷文赫，雾气弥漫的港口区\n- 莱尔在排练室后门拦住塞西莉，说“照常排练”\n- 塞西莉说“她不是玛蒂尔达”，莱尔确认真正的玛蒂尔达还活着（“至少被带进货仓时还活着”）\n- 他们计划让模拟的玛蒂尔达继续排练，不要起疑心\n- 塞西莉问“要演多久？”\n- 侦察/追踪组追踪木偶替身到一个旧港口仓库\n- 莱尔补齐绑架与操控木偶的完整证据链\n- 联合行动成功，真正的玛蒂尔达获救\n- 聚焦角色：莱尔、珀西瓦尔、玛蒂尔达、塞西莉\n- 情绪弧线：由紧张克制转向宽慰温暖\n- 叙事目标：解决替身疑案，展现莱尔重视证据的办案方式，强化事务所与官方人员之间的合作关系\n- 冲突类型：调查者与异能罪犯之间的行动对抗\n\n来自前情回顾的关键信息：\n- 第9章的结尾是莱尔意识到了这个玛蒂尔达是个木偶替身，盯着它背着包的手指关节，发现关节在灯光下泛着不自然的哑光\n- 他告诉塞西莉“还在查”\n- 木偶带着包进了内间\n\n写作指南与风格要求：	default	\N	\N	2026-08-16 22:13:53.410911
433c7e01-92dd-4aa3-ab98-1d2fae723e4c	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	创作章节: 第3章 血色黄昏	海雾比他们先到。\n\n从灰鲸海湾的方向压过来，灰蓝色，黏稠稠的，裹着鱼腥和潮气，把锈带区的铁皮屋顶、歪斜的电线杆、巷口堆着的废铁桶，一层一层浸成模糊的影子。莱尔和克劳踩着湿漉漉的石板路拐进晨星街时，雾已经漫到膝盖，像踩在一条灰白色的河里。\n\n克劳走在前面，布袋甩在肩上，面粉袋的棱角硌着他的肩胛骨。莱尔跟在两步之后，目光扫过街边紧闭的门板和窗缝里漏出的昏黄灯光。傍晚了，该是玛丽修女在厨房里烧水的时辰，铁锅碰铁勺的声响，从门缝里挤出来，和煤油灯的气味混在一起。\n\n但今天没有。\n\n莱尔先停住了脚。\n\n晨星孤儿院的院门虚掩着，门缝里透出的不是暖黄的灯火，是黑。死沉沉的、没有一丝光的黑。\n\n“克劳。”\n\n克劳已经看见了。\n\n他把布袋往地上一扔，面粉袋砸在石板上，发出一声闷响。三步并作两步冲到门前，伸手一推——\n\n门没锁。\n\n铁门轴发出吱呀一声尖响，像钝刀刮过骨头。\n\n气味先撞出来。\n\n不是厨房的煤油味，不是孩子们洗过澡后湿漉漉的肥皂香。是铁锈。是铁锈和某种更沉、更甜、更黏稠的东西混在一起，堵在喉咙口，让人想呕。\n\n克劳僵在门槛上。\n\n莱尔从他身侧挤进去。\n\n玄关的地板上有拖痕。黑红色的，从走廊深处	default	\N	\N	2026-08-06 00:37:14.596696
cad31507-4596-4655-8ddd-fc60227e4e4b	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	批量生成: 第2章 巷口的低语	三月的午后，阳光把石板路晒得发白。莱尔背着一只半人高的麻袋，面粉的粉尘从袋口扑出来，在光柱里浮浮沉沉。他偏过头打了个喷嚏，差点没站稳。\n\n克劳走在他前面半步，两只手各拎一袋药品，胳膊上的肌肉绷出结实的线条。他回头看了莱尔一眼，没说话，但脚步放慢了些。\n\n城东市场离孤儿院大约二十分钟脚程，要穿过三条街、一座蒸汽轨道桥，再拐进一条窄巷。轨道上偶尔有蒸汽机车轰隆隆地碾过去，白烟喷出来，带着煤灰和机油的气味。莱尔每次走到这儿都要屏住呼吸，他不喜欢那种味道，闻多了像嗓子眼里卡了东西。\n\n市场比他们预想的要热闹。卖菜的、卖布的、卖铁器的摊子挤在一条街的两侧，吆喝声和讨价还价声混成一片，头顶的遮阳棚被风掀得哗哗响。莱尔跟着克劳在人群里穿来穿去，把面粉袋往肩上颠了颠，目光扫过两侧的摊位。\n\n“药铺在左拐第二家。”克劳说。\n\n“嗯。”\n\n两人又走了一段。莱尔注意到克劳今天有点不对劲。他说不上来哪里不对，就是感觉——克劳的步子比平时慢，肩膀也比平时绷得紧，像有什么话憋着没说出来。\n\n莱尔没问。他太了解克劳了，这人想说的时候自然会说，不想说的时候逼他也没用。上一章结尾玛丽修女说“我见过拥有这种能力的人”的时	default	\N	\N	2026-08-06 12:52:14.905507
5705d469-247d-49bc-b161-953330269314	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	创作章节: 第1章 躲猫猫	三月的风带着泥土的潮气，从后院那排老梧桐的枝丫间钻过来。莱尔·西奥多把自己缩成一团，贴在旧木箱和砖墙之间那条窄缝里，膝盖抵着下巴，后背贴着冰冷的墙面。他数着自己的心跳，一下，两下，三下——数到第十七下的时候，脚步声停在了离他不到三步远的地方。\n\n是杰米。他听得出来，那家伙走路总带着一种奇怪的拖沓，像左脚比右脚短了半寸。莱尔屏住呼吸，盯着面前那只木箱上剥落的漆皮，心里默数着时间。杰米站了大概五秒，然后脚步又响起来，朝工具棚的方向去了。\n\n莱尔嘴角弯了弯。\n\n这场躲猫猫已经玩了二十分钟，天快暗了，玛丽修女随时会喊他们去洗手吃点心。他闭上眼睛，在脑子里把刚才听到的所有声音过了一遍。杰米的脚步声是拖沓的，往工具棚去了；双胞胎姐妹跑开的时候裙摆蹭过洗衣房门口那丛冬青，发出细碎的沙沙声，她们肯定还在那儿；最小的莉莉跑得最慢，躲进了厨房后门旁边的柴堆，因为她觉得那里最安全，但她不知道柴堆边上那个水龙头会滴水，每隔三秒就“嗒”一声。\n\n还有克劳。克劳没跑。莱尔记得游戏开始的时候，克劳就靠在东墙那棵梧桐树下面，双手插在口袋里，看着他们一哄而散。他没躲，也没打算躲，就站在那儿，像棵长在墙边的树。\n\n莱尔睁	default	\N	\N	2026-08-06 12:49:58.308323
43e2a1b3-6bd3-4982-921d-99d716b9da45	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	批量生成: 第5章 雷金纳德·洛克哈特	第三天午饭后，治安所二楼走廊的灯管闪了两下，又稳住了。\n\n莱尔坐在长椅上，背靠着墙，手里攥着那枚银纽扣。阳光从窗户斜进来，照在纽扣表面的刻痕上——那道细小的爪痕，像猫科动物伸爪时留下的弧度。他用拇指摩挲了两下，金属的凉意渗进指腹。\n\n走廊尽头传来脚步声。两双鞋——一双皮鞋，鞋跟敲在地砖上节奏均匀；一双靴子，步子更重，像是治安所的人。\n\n莱尔把纽扣收进口袋。\n\n汉克斯从走廊那头拐出来，身后跟着一个穿深灰色风衣的男人。那人个子不算特别高，但肩膀很宽，走路的时候风衣下摆微微摆动，露出里面深色的制服裤和一双擦得很亮的黑皮鞋。他胸前挂着一块工牌，白底蓝字，在走廊的灯光下反了一下光。\n\n汉克斯走到长椅前，侧身让出位置：“这是异常管理局的洛克哈特先生，负责——”他顿了一下，像是在斟酌措辞，“来了解案情的。”\n\n莱尔站起来。克劳也站了起来，动作慢半拍，但站定之后，整个人像一堵墙一样杵在莱尔身侧。\n\n雷金纳德·洛克哈特的目光在莱尔脸上停了一秒，又扫过克劳，然后点了点头，没说客套话，直接推开二楼会议室的门，走了进去。\n\n汉克斯没跟进去。他站在门口，朝里面偏了偏头：“你们进去谈，我在外面。”\n\n莱尔和克劳对	default	\N	\N	2026-08-06 12:56:55.253775
fd6d1c3d-2b67-4a0a-b61a-d4b1b2e6785e	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	批量生成: 第3章 血色黄昏	黄昏的光压在屋顶上，像一层没洗干净的铁锈。\n\n莱尔把面粉袋往肩上颠了颠，拐过最后一道巷口，晨星孤儿院的铁门出现在视野里。他脚步没停，走了两步，忽然顿住了。\n\n克劳比他慢半步，察觉到他的停顿，也停下来：“怎么？”\n\n莱尔没回答。他盯着那扇铁门——门虚掩着，留了一道拳头宽的缝。这个时间点，玛丽修女一般会把门从里面锁上，等孩子们吃完饭才重新打开。而且门缝里透出来的不是厨房的油烟味和孩子们的吵闹声，什么都没有。死一样的安静。\n\n“门没锁。”莱尔说。\n\n克劳的目光也落在那道门缝上，他沉默了一秒，然后把左手拎着的药包换到右手，空出左手来。他没说话，但莱尔注意到他的步子放轻了。\n\n两人走到门前，莱尔伸手推门。铁门发出沉闷的吱呀声，向两侧滑开。\n\n院子里一片狼藉。\n\n晾衣绳断了，一头还拴在柱子上，另一头垂在地上。床单和几件衣服散落在泥地里，其中一条白床单上有一大片暗红色的污迹，边缘已经干涸发黑，像泼翻的颜料。\n\n莱尔站在门口，胸口像被什么东西堵住了。他把面粉袋放在地上，动作很轻，像怕惊动什么似的。他跨过门槛，走进院子。\n\n风从院子的另一头吹过来，带着一股浓重的气味。铁锈味——或者说，是血的味道，混着某	default	\N	\N	2026-08-06 12:55:15.046499
d0bac1ea-13ad-4e04-bbf6-a43f68a30e70	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	批量生成: 第4章 治安所的三天	治安所的门比莱尔想象的要沉。推门的时候，门轴发出一声刺耳的尖响，柜台后面打瞌睡的值班治安官被惊得肩膀一抖，手里那杯凉透的茶差点洒出来。\n\n“干什么的？”治安官把杯子放下，上下打量他们俩。目光先落在克劳身上——一米八六的个子，黑皮夹克，左眉骨一道旧疤，怎么看都不像这个点该出现在治安所的人。又扫到莱尔，瘦，衣服上沾着灰，脸色发白。\n\n“报案。”莱尔说。他的声音比预想中稳，“晨星孤儿院，城东旧街那边。有人死了。”\n\n治安官的表情没什么变化，甚至打了个哈欠。“小孩儿打架还是——”\n\n“死人了。”莱尔打断他，“修女，被杀的。孩子们不见了。”\n\n治安官的手停在杯子边上，没动。他盯着莱尔看了两秒，像是在判断这小子是不是在耍他。然后他慢慢站起来，绕过柜台，走近了几步。\n\n“你说啥？”\n\n莱尔又说了一遍。治安官的目光从他脸上移到克劳脸上，克劳没说话，只是微微侧了侧身，露出他身后——莱尔鞋底踩过的地方，留下一个暗红色的印子。\n\n治安官低头看了一眼那个印子。然后他蹲下去，用指尖蹭了一下，放到鼻子下面闻了闻。\n\n他的脸色变了。\n\n“你俩在这儿等着，别动。”他转身朝走廊尽头喊了一嗓子，“老郑！把人都叫起来！”\n	default	\N	\N	2026-08-06 12:55:57.850794
227307de-618d-4747-9e1a-2f144228ce14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	批量生成: 第6章 工牌背面的爪痕	门关上的声音很轻，但会议室里安静得连窗帘摩擦窗框的声响都听得见。\n\n莱尔坐在椅子上没动，目光落在桌面上那道浅浅的弧线上。雷金纳德坐过的位置，桌面上那道刮痕还在，像是工牌背面那枚爪痕划过时留下的。他的手指无意识地伸进口袋，指尖碰到那枚银纽扣的边沿，金属的凉意顺着指腹往上爬。\n\n克劳还站在他身后，像一堵墙。他沉默了几秒，开口：“你看见什么了。”\n\n莱尔没回头，声音压得很低：“他工牌背面有爪痕。”\n\n克劳没说话，但莱尔能感觉到他身后的空气紧了一下。\n\n“跟纽扣上的图案一样。”莱尔补了一句。\n\n克劳绕过桌子，在他对面坐下。那张椅子刚才还是雷金纳德坐过的，克劳坐下来的时候，皮面发出一声轻微的吱呀声。他压低声音：“确定？”\n\n莱尔把银纽扣从口袋里掏出来，放在桌面上，用拇指拨到雷金纳德刚才坐的位置旁边。纽扣表面的刻痕在窗外的光线下微微反光——那道弧线，锋利，干净，像猫科动物收爪时留下的弧度。\n\n“一模一样。”莱尔说，“我看了两遍。”\n\n克劳的视线在纽扣上停了几秒，又抬起来看莱尔的脸。“你想直接问他？”\n\n“不能问。”莱尔把纽扣收回去，声音很轻，“如果他的工牌上的爪痕跟这个有关，那他要么是知情人，要么	default	\N	\N	2026-08-06 12:57:40.844539
67f80ccc-872b-4e44-98f0-e82660749462	d59e468a-8617-41e0-aabf-87a13be78834	\N	批量生成: 第3章 掌心字与灯灭时	让我仔细规划这第3章。\n\n上一章结尾：张羽发现瞒天符边缘焦黑卷起，低头混入人群，侥幸被冰凉吞没。\n\n本章大纲要求：\n- 傍晚雨歇，药园学徒柳若霜抱着一只竹篓出现在杂役坊门口\n- 柳若霜趁四下无人喊住张羽，摊开掌心，请他辨认一个昨夜外门弟子昏迷前抓着她写下的字\n- 那字没写完，只余几道深深浅浅的残痕，看着像契字，又像祭字\n- 张羽心头一跳，却不敢多说，只答应夜里翻翻旧书\n- 回到住处，点起油灯，翻开残缺的《天启见闻录》\n- 指尖刚触到纸页，听见极远处传来一声压抑的尖叫，仿佛从灵脉深处透出来\n- 他猛地吹灭油灯。窗外，天柱峰上的五色霞光依旧明亮，比白日更温柔地笼罩着山门，好像什么都不曾发生\n\n关键背景衔接：\n- 第2章结尾是早上检查结束（瞒天符焦黑）。本章开头是"傍晚雨歇"，所以是同一日的傍晚，或过了一天？"傍晚"——天衡司检查是早晨，灵识迷失事件在"昨日"。所以检查当天白天过去了，傍晚发生本章事件。合理。\n\n对话台词参考大纲：柳若霜说她昨夜在外门弟子昏迷前，那人抓着她写下的字。注意时间线：第2章执事说"昨儿云梦泽边又折了一个外门弟子"——那个被押走的弟子。而本章柳若霜说的"昨夜外门弟子昏	default	\N	\N	2026-08-05 13:57:03.674522
d2fcd6e7-6021-4077-972d-df317237744a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	批量生成: 第1章 藏在阳光里的秘密	六月的太阳越过红砖屋顶，把晨星孤儿院的影子压在地上。\n\n后院不大，三面围墙。东边是掉漆的仓房，西边立着钟楼矮墙，中间扯了几根晾衣绳。床单、围裙和洗得发白的旧衬衣挂在上头，被风吹得鼓鼓囊囊。\n\n厨房窗户开着。烤面包的香味飘出来，混着皂角水和晒热的泥土味。\n\n“六十！”\n\n莱尔背对院子，额头抵着老槐树，双手蒙住眼睛。\n\n“数完了。没藏好的，算你倒霉。”\n\n身后传来一阵乱响。\n\n有人踩翻木盆，有人压着嗓子骂了一句，还有个倒霉蛋撞上晾衣架，铁钩晃得叮当作响。\n\n莱尔没急着回头。\n\n“九十七，九十八，九十九……”\n\n“你刚才才数到六十！”远处有人喊。\n\n“我数得快。”\n\n“你耍赖！”\n\n“一百。”\n\n莱尔转过身，棕黑色短发被树皮蹭乱了几根。他抬手捋开额前碎发，先看院门。\n\n门闩好好的，没人跑出去。\n\n今天参加游戏的一共八个。抓到七个才算赢。输的人负责替玛丽修女剥晚饭用的豌豆，整整一大篮。\n\n这种时候，友情靠不住。\n\n泥地上全是脚印。\n\n莱尔蹲下，盯着其中一串看了几秒。鞋印从槐树后绕向仓房，鞋底右边缺了一小块。\n\n“出来吧，托比。”\n\n仓房后的空木桶晃了晃。\n\n“凭什么？”\n\n“你那双鞋是我补的。	default	\N	\N	2026-08-06 15:29:06.931263
16a7910d-3797-4f43-a930-07897a97374f	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	批量生成: 第2章 归途之前	晨雾贴着灰瓦往下淌，城西教堂的钟敲了六下。\n\n街边的面包房刚开门，热气从烟囱里冒出来。运煤车碾过石板路，铁轮咯噔作响，惊起一群啄食的麻雀。\n\n晨星孤儿院也醒了。\n\n厨房里满是煮燕麦的甜味，煤炉烤得人脸发热。几个孩子围着长桌抢最后一勺蜂蜜，托比拿面包去蘸，被玛丽修女用木勺挡了回去。\n\n“那是给诺亚的。”\n\n“他吃得慢。”\n\n“所以你替他吃？”\n\n托比收回手，装作什么也没发生。\n\n莱尔坐在桌角，把碗里那点燕麦糊刮得干干净净。克劳靠着窗台，嘴里叼着半片面包，正用小刀削一截木头。\n\n玛丽修女擦净手，从围裙口袋里拿出一张折好的纸。\n\n“面粉两袋，退烧药一盒，煤油一桶。要是剩得多，再买些盐。”\n\n她又取出一个布袋。几枚铜币落在桌上，碰出脆响。\n\n莱尔数了一遍。\n\n“剩不了。”\n\n“那就不买盐。”\n\n“也可能连煤油都不够。”\n\n“城东那家铺子便宜。”\n\n“他们的秤缺斤少两。”\n\n玛丽修女将零钱推过去。\n\n“所以才让你去。”\n\n莱尔收起铜币，满意了。\n\n克劳把木头和小刀揣进口袋，拎起墙边的空篮。玛丽修女替他理了理歪掉的衣领，又转向莱尔。\n\n“别惹事。”\n\n“您应该对克劳说。他长得比较像会惹事的。”\n\n	default	\N	\N	2026-08-06 15:35:22.071838
177e1708-d2f3-4a98-9f15-10a4ea488451	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	批量生成: 第3章 熄灭的晨星	药瓶撞上石阶，瓶塞滚进门缝。\n\n里面没有人出来。\n\n克劳扔下煤油桶，一把推开大门。断掉的门闩擦过地面，发出刺耳的刮响。\n\n“等等。”\n\n莱尔抓了个空。\n\n门后的血腥味扑出来，混着煤灰和冷掉的燕麦，黏在喉咙里。几只苍蝇从墙角飞起，嗡嗡绕过克劳的肩膀。\n\n走廊还是他们离开时的样子，又不太一样。\n\n衣帽架倒了，木钩断了两根。半扇窗碎在地上，玻璃踩得到处都是。墙边躺着托比劈柴用的小斧，斧柄上全是血。\n\n克劳站住了。\n\n“托比？”\n\n没人应。\n\n他往前走，靴底踩中一只铁皮杯。杯子咣当滚远，撞在厨房门上。\n\n莱尔蹲下去，没碰那把斧头。\n\n血已经暗了。斧刃干净，斧柄却沾了血，说明托比抓起它时，手上就有伤。\n\n血点一路拖向厨房。\n\n“别进去。”莱尔说。\n\n克劳推开门。\n\n煤炉灭了，锅翻在地上，燕麦糊凝成一摊。托比倒在长桌旁，手臂还朝门口伸着，指尖离斧头只差几步。\n\n他没拿到。\n\n克劳蹲下，手伸到一半，停在托比肩上。\n\n“托比。”\n\n还是没有回应。\n\n桌底露出一只小鞋。克劳猛地掀开桌布，动作太大，长凳被带倒在地。\n\n诺亚缩在桌下。\n\n他怀里抱着那只木马，脸埋在膝间，安静得像睡着了。木马从中间裂开，裂缝正	default	\N	\N	2026-08-06 15:40:30.311627
25ad03c7-ab10-4c5e-9970-b0f7b5b618f8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	创作章节: 第4章 治安所的三天	清晨的雾压在城西，屋顶只剩一排模糊的黑影。\n\n送煤车碾过街口，车轮吱呀作响。治安管理所门前的积水结了薄冰，两个巡警缩在屋檐下换岗，呵出的白气很快散进雾里。\n\n一墙之隔，临时休息室冷得像地窖。\n\n屋里摆着两张行军床，一张缺了条腿，底下垫着旧卷宗。窗户封死了，玻璃上全是水汽。昨晚送来的咖啡放在桌角，油腻的黑沫已经凝成一圈。\n\n莱尔一夜没睡。\n\n克劳也没睡。他坐在床边，背抵着墙，右手插在夹克口袋里。那枚缝衣针就在里面。\n\n走廊响起钥匙声。\n\n门一开，瘦高巡警探进头。\n\n“莱尔·西奥多，出来。”\n\n“早餐呢？”\n\n巡警看了他一眼。\n\n“问完再吃。”\n\n“昨天也是这句。”\n\n没人接话。\n\n莱尔起身，把衬衣下摆抻平，跟着他穿过走廊。\n\n问询室不大。煤气灯滋滋作响，桌面残留着烟灰和杯底印。负责记录的是个红鼻头书记员，坐在对面的治安官换成了陌生人。\n\n四十岁上下，秃顶，左手戴着婚戒。\n\n桌旁放了三个档案袋。最上面那个写着晨星孤儿院，封口还没拆。\n\n“坐。”\n\n莱尔拉开椅子。\n\n秃顶治安官翻开本子。\n\n“你和死者关系如何？”\n\n“哪一位？”\n\n“所有人。”\n\n“这得问到明天。”\n\n笔尖停了一下。\n\n“有	default	\N	\N	2026-08-06 16:58:52.754032
94980e76-eb19-47a2-8d41-9acd360dda3a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	创作章节: 第4章 治安所的三天	雾压在城西，屋脊只剩一排发黑的轮廓。\n\n送煤车慢吞吞碾过街口，车轮咬着石缝，吱呀，吱呀。治安管理所门前积了半洼脏水，夜里冻出一层薄冰。两个巡警缩在屋檐下换岗，跺着脚，白气刚出口就散进雾里。\n\n一墙之隔，临时休息室冷得像地窖。\n\n屋里塞着两张行军床。一张缺了条腿，底下垫着几本旧卷宗，每次有人翻身，床架就嘎吱乱叫。窗户钉死了，玻璃上全是水汽。昨晚送来的咖啡摆在桌角，黑沫凝成油腻的一圈。\n\n莱尔一夜没睡。\n\n克劳也没睡。\n\n他坐在床边，背抵着墙，右手始终插在夹克口袋里。那枚缝衣针就在里面。隔着一层布，针尖顶着他的指腹。\n\n走廊传来钥匙碰撞声。\n\n门打开，昨天带队赶去孤儿院的瘦高巡警探进头。\n\n“莱尔·西奥多，出来。”\n\n莱尔看向桌角。\n\n“早餐呢？”\n\n巡警扫了他一眼。\n\n“问完再吃。”\n\n“昨天也是这句。”\n\n没人接话。\n\n莱尔起身，抻平衬衣下摆。走到门口时，他停了一下。\n\n“他昨晚没吃东西。”\n\n巡警看向克劳。\n\n“等食堂开火。”\n\n“再送一杯热水。”\n\n“这里不是旅店。”\n\n“旅店的床一般有四条腿。”\n\n巡警的脸沉下来，莱尔已经迈进走廊。\n\n问讯室比休息室暖些，却有股湿羊毛、烟灰和墨水	default	\N	\N	2026-08-06 22:14:45.633165
4de98f25-65f0-4ef4-ab66-df958ed2657d	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	<system>\n你是专业的组织设定师，擅长创建完整的组织/势力设定。\n</system>\n\n<task>\n【设计任务】\n根据用户需求和项目上下文，创建一个完整的组织/势力设定。\n</task>\n\n<context priority="P0">\n【项目上下文】\n\n项目信息：\n- 书名：瞒天过海\n- 主题：孤儿院灭门幸存者莱尔·西奥多和克劳·沃尔特，莱尔开上了侦探所，克劳·沃尔特加入了佣兵集团，两个人在不同的渠道打探消息，最终完成了复仇。\n复仇成功后却得知-他所在的世界其实是一本书所写的故事，在这本书上写下的内容都会最大程度复现，\n但代价会逐渐让书灵走向灭亡。\n书灵和莱尔等人做了交易，莱尔要用他的智慧、伙伴的团结协作，为这个被写定的世界夺回自由。\n- 类型：奇幻、悬疑\n- 时间背景：当下故事时间为2050年6月。十五年前（2035年），晨星孤儿院惨案发生，是全书主线起点。异能在这十余年间从隐秘传闻逐渐进入公众日常，官方将异常管理局报案台铺到每个区，监测仪一根根立到街角。民间组织有时候也会和官方合作一同处理一些异常事件。\n随着科技发展，异能物品也逐渐被人为制造出来，可以让普通人也使用到异能，但代价仍然是不可避免的。\n- 地理位置：格雷文赫城——港口工业城市，物价中等偏上。城东区有不起眼的巷弄和贫民窟，也有繁华的蒸汽码头和钟楼广场。城市街道由石板路与蒸汽轨道交织，哥特式高建筑与简陋棚户比邻。\n- 氛围基调：维多利亚风格。煤气灯与异常粒子检测仪共立街角，马车与蒸汽机械并行。异能者存在但受管控，街头巷尾议论异能的语气从压低声音变成了大声抱怨——"大致知道"和"真碰上时知道怎么办"之间，隔着无数被踢来踢去的案子。基调是悬疑中带轻松，日常案件的诙谐与复仇主线的沉重交织。\n- 世界规则：代价守恒：任何异能使用必付代价，代价与能力强度正相关，不存在无代价的能力。代价无法完全消除，但可以转移、延缓或对冲。对于代价无法支付的异能者，会化为灰烬死去。\n官方垄断高危事件：民间组织只有在官方邀请、粒子超阈值、或成员被卷入时才能参与异常事件处理，否则不可贸然行动。\n凯莉米粒子监测：异能发动和异常器物活动会搅动凯莉米粒子，浓度超过警戒线由管理局介入。但有些手段动得很轻，轻到仪器当背景噪音——这是灰色地带案件的根源。\n\n已有角色：\n- 玛蒂尔达·斯特林（supporting）\n- 塞西莉·辛克莱（supporting）\n- 珀西瓦尔·费尔班克斯（supporting）\n- 雷金纳德·洛克哈特（supporting）\n- 莱尔·西奥多（protagonist）\n- 玛丽修女（supporting）\n\n已有组织：\n- 异能管理局 [政府机构]\n- 治安管理所 [警察局]\n- 晨星孤儿院 [孤儿院]\n- 灰烬之爪 [佣兵集团]\n\n\n【用户需求】\n\n用户要求：\n- 组织名称：西奥多侦探事务所\n- 组织类型：请AI根据世界观决定\n- 背景设定：与月季咖啡厅同一栋临街小楼。二楼为莱尔经营的西奥多侦探事务所，营业时间为每日 9:00—18:00，因寻猫找狗、查找遗失物等小委托在附近颇有名气；一楼为房东格蕾丝太太经营的月季咖啡厅，莱尔日常在此用早餐。格蕾丝太太养有一只名叫露西的狗，爱称露西小姐，莱尔经常代为遛狗。\n- 其他要求：无\n\n</context>\n\n<output priority="P0">\n【输出格式】\n生成完整的组织设定JSON对象：\n\n{\n  "name": "组织名称（如用户未提供则生成符合世界观的名称）",\n  "is_organization": true,\n  "organization_type": "组织类型（帮派/公司/门派/学院/政府机构/宗教组织等）",\n  "personality": "组织特性（150-200字）：核心理念、行事风格、文化价值观、运作方式",\n  "background": "组织背景（200-300字）：建立历史、发展历程、重要事件、当前地位",\n  "appearance": "外在表现（100-150字）：总部位置、标志性建筑、组织标志、制服等",\n  "organization_purpose": "组织目的和宗旨：明确目标、长期愿景、行动准则",\n  "power_level": 75,\n  "location": "所在地点：主要活动区域、势力范围",\n  "motto": "组织格言或口号",\n  "traits": ["特征1", "特征2", "特征3"],\n  "color": "组织代表颜色（如：深红色、金色、黑色等）",\n  "organization_members": ["重要成员1", "重要成员2", "重要成员3"]\n}\n\n【字段说明】\n- power_level：0-100的整数，表示在世界中的影响力\n- organization_members：组织内重要成员名字列表（可关联已有角色）\n- 成立时间：在background中描述\n</output>\n\n<constraints>\n【必须遵守】\n✅ 符合世界观：组织设定与项目世界观一致\n✅ 主题关联：背景与项目主题关联\n✅ 推动剧情：组织能推动故事发展\n✅ 有层级结构：内部有明确的层级和结构\n✅ 势力互动：与其他势力有互动关系\n\n【组织定位要求】\n✅ 有存在必要性：不是可有可无的背景板\n✅ 目标合理：不过于理想化或脸谱化\n✅ 具体细节：描述详细具体，避免空泛\n\n【格式约束】\n✅ 纯JSON对象输出，无markdown标记\n✅ 内容描述中严禁使用特殊符号\n✅ 专有名词直接书写\n\n【禁止事项】\n❌ 输出markdown或代码块标记\n❌ 在描述中使用特殊符号（引号、方括号等）\n❌ 过于理想化或脸谱化的设定\n❌ 空泛的描述\n</constraints>	{\n  "name": "西奥多侦探事务所",\n  "is_organization": true,\n  "organization_type": "民间调查机构",\n  "personality": "以不起眼的日常委托为掩护，在都市缝隙间寻找被湮没的真相。奉行小事求真、大隐于市的准则，不张扬、不越界，却也不曾真正停下。事务所分工简单：莱尔负责定案与最终判断，塞西莉掌管档案与情报，珀西瓦尔跑外勤和线人。对内线索共享，对外礼貌克制，按规矩接案，对官方始终保持谨慎距离。莱尔信奉细节与逻辑胜过直觉与异能，因此办案更依赖观察走访与档案比对，而非触碰超越权限的异常事件。若委托人被卷入异常，他们会在规则边缘小心走一趟，尽量不让粒子监测仪盯上。整个事务所的底色是耐心与执念，像猫蹲守老鼠一样等着属于他们的时机。",\n  "background": "2045年春天，莱尔·西奥多带着孤儿院大火后攒下的积蓄，在格雷文赫城城东老巷租下月季咖啡厅二楼的空房间，挂出西奥多侦探事务所的招牌。最初的业务只是帮街坊寻找走失的猫狗和遗失的怀表，收入勉强够付房租。莱尔谨慎地把每一项委托登记在册，因为每一件小事都可能藏着他要找的那把钥匙。五年间，事务所渐渐在附近街区站稳了脚跟，也在治安管理所和异能管理局的名单上留下一个无害的记录。真正重要的工作都在柜台下面：莱尔将孤儿院旧档案、报纸剪报和委托中零碎的异常线索交叉比对，慢慢拼出当年惨案的另一面。偶发的异常物品案件被委托上门时，他们总以咨询师身份介入，不越过管理局划定的警戒线。如今的西奥多侦探事务所依然不是什么大势力，却已是许多无处可去的秘密愿意停靠的码头。",\n  "appearance": "从老巷边一道窄木梯上去，二楼便是事务所。临街的窗台上摆着一盆月季，推门先看到会客用的旧沙发，对面墙壁钉满街区地图和照片，书架上塞着市政档案、旧报纸和异常事件剪报。桌上一台老式打字机，下层抽屉锁着真正重要的记录。门口挂着一块铸铁招牌，刻着西奥多侦探事务所，边角已经生锈，招牌背后缀了一枚小小的铜制月季。",\n  "organization_purpose": "表面目标是以日常委托谋生并维持事务所运作；核心目标是查明十五年前晨星孤儿院灭门惨案真相，还逝者以公正，并最终摆脱写定命运的束缚。长期愿景是在格雷文赫城建立一个可以信赖的情报节点，让更多被命运脚本困住的人有机会选择自己的路。行动准则是不露锋芒、不越红线、不负托付；任何线索都登记在案，任何委托都有始有终。",\n  "power_level": 60,\n  "location": "格雷文赫城城东区老巷的临街小楼二层，月季咖啡厅楼上；主要活动区域覆盖城东各街区，偶尔延伸至蒸汽码头与钟楼广场一带。",\n  "motto": "小事求真，大隐于市",\n  "traits": [\n    "以琐碎委托为掩护的调查节点",\n    "游走于规则边缘的谨慎作风",\n    "依靠观察与逻辑而非异能破局"\n  ],\n  "color": "灰蓝色",\n  "organization_members": [\n    "莱尔·西奥多",\n    "塞西莉·辛克莱",\n    "珀西瓦尔·费尔班克斯"\n  ]\n}	deepseek-v4-flash	\N	\N	2026-08-06 23:57:50.217738
5eb0bb57-aa80-4a0e-98ca-823363d8afd8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	创作章节: 第9章 皮包里的囚笼	清晨的雾贴着格雷文赫城北站爬行，铁轨被水汽浸得发亮。蒸汽机车拖着长鸣驶出站台，煤烟压过屋顶，又被海风扯散。\n\n候车厅外，报童冻得直跺脚。搬运工的吆喝、车轮的摩擦声和锅炉泄压的“嗤嗤”声混在一起，吵得人耳根发麻。\n\n莱尔坐在街对面的早餐铺里。\n\n桌上摆着一杯掺水咖啡，两片烤焦的面包。一个戴鸭舌帽的瘦子挤过人群，把牛皮纸袋扔到桌上。\n\n“灰烬酒馆送来的。”\n\n莱尔没碰纸袋。\n\n“多少钱？”\n\n“已经付了。”\n\n“那就很可疑。”\n\n瘦子翻了个白眼，钻进雾里。\n\n纸袋里有三份东西。\n\n地下印坊的旧工名册、木偶剧团的薪酬记录，还有北站的货运雇工单。三张纸都指向同一个人。\n\n文森特·惠特莫尔。\n\n五尺四寸，右嘴角有疤，常穿深灰大衣。替地下印坊搬过铅字，也在巡演木偶团里修过道具。五月二十九日，他受雇押送一批印刷机零件前往北方的瓦伦港。\n\n出城记录、车票存根、沿途驿站签名，一样不少。\n\n六月三日，他已在四百里外。\n\n莱尔喝了口咖啡，立刻放下。\n\n比月季咖啡厅昨天那杯还糟。\n\n他拿起木偶剧团的薪酬表。文森特的名字旁盖着指印，墨色已旧。下面另有一行小字。\n\n擅长人像雕刻，手脚不稳，已辞退。\n\n莱尔用指甲刮	default	\N	\N	2026-08-07 10:07:22.617629
8aec9288-b9d2-43e9-92ba-ef92f97a0aab	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶归巢	夜色压住格雷文赫，港区的吊臂横在雾里。海风卷着煤灰和鱼腥穿过街巷，远处汽笛长鸣，惊起一群停在仓顶的黑鸟。\n\n排练室后门，莱尔拦住了塞西莉。\n\n“照常排练。”\n\n塞西莉看着里间，手指捏紧了贝斯背带。\n\n“她不是玛蒂尔达。”\n\n“所以才不能让她知道，我们已经发现了。”\n\n“那真的呢？”\n\n“还活着。”莱尔说，“至少她被带进货仓时还活着。”\n\n塞西莉喉咙动了一下。\n\n莱尔把帽檐压低：“明天的排练时间别改。她问起我，就说器材没问题，我也没看出什么。”\n\n“要演多久？”\n\n“演到她回去。”\n\n门里传来鼓槌敲击鼓边的声音，一下，又一下。分毫不差。\n\n塞西莉松开背带。\n\n“行。”\n\n当晚九点，珀西瓦尔赶到排练室对街。\n\n他的制服外面套了件旧风衣，风纪扣依旧扣到最上面。莱尔看了一眼，忍不住问：“不勒？”\n\n“值勤规范。”\n\n“你们局里连便衣怎么喘气都管？”\n\n珀西瓦尔没接这句。他递来一张港区监测仪分布图。\n\n“局长签了临时协查许可。没有正式立案，只能监视，不能搜查，更不能抓人。”\n\n“你们局长签得挺快。”\n\n“他说，你知道界线在哪儿。”\n\n莱尔折起地图，收进大衣内袋。\n\n这句话听着不像夸奖。\n\n排练在	default	\N	\N	2026-08-07 10:26:41.673876
50fe4f3a-01a7-4f46-a426-e52abc4cec58	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	批量生成: 第11章 清醒者的缺口	天刚亮，港区还泡在灰白的雾里。诊疗所的烟囱冒着黑烟，煤炉烧得太旺，碘酒味混着煮纱布的热气，从门缝一路钻到街上。\n\n莱尔坐在二楼走廊，膝上摊着一份晨报。六码头的事只占了豆腐大的一块，标题是“废弃货仓查获违禁剧具”。没有绑架，没有木偶，也没有异常管理局。\n\n写得真干净。\n\n病房里传出一声脆响。\n\n莱尔折起报纸，推门进去。\n\n药杯滚到床脚，里面的水洒了一地。玛蒂尔达半撑着身子，脸色发白，右手死死抓着被角。\n\n塞西莉站在床边，没敢碰她。\n\n“护士刚给她换药。”她压低声音，“她睡着以后一直在说话。”\n\n“说什么？”\n\n“别学我。”\n\n床上的人抬起头。\n\n短发贴在额前，眼下发青。她看了莱尔半天，才认出他。\n\n“我睡了多久？”\n\n“六个小时。”\n\n“我还以为……”玛蒂尔达扫了眼窗户，又去看门，“这里锁了吗？”\n\n莱尔走过去，推了推门。\n\n“没锁。楼下有两个治安官，窗外是三层楼。你想走门，没人拦。想走窗，我建议等手腕好了再试。”\n\n玛蒂尔达盯着敞开的门，手指松了些。\n\n塞西莉捡起药杯。\n\n“你昨天下午不该去排练。”\n\n“我能打。”\n\n“你只打了四小节。”\n\n“那是鼓槌太轻。”\n\n“你以前拿筷子都能打。	default	\N	\N	2026-08-07 10:56:09.920378
1d92ed4f-d2a2-4567-8930-8fff81d55793	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	批量生成: 第12章 死者的贵宾席	午后的钟楼剧院伏在旧城区中央，尖顶刺进一层铅灰色的云。钟盘停在十一点，几只鸽子挤在分针上，羽毛被风吹得乱翻。\n\n街上的马车绕过广场。镜头再往下，是剧院侧门。\n\n莱尔收起伞，鞋尖在台阶上磕了两下。塞西莉跟在他身后，右手缠着一圈新纱布。哈里特走在最前面，钥匙串撞着裙侧，叮叮作响。\n\n“档案室在顶楼？”\n\n“地下。”哈里特推开侧门，“顶楼漏雨，放账本的人没那么蠢。”\n\n门内一股热烘烘的灰尘味。舞台上有人试灯，电流滋啦作响。空座椅一排排陷在暗处，正中央那张贵宾席罩着红绒布，比旁边宽出半掌。\n\n塞西莉多看了一眼。\n\n哈里特没停，领着两人钻进舞台后的窄门。\n\n地下档案室比楼上更闷。纸张发潮，浆糊有股酸味，墙角搁着两只捕鼠夹，其中一只夹着半截尾巴。负责票务的老头把窗户推开一条缝，外头却是剧院的排污沟。\n\n味道更重了。\n\n“六月八日，城南加场。”哈里特将登记簿摊在桌上，“舞台流程、后台出入、临时票务，都在这几册。”\n\n老头瞥了莱尔一眼。\n\n“你是治安所的？”\n\n“比他们贵。”\n\n“那就是私家侦探。”\n\n“也可能是骗子。”\n\n老头把登记簿往回拖了一寸。\n\n哈里特按住封皮。\n\n“费用记在乐队账上。”\n\n“	default	\N	\N	2026-08-07 11:03:46.845284
af9002fe-3d7f-4948-9609-03834d4dfd5b	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	批量生成: 第13章 灰线账簿	雨从管理局黑色的尖顶上淌下来，沿石兽张开的嘴汇成水线，砸进街边排水沟。运河那头起了雾，煤气灯只剩一团团发黄的光。\n\n一辆出租马车停在台阶下。\n\n莱尔踩过积水，刚收起伞，门里便伸出一只戴白手套的手。\n\n“证物库不许带湿伞。”\n\n珀西瓦尔站在门后，制服扣到领口，脸色却有些发白。他接伞时右肩僵了一下，动作很轻，还是没躲过莱尔的眼睛。\n\n“墙撞得挺疼？”\n\n“肌肉酸痛。正常代价。”\n\n“你上次说贴两片就好。”\n\n“这次用了六片。”\n\n珀西瓦尔把伞交给值班员，转身领路。\n\n走廊里有消毒水和湿羊毛的味道。地下入口守着两名持枪职员，铁门后每隔十步便有一盏灯，灯罩上结着水汽。\n\n雷金纳德等在最后一道门前。\n\n他没穿外套，只穿深灰制服衬衣，袖子卷到肘部。宽厚的肩背几乎挡住半扇门。\n\n“许可只到今晚十二点。”他说，“你可以看，不可以单独碰。任何损坏，按妨害管理局调查处理。”\n\n莱尔看了眼墙上的钟。\n\n“现在九点十七分。您这顿晚饭看来不怎么合胃口。”\n\n“我没吃。”\n\n“那脾气差是天生的。”\n\n雷金纳德打开铁门。\n\n“费尔班克斯，记下这句。”\n\n证物库里更冷。\n\n潮湿的石墙往外渗水，空气中混着防腐油、旧木头	default	\N	\N	2026-08-07 11:07:59.347226
a837205e-8bc4-4ba0-a783-025190af729a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	批量生成: 第14章 开演许可	雨停后，钟楼剧院的铜顶从雾里露出来。白鸽绕着尖塔打转，羽翼掠过十二点不动的黑色指针。\n\n街面却堵得厉害。\n\n报童挤在马车之间，扯着嗓子叫卖号外。记者守住委员会侧门，镁光灯架在积水边，烧出的白烟呛得人咳嗽。\n\n莱尔下车时，距离听证开始还有七分钟。\n\n塞西莉站在台阶上，头发拢在耳后，外套扣错了一颗。她左手缠着新纱布，右手握着排练室钥匙。\n\n哈里特来回踱步，鞋跟敲得石板发响。\n\n“他们凭什么审我们？”她压着嗓子，“被绑的是玛蒂尔达，差点在台上出事的也是我们。”\n\n“凭剧院归他们管。”\n\n莱尔把一只牛皮箱递给塞西莉。\n\n箱子很沉。她接住后，包着纱布的手往下一坠。\n\n“这里面是什么？”\n\n“能让他们安静听你说话的东西。”\n\n“你确定？”\n\n“不确定。”\n\n哈里特停下脚。\n\n莱尔接着道：“但我带了三份副本。他们扔一份，我还有两份。”\n\n侧门打开，书记员叫了锈蔷薇的名字。\n\n听证厅在钟楼二层。\n\n屋里有旧木蜡、潮纸和热咖啡的味道。五名委员坐在弧形长桌后，正中是剧院委员会主席阿尔伯特·布莱。两侧旁听席挤满记者，纸张摩擦声连成一片。\n\n薇奥拉已经到了。\n\n她穿银灰色长裙，胸前没有佩戴银弦徽章。身边的律师	default	\N	\N	2026-08-07 11:12:30.36464
3818d740-e91b-4618-ad02-163d621ee3db	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c0a34e67-01f7-49c3-92cf-986d9824453b	批量生成: 第15章 迟半拍的鼓声	鼓槌在鼓面上横了一夜。\n\n第二天傍晚，钟楼剧院亮起整排煤气灯。长队从正门绕过报刊亭，一直排到街角。马车堵在雨后的泥水里，车夫骂个不停，卖热栗子的铁锅冒着白汽。\n\n钟楼下，有人举着“锈蔷薇不会登台”的号外。\n\n更多人把报纸折起来，塞进外套，继续往前挪。\n\n后台比外面更闷。\n\n脂粉、汗和烧热的电线混在一起。隔着幕布，观众的说话声压成一片，偶尔有人跺脚，震得化妆镜上的灯泡发颤。\n\n玛蒂尔达坐在木箱上，演出服已经换好。鼓槌却还装在皮套里。\n\n哈里特扯下手套，又戴回去。\n\n“让候补鼓手上。”\n\n“没有候补。”塞西莉说。\n\n“临时找一个。剧院乐队里总有人会打。”\n\n“会打和能跟上我们，是两回事。”\n\n“那也比台上停住强。”\n\n键盘手坐在墙角，一声没吭。小号手把铜管擦了三遍，还是在同一个地方打转。\n\n哈里特转向玛蒂尔达。\n\n“我不是要赶你走。”\n\n“我知道。”\n\n“就这一晚。”\n\n玛蒂尔达抬头看她。\n\n“那明晚呢？”\n\n哈里特张了张嘴。\n\n没人接话。\n\n走廊外响起三声敲门。舞台经理探进半个脑袋，额头全是汗。\n\n“还有十二分钟。开场曲再不定，我就按原单报幕了。”\n\n塞西莉把曲目单折起。\n\n“等两分钟。	default	\N	\N	2026-08-07 11:15:47.505194
9d129952-abbd-40f3-aa2d-191e5e1752b8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶	夜色压住格雷文赫。\n\n港区的吊臂横在雾里，铁钩被风吹得来回晃。煤灰贴着湿冷的石墙打转，鱼市收摊后留下的腥水漫过沟槽。远处汽笛拖出一声长鸣，仓顶的黑鸟齐齐飞起。\n\n排练室后门，莱尔拦住塞西莉。\n\n“照常排练。”\n\n塞西莉回头看了眼门内。灯光下，那个顶着玛蒂尔达面孔的东西正在调鼓凳，动作一顿一顿，手指每次都落在同一处。\n\n她捏紧贝斯背带。\n\n“她不是玛蒂尔达。”\n\n“所以不能让她知道，我们发现了。”\n\n“真的呢？”\n\n“还活着。”莱尔把帽檐往下压了压，“至少被带进货仓时还活着。”\n\n塞西莉喉咙动了一下。\n\n“明天的排练时间别改。她问起我，就说器材没问题，我也没看出什么。”\n\n“要演多久？”\n\n“演到她回去。”\n\n门里传来鼓槌敲击鼓边的声音。\n\n嗒。\n\n嗒。\n\n间隔分毫不差。\n\n塞西莉松开背带。\n\n“行。”\n\n当晚九点，珀西瓦尔赶到排练室对街。\n\n他的制服外套了件旧工装，风纪扣依旧扣得严实。两个管理局行动员扮成码头工，蹲在报刊亭旁抽烟。治安所的人藏在后巷马车里，车轮用破布裹住，没半点声音。\n\n“搜查令下来了。”珀西瓦尔递来折好的公文，“局长亲自签的。”\n\n莱尔没接。\n\n“他还说什么？”\n\n“	default	\N	\N	2026-08-14 23:06:47.004825
e4d76af1-8c28-4448-8ff3-b53fe3378791	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶	夜色压住格雷文赫。\n\n港区的吊臂横在雾里，铁钩被风吹得来回晃。煤灰贴着湿冷的石墙打转，鱼市收摊后留下的腥水漫过沟槽。远处汽笛拖出一声长鸣，仓顶的黑鸟全飞了起来。\n\n排练室后门，莱尔拦住塞西莉。\n\n“照常排练。”\n\n塞西莉回头看了眼门内。\n\n灯光下，那个顶着玛蒂尔达面孔的东西正在调鼓凳。它拧一下旋钮，停住，再拧一下。手指每次都落在同一处，分毫不差。\n\n她捏紧贝斯背带。\n\n“她不是玛蒂尔达。”\n\n“所以不能让她知道，我们发现了。”\n\n“真的呢？”\n\n“还活着。”莱尔把帽檐往下压了压，“至少被带进货仓时还活着。”\n\n塞西莉喉咙动了一下。\n\n“明天的排练时间别改。她问起我，就说器材没问题，我也没看出什么。”\n\n“要演多久？”\n\n“演到她回去。”\n\n门里传来鼓槌落地的声音。\n\n嗒。\n\n塞西莉推门进去，弯腰捡起鼓槌。\n\n“又掉了？”\n\n木偶抬头。玛蒂尔达的脸上没有多余表情。\n\n“手滑。”\n\n“那就再来一遍。”\n\n塞西莉把鼓槌递过去，手指没碰它的皮肤。\n\n排练持续到九点。\n\n木偶背起皮包离开时，塞西莉还在低头收线。门锁合上，她才直起腰，掌心全是背带压出的红印。\n\n窗外，两辆没有标识的马车先后驶过。\n	default	\N	\N	2026-08-14 23:27:52.193869
2e913872-b0c8-4b2e-b2ab-fdbdcfc57106	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶	夜色压住格雷文赫。\n\n港区的吊臂横在雾里，铁钩被风吹得来回晃。煤灰贴着湿冷的石墙打转，鱼市收摊后留下的腥水漫过沟槽。远处汽笛拖出一声长鸣，仓顶的黑鸟全飞了起来。\n\n排练室后门，莱尔拦住塞西莉。\n\n“照常排练。”\n\n塞西莉回头看了眼门内。\n\n灯光下，那个顶着玛蒂尔达面孔的东西正在调鼓凳。它拧一下旋钮，停住，再拧一下。手指每次都落在同一处，分毫不差。\n\n她捏紧贝斯背带。\n\n“她不是玛蒂尔达。”\n\n“所以不能让她知道，我们发现了。”\n\n“真的呢？”\n\n“还活着。”莱尔把帽檐往下压了压，“至少被带进货仓时还活着。”\n\n塞西莉喉咙动了一下。\n\n“明天的排练时间别改。她问起我，就说器材没问题，我也没看出什么。”\n\n“要演多久？”\n\n“演到它回去。”\n\n门里响起两下鼓点。\n\n一模一样的力度，连余音都差不多。\n\n塞西莉点头，转身前又问：“你呢？”\n\n莱尔看向巷口。一辆没有标记的黑色马车停在那里，车灯没点，轮廓藏在雾里。\n\n“我去找能踹门的人。”\n\n马车里有皮革、药水和湿呢料的味道。\n\n珀西瓦尔坐得笔直，管理局制服的风纪扣一颗不少。他膝上摊着记录板，纸角压着异常粒子测量仪。两名行动员挤在对面，靴底沾了港	default	\N	\N	2026-08-15 00:39:41.662207
2d104413-a922-4c61-a95d-8e659d5fe431	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶	夜色压住格雷文赫。\n\n港区的吊臂横在雾里，铁钩被风推得左右摇晃。煤灰贴着湿冷的石墙打转，鱼市收摊后留下的腥水漫过沟槽。远处汽笛拉出一声长鸣，仓顶的黑鸟哗啦一下，全飞了起来。\n\n排练室后门，莱尔拦住塞西莉。\n\n“照常排练。”\n\n塞西莉回头看了眼门内。\n\n灯下，那个顶着玛蒂尔达面孔的东西正在调鼓凳。它拧一下旋钮，停住，再拧一下。手指每次都落在同一处，分毫不差。\n\n她捏紧贝斯背带。\n\n“她不是玛蒂尔达。”\n\n“所以不能让她知道，我们发现了。”\n\n“真的呢？”\n\n“还活着。”莱尔压低帽檐，“至少被带进货仓时还活着。”\n\n塞西莉喉咙动了一下。\n\n“明天排练时间别改。她问起我，就说器材没问题，我也没看出什么。”\n\n“要演多久？”\n\n“演到她回去。”\n\n门内传来鼓槌敲击鼓边的声音。\n\n哒。哒。哒。\n\n三下，间隔一模一样。\n\n塞西莉松开背带，转身回去。\n\n“莱尔。”\n\n“嗯？”\n\n“把她带回来。”\n\n莱尔抬了下手，算是答应。\n\n半小时后，一辆异常管理局的黑色厢车停进两条街外的修械铺后院。\n\n车厢里塞满人。便携粒子测量仪搁在木箱上，指针贴着最低刻度晃动。珀西瓦尔坐在对面，制服风纪扣系到最上面，膝头放着一	default	\N	\N	2026-08-15 00:47:47.561111
411fcd16-6fb5-4f88-9019-8d4b014dd167	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶	夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水。\n\n莱尔靠在门边。塞西莉出来得很快，反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。\n\n“你早就知道了。”她说。\n\n“刚知道。”\n\n“她不是玛蒂尔达。”\n\n塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人。\n\n“不是。”莱尔说，“里面那个，不是玛蒂尔达。”\n\n塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了。“那真的玛蒂尔达在哪？”\n\n“肉仓库。”莱尔说，“港口区的旧货仓。我看见她被人绑进去的——至少被带进仓门的时候，人还活着。”\n\n“还活着。”塞西莉把三个字咬得发白。\n\n“活着。”莱尔说，“有呼吸，没有血。”\n\n“谁绑的？”\n\n“一个灰衣服的男人，还有一个披斗篷的女人。”莱尔顿了顿，“操偶师。木头做的假人，刻成玛蒂尔达的脸，放在乐队里当替身。皮包就是证据——包上读到的，不会错。”\n\n塞西莉的指甲一下抠进袖口。\n\n“为什么？”她问。\n\n“还不清楚。”莱尔说，“但那个假货	default	\N	\N	2026-08-16 22:40:33.018397
c2e4894e-fed2-4402-8891-5cc654e5e9af	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	创作章节: 第10章 木偶		default	\N	\N	2026-08-24 01:19:25.502104
bc4f9745-6b17-4616-a173-5545da04ec97	d59e468a-8617-41e0-aabf-87a13be78834	\N	创作章节: 第1章 绝境伪光	风裹着砂砾，抽在青灰色的石碑上。\n\n试灵台搭在镇口老槐树下，三丈见方，台面铺着一层暗红色的矿砂。张羽站在队伍里，前面还有十来个半大孩子，最小的那个正抹鼻涕。\n\n他低头看了看自己的手。十六岁的农户少年，指节粗糙，掌心有茧——这双手不属于他。\n\n三天前他还在实验室里记录气相色谱数据，下一秒就栽进了这具身体。原身的记忆像被水泡过的墨迹，模模糊糊能认出几个人名，再多的就没有了。\n\n"下一个。"\n\n执事坐在台侧的木椅上，眼皮都没抬。他穿着玄霄宗的青色袍服，胸口绣着一枚银色小剑，腰间挂着一只铜铃。\n\n前面那个男孩走上试灵台，把手按在石碑上。\n\n石碑顶端嵌着一块拳头大的原矿，灰扑扑的，没什么光泽。男孩按上去之后，原矿表面浮起一层淡蓝色的微光，像萤火虫困在玻璃罩里。\n\n"七品。"执事提笔在册子上写了个字，"过。"\n\n男孩松了口气，下台时腿都在抖。\n\n张羽盯着那块原矿，眯起眼。\n\n蓝光。他见过这种光。前世做植物药理分析时，某些生物碱在特定pH值下会发出类似波长的荧光。铜离子、铁离子、磷化物——特定元素受激发后释放光子，这是初中化学。\n\n问题是，这个世界不讲化学。\n\n"下一个。"\n\n他前面只剩一个人了。\n	default	\N	\N	2026-09-20 12:48:24.701138
bf6e4175-1a56-4b28-90f7-c0a62fc2beb0	d59e468a-8617-41e0-aabf-87a13be78834	\N	创作章节: 第2章 逆命初聚		default	\N	\N	2026-09-20 12:55:15.326179
9dcb06e1-21b7-49ea-b282-a90543a68f6f	d59e468a-8617-41e0-aabf-87a13be78834	\N	创作章节: 第2章 逆命初聚	灰蒙山峦间，玄霄宗外门像一块嵌在乱石中的锈铁。\n\n张羽沿着碎石道走了半个时辰，鞋底磨得发烫。路两边是低矮的茅棚，棚顶压着矿渣，风一吹就往下掉红灰。空气里弥漫着硫磺和汗酸味，混着远处丹炉飘来的焦糊气。\n\n外门弟子居所在山坳深处，三排土坯房，墙皮剥落，露出里头黄泥和碎石。每间屋子住八人，通铺，没有门板，只挂一张草帘。\n\n张羽被分到最靠西那间。\n\n屋里已经坐了四个人。靠墙那个壮汉正用矿镐尖刮靴底泥，身高近八尺，肩宽得像门板，裸露的手臂上布满黑紫色旧疤。他刮完泥，抬头扫了张羽一眼，又低下头继续磨镐尖。\n\n"新来的？"对面铺位上一个瘦高个正在啃干粮，嘴里塞得含含糊糊，"九品的？"\n\n张羽没答话，把皮囊放在铺角。\n\n"别问了，"瘦高个嚼着饼，"这屋四个，全是九品。外门最低一档，连杂役坊都看不上咱们。"\n\n"苏晚棠，少说两句。"墙角传来一个沙哑的声音。那人裹在破棉被里，只露出一张灰扑扑的脸，头发乱得像鸟窝，手指间夹着几根细竹签，正对着地面比划什么。\n\n苏晚棠翻了个白眼："墨渊，你又在画你的破阵法？画了三个月了，连个聚灵阵都聚不住灵气。"\n\n"聚不住是灵气有问题。"墨渊没抬头，竹签在泥地上划出一道浅痕	default	\N	\N	2026-09-20 12:56:27.776388
\.


--
-- Data for Name: mcp_plugins; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.mcp_plugins (id, user_id, plugin_name, display_name, description, plugin_type, server_url, command, args, env, headers, config, tools, enabled, status, last_error, last_test_at, category, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: organization_members; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.organization_members (id, organization_id, character_id, "position", rank, status, joined_at, left_at, loyalty, contribution, source, notes, created_at, updated_at) FROM stdin;
a6bb14d4-3498-4771-80f7-35b2d6c036c3	65f66da1-fa75-4f5b-9826-0fa4a4b194fb	aff03d10-b083-4bde-a165-34e8c9b3f9a8	藏经阁守阁人（长老名册上疑似为隐退的执律长老）	8	active	玄历一三二九年春	\N	60	0	auto	\N	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
d608cb44-5d51-4172-a62f-568a35bbead1	65f66da1-fa75-4f5b-9826-0fa4a4b194fb	27635aa9-65ae-48a8-8842-62dc121d86f0	杂役坊暗工（不入册，实际兼为藏经阁临时整理者）	1	active	玄历一三七一年九月	\N	30	0	auto	\N	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
40dd712f-3e82-45b6-8ff7-9245314da2df	65f66da1-fa75-4f5b-9826-0fa4a4b194fb	6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	废弃灵矿守矿人（原矿卫，因不愿参与收割被贬）	3	active	玄历一三六零年	\N	70	0	auto	\N	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
d8cc0da5-af4e-47fb-9228-f05763742ae6	f1a33196-6381-42a5-93fc-21ce83467d96	aff03d10-b083-4bde-a165-34e8c9b3f9a8	前档案司副司长（隐退/潜伏）	7	inactive	玄历一三四零年（已脱离）	\N	30	0	auto	\N	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
a51f2a58-bb49-405d-bc87-25283a5edf3f	f1a33196-6381-42a5-93fc-21ce83467d96	a4d5f38f-fea9-4947-8fc7-624ff8743955	外勤捕手（巡查司密探）	5	active	玄历一三六八年	\N	75	0	auto	\N	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
aa81b7ac-6065-446d-b1eb-b6cdaf5d0e74	c5f63dbe-218f-4682-9f43-63393b58bb9f	815122f4-2668-4b12-afe4-526216e2dd52	孩子	1	active	\N	\N	100	0	manual	\N	2026-08-05 23:28:24.732046	2026-08-05 23:28:24.732046
7835dbe6-f252-49b2-9d96-1e4309ea7484	c5f63dbe-218f-4682-9f43-63393b58bb9f	7024257f-32d9-486c-a9c4-0508478121fe	孩子	1	active	\N	\N	100	0	manual	\N	2026-08-05 23:28:35.451356	2026-08-05 23:28:35.451356
1a3dc973-67fd-4f70-a986-c39507512c12	c5f63dbe-218f-4682-9f43-63393b58bb9f	fc1e762e-6543-424b-b07d-4bb80aa494d0	院长	5	deceased	\N	第3章	100	0	manual	[第3章] 角色死亡	2026-08-05 23:28:07.704239	2026-08-06 00:34:48.609988
92a461a4-dbc3-4280-9ba0-a56c13478654	c8ccaf3f-285d-43e7-8c69-386f29dfbfc3	815122f4-2668-4b12-afe4-526216e2dd52	精英行动员	4	expelled	\N	第3章	55	0	ai	[第3章] betrayed: 发现灰烬之爪的纽扣出现在孤儿院袭击现场，克劳对组织的忠诚开始动摇	2026-08-05 22:56:26.703372	2026-08-06 12:55:57.832584
0c2a42a1-e96c-4cbe-b309-a079ac624213	dd0fd0fe-beec-4806-b960-7bdb141df70f	8405510d-a2eb-48be-ad35-2b92426638a5	工作人员	3	active	\N	\N	70	0	manual	\N	2026-08-06 23:30:50.667606	2026-08-06 23:31:03.826394
604294a4-d891-45b4-9ca7-3da43db66c2d	dd0fd0fe-beec-4806-b960-7bdb141df70f	ef11421f-5897-4eb3-92fd-2d3f5e8b4aa7	分局长	6	active	\N	\N	80	0	manual	\N	2026-08-05 23:36:53.141447	2026-08-06 23:31:08.185659
1b24a744-c96a-4d5c-af9f-74533ff11d93	008d4902-9126-4583-bfbc-6626054ac338	0fa03f01-5ba6-41cf-84f6-75e525f762df	店长	5	active	\N	\N	100	0	manual	\N	2026-08-07 00:02:26.145143	2026-08-07 00:02:26.145143
269d74a9-aefa-410f-bde4-814354d01da3	d45cf704-88c8-4a4a-b549-fa3b38b7a8a3	27635aa9-65ae-48a8-8842-62dc121d86f0	外门杂役	1	active	灵潮纪元三百零一年	\N	0	0	auto	\N	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609
70324553-e372-4d57-a08a-5f0fce5dd27c	d45cf704-88c8-4a4a-b549-fa3b38b7a8a3	0f0ef402-3ad1-45fc-be6a-582774193d14	外门药谷弟子	2	active	灵潮纪元三百零一年	\N	40	0	auto	\N	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609
f073daf6-7470-4467-8137-9095d007e27a	d45cf704-88c8-4a4a-b549-fa3b38b7a8a3	6c8b54f7-f20a-45db-bc7c-fa4d9413b67f	外门矿脉弟子	2	active	灵潮纪元三百零一年	\N	30	0	auto	\N	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609
7076dc77-ee37-450d-839a-16ea31b58c48	d45cf704-88c8-4a4a-b549-fa3b38b7a8a3	a4d5f38f-fea9-4947-8fc7-624ff8743955	外门坊市眼线	3	active	灵潮纪元三百零一年	\N	20	0	auto	\N	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609
33f88d1f-2ac6-4bf3-8c4f-071e62b14fc3	d45cf704-88c8-4a4a-b549-fa3b38b7a8a3	aff03d10-b083-4bde-a165-34e8c9b3f9a8	外门藏经阁守夜人	4	active	灵潮纪元三百零一年	\N	10	0	auto	\N	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.organizations (id, character_id, project_id, parent_org_id, level, power_level, member_count, location, motto, color, created_at, updated_at) FROM stdin;
65f66da1-fa75-4f5b-9826-0fa4a4b194fb	8718a55c-f7bd-4d24-b911-4220673dc052	d59e468a-8617-41e0-aabf-87a13be78834	\N	0	85	3	云梦泽深处天柱峰，天禀城及其周边的灵矿、灵田、泥瓦村落均在势力辐射范围内，另在大陆东域设有十余处矿场和灵草种植据点。	天启为纲，天赋为命。	五色霞光金	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
f1a33196-6381-42a5-93fc-21ce83467d96	7833c3ce-3d10-4780-865d-e77550aa78ed	d59e468a-8617-41e0-aabf-87a13be78834	\N	0	85	2	总部位于中州皇城钧天府，在大陆八方设巡查司，各城池设分司驻点，测灵石碑所在之处即是其势力延伸。与玄霄宗等大宗门保持监管与被监管的关系，同时通过问天大会渗透宗门弟子选拔。	天启有序，天赋有衡。	#1a2a4a	2026-08-05 13:44:59.446751	2026-08-05 13:44:59.446751
c5f63dbe-218f-4682-9f43-63393b58bb9f	8fd6410d-f1e5-4496-8e2e-7c458842f9a8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	0	0	3	\N	\N	\N	2026-08-05 23:27:30.561466	2026-08-06 15:47:58.844091
a353e267-629f-47bc-9acb-70f9e26e543f	d692271c-83b6-492f-b402-090750c2828e	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	0	40	0	格雷文赫城城东区老巷的临街小楼二层，月季咖啡厅楼上；主要活动区域覆盖城东各街区，偶尔延伸至蒸汽码头与钟楼广场一带。	小事求真，大隐于市	灰蓝色	2026-08-06 23:57:50.217738	2026-08-07 00:00:49.525752
7dca1d1a-03d5-4927-a269-2f289f1cf189	c98b5011-461a-4d2e-a688-62a8cfc1d808	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	0	60	0	\N	\N	\N	2026-08-05 23:29:54.977626	2026-08-05 23:30:04.802998
c8ccaf3f-285d-43e7-8c69-386f29dfbfc3	30bd11f5-56e6-4b2e-84d5-2e9124dd8494	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	0	60	1	每个城市的灰烬酒馆		黑色与暗红色	2026-08-05 22:56:26.703372	2026-08-05 23:30:11.625878
008d4902-9126-4583-bfbc-6626054ac338	fd004e38-2270-429e-b8ac-289b4088b5cf	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	0	10	1	\N	\N	\N	2026-08-07 00:01:18.68888	2026-08-07 00:02:26.145143
dd0fd0fe-beec-4806-b960-7bdb141df70f	c9e05d0e-7553-4795-b57d-3019fa912aa9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	\N	0	81	2	灰港城白塔区中央广场东侧，总部大楼；在每个区域都有分局		深蓝色	2026-08-05 23:31:56.12292	2026-08-15 00:43:31.425298
d45cf704-88c8-4a4a-b549-fa3b38b7a8a3	6172c65d-c986-4acd-bdb4-b26a26518315	d59e468a-8617-41e0-aabf-87a13be78834	\N	0	75	5	九州大陆登仙山，九脉交汇之地	灵根定命，仙途登天	玄青与月白	2026-09-19 23:15:35.243609	2026-09-19 23:15:35.243609
d13d4cb3-73f5-4d5e-afbf-25cd4c29ddb2	327e1676-6588-4805-8329-ad02ad06b786	d59e468a-8617-41e0-aabf-87a13be78834	\N	0	95	0	虚空之外及天元界本源深处	万物皆薪，界界可噬	暗紫色	2026-09-19 23:31:20.824352	2026-09-19 23:31:20.824352
\.


--
-- Data for Name: outlines; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.outlines (id, project_id, title, content, structure, order_index, created_at, updated_at) FROM stdin;
165cc86a-c575-44c6-9af7-498a161ff048	7f6d28c4-2a32-46d1-887c-6cf5c4555056	白塔阴影	在莱尔和克劳交换情报的同一时刻，白塔区异能登记局总部大楼的顶层办公室里，艾莉西亚·冯·海因里希正站在落地窗前，俯瞰着灰港城被海雾吞噬的街道。她的办公桌上摊着一份加密文件，文件封面标注着【圣心之家专项调查】的红色印章，但内容却与官方档案截然不同——文件详细记录了灭门案当晚的异能波动数据，数据显示，当晚圣心之家附近出现了远超常规的能量峰值，而能量来源并非孤儿院内部，而是来自外部的一次定向投射。艾莉西亚是贵族议会中最年轻的书记官，但她真实的身份是书灵议会安插在议会中的暗线。她刚刚收到一条加密通讯，通知她【修正者】已介入调查，因为有人触碰了世界之书的禁忌领域。艾莉西亚知道，修正者一旦出动，就意味着某个目标将被从现实中抹去。她调出监控记录，发现最近三天内，概率事务所的莱尔·西奥多频繁出入港口区，且其异能使用频率异常升高。她眉头微皱，手指轻轻敲击桌面——莱尔是她十五年前在圣心之家警戒线外见过的那个孩子，她记得他当时站在雨里，浑身湿透，却死死盯着燃烧的孤儿院，眼神里有一种近乎疯狂的光。艾莉西亚拿起电话，拨通了一个不对外公开的号码，接通后只说了一句话：我需要那个侦探的全部档案。与此同时，莱尔在事务所里接待了克劳带来的异能者少年。少年名叫米洛，十五岁，能力是【情绪感知】，代价是每使用一次就会失去一种味觉。米洛在矿场中亲眼见过那些被铁链锁住的旧书，他描述说，那些书的封面上没有任何文字，但翻开时能听到低语声，像是很多人在同时说话，而且每翻一页，周围的空气就会变冷一分。米洛还说，矿场里有一个穿白大褂的人，看起来像是研究者，但那个人的眼睛是纯黑色的，没有眼白。莱尔听完后，在剪报本上画出一条时间线：十五年前圣心之家灭门案，五年前黑曜山脉矿场开始秘密运作，三天前港口仓库出现黑袍人和泛黄书籍——这些事件之间似乎存在某种规律性的间隔，像是某种仪式正在按部就班地推进。他正沉思时，事务所的门被敲响。门外站着一个穿着深蓝色制服的女人，胸口别着异能登记局的金属徽章，她自称是来例行检查登记异能者状态的，但莱尔注意到她进门时目光迅速扫过桌上的剪报本和米洛，停留的时间明显超过了正常检查所需。莱尔不动声色地应付过去，却在女人离开后，从垃圾桶里发现了一张被丢弃的纸条，上面写着：【书灵议会已注意到你。】字迹与昨晚出现在他口袋里的警告纸条一模一样。克劳站在窗边，目光投向白塔区方向，低声说：看来我们已经被两股势力盯上了。莱尔把纸条夹进剪报本，合上，从抽屉里拿出一把旧钥匙——那是圣心之家孤儿院档案室的钥匙，他在灭门案后趁乱藏起来的。他看着钥匙上锈蚀的齿痕，对克劳说：我们需要去一趟圣心之家的废墟。那里有一些东西，十五年来我一直没敢去碰。但现在是时候了。夜色中，两人带着米洛，穿过锈带区荒废的街道，向城市边缘的圣心之家废墟走去。而他们身后，白塔区的阴影中，一双纯黑色的眼睛正从一扇高窗内注视着他们的背影。	{"chapter_number": 3, "title": "白塔阴影", "summary": "在莱尔和克劳交换情报的同一时刻，白塔区异能登记局总部大楼的顶层办公室里，艾莉西亚·冯·海因里希正站在落地窗前，俯瞰着灰港城被海雾吞噬的街道。她的办公桌上摊着一份加密文件，文件封面标注着【圣心之家专项调查】的红色印章，但内容却与官方档案截然不同——文件详细记录了灭门案当晚的异能波动数据，数据显示，当晚圣心之家附近出现了远超常规的能量峰值，而能量来源并非孤儿院内部，而是来自外部的一次定向投射。艾莉西亚是贵族议会中最年轻的书记官，但她真实的身份是书灵议会安插在议会中的暗线。她刚刚收到一条加密通讯，通知她【修正者】已介入调查，因为有人触碰了世界之书的禁忌领域。艾莉西亚知道，修正者一旦出动，就意味着某个目标将被从现实中抹去。她调出监控记录，发现最近三天内，概率事务所的莱尔·西奥多频繁出入港口区，且其异能使用频率异常升高。她眉头微皱，手指轻轻敲击桌面——莱尔是她十五年前在圣心之家警戒线外见过的那个孩子，她记得他当时站在雨里，浑身湿透，却死死盯着燃烧的孤儿院，眼神里有一种近乎疯狂的光。艾莉西亚拿起电话，拨通了一个不对外公开的号码，接通后只说了一句话：我需要那个侦探的全部档案。与此同时，莱尔在事务所里接待了克劳带来的异能者少年。少年名叫米洛，十五岁，能力是【情绪感知】，代价是每使用一次就会失去一种味觉。米洛在矿场中亲眼见过那些被铁链锁住的旧书，他描述说，那些书的封面上没有任何文字，但翻开时能听到低语声，像是很多人在同时说话，而且每翻一页，周围的空气就会变冷一分。米洛还说，矿场里有一个穿白大褂的人，看起来像是研究者，但那个人的眼睛是纯黑色的，没有眼白。莱尔听完后，在剪报本上画出一条时间线：十五年前圣心之家灭门案，五年前黑曜山脉矿场开始秘密运作，三天前港口仓库出现黑袍人和泛黄书籍——这些事件之间似乎存在某种规律性的间隔，像是某种仪式正在按部就班地推进。他正沉思时，事务所的门被敲响。门外站着一个穿着深蓝色制服的女人，胸口别着异能登记局的金属徽章，她自称是来例行检查登记异能者状态的，但莱尔注意到她进门时目光迅速扫过桌上的剪报本和米洛，停留的时间明显超过了正常检查所需。莱尔不动声色地应付过去，却在女人离开后，从垃圾桶里发现了一张被丢弃的纸条，上面写着：【书灵议会已注意到你。】字迹与昨晚出现在他口袋里的警告纸条一模一样。克劳站在窗边，目光投向白塔区方向，低声说：看来我们已经被两股势力盯上了。莱尔把纸条夹进剪报本，合上，从抽屉里拿出一把旧钥匙——那是圣心之家孤儿院档案室的钥匙，他在灭门案后趁乱藏起来的。他看着钥匙上锈蚀的齿痕，对克劳说：我们需要去一趟圣心之家的废墟。那里有一些东西，十五年来我一直没敢去碰。但现在是时候了。夜色中，两人带着米洛，穿过锈带区荒废的街道，向城市边缘的圣心之家废墟走去。而他们身后，白塔区的阴影中，一双纯黑色的眼睛正从一扇高窗内注视着他们的背影。", "scenes": ["白塔区异能登记局顶层，艾莉西亚查看加密文件，发现灭门案当晚存在外部异能投射，与书灵议会暗线身份呼应，得知修正者已介入", "概率事务所内，米洛描述矿场旧书的异常现象，莱尔画出事件时间线，发现规律性间隔，怀疑是仪式行为", "异能登记局人员例行检查后留下警告纸条，莱尔取出圣心之家档案室钥匙，决定前往废墟探查，两人出发后被白塔区方向的黑瞳人注视"], "characters": [{"name": "莱尔·西奥多", "type": "character"}, {"name": "克劳·沃尔特", "type": "character"}, {"name": "艾莉西亚·冯·海因里希", "type": "character"}, {"name": "书灵议会", "type": "organization"}], "key_points": ["艾莉西亚的真实身份为书灵议会暗线，掌握圣心之家灭门案的外部能量投射数据", "修正者已介入调查，暗示莱尔和克劳处于被抹杀的危险边缘", "米洛描述的旧书低语和黑瞳研究者，进一步揭示世界之书的存在与运作方式", "莱尔发现事件时间线的规律性间隔，怀疑灭门案是一场仪式，而非单一事件", "莱尔取出圣心之家档案室钥匙，决定主动探查废墟，开启下一阶段行动"], "emotion": "压迫感逐渐收紧，三方势力的目光同时聚焦于莱尔和克劳，旧案真相的轮廓在迷雾中若隐若现，但更深的黑暗才刚刚揭开一角", "goal": "引入艾莉西亚作为第三方势力视角，揭示书灵议会和修正者的存在，强化世界之书的规则与恐怖，同时推动莱尔和克劳从被动调查转向主动探查，为后续圣心之家废墟的探索埋下伏笔"}	3	2026-08-05 22:57:03.711535	2026-08-05 22:57:03.711535
f035327a-2add-4afe-bf92-2f2b9498cafa	7f6d28c4-2a32-46d1-887c-6cf5c4555056	替身疑云	自孤儿院事件已经过去十五年，现在莱尔开了一间侦探事务所。\n故事从莱尔的日常切入——他住在月季咖啡厅二楼的西奥多侦探事务所，靠找猫一类的小活营生，房东格蕾丝太太管他早餐，每天准时遛狗露西。\n这天锈蔷薇乐队主唱塞西莉与经纪人哈里特委托侦探莱尔调查鼓手玛蒂尔达被跟踪一事。塞西莉因鼓手玛蒂尔达被跟踪一事，先被治安所推给异常管理局，管理局新人珀西瓦尔查得六月三号晚铜锣巷口凯莉米粒子浓度全程常态，按规程不受理，珀西瓦尔想起雷金纳德局长的建议：对于麻烦的事可以去找莱尔的侦探事务所。因此建议塞西莉来寻求莱尔帮忙。\n塞西莉讲述六月三号排练散场后远远看见无声黑影跟踪玛蒂尔达，此后玛蒂尔达打鼓钝了半拍、反应变慢、眼神不对。莱尔解释粒子浓度原理——浓度衡量现实被搅动程度，未过线不代表无事，提出催眠侧写黑影。塞西莉答应后，莱尔却掏出了吐真剂要给塞西莉打针，结果最后当然是被拒绝。\n莱尔先赴铜锣巷现场，以异能触摸物件读取其"记忆"，侧写出跟踪者样貌（矮、络腮胡、眉骨深、嘴角疤、手指沾油墨），但两条痕迹在暗巷断裂。转查人：治安所档案查无此人，之后通过灰烬酒馆查出跟踪者是文森特·惠特莫尔，但此人在案发之前就离城，是因公出差，线索再断。莱尔改查物，借排练室摸玛蒂尔达的黑色皮包回溯，揭露核心反转——玛蒂尔达已被绑架囚于旧货仓，身边那个是照她模样雕成的木偶替身，由灰衣操偶师每夜驱动。双视角收拢信息：反派斗篷女人与操偶师交代阴谋全貌——跟踪的也是做木偶替身，就是防止被人发现时，可以混淆视线。绑架鼓手的目的是为了在演唱会当众唱砸，挤掉锈蔷薇的签约与舞台；莱尔完成全盘推理，定计演唱会前跟踪替身夜归以找到货仓，此时距演出还有六天。寻找到货仓后，并寻找到有利的证据链，报案后抓捕了嫌疑人并成功营救鼓手	{\n  "chapter_number": 2,\n  "title": "替身疑云",\n  "summary": "自孤儿院事件已经过去十五年，现在莱尔开了一间侦探事务所。\\n故事从莱尔的日常切入——他住在月季咖啡厅二楼的西奥多侦探事务所，靠找猫一类的小活营生，房东格蕾丝太太管他早餐，每天准时遛狗露西。\\n这天锈蔷薇乐队主唱塞西莉与经纪人哈里特委托侦探莱尔调查鼓手玛蒂尔达被跟踪一事。塞西莉因鼓手玛蒂尔达被跟踪一事，先被治安所推给异常管理局，管理局新人珀西瓦尔查得六月三号晚铜锣巷口凯莉米粒子浓度全程常态，按规程不受理，珀西瓦尔想起雷金纳德局长的建议：对于麻烦的事可以去找莱尔的侦探事务所。因此建议塞西莉来寻求莱尔帮忙。\\n塞西莉讲述六月三号排练散场后远远看见无声黑影跟踪玛蒂尔达，此后玛蒂尔达打鼓钝了半拍、反应变慢、眼神不对。莱尔解释粒子浓度原理——浓度衡量现实被搅动程度，未过线不代表无事，提出催眠侧写黑影。塞西莉答应后，莱尔却掏出了吐真剂要给塞西莉打针，结果最后当然是被拒绝。\\n莱尔先赴铜锣巷现场，以异能触摸物件读取其\\"记忆\\"，侧写出跟踪者样貌（矮、络腮胡、眉骨深、嘴角疤、手指沾油墨），但两条痕迹在暗巷断裂。转查人：治安所档案查无此人，之后通过灰烬酒馆查出跟踪者是文森特·惠特莫尔，但此人在案发之前就离城，是因公出差，线索再断。莱尔改查物，借排练室摸玛蒂尔达的黑色皮包回溯，揭露核心反转——玛蒂尔达已被绑架囚于旧货仓，身边那个是照她模样雕成的木偶替身，由灰衣操偶师每夜驱动。双视角收拢信息：反派斗篷女人与操偶师交代阴谋全貌——跟踪的也是做木偶替身，就是防止被人发现时，可以混淆视线。绑架鼓手的目的是为了在演唱会当众唱砸，挤掉锈蔷薇的签约与舞台；莱尔完成全盘推理，定计演唱会前跟踪替身夜归以找到货仓，此时距演出还有六天。寻找到货仓后，并寻找到有利的证据链，报案后抓捕了嫌疑人并成功营救鼓手",\n  "characters": [\n    {\n      "name": "莱尔·西奥多",\n      "type": "character"\n    },\n    {\n      "name": "珀西瓦尔·费尔班克斯",\n      "type": "character"\n    },\n    {\n      "name": "格蕾丝",\n      "type": "character"\n    },\n    {\n      "name": "塞西莉·辛克莱",\n      "type": "character"\n    },\n    {\n      "name": "玛蒂尔达·斯特林",\n      "type": "character"\n    },\n    {\n      "name": "西奥多侦探事务所",\n      "type": "organization"\n    },\n    {\n      "name": "月季咖啡厅",\n      "type": "organization"\n    },\n    {\n      "name": "灰烬酒馆",\n      "type": "organization"\n    },\n    {\n      "name": "异常管理局",\n      "type": "organization"\n    }\n  ],\n  "scenes": [\n    {\n      "location": "月季咖啡厅/西奥多侦探事务所二楼→格雷文赫异常管理局报案台→铜锣巷现场→西区治安所档案室→铁玫瑰酒馆→排练室→城郊旧货仓→莱尔事务所",\n      "characters": [\n        "莱尔",\n        "格蕾丝太太",\n        "露西",\n        "珀西瓦尔",\n        "塞西莉",\n        "哈里特",\n        "治安所文书",\n        "酒馆情报贩子",\n        "玛蒂尔达（木偶替身）",\n        "斗篷女人",\n        "灰衣操偶师",\n        "真玛蒂尔达"\n      ],\n      "purpose": "查清玛蒂尔达被跟踪真相，营救真人"\n    }\n  ],\n  "key_points": [\n    "建立委托与世界观（凯莉米粒子/异能/异常管理局）；揭示莱尔核心异能（物件记忆回溯）并完成跟踪者侧写；线索三次断裂（暗巷/档案/狗仔离城）驱动查法转向；借皮包回溯揭开木偶替身真相（核心反转）；双视角交代反派阴谋全貌与动机（抢舞台）；莱尔完成推理并定计与救出鼓手。"\n  ],\n  "emotion": "由悬疑试探渐入惊悚压抑，终至阴冷紧迫的暗中角力。",\n  "goal": "完成\\"委托→勘查→查人→反转→定计\\"完整弧线，揭露替身阴谋，建立倒计时紧迫感，为后续营救行动铺垫。"\n}	2	2026-08-05 22:57:03.711535	2026-08-07 00:07:52.572048
a9bcfa47-5a17-442f-85dd-c050b209c378	7f6d28c4-2a32-46d1-887c-6cf5c4555056	往事	描写莱尔童年时的日常生活，十二岁的莱尔在晨星孤儿院后院与伙伴们玩躲猫猫，用纯推理逐一找出各个小伙伴。童年时他就表现出了聪明的一面，会偷偷利用自己的异能在游戏中“作弊”找到伙伴们，赢得胜利。这个时候异能者还未被公开宣传，仅有玛丽修女知道莱尔的能力，玛丽修女告诫莱尔要慎重使用异能。\n第二天玛丽修女让莱尔和克劳外出采购物资，克劳路上告诉莱尔前一阵子听说有个叫什么异常管理局（其实是假冒的，后面章节会提）的上门来收集异能者的信息，询问晨星孤儿院有无异能者，玛丽修女回答孩子们都没有，仅有她自己是治疗。克劳告诉莱尔，他也有能力，曾经以为自己是异于常人的，结果似乎也不是仅有他一个异类。\n在采购回去后，发现孤儿院惨遭灭门，莱尔和克劳去找治安管理所报案。治安官很快带人封锁了现场并勘察，莱尔他们在治安所待了3天以便接受问询。第三天午饭后，年轻干员雷金纳德·洛克哈特（异常管理局）在二楼会议室正式接触两人，莱尔观察到他携带了一个"晨星孤儿院异常事件"文件袋，里面存放了一些资料并问询莱尔他们一些情况，包括案情、人员、有无可疑人员、有无异常事件、有无异能者。雷金纳德还解释凯莉米粒子与浓度判定，说明这个意外很可能是异能者所为。\n但莱尔从雷金纳德德提问中，发现孤儿院资料中却没有玛丽修女信息，因为玛丽修女明确告诉过异常管理局的人信息。因此猜测之前的人是冒充异常管理局的，从而反问雷金纳德是否有人冒充异常管理局人员。雷金纳德记下特征但拒透露组织名，承诺查清并加强保护。\n临走雷金纳德追问莱尔如何知道自己姓名——两人无语同时指向他胸前工牌，以一个好笑的结局结束。	{\n  "chapter_number": 1,\n  "title": "往事",\n  "summary": "描写莱尔童年时的日常生活，十二岁的莱尔在晨星孤儿院后院与伙伴们玩躲猫猫，用纯推理逐一找出各个小伙伴。童年时他就表现出了聪明的一面，会偷偷利用自己的异能在游戏中“作弊”找到伙伴们，赢得胜利。这个时候异能者还未被公开宣传，仅有玛丽修女知道莱尔的能力，玛丽修女告诫莱尔要慎重使用异能。\\n第二天玛丽修女让莱尔和克劳外出采购物资，克劳路上告诉莱尔前一阵子听说有个叫什么异常管理局（其实是假冒的，后面章节会提）的上门来收集异能者的信息，询问晨星孤儿院有无异能者，玛丽修女回答孩子们都没有，仅有她自己是治疗。克劳告诉莱尔，他也有能力，曾经以为自己是异于常人的，结果似乎也不是仅有他一个异类。\\n在采购回去后，发现孤儿院惨遭灭门，莱尔和克劳去找治安管理所报案。治安官很快带人封锁了现场并勘察，莱尔他们在治安所待了3天以便接受问询。第三天午饭后，年轻干员雷金纳德·洛克哈特（异常管理局）在二楼会议室正式接触两人，莱尔观察到他携带了一个\\"晨星孤儿院异常事件\\"文件袋，里面存放了一些资料并问询莱尔他们一些情况，包括案情、人员、有无可疑人员、有无异常事件、有无异能者。雷金纳德还解释凯莉米粒子与浓度判定，说明这个意外很可能是异能者所为。\\n但莱尔从雷金纳德德提问中，发现孤儿院资料中却没有玛丽修女信息，因为玛丽修女明确告诉过异常管理局的人信息。因此猜测之前的人是冒充异常管理局的，从而反问雷金纳德是否有人冒充异常管理局人员。雷金纳德记下特征但拒透露组织名，承诺查清并加强保护。\\n临走雷金纳德追问莱尔如何知道自己姓名——两人无语同时指向他胸前工牌，以一个好笑的结局结束。",\n  "scenes": [\n    {\n      "location": "晨星孤儿院",\n      "characters": [\n        "克劳",\n        "莱尔",\n        "玛丽修女"\n      ],\n      "purpose": "描写日常生活"\n    },\n    {\n      "location": "晨星孤儿院附近的杂货店",\n      "characters": [\n        "克劳",\n        "莱尔"\n      ],\n      "purpose": "采购物资"\n    },\n    {\n      "location": "晨星孤儿院附近的治安管理所",\n      "characters": [\n        "克劳",\n        "莱尔"\n      ],\n      "purpose": "报案"\n    },\n    {\n      "location": "晨星孤儿院附近的治安管理所",\n      "characters": [\n        "克劳",\n        "莱尔",\n        "雷金纳德"\n      ],\n      "purpose": "问询"\n    }\n  ],\n  "characters": [\n    {\n      "name": "莱尔·西奥多",\n      "type": "character"\n    },\n    {\n      "name": "克劳·沃尔特",\n      "type": "character"\n    },\n    {\n      "name": "玛丽修女",\n      "type": "character"\n    },\n    {\n      "name": "雷金纳德·洛克哈特",\n      "type": "character"\n    },\n    {\n      "name": "晨星孤儿院",\n      "type": "organization"\n    },\n    {\n      "name": "异常管理局",\n      "type": "organization"\n    }\n  ],\n  "key_points": [\n    "捉迷藏-主要引出莱尔的回溯能力，并突出了莱尔的冷静、聪明",\n    "偷听与袒露心声-克劳偷听到异常管局人员的谈话后，与莱尔畅谈",\n    "灭门-克劳、莱尔遭遇悲剧后，主动报案，等待排查结果"\n  ],\n  "emotion": "日常欢愉到悲伤",\n  "goal": "讲述主角们的童年生活，引入异能者的世界观"\n}	1	2026-08-05 22:57:03.711535	2026-08-06 14:58:31.831488
96f10a16-070b-4e1b-82f0-6e962b5b6f3f	d59e468a-8617-41e0-aabf-87a13be78834	第一卷 风起微末	灵潮纪元，天赋决定一切，十六岁测灵便是凡人命运的绝对分水岭，无天赋者不仅永为泥泞，甚至面临被炼为药人的绝境。张羽本是小镇农户之子，灵魂深处藏着现代人的平等观念，对高高在上的天赋阶层本能反感却只能深藏不露。试灵台上，面对测灵碑的绝对威压，他深知自己毫无伴生灵根，一旦暴露必死无疑。凭借前世记忆中对能量波动的理解，他以强大的精神力强行牵引外界灵气在特定经脉中流转，伪装出极其微弱、若有若无的"隐灵根"异象。这种异象被判定为极罕见的变异灵根，勉强获得入宗资格，被贬至最底层的杂役坊。\n\n进入天璇宗杂役坊，张羽见识到了天赋至上的残酷真相。高天赋者肆意欺压，杂役如牛马，为半块灵石打破头是常态。没有外挂傍身，他只能依靠远超常人的努力与极度缜密的时间管理，偷学外门基础功法。他必须在人前维持"隐灵根废材但够用"的人设，暗中却以近乎自虐的方式填补没有灵根自动吸纳灵气的短板，每晚只睡两个时辰，靠肉体与意志硬抗灵气灌体的痛楚，甚至不惜服用有微毒的草药来模拟灵根运转的体表特征。期间，他因一次灵矿劳作结识了同样底层的石铁心，两人在矿洞塌方中生死与共，石铁心替他挡下致命落石，两人因对高阶修士的共同敌意与对命运的不甘而结成生死之交。\n\n在照料宗门药园以换取微薄修炼资源的过程中，张羽遇到了为救重病亲人而忍气吞声、倔强柔软的柳若霜。柳若霜为了换取一株完整的天星草，不惜以身试药，张羽利用前世的知识（伪装成偶然发现），帮助柳若霜解决了一株珍贵灵植的枯死危机，两人达成互助同盟，互相掩盖秘密。张羽在底层挣扎中，敏锐地察觉到灵气中那一丝若有若无的驳杂与腐朽气息，以及外门弟子在突破时偶尔流露出的神魂透支异象，这为他后续探索世界真相埋下了深深的伏笔。\n\n卷末，宗门举行外门选拔考核，杂役亦有一线生机。张羽面临暴露的危机，必须在实战中不露馅。他利用对敌人招式的极致预判和地形利用，如履薄冰般勉强过关。然而，考核中一次极限爆发（实为濒临暴露的应急操作）意外引动了测灵碑的共鸣，其"隐灵根"的特殊性引起了外门执事的注意，获得了破格升入外门的契机，同时也引来了某些有心人的暗中窥探，为下一卷破格进入内门、遇到墨渊和苏晚棠以及发现魂契收割做完美铺垫。	{"volume_number": 1, "title": "第一卷 风起微末", "phase": "开端", "summary": "灵潮纪元，天赋决定一切，十六岁测灵便是凡人命运的绝对分水岭，无天赋者不仅永为泥泞，甚至面临被炼为药人的绝境。张羽本是小镇农户之子，灵魂深处藏着现代人的平等观念，对高高在上的天赋阶层本能反感却只能深藏不露。试灵台上，面对测灵碑的绝对威压，他深知自己毫无伴生灵根，一旦暴露必死无疑。凭借前世记忆中对能量波动的理解，他以强大的精神力强行牵引外界灵气在特定经脉中流转，伪装出极其微弱、若有若无的\\"隐灵根\\"异象。这种异象被判定为极罕见的变异灵根，勉强获得入宗资格，被贬至最底层的杂役坊。\\n\\n进入天璇宗杂役坊，张羽见识到了天赋至上的残酷真相。高天赋者肆意欺压，杂役如牛马，为半块灵石打破头是常态。没有外挂傍身，他只能依靠远超常人的努力与极度缜密的时间管理，偷学外门基础功法。他必须在人前维持\\"隐灵根废材但够用\\"的人设，暗中却以近乎自虐的方式填补没有灵根自动吸纳灵气的短板，每晚只睡两个时辰，靠肉体与意志硬抗灵气灌体的痛楚，甚至不惜服用有微毒的草药来模拟灵根运转的体表特征。期间，他因一次灵矿劳作结识了同样底层的石铁心，两人在矿洞塌方中生死与共，石铁心替他挡下致命落石，两人因对高阶修士的共同敌意与对命运的不甘而结成生死之交。\\n\\n在照料宗门药园以换取微薄修炼资源的过程中，张羽遇到了为救重病亲人而忍气吞声、倔强柔软的柳若霜。柳若霜为了换取一株完整的天星草，不惜以身试药，张羽利用前世的知识（伪装成偶然发现），帮助柳若霜解决了一株珍贵灵植的枯死危机，两人达成互助同盟，互相掩盖秘密。张羽在底层挣扎中，敏锐地察觉到灵气中那一丝若有若无的驳杂与腐朽气息，以及外门弟子在突破时偶尔流露出的神魂透支异象，这为他后续探索世界真相埋下了深深的伏笔。\\n\\n卷末，宗门举行外门选拔考核，杂役亦有一线生机。张羽面临暴露的危机，必须在实战中不露馅。他利用对敌人招式的极致预判和地形利用，如履薄冰般勉强过关。然而，考核中一次极限爆发（实为濒临暴露的应急操作）意外引动了测灵碑的共鸣，其\\"隐灵根\\"的特殊性引起了外门执事的注意，获得了破格升入外门的契机，同时也引来了某些有心人的暗中窥探，为下一卷破格进入内门、遇到墨渊和苏晚棠以及发现魂契收割做完美铺垫。", "key_points": ["试灵台伪装：张羽在绝境中以精神力强行模拟隐灵根，骗过测灵碑，死里逃生", "杂役坊结盟：与石铁心在矿洞塌方中生死与共，与柳若霜在药园互助，建立底层生存同盟", "察觉暗流：敏锐感知灵气驳杂与突破时的神魂透支异象，埋下探索世界真相的伏笔", "外门选拔危机：实战考核中如履薄冰，凭借极致微操过关，因隐灵根特殊性引起高层关注"], "characters": ["张羽", "石铁心", "柳若霜"], "organizations": ["天璇宗", "噬界者"], "scenes": ["山脚试灵台：万民等待裁决，灵光闪烁间众生狂喜与绝望交织", "外门杂役坊：阴暗潮湿的角落，底层修士为了碎灵石打破头", "登仙山灵矿洞：幽暗深邃，矿镐声伴随着压抑的喘息与生死危机"], "emotion": "压抑、紧张、如履薄冰", "goal": "建立世界观压抑基调，展现主角无天赋的危机与伪装智慧，完成底层生存的初始闭环", "estimated_words": 200000, "narrative_goal": "建立世界观压抑基调，展现主角无天赋的危机与伪装智慧，完成底层生存的初始闭环"}	1	2026-09-20 14:03:48.675684	2026-09-20 14:03:48.675684
116ccfb0-bf70-4462-a4f2-a1a24332623d	d59e468a-8617-41e0-aabf-87a13be78834	第二卷 暗流涌动	张羽在杂役坊如履薄冰的日子因一次意外戛然而止。宗门大比前夕，他为救一名遇险的低阶弟子，体内伪装的"隐灵根"在极度危机下被强行激发，灵气波动竟呈现出罕见的极品异象。这一异象惊动了内门长老，张羽破格被提拔为内门弟子，正式踏入天璇宗真正的权力与利益中心。然而，内门并非乐土，而是更为残酷的修罗场。天赋等级划分在此处被演绎到极致，高阶弟子视低阶为草芥，资源争夺血腥而隐蔽。进入内门后，张羽刻意藏锋，却依旧被卷入漩涡。他遇到了看似邋遢懒散、实则眼光毒辣的藏书阁执事墨渊，以及笑里藏刀、看似没心没肺实则心思缜密的内门师姐苏晚棠。墨渊一眼看穿张羽修炼方式的异样，却没有点破，反而以古籍为饵，试探他的底细；苏晚棠则对张羽的"隐灵根"极感兴趣，几次三番设局试探。三人在一次宗门秘境探索中因利益纠葛被迫合作：张羽需要墨渊的掩护和苏晚棠的情报网，墨渊需要一个听话且极具潜力的棋子去探查宗门暗流，苏晚棠则需要张羽的"隐灵根"特性去盗取秘境中的核心资源。三人结成貌合神离的利益同盟。随着修为提升，张羽敏锐地察觉到宗门内的灵气日益驳杂，修炼时不仅吸纳灵气，更有一种微弱的"抽离感"，仿佛自身的生机与本源正在被某种无形之物窃取。他利用墨渊提供的权限，在藏经阁的故纸堆中寻找蛛丝马迹，发现天璇宗乃至整个修仙界的灵气都在走向枯竭，而宗门高层对此不仅讳莫如深，反而在暗中加速。更令他毛骨悚然的是，宗门内开始频繁出现低阶弟子失踪事件，张羽顺藤摸瓜，发现了隐藏在星辰大殿地下的"魂契收割"真相——高阶长老以秘法催化弟子突破，待其神魂成熟后强行收割，作为供给"天启之门"的耗材。柳若霜因展现出过人的草药天赋，被盯上成为下一批收割对象。为救柳若霜，张羽不得不打破低调行事的准则，暗中破坏了一次收割仪式，虽成功救人，却留下了破绽。天衡司的暗探开始注意到灵气波动的异常，玄霄宗也向天璇宗投来审视的目光。与此同时，张羽在墨渊的指引下，于秘境深处意外触碰到了一块残破的上古石碑（分灵碑的碎片），刹那间，他隐约感知到了所谓"天赋"的恐怖真相——那并非天赐的灵根，而是寄生在修士身上的枷锁与吸盘。这一认知令他道心险些崩溃，但他强行稳住心神。然而，这次触碰也触发了禁制，张羽的伪装在禁制反噬下出现裂痕。苏晚棠敏锐地捕捉到了他体内灵气的诡异断层，虽被他用秘法暂时搪塞过去，但怀疑的种子已经种下。本卷结尾，张羽虽然在内门初步站稳脚跟，建立了脆弱的同盟，但他已经置身于宗门核心的暗流之中。天衡司的暗探逼近，柳若霜死里逃生，墨渊的引路越发危险，苏晚棠的怀疑如悬顶之剑。张羽深知，他正走在一条通往深渊的钢丝上，而那关于世界本源的残酷真相，已如冰山一角，露出了狰狞的轮廓。	{"volume_number": 2, "title": "第二卷 暗流涌动", "phase": "发展", "summary": "张羽在杂役坊如履薄冰的日子因一次意外戛然而止。宗门大比前夕，他为救一名遇险的低阶弟子，体内伪装的\\"隐灵根\\"在极度危机下被强行激发，灵气波动竟呈现出罕见的极品异象。这一异象惊动了内门长老，张羽破格被提拔为内门弟子，正式踏入天璇宗真正的权力与利益中心。然而，内门并非乐土，而是更为残酷的修罗场。天赋等级划分在此处被演绎到极致，高阶弟子视低阶为草芥，资源争夺血腥而隐蔽。进入内门后，张羽刻意藏锋，却依旧被卷入漩涡。他遇到了看似邋遢懒散、实则眼光毒辣的藏书阁执事墨渊，以及笑里藏刀、看似没心没肺实则心思缜密的内门师姐苏晚棠。墨渊一眼看穿张羽修炼方式的异样，却没有点破，反而以古籍为饵，试探他的底细；苏晚棠则对张羽的\\"隐灵根\\"极感兴趣，几次三番设局试探。三人在一次宗门秘境探索中因利益纠葛被迫合作：张羽需要墨渊的掩护和苏晚棠的情报网，墨渊需要一个听话且极具潜力的棋子去探查宗门暗流，苏晚棠则需要张羽的\\"隐灵根\\"特性去盗取秘境中的核心资源。三人结成貌合神离的利益同盟。随着修为提升，张羽敏锐地察觉到宗门内的灵气日益驳杂，修炼时不仅吸纳灵气，更有一种微弱的\\"抽离感\\"，仿佛自身的生机与本源正在被某种无形之物窃取。他利用墨渊提供的权限，在藏经阁的故纸堆中寻找蛛丝马迹，发现天璇宗乃至整个修仙界的灵气都在走向枯竭，而宗门高层对此不仅讳莫如深，反而在暗中加速。更令他毛骨悚然的是，宗门内开始频繁出现低阶弟子失踪事件，张羽顺藤摸瓜，发现了隐藏在星辰大殿地下的\\"魂契收割\\"真相——高阶长老以秘法催化弟子突破，待其神魂成熟后强行收割，作为供给\\"天启之门\\"的耗材。柳若霜因展现出过人的草药天赋，被盯上成为下一批收割对象。为救柳若霜，张羽不得不打破低调行事的准则，暗中破坏了一次收割仪式，虽成功救人，却留下了破绽。天衡司的暗探开始注意到灵气波动的异常，玄霄宗也向天璇宗投来审视的目光。与此同时，张羽在墨渊的指引下，于秘境深处意外触碰到了一块残破的上古石碑（分灵碑的碎片），刹那间，他隐约感知到了所谓\\"天赋\\"的恐怖真相——那并非天赐的灵根，而是寄生在修士身上的枷锁与吸盘。这一认知令他道心险些崩溃，但他强行稳住心神。然而，这次触碰也触发了禁制，张羽的伪装在禁制反噬下出现裂痕。苏晚棠敏锐地捕捉到了他体内灵气的诡异断层，虽被他用秘法暂时搪塞过去，但怀疑的种子已经种下。本卷结尾，张羽虽然在内门初步站稳脚跟，建立了脆弱的同盟，但他已经置身于宗门核心的暗流之中。天衡司的暗探逼近，柳若霜死里逃生，墨渊的引路越发危险，苏晚棠的怀疑如悬顶之剑。张羽深知，他正走在一条通往深渊的钢丝上，而那关于世界本源的残酷真相，已如冰山一角，露出了狰狞的轮廓。", "key_points": ["张羽隐灵根意外激发破格升入内门", "与墨渊苏晚棠因利益结盟互相试探", "发现灵气驳杂与宗门魂契收割真相", "初触分灵碑碎片感知天赋寄生本质", "救柳若霜留下破绽伪装险些暴露"], "character_arcs": ["张羽：从底层求生的被动伪装转向主动探寻真相，意识到天赋体制的残酷，开始构建同盟并尝试反抗，内心对世界的认知发生颠覆性动摇。", "墨渊：从颓丧旁观者逐渐展露锋芒，对张羽从利用转为认可，成为其暗流中的引路人，护短本性初显。", "苏晚棠：从笑里藏刀的利用者，因张羽的底线与挣扎产生微妙共情，同盟关系由纯粹利益向情感羁绊偏移。"], "characters": ["张羽", "墨渊", "苏晚棠", "柳若霜", "石铁心"], "organizations": ["天璇宗", "玄霄宗", "天衡司"], "scenes": ["内门藏经阁故纸堆", "灵气驳杂的秘境深处", "星辰大殿地下魂契暗室"], "emotion": "紧张/压抑/诡谲", "goal": "将视角从底层求生转向宗门内部暗斗，埋下世界本源被蚕食的核心悬念，丰富配角形象", "estimated_words": 250000, "narrative_goal": "将视角从底层求生转向宗门内部暗斗，埋下世界本源被蚕食的核心悬念，丰富配角形象"}	2	2026-09-20 14:03:48.675684	2026-09-20 14:03:48.675684
0321512a-203b-462c-9dc5-37dea395644a	d59e468a-8617-41e0-aabf-87a13be78834	第三卷 破茧惊变	承接上一卷的暗流涌动，张羽在墨渊的暗中指引下，获得了一枚上古残卷，开始反向推演灵气驳杂的根源。他发现修士吸纳的灵气中夹杂着微弱的意志烙印，这些烙印如同寄生虫般附着在灵根之上。张羽震惊地推导出真相：所谓的天赋，不过是外界势力"噬界者"投放的"分灵器"碎片，修士修炼越勤奋，实则是在帮噬界者提炼世界本源。这一发现令他毛骨悚然，但他并未声张，而是试图寻找分灵碑的实体证据。\n\n利用内门弟子的身份，张羽与擅长草药的柳若霜合作，发现灵植本源的枯竭与灵根觉醒的微妙联系，两人结伴潜入宗门禁地——测灵圣殿的深层。在那里，他们目睹了分灵碑的投影，那是一块不断搏动、犹如活体心脏般的诡异石碑，正将九州大陆的灵气转化为噬界者所需的养分。张羽以隐灵根强行解析分灵碑的运转机制，试图找到切断本源外流的办法。\n\n然而，隐灵根与分灵碑的共鸣意外触发了宗门的预警禁制。张羽"无天赋"却修为高绝的异样彻底暴露在玄霄宗与天衡司的视野中。为了掩盖收割世界的秘密，玄霄宗与天衡司联手下达追杀令，甚至不惜以"天弃之人"的罪名清洗张羽的亲友。柳若霜为保护张羽行踪以身犯险，石铁心在矿区为掩护张羽浴血奋战，苏晚棠的暗探网络被连根拔起。\n\n亲友的鲜血彻底击碎了张羽"苟且偷生"的幻想。在追杀中，张羽被逼入宗门禁地深处的"葬灵渊"——一处被噬界者抽干本源后留下的灵气绝地。这里是世界的伤疤，充满了绝望与死寂。在深渊底部，张羽直面了噬界者残留的意志投影，对方视九州生灵如圈养之猪羊，傲慢地宣告收割的必然。面对绝境与强敌，张羽再无退路，他彻底撕碎隐灵根的压制，以凡人之躯吞噬深渊中残存的狂暴灵气，不仅突破境界，更领悟了反制分灵碑的法门。\n\n从葬灵渊爬出的张羽，眼神再无往日的恭顺与谨慎，取而代之的是破茧重生的决绝。他深知这天赋至上的世界本就是一座巨大的牧场，若不反抗，众生皆亡。他带着亲友的遗志与幸存的同伴，踏出深渊，正式向这吃人的旧秩序与噬界者宣战，为下一卷组建"逆命"、掀起反侵略浪潮吹响了号角。	{"volume_number": 3, "title": "第三卷 破茧惊变", "phase": "转折", "summary": "承接上一卷的暗流涌动，张羽在墨渊的暗中指引下，获得了一枚上古残卷，开始反向推演灵气驳杂的根源。他发现修士吸纳的灵气中夹杂着微弱的意志烙印，这些烙印如同寄生虫般附着在灵根之上。张羽震惊地推导出真相：所谓的天赋，不过是外界势力\\"噬界者\\"投放的\\"分灵器\\"碎片，修士修炼越勤奋，实则是在帮噬界者提炼世界本源。这一发现令他毛骨悚然，但他并未声张，而是试图寻找分灵碑的实体证据。\\n\\n利用内门弟子的身份，张羽与擅长草药的柳若霜合作，发现灵植本源的枯竭与灵根觉醒的微妙联系，两人结伴潜入宗门禁地——测灵圣殿的深层。在那里，他们目睹了分灵碑的投影，那是一块不断搏动、犹如活体心脏般的诡异石碑，正将九州大陆的灵气转化为噬界者所需的养分。张羽以隐灵根强行解析分灵碑的运转机制，试图找到切断本源外流的办法。\\n\\n然而，隐灵根与分灵碑的共鸣意外触发了宗门的预警禁制。张羽\\"无天赋\\"却修为高绝的异样彻底暴露在玄霄宗与天衡司的视野中。为了掩盖收割世界的秘密，玄霄宗与天衡司联手下达追杀令，甚至不惜以\\"天弃之人\\"的罪名清洗张羽的亲友。柳若霜为保护张羽行踪以身犯险，石铁心在矿区为掩护张羽浴血奋战，苏晚棠的暗探网络被连根拔起。\\n\\n亲友的鲜血彻底击碎了张羽\\"苟且偷生\\"的幻想。在追杀中，张羽被逼入宗门禁地深处的\\"葬灵渊\\"——一处被噬界者抽干本源后留下的灵气绝地。这里是世界的伤疤，充满了绝望与死寂。在深渊底部，张羽直面了噬界者残留的意志投影，对方视九州生灵如圈养之猪羊，傲慢地宣告收割的必然。面对绝境与强敌，张羽再无退路，他彻底撕碎隐灵根的压制，以凡人之躯吞噬深渊中残存的狂暴灵气，不仅突破境界，更领悟了反制分灵碑的法门。\\n\\n从葬灵渊爬出的张羽，眼神再无往日的恭顺与谨慎，取而代之的是破茧重生的决绝。他深知这天赋至上的世界本就是一座巨大的牧场，若不反抗，众生皆亡。他带着亲友的遗志与幸存的同伴，踏出深渊，正式向这吃人的旧秩序与噬界者宣战，为下一卷组建\\"逆命\\"、掀起反侵略浪潮吹响了号角。", "key_points": ["张羽解析灵气异变，发现天赋实为噬界者抽取世界本源的寄生虫，世界观彻底反转", "潜入测灵圣殿获取分灵碑证据，隐灵根共鸣触发警报，身份暴露遭玄霄宗与天衡司联合追杀", "亲友受迫害，张羽跌入葬灵渊绝境，直面噬界者意志，撕碎伪装决心反侵略"], "characters": ["张羽", "柳若霜", "墨渊", "苏晚棠", "石铁心"], "organizations": ["玄霄宗", "天衡司", "测灵圣殿", "噬界者"], "scenes": ["测灵圣殿深层：分灵碑投影所在，灵气如血管般搏动，诡异而压抑，揭示世界本源被抽取的真相", "葬灵渊：灵气枯竭的绝地，世界的伤疤，充满死寂与绝望，张羽在此直面噬界者意志并绝境反杀"], "emotion": "紧张、压抑、悲壮、决绝", "goal": "打破主角的舒适区，揭露核心世界观反转，将故事主线从生存求生彻底扭转为反侵略抗争", "estimated_words": 250000, "narrative_goal": "打破主角的舒适区，揭露核心世界观反转，将故事主线从生存求生彻底扭转为反侵略抗争"}	3	2026-09-20 14:03:48.675684	2026-09-20 14:03:48.675684
8bd32580-eafd-4e7a-9038-08b85a6f381a	d59e468a-8617-41e0-aabf-87a13be78834	第四卷 星火燎原	本卷承接张羽跌落深渊后的绝境，讲述他在灵气荒漠与废弃矿脉中悟道重生，凭借对灵气本质的透彻理解，独创"逆命诀"——一种剥离分灵器干扰、直接吸纳天地本源的修炼法门。张羽深知单凭一己之力无法撼动庞然大物，遂暗中集结石铁心、苏晚棠、墨渊、柳若霜等同样受天赋阶级压迫的底层修士，组建反抗组织"逆命"。初期，逆命组织如星火般微弱，张羽率众以游击战术，奇袭天璇宗外门坊市与测灵台，以无天赋之身越阶碾压所谓天骄，夺取了大量修炼资源。这一连串的胜利不仅打破了"天赋即一切"的铁律，更在底层修士中点燃了反抗的火种。随着逆命组织势力扩张，张羽开始主动破坏噬界者的外围收割节点。柳若霜利用草药天赋破解丹方，炼制出剔除分灵器毒素的丹药；苏晚棠以话痨伪装渗透天衡司底层，窃取情报；墨渊布置隐匿阵法，建立地下据点；石铁心则训练出一支悍不畏死的矿奴军。在一次针对天衡司资源转运队的伏击战中，张羽当众施展逆命诀，强行切断敌方修士与分灵器的连接，令其瞬间跌落境界，以凡人之躯碾杀三名筑基期天骄，震惊九州。此役过后，逆命之名传遍天下，无数底层修士来投，星火渐成燎原之势。玄霄宗与天衡司震怒，联合被蛊惑的宗门势力展开大规模清剿。面对数倍于己的强敌，张羽没有硬拼，而是利用对灵气循环的深刻理解，设下"绝灵大阵"，反杀追兵，并揭露了分灵碑抽取世界本源的隐秘，动摇了敌方底层修士的军心。在生死存亡之际，张羽成功策反了部分对天赋制度不满的宗门长老，里应外合粉碎了围剿。经此一役，逆命组织从暗中潜伏转为半公开抗争，张羽正式向天赋至上的旧秩序宣战，打响了反侵略的第一枪。同时，张羽发现外围节点只是冰山一角，真正的核心在"测灵圣殿"深处，而噬界者也已注意到这个变数，正加速降临，为最终决战埋下伏笔。	{"volume_number": 4, "title": "第四卷 星火燎原", "phase": "崛起", "summary": "本卷承接张羽跌落深渊后的绝境，讲述他在灵气荒漠与废弃矿脉中悟道重生，凭借对灵气本质的透彻理解，独创\\"逆命诀\\"——一种剥离分灵器干扰、直接吸纳天地本源的修炼法门。张羽深知单凭一己之力无法撼动庞然大物，遂暗中集结石铁心、苏晚棠、墨渊、柳若霜等同样受天赋阶级压迫的底层修士，组建反抗组织\\"逆命\\"。初期，逆命组织如星火般微弱，张羽率众以游击战术，奇袭天璇宗外门坊市与测灵台，以无天赋之身越阶碾压所谓天骄，夺取了大量修炼资源。这一连串的胜利不仅打破了\\"天赋即一切\\"的铁律，更在底层修士中点燃了反抗的火种。随着逆命组织势力扩张，张羽开始主动破坏噬界者的外围收割节点。柳若霜利用草药天赋破解丹方，炼制出剔除分灵器毒素的丹药；苏晚棠以话痨伪装渗透天衡司底层，窃取情报；墨渊布置隐匿阵法，建立地下据点；石铁心则训练出一支悍不畏死的矿奴军。在一次针对天衡司资源转运队的伏击战中，张羽当众施展逆命诀，强行切断敌方修士与分灵器的连接，令其瞬间跌落境界，以凡人之躯碾杀三名筑基期天骄，震惊九州。此役过后，逆命之名传遍天下，无数底层修士来投，星火渐成燎原之势。玄霄宗与天衡司震怒，联合被蛊惑的宗门势力展开大规模清剿。面对数倍于己的强敌，张羽没有硬拼，而是利用对灵气循环的深刻理解，设下\\"绝灵大阵\\"，反杀追兵，并揭露了分灵碑抽取世界本源的隐秘，动摇了敌方底层修士的军心。在生死存亡之际，张羽成功策反了部分对天赋制度不满的宗门长老，里应外合粉碎了围剿。经此一役，逆命组织从暗中潜伏转为半公开抗争，张羽正式向天赋至上的旧秩序宣战，打响了反侵略的第一枪。同时，张羽发现外围节点只是冰山一角，真正的核心在\\"测灵圣殿\\"深处，而噬界者也已注意到这个变数，正加速降临，为最终决战埋下伏笔。", "key_points": ["张羽于深渊绝境中悟道，独创剥离分灵器干扰的\\"逆命诀\\"，并集结石铁心、苏晚棠、墨渊、柳若霜等底层修士组建\\"逆命\\"组织", "逆命组织以游击战术奇袭天璇宗外门与测灵台，张羽以无天赋之身越阶碾压天骄，夺取资源，在底层修士中点燃反抗火种", "逆命组织伏击天衡司转运队，张羽当众强行切断敌方与分灵器连接，碾杀筑基期天骄，逆命之名传遍九州，星火发展为燎原之势", "玄霄宗与天衡司联合围剿逆命，张羽设\\"绝灵大阵\\"反杀，揭露分灵碑抽取本源隐秘动摇敌军，并成功策反宗门长老，粉碎围剿，正式向旧秩序宣战"], "characters": ["柳若霜", "苏晚棠", "墨渊"], "organizations": ["逆命", "测灵圣殿"], "scenes": ["废弃矿脉深处，张羽向石铁心等人展示逆命诀，剥离其体内分灵器碎片，众人首次感受到不受操控的纯粹灵气运转，宣誓成立逆命组织", "天衡司资源转运峡谷，张羽以凡人之躯独战三名筑基期天骄，强行切断他们与分灵器的联系，当众碾杀，逆命旗帜首次飘扬于九州大地"], "emotion": "激昂", "goal": "提供密集爽点，展现主角对抗全世界的魄力，将反抗势力从星火发展为燎原之势", "estimated_words": 250000, "narrative_goal": "提供密集爽点，展现主角对抗全世界的魄力，将反抗势力从星火发展为燎原之势"}	4	2026-09-20 14:03:48.675684	2026-09-20 14:03:48.675684
23802a4d-aa12-478c-9de7-68d7add8c442	d59e468a-8617-41e0-aabf-87a13be78834	第五卷 伐天之战	噬界者感知到逆命组织对其收割体系的致命威胁，决定加速降临进程，以雷霆之势彻底吞噬天元界本源。一时间，天地灵气急剧紊乱，灵脉大面积枯竭，天灾频发，九州大陆陷入末日般的恐慌。张羽深知决战时刻已至，逆命组织从暗处走向明处，于登仙山星辰大殿发出"伐天令"，号召天下不愿为奴的修士共同反抗噬界者的压迫。\n\n张羽亲赴九州各大宗门游说，揭露天赋真相。然而，玄霄宗、天衡司等既得利益集团早已被噬界者深度控制，疯狂镇压异见，内部出现血腥清洗。部分底层修士和觉醒大能选择加入逆命，但也有不少宗门因长期被蛊惑而视逆命为仇敌。张羽在游说过程中遭遇多次暗杀与背叛，但凭借超凡的智慧与实力一次次化险为夷，其声望与日俱增，逐渐成为天下反抗势力的精神图腾。\n\n噬界者开启"天启之门"，虚空裂缝遍布九州大陆，噬界者先锋降临。灵气驳杂到极致，无数低阶修士因灵根反噬而陷入疯狂或当场死亡。逆命组织建立防线，保护凡人撤退。惨烈的遭遇战中，石铁心为掩护一群凡人孩童撤离，独挡噬界者先锋，身受重伤，却以矿镐劈开一条血路；苏晚棠在情报战中身份暴露，被噬界者追兵围杀，展现出冷静到近乎冷酷的杀戮本能后重伤垂死，被墨渊以命为代价救回；柳若霜则在混乱中发现噬界者先锋的力量与灵根存在某种共鸣，这一发现为后续大战提供了关键情报。\n\n张羽整合逆命组织、觉醒大能以及部分正义宗门，组成"伐天联军"，决定直捣噬界者大本营——测灵圣殿深处的"分灵碑"核心。大战分为多条战线同时推进：石铁心带领矿修死士冲击外层防线，以血肉之躯撕开噬界者的防御阵法；苏晚棠负责情报渗透与刺杀敌方指挥节点，在无声处听惊雷；柳若霜研制出克制噬界者的特殊丹药，大幅削弱敌方战力；墨渊以毕生所学布置封印大阵，试图封锁最大的虚空裂缝；张羽则率精锐直取分灵碑。\n\n战斗惨烈到极致。墨渊为封印最大的虚空裂缝，燃烧自身神魂为代价，以命换得联军突破时间，临终前将毕生阵法心得托付给柳若霜。张羽在分灵碑前遭遇噬界者首领的意志投影，发现分灵碑不仅是收割本源的工具，更是噬界者降临的锚点。张羽以凡躯沟通被禁锢的世界本源，获得本源之力加持，与噬界者首领展开意志与力量的双重对决。在同伴的牺牲与帮助下，张羽找到分灵碑的核心弱点——它需要持续的本源供给才能维持运转。张羽引导逆命成员切断各地分灵碑碎片的联系，同时以自身为媒介，反向吞噬分灵碑的力量。\n\n分灵碑崩碎，噬界者降临通道被彻底切断，但张羽承受了分灵碑崩碎的反噬，修为尽废，陷入昏迷。战后的世界满目疮痍，但灵气开始逐渐恢复纯净。噬界者势力大损，但其首领仍负隅顽抗，为下一卷的最终决战埋下伏笔。张羽的牺牲精神感召了更多人，逆命组织从反抗军开始转变为重建秩序的守护者，而柳若霜、苏晚棠等人则肩负起照顾昏迷的张羽、继续未竟事业的使命。	{"volume_number": 5, "title": "第五卷 伐天之战", "phase": "巅峰", "summary": "噬界者感知到逆命组织对其收割体系的致命威胁，决定加速降临进程，以雷霆之势彻底吞噬天元界本源。一时间，天地灵气急剧紊乱，灵脉大面积枯竭，天灾频发，九州大陆陷入末日般的恐慌。张羽深知决战时刻已至，逆命组织从暗处走向明处，于登仙山星辰大殿发出\\"伐天令\\"，号召天下不愿为奴的修士共同反抗噬界者的压迫。\\n\\n张羽亲赴九州各大宗门游说，揭露天赋真相。然而，玄霄宗、天衡司等既得利益集团早已被噬界者深度控制，疯狂镇压异见，内部出现血腥清洗。部分底层修士和觉醒大能选择加入逆命，但也有不少宗门因长期被蛊惑而视逆命为仇敌。张羽在游说过程中遭遇多次暗杀与背叛，但凭借超凡的智慧与实力一次次化险为夷，其声望与日俱增，逐渐成为天下反抗势力的精神图腾。\\n\\n噬界者开启\\"天启之门\\"，虚空裂缝遍布九州大陆，噬界者先锋降临。灵气驳杂到极致，无数低阶修士因灵根反噬而陷入疯狂或当场死亡。逆命组织建立防线，保护凡人撤退。惨烈的遭遇战中，石铁心为掩护一群凡人孩童撤离，独挡噬界者先锋，身受重伤，却以矿镐劈开一条血路；苏晚棠在情报战中身份暴露，被噬界者追兵围杀，展现出冷静到近乎冷酷的杀戮本能后重伤垂死，被墨渊以命为代价救回；柳若霜则在混乱中发现噬界者先锋的力量与灵根存在某种共鸣，这一发现为后续大战提供了关键情报。\\n\\n张羽整合逆命组织、觉醒大能以及部分正义宗门，组成\\"伐天联军\\"，决定直捣噬界者大本营——测灵圣殿深处的\\"分灵碑\\"核心。大战分为多条战线同时推进：石铁心带领矿修死士冲击外层防线，以血肉之躯撕开噬界者的防御阵法；苏晚棠负责情报渗透与刺杀敌方指挥节点，在无声处听惊雷；柳若霜研制出克制噬界者的特殊丹药，大幅削弱敌方战力；墨渊以毕生所学布置封印大阵，试图封锁最大的虚空裂缝；张羽则率精锐直取分灵碑。\\n\\n战斗惨烈到极致。墨渊为封印最大的虚空裂缝，燃烧自身神魂为代价，以命换得联军突破时间，临终前将毕生阵法心得托付给柳若霜。张羽在分灵碑前遭遇噬界者首领的意志投影，发现分灵碑不仅是收割本源的工具，更是噬界者降临的锚点。张羽以凡躯沟通被禁锢的世界本源，获得本源之力加持，与噬界者首领展开意志与力量的双重对决。在同伴的牺牲与帮助下，张羽找到分灵碑的核心弱点——它需要持续的本源供给才能维持运转。张羽引导逆命成员切断各地分灵碑碎片的联系，同时以自身为媒介，反向吞噬分灵碑的力量。\\n\\n分灵碑崩碎，噬界者降临通道被彻底切断，但张羽承受了分灵碑崩碎的反噬，修为尽废，陷入昏迷。战后的世界满目疮痍，但灵气开始逐渐恢复纯净。噬界者势力大损，但其首领仍负隅顽抗，为下一卷的最终决战埋下伏笔。张羽的牺牲精神感召了更多人，逆命组织从反抗军开始转变为重建秩序的守护者，而柳若霜、苏晚棠等人则肩负起照顾昏迷的张羽、继续未竟事业的使命。", "key_points": ["噬界者加速降临，天启之门开启，九州大陆陷入末日危机，逆命组织发出伐天令", "张羽游说各方势力组建伐天联军，遭遇暗杀与背叛，声望日隆成为反抗精神图腾", "遭遇战中石铁心、苏晚棠重伤，柳若霜发现噬界者弱点与灵根共鸣有关", "伐天联军直捣分灵碑，墨渊燃烧神魂封印虚空裂缝，张羽与噬界者首领意志对决", "分灵碑崩碎切断降临通道，张羽承受反噬修为尽废陷入昏迷，噬界者首领仍负隅顽抗"], "characters": ["张羽", "柳若霜", "苏晚棠", "墨渊", "石铁心"], "organizations": ["逆命", "测灵圣殿", "噬界者", "玄霄宗", "天衡司"], "scenes": ["登仙山星辰大殿——逆命发出伐天令的誓师之地，天下反抗势力云集响应", "天启之门——虚空裂缝遍布九州，噬界者先锋降临的末日景象，灵气驳杂导致修士疯狂", "测灵圣殿深处——分灵碑核心，最终战场，张羽与噬界者首领意志对决的所在"], "emotion": "悲壮、激昂、热血", "goal": "将剧情推向最高潮，以宏大战争场面和终极对决，完成打破枷锁、解救世界的核心使命", "estimated_words": 200000, "narrative_goal": "将剧情推向最高潮，以宏大战争场面和终极对决，完成打破枷锁、解救世界的核心使命"}	5	2026-09-20 14:03:48.675684	2026-09-20 14:03:48.675684
2643cd6e-dd43-45b2-ab90-dcc1e8daf8d3	d59e468a-8617-41e0-aabf-87a13be78834	第六卷 我命由我	本卷为全书终章，承接上卷伐天之战的惨烈尾声，聚焦于最终决战与世界重塑。开篇于满目疮痍的天元界废墟之上，噬界者主力虽已覆灭，但其首领——'噬界之主'仍负隅顽抗，它以残存的分灵碑碎片为巢穴，汲取最后的世界本源，化为不可名状的扭曲存在，试图拉着整个世界陪葬。张羽与逆命组织的幸存者们，虽伤痕累累、本源受损，但信念如钢。他们深知，这是最后的战争。张羽整合所有力量，联合柳若霜、苏晚棠、墨渊、石铁心等核心伙伴，以及被唤醒的九州残余正派势力，发动最终决战。战斗并非简单的力量对轰，而是张羽以自身为'无天赋者'的独特位格为引，逆向解析噬界之主的能量结构，寻找其核心破绽。过程中，伙伴们各展所长：柳若霜以丹药维系众人生命，苏晚棠以话术与幻术干扰噬界之主的精神侵蚀，墨渊以阵法封锁其退路，石铁心则以悍不畏死的近战为其争取机会。最终，张羽抓住那稍纵即逝的契机，以凡躯证道，并非借用天赋之力，而是将自身不屈意志与对'我命由我'的极致领悟化为无匹一击，彻底击碎噬界之主的核心，终结了这场延续不知多久的入侵。随着噬界者势力的彻底消散，最大的变革降临：分灵碑崩碎，所有被植入的伪灵根开始消散。这并非末日，而是新生。被禁锢的世界本源如洪流般反哺天地，灵气循环重构，驳杂褪去，重归纯净。修仙体系发生根本性变革，天赋不再是唯一标尺，努力、心性、悟性重新获得价值，世界进入'后天赋时代'。张羽作为变革的推手，却选择功成身退。他并未成为新世界的帝王或守护神，而是将重建秩序的责任交还给众生。他与柳若霜、苏晚棠等同伴携手，归于平凡，或许是开一间小小的药铺，或许是云游四方，在经历了血与火的洗礼后，享受来之不易的和平与宁静。故事在温馨释然的氛围中收尾，张羽望着不再被'天赋'阴霾笼罩的星空，心中圆满。'我命由我不由天'的主题在此刻得到终极升华——真正的命运掌握在自己手中，无论有无外挂，人的意志与选择才是照亮前路的光。	{"volume_number": 6, "title": "第六卷 我命由我", "phase": "结局", "summary": "本卷为全书终章，承接上卷伐天之战的惨烈尾声，聚焦于最终决战与世界重塑。开篇于满目疮痍的天元界废墟之上，噬界者主力虽已覆灭，但其首领——'噬界之主'仍负隅顽抗，它以残存的分灵碑碎片为巢穴，汲取最后的世界本源，化为不可名状的扭曲存在，试图拉着整个世界陪葬。张羽与逆命组织的幸存者们，虽伤痕累累、本源受损，但信念如钢。他们深知，这是最后的战争。张羽整合所有力量，联合柳若霜、苏晚棠、墨渊、石铁心等核心伙伴，以及被唤醒的九州残余正派势力，发动最终决战。战斗并非简单的力量对轰，而是张羽以自身为'无天赋者'的独特位格为引，逆向解析噬界之主的能量结构，寻找其核心破绽。过程中，伙伴们各展所长：柳若霜以丹药维系众人生命，苏晚棠以话术与幻术干扰噬界之主的精神侵蚀，墨渊以阵法封锁其退路，石铁心则以悍不畏死的近战为其争取机会。最终，张羽抓住那稍纵即逝的契机，以凡躯证道，并非借用天赋之力，而是将自身不屈意志与对'我命由我'的极致领悟化为无匹一击，彻底击碎噬界之主的核心，终结了这场延续不知多久的入侵。随着噬界者势力的彻底消散，最大的变革降临：分灵碑崩碎，所有被植入的伪灵根开始消散。这并非末日，而是新生。被禁锢的世界本源如洪流般反哺天地，灵气循环重构，驳杂褪去，重归纯净。修仙体系发生根本性变革，天赋不再是唯一标尺，努力、心性、悟性重新获得价值，世界进入'后天赋时代'。张羽作为变革的推手，却选择功成身退。他并未成为新世界的帝王或守护神，而是将重建秩序的责任交还给众生。他与柳若霜、苏晚棠等同伴携手，归于平凡，或许是开一间小小的药铺，或许是云游四方，在经历了血与火的洗礼后，享受来之不易的和平与宁静。故事在温馨释然的氛围中收尾，张羽望着不再被'天赋'阴霾笼罩的星空，心中圆满。'我命由我不由天'的主题在此刻得到终极升华——真正的命运掌握在自己手中，无论有无外挂，人的意志与选择才是照亮前路的光。", "key_points": ["噬界之主以残存分灵碑碎片为巢穴，化为扭曲存在，试图拉世界陪葬，最终决战爆发。", "张羽以'无天赋者'位格逆向解析噬界之主，联合伙伴各展所长，最终以凡躯证道，凝聚不屈意志一击终结入侵。", "分灵碑崩碎，伪灵根消散，被禁锢的世界本源反哺天地，灵气循环重构，修仙体系变革，天赋不再定尊卑，世界进入'后天赋时代'。", "张羽功成身退，将重建秩序的责任交还众生，与柳若霜、苏晚棠等同伴携手归隐，在温馨释然中迎来和平新纪元，完美升华'我命由我'主题。"], "characters": ["柳若霜", "苏晚棠", "墨渊"], "organizations": ["逆命", "测灵圣殿"], "scenes": ["废墟终战：于满目疮痍的天元界废墟核心，扭曲的噬界之主巢穴前，逆命组织与残存势力集结，进行最终决战。场景宏大而惨烈，能量风暴肆虐，信念与绝望交织。", "本源重塑：分灵碑崩碎、伪灵根消散的瞬间，世界本源如金色洪流冲刷天地，灵气循环重构。场景充满神圣与新生感，从破败转向纯净，视觉上从阴霾压抑转向光明温暖。", "归隐日常：战后，张羽与同伴在一处宁静的山间小镇开设药铺或漫步于市井。场景平淡温馨，充满生活气息，与之前的血战形成强烈对比，凸显和平的珍贵与'我命由我'的最终归宿。"], "emotion": "由决战的紧张、悲壮，转向胜利的激昂、畅快，最终归于温馨、释然与圆满。", "goal": "收束所有伏笔，解决外部矛盾与内部情感线，在温馨氛围中升华\\"我命由我\\"的主题，完美收官", "estimated_words": 50000, "narrative_goal": "收束所有伏笔，解决外部矛盾与内部情感线，在温馨氛围中升华\\"我命由我\\"的主题，完美收官"}	6	2026-09-20 14:03:48.675684	2026-09-20 14:03:48.675684
\.


--
-- Data for Name: plot_analysis; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.plot_analysis (id, project_id, chapter_id, plot_stage, conflict_level, conflict_types, emotional_tone, emotional_intensity, emotional_curve, hooks, hooks_count, hooks_avg_strength, foreshadows, foreshadows_planted, foreshadows_resolved, plot_points, plot_points_count, character_states, scenes, pacing, overall_quality_score, pacing_score, engagement_score, coherence_score, analysis_report, suggestions, word_count, dialogue_ratio, description_ratio, created_at) FROM stdin;
ee6ab938-7f4a-4625-8a44-085212b151b3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	发展	7	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	紧张沉郁	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u8ddf\\u8e2a\\u8005\\u9762\\u5bb9\\u88ab\\u9501\\u5b9a\\uff0c\\u4f46\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u884c\\u8e2a\\u5728\\u7a7a\\u5730\\u5f7b\\u5e95\\u6d88\\u5931\\uff0c\\u5979\\u5230\\u5e95\\u53bb\\u4e86\\u54ea\\u91cc\\uff1f\\u662f\\u5426\\u5df2\\u7ecf\\u906d\\u9047\\u4e0d\\u6d4b\\uff1f", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u739b\\u8482\\u5c14\\u8fbe\\u53ef\\u80fd\\u56de\\u4e86\\u5bb6\\u3002\\u4e5f\\u53ef\\u80fd\\uff0c\\u5979\\u4ece\\u6765\\u6ca1\\u6709\\u8d70\\u51fa\\u90a3\\u7247\\u7a7a\\u5730\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u8ddf\\u8e2a\\u8005\\u7684\\u8eab\\u4efd\\uff1a\\u77ee\\u4e2a\\u5b50\\u3001\\u7edc\\u816e\\u80e1\\u3001\\u53f3\\u5634\\u89d2\\u65e7\\u75a4\\u3001\\u624b\\u67d3\\u6cb9\\u58a8\\uff0c\\u4ed6\\u7a76\\u7adf\\u662f\\u4ec0\\u4e48\\u4eba\\uff1f", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u77ee\\u4e2a\\u5b50\\u3002\\u7edc\\u816e\\u80e1\\u6ca1\\u6709\\u4fee\\u51c0\\u3002\\u7709\\u9aa8\\u5f88\\u6df1\\u3002\\u53f3\\u4fa7\\u5634\\u89d2\\u538b\\u7740\\u4e00\\u9053\\u65e7\\u75a4"}, {"type": "\\u60ac\\u5ff5", "content": "\\u6697\\u5df7\\u91cc\\u6ca1\\u6709\\u4efb\\u4f55\\u65e7\\u7269\\u80fd\\u7559\\u4e0b\\u75d5\\u8ff9\\uff0c\\u8bf4\\u660e\\u8ddf\\u8e2a\\u8005\\u6709\\u6781\\u5f3a\\u7684\\u53cd\\u4fa6\\u5bdf\\u610f\\u8bc6\\u2014\\u2014\\u8fd9\\u662f\\u5426\\u610f\\u5473\\u7740\\u80cc\\u540e\\u6709\\u66f4\\u5927\\u7684\\u7ec4\\u7ec7\\uff1f", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u4ed6\\u53c8\\u78b0\\u4e86\\u95e8\\u73af\\u3001\\u6392\\u6c34\\u7ba1\\u548c\\u5899\\u89d2\\u6b8b\\u7559\\u7684\\u65e7\\u7816\\u3002\\u80fd\\u770b\\u89c1\\u7684\\u89d2\\u5ea6\\u5168\\u4e0d\\u5bf9\\u3002"}, {"type": "\\u60c5\\u611f", "content": "\\u83b1\\u5c14\\u72ec\\u81ea\\u7ad9\\u5728\\u5c94\\u8def\\u53e3\\uff0c\\u9762\\u5bf9\\u4e24\\u6761\\u65ad\\u6389\\u7684\\u7ebf\\u7d22\\uff0c\\u4ecd\\u51b3\\u5b9a\\u7ee7\\u7eed\\u8ffd\\u67e5\\uff0c\\u5c55\\u73b0\\u5b64\\u52c7\\u4e0e\\u6267\\u7740\\u3002", "strength": 7, "position": "\\u7ed3\\u5c3e", "keyword": "\\u83b1\\u5c14\\u8f6c\\u8eab\\u8d70\\u51fa\\u6697\\u5df7\\u3002\\u978b\\u5e95\\u78be\\u8fc7\\u6e7f\\u6ce5\\uff0c\\u7559\\u4e0b\\u4e24\\u884c\\u6e05\\u695a\\u7684\\u8db3\\u8ff9\\u3002"}]	4	\N	[{"title": "\\u65e0\\u8bb0\\u5fc6\\u6697\\u5df7\\u9884\\u793a\\u53cd\\u4fa6\\u5bdf\\u610f\\u8bc6", "content": "\\u6697\\u5df7\\u6ca1\\u6709\\u7164\\u6c14\\u706f\\u548c\\u76d1\\u6d4b\\u4eea\\uff0c\\u8fde\\u65e7\\u7269\\u4e5f\\u8bb0\\u5f55\\u4e0d\\u5230\\u4efb\\u4f55\\u753b\\u9762\\uff0c\\u5f3a\\u70c8\\u6697\\u793a\\u8ddf\\u8e2a\\u8005\\u6709\\u9884\\u8c0b\\u5730\\u9009\\u62e9\\u4e86\\u4e00\\u6761\\u65e0\\u6cd5\\u7559\\u4e0b\\u75d5\\u8ff9\\u7684\\u8def\\u7ebf\\uff0c\\u65e5\\u540e\\u771f\\u76f8\\u63ed\\u9732\\u65f6\\u53ef\\u80fd\\u53d1\\u73b0\\u5176\\u80cc\\u540e\\u6709\\u7ec4\\u7ec7\\u5316\\u7684\\u53cd\\u4fa6\\u5bdf\\u80fd\\u529b\\u652f\\u6301\\u3002", "type": "planted", "strength": 9, "subtlety": 8, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u90a3\\u6761\\u5df7\\u5b50\\u5939\\u5728\\u4e24\\u5ea7\\u65b0\\u4fee\\u7684\\u4ed3\\u5e93\\u4e4b\\u95f4\\uff0c\\u7a84\\u5f97\\u53ea\\u80fd\\u5bb9\\u4e24\\u4eba\\u5e76\\u80a9\\u3002", "category": "event", "is_long_term": true, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 18}, {"title": "\\u50ac\\u7720\\u8bb0\\u5fc6\\u4e2d\\u7684\\u5f71\\u5b50\\u7ec6\\u8282", "content": "\\u83b1\\u5c14\\u901a\\u8fc7\\u89e6\\u6478\\u8def\\u706f\\u7b49\\u65e7\\u7269\\uff0c\\u6210\\u529f\\u8fd8\\u539f\\u4e86\\u516d\\u6708\\u4e09\\u65e5\\u591c\\u91cc\\u8ddf\\u8e2a\\u8005\\u7684\\u8eab\\u9ad8\\u3001\\u8f6e\\u5ed3\\u548c\\u79fb\\u52a8\\u65b9\\u5f0f\\uff0c\\u8fd9\\u6b63\\u5bf9\\u5e94\\u4ed6\\u6b64\\u524d\\u8ba4\\u4e3a\\u585e\\u897f\\u8389\\u6df1\\u5c42\\u89c6\\u89c9\\u8bb0\\u5fc6\\u4e2d\\u6709\\u6b8b\\u7559\\u3001\\u53ef\\u501f\\u50ac\\u7720\\u7ed8\\u5236\\u4fa7\\u5199\\u7684\\u5224\\u65ad\\u2014\\u2014\\u867d\\u7136\\u6ca1\\u6709\\u4f7f\\u7528\\u50ac\\u7720\\uff0c\\u4f46\\u7ed3\\u679c\\u8fbe\\u5230\\u4e86\\u8ffd\\u67e5\\u5f71\\u5b50\\u7684\\u76ee\\u7684\\u3002", "type": "resolved", "strength": 8, "subtlety": 6, "reference_chapter": 7, "reference_foreshadow_id": "ca873cc1-0031-45f4-b3e7-6e021ec44b2a", "keyword": "\\u77ee\\u4e2a\\u5b50\\u3002\\u7edc\\u816e\\u80e1\\u6ca1\\u6709\\u4fee\\u51c0\\u3002\\u7709\\u9aa8\\u5f88\\u6df1\\u3002\\u53f3\\u4fa7\\u5634\\u89d2\\u538b\\u7740\\u4e00\\u9053\\u65e7\\u75a4", "category": "mystery", "is_long_term": false, "related_characters": ["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u8482\\u5c14\\u8fbe"], "estimated_resolve_chapter": 8}]	1	1	[{"content": "\\u83b1\\u5c14\\u5728\\u7a97\\u8fb9\\u76ee\\u9001\\u585e\\u897f\\u8389\\u4e0e\\u54c8\\u91cc\\u7279\\u79bb\\u53bb\\uff0c\\u786e\\u8ba4\\u5410\\u771f\\u5242\\u6ca1\\u80fd\\u6362\\u6765\\u4fe1\\u4efb\\uff0c\\u53ea\\u7559\\u4e0b\\u4e00\\u5f20\\u5730\\u5740\\u3002", "type": "transition", "importance": 0.6, "impact": "\\u4e3a\\u672c\\u7ae0\\u8c03\\u67e5\\u5212\\u5b9a\\u7a7a\\u95f4\\u4e0e\\u65f6\\u95f4\\u951a\\u70b9\\uff0c\\u5e76\\u5f3a\\u5316\\u585e\\u897f\\u8389\\u4e0e\\u83b1\\u5c14\\u4e4b\\u95f4\\u7684\\u5408\\u4f5c\\u51b7\\u611f\\u3002", "keyword": "\\u76ee\\u5149\\u5f88\\u51b7\\u3002\\u663e\\u7136\\uff0c\\u90a3\\u652f\\u88c5\\u7740\\u5410\\u771f\\u5242\\u7684\\u9488\\u7ba1\\uff0c\\u5e76\\u6ca1\\u80fd\\u66ff\\u53cc\\u65b9\\u5efa\\u7acb\\u66f4\\u591a\\u4fe1\\u4efb\\u3002"}, {"content": "\\u83b1\\u5c14\\u89e6\\u6478\\u94c1\\u6746\\u8def\\u706f\\uff0c\\u901a\\u8fc7\\u65e7\\u7269\\u7684\\u89c6\\u89c9\\u8bb0\\u5fc6\\u8fd8\\u539f\\u51fa\\u516d\\u6708\\u4e09\\u65e5\\u8ddf\\u8e2a\\u8005\\u7684\\u753b\\u9762\\uff0c\\u7b2c\\u4e00\\u6b21\\u5b8c\\u6574\\u6355\\u6349\\u5230\\u9762\\u5bb9\\u7ec6\\u8282\\u3002", "type": "revelation", "importance": 0.95, "impact": "\\u76f4\\u63a5\\u63a8\\u8fdb\\u6848\\u4ef6\\uff1a\\u77ee\\u4e2a\\u5b50\\u3001\\u7edc\\u816e\\u80e1\\u3001\\u53f3\\u5634\\u89d2\\u65e7\\u75a4\\u3001\\u624b\\u6307\\u67d3\\u6cb9\\u58a8\\u2014\\u2014\\u8fd9\\u7ec4\\u753b\\u50cf\\u6210\\u4e3a\\u540e\\u7eed\\u8ffd\\u67e5\\u7684\\u5173\\u952e\\u94a5\\u5319\\u3002", "keyword": "\\u8bb0\\u5fc6\\u50cf\\u88ab\\u626f\\u65ad\\u7684\\u80f6\\u7247\\uff0c\\u5728\\u4ed6\\u8111\\u4e2d\\u8fc5\\u901f\\u62fc\\u5408\\u3002"}, {"content": "\\u4e24\\u6761\\u7ebf\\u7d22\\u65ad\\u88c2\\uff1a\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u8db3\\u8ff9\\u6e6e\\u706d\\u5728\\u7a7a\\u5730\\u7684\\u96e8\\u6ce5\\u91cc\\uff0c\\u8ddf\\u8e2a\\u8005\\u5219\\u6d88\\u5931\\u5728\\u6ca1\\u6709\\u65e7\\u7269\\u770b\\u89c1\\u7684\\u6697\\u5df7\\u4e2d\\u3002", "type": "conflict", "importance": 0.9, "impact": "\\u5c06\\u60ac\\u7591\\u63a8\\u5411\\u66f4\\u9ad8\\u5c42\\uff1a\\u8ddf\\u8e2a\\u8005\\u663e\\u7136\\u5177\\u5907\\u53cd\\u4fa6\\u5bdf\\u610f\\u8bc6\\uff0c\\u6848\\u4ef6\\u96be\\u5ea6\\u6025\\u5267\\u5347\\u7ea7\\uff0c\\u8feb\\u4f7f\\u83b1\\u5c14\\u8f6c\\u6362\\u8ffd\\u67e5\\u65b9\\u5411\\u3002", "keyword": "\\u739b\\u8482\\u5c14\\u8fbe\\u53ef\\u80fd\\u56de\\u4e86\\u5bb6\\u3002\\u4e5f\\u53ef\\u80fd\\uff0c\\u5979\\u4ece\\u6765\\u6ca1\\u6709\\u8d70\\u51fa\\u90a3\\u7247\\u7a7a\\u5730\\u3002"}, {"content": "\\u83b1\\u5c14\\u7ad9\\u5728\\u5c94\\u8def\\u53e3\\uff0c\\u51b3\\u5b9a\\u5148\\u67e5\\u8138\\u3001\\u518d\\u67e5\\u6cb9\\u58a8\\uff0c\\u5e76\\u8f6c\\u5411\\u6cbb\\u5b89\\u6240\\u4f53\\u7cfb\\u4e4b\\u5916\\u7684\\u7070\\u8272\\u5730\\u5e26\\u5bfb\\u627e\\u7b54\\u6848\\u3002", "type": "resolution", "importance": 0.8, "impact": "\\u4e3b\\u89d2\\u4ece\\u5236\\u5ea6\\u5316\\u5408\\u4f5c\\u8f6c\\u5411\\u4e2a\\u4eba\\u5b64\\u519b\\u6df1\\u5165\\uff0c\\u4e3a\\u540e\\u7eed\\u5f15\\u5165\\u5730\\u4e0b\\u4fe1\\u606f\\u7f51\\u505a\\u94fa\\u57ab\\u3002", "keyword": "\\u6cbb\\u5b89\\u6240\\u82e5\\u6ca1\\u6709\\u7b54\\u6848\\uff0c\\u57ce\\u91cc\\u603b\\u6709\\u4e9b\\u4e0d\\u5199\\u8fdb\\u6863\\u6848\\u7684\\u4eba\\u8ba4\\u5f97\\u8fd9\\u5f20\\u8138\\u3002"}]	4	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u4fdd\\u6301\\u51b7\\u9759\\u3001\\u8bd5\\u56fe\\u5728\\u5236\\u5ea6\\u5316\\u6846\\u67b6\\u5185\\u5408\\u4f5c", "state_after": "\\u76ee\\u6807\\u660e\\u786e\\uff0c\\u51b3\\u5b9a\\u8131\\u79bb\\u6846\\u67b6\\u81ea\\u884c\\u8ffd\\u67e5", "psychological_change": "\\u4ece\\u4f9d\\u9760\\u6d41\\u7a0b\\u4e0e\\u5408\\u4f5c\\u7684\\u514b\\u5236\\uff0c\\u8f6c\\u5411\\u88ab\\u65ad\\u7ebf\\u903c\\u8feb\\u7684\\u5b64\\u52c7\\u2014\\u2014\\u4ed6\\u8ba4\\u8bc6\\u5230\\u7cfb\\u7edf\\u65e0\\u6cd5\\u89e3\\u51b3\\uff0c\\u53ea\\u80fd\\u4f9d\\u9760\\u81ea\\u5df1\\u7684\\u80fd\\u529b\\u4e0e\\u79c1\\u7f51\\u3002\\u638c\\u5fc3\\u7684\\u7126\\u9ed1\\u548c'\\u6ca1\\u6709\\u8bb0\\u5fc6\\u7684\\u6697\\u5df7'\\u5f3a\\u5316\\u4e86\\u4ed6\\u7684\\u8b66\\u89c9\\uff0c\\u4f46\\u6ca1\\u6709\\u4f7f\\u4ed6\\u6709\\u4e1d\\u6beb\\u9000\\u7f29\\u3002", "key_event": "\\u4e24\\u6761\\u7ebf\\u7d22\\u5206\\u522b\\u65ad\\u5728\\u7a7a\\u5730\\u548c\\u6697\\u5df7\\uff0c\\u83b1\\u5c14\\u51b3\\u5b9a\\u5148\\u67e5\\u8138\\u518d\\u67e5\\u6cb9\\u58a8\\uff0c\\u8131\\u79bb\\u6cbb\\u5b89\\u6240\\u6846\\u67b6\\u7ee7\\u7eed\\u6df1\\u5165\\u3002", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u5408\\u4f5c\\u4ecd\\u65e7\\u4f46\\u4fe1\\u4efb\\u5df2\\u51fa\\u73b0\\u8fb9\\u754c", "\\u683c\\u857e\\u4e1d": "\\u751f\\u6d3b\\u5316\\u9ed8\\u5951\\u5f97\\u5230\\u786e\\u8ba4\\uff08\\u5979\\u77e5\\u6653\\u83b1\\u5c14\\u665a\\u5f52\\u3001\\u4ed8\\u8d26\\u4e60\\u60ef\\u7b49\\uff09"}}]	[{"location": "\\u6708\\u5b63\\u5496\\u5561\\u5385\\u4e8c\\u697c/\\u4e00\\u697c", "atmosphere": "\\u51b7\\u6e05\\u3001\\u538b\\u6291\\uff0c\\u6709\\u5496\\u5561\\u4e0e\\u6d88\\u6bd2\\u9152\\u7cbe\\u6df7\\u5408\\u7684\\u82e6\\u6da9\\u5473", "duration": "\\u7ea65\\u5206\\u949f"}, {"location": "\\u897f\\u533a\\u94dc\\u9523\\u5df7\\u53e3\\u8857\\u5934", "atmosphere": "\\u55a7\\u95f9\\u6df7\\u4e71\\u3001\\u9c7c\\u8165\\u4e0e\\u7164\\u7070\\u6c14\\u606f\\u7f20\\u7ed5\\uff0c\\u5e95\\u5c42\\u5e02\\u4e95\\u6c14\\u606f\\u6d53\\u91cd", "duration": "\\u7ea610\\u5206\\u949f"}, {"location": "\\u94dc\\u9523\\u5df7\\u4e2d\\u6bb5\\u94c1\\u680f\\u6746\\u9644\\u8fd1", "atmosphere": "\\u5149\\u5f71\\u6591\\u9a73\\u3001\\u6f6e\\u6e7f\\u68ee\\u7136\\uff0c\\u83b1\\u5c14\\u7528\\u65e7\\u7269\\u62fc\\u51fa\\u8ddf\\u8e2a\\u8005\\u9762\\u8c8c", "duration": "\\u7ea610\\u5206\\u949f"}, {"location": "\\u7a7a\\u5730\\u6ce5\\u573a\\u4e0e\\u6697\\u5df7\\u5c94\\u53e3", "atmosphere": "\\u9634\\u4e91\\u538b\\u9876\\u3001\\u98ce\\u4ece\\u897f\\u8fb9\\u704c\\u6765\\uff0c\\u7a7a\\u65f7\\u5bc2\\u51b7\\u4e2d\\u5145\\u6ee1\\u5931\\u8e2a\\u611f", "duration": "\\u7ea615\\u5206\\u949f"}]	slow-burn	8.2	8.2	8.5	8	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.2/10\n  节奏把控: 8.2/10\n  吸引力: 8.5/10\n  连贯性: 8.0/10\n\n【剧情阶段】发展\n\n【钩子分析】共4个\n  • [悬念] 跟踪者面容被锁定，但玛蒂尔达的行踪在空地彻底消失，她到底去了哪里？是否已经遭遇不测？... (强度:9)\n  • [悬念] 跟踪者的身份：矮个子、络腮胡、右嘴角旧疤、手染油墨，他究竟是什么人？... (强度:8)\n  • [悬念] 暗巷里没有任何旧物能留下痕迹，说明跟踪者有极强的反侦察意识——这是否意味着背后有更大的组织？... (强度:8)\n\n【伏笔分析】埋下2个, 回收1个\n\n【冲突分析】\n  类型: 人与人, 人与己, 人与社会\n  强度: 7/10\n  进度: 35%\n\n【改进建议】\n  1. 【节奏优化】开篇月季咖啡厅的段落约300字略显拖慢节奏，可将塞西莉回望与吐真剂总结压缩到200字以内，更快切入铜锣巷调查主线。	["\\u3010\\u8282\\u594f\\u4f18\\u5316\\u3011\\u5f00\\u7bc7\\u6708\\u5b63\\u5496\\u5561\\u5385\\u7684\\u6bb5\\u843d\\u7ea6300\\u5b57\\u7565\\u663e\\u62d6\\u6162\\u8282\\u594f\\uff0c\\u53ef\\u5c06\\u585e\\u897f\\u8389\\u56de\\u671b\\u4e0e\\u5410\\u771f\\u5242\\u603b\\u7ed3\\u538b\\u7f29\\u5230200\\u5b57\\u4ee5\\u5185\\uff0c\\u66f4\\u5feb\\u5207\\u5165\\u94dc\\u9523\\u5df7\\u8c03\\u67e5\\u4e3b\\u7ebf\\u3002"]	\N	0.2	0.5	2026-08-07 00:45:59.723506
883fe075-07b9-429e-94b6-c45c381fe522	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	重大转折	10	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	悲恸与压抑	1	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u5f00\\u7bc7\\u76f4\\u63a5\\u4ee5\\u65e0\\u4eba\\u56de\\u5e94\\u3001\\u65ad\\u88c2\\u95e8\\u95e9\\u548c\\u6251\\u9762\\u800c\\u6765\\u7684\\u8840\\u8165\\u5473\\u786e\\u8ba4\\u5b64\\u513f\\u9662\\u906d\\u9047\\u91cd\\u5927\\u53d8\\u6545\\uff0c\\u8fc5\\u901f\\u628a\\u4e0a\\u4e00\\u7ae0\\u7684\\u5371\\u673a\\u9884\\u5146\\u8f6c\\u5316\\u4e3a\\u51f6\\u6848\\u73b0\\u573a\\u3002", "strength": 10, "position": "\\u5f00\\u5934", "keyword": "\\u95e8\\u540e\\u7684\\u8840\\u8165\\u5473\\u6251\\u51fa\\u6765"}, {"type": "\\u60c5\\u611f", "content": "\\u6258\\u6bd4\\u3001\\u8bfa\\u4e9a\\u4e0e\\u5b64\\u513f\\u9662\\u5b69\\u5b50\\u76f8\\u7ee7\\u88ab\\u53d1\\u73b0\\u9047\\u5bb3\\uff0c\\u6728\\u9a6c\\u65ad\\u88c2\\u3001\\u4f38\\u5411\\u65a7\\u5934\\u7684\\u624b\\u7b49\\u7ec6\\u8282\\u5c06\\u96c6\\u4f53\\u6b7b\\u4ea1\\u843d\\u5230\\u5177\\u4f53\\u4e2a\\u4f53\\u8eab\\u4e0a\\uff0c\\u5236\\u9020\\u5f3a\\u70c8\\u60b2\\u6078\\u3002", "strength": 10, "position": "\\u5f00\\u5934", "keyword": "\\u8bfa\\u4e9a\\u7f29\\u5728\\u684c\\u4e0b"}, {"type": "\\u60ac\\u5ff5", "content": "\\u5bbf\\u820d\\u5e8a\\u4f4d\\u4e0e\\u5c38\\u4f53\\u6570\\u91cf\\u4e0d\\u7b26\\uff0c\\u8428\\u59c6\\u6210\\u4e3a\\u552f\\u4e00\\u786e\\u8ba4\\u5931\\u8e2a\\u8005\\uff0c\\u5176\\u7a76\\u7adf\\u9003\\u751f\\u3001\\u88ab\\u7ed1\\u67b6\\u8fd8\\u662f\\u4e0e\\u88ad\\u51fb\\u76ee\\u6807\\u6709\\u5173\\uff0c\\u6784\\u6210\\u5168\\u7ae0\\u6700\\u6838\\u5fc3\\u7684\\u540e\\u7eed\\u60ac\\u5ff5\\u3002", "strength": 10, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5341\\u4e8c\\u5f20\\u5e8a\\uff0c\\u5341\\u4e00\\u5177\\u5c38\\u4f53"}, {"type": "\\u8ba4\\u77e5", "content": "\\u88ad\\u51fb\\u8005\\u6ca1\\u6709\\u641c\\u522e\\u98df\\u7269\\u548c\\u666e\\u901a\\u8d22\\u7269\\uff0c\\u5374\\u7ffb\\u904d\\u623f\\u95f4\\u5e76\\u6252\\u5f00\\u58c1\\u7089\\u7070\\u70ec\\uff0c\\u8868\\u660e\\u8fd9\\u4e0d\\u662f\\u968f\\u673a\\u52ab\\u6740\\uff0c\\u800c\\u662f\\u9488\\u5bf9\\u7279\\u5b9a\\u4eba\\u7269\\u6216\\u79d8\\u5bc6\\u7684\\u6709\\u8ba1\\u5212\\u884c\\u52a8\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u6765\\u4eba\\u4e0d\\u662f\\u4e3a\\u4e86\\u94b1\\uff0c\\u4e5f\\u4e0d\\u662f\\u4e3a\\u4e86\\u98df\\u7269"}, {"type": "\\u51b2\\u7a81", "content": "\\u514b\\u52b3\\u56e0\\u8428\\u59c6\\u53ef\\u80fd\\u88ab\\u5e26\\u8d70\\u800c\\u575a\\u6301\\u72ec\\u81ea\\u8ffd\\u8f66\\uff0c\\u83b1\\u5c14\\u5219\\u5f3a\\u884c\\u963b\\u6b62\\uff0c\\u590d\\u4ec7\\u51b2\\u52a8\\u4e0e\\u7406\\u6027\\u6551\\u63f4\\u65b9\\u6848\\u6b63\\u9762\\u78b0\\u649e\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8428\\u59c6\\u53ef\\u80fd\\u5728\\u8f66\\u4e0a\\u3002\\u6240\\u4ee5\\u66f4\\u4e0d\\u80fd\\u4e71\\u8ffd"}, {"type": "\\u60ac\\u5ff5", "content": "\\u62a5\\u6848\\u540e\\u4e24\\u4eba\\u6ca1\\u6709\\u83b7\\u5f97\\u81ea\\u7531\\u884c\\u52a8\\u6743\\uff0c\\u53cd\\u800c\\u540c\\u65f6\\u88ab\\u4fdd\\u62a4\\u548c\\u62d8\\u7559\\uff0c\\u9884\\u793a\\u5b98\\u65b9\\u8c03\\u67e5\\u53ef\\u80fd\\u628a\\u5e78\\u5b58\\u8005\\u4e5f\\u5217\\u4e3a\\u5acc\\u7591\\u5bf9\\u8c61\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u8fd9\\u662f\\u4fdd\\u62a4\\uff0c\\u8fd8\\u662f\\u62d8\\u7559"}, {"type": "\\u60c5\\u611f", "content": "\\u7ed3\\u5c3e\\u4ee5\\u5b8c\\u6574\\u65e0\\u7f3a\\u7684\\u91c7\\u8d2d\\u6e05\\u5355\\u5bf9\\u7167\\u5df2\\u88ab\\u6bc1\\u706d\\u7684\\u65e5\\u5e38\\u751f\\u6d3b\\uff0c\\u5f3a\\u8c03\\u4e24\\u4eba\\u53ea\\u662f\\u77ed\\u6682\\u79bb\\u5f00\\uff0c\\u5374\\u518d\\u4e5f\\u65e0\\u6cd5\\u628a\\u836f\\u54c1\\u548c\\u98df\\u7269\\u5e26\\u7ed9\\u7b49\\u5f85\\u4ed6\\u4eec\\u7684\\u4eba\\u3002", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u9762\\u7c89\\u3001\\u9000\\u70e7\\u836f\\u3001\\u7164\\u6cb9\\u3001\\u76d0\\uff0c\\u4e00\\u4e2a\\u5b57\\u90fd\\u6ca1\\u5c11"}]	7	\N	[{"title": "\\u5b64\\u513f\\u9662\\u906d\\u88ad\\u4e0e\\u4f17\\u4eba\\u5b89\\u5371", "content": "\\u4e0a\\u4e00\\u7ae0\\u4e2d\\u70df\\u56f1\\u505c\\u706b\\u3001\\u9662\\u5185\\u65e0\\u58f0\\u3001\\u5927\\u95e8\\u865a\\u63a9\\u53ca\\u95e8\\u95e9\\u65ad\\u88c2\\u6240\\u9884\\u793a\\u7684\\u66b4\\u529b\\u5165\\u4fb5\\u5f97\\u5230\\u5b8c\\u6574\\u56de\\u6536\\u3002\\u672c\\u7ae0\\u786e\\u8ba4\\u5b64\\u513f\\u9662\\u906d\\u4e09\\u4eba\\u4ee5\\u4e0a\\u88ad\\u51fb\\uff0c\\u739b\\u4e3d\\u4fee\\u5973\\u3001\\u6258\\u6bd4\\u53ca\\u591a\\u540d\\u5b69\\u5b50\\u9047\\u5bb3\\uff0c\\u8428\\u59c6\\u5931\\u8e2a\\uff0c\\u5371\\u673a\\u7531\\u9884\\u5146\\u6b63\\u5f0f\\u8f6c\\u5316\\u4e3a\\u4e3b\\u7ebf\\u60e8\\u6848\\u3002", "type": "resolved", "strength": 10, "subtlety": 2, "reference_chapter": 2, "reference_foreshadow_id": "7ade4e28-cd34-41fc-881d-399f9aead5dd", "keyword": "\\u65ad\\u6389\\u7684\\u95e8\\u95e9\\u64e6\\u8fc7\\u5730\\u9762", "category": "event", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u8428\\u59c6"], "estimated_resolve_chapter": 3}, {"title": "\\u7f1d\\u8863\\u9488\\u6210\\u4e3a\\u590d\\u4ec7\\u9057\\u7269", "content": "\\u514b\\u52b3\\u53ea\\u4ece\\u739b\\u4e3d\\u6563\\u843d\\u7684\\u7f1d\\u8863\\u9488\\u4e2d\\u6361\\u8d77\\u4e00\\u679a\\uff0c\\u5e76\\u5728\\u7ed3\\u5c3e\\u8d34\\u8eab\\u6536\\u85cf\\u3002\\u8fd9\\u4e00\\u52a8\\u4f5c\\u5c06\\u666e\\u901a\\u751f\\u6d3b\\u7269\\u4ef6\\u8f6c\\u5316\\u4e3a\\u54c0\\u60bc\\u3001\\u8a93\\u8a00\\u548c\\u590d\\u4ec7\\u52a8\\u673a\\u7684\\u8f7d\\u4f53\\uff0c\\u540e\\u7eed\\u53ef\\u80fd\\u4f5c\\u4e3a\\u514b\\u52b3\\u4fdd\\u6301\\u7406\\u667a\\u6216\\u786e\\u8ba4\\u76ee\\u6807\\u7684\\u60c5\\u611f\\u951a\\u70b9\\u3002", "type": "planted", "strength": 7, "subtlety": 6, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u628a\\u90a3\\u679a\\u7f1d\\u8863\\u9488\\u6536\\u8fdb\\u8d34\\u8eab\\u53e3\\u888b", "category": "item", "is_long_term": true, "related_characters": ["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u739b\\u4e3d\\u4fee\\u5973"], "estimated_resolve_chapter": 14}, {"title": "\\u5b98\\u65b9\\u4fdd\\u62a4\\u4e0b\\u7684\\u5acc\\u7591\\u8eab\\u4efd", "content": "\\u6cbb\\u5b89\\u5b98\\u540c\\u65f6\\u4ee5\\u4fdd\\u62a4\\u548c\\u62d8\\u7559\\u7684\\u540d\\u4e49\\u9650\\u5236\\u4e24\\u540d\\u5e78\\u5b58\\u8005\\u884c\\u52a8\\uff0c\\u610f\\u5473\\u7740\\u83b1\\u5c14\\u4e0e\\u514b\\u52b3\\u5c06\\u63a5\\u53d7\\u5ba1\\u67e5\\u3002\\u4e24\\u4eba\\u7684\\u5f02\\u5e38\\u80fd\\u529b\\u3001\\u6848\\u53d1\\u524d\\u79bb\\u9662\\u7ecf\\u5386\\u53ca\\u5bf9\\u73b0\\u573a\\u8fc7\\u4e8e\\u7cbe\\u51c6\\u7684\\u5224\\u65ad\\uff0c\\u90fd\\u53ef\\u80fd\\u5728\\u8c03\\u67e5\\u4e2d\\u5f62\\u6210\\u98ce\\u9669\\u3002", "type": "planted", "strength": 8, "subtlety": 5, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u6ca1\\u6709\\u6211\\u7684\\u5141\\u8bb8\\uff0c\\u8c01\\u4e5f\\u4e0d\\u80fd\\u79bb\\u5f00", "category": "event", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"], "estimated_resolve_chapter": 4}]	2	1	[{"content": "\\u83b1\\u5c14\\u4e0e\\u514b\\u52b3\\u8fdb\\u5165\\u5b64\\u513f\\u9662\\uff0c\\u786e\\u8ba4\\u6b64\\u524d\\u7684\\u5f02\\u5e38\\u6765\\u81ea\\u4e00\\u573a\\u5df2\\u7ecf\\u7ed3\\u675f\\u7684\\u96c6\\u4f53\\u5c60\\u6740\\u3002", "type": "revelation", "importance": 1.0, "impact": "\\u5f7b\\u5e95\\u6467\\u6bc1\\u4e3b\\u89d2\\u539f\\u6709\\u751f\\u6d3b\\u652f\\u70b9\\uff0c\\u5c06\\u6545\\u4e8b\\u4ece\\u65e5\\u5e38\\u5f02\\u5e38\\u8c03\\u67e5\\u63a8\\u5165\\u8c0b\\u6740\\u6848\\u4e0e\\u590d\\u4ec7\\u8ffd\\u67e5\\u4e3b\\u7ebf\\u3002", "keyword": "\\u6258\\u6bd4\\u5012\\u5728\\u957f\\u684c\\u65c1"}, {"content": "\\u83b1\\u5c14\\u901a\\u8fc7\\u978b\\u5370\\u3001\\u8840\\u8ff9\\u548c\\u7ffb\\u52a8\\u7269\\u54c1\\u5224\\u65ad\\u51f6\\u624b\\u81f3\\u5c11\\u4e09\\u4eba\\uff0c\\u4e14\\u88ad\\u51fb\\u76ee\\u7684\\u4e0d\\u662f\\u666e\\u901a\\u52ab\\u63a0\\u3002", "type": "revelation", "importance": 0.9, "impact": "\\u5efa\\u7acb\\u6848\\u4ef6\\u7684\\u57fa\\u7840\\u63a8\\u7406\\u6846\\u67b6\\uff0c\\u8bf4\\u660e\\u5c60\\u6740\\u5177\\u6709\\u7ec4\\u7ec7\\u6027\\u548c\\u660e\\u786e\\u76ee\\u6807\\uff0c\\u5e76\\u4e3a\\u540e\\u7eed\\u8ffd\\u8e2a\\u7559\\u4e0b\\u7269\\u8bc1\\u3002", "keyword": "\\u811a\\u5370\\u4ece\\u6b63\\u95e8\\u8fdb\\u6765\\uff0c\\u5728\\u53a8\\u623f\\u6563\\u5f00"}, {"content": "\\u5bbf\\u820d\\u4e2d\\u5c11\\u4e86\\u4e00\\u540d\\u5b69\\u5b50\\uff0c\\u83b1\\u5c14\\u786e\\u8ba4\\u5931\\u8e2a\\u8005\\u662f\\u8428\\u59c6\\u3002", "type": "revelation", "importance": 1.0, "impact": "\\u5728\\u5168\\u706d\\u5f0f\\u60e8\\u6848\\u4e2d\\u4fdd\\u7559\\u8425\\u6551\\u76ee\\u6807\\u4e0e\\u751f\\u5b58\\u5e0c\\u671b\\uff0c\\u540c\\u65f6\\u8ba9\\u51f6\\u624b\\u7684\\u64a4\\u79bb\\u8def\\u7ebf\\u548c\\u771f\\u5b9e\\u76ee\\u7684\\u66f4\\u5177\\u7d27\\u8feb\\u6027\\u3002", "keyword": "\\u6700\\u91cc\\u4fa7\\u7684\\u5e8a\\u5355\\u5782\\u5230\\u5730\\u9762"}, {"content": "\\u739b\\u4e3d\\u4fee\\u5973\\u88ab\\u53d1\\u73b0\\u6b7b\\u4e8e\\u793c\\u62dc\\u5ba4\\uff0c\\u70e7\\u6bc1\\u5730\\u5740\\u7684\\u58c1\\u7089\\u4e5f\\u88ab\\u4eba\\u7ffb\\u67e5\\uff0c\\u8fdb\\u4e00\\u6b65\\u6307\\u5411\\u79d8\\u5bc6\\u6cc4\\u9732\\u548c\\u5b9a\\u5411\\u88ad\\u51fb\\u3002", "type": "revelation", "importance": 1.0, "impact": "\\u5b8c\\u6210\\u60c5\\u611f\\u9ad8\\u6f6e\\u5e76\\u628a\\u739b\\u4e3d\\u6b64\\u524d\\u9690\\u85cf\\u7684\\u4fe1\\u606f\\u4e0e\\u672c\\u6b21\\u60e8\\u6848\\u76f4\\u63a5\\u8fde\\u63a5\\uff0c\\u4f7f\\u6848\\u4ef6\\u4e0a\\u5347\\u4e3a\\u9488\\u5bf9\\u5b64\\u513f\\u9662\\u79d8\\u5bc6\\u7684\\u6e05\\u6d17\\u884c\\u52a8\\u3002", "keyword": "\\u739b\\u4e3d\\u4fee\\u5973\\u9760\\u5750\\u5728\\u6668\\u661f\\u5723\\u50cf\\u4e0b"}, {"content": "\\u83b1\\u5c14\\u963b\\u6b62\\u514b\\u52b3\\u72ec\\u81ea\\u8ffd\\u51fb\\uff0c\\u4e8c\\u4eba\\u62a5\\u6848\\u540e\\u88ab\\u6cbb\\u5b89\\u5b98\\u540c\\u65f6\\u4fdd\\u62a4\\u548c\\u62d8\\u7559\\u3002", "type": "transition", "importance": 0.9, "impact": "\\u907f\\u514d\\u89d2\\u8272\\u56e0\\u51b2\\u52a8\\u7acb\\u5373\\u8fdb\\u5165\\u4e0d\\u5408\\u7406\\u8ffd\\u9010\\uff0c\\u5c06\\u53d9\\u4e8b\\u81ea\\u7136\\u8f6c\\u5411\\u5b98\\u65b9\\u8c03\\u67e5\\u3001\\u5acc\\u7591\\u5ba1\\u67e5\\u548c\\u5c01\\u57ce\\u8ffd\\u8e2a\\u9636\\u6bb5\\u3002", "keyword": "\\u4ece\\u73b0\\u5728\\u8d77\\uff0c\\u4f60\\u4eec\\u7559\\u5728\\u8fd9\\u91cc"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u5e26\\u7740\\u4e0d\\u7965\\u9884\\u611f\\u8fd4\\u56de\\u5b64\\u513f\\u9662\\uff0c\\u4ecd\\u8bd5\\u56fe\\u786e\\u8ba4\\u9662\\u5185\\u60c5\\u51b5", "state_after": "\\u538b\\u4e0b\\u60b2\\u75db\\u8fdb\\u5165\\u6848\\u4ef6\\u5206\\u6790\\u72b6\\u6001\\uff0c\\u5e76\\u5728\\u5b98\\u65b9\\u62d8\\u7559\\u4e0b\\u5f00\\u59cb\\u9762\\u5bf9\\u8ffd\\u51f6\\u4e0e\\u81ea\\u4fdd\\u53cc\\u91cd\\u538b\\u529b", "psychological_change": "\\u83b1\\u5c14\\u4ee5\\u89c2\\u5bdf\\u978b\\u5370\\u3001\\u8840\\u8ff9\\u3001\\u95e8\\u9501\\u548c\\u623f\\u95f4\\u7ffb\\u52a8\\u60c5\\u51b5\\u6765\\u62b5\\u5fa1\\u60c5\\u7eea\\u5d29\\u6e83\\u3002\\u4ed6\\u53d1\\u73b0\\u5c38\\u4f53\\u65f6\\u660e\\u663e\\u50f5\\u786c\\uff0c\\u5374\\u59cb\\u7ec8\\u8981\\u6c42\\u81ea\\u5df1\\u4e0d\\u80fd\\u4e71\\uff0c\\u5e76\\u5728\\u514b\\u52b3\\u51c6\\u5907\\u72ec\\u81ea\\u8ffd\\u51fb\\u65f6\\u627f\\u62c5\\u4e86\\u5236\\u6b62\\u8005\\u89d2\\u8272\\u3002\\u62a5\\u6848\\u65f6\\uff0c\\u4ed6\\u4e3b\\u52a8\\u653e\\u5f03\\u4f7f\\u7528\\u6b3a\\u9a97\\u529b\\u91cf\\uff0c\\u8bf4\\u660e\\u5176\\u51b7\\u9759\\u4e0d\\u4ec5\\u662f\\u80fd\\u529b\\u4f9d\\u8d56\\uff0c\\u66f4\\u5305\\u542b\\u5bf9\\u98ce\\u9669\\u548c\\u5fc5\\u8981\\u6027\\u7684\\u5224\\u65ad\\u3002", "key_event": "\\u53d1\\u73b0\\u5b64\\u513f\\u9662\\u96c6\\u4f53\\u9047\\u5bb3\\u3001\\u8428\\u59c6\\u5931\\u8e2a\\uff0c\\u5e76\\u6210\\u529f\\u963b\\u6b62\\u514b\\u52b3\\u72ec\\u81ea\\u8ffd\\u8f66", "relationship_changes": {"\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u4e24\\u4eba\\u7684\\u5206\\u6b67\\u516c\\u5f00\\u7206\\u53d1\\uff0c\\u4f46\\u83b1\\u5c14\\u6562\\u4e8e\\u6309\\u4f4f\\u514b\\u52b3\\u6301\\u5200\\u7684\\u624b\\u8155\\uff0c\\u514b\\u52b3\\u6700\\u7ec8\\u63a5\\u53d7\\u5176\\u65b9\\u6848\\uff0c\\u663e\\u793a\\u53cc\\u65b9\\u5df2\\u5f62\\u6210\\u5371\\u673a\\u4e2d\\u7684\\u5236\\u8861\\u4e0e\\u4fe1\\u4efb\\u3002", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u4ece\\u4f9d\\u8d56\\u65e5\\u5e38\\u7167\\u6599\\u7684\\u5bb6\\u4eba\\u5173\\u7cfb\\u8f6c\\u5316\\u4e3a\\u5931\\u53bb\\u4fdd\\u62a4\\u8005\\u540e\\u7684\\u54c0\\u6078\\u4e0e\\u8ffd\\u67e5\\u8d23\\u4efb\\u3002", "\\u8428\\u59c6": "\\u7531\\u5171\\u540c\\u751f\\u6d3b\\u7684\\u5b64\\u513f\\u9662\\u6210\\u5458\\u8f6c\\u5316\\u4e3a\\u83b1\\u5c14\\u5fc5\\u987b\\u4f18\\u5148\\u5bfb\\u627e\\u548c\\u8425\\u6551\\u7684\\u5931\\u8e2a\\u8005\\u3002"}}, {"character_name": "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "survival_status": null, "state_before": "\\u5bdf\\u89c9\\u5b64\\u513f\\u9662\\u5f02\\u5e38\\u540e\\u6025\\u4e8e\\u51b2\\u5165\\u9662\\u5185\\u786e\\u8ba4\\u4f17\\u4eba\\u5b89\\u5371", "state_after": "\\u7531\\u5373\\u65f6\\u590d\\u4ec7\\u51b2\\u52a8\\u8f6c\\u4e3a\\u88ab\\u8feb\\u514b\\u5236\\uff0c\\u5c06\\u60b2\\u75db\\u51dd\\u7ed3\\u4e3a\\u8ffd\\u67e5\\u51f6\\u624b\\u548c\\u8425\\u6551\\u8428\\u59c6\\u7684\\u957f\\u671f\\u52a8\\u673a", "psychological_change": "\\u514b\\u52b3\\u9762\\u5bf9\\u6258\\u6bd4\\u3001\\u8bfa\\u4e9a\\u548c\\u739b\\u4e3d\\u7684\\u6b7b\\u4ea1\\u51e0\\u4e4e\\u65e0\\u6cd5\\u7528\\u8bed\\u8a00\\u8868\\u8fbe\\uff0c\\u53ea\\u80fd\\u901a\\u8fc7\\u6380\\u684c\\u5e03\\u3001\\u63e1\\u5200\\u3001\\u6536\\u8d77\\u56f4\\u88d9\\u53e3\\u888b\\u548c\\u6361\\u8d70\\u7f1d\\u8863\\u9488\\u7b49\\u52a8\\u4f5c\\u5916\\u5316\\u60c5\\u7eea\\u3002\\u4ed6\\u6700\\u521d\\u575a\\u6301\\u6cbf\\u8f66\\u8f99\\u8ffd\\u51fb\\uff0c\\u5728\\u83b1\\u5c14\\u6307\\u51fa\\u654c\\u6211\\u5dee\\u8ddd\\u4e0e\\u641c\\u67e5\\u6548\\u7387\\u540e\\u6700\\u7ec8\\u5408\\u5200\\uff0c\\u8868\\u73b0\\u51fa\\u9996\\u6b21\\u5728\\u6781\\u7aef\\u6124\\u6012\\u4e2d\\u63a5\\u53d7\\u7406\\u6027\\u7ea6\\u675f\\u3002", "key_event": "\\u5728\\u739b\\u4e3d\\u9057\\u4f53\\u524d\\u51c6\\u5907\\u72ec\\u81ea\\u8ffd\\u51f6\\uff0c\\u968f\\u540e\\u88ab\\u83b1\\u5c14\\u8bf4\\u670d\\u6539\\u4e3a\\u62a5\\u6848\\u5c01\\u57ce", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u83b1\\u5c14\\u4ece\\u540c\\u884c\\u8005\\u8fdb\\u4e00\\u6b65\\u6210\\u4e3a\\u80fd\\u5728\\u514b\\u52b3\\u5931\\u63a7\\u65f6\\u5236\\u6b62\\u5e76\\u8bf4\\u670d\\u4ed6\\u7684\\u552f\\u4e00\\u5236\\u8861\\u8005\\uff0c\\u5371\\u673a\\u4fe1\\u4efb\\u663e\\u8457\\u52a0\\u6df1\\u3002", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u739b\\u4e3d\\u4e4b\\u6b7b\\u8ba9\\u7167\\u6599\\u8005\\u5173\\u7cfb\\u6c38\\u4e45\\u4e2d\\u65ad\\uff0c\\u514b\\u52b3\\u6536\\u85cf\\u7f1d\\u8863\\u9488\\uff0c\\u663e\\u793a\\u5176\\u5c06\\u5979\\u7684\\u6b7b\\u4ea1\\u5185\\u5316\\u4e3a\\u54c0\\u60bc\\u548c\\u590d\\u4ec7\\u8a93\\u8a00\\u3002", "\\u8428\\u59c6": "\\u8428\\u59c6\\u5931\\u8e2a\\u6210\\u4e3a\\u514b\\u52b3\\u538b\\u5012\\u6027\\u7684\\u6551\\u63f4\\u76ee\\u6807\\uff0c\\u4e5f\\u662f\\u4ed6\\u613f\\u610f\\u6682\\u65f6\\u653e\\u5f03\\u76f4\\u63a5\\u590d\\u4ec7\\u7684\\u4e3b\\u8981\\u539f\\u56e0\\u3002"}}, {"character_name": "\\u739b\\u4e3d\\u4fee\\u5973", "survival_status": "deceased", "state_before": "\\u5b64\\u513f\\u9662\\u7684\\u7167\\u6599\\u8005\\u4e0e\\u4fdd\\u62a4\\u8005", "state_after": "\\u5728\\u793c\\u62dc\\u5ba4\\u6668\\u661f\\u5723\\u50cf\\u4e0b\\u9047\\u5bb3", "psychological_change": "\\u7ae0\\u8282\\u672a\\u5c55\\u793a\\u5176\\u4e34\\u6b7b\\u524d\\u5b8c\\u6574\\u5fc3\\u7406\\u8fc7\\u7a0b\\uff0c\\u4f46\\u88ab\\u7ffb\\u51fa\\u7684\\u53e3\\u888b\\u3001\\u6563\\u843d\\u7684\\u7f1d\\u8863\\u9488\\u4e0e\\u624b\\u4e2d\\u65ad\\u88c2\\u7684\\u6668\\u661f\\u8bf4\\u660e\\u5979\\u7ecf\\u5386\\u8fc7\\u641c\\u8eab\\u6216\\u640f\\u6597\\uff0c\\u5e76\\u53ef\\u80fd\\u5728\\u6700\\u540e\\u65f6\\u523b\\u8bd5\\u56fe\\u7559\\u4e0b\\u7ebf\\u7d22\\u3002", "key_event": "\\u83b1\\u5c14\\u4e0e\\u514b\\u52b3\\u5728\\u793c\\u62dc\\u5ba4\\u53d1\\u73b0\\u5176\\u9057\\u4f53", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4fdd\\u62a4\\u4e0e\\u88ab\\u4fdd\\u62a4\\u7684\\u73b0\\u5b9e\\u5173\\u7cfb\\u7ec8\\u6b62\\uff0c\\u8f6c\\u5316\\u4e3a\\u83b1\\u5c14\\u8ffd\\u67e5\\u771f\\u76f8\\u7684\\u60c5\\u611f\\u8d23\\u4efb\\u3002", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u7167\\u6599\\u5173\\u7cfb\\u56e0\\u6b7b\\u4ea1\\u4e2d\\u65ad\\uff0c\\u739b\\u4e3d\\u6210\\u4e3a\\u514b\\u52b3\\u590d\\u4ec7\\u4e0e\\u81ea\\u6211\\u514b\\u5236\\u5e76\\u5b58\\u7684\\u60c5\\u611f\\u6838\\u5fc3\\u3002"}}, {"character_name": "\\u6258\\u6bd4", "survival_status": "deceased", "state_before": "\\u5b64\\u513f\\u9662\\u4e2d\\u8d1f\\u8d23\\u5288\\u67f4\\u7b49\\u6742\\u52a1\\u7684\\u6210\\u5458", "state_after": "\\u5728\\u53a8\\u623f\\u906d\\u88ad\\u8eab\\u4ea1", "psychological_change": "\\u4ece\\u8840\\u8ff9\\u548c\\u65a7\\u5934\\u4f4d\\u7f6e\\u53ef\\u5224\\u65ad\\uff0c\\u6258\\u6bd4\\u624b\\u90e8\\u5df2\\u7ecf\\u53d7\\u4f24\\uff0c\\u4ecd\\u8bd5\\u56fe\\u53d6\\u5f97\\u5288\\u67f4\\u65a7\\u8fdb\\u884c\\u62b5\\u6297\\uff0c\\u4f46\\u6700\\u7ec8\\u672a\\u80fd\\u89e6\\u53ca\\u6b66\\u5668\\u3002", "key_event": "\\u5012\\u5728\\u957f\\u684c\\u65c1\\uff0c\\u6307\\u5c16\\u8ddd\\u79bb\\u65a7\\u5934\\u53ea\\u6709\\u51e0\\u6b65", "relationship_changes": {"\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u6258\\u6bd4\\u4e4b\\u6b7b\\u76f4\\u63a5\\u89e6\\u53d1\\u514b\\u52b3\\u7684\\u9707\\u60ca\\u4e0e\\u590d\\u4ec7\\u51b2\\u52a8\\u3002", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6258\\u6bd4\\u7684\\u6b7b\\u4ea1\\u6210\\u4e3a\\u83b1\\u5c14\\u91cd\\u5efa\\u4f5c\\u6848\\u8fc7\\u7a0b\\u7684\\u7b2c\\u4e00\\u7ec4\\u73b0\\u573a\\u8bc1\\u636e\\u3002"}}, {"character_name": "\\u8bfa\\u4e9a", "survival_status": "deceased", "state_before": "\\u62b1\\u7740\\u6728\\u9a6c\\u751f\\u6d3b\\u5728\\u5b64\\u513f\\u9662\\u7684\\u5b69\\u5b50", "state_after": "\\u85cf\\u5728\\u53a8\\u623f\\u684c\\u4e0b\\u9047\\u5bb3", "psychological_change": "\\u8bfa\\u4e9a\\u53ef\\u80fd\\u5728\\u88ad\\u51fb\\u53d1\\u751f\\u65f6\\u62b1\\u7740\\u6728\\u9a6c\\u8eb2\\u5165\\u684c\\u4e0b\\uff0c\\u5176\\u6b7b\\u4ea1\\u4e0e\\u65ad\\u88c2\\u6728\\u9a6c\\u5171\\u540c\\u5f3a\\u5316\\u4e86\\u66b4\\u529b\\u5bf9\\u513f\\u7ae5\\u65e5\\u5e38\\u751f\\u6d3b\\u7684\\u6467\\u6bc1\\u3002", "key_event": "\\u514b\\u52b3\\u6380\\u5f00\\u684c\\u5e03\\u540e\\u53d1\\u73b0\\u8bfa\\u4e9a\\u4e0e\\u88c2\\u5f00\\u7684\\u6728\\u9a6c", "relationship_changes": {"\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u8bfa\\u4e9a\\u7684\\u6b7b\\u4ea1\\u4f7f\\u514b\\u52b3\\u77ed\\u6682\\u5931\\u8bed\\uff0c\\u5e76\\u8ba9\\u4ed6\\u7684\\u6124\\u6012\\u8fdb\\u4e00\\u6b65\\u7d2f\\u79ef\\u3002", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u65ad\\u88c2\\u6728\\u9a6c\\u5c06\\u83b1\\u5c14\\u6b64\\u524d\\u63a5\\u89e6\\u8fc7\\u7684\\u65e5\\u5e38\\u7269\\u4ef6\\u8f6c\\u5316\\u4e3a\\u60e8\\u6848\\u8bc1\\u7269\\u3002"}}, {"character_name": "\\u827e\\u62c9", "survival_status": "deceased", "state_before": "\\u5c45\\u4f4f\\u5728\\u5b64\\u513f\\u9662\\u5bbf\\u820d\\u7684\\u5b69\\u5b50", "state_after": "\\u8bd5\\u56fe\\u4ece\\u7a97\\u6237\\u9003\\u751f\\u4f46\\u672a\\u80fd\\u6210\\u529f\\uff0c\\u6700\\u7ec8\\u9047\\u5bb3", "psychological_change": "\\u5979\\u4e34\\u6b7b\\u524d\\u8868\\u73b0\\u51fa\\u660e\\u786e\\u7684\\u6c42\\u751f\\u884c\\u52a8\\uff0c\\u6293\\u7740\\u7a97\\u6846\\u5e76\\u8bd5\\u56fe\\u501f\\u6392\\u6c34\\u7ba1\\u9003\\u79bb\\uff0c\\u5374\\u6ca1\\u6709\\u7559\\u4e0b\\u843d\\u5730\\u811a\\u5370\\uff0c\\u8bf4\\u660e\\u5728\\u7ffb\\u7a97\\u8fc7\\u7a0b\\u4e2d\\u6216\\u6b64\\u524d\\u5c31\\u88ab\\u88ad\\u51fb\\u8005\\u622a\\u4f4f\\u3002", "key_event": "\\u88ab\\u53d1\\u73b0\\u8db4\\u5728\\u7a97\\u53f0\\u8fb9\\uff0c\\u624b\\u4ecd\\u6293\\u7740\\u7a97\\u6846", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u827e\\u62c9\\u7684\\u9003\\u751f\\u5931\\u8d25\\u4f7f\\u83b1\\u5c14\\u786e\\u8ba4\\u88ad\\u51fb\\u8005\\u5bf9\\u51fa\\u53e3\\u8fdb\\u884c\\u4e86\\u63a7\\u5236\\uff0c\\u4e5f\\u52a0\\u6df1\\u5176\\u538b\\u6291\\u548c\\u81ea\\u8d23\\u3002"}}, {"character_name": "\\u8428\\u59c6", "survival_status": "missing", "state_before": "\\u6668\\u661f\\u5b64\\u513f\\u9662\\u7684\\u5b69\\u5b50\\u4e4b\\u4e00", "state_after": "\\u5728\\u5c60\\u6740\\u540e\\u4e0b\\u843d\\u4e0d\\u660e\\uff0c\\u53ef\\u80fd\\u9003\\u8d70\\u6216\\u88ab\\u88ad\\u51fb\\u8005\\u5e26\\u8d70", "psychological_change": "\\u672c\\u7ae0\\u672a\\u76f4\\u63a5\\u5448\\u73b0\\u5176\\u5fc3\\u7406\\uff0c\\u4f46\\u5e8a\\u540e\\u8e6d\\u8fc7\\u7070\\u5c18\\u7684\\u75d5\\u8ff9\\u6697\\u793a\\u4ed6\\u53ef\\u80fd\\u5c1d\\u8bd5\\u85cf\\u533f\\u6216\\u9003\\u751f\\u3002", "key_event": "\\u83b1\\u5c14\\u6e05\\u70b9\\u5bbf\\u820d\\u540e\\u786e\\u8ba4\\u5c11\\u4e86\\u4e00\\u4eba", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6210\\u4e3a\\u83b1\\u5c14\\u5f53\\u524d\\u6700\\u8feb\\u5207\\u9700\\u8981\\u5bfb\\u627e\\u7684\\u5e78\\u5b58\\u8005\\u3002", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u6210\\u4e3a\\u514b\\u52b3\\u613f\\u610f\\u63a5\\u53d7\\u5b98\\u65b9\\u641c\\u67e5\\u65b9\\u6848\\u3001\\u6682\\u7f13\\u72ec\\u81ea\\u590d\\u4ec7\\u7684\\u5173\\u952e\\u7275\\u6302\\u3002"}}]	[{"location": "\\u6668\\u661f\\u5b64\\u513f\\u9662\\u8d70\\u5eca\\u3001\\u53a8\\u623f\\u4e0e\\u5bbf\\u820d", "atmosphere": "\\u8840\\u8165\\u3001\\u6b7b\\u5bc2\\u3001\\u538b\\u8feb\\uff0c\\u73b0\\u573a\\u52d8\\u67e5\\u4e0e\\u8fde\\u7eed\\u53d1\\u73b0\\u5c38\\u4f53\\u5f62\\u6210\\u6301\\u7eed\\u51b2\\u51fb", "duration": "\\u7ea6\\u5341\\u4e94\\u81f3\\u4e8c\\u5341\\u5206\\u949f"}, {"location": "\\u533b\\u52a1\\u5ba4\\u3001\\u4f1a\\u5ba2\\u5ba4\\u3001\\u793c\\u62dc\\u5ba4\\u53ca\\u540e\\u95e8\\u83dc\\u5730", "atmosphere": "\\u60b2\\u6078\\u8fbe\\u5230\\u9876\\u5cf0\\uff0c\\u5e76\\u7531\\u9057\\u4f53\\u53d1\\u73b0\\u8f6c\\u5165\\u7ebf\\u7d22\\u8ffd\\u8e2a\\u548c\\u8ffd\\u51f6\\u4e89\\u6267", "duration": "\\u7ea6\\u5341\\u81f3\\u5341\\u4e94\\u5206\\u949f"}, {"location": "\\u6cbb\\u5b89\\u7ba1\\u7406\\u6240\\u503c\\u52e4\\u5ba4", "atmosphere": "\\u4ece\\u8352\\u8bde\\u7684\\u4e0d\\u88ab\\u76f8\\u4fe1\\u8f6c\\u4e3a\\u7d27\\u5f20\\u52a8\\u5458\\uff0c\\u6700\\u7ec8\\u843d\\u5165\\u53d7\\u76d1\\u89c6\\u548c\\u88ab\\u62d8\\u7559\\u7684\\u5c01\\u95ed\\u611f", "duration": "\\u7ea6\\u56db\\u5341\\u81f3\\u4e94\\u5341\\u5206\\u949f"}]	varied	8.8	9.2	9.4	7.8	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.8/10\n  节奏把控: 9.2/10\n  吸引力: 9.4/10\n  连贯性: 7.8/10\n\n【剧情阶段】重大转折\n\n【钩子分析】共7个\n  • [悬念] 开篇直接以无人回应、断裂门闩和扑面而来的血腥味确认孤儿院遭遇重大变故，迅速把上一章的危机预兆转化为凶... (强度:10)\n  • [情感] 托比、诺亚与孤儿院孩子相继被发现遇害，木马断裂、伸向斧头的手等细节将集体死亡落到具体个体身上，制造强... (强度:10)\n  • [悬念] 宿舍床位与尸体数量不符，萨姆成为唯一确认失踪者，其究竟逃生、被绑架还是与袭击目标有关，构成全章最核心... (强度:10)\n\n【伏笔分析】埋下7个, 回收2个\n\n【冲突分析】\n  类型: 人与人, 人与己, 人与社会\n  强度: 10/10\n  进度: 15%\n\n【改进建议】\n  1. 【连贯性问题】建议核对并统一遇害人数：宿舍明确出现十一具尸体，厨房另有托比和诺亚，礼拜室另有玛丽，按字面统计应为十四名死者，与报案时的十三人遇害不符。可将宿舍尸体改为十具，或补充说明十二张床包含诺亚的床位且莱尔统计的是全院儿童总数，以避免读者在关键悬念处被数字问题分散注意力。	["\\u3010\\u8fde\\u8d2f\\u6027\\u95ee\\u9898\\u3011\\u5efa\\u8bae\\u6838\\u5bf9\\u5e76\\u7edf\\u4e00\\u9047\\u5bb3\\u4eba\\u6570\\uff1a\\u5bbf\\u820d\\u660e\\u786e\\u51fa\\u73b0\\u5341\\u4e00\\u5177\\u5c38\\u4f53\\uff0c\\u53a8\\u623f\\u53e6\\u6709\\u6258\\u6bd4\\u548c\\u8bfa\\u4e9a\\uff0c\\u793c\\u62dc\\u5ba4\\u53e6\\u6709\\u739b\\u4e3d\\uff0c\\u6309\\u5b57\\u9762\\u7edf\\u8ba1\\u5e94\\u4e3a\\u5341\\u56db\\u540d\\u6b7b\\u8005\\uff0c\\u4e0e\\u62a5\\u6848\\u65f6\\u7684\\u5341\\u4e09\\u4eba\\u9047\\u5bb3\\u4e0d\\u7b26\\u3002\\u53ef\\u5c06\\u5bbf\\u820d\\u5c38\\u4f53\\u6539\\u4e3a\\u5341\\u5177\\uff0c\\u6216\\u8865\\u5145\\u8bf4\\u660e\\u5341\\u4e8c\\u5f20\\u5e8a\\u5305\\u542b\\u8bfa\\u4e9a\\u7684\\u5e8a\\u4f4d\\u4e14\\u83b1\\u5c14\\u7edf\\u8ba1\\u7684\\u662f\\u5168\\u9662\\u513f\\u7ae5\\u603b\\u6570\\uff0c\\u4ee5\\u907f\\u514d\\u8bfb\\u8005\\u5728\\u5173\\u952e\\u60ac\\u5ff5\\u5904\\u88ab\\u6570\\u5b57\\u95ee\\u9898\\u5206\\u6563\\u6ce8\\u610f\\u529b\\u3002"]	\N	0.27	0.59	2026-08-06 15:47:58.054444
a6b68c35-289d-492c-8234-fe0a66625730	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	毛骨悚然	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u901a\\u8fc7\\u89e6\\u6478\\u76ae\\u5305\\u8bfb\\u53d6\\u5230\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u7ed1\\u67b6\\u7684\\u8fc7\\u7a0b\\uff0c\\u771f\\u8eab\\u88ab\\u56da\\u7981\\u5728\\u65e7\\u8d27\\u4ed3\\uff0c\\u800c\\u773c\\u524d\\u7ee7\\u7eed\\u6392\\u7ec3\\u7684\\u53ea\\u662f\\u4e00\\u4e2a\\u88ab\\u6fc0\\u6d3b\\u7684\\u6728\\u5076\\u66ff\\u8eab\\u3002\\u771f\\u8eab\\u5904\\u5883\\u5982\\u4f55\\u3001\\u5e55\\u540e\\u7ec4\\u7ec7\\u4e3a\\u4f55\\u8981\\u5728\\u6f14\\u5531\\u4f1a\\u524d\\u66ff\\u6362\\u5979\\uff0c\\u6210\\u4e3a\\u6700\\u5927\\u672a\\u89e3\\u60ac\\u5ff5\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5979\\u88ab\\u585e\\u8fdb\\u4e00\\u8f86\\u505c\\u7740\\u7684\\u9a6c\\u8f66"}, {"type": "\\u8ba4\\u77e5", "content": "\\u5899\\u8fb9\\u7acb\\u7740\\u7684\\u4eba\\u5f62\\u6728\\u5076\\u5b8c\\u5168\\u590d\\u523b\\u739b\\u8482\\u5c14\\u8fbe\\uff0c\\u7070\\u8863\\u4eba\\u901a\\u8fc7\\u89e6\\u6478\\u5934\\u9876\\u5c06\\u5176\\u6fc0\\u6d3b\\uff0c\\u63ed\\u793a\\u4e86\\u4e00\\u79cd\\u4ee5\\u5047\\u4e71\\u771f\\u7684\\u4eba\\u5076/\\u501f\\u8138\\u6280\\u672f\\u3002\\u8fd9\\u4e00\\u6280\\u672f\\u8ba9\\u8bfb\\u8005\\u610f\\u8bc6\\u5230\\uff0c\\u8eab\\u8fb9\\u4efb\\u4f55\\u770b\\u4f3c\\u719f\\u6089\\u7684\\u4eba\\u90fd\\u53ef\\u80fd\\u662f\\u5192\\u724c\\u8d27\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5899\\u8fb9\\u9760\\u7740\\u4e00\\u4e2a\\u4e1c\\u897f"}, {"type": "\\u60ac\\u5ff5", "content": "\\u6728\\u5076\\u739b\\u8482\\u5c14\\u8fbe\\u62b1\\u7740\\u76ae\\u5305\\u8fd4\\u56de\\uff0c\\u5bf9\\u83b1\\u5c14\\u6b6a\\u5934\\u5fae\\u7b11\\uff0c\\u624b\\u6307\\u5173\\u8282\\u6cdb\\u7740\\u54d1\\u5149\\u2014\\u2014\\u5979\\u662f\\u5426\\u5df2\\u7ecf\\u5bdf\\u89c9\\u83b1\\u5c14\\u52a8\\u8fc7\\u76ae\\u5305\\uff1f\\u5979\\u7684\\u5fae\\u7b11\\u662f\\u6728\\u5076\\u7684\\u8bbe\\u5b9a\\u8fd8\\u662f\\u64cd\\u63a7\\u8005\\u7684\\u8b66\\u89c9\\uff1f", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u5979\\u770b\\u7740\\u4ed6\\uff0c\\u6b6a\\u4e86\\u6b6a\\u5934\\uff0c\\u9732\\u51fa\\u4e00\\u4e2a\\u7b11"}]	3	\N	[{"title": "\\u6728\\u5076\\u7684\\u5bdf\\u89c9\\u5f0f\\u5fae\\u7b11", "content": "\\u6728\\u5076\\u739b\\u8482\\u5c14\\u8fbe\\u5728\\u83b1\\u5c14\\u8bfb\\u53d6\\u5b8c\\u76ae\\u5305\\u540e\\u62b1\\u7740\\u5305\\u51fa\\u73b0\\uff0c\\u6b6a\\u5934\\u5fae\\u7b11\\uff0c\\u624b\\u6307\\u5173\\u8282\\u6cdb\\u7740\\u54d1\\u5149\\u3002\\u8fd9\\u4e2a\\u5fae\\u7b11\\u53ef\\u80fd\\u53ea\\u662f\\u6728\\u5076\\u6a21\\u4eff\\u771f\\u4eba\\u7684\\u673a\\u68b0\\u884c\\u4e3a\\uff0c\\u4e5f\\u53ef\\u80fd\\u6697\\u793a\\u64cd\\u63a7\\u8005\\u5df2\\u7ecf\\u5bdf\\u89c9\\u83b1\\u5c14\\u6765\\u8fc7\\u3002\\u5b83\\u8ba9\\u83b1\\u5c14\\u786e\\u8ba4\\u9762\\u524d\\u7684\\u4eba\\u4e0d\\u662f\\u739b\\u8482\\u5c14\\u8fbe\\uff0c\\u540c\\u65f6\\u4e5f\\u66b4\\u9732\\u4e86\\u66ff\\u8eab\\u5177\\u6709\\u4e00\\u5b9a\\u7a0b\\u5ea6\\u7684\\u89c2\\u5bdf\\u4e0e\\u4f2a\\u88c5\\u80fd\\u529b\\u3002", "type": "planted", "strength": 9, "subtlety": 7, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u5979\\u770b\\u7740\\u4ed6\\uff0c\\u6b6a\\u4e86\\u6b6a\\u5934\\uff0c\\u9732\\u51fa\\u4e00\\u4e2a\\u7b11", "category": "mystery", "is_long_term": false, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 12}, {"title": "\\u4eba\\u50cf\\u96d5\\u523b\\u4e0e\\u501f\\u8138\\u6280\\u672f", "content": "\\u6728\\u5076\\u7684\\u8138\\u5b8c\\u5168\\u7167\\u7740\\u739b\\u8482\\u5c14\\u8fbe\\u96d5\\u523b\\uff0c\\u7709\\u773c\\u9f3b\\u6881\\u5634\\u89d2\\u4e00\\u6a21\\u4e00\\u4e2a\\u6a21\\u5b50\\uff0c\\u7070\\u767d\\u76ae\\u80a4\\u6cdb\\u7740\\u6728\\u5934\\u54d1\\u5149\\uff0c\\u5173\\u8282\\u80fd\\u770b\\u5230\\u69ab\\u63a5\\u7f1d\\u3002\\u7070\\u8863\\u4eba\\u901a\\u8fc7\\u89e6\\u6478\\u6728\\u5076\\u5934\\u9876\\u5c06\\u5176\\u6fc0\\u6d3b\\uff0c\\u4f7f\\u5176\\u884c\\u8d70\\u5982\\u6d3b\\u4eba\\u3002\\u8fd9\\u80cc\\u540e\\u7684\\u5236\\u4f5c\\u6280\\u672f\\u53ef\\u80fd\\u6d89\\u53ca\\u67d0\\u79cd\\u5f02\\u5e38\\u80fd\\u529b\\uff0c\\u4e5f\\u53ef\\u80fd\\u4e0e\\u83b1\\u5c14\\u81ea\\u8eab\\u7684\\u89e6\\u6478\\u80fd\\u529b\\u5b58\\u5728\\u67d0\\u79cd\\u5bf9\\u5e94\\u5173\\u7cfb\\u3002", "type": "planted", "strength": 8, "subtlety": 6, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u8138\\u662f\\u7167\\u7740\\u739b\\u8482\\u5c14\\u8fbe\\u63cf\\u7684", "category": "ability", "is_long_term": true, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 20}, {"title": "\\u739b\\u8482\\u5c14\\u8fbe\\u56da\\u7981\\u5904\\u7684\\u6c14\\u5473\\u7ebf\\u7d22", "content": "\\u83b1\\u5c14\\u5728\\u8bfb\\u53d6\\u4e2d\\u95fb\\u5230\\u65e7\\u8d27\\u4ed3\\u7279\\u6709\\u7684\\u6f6e\\u5473\\uff0c\\u5e76\\u770b\\u5230\\u9ad8\\u5c4b\\u9876\\u3001\\u5806\\u653e\\u7684\\u6728\\u7bb1\\u548c\\u5377\\u8d77\\u7684\\u5e06\\u5e03\\u3002\\u8fd9\\u4e9b\\u73af\\u5883\\u7ec6\\u8282\\u6210\\u4e3a\\u8ffd\\u8e2a\\u739b\\u8482\\u5c14\\u8fbe\\u771f\\u8eab\\u6240\\u5728\\u4f4d\\u7f6e\\u7684\\u91cd\\u8981\\u55c5\\u89c9\\u4e0e\\u89c6\\u89c9\\u7ebf\\u7d22\\uff0c\\u540e\\u7eed\\u529e\\u6848\\u65f6\\u53ef\\u80fd\\u901a\\u8fc7\\u6c14\\u5473\\u6216\\u5efa\\u7b51\\u7279\\u5f81\\u9501\\u5b9a\\u5730\\u70b9\\u3002", "type": "planted", "strength": 7, "subtlety": 7, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u4e00\\u80a1\\u6f6e\\u5473\\u2014\\u2014\\u65e7\\u8d27\\u4ed3", "category": "event", "is_long_term": false, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"], "estimated_resolve_chapter": 12}]	3	0	[{"content": "\\u83b1\\u5c14\\u89c2\\u5bdf\\u739b\\u8482\\u5c14\\u8fbe\\u6253\\u9f13\\uff0c\\u53d1\\u73b0\\u5979\\u7684\\u8282\\u594f\\u8fc7\\u4e8e\\u7cbe\\u51c6\\u3001\\u7f3a\\u4e4f\\u771f\\u4eba\\u8d77\\u4f0f\\uff0c\\u786e\\u8ba4\\u585e\\u897f\\u8389\\u7684\\u6000\\u7591\\u662f\\u5bf9\\u7684\\u3002", "type": "revelation", "importance": 0.8, "impact": "\\u5750\\u5b9e\\u739b\\u8482\\u5c14\\u8fbe\\u5f02\\u5e38\\uff0c\\u63a8\\u52a8\\u83b1\\u5c14\\u8fdb\\u4e00\\u6b65\\u63a5\\u8fd1\\u771f\\u76f8\\u3002", "keyword": "\\u8282\\u594f\\u662f\\u5bf9\\u7684\\u3002\\u53ef\\u4e0d\\u5bf9"}, {"content": "\\u83b1\\u5c14\\u89e6\\u78b0\\u5230\\u76ae\\u5305\\uff0c\\u901a\\u8fc7\\u80fd\\u529b\\u8bfb\\u53d6\\u5230\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u7ed1\\u67b6\\u3001\\u88ab\\u585e\\u8fdb\\u9a6c\\u8f66\\u8fd0\\u5f80\\u65e7\\u8d27\\u4ed3\\u7684\\u5168\\u8fc7\\u7a0b\\u3002", "type": "revelation", "importance": 0.9, "impact": "\\u63ed\\u793a\\u6848\\u4ef6\\u6838\\u5fc3\\uff1a\\u8fd9\\u4e0d\\u662f\\u666e\\u901a\\u5931\\u8e2a\\uff0c\\u800c\\u662f\\u4e00\\u573a\\u6709\\u9884\\u8c0b\\u7684\\u66ff\\u8eab\\u8ba1\\u5212\\u3002", "keyword": "\\u5979\\u88ab\\u585e\\u8fdb\\u4e00\\u8f86\\u505c\\u7740\\u7684\\u9a6c\\u8f66"}, {"content": "\\u8bfb\\u53d6\\u753b\\u9762\\u4e2d\\u51fa\\u73b0\\u5b8c\\u5168\\u4eff\\u9020\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u6728\\u5076\\uff0c\\u88ab\\u7070\\u8863\\u4eba\\u6fc0\\u6d3b\\u540e\\u80cc\\u7740\\u5305\\u8d70\\u51fa\\u8d27\\u4ed3\\uff0c\\u6210\\u4e3a\\u6b63\\u9762\\u6d3b\\u52a8\\u7684\\u66ff\\u8eab\\u3002", "type": "revelation", "importance": 1.0, "impact": "\\u786e\\u5b9a\\u773c\\u524d\\u739b\\u8482\\u5c14\\u8fbe\\u662f\\u5047\\u4eba\\uff0c\\u771f\\u8eab\\u88ab\\u56da\\uff0c\\u5e55\\u540e\\u52bf\\u529b\\u6b63\\u5728\\u7b56\\u5212\\u66f4\\u5927\\u7684\\u76ee\\u7684\\u3002", "keyword": "\\u5b83\\u4ece\\u5899\\u89d2\\u8d70\\u51fa\\u6765\\uff0c\\u811a\\u8e29\\u5728\\u5730\\u4e0a\\u7684\\u7b2c\\u4e00\\u6b65\\u8fd8\\u5e26\\u7740\\u4e00\\u70b9\\u6728\\u5934\\u7684\\u50f5"}, {"content": "\\u6728\\u5076\\u739b\\u8482\\u5c14\\u8fbe\\u56de\\u5230\\u6392\\u7ec3\\u5ba4\\uff0c\\u5bf9\\u83b1\\u5c14\\u6b6a\\u5934\\u5fae\\u7b11\\uff0c\\u624b\\u6307\\u5173\\u8282\\u6cdb\\u7740\\u54d1\\u5149\\uff0c\\u4f3c\\u4e4e\\u5bdf\\u89c9\\u5230\\u83b1\\u5c14\\u7684\\u5f02\\u6837\\u3002", "type": "complication", "importance": 0.85, "impact": "\\u66ff\\u8eab\\u5177\\u6709\\u89c2\\u5bdf\\u4e0e\\u4f2a\\u88c5\\u80fd\\u529b\\uff0c\\u83b1\\u5c14\\u66b4\\u9732\\u7684\\u98ce\\u9669\\u589e\\u5927\\uff0c\\u5367\\u5e95\\u8c03\\u67e5\\u968f\\u65f6\\u53ef\\u80fd\\u88ab\\u53cd\\u5236\\u3002", "keyword": "\\u5979\\u770b\\u7740\\u4ed6\\uff0c\\u6b6a\\u4e86\\u6b6a\\u5934\\uff0c\\u9732\\u51fa\\u4e00\\u4e2a\\u7b11"}]	4	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": "active", "state_before": "\\u6000\\u7591\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u6253\\u9f13\\u8282\\u594f\\u5f02\\u5e38\\u56f0\\u6270\\uff0c\\u6b63\\u5728\\u8c03\\u67e5", "state_after": "\\u786e\\u8ba4\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u6728\\u5076\\u66ff\\u6362\\u3001\\u771f\\u8eab\\u88ab\\u56da\\uff0c\\u8f6c\\u4e3a\\u66f4\\u9690\\u79d8\\u7684\\u79d8\\u5bc6\\u884c\\u52a8", "psychological_change": "\\u4ece\\u51b7\\u9759\\u89c2\\u5bdf\\u53d8\\u4e3a\\u5f3a\\u538b\\u5185\\u5fc3\\u9707\\u60ca\\uff0c\\u610f\\u8bc6\\u5230\\u5e55\\u540e\\u52bf\\u529b\\u8fdc\\u6bd4\\u60f3\\u8c61\\u4e2d\\u5371\\u9669\\uff0c\\u884c\\u52a8\\u66f4\\u52a0\\u8c28\\u614e\\uff0c\\u6307\\u7532\\u6390\\u8fdb\\u638c\\u5fc3\\u4e5f\\u4e0d\\u8ba9\\u81ea\\u5df1\\u5598\\u51fa\\u6c14\\u3002", "key_event": "\\u89e6\\u6478\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u76ae\\u5305\\uff0c\\u5b8c\\u6574\\u8bfb\\u53d6\\u5230\\u7ed1\\u67b6\\u3001\\u6728\\u5076\\u6fc0\\u6d3b\\u4e0e\\u66ff\\u6362\\u7684\\u8fc7\\u7a0b", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4fe1\\u4efb\\u52a0\\u6df1\\uff0c\\u5171\\u540c\\u627f\\u62c5\\u79d8\\u5bc6", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u786e\\u8ba4\\u5bf9\\u65b9\\u4e3a\\u6728\\u5076\\u66ff\\u8eab\\uff0c\\u771f\\u8eab\\u53e6\\u6709\\u5176\\u4eba"}}, {"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": "active", "state_before": "\\u62c5\\u5fe7\\u961f\\u53cb\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u72b6\\u6001\\uff0c\\u4e3b\\u52a8\\u5e26\\u83b1\\u5c14\\u524d\\u6765\\u786e\\u8ba4", "state_after": "\\u786e\\u8ba4\\u961f\\u53cb\\u88ab\\u66ff\\u6362\\uff0c\\u9707\\u60ca\\u4f46\\u5f3a\\u884c\\u9547\\u5b9a\\uff0c\\u51b3\\u5fc3\\u6551\\u56de\\u771f\\u8eab", "psychological_change": "\\u770b\\u5230\\u83b1\\u5c14\\u8138\\u8272\\u4e0d\\u5bf9\\u65f6\\u66f4\\u52a0\\u8b66\\u60d5\\uff0c\\u4f46\\u6ca1\\u6709\\u5f53\\u573a\\u8ffd\\u95ee\\uff0c\\u9009\\u62e9\\u7528\\u6697\\u8bed\\u786e\\u8ba4\\uff0c\\u5c55\\u73b0\\u6210\\u719f\\u7684\\u5fc3\\u7406\\u627f\\u53d7\\u529b\\u3002", "key_event": "\\u4e0e\\u83b1\\u5c14\\u773c\\u795e\\u4ea4\\u6d41\\u5e76\\u5f97\\u5230\\u786e\\u8ba4\\u7ed3\\u679c", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4fe1\\u4efb\\u8fdb\\u4e00\\u6b65\\u52a0\\u6df1", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u4ece\\u62c5\\u5fe7\\u8f6c\\u4e3a\\u75db\\u60dc\\uff0c\\u51b3\\u5fc3\\u6551\\u56de\\u771f\\u8eab"}}, {"character_name": "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "survival_status": "active", "state_before": "\\u88ab\\u5f02\\u5e38\\u66ff\\u8eab\\u9876\\u66ff\\uff0c\\u5468\\u56f4\\u4eba\\u53ea\\u89c9\\u5176\\u6027\\u683c\\u3001\\u8282\\u594f\\u5f02\\u5e38", "state_after": "\\u786e\\u8ba4\\u771f\\u8eab\\u88ab\\u56da\\u7981\\u5728\\u65e7\\u8d27\\u4ed3\\uff0c\\u6728\\u5076\\u66ff\\u8eab\\u7ee7\\u7eed\\u4ee5\\u5979\\u7684\\u8eab\\u4efd\\u6d3b\\u52a8", "psychological_change": "\\u8bfb\\u53d6\\u753b\\u9762\\u4e2d\\u771f\\u8eab\\u5728\\u7ed1\\u7f1a\\u4e2d\\u4ecd\\u7741\\u773c\\u770b\\u7740\\u95e8\\u53e3\\uff0c\\u8868\\u73b0\\u51fa\\u4e00\\u5b9a\\u9547\\u5b9a\\u4e0e\\u5fcd\\u8010\\uff0c\\u4f46\\u5f53\\u524d\\u5fc3\\u7406\\u72b6\\u6001\\u672a\\u77e5\\u3002", "key_event": "\\u88ab\\u88f9\\u5165\\u7ed1\\u67b6\\u4e8b\\u4ef6\\uff0c\\u88ab\\u6728\\u5076\\u66ff\\u4ee3\\u8eab\\u4efd", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u771f\\u8eab\\u6682\\u65f6\\u4e0e\\u5916\\u754c\\u9694\\u7edd\\uff0c\\u66ff\\u8eab\\u7ef4\\u7cfb\\u8868\\u9762\\u5173\\u7cfb", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6210\\u4e3a\\u83b1\\u5c14\\u7684\\u8425\\u6551\\u76ee\\u6807"}}]	[{"location": "\\u65e7\\u4ed3\\u5e93\\u6392\\u7ec3\\u5ba4", "atmosphere": "\\u534a\\u660e\\u534a\\u6697\\u3001\\u538b\\u6291", "duration": "\\u5f00\\u573a\\u7ea6600\\u5b57"}, {"location": "\\u8bb0\\u5fc6\\u753b\\u9762\\uff1a\\u591c\\u8def\\u4e0e\\u9a6c\\u8f66", "atmosphere": "\\u6f6e\\u6e7f\\u3001\\u7d27\\u5f20\\u3001\\u7a81\\u53d1", "duration": "\\u7ea6400\\u5b57"}, {"location": "\\u8bb0\\u5fc6\\u753b\\u9762\\uff1a\\u65e7\\u8d27\\u4ed3", "atmosphere": "\\u660f\\u6697\\u3001\\u8be1\\u5f02\\u3001\\u6bdb\\u9aa8\\u609a\\u7136", "duration": "\\u7ea6700\\u5b57"}, {"location": "\\u6392\\u7ec3\\u5ba4\\uff08\\u8fd4\\u56de\\u73b0\\u5b9e\\uff09", "atmosphere": "\\u8868\\u9762\\u5e73\\u9759\\u3001\\u6697\\u6d41\\u6d8c\\u52a8", "duration": "\\u7ea6400\\u5b57"}]	varied	8.2	7.8	8.2	8.5	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.2/10\n  节奏把控: 7.8/10\n  吸引力: 8.2/10\n  连贯性: 8.5/10\n\n【剧情阶段】发展\n\n【钩子分析】共3个\n  • [悬念] 莱尔通过触摸皮包读取到玛蒂尔达被绑架的过程，真身被囚禁在旧货仓，而眼前继续排练的只是一个被激活的木偶... (强度:9)\n  • [认知] 墙边立着的人形木偶完全复刻玛蒂尔达，灰衣人通过触摸头顶将其激活，揭示了一种以假乱真的人偶/借脸技术。... (强度:8)\n  • [悬念] 木偶玛蒂尔达抱着皮包返回，对莱尔歪头微笑，手指关节泛着哑光——她是否已经察觉莱尔动过皮包？她的微笑是... (强度:8)\n\n【伏笔分析】埋下4个, 回收1个\n\n【冲突分析】\n  类型: 人与人, 人与己\n  强度: 8/10\n  进度: 20%\n\n【改进建议】\n  1. 【细节增强】结尾木偶微笑时，建议在'歪了歪头'后补充一个不对称的细微动作（如歪头角度比正常人略大、发丝纹路一动不动），强化'非人'的恐怖感，同时让莱尔确认的'哑光'有更多视觉支撑。	["\\u3010\\u7ec6\\u8282\\u589e\\u5f3a\\u3011\\u7ed3\\u5c3e\\u6728\\u5076\\u5fae\\u7b11\\u65f6\\uff0c\\u5efa\\u8bae\\u5728'\\u6b6a\\u4e86\\u6b6a\\u5934'\\u540e\\u8865\\u5145\\u4e00\\u4e2a\\u4e0d\\u5bf9\\u79f0\\u7684\\u7ec6\\u5fae\\u52a8\\u4f5c\\uff08\\u5982\\u6b6a\\u5934\\u89d2\\u5ea6\\u6bd4\\u6b63\\u5e38\\u4eba\\u7565\\u5927\\u3001\\u53d1\\u4e1d\\u7eb9\\u8def\\u4e00\\u52a8\\u4e0d\\u52a8\\uff09\\uff0c\\u5f3a\\u5316'\\u975e\\u4eba'\\u7684\\u6050\\u6016\\u611f\\uff0c\\u540c\\u65f6\\u8ba9\\u83b1\\u5c14\\u786e\\u8ba4\\u7684'\\u54d1\\u5149'\\u6709\\u66f4\\u591a\\u89c6\\u89c9\\u652f\\u6491\\u3002"]	\N	0.2	0.6	2026-08-07 10:12:40.119935
663a0ec5-4745-4941-a4f3-1beea5f62d94	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	调查发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a", "\\u4eba\\u4e0e\\u73af\\u5883"]	压抑哀恸	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u8b66\\u65b9\\u53d1\\u73b0\\u4e00\\u8f86\\u6ca1\\u6709\\u767b\\u8bb0\\u8f66\\u724c\\u7684\\u9a6c\\u8f66\\uff0c\\u5176\\u7834\\u635f\\u8f66\\u8f6e\\u7559\\u4e0b\\u72ec\\u7279\\u65ad\\u7eb9\\uff0c\\u53ef\\u80fd\\u662f\\u88ad\\u51fb\\u8005\\u8fd0\\u9001\\u4eba\\u5458\\u6216\\u64a4\\u79bb\\u73b0\\u573a\\u7684\\u5173\\u952e\\u8f7d\\u5177\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8fd8\\u6709\\u4e00\\u8f86\\u6ca1\\u6709\\u767b\\u8bb0\\u8f66\\u724c"}, {"type": "\\u8ba4\\u77e5", "content": "\\u6cbb\\u5b89\\u6240\\u660e\\u786e\\u6392\\u9664\\u83b1\\u5c14\\u4e0e\\u514b\\u52b3\\u7684\\u5acc\\u7591\\uff0c\\u5e76\\u8ba4\\u771f\\u590d\\u6838\\u4e8c\\u4eba\\u63d0\\u4f9b\\u7684\\u8bc1\\u636e\\uff0c\\u6253\\u7834\\u4e86\\u8bfb\\u8005\\u5bf9\\u5b98\\u65b9\\u673a\\u6784\\u6577\\u884d\\u3001\\u654c\\u5bf9\\u6216\\u8150\\u8d25\\u7684\\u60ef\\u6027\\u9884\\u671f\\u3002", "strength": 7, "position": "\\u4e2d\\u6bb5", "keyword": "\\u4f60\\u4eec\\u4e0d\\u662f\\u5acc\\u7591\\u4eba\\u3002\\u628a\\u4f60\\u4eec\\u7559\\u5728\\u8fd9\\u91cc"}, {"type": "\\u60ac\\u5ff5", "content": "\\u73b0\\u573a\\u5899\\u7070\\u88ab\\u4f5c\\u4e3a\\u7279\\u6b8a\\u8bc1\\u7269\\u5c01\\u5b58\\uff0c\\u6848\\u4ef6\\u56e0\\u6b64\\u8fdb\\u5165\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u7ba1\\u8f96\\u8303\\u56f4\\uff0c\\u6697\\u793a\\u5b64\\u513f\\u9662\\u88ad\\u51fb\\u6d89\\u53ca\\u8d85\\u81ea\\u7136\\u529b\\u91cf\\u6216\\u5f02\\u5e38\\u7269\\u8d28\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8eba\\u7740\\u51e0\\u7c92\\u989c\\u8272\\u53d1\\u6697\\u7684\\u5899\\u7070"}, {"type": "\\u60c5\\u611f", "content": "\\u8d70\\u5eca\\u4e2d\\u7684\\u5b69\\u5b50\\u54ed\\u58f0\\u89e6\\u53d1\\u514b\\u52b3\\u7684\\u521b\\u4f24\\u53cd\\u5e94\\uff0c\\u83b1\\u5c14\\u7acb\\u5373\\u906e\\u4f4f\\u89c2\\u5bdf\\u7a97\\u5e76\\u5b89\\u6170\\u4ed6\\uff0c\\u96c6\\u4e2d\\u5448\\u73b0\\u5e78\\u5b58\\u8005\\u7684\\u5185\\u759a\\u3001\\u54c0\\u75db\\u4e0e\\u5f7c\\u6b64\\u4f9d\\u8d56\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u514b\\u52b3\\u624b\\u8155\\u4e00\\u6296\\uff0c\\u6c34\\u6d12\\u5728\\u819d\\u5934"}, {"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u4ece\\u8bbf\\u5ba2\\u753b\\u50cf\\u4e2d\\u8ba4\\u51fa\\u4e09\\u540d\\u7070\\u8863\\u7537\\u5b50\\uff0c\\u800c\\u4ed6\\u4eec\\u66fe\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u8c03\\u67e5\\u5458\\uff1b\\u771f\\u6b63\\u7684\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u6b64\\u65f6\\u53c8\\u5c06\\u6b63\\u5f0f\\u4ecb\\u5165\\uff0c\\u5236\\u9020\\u771f\\u5047\\u8c03\\u67e5\\u5458\\u7684\\u8eab\\u4efd\\u7591\\u4e91\\u3002", "strength": 9, "position": "\\u4e2d\\u540e\\u6bb5", "keyword": "\\u4ed6\\u4eec\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u8c03\\u67e5\\u5458"}, {"type": "\\u60c5\\u611f", "content": "\\u70e7\\u9ed1\\u5ff5\\u73e0\\u4ee5\\u5177\\u4f53\\u9057\\u7269\\u627f\\u8f7d\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u6b7b\\u4ea1\\u4e0e\\u5b69\\u5b50\\u4eec\\u7684\\u5171\\u540c\\u8bb0\\u5fc6\\uff0c\\u5728\\u8c03\\u67e5\\u7ebf\\u7d22\\u4e4b\\u5916\\u5f62\\u6210\\u514b\\u5236\\u800c\\u5f3a\\u70c8\\u7684\\u54c0\\u60bc\\u6536\\u675f\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u90a3\\u662f\\u5979\\u7684\\u5ff5\\u73e0\\u3002\\u83b1\\u5c14\\u8bf4"}]	6	\N	[]	0	0	[{"content": "\\u6cbb\\u5b89\\u6240\\u901a\\u8fc7\\u5e97\\u94fa\\u3001\\u57ce\\u95e8\\u548c\\u91c7\\u8d2d\\u5355\\u6838\\u5b9e\\u83b1\\u5c14\\u4e0e\\u514b\\u52b3\\u7684\\u884c\\u52a8\\u8def\\u7ebf\\uff0c\\u6b63\\u5f0f\\u6392\\u9664\\u4e8c\\u4eba\\u7684\\u4f5c\\u6848\\u5acc\\u7591\\u3002", "type": "resolution", "importance": 0.75, "impact": "\\u7ed3\\u675f\\u4e3b\\u89d2\\u662f\\u5426\\u4f1a\\u906d\\u5b98\\u65b9\\u62d8\\u62bc\\u7684\\u77ed\\u671f\\u60ac\\u5ff5\\uff0c\\u4f7f\\u53d9\\u4e8b\\u91cd\\u5fc3\\u4ece\\u81ea\\u8bc1\\u6e05\\u767d\\u8f6c\\u5411\\u5408\\u4f5c\\u8ffd\\u51f6\\u3002", "keyword": "\\u4f60\\u4eec\\u4e0d\\u662f\\u5acc\\u7591\\u4eba\\u3002\\u628a\\u4f60\\u4eec\\u7559\\u5728\\u8fd9\\u91cc"}, {"content": "\\u8b66\\u65b9\\u9501\\u5b9a\\u4e00\\u8f86\\u65e0\\u724c\\u9a6c\\u8f66\\uff0c\\u5e76\\u4ee5\\u5de6\\u4fa7\\u7834\\u635f\\u8f66\\u8f6e\\u5f62\\u6210\\u7684\\u65ad\\u7eb9\\u4f5c\\u4e3a\\u8ffd\\u8e2a\\u4f9d\\u636e\\u3002", "type": "revelation", "importance": 0.9, "impact": "\\u628a\\u540e\\u95e8\\u8f66\\u8f99\\u4ece\\u73b0\\u573a\\u89c2\\u5bdf\\u63d0\\u5347\\u4e3a\\u53ef\\u8de8\\u8f96\\u533a\\u8ffd\\u67e5\\u7684\\u5b9e\\u8bc1\\uff0c\\u4e3a\\u9501\\u5b9a\\u64a4\\u79bb\\u8def\\u7ebf\\u548c\\u88ad\\u51fb\\u8005\\u636e\\u70b9\\u63d0\\u4f9b\\u7a81\\u7834\\u53e3\\u3002", "keyword": "\\u8fd8\\u6709\\u4e00\\u8f86\\u6ca1\\u6709\\u767b\\u8bb0\\u8f66\\u724c"}, {"content": "\\u5f02\\u5e38\\u5899\\u7070\\u88ab\\u5c01\\u5b58\\u4e3a\\u8bc1\\u7269\\uff0c\\u6cbb\\u5b89\\u5b98\\u5ba3\\u5e03\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u5c06\\u4ecb\\u5165\\u5b64\\u513f\\u9662\\u6848\\u4ef6\\u3002", "type": "transition", "importance": 0.95, "impact": "\\u660e\\u786e\\u6848\\u4ef6\\u5b58\\u5728\\u8d85\\u51fa\\u666e\\u901a\\u6cbb\\u5b89\\u4f53\\u7cfb\\u7684\\u6210\\u5206\\uff0c\\u63a8\\u52a8\\u6545\\u4e8b\\u8fdb\\u5165\\u8d85\\u51e1\\u673a\\u6784\\u4e0e\\u80fd\\u529b\\u8c03\\u67e5\\u5c42\\u9762\\u3002", "keyword": "\\u73b0\\u573a\\u6709\\u4e9b\\u60c5\\u51b5\\uff0c\\u4e0d\\u5f52\\u6211\\u4eec\\u5355\\u72ec\\u5904\\u7406"}, {"content": "\\u83b1\\u5c14\\u901a\\u8fc7\\u753b\\u50cf\\u8ba4\\u51fa\\u4e09\\u540d\\u7070\\u8863\\u8bbf\\u5ba2\\uff0c\\u5e76\\u6307\\u51fa\\u4ed6\\u4eec\\u66fe\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u8c03\\u67e5\\u5458\\u3002", "type": "revelation", "importance": 1.0, "impact": "\\u5c06\\u7b2c2\\u7ae0\\u8bbf\\u5ba2\\u4fe1\\u606f\\u8f6c\\u5316\\u4e3a\\u6838\\u5fc3\\u5acc\\u7591\\u7ebf\\u7d22\\uff0c\\u540c\\u65f6\\u5236\\u9020\\u5192\\u540d\\u3001\\u5185\\u9b3c\\u6216\\u673a\\u6784\\u9690\\u7792\\u7b49\\u591a\\u91cd\\u53ef\\u80fd\\u3002", "keyword": "\\u4ed6\\u4eec\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u8c03\\u67e5\\u5458"}, {"content": "\\u8b66\\u65b9\\u5728\\u793c\\u62dc\\u5ba4\\u95e8\\u8fb9\\u627e\\u5230\\u739b\\u4e3d\\u4fee\\u5973\\u70e7\\u9ed1\\u7684\\u5ff5\\u73e0\\uff0c\\u5e76\\u627f\\u8bfa\\u6848\\u4ef6\\u7ed3\\u675f\\u540e\\u5f52\\u8fd8\\u3002", "type": "conflict", "importance": 0.8, "impact": "\\u4ee5\\u9057\\u7269\\u5f3a\\u5316\\u739b\\u4e3d\\u4fee\\u5973\\u6b7b\\u4ea1\\u7684\\u60c5\\u611f\\u91cd\\u91cf\\uff0c\\u4e5f\\u8ba9\\u4e3b\\u89d2\\u8ffd\\u67e5\\u771f\\u76f8\\u7684\\u79c1\\u4eba\\u52a8\\u673a\\u5f97\\u5230\\u518d\\u6b21\\u786e\\u8ba4\\u3002", "keyword": "\\u4ece\\u793c\\u62dc\\u5ba4\\u95e8\\u8fb9\\u627e\\u5230\\u7684\\u3002\\u4f60\\u4eec\\u8ba4\\u5f97\\u5417"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u5f7b\\u591c\\u672a\\u7720\\uff0c\\u4ee5\\u51b7\\u9759\\u548c\\u8ba5\\u8bbd\\u538b\\u5236\\u4e27\\u4eb2\\u540e\\u7684\\u75b2\\u60eb\\u4e0e\\u60b2\\u75db", "state_after": "\\u786e\\u8ba4\\u5b98\\u65b9\\u8c03\\u67e5\\u6b63\\u5728\\u6709\\u6548\\u63a8\\u8fdb\\uff0c\\u5e76\\u4ece\\u9a6c\\u8f66\\u3001\\u978b\\u5370\\u3001\\u7070\\u8863\\u8bbf\\u5ba2\\u548c\\u5f02\\u5e38\\u5899\\u7070\\u4e2d\\u5efa\\u7acb\\u8d77\\u8f83\\u6e05\\u6670\\u7684\\u8ffd\\u67e5\\u65b9\\u5411", "psychological_change": "\\u83b1\\u5c14\\u7531\\u88ab\\u52a8\\u7b49\\u5f85\\u95ee\\u8be2\\u8f6c\\u4e3a\\u4e3b\\u52a8\\u53c2\\u4e0e\\u8c03\\u67e5\\u3002\\u4ed6\\u53d1\\u73b0\\u6cbb\\u5b89\\u6240\\u5e76\\u672a\\u5ffd\\u89c6\\u81ea\\u5df1\\u7684\\u73b0\\u573a\\u5224\\u65ad\\u540e\\uff0c\\u5bf9\\u5b98\\u65b9\\u7a0b\\u5e8f\\u4ea7\\u751f\\u6709\\u9650\\u4fe1\\u4efb\\uff0c\\u4f46\\u4f9d\\u65e7\\u4fdd\\u6301\\u8b66\\u60d5\\u3002\\u9762\\u5bf9\\u514b\\u52b3\\u7684\\u521b\\u4f24\\u53cd\\u5e94\\uff0c\\u4ed6\\u6301\\u7eed\\u627f\\u62c5\\u7167\\u987e\\u8005\\u4e0e\\u7a33\\u5b9a\\u8005\\u7684\\u804c\\u8d23\\uff0c\\u4e2a\\u4eba\\u60b2\\u4f24\\u5219\\u4e3b\\u8981\\u901a\\u8fc7\\u679c\\u9171\\u548c\\u5ff5\\u73e0\\u7684\\u8bb0\\u5fc6\\u95f4\\u63a5\\u6d41\\u9732\\u3002", "key_event": "\\u901a\\u8fc7\\u8bbf\\u5ba2\\u753b\\u50cf\\u8ba4\\u51fa\\u4e09\\u540d\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u8c03\\u67e5\\u5458\\u7684\\u7070\\u8863\\u7537\\u5b50\\uff0c\\u5e76\\u5f97\\u77e5\\u771f\\u6b63\\u7684\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u5373\\u5c06\\u4ecb\\u5165", "relationship_changes": {"\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u83b1\\u5c14\\u4e3b\\u52a8\\u7d22\\u8981\\u70ed\\u6c34\\u3001\\u906e\\u6321\\u89c2\\u5bdf\\u7a97\\u5e76\\u5224\\u65ad\\u514b\\u52b3\\u7684\\u60c5\\u7eea\\u72b6\\u6001\\uff0c\\u53cc\\u65b9\\u5173\\u7cfb\\u8fdb\\u4e00\\u6b65\\u8f6c\\u5316\\u4e3a\\u7531\\u83b1\\u5c14\\u8d1f\\u8d23\\u5224\\u65ad\\u4e0e\\u7a33\\u5b9a\\u3001\\u514b\\u52b3\\u63a5\\u53d7\\u5176\\u7167\\u6599\\u548c\\u5b89\\u6392\\u7684\\u9ad8\\u5ea6\\u4fe1\\u8d56\\u6a21\\u5f0f\\u3002", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u739b\\u4e3d\\u4fee\\u5973\\u4ece\\u65e5\\u5e38\\u7167\\u6599\\u8005\\u5f7b\\u5e95\\u8f6c\\u5316\\u4e3a\\u83b1\\u5c14\\u5fc5\\u987b\\u4e3a\\u4e4b\\u8ffd\\u67e5\\u771f\\u76f8\\u7684\\u901d\\u53bb\\u5bb6\\u4eba\\uff1b\\u679c\\u9171\\u548c\\u70e7\\u9ed1\\u5ff5\\u73e0\\u4f7f\\u8fd9\\u4efd\\u8d23\\u4efb\\u5177\\u8c61\\u5316\\u3002", "\\u7070\\u80e1\\u5b50\\u6cbb\\u5b89\\u5b98": "\\u4ece\\u53ef\\u80fd\\u7684\\u5ba1\\u8baf\\u8005\\u8f6c\\u53d8\\u4e3a\\u53ef\\u6709\\u9650\\u5408\\u4f5c\\u7684\\u8c03\\u67e5\\u8005\\uff0c\\u83b1\\u5c14\\u5f00\\u59cb\\u8ba4\\u53ef\\u5176\\u529e\\u6848\\u8ba4\\u771f\\u7a0b\\u5ea6\\uff0c\\u4f46\\u5c1a\\u672a\\u5b8c\\u5168\\u4ea4\\u4ed8\\u4fe1\\u4efb\\u3002"}}, {"character_name": "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "survival_status": null, "state_before": "\\u50f5\\u786c\\u5c01\\u95ed\\uff0c\\u6574\\u591c\\u63e1\\u7740\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u7269\\u54c1\\uff0c\\u4ee5\\u6c89\\u9ed8\\u538b\\u5236\\u60b2\\u75db\\u4e0e\\u590d\\u4ec7\\u51b2\\u52a8", "state_after": "\\u4ecd\\u5904\\u4e8e\\u5f3a\\u70c8\\u521b\\u4f24\\u548c\\u6124\\u6012\\u4e2d\\uff0c\\u4f46\\u6682\\u65f6\\u63a5\\u53d7\\u83b1\\u5c14\\u4e0e\\u6cbb\\u5b89\\u5b98\\u7684\\u73b0\\u5b9e\\u5224\\u65ad\\uff0c\\u6ca1\\u6709\\u64c5\\u81ea\\u524d\\u5f80\\u65e7\\u8d27\\u573a", "psychological_change": "\\u514b\\u52b3\\u5bf9\\u8c03\\u67e5\\u8fdb\\u5c55\\u8868\\u73b0\\u51fa\\u6025\\u8feb\\u611f\\uff0c\\u5f97\\u77e5\\u8d27\\u573a\\u7ebf\\u7d22\\u540e\\u7acb\\u5373\\u63d0\\u51fa\\u4eb2\\u81ea\\u5bfb\\u627e\\uff0c\\u663e\\u793a\\u5176\\u503e\\u5411\\u7528\\u884c\\u52a8\\u548c\\u66b4\\u529b\\u6446\\u8131\\u65e0\\u529b\\u611f\\u3002\\u5b69\\u5b50\\u7684\\u54ed\\u58f0\\u89e6\\u53d1\\u660e\\u663e\\u5e94\\u6fc0\\u53cd\\u5e94\\uff0c\\u8bf4\\u660e\\u5b64\\u513f\\u9662\\u60e8\\u6848\\u5df2\\u9020\\u6210\\u6df1\\u5c42\\u521b\\u4f24\\u3002\\u6700\\u7ec8\\u9762\\u5bf9\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u5ff5\\u73e0\\uff0c\\u4ed6\\u7ee7\\u7eed\\u4ee5\\u6c89\\u9ed8\\u627f\\u53d7\\u60b2\\u75db\\uff0c\\u6ca1\\u6709\\u5931\\u63a7\\u884c\\u52a8\\u3002", "key_event": "\\u4e3b\\u52a8\\u8981\\u6c42\\u524d\\u5f80\\u897f\\u5357\\u65e7\\u8d27\\u573a\\u8ffd\\u67e5\\u9a6c\\u8f66\\uff0c\\u4f46\\u88ab\\u6cbb\\u5b89\\u5b98\\u4ee5\\u5b89\\u5168\\u548c\\u8c03\\u67e5\\u6548\\u7387\\u4e3a\\u7531\\u963b\\u6b62", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u63a5\\u53d7\\u83b1\\u5c14\\u9012\\u6765\\u7684\\u70ed\\u6c34\\u3001\\u5b89\\u6170\\u548c\\u73b0\\u573a\\u5224\\u65ad\\uff0c\\u5728\\u9ad8\\u5ea6\\u4e0d\\u5b89\\u4e2d\\u4ecd\\u613f\\u610f\\u542c\\u4ece\\u83b1\\u5c14\\u7684\\u8282\\u594f\\uff0c\\u4f9d\\u8d56\\u4e0e\\u670d\\u4ece\\u8fdb\\u4e00\\u6b65\\u589e\\u5f3a\\u3002", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u70e7\\u9ed1\\u7684\\u5ff5\\u73e0\\u548c\\u674e\\u5b50\\u679c\\u9171\\u5524\\u8d77\\u5bb6\\u5ead\\u8bb0\\u5fc6\\uff0c\\u4f7f\\u5176\\u4e27\\u4eb2\\u60b2\\u75db\\u8fdb\\u4e00\\u6b65\\u52a0\\u6df1\\uff0c\\u5e76\\u5f3a\\u5316\\u5176\\u8ffd\\u67e5\\u88ad\\u51fb\\u8005\\u7684\\u5185\\u5728\\u52a8\\u529b\\u3002", "\\u7070\\u80e1\\u5b50\\u6cbb\\u5b89\\u5b98": "\\u5bf9\\u6cbb\\u5b89\\u5b98\\u7981\\u6b62\\u81ea\\u5df1\\u524d\\u5f80\\u8d27\\u573a\\u7684\\u51b3\\u5b9a\\u611f\\u5230\\u4e0d\\u6ee1\\uff0c\\u4f46\\u6ca1\\u6709\\u516c\\u5f00\\u5bf9\\u6297\\uff0c\\u5f62\\u6210\\u7d27\\u5f20\\u800c\\u514b\\u5236\\u7684\\u5408\\u4f5c\\u5173\\u7cfb\\u3002"}}]	[{"location": "\\u57ce\\u897f\\u6cbb\\u5b89\\u7ba1\\u7406\\u6240\\u4e34\\u65f6\\u4f11\\u606f\\u5ba4", "atmosphere": "\\u6f6e\\u6e7f\\u3001\\u75b2\\u60eb\\u3001\\u5c01\\u95ed\\uff0c\\u5939\\u6742\\u83b1\\u5c14\\u514b\\u5236\\u7684\\u51b7\\u5e7d\\u9ed8\\u4e0e\\u4e24\\u540d\\u5e78\\u5b58\\u8005\\u7684\\u521b\\u4f24\\u611f", "duration": "\\u7b2c\\u4e00\\u5929\\u6e05\\u6668\\u53ca\\u4e24\\u65e5\\u5185\\u591a\\u6b21\\u505c\\u7559"}, {"location": "\\u6cbb\\u5b89\\u7ba1\\u7406\\u6240\\u95ee\\u8be2\\u5ba4", "atmosphere": "\\u6e29\\u6696\\u5374\\u4e25\\u8083\\uff0c\\u8c03\\u67e5\\u7a0b\\u5e8f\\u7ec6\\u5bc6\\uff0c\\u5b98\\u65b9\\u673a\\u6784\\u5448\\u73b0\\u51fa\\u5fd9\\u788c\\u800c\\u53ef\\u9760\\u7684\\u52a1\\u5b9e\\u611f", "duration": "\\u7b2c\\u4e00\\u5929\\u6570\\u8f6e\\u95ee\\u8be2"}, {"location": "\\u6cbb\\u5b89\\u7ba1\\u7406\\u6240\\u8d70\\u5eca\\u4e0e\\u4f11\\u606f\\u5ba4", "atmosphere": "\\u7535\\u8bdd\\u3001\\u6253\\u5b57\\u673a\\u548c\\u5de1\\u8b66\\u811a\\u6b65\\u5236\\u9020\\u9ad8\\u5f3a\\u5ea6\\u529e\\u6848\\u6c1b\\u56f4\\uff0c\\u5b69\\u5b50\\u54ed\\u58f0\\u4e0e\\u9057\\u7269\\u51fa\\u73b0\\u5219\\u52a0\\u91cd\\u538b\\u6291\\u54c0\\u4f24", "duration": "\\u7b2c\\u4e00\\u65e5\\u81f3\\u7b2c\\u4e8c\\u5929"}]	slow_to_moderate	8.9	8.7	8.9	9.2	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.9/10\n  节奏把控: 8.7/10\n  吸引力: 8.9/10\n  连贯性: 9.2/10\n\n【剧情阶段】调查发展\n\n【钩子分析】共6个\n  • [悬念] 警方发现一辆没有登记车牌的马车，其破损车轮留下独特断纹，可能是袭击者运送人员或撤离现场的关键载具。... (强度:8)\n  • [认知] 治安所明确排除莱尔与克劳的嫌疑，并认真复核二人提供的证据，打破了读者对官方机构敷衍、敌对或腐败的惯性... (强度:7)\n  • [悬念] 现场墙灰被作为特殊证物封存，案件因此进入异常管理局的管辖范围，暗示孤儿院袭击涉及超自然力量或异常物质... (强度:9)\n\n【伏笔分析】埋下4个, 回收2个\n\n【冲突分析】\n  类型: 人与人, 人与己, 人与社会, 人与环境\n  强度: 8/10\n  进度: 25%\n\n【改进建议】\n  1. 【结尾钩子强化】念珠收尾的情感力量很强，但悬念推进略弱；可在治安官郑重承诺后补入一个极短的异常细节，例如某颗木珠存在不应被火焰留下的切痕或残留反应，使情感钩子与下一章异常管理局介入形成更直接的衔接。	["\\u3010\\u7ed3\\u5c3e\\u94a9\\u5b50\\u5f3a\\u5316\\u3011\\u5ff5\\u73e0\\u6536\\u5c3e\\u7684\\u60c5\\u611f\\u529b\\u91cf\\u5f88\\u5f3a\\uff0c\\u4f46\\u60ac\\u5ff5\\u63a8\\u8fdb\\u7565\\u5f31\\uff1b\\u53ef\\u5728\\u6cbb\\u5b89\\u5b98\\u90d1\\u91cd\\u627f\\u8bfa\\u540e\\u8865\\u5165\\u4e00\\u4e2a\\u6781\\u77ed\\u7684\\u5f02\\u5e38\\u7ec6\\u8282\\uff0c\\u4f8b\\u5982\\u67d0\\u9897\\u6728\\u73e0\\u5b58\\u5728\\u4e0d\\u5e94\\u88ab\\u706b\\u7130\\u7559\\u4e0b\\u7684\\u5207\\u75d5\\u6216\\u6b8b\\u7559\\u53cd\\u5e94\\uff0c\\u4f7f\\u60c5\\u611f\\u94a9\\u5b50\\u4e0e\\u4e0b\\u4e00\\u7ae0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u4ecb\\u5165\\u5f62\\u6210\\u66f4\\u76f4\\u63a5\\u7684\\u8854\\u63a5\\u3002"]	\N	0.43	0.36	2026-08-06 22:18:27.616981
0f5e9f7d-9904-4c0b-8a5a-611874cb82a4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	新案件展开	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a", "\\u4eba\\u4e0e\\u73af\\u5883"]	疑惧逐步升级	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u585e\\u897f\\u8389\\u76ee\\u51fb\\u5230\\u4e00\\u4e2a\\u8eab\\u5f62\\u5f02\\u5e38\\u77ee\\u5c0f\\u3001\\u5728\\u77f3\\u677f\\u8def\\u4e0a\\u79fb\\u52a8\\u5374\\u5b8c\\u5168\\u6ca1\\u6709\\u811a\\u6b65\\u58f0\\u7684\\u9ed1\\u5f71\\u8ddf\\u8e2a\\u739b\\u8482\\u5c14\\u8fbe\\uff0c\\u76f4\\u63a5\\u5efa\\u7acb\\u672c\\u6848\\u7684\\u8d85\\u81ea\\u7136\\u6838\\u5fc3\\u8c1c\\u56e2\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u6bd4\\u6b63\\u5e38\\u4eba\\u77ee\\u4e00\\u622a\\u3002\\u8d70\\u8def\\u6ca1\\u58f0\\u97f3"}, {"type": "\\u8ba4\\u77e5", "content": "\\u739b\\u8482\\u5c14\\u8fbe\\u6ca1\\u6709\\u5931\\u8e2a\\u6216\\u53d7\\u4f24\\uff0c\\u5374\\u5728\\u8282\\u594f\\u3001\\u52a8\\u4f5c\\u548c\\u53cd\\u5e94\\u4e0a\\u51fa\\u73b0\\u7a33\\u5b9a\\u800c\\u7ec6\\u5fae\\u7684\\u53d8\\u5316\\uff0c\\u585e\\u897f\\u8389\\u751a\\u81f3\\u4ea7\\u751f\\u4e86\\u5979\\u88ab\\u5176\\u4ed6\\u5b58\\u5728\\u64cd\\u7eb5\\u6216\\u66ff\\u6362\\u7684\\u76f4\\u89c9\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u50cf\\u6362\\u4e86\\u4e2a\\u4eba\\u5728\\u7528\\u5979\\u7684\\u624b"}, {"type": "\\u8ba4\\u77e5", "content": "\\u83b1\\u5c14\\u89e3\\u91ca\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u76d1\\u6d4b\\u53ea\\u80fd\\u8861\\u91cf\\u73b0\\u5b9e\\u53d7\\u6270\\u52a8\\u7684\\u5e45\\u5ea6\\uff0c\\u4f4e\\u8bfb\\u6570\\u5e76\\u4e0d\\u80fd\\u6392\\u9664\\u5f02\\u5e38\\u6d3b\\u52a8\\uff0c\\u4fee\\u6b63\\u4e86\\u5ba2\\u6237\\u548c\\u8bfb\\u8005\\u5bf9\\u5b98\\u65b9\\u76d1\\u6d4b\\u673a\\u5236\\u7684\\u7406\\u89e3\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u4e0d\\u4ee3\\u8868\\u6ca1\\u4eba\\u62ff\\u7740\\u94f2\\u5b50"}, {"type": "\\u51b2\\u7a81", "content": "\\u585e\\u897f\\u8389\\u9700\\u8981\\u5728\\u4fdd\\u62a4\\u961f\\u53cb\\u548c\\u5c0a\\u91cd\\u739b\\u8482\\u5c14\\u8fbe\\u4e2a\\u4eba\\u610f\\u613f\\u4e4b\\u95f4\\u4f5c\\u51fa\\u9009\\u62e9\\uff0c\\u5e76\\u5728\\u8bc1\\u636e\\u4e0d\\u8db3\\u7684\\u60c5\\u51b5\\u4e0b\\u79d8\\u5bc6\\u5bfb\\u6c42\\u8c03\\u67e5\\u3002", "strength": 7, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5979\\u8981\\u662f\\u77e5\\u9053\\uff0c\\u53ef\\u80fd\\u53cd\\u800c\\u4e0d\\u613f\\u610f"}, {"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u63d0\\u51fa\\u901a\\u8fc7\\u50ac\\u7720\\u63d0\\u53d6\\u76ee\\u51fb\\u8bb0\\u5fc6\\uff0c\\u968f\\u540e\\u5374\\u62ff\\u51fa\\u4e00\\u652f\\u6de1\\u84dd\\u8272\\u5410\\u771f\\u5242\\u9488\\u7b52\\uff0c\\u628a\\u8c03\\u67e5\\u65b9\\u6cd5\\u7684\\u4e0d\\u786e\\u5b9a\\u6027\\u4e0e\\u8eab\\u4f53\\u98ce\\u9669\\u63a8\\u5230\\u7ae0\\u672b\\u3002", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u7136\\u540e\\u638f\\u51fa\\u4e00\\u4e2a\\u9488\\u7b52"}]	5	\N	[{"title": "\\u660e\\u661f\\u5ba2\\u6237\\u7684\\u672a\\u8ff0\\u59d4\\u6258", "content": "\\u7b2c6\\u7ae0\\u523b\\u610f\\u9690\\u85cf\\u7684\\u59d4\\u6258\\u5185\\u5bb9\\u5728\\u672c\\u7ae0\\u6b63\\u5f0f\\u516c\\u5f00\\uff1a\\u585e\\u897f\\u8389\\u76ee\\u51fb\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u65e0\\u58f0\\u9ed1\\u5f71\\u8ddf\\u8e2a\\uff0c\\u5e76\\u53d1\\u73b0\\u5979\\u6b64\\u540e\\u51fa\\u73b0\\u8282\\u594f\\u548c\\u53cd\\u5e94\\u5f02\\u5e38\\u3002\\u5979\\u4ece\\u6cbb\\u5b89\\u6240\\u8f6c\\u5411\\u7ba1\\u7406\\u5c40\\u3001\\u6700\\u7ec8\\u62dc\\u8bbf\\u83b1\\u5c14\\u7684\\u5b8c\\u6574\\u52a8\\u673a\\u7531\\u6b64\\u5f97\\u5230\\u89e3\\u91ca\\u3002", "type": "resolved", "strength": 9, "subtlety": 3, "reference_chapter": 6, "reference_foreshadow_id": "6f7d55b6-a4ff-41d2-ad65-1a5fbf0c1d77", "keyword": "\\u90a3\\u8fb9\\u7684\\u4eba\\u5efa\\u8bae\\u6211\\u6765\\u627e\\u60a8", "category": "event", "is_long_term": false, "related_characters": ["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"], "estimated_resolve_chapter": 7}, {"title": "\\u96f6\\u7c92\\u5b50\\u5f02\\u5e38\\u6848\\u4ef6", "content": "\\u7b2c6\\u7ae0\\u63d0\\u51fa\\u7684\\u4f4e\\u8bfb\\u6570\\u4e43\\u81f3\\u96f6\\u8bfb\\u6570\\u5f02\\u5e38\\u6848\\u4ef6\\u5728\\u672c\\u7ae0\\u5f97\\u5230\\u673a\\u5236\\u5c42\\u9762\\u7684\\u89e3\\u91ca\\uff1a\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u76d1\\u6d4b\\u53cd\\u6620\\u7684\\u662f\\u73b0\\u5b9e\\u88ab\\u6405\\u52a8\\u7684\\u7a0b\\u5ea6\\uff0c\\u5fae\\u5f31\\u5f02\\u80fd\\u3001\\u5f02\\u5e38\\u5668\\u7269\\u6216\\u5c4f\\u853d\\u624b\\u6bb5\\u53ef\\u80fd\\u88ab\\u4eea\\u5668\\u89c6\\u4e3a\\u80cc\\u666f\\u566a\\u97f3\\u3002\\u8be5\\u89e3\\u91ca\\u786e\\u7acb\\u4e86\\u83b1\\u5c14\\u80fd\\u591f\\u4ecb\\u5165\\u5b98\\u65b9\\u5236\\u5ea6\\u76f2\\u533a\\u7684\\u5408\\u7406\\u6027\\u3002", "type": "resolved", "strength": 8, "subtlety": 4, "reference_chapter": 6, "reference_foreshadow_id": "921688e9-2e5d-4f40-9c5b-f4bfea3908b1", "keyword": "\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u6d53\\u5ea6\\u6ca1\\u8fc7\\u8b66\\u6212\\u7ebf", "category": "mystery", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af"], "estimated_resolve_chapter": 7}, {"title": "\\u739b\\u8482\\u5c14\\u8fbe\\u7591\\u4f3c\\u906d\\u5230\\u66ff\\u6362", "content": "\\u585e\\u897f\\u8389\\u4ee5\\u5408\\u4f5c\\u516d\\u5e74\\u7684\\u7ecf\\u9a8c\\u5224\\u65ad\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u52a8\\u4f5c\\u3001\\u53cd\\u5e94\\u548c\\u773c\\u795e\\u5747\\u53d1\\u751f\\u53d8\\u5316\\uff0c\\u5e76\\u5f62\\u5bb9\\u5176\\u50cf\\u88ab\\u53e6\\u4e00\\u4e2a\\u4eba\\u4f7f\\u7528\\u8eab\\u4f53\\u3002\\u8fd9\\u53ef\\u80fd\\u6307\\u5411\\u9644\\u8eab\\u3001\\u610f\\u8bc6\\u66ff\\u6362\\u3001\\u7cbe\\u795e\\u63a7\\u5236\\u6216\\u5236\\u9020\\u66ff\\u8eab\\uff0c\\u662f\\u672c\\u6848\\u6700\\u5371\\u9669\\u7684\\u53ef\\u80fd\\u6027\\u3002", "type": "planted", "strength": 9, "subtlety": 3, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u50cf\\u6362\\u4e86\\u4e2a\\u4eba\\u5728\\u7528\\u5979\\u7684\\u624b", "category": "identity", "is_long_term": false, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"], "estimated_resolve_chapter": 10}, {"title": "\\u50ac\\u7720\\u8bb0\\u5fc6\\u4e2d\\u7684\\u5f71\\u5b50\\u7ec6\\u8282", "content": "\\u83b1\\u5c14\\u8ba4\\u4e3a\\u585e\\u897f\\u8389\\u7684\\u610f\\u8bc6\\u867d\\u7136\\u6ca1\\u8bb0\\u4f4f\\u5f71\\u5b50\\u7ec6\\u8282\\uff0c\\u89c6\\u89c9\\u8bb0\\u5fc6\\u5374\\u4ecd\\u6709\\u6b8b\\u7559\\uff0c\\u51c6\\u5907\\u901a\\u8fc7\\u50ac\\u7720\\u5b8c\\u6210\\u4fa7\\u5199\\u3002\\u4e0b\\u4e00\\u9636\\u6bb5\\u8c03\\u67e5\\u5c06\\u56f4\\u7ed5\\u88ab\\u538b\\u5728\\u6df1\\u5c42\\u8bb0\\u5fc6\\u4e2d\\u7684\\u8eab\\u9ad8\\u3001\\u8f6e\\u5ed3\\u3001\\u79fb\\u52a8\\u65b9\\u5f0f\\u6216\\u8eab\\u4efd\\u6807\\u5fd7\\u5c55\\u5f00\\u3002", "type": "planted", "strength": 8, "subtlety": 3, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u50ac\\u7720\\u80fd\\u628a\\u90a3\\u6bb5\\u8bb0\\u5fc6\\u7ffb\\u51fa\\u6765", "category": "ability", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"], "estimated_resolve_chapter": 8}, {"title": "\\u7ea2\\u96ea\\u5410\\u771f\\u5242\\u7684\\u5b9e\\u9645\\u6548\\u679c", "content": "\\u6de1\\u84dd\\u8272\\u5410\\u771f\\u5242\\u4ee5\\u5f3a\\u70c8\\u89c6\\u89c9\\u7b26\\u53f7\\u6536\\u675f\\u7ae0\\u8282\\u3002\\u83b1\\u5c14\\u58f0\\u79f0\\u4f4e\\u5242\\u91cf\\u53ea\\u4f1a\\u5e2e\\u52a9\\u653e\\u677e\\u5e76\\u63d0\\u53d6\\u8bb0\\u5fc6\\uff0c\\u4f46\\u585e\\u897f\\u8389\\u4e0e\\u54c8\\u91cc\\u7279\\u7684\\u6050\\u60e7\\u4ee5\\u53ca\\u5bf9\\u5408\\u6cd5\\u6027\\u7684\\u8d28\\u7591\\uff0c\\u9884\\u793a\\u836f\\u7269\\u7684\\u771f\\u5b9e\\u6548\\u679c\\u3001\\u4f7f\\u7528\\u98ce\\u9669\\u548c\\u83b1\\u5c14\\u7684\\u64cd\\u4f5c\\u8fb9\\u754c\\u5c06\\u5728\\u4e0b\\u4e00\\u7ae0\\u63a5\\u53d7\\u9a8c\\u8bc1\\u3002", "type": "planted", "strength": 8, "subtlety": 4, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u91cc\\u5934\\u4e00\\u7ba1\\u6de1\\u84dd\\u6db2\\u4f53\\uff0c\\u9488\\u5c16\\u5728\\u7a97\\u5149\\u4e0b\\u95ea\\u4e86\\u4e00\\u4e0b", "category": "item", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u54c8\\u91cc\\u7279"], "estimated_resolve_chapter": 8}]	3	2	[{"content": "\\u585e\\u897f\\u8389\\u516c\\u5f00\\u516d\\u6708\\u4e09\\u65e5\\u7684\\u76ee\\u51fb\\u7ecf\\u8fc7\\uff0c\\u8bf4\\u660e\\u739b\\u8482\\u5c14\\u8fbe\\u66fe\\u88ab\\u4e00\\u4e2a\\u77ee\\u5c0f\\u3001\\u65e0\\u58f0\\u7684\\u9ed1\\u5f71\\u5c3e\\u968f\\u3002", "type": "revelation", "importance": 0.95, "impact": "\\u6b63\\u5f0f\\u63ed\\u793a\\u660e\\u661f\\u5ba2\\u6237\\u7684\\u59d4\\u6258\\u5185\\u5bb9\\uff0c\\u542f\\u52a8\\u672c\\u7ae0\\u7684\\u65b0\\u6848\\u4ef6\\u4e3b\\u7ebf\\u3002", "keyword": "\\u53ea\\u770b\\u89c1\\u4e00\\u4e2a\\u5f71\\u5b50\\u8fdc\\u8fdc\\u8ddf\\u5728\\u5979\\u540e\\u9762"}, {"content": "\\u739b\\u8482\\u5c14\\u8fbe\\u5728\\u4e8b\\u4ef6\\u540e\\u51fa\\u73b0\\u56fa\\u5b9a\\u6162\\u62cd\\u3001\\u52a8\\u4f5c\\u8fdf\\u949d\\u548c\\u53cd\\u5e94\\u5ef6\\u8fdf\\uff0c\\u6848\\u4ef6\\u7531\\u5355\\u7eaf\\u8ddf\\u8e2a\\u5347\\u7ea7\\u4e3a\\u7591\\u4f3c\\u5f02\\u5e38\\u4fb5\\u5bb3\\u3002", "type": "revelation", "importance": 0.98, "impact": "\\u5c06\\u8c03\\u67e5\\u76ee\\u6807\\u4ece\\u5bfb\\u627e\\u8ddf\\u8e2a\\u8005\\u6269\\u5c55\\u5230\\u786e\\u8ba4\\u739b\\u8482\\u5c14\\u8fbe\\u662f\\u5426\\u906d\\u5230\\u9644\\u8eab\\u3001\\u66ff\\u6362\\u6216\\u63a7\\u5236\\u3002", "keyword": "\\u5979\\u6574\\u4e2a\\u4eba\\uff0c\\u52a8\\u4f5c\\u6bd4\\u4ee5\\u524d\\u949d"}, {"content": "\\u83b1\\u5c14\\u89e3\\u91ca\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u8bfb\\u6570\\u7684\\u5c40\\u9650\\uff0c\\u6307\\u51fa\\u4f4e\\u4e8e\\u8b66\\u6212\\u7ebf\\u4e0d\\u7b49\\u4e8e\\u4e0d\\u5b58\\u5728\\u5f02\\u5e38\\u3002", "type": "revelation", "importance": 0.85, "impact": "\\u8865\\u5168\\u4e16\\u754c\\u89c2\\u89c4\\u5219\\uff0c\\u5408\\u7406\\u5316\\u7ba1\\u7406\\u5c40\\u4e0d\\u53d7\\u7406\\u4e0e\\u83b1\\u5c14\\u4ecb\\u5165\\u4e4b\\u95f4\\u7684\\u5236\\u5ea6\\u903b\\u8f91\\u3002", "keyword": "\\u4e0d\\u4ee3\\u8868\\u6ca1\\u4eba\\u62ff\\u7740\\u94f2\\u5b50"}, {"content": "\\u83b1\\u5c14\\u51b3\\u5b9a\\u901a\\u8fc7\\u50ac\\u7720\\u7ffb\\u51fa\\u585e\\u897f\\u8389\\u7684\\u6df1\\u5c42\\u89c6\\u89c9\\u8bb0\\u5fc6\\uff0c\\u4ee5\\u4fa7\\u5199\\u9ed1\\u5f71\\u7684\\u771f\\u5b9e\\u5916\\u5f62\\u3002", "type": "transition", "importance": 0.9, "impact": "\\u628a\\u6848\\u4ef6\\u4ece\\u53e3\\u8ff0\\u8be2\\u95ee\\u63a8\\u8fdb\\u5230\\u4e3b\\u52a8\\u53d6\\u8bc1\\u9636\\u6bb5\\uff0c\\u5e76\\u4e3a\\u4e0b\\u4e00\\u7ae0\\u7684\\u8bb0\\u5fc6\\u573a\\u666f\\u505a\\u51c6\\u5907\\u3002", "keyword": "\\u6211\\u9700\\u8981\\u4f60\\u5e2e\\u6211\\u770b\\u6e05\\u90a3\\u4e2a\\u5f71\\u5b50"}, {"content": "\\u83b1\\u5c14\\u62ff\\u51fa\\u7ea2\\u96ea\\u751f\\u4ea7\\u7684\\u6de1\\u84dd\\u8272\\u5410\\u771f\\u5242\\uff0c\\u585e\\u897f\\u8389\\u4e0e\\u54c8\\u91cc\\u7279\\u56e0\\u5176\\u5371\\u9669\\u5370\\u8c61\\u9677\\u5165\\u60ca\\u60e7\\u3002", "type": "conflict", "importance": 0.92, "impact": "\\u5236\\u9020\\u7ae0\\u672b\\u5f3a\\u94a9\\u5b50\\uff0c\\u540c\\u65f6\\u5f15\\u51fa\\u8c03\\u67e5\\u624b\\u6bb5\\u7684\\u4f26\\u7406\\u3001\\u5408\\u6cd5\\u6027\\u548c\\u5b89\\u5168\\u98ce\\u9669\\u3002", "keyword": "\\u7ea2\\u96ea\\u51fa\\u7684\\u5410\\u771f\\u5242"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u4ece\\u5bb9\\u63a5\\u5f85\\u7279\\u6b8a\\u5ba2\\u6237\\uff0c\\u5c1a\\u672a\\u638c\\u63e1\\u59d4\\u6258\\u7684\\u5177\\u4f53\\u5185\\u5bb9", "state_after": "\\u521d\\u6b65\\u5224\\u65ad\\u6848\\u4ef6\\u53ef\\u80fd\\u6d89\\u53ca\\u4f4e\\u6270\\u52a8\\u5f02\\u5e38\\uff0c\\u5e76\\u51b3\\u5b9a\\u901a\\u8fc7\\u836f\\u7269\\u8f85\\u52a9\\u50ac\\u7720\\u63d0\\u53d6\\u76ee\\u51fb\\u8bb0\\u5fc6", "psychological_change": "\\u83b1\\u5c14\\u4ece\\u5e38\\u89c4\\u95ee\\u8be2\\u8fc5\\u901f\\u8f6c\\u5165\\u4e13\\u4e1a\\u5224\\u65ad\\u3002\\u4ed6\\u6ce8\\u610f\\u5230\\u65e0\\u58f0\\u9ed1\\u5f71\\u3001\\u7a33\\u5b9a\\u6162\\u62cd\\u548c\\u53cd\\u5e94\\u8fdf\\u6ede\\u4e4b\\u95f4\\u7684\\u5173\\u8054\\uff0c\\u5374\\u6ca1\\u6709\\u8fc7\\u65e9\\u4e0b\\u7ed3\\u8bba\\uff0c\\u800c\\u662f\\u5148\\u89e3\\u91ca\\u76d1\\u6d4b\\u673a\\u5236\\uff0c\\u518d\\u63d0\\u51fa\\u53ef\\u9a8c\\u8bc1\\u7684\\u8c03\\u67e5\\u624b\\u6bb5\\uff0c\\u4f53\\u73b0\\u5176\\u51b7\\u9759\\u3001\\u52a1\\u5b9e\\u53ca\\u6e38\\u8d70\\u89c4\\u5219\\u8fb9\\u7f18\\u7684\\u529e\\u6848\\u98ce\\u683c\\u3002", "key_event": "\\u542c\\u5b8c\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u5f02\\u5e38\\u8868\\u73b0\\u540e\\u51b3\\u5b9a\\u5bf9\\u585e\\u897f\\u8389\\u5b9e\\u65bd\\u50ac\\u7720\\u4fa7\\u5199", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4ece\\u6f5c\\u5728\\u59d4\\u6258\\u5173\\u7cfb\\u53d1\\u5c55\\u4e3a\\u521d\\u6b65\\u5408\\u4f5c\\u5173\\u7cfb\\uff0c\\u4f46\\u5410\\u771f\\u5242\\u7684\\u51fa\\u73b0\\u4f7f\\u5979\\u5bf9\\u83b1\\u5c14\\u4ea7\\u751f\\u65b0\\u7684\\u8b66\\u60d5", "\\u54c8\\u91cc\\u7279": "\\u5efa\\u7acb\\u57fa\\u4e8e\\u6848\\u4ef6\\u9700\\u8981\\u7684\\u5408\\u4f5c\\u5173\\u7cfb\\uff0c\\u540c\\u65f6\\u56e0\\u836f\\u7269\\u5408\\u6cd5\\u6027\\u95ee\\u9898\\u5f62\\u6210\\u8f7b\\u5fae\\u7acb\\u573a\\u6469\\u64e6", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u7531\\u964c\\u751f\\u7684\\u6848\\u4ef6\\u76f8\\u5173\\u8005\\u8f6c\\u53d8\\u4e3a\\u9700\\u8981\\u5c3d\\u5feb\\u786e\\u8ba4\\u662f\\u5426\\u906d\\u53d7\\u5f02\\u5e38\\u4fb5\\u5bb3\\u7684\\u8c03\\u67e5\\u5bf9\\u8c61"}}, {"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": null, "state_before": "\\u4fdd\\u6301\\u51b7\\u9759\\u4e0e\\u6212\\u5907\\uff0c\\u5e0c\\u671b\\u5224\\u65ad\\u83b1\\u5c14\\u662f\\u5426\\u503c\\u5f97\\u59d4\\u6258", "state_after": "\\u8ba4\\u53ef\\u6848\\u4ef6\\u53ef\\u80fd\\u65e0\\u6cd5\\u7531\\u5b98\\u65b9\\u8bfb\\u6570\\u6392\\u9664\\uff0c\\u613f\\u610f\\u63a5\\u53d7\\u50ac\\u7720\\uff0c\\u4f46\\u5bf9\\u6ce8\\u5c04\\u5410\\u771f\\u5242\\u4ea7\\u751f\\u660e\\u663e\\u6050\\u60e7", "psychological_change": "\\u5979\\u4ece\\u8c28\\u614e\\u9648\\u8ff0\\u76ee\\u51fb\\u7ecf\\u8fc7\\uff0c\\u9010\\u6e10\\u66b4\\u9732\\u5bf9\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u6df1\\u5ea6\\u62c5\\u5fe7\\u3002\\u5979\\u80fd\\u591f\\u51ed\\u516d\\u5e74\\u5408\\u4f5c\\u7ecf\\u9a8c\\u8bc6\\u522b\\u6781\\u7ec6\\u5fae\\u7684\\u8282\\u594f\\u548c\\u52a8\\u4f5c\\u504f\\u5dee\\uff0c\\u8bf4\\u660e\\u5979\\u7684\\u6c42\\u52a9\\u5e76\\u975e\\u540d\\u4eba\\u5f0f\\u654f\\u611f\\uff0c\\u800c\\u662f\\u5efa\\u7acb\\u5728\\u4e13\\u4e1a\\u89c2\\u5bdf\\u4e0a\\u3002\\u6700\\u7ec8\\u540c\\u610f\\u50ac\\u7720\\uff0c\\u8868\\u660e\\u4fdd\\u62a4\\u961f\\u53cb\\u7684\\u8d23\\u4efb\\u611f\\u6682\\u65f6\\u538b\\u8fc7\\u4e86\\u5bf9\\u672a\\u77e5\\u624b\\u6bb5\\u7684\\u6212\\u5fc3\\u3002", "key_event": "\\u5728\\u54c8\\u91cc\\u7279\\u70b9\\u5934\\u540e\\u540c\\u610f\\u63a5\\u53d7\\u50ac\\u7720\\u8c03\\u67e5", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u5ba1\\u89c6\\u5176\\u80fd\\u529b\\u8f6c\\u4e3a\\u6709\\u9650\\u4fe1\\u4efb\\u548c\\u6b63\\u5f0f\\u914d\\u5408\\uff0c\\u968f\\u540e\\u56e0\\u5410\\u771f\\u5242\\u518d\\u6b21\\u63d0\\u9ad8\\u6212\\u5907", "\\u54c8\\u91cc\\u7279": "\\u7ee7\\u7eed\\u4f9d\\u8d56\\u54c8\\u91cc\\u7279\\u7684\\u5224\\u65ad\\u4e0e\\u966a\\u540c\\uff0c\\u53cc\\u65b9\\u5448\\u73b0\\u7a33\\u5b9a\\u7684\\u4fe1\\u4efb\\u548c\\u4fdd\\u62a4\\u5173\\u7cfb", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u7531\\u666e\\u901a\\u957f\\u671f\\u961f\\u53cb\\u8f6c\\u53d8\\u4e3a\\u5979\\u5fc5\\u987b\\u79d8\\u5bc6\\u4fdd\\u62a4\\u548c\\u8c03\\u67e5\\u7684\\u5bf9\\u8c61\\uff0c\\u8d23\\u4efb\\u611f\\u660e\\u663e\\u589e\\u5f3a"}}, {"character_name": "\\u54c8\\u91cc\\u7279", "survival_status": null, "state_before": "\\u4f5c\\u4e3a\\u7ecf\\u7eaa\\u4eba\\u966a\\u540c\\u585e\\u897f\\u8389\\uff0c\\u4fdd\\u6301\\u89c2\\u5bdf\\u548c\\u98ce\\u9669\\u63a7\\u5236\\u59ff\\u6001", "state_after": "\\u652f\\u6301\\u585e\\u897f\\u8389\\u63a5\\u53d7\\u8bb0\\u5fc6\\u8c03\\u67e5\\uff0c\\u4f46\\u5728\\u83b1\\u5c14\\u62ff\\u51fa\\u5410\\u771f\\u5242\\u540e\\u7acb\\u523b\\u8d28\\u7591\\u5176\\u5408\\u6cd5\\u6027\\u4e0e\\u5b89\\u5168\\u6027", "psychological_change": "\\u54c8\\u91cc\\u7279\\u524d\\u534a\\u6bb5\\u4e3b\\u8981\\u627f\\u62c5\\u4fe1\\u606f\\u8865\\u5145\\u548c\\u89c1\\u8bc1\\u8005\\u89d2\\u8272\\uff0c\\u9762\\u5bf9\\u50ac\\u7720\\u63d0\\u8bae\\u65f6\\u7ecf\\u8fc7\\u6743\\u8861\\u540e\\u540c\\u610f\\uff1b\\u9488\\u7b52\\u51fa\\u73b0\\u540e\\uff0c\\u5979\\u8fc5\\u901f\\u4ece\\u65c1\\u89c2\\u8005\\u5207\\u6362\\u4e3a\\u4fdd\\u62a4\\u8005\\uff0c\\u8868\\u660e\\u5979\\u7684\\u9996\\u8981\\u7acb\\u573a\\u4e0d\\u662f\\u63a8\\u52a8\\u6848\\u4ef6\\uff0c\\u800c\\u662f\\u4fdd\\u969c\\u585e\\u897f\\u8389\\u7684\\u4eba\\u8eab\\u4e0e\\u804c\\u4e1a\\u5b89\\u5168\\u3002", "key_event": "\\u4e3b\\u52a8\\u8be2\\u95ee\\u5410\\u771f\\u5242\\u662f\\u5426\\u5408\\u6cd5", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4fdd\\u62a4\\u4e0e\\u76d1\\u7763\\u804c\\u8d23\\u5f97\\u5230\\u5f3a\\u5316", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u7531\\u4e2d\\u6027\\u5408\\u4f5c\\u8f6c\\u4e3a\\u8c28\\u614e\\u76d1\\u7763\\uff0c\\u8981\\u6c42\\u5176\\u8bf4\\u660e\\u624b\\u6bb5\\u7684\\u5408\\u6cd5\\u6027"}}, {"character_name": "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "survival_status": null, "state_before": "\\u5728\\u516d\\u6708\\u4e09\\u65e5\\u6392\\u7ec3\\u7ed3\\u675f\\u540e\\u72ec\\u81ea\\u56de\\u5bb6\\uff0c\\u81ea\\u79f0\\u6ca1\\u6709\\u906d\\u9047\\u4efb\\u4f55\\u4e8b\\u60c5", "state_after": "\\u88ab\\u585e\\u897f\\u8389\\u6000\\u7591\\u51fa\\u73b0\\u7a33\\u5b9a\\u7684\\u52a8\\u4f5c\\u8fdf\\u6ede\\u3001\\u8282\\u594f\\u504f\\u5dee\\u548c\\u4eba\\u683c\\u5f02\\u6837\\uff0c\\u6210\\u4e3a\\u5f02\\u5e38\\u6848\\u4ef6\\u7684\\u6838\\u5fc3\\u5bf9\\u8c61", "psychological_change": "\\u672c\\u4eba\\u672a\\u76f4\\u63a5\\u51fa\\u573a\\uff0c\\u65e0\\u6cd5\\u786e\\u8ba4\\u5176\\u4e3b\\u89c2\\u5fc3\\u7406\\u53d8\\u5316\\uff1b\\u4ece\\u5916\\u90e8\\u89c2\\u5bdf\\u770b\\uff0c\\u5979\\u4f3c\\u4e4e\\u5bf9\\u81ea\\u8eab\\u5f02\\u5e38\\u7f3a\\u4e4f\\u8ba4\\u77e5\\u6216\\u523b\\u610f\\u5426\\u8ba4\\uff0c\\u5e76\\u53ef\\u80fd\\u53d7\\u5230\\u67d0\\u79cd\\u610f\\u8bc6\\u3001\\u8eab\\u4f53\\u6216\\u8eab\\u4efd\\u5c42\\u9762\\u7684\\u5e72\\u6270\\u3002", "key_event": "\\u906d\\u65e0\\u58f0\\u9ed1\\u5f71\\u5c3e\\u968f\\u540e\\u51fa\\u73b0\\u6301\\u7eed\\u6027\\u7684\\u884c\\u4e3a\\u4e0e\\u6f14\\u594f\\u5f02\\u5e38", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4ece\\u5408\\u4f5c\\u516d\\u5e74\\u7684\\u961f\\u53cb\\u8f6c\\u4e3a\\u88ab\\u5176\\u79d8\\u5bc6\\u62c5\\u5fe7\\u548c\\u4fdd\\u62a4\\u7684\\u5bf9\\u8c61", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6210\\u4e3a\\u83b1\\u5c14\\u51c6\\u5907\\u8c03\\u67e5\\u7684\\u6f5c\\u5728\\u53d7\\u5bb3\\u8005\\u6216\\u5f02\\u5e38\\u8f7d\\u4f53"}}]	[{"location": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a\\u7684\\u4fa6\\u63a2\\u4e8b\\u52a1\\u6240\\u529e\\u516c\\u5ba4", "atmosphere": "\\u6668\\u5149\\u4e0b\\u8868\\u9762\\u5e73\\u9759\\uff0c\\u968f\\u7740\\u65e0\\u58f0\\u9ed1\\u5f71\\u3001\\u4eba\\u683c\\u5f02\\u53d8\\u548c\\u5410\\u771f\\u5242\\u9010\\u6b65\\u8f6c\\u4e3a\\u8be1\\u5f02\\u7d27\\u5f20", "duration": "\\u7ea6\\u4e8c\\u5341\\u81f3\\u4e09\\u5341\\u5206\\u949f\\u7684\\u59d4\\u6258\\u95ee\\u8be2"}]	由慢到快	8.8	8.6	9	8.9	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.8/10\n  节奏把控: 8.6/10\n  吸引力: 9.0/10\n  连贯性: 8.9/10\n\n【剧情阶段】新案件展开\n\n【钩子分析】共5个\n  • [悬念] 塞西莉目击到一个身形异常矮小、在石板路上移动却完全没有脚步声的黑影跟踪玛蒂尔达，直接建立本案的超自然... (强度:9)\n  • [认知] 玛蒂尔达没有失踪或受伤，却在节奏、动作和反应上出现稳定而细微的变化，塞西莉甚至产生了她被其他存在操纵... (强度:9)\n  • [认知] 莱尔解释凯莉米粒子监测只能衡量现实受扰动的幅度，低读数并不能排除异常活动，修正了客户和读者对官方监测... (强度:8)\n\n【伏笔分析】埋下6个, 回收3个\n\n【冲突分析】\n  类型: 人与人, 人与己, 人与社会, 人与环境\n  强度: 8/10\n  进度: 18%\n\n【改进建议】\n  1. 【伏笔关联】货场鞋印与本章无声黑影之间目前只有"异常移动方式"这一弱呼应；若两案确属同一势力，后续可补充相同鞋型、特殊鞋钉或潜行装备等可验证特征，避免读者将两条线索视为互不相关的独立案件。	["\\u3010\\u4f0f\\u7b14\\u5173\\u8054\\u3011\\u8d27\\u573a\\u978b\\u5370\\u4e0e\\u672c\\u7ae0\\u65e0\\u58f0\\u9ed1\\u5f71\\u4e4b\\u95f4\\u76ee\\u524d\\u53ea\\u6709\\"\\u5f02\\u5e38\\u79fb\\u52a8\\u65b9\\u5f0f\\"\\u8fd9\\u4e00\\u5f31\\u547c\\u5e94\\uff1b\\u82e5\\u4e24\\u6848\\u786e\\u5c5e\\u540c\\u4e00\\u52bf\\u529b\\uff0c\\u540e\\u7eed\\u53ef\\u8865\\u5145\\u76f8\\u540c\\u978b\\u578b\\u3001\\u7279\\u6b8a\\u978b\\u9489\\u6216\\u6f5c\\u884c\\u88c5\\u5907\\u7b49\\u53ef\\u9a8c\\u8bc1\\u7279\\u5f81\\uff0c\\u907f\\u514d\\u8bfb\\u8005\\u5c06\\u4e24\\u6761\\u7ebf\\u7d22\\u89c6\\u4e3a\\u4e92\\u4e0d\\u76f8\\u5173\\u7684\\u72ec\\u7acb\\u6848\\u4ef6\\u3002"]	\N	0.68	0.2	2026-08-07 00:36:35.079395
cd65c129-d0de-4535-843e-1ecc4130df74	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	紧绷对抗	0.85	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u51b3\\u5b9a\\u6682\\u7f13\\u6293\\u6355\\u3001\\u8d76\\u5728\\u4e5d\\u70b9\\u524d\\u8ba9\\u59d4\\u5458\\u4f1a\\"\\u770b\\u6728\\u5076\\"\\u2014\\u2014\\u4ed6\\u5982\\u4f55\\u7528\\u5df2\\u88ab\\u6263\\u62bc\\u7684\\u7269\\u8bc1\\u8bf4\\u670d\\u59d4\\u5458\\u4f1a\\u4e0d\\u4e2d\\u6b62\\u6f14\\u51fa\\uff1f", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u8d76\\u5728\\u4e5d\\u70b9\\u524d\\uff0c\\u6559\\u59d4\\u5458\\u4f1a\\u770b\\u6728\\u5076"}, {"type": "\\u60ac\\u5ff5", "content": "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069\\u62a2\\u5148\\u4e00\\u6b65\\u63d0\\u4ea4\\u505c\\u6f14\\u7533\\u8bf7\\uff0c\\u7ba1\\u7406\\u5c40\\u5373\\u4fbf\\u638c\\u63e1\\u72af\\u7f6a\\u8bc1\\u636e\\u4e5f\\u65e0\\u6cd5\\u8bc1\\u660e\\"\\u4e0d\\u5b58\\u5728\\u7684\\u4e1c\\u897f\\u4e0d\\u5b58\\u5728\\"\\uff0c\\u4e3b\\u89d2\\u9677\\u5165\\u5236\\u5ea6\\u6027\\u56f0\\u5883\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e\\u524d\\u6bb5", "keyword": "\\u8587\\u5965\\u62c9\\u6bd4\\u4ed6\\u4eec\\u5148\\u8d70\\u4e86\\u4e00\\u6b65"}, {"type": "\\u60ac\\u5ff5", "content": "\\u5f02\\u8c61\\u4e2d\\u90a3\\u679a\\u523b\\u7740\\u5b57\\u6bcdV\\u7684\\u94f6\\u8272\\u5f26\\u7434\\u5f62\\u9886\\u9488\\u672a\\u88ab\\u4e22\\u8fdb\\u706b\\u76c6\\u2014\\u2014\\u5b83\\u662f\\u771f\\u5b9e\\u8bc1\\u7269\\u8fd8\\u662f\\u672a\\u6765\\u6307\\u8ba4\\u8587\\u5965\\u62c9\\u7684\\u7269\\u8bc1\\uff1f", "strength": 7, "position": "\\u4e2d\\u6bb5", "keyword": "\\u4e00\\u679a\\u94f6\\u8272\\u5f26\\u7434\\u5f62\\u9886\\u9488\\u88ab\\u63a8\\u5230\\u684c\\u8fb9\\u3002\\u7434\\u5f26\\u4e2d\\u592e\\u523b\\u7740\\u5b57\\u6bcdV"}, {"type": "\\u60ac\\u5ff5", "content": "\\u73c0\\u897f\\u74e6\\u5c14\\u80a9\\u8180\\u53d7\\u4f24\\u3001\\"\\u8fd9\\u6b21\\u7528\\u4e86\\u516d\\u7247\\"\\u8d34\\u7247\\u2014\\u2014\\u4e0a\\u4e00\\u7ae0\\u4e0e\\u672c\\u7ae0\\u4e4b\\u95f4\\u4e3b\\u89d2\\u4e00\\u884c\\u7ecf\\u5386\\u4e86\\u4ec0\\u4e48\\u4e0d\\u4e3a\\u4eba\\u77e5\\u7684\\u6fc0\\u70c8\\u51b2\\u7a81\\uff1f", "strength": 5, "position": "\\u5f00\\u5934", "keyword": "\\u4f60\\u4e0a\\u6b21\\u8bf4\\u8d34\\u4e24\\u7247\\u5c31\\u597d\\u3002\\u8fd9\\u6b21\\u7528\\u4e86\\u516d\\u7247\\u3002"}]	4	\N	[{"title": "\\u4f2a\\u9020\\u63a8\\u7406\\u63a9\\u76d6\\u771f\\u5b9e\\u80fd\\u529b", "content": "\\u83b1\\u5c14\\u5728\\u8bc1\\u7269\\u5e93\\"\\u770b\\u89c1\\"\\u6cbe\\u6728\\u5c51\\u7684\\u624b\\u5728\\u8d26\\u7c3f\\u4e0a\\u5199\\u4e0b\\u7f16\\u53f7\\u7684\\u5f02\\u8c61\\uff08\\u706f\\u5149\\u6697\\u4e86\\u4e00\\u4e0b\\uff09\\uff0c\\u968f\\u5373\\u7528\\u4fa7\\u706f\\u4e0e\\u94c5\\u7b14\\u62d3\\u5370\\u538b\\u75d5\\u7684\\u5e38\\u89c4\\u624b\\u6bb5\\u5305\\u88c5\\u4fe1\\u606f\\u7ed3\\u679c\\uff0c\\u5e76\\u7279\\u610f\\u5c06\\u6bc1\\u635f\\u7684\\u5c01\\u76ae\\u788e\\u5c51\\u538b\\u8fdb\\u638c\\u5fc3\\u63a9\\u76d6\\u75d5\\u8ff9\\uff1b\\"\\u8fd9\\u8bdd\\u4e0d\\u5168\\u662f\\u5047\\"\\u518d\\u6b21\\u786e\\u8ba4\\u4ed6\\u60ef\\u7528\\u534a\\u771f\\u8bdd\\u63a9\\u76d6\\u771f\\u5b9e\\u80fd\\u529b\\u6765\\u6e90\\u3002", "type": "resolved", "strength": 8, "subtlety": 8, "reference_chapter": 1, "reference_foreshadow_id": "119b3b6b-1568-4cd1-b64a-7bc4755d74ac", "keyword": "\\u83b1\\u5c14\\u53d6\\u51fa\\u94c5\\u7b14\\uff0c\\u6ca1\\u6709\\u6d82\\u6574\\u5f20\\uff0c\\u53ea\\u6cbf\\u6700\\u6df1\\u7684\\u51e0\\u9053\\u538b\\u75d5\\u63cf\\u7ebf", "category": "ability", "is_long_term": true, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af"], "estimated_resolve_chapter": 13}, {"title": "\\u6728\\u5076\\u4ea7\\u4e1a\\u94fe\\u4e0e\\u57c3\\u8499\\u5546\\u884c", "content": "\\u7ae0\\u8282\\u901a\\u8fc7\\u57c3\\u8499\\u5267\\u5177\\u5546\\u884c\\u7684\\u96f6\\u4ef6\\u7f16\\u53f7\\uff08\\u4e59\\u5341\\u4e03\\u6279\\u6b21\\u3001\\u6d41\\u6c34\\u53f7\\u56db\\u516b\\u4e5d\\u81f3\\u56db\\u4e5d\\u4e09\\uff09\\u4e0e\\u4e94\\u6708\\u4e8c\\u5341\\u516b\\u65e5\\u51fa\\u5e93\\u767b\\u8bb0\\uff0c\\u5b8c\\u6574\\u5750\\u5b9e\\u4e86\\u6728\\u5076\\u96f6\\u90e8\\u4ef6\\u4ece\\u57c3\\u8499\\u5546\\u884c\\u6d41\\u5411\\u94f6\\u5f26\\u6f14\\u827a\\u3001\\u518d\\u7ecf\\u6597\\u7bf7\\u5973\\u4eba\\u4e0e\\u64cd\\u5076\\u5e08\\u7ec4\\u88c5\\u6210\\u739b\\u8482\\u5c14\\u8fbe\\u66ff\\u8eab\\u7684\\u4ea7\\u4e1a\\u94fe\\uff0c\\u5e76\\u8865\\u4e0a\\u4e86\\u7f3a\\u5931\\u7684\\u56db\\u4e5d\\u96f6\\u53f7\\u96f6\\u4ef6\\u88ab\\u5355\\u72ec\\u9001\\u51fa\\u7684\\u9a8c\\u8d27\\u73af\\u8282\\u3002", "type": "resolved", "strength": 8, "subtlety": 6, "reference_chapter": 10, "reference_foreshadow_id": "f0a1accf-903d-4f1e-8e4b-0ba3cbf4dfe1", "keyword": "\\u57c3\\u8499\\u5267\\u5177\\u5546\\u884c\\u7684\\u96f6\\u4ef6\\u7f16\\u53f7\\u3002\\u524d\\u9762\\u662f\\u89c4\\u683c\\uff0c\\u540e\\u9762\\u662f\\u6d41\\u6c34\\u53f7", "category": "event", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069", "\\u6597\\u7bf7\\u5973\\u4eba", "\\u64cd\\u5076\\u5e08"], "estimated_resolve_chapter": 13}]	0	2	[{"content": "\\u901a\\u8fc7\\u8d26\\u7c3f\\u538b\\u75d5\\u4e0e\\u96f6\\u4ef6\\u7f16\\u53f7\\u4ea4\\u53c9\\u6bd4\\u5bf9\\uff0c\\u786e\\u8ba4\\u6728\\u5076\\u6848\\u552f\\u4e00\\u4e70\\u5bb6\\u662f\\u94f6\\u5f26\\u6f14\\u827a\\u7684\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069\\uff0c\\u6597\\u7bf7\\u5973\\u4eba\\u4e0e\\u64cd\\u5076\\u5e08\\"\\u533f\\u540d\\u59d4\\u6258\\"\\u7684\\u8bf4\\u6cd5\\u88ab\\u62c6\\u7a7f", "type": "revelation", "importance": 0.95, "impact": "\\u771f\\u51f6\\u6d6e\\u51fa\\u6c34\\u9762\\uff0c\\u6848\\u4ef6\\u6027\\u8d28\\u4ece\\u8ffd\\u67e5\\u771f\\u51f6\\u8f6c\\u4e3a\\u6b63\\u9762\\u535a\\u5f08", "keyword": "\\u4e59\\u5341\\u4e03\\uff0c\\u56db\\u4e5d\\u96f6\\u3002\\u7070\\u7ebf\\u3002\\u51ef\\u6069\\u3002\\u5148\\u4e09\\u540e\\u4e03"}, {"content": "\\u63ed\\u793a\\u94f6\\u5f26\\u4e0e\\u91d1\\u7b3c\\u7684\\u5408\\u4f5c\\u7f51\\u7edc\\uff1a\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b\\u3001\\u5171\\u7528\\u8d27\\u8fd0\\u4ee3\\u7406\\u3001\\u5531\\u7247\\u5382\\u72ec\\u5bb6\\u5408\\u7ea6\\u2014\\u2014\\u52a8\\u673a\\u662f\\u6324\\u6389\\u9508\\u8537\\u8587\\u62a2\\u4e0b\\u957f\\u671f\\u5408\\u7ea6", "type": "revelation", "importance": 0.8, "impact": "\\u89e3\\u91ca\\u4e86\\u4e24\\u5bb6\\u516c\\u53f8\\u62c5\\u4fdd\\u94fe\\u4e0e\\u8d26\\u52a1\\u7ed5\\u884c\\u7684\\u7531\\u6765\\uff0c\\u91d1\\u7b3c\\u6f14\\u827a\\u7684\\u89d2\\u8272\\u8fdb\\u4e00\\u6b65\\u9ed1\\u5316", "keyword": "\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b\\u4ee5\\u524d\\u5728\\u94f6\\u5f26\\u505a\\u8d26\\u3002\\u4e09\\u5e74\\u524d\\u624d\\u53bb\\u4e86\\u91d1\\u7b3c"}, {"content": "\\u8587\\u5965\\u62c9\\u5047\\u501f\\u516c\\u5171\\u5b89\\u5168\\u540d\\u4e49\\u5411\\u59d4\\u5458\\u4f1a\\u63d0\\u8bf7\\u505c\\u6f14\\uff0c\\u5e76\\u9644\\u4e0a\\u6597\\u7bf7\\u5973\\u4eba\\u7684\\u8bc1\\u8bcd\\uff0c\\u62a2\\u5728\\u7ba1\\u7406\\u5c40\\u884c\\u52a8\\u524d\\u5360\\u636e\\u5236\\u5ea6\\u5148\\u624b", "type": "conflict", "importance": 0.9, "impact": "\\u4e3b\\u89d2\\u906d\\u9047\\u89c4\\u5219\\u56f0\\u5883\\uff1a\\u65e0\\u6cd5\\u8bc1\\u660e\\u4e0d\\u5b58\\u5728\\u7684\\u4e1c\\u897f\\u4e0d\\u5b58\\u5728\\uff0c\\u65f6\\u9650\\u88ab\\u538b\\u7f29\\u5230\\u660e\\u65e9\\u4e5d\\u70b9", "keyword": "\\u7533\\u8bf7\\u6682\\u505c\\u949f\\u697c\\u5267\\u9662\\u516d\\u6708\\u5341\\u4e09\\u65e5\\u6f14\\u51fa"}, {"content": "\\u83b1\\u5c14\\u51b3\\u5b9a\\u6682\\u4e0d\\u6293\\u6355\\uff0c\\u8d76\\u5728\\u4e5d\\u70b9\\u524d\\u7528\\u8bc1\\u636e\\u8bf4\\u670d\\u59d4\\u5458\\u4f1a\\u2014\\u2014\\u53cd\\u5b88\\u4e3a\\u653b\\u7684\\u5173\\u952e\\u6289\\u62e9", "type": "transition", "importance": 0.9, "impact": "\\u5c55\\u5f00\\u4e0b\\u4e00\\u7ae0\\u6b63\\u9762\\u5bf9\\u8d28\\u573a\\u666f\\uff0c\\u7ba1\\u7406\\u5c40\\u4e0e\\u94f6\\u5f26\\u7684\\u535a\\u5f08\\u5347\\u7ea7", "keyword": "\\u8d76\\u5728\\u4e5d\\u70b9\\u524d\\uff0c\\u6559\\u59d4\\u5458\\u4f1a\\u770b\\u6728\\u5076"}]	4	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u5df2\\u9501\\u5b9a\\u91d1\\u7b3c\\u6f14\\u827a\\u4e3a\\u5e55\\u540e\\u52bf\\u529b\\uff0c\\u51c6\\u5907\\u901a\\u8fc7\\u8bc1\\u7269\\u5e93\\u8bc1\\u636e\\u5370\\u8bc1\\u5168\\u94fe", "state_after": "\\u786e\\u8ba4\\u771f\\u51f6\\u4e3a\\u94f6\\u5f26\\u6f14\\u827a\\u7684\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069\\uff0c\\u770b\\u5230\\u5bf9\\u65b9\\u62a2\\u5148\\u51fa\\u624b\\u540e\\u8f6c\\u4e3a\\u4e3b\\u52a8\\u53cd\\u5236\\u2014\\u2014\\u5148\\u4fdd\\u6f14\\u51fa\\u3001\\u540e\\u6293\\u4eba", "psychological_change": "\\u4ece\\u51b7\\u9759\\u53d6\\u8bc1\\u8005\\u8f6c\\u4e3a\\u4e0e\\u68cb\\u624b\\u5bf9\\u5f08\\u7684\\u5e03\\u5c40\\u8005\\uff1a\\u505c\\u6f14\\u7533\\u8bf7\\u7684\\u7d27\\u903c\\u6ca1\\u6709\\u6253\\u4e71\\u8282\\u594f\\uff0c\\u53cd\\u800c\\u8ba9\\u4ed6\\u8fc5\\u901f\\u5207\\u6362\\u76ee\\u6807\\uff0c\\u5c55\\u73b0\\u51fa\\u5bf9\\u5236\\u5ea6\\u89c4\\u5219\\u7684\\u6df1\\u523b\\u7406\\u89e3\\u4e0e\\u5229\\u7528\\u80fd\\u529b", "key_event": "\\u8bfb\\u5230\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069\\u81f4\\u59d4\\u5458\\u4f1a\\u7684\\u505c\\u6f14\\u7533\\u8bf7\\uff0c\\u7acb\\u5373\\u51b3\\u5b9a\\u6682\\u7f13\\u6293\\u6355", "relationship_changes": {"\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279": "\\u8bc1\\u7269\\u5e93\\u653e\\u884c\\u4e0e\\u53cd\\u5236\\u8ba1\\u5212\\u83b7\\u5f97\\u9ed8\\u8bb8\\uff0c\\u4fe1\\u4efb\\u5ea6\\u4e0a\\u5347\\u4f46\\u53cc\\u65b9\\u4ecd\\u5404\\u81ea\\u7559\\u6709\\u5e95\\u724c", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af": "\\u73c0\\u897f\\u74e6\\u5c14\\u5168\\u7a0b\\u89c2\\u6469\\u5176\\u53d6\\u8bc1\\u624b\\u6cd5\\uff0c\\u5408\\u4f5c\\u5173\\u7cfb\\u52a0\\u6df1\\u4f46\\u5e76\\u4e0d\\u6253\\u6d88\\u5bf9\\u5176\\u80fd\\u529b\\u6765\\u6e90\\u7684\\u6000\\u7591", "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069": "\\u786e\\u5b9a\\u5176\\u4e3a\\u5e55\\u540e\\u771f\\u51f6\\u5e76\\u8fdb\\u5165\\u6b63\\u9762\\u5bf9\\u6297"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "survival_status": null, "state_before": "\\u5b8c\\u6210\\u4efb\\u52a1\\uff0c\\u4f46\\u5f00\\u59cb\\u6000\\u7591\\u83b1\\u5c14\\u9690\\u7792\\u80fd\\u529b\\uff08\\u7b2c10\\u7ae0\\uff09", "state_after": "\\u4e25\\u683c\\u4f9d\\u7a0b\\u5e8f\\u914d\\u5408\\u53d6\\u8bc1\\uff0c\\u4eb2\\u773c\\u770b\\u89c1\\u83b1\\u5c14\\"\\u8bfb\\u51fa\\"\\u8d26\\u7c3f\\u538b\\u75d5\\u540e\\u6000\\u7591\\u52a0\\u6df1\\uff1b\\u5bf9\\u8587\\u5965\\u62c9\\u501f\\u7528\\u53e3\\u4f9b\\u62a2\\u5360\\u5148\\u673a\\u611f\\u5230\\u6124\\u6012", "psychological_change": "\\u4ece\\u6000\\u7591\\u8005\\u8f6c\\u4e3a\\u76ee\\u51fb\\u8005\\u2014\\u2014\\u83b1\\u5c14\\u8fc7\\u4e8e\\u7cbe\\u786e\\u7684\\u4fe1\\u606f\\u6765\\u6e90\\u8ba9\\u4ed6\\u66f4\\u52a0\\u8b66\\u89c9\\uff0c\\u4f46\\u7834\\u6848\\u6548\\u7387\\u53c8\\u8feb\\u4f7f\\u4ed6\\u6682\\u65f6\\u538b\\u4e0b\\u7591\\u8651\\u7ee7\\u7eed\\u5408\\u4f5c", "key_event": "\\u53d1\\u73b0\\u6597\\u7bf7\\u5973\\u4eba\\u53e3\\u4f9b\\u88ab\\u7528\\u4f5c\\u505c\\u6f14\\u7533\\u8bf7\\u9644\\u4ef6\\uff0c\\u610f\\u8bc6\\u5230\\u5236\\u5ea6\\u88ab\\u5bf9\\u624b\\u53cd\\u5411\\u5229\\u7528", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u5408\\u4f5c\\u52a0\\u6df1\\u4f46\\u5ba1\\u89c6\\u76ee\\u5149\\u672a\\u6d88\\uff0c\\u6301\\u7eed\\u7559\\u610f\\u5176\\u4fe1\\u606f\\u83b7\\u53d6\\u65b9\\u5f0f", "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279": "\\u4e25\\u683c\\u6267\\u884c\\u5c40\\u957f\\u6307\\u793a\\uff0c\\u7a0b\\u5e8f\\u670d\\u4ece\\u4e0d\\u53d8"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279", "survival_status": null, "state_before": "\\u57ce\\u5e9c\\u6781\\u6df1\\uff0c\\u4e60\\u60ef\\u5148\\u8bd5\\u63a2\\u518d\\u51b3\\u5b9a", "state_after": "\\u6709\\u9650\\u653e\\u6743\\u7ed9\\u83b1\\u5c14\\u67e5\\u770b\\u8bc1\\u7269\\uff0c\\u5e76\\u9ed8\\u8bb8\\u5176\\"\\u5148\\u522b\\u6293\\"\\u7684\\u5192\\u9669\\u8ba1\\u5212", "psychological_change": "\\u4ece\\u4fdd\\u7559\\u4e09\\u5206\\u8bd5\\u63a2\\u53d8\\u4e3a\\u52a1\\u5b9e\\u6743\\u8861\\u2014\\u2014\\u5728\\u65f6\\u9650\\u538b\\u529b\\u4e0b\\u9009\\u62e9\\u8ba9\\u83b1\\u5c14\\u5148\\u53bb\\u59d4\\u5458\\u4f1a\\u4e89\\u53d6\\u65f6\\u95f4\\uff0c\\u4f46\\u4ecd\\u4fdd\\u7559\\u6700\\u7ec8\\u5426\\u51b3\\u6743", "key_event": "\\u7b7e\\u6536\\u59d4\\u5458\\u4f1a\\u7d27\\u6025\\u6587\\u4ef6\\u5e76\\u542c\\u5b8c\\u83b1\\u5c14\\u7684\\u53cd\\u5236\\u8ba1\\u5212\\uff0c\\u6279\\u51c6\\u6682\\u7f13\\u6293\\u6355", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u89c2\\u5bdf\\u8bd5\\u63a2\\u8f6c\\u4e3a\\u6709\\u9650\\u5408\\u4f5c\\uff0c\\u4fe1\\u4efb\\u5ea6\\u4e0a\\u5347\\u4f46\\u5e95\\u7ebf\\u672a\\u677e"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069", "survival_status": "active", "state_before": "\\uff08\\u5e55\\u540e\\uff09\\u638c\\u63a7\\u94f6\\u5f26\\u6f14\\u827a\\u4e0e\\u6728\\u5076\\u66ff\\u8eab\\u8ba1\\u5212\\uff0c\\u672a\\u5728\\u6b63\\u9762\\u573a\\u666f\\u51fa\\u573a", "state_after": "\\u62a2\\u5148\\u5411\\u5267\\u9662\\u59d4\\u5458\\u4f1a\\u63d0\\u4ea4\\u505c\\u6f14\\u7533\\u8bf7\\uff0c\\u5360\\u636e\\u5236\\u5ea6\\u5148\\u624b", "psychological_change": "\\u5c55\\u793a\\u51fa\\u6bd4\\u6597\\u7bf7\\u5973\\u4eba\\u4e0e\\u64cd\\u5076\\u5e08\\u9ad8\\u4e00\\u4e2a\\u91cf\\u7ea7\\u7684\\u5e03\\u5c40\\u80fd\\u529b\\u2014\\u2014\\u8fde\\u5bf9\\u624b\\u7684\\u8bc1\\u8bcd\\u90fd\\u63d0\\u524d\\u7b97\\u4f5c\\u81ea\\u5df1\\u4e0b\\u4e00\\u6b65\\u7684\\u68cb\\u5b50", "key_event": "\\u4ee5\\u9508\\u8537\\u8587\\u5b58\\u5728\\u672a\\u67e5\\u660e\\u5f02\\u5e38\\u88c5\\u7f6e\\u3001\\u5371\\u5bb3\\u89c2\\u4f17\\u5b89\\u5168\\u4e3a\\u7531\\u7533\\u8bf7\\u6682\\u505c\\u516d\\u6708\\u5341\\u4e09\\u65e5\\u6f14\\u51fa", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u88ab\\u83b1\\u5c14\\u9501\\u5b9a\\u4e3a\\u771f\\u51f6\\uff0c\\u53cc\\u65b9\\u5f00\\u59cb\\u9694\\u7a7a\\u4ea4\\u950b", "\\u6597\\u7bf7\\u5973\\u4eba": "\\u5176\\u8bc1\\u8bcd\\u88ab\\u63d0\\u524d\\u7eb3\\u5165\\u7533\\u8bf7\\u9644\\u4ef6\\uff0c\\u663e\\u793a\\u4e24\\u4eba\\u5b58\\u5728\\u66f4\\u6df1\\u7684\\u9884\\u5148\\u914d\\u5408", "\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b": "\\u7ecf\\u8d6b\\u4f2f\\u7279\\u7275\\u7ebf\\u6253\\u901a\\u4e0e\\u91d1\\u7b3c\\u6f14\\u827a\\u7684\\u5408\\u4f5c\\u6e20\\u9053"}, "career_changes": null, "organization_changes": null}]	[{"location": "\\u7ba1\\u7406\\u5c40\\u95e8\\u5eca\\u4e0e\\u5730\\u4e0b\\u8d70\\u5eca", "atmosphere": "\\u96e8\\u591c\\u538b\\u6291\\uff0c\\u6d88\\u6bd2\\u6c34\\u5473\\uff0c\\u5b88\\u536b\\u68ee\\u4e25", "duration": "\\u77ed\\u573a\\u666f\\uff0c\\u53d9\\u4e8b\\u65f6\\u95f4\\u7ea6\\u5341\\u5206\\u949f"}, {"location": "\\u5730\\u4e0b\\u4e00\\u5c42\\u8bc1\\u7269\\u5e93\\u5185\\u90e8", "atmosphere": "\\u9634\\u51b7\\u6f6e\\u6e7f\\uff0c\\u9632\\u8150\\u6cb9\\u4e0e\\u9709\\u5473\\uff0c\\u706f\\u5149\\u660f\\u9ec4\\uff0c\\u6728\\u5076\\u8499\\u773c\\u6392\\u5217", "duration": "\\u4e3b\\u573a\\u666f\\uff0c\\u53d9\\u4e8b\\u65f6\\u95f4\\u8fd1\\u4e24\\u5c0f\\u65f6\\uff08\\u4e5d\\u70b9\\u5341\\u4e03\\u5206\\u81f3\\u5341\\u4e00\\u70b9\\uff09"}, {"location": "\\u8bc1\\u7269\\u5e93\\u94c1\\u95e8\\u5916\\u4e0e\\u8d70\\u5eca", "atmosphere": "\\u7d27\\u6025\\u6587\\u4e66\\u9001\\u8fbe\\u6253\\u7834\\u6c89\\u6ede\\uff0c\\u6c14\\u6c1b\\u9aa4\\u7136\\u7d27\\u5f20", "duration": "\\u77ed\\u573a\\u666f\\uff0c\\u53d9\\u4e8b\\u65f6\\u95f4\\u6570\\u5206\\u949f"}]	varied	8.3	8	8.3	8.5	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.3/10\n  节奏把控: 8.0/10\n  吸引力: 8.3/10\n  连贯性: 8.5/10\n\n【剧情阶段】发展\n\n【钩子分析】共4个\n  • [悬念] 莱尔决定暂缓抓捕、赶在九点前让委员会"看木偶"——他如何用已被扣押的物证说服委员会不中止演出？... (强度:9)\n  • [悬念] 薇奥拉·凯恩抢先一步提交停演申请，管理局即便掌握犯罪证据也无法证明"不存在的东西不存在"，主角陷入制... (强度:8)\n  • [悬念] 异象中那枚刻着字母V的银色弦琴形领针未被丢进火盆——它是真实证物还是未来指认薇奥拉的物证？... (强度:7)\n\n【伏笔分析】埋下4个, 回收2个\n\n【冲突分析】\n  类型: 人与人, 人与社会\n  强度: 8/10\n  进度: 45%\n\n【改进建议】\n  1. 【描写密度】中段零件编号逐一罗列（四八九/四九一/四九二/四九三）与两份口供比对的段落略密集，可在编号之间插入雷金纳德或珀西瓦尔的反应打断句式，让"找缺失编号"的过程更有层次感，同时缓解信息堆叠。	["\\u3010\\u63cf\\u5199\\u5bc6\\u5ea6\\u3011\\u4e2d\\u6bb5\\u96f6\\u4ef6\\u7f16\\u53f7\\u9010\\u4e00\\u7f57\\u5217\\uff08\\u56db\\u516b\\u4e5d/\\u56db\\u4e5d\\u4e00/\\u56db\\u4e5d\\u4e8c/\\u56db\\u4e5d\\u4e09\\uff09\\u4e0e\\u4e24\\u4efd\\u53e3\\u4f9b\\u6bd4\\u5bf9\\u7684\\u6bb5\\u843d\\u7565\\u5bc6\\u96c6\\uff0c\\u53ef\\u5728\\u7f16\\u53f7\\u4e4b\\u95f4\\u63d2\\u5165\\u96f7\\u91d1\\u7eb3\\u5fb7\\u6216\\u73c0\\u897f\\u74e6\\u5c14\\u7684\\u53cd\\u5e94\\u6253\\u65ad\\u53e5\\u5f0f\\uff0c\\u8ba9\\"\\u627e\\u7f3a\\u5931\\u7f16\\u53f7\\"\\u7684\\u8fc7\\u7a0b\\u66f4\\u6709\\u5c42\\u6b21\\u611f\\uff0c\\u540c\\u65f6\\u7f13\\u89e3\\u4fe1\\u606f\\u5806\\u53e0\\u3002"]	\N	0.4	0.35	2026-08-07 11:12:29.709725
75c14695-4b6e-44fd-a057-aaa8c4bb7a16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	紧张戒备	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u65b0\\u7248\\u5165\\u573a\\u53e3\\u4ee4\\u53ea\\u6709\\u516d\\u4e2a\\u4eba\\u77e5\\u9053\\uff0c\\u5374\\u88ab\\u7ed1\\u532a\\u8bf4\\u51fa\\uff0c\\u8bc1\\u660e\\u5185\\u9b3c\\u5c31\\u5728\\u4e50\\u961f\\u6838\\u5fc3\\u5708\\u5185\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5979\\u8bf4\\uff0c'\\u949f\\u574f\\u5728\\u5341\\u4e00\\u70b9'\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u585e\\u897f\\u8389\\u5728\\u8d70\\u5eca\\u5916\\u6525\\u7d27\\u6392\\u7ec3\\u5ba4\\u94a5\\u5319\\u76f4\\u5230\\u638c\\u5fc3\\u51fa\\u8840\\uff0c\\u6697\\u793a\\u5979\\u53ef\\u80fd\\u9690\\u85cf\\u7740\\u4e0e\\u5185\\u9b3c\\u76f8\\u5173\\u7684\\u79d8\\u5bc6\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u94a5\\u5319\\u4e0a\\u6cbe\\u4e86\\u4e00\\u70b9\\u8840\\u3002"}, {"type": "\\u60c5\\u611f", "content": "\\u739b\\u8482\\u5c14\\u8fbe\\u4e0e\\u585e\\u897f\\u8389\\u4e4b\\u95f4\\u56e0\\u53e3\\u4ee4\\u6cc4\\u9732\\u5f62\\u6210\\u4fe1\\u4efb\\u88c2\\u75d5\\uff0c\\u739b\\u8482\\u5c14\\u8fbe\\u654f\\u9510\\u5730\\u611f\\u5230\\u5bf9\\u65b9\\u5f00\\u59cb\\u6015\\u81ea\\u5df1\\u3002", "strength": 7, "position": "\\u7ed3\\u5c3e", "keyword": "\\u5979\\u5f00\\u59cb\\u6015\\u6211\\u4e86\\u3002"}, {"type": "\\u8ba4\\u77e5", "content": "\\u7a7f\\u6597\\u7bf7\\u5973\\u4eba\\u6536\\u96c6\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u7b7e\\u540d\\u3001\\u8bed\\u6c14\\u3001\\u8eab\\u4f53\\u4e60\\u60ef\\uff0c\\u8bf4\\u660e\\u6728\\u5076\\u6280\\u672f\\u5df2\\u80fd\\u590d\\u5236\\u6d3b\\u4eba\\u7ec6\\u8282\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5979\\u5c31\\u8ba9\\u6728\\u5076\\u5b66\\u6211\\u7728\\u773c\\u3002"}]	4	\N	[]	0	0	[{"content": "\\u739b\\u8482\\u5c14\\u8fbe\\u56de\\u5fc6\\u7ed1\\u532a\\u8fdb\\u95e8\\u4fbf\\u8bf4\\u51fa\\u53ea\\u6709\\u516d\\u4eba\\u77e5\\u9053\\u7684\\u65b0\\u7248\\u5165\\u573a\\u53e3\\u4ee4'\\u949f\\u574f\\u5728\\u5341\\u4e00\\u70b9'\\uff0c\\u8bc1\\u660e\\u5185\\u9b3c\\u5c31\\u5728\\u6d41\\u7a0b\\u8868\\u6301\\u6709\\u8005\\u4e4b\\u4e2d\\u3002", "type": "revelation", "importance": 0.95, "impact": "\\u8c03\\u67e5\\u7126\\u70b9\\u9aa4\\u7136\\u8f6c\\u5411\\u4e50\\u961f\\u5185\\u90e8\\uff0c\\u4fe1\\u4efb\\u4f53\\u7cfb\\u5f00\\u59cb\\u5d29\\u89e3\\u3002", "keyword": "\\u5979\\u8bf4\\uff0c'\\u949f\\u574f\\u5728\\u5341\\u4e00\\u70b9'\\u3002"}, {"content": "\\u83b1\\u5c14\\u7528'\\u6000\\u7591\\u7eb8\\u4e0d\\u6000\\u7591\\u4eba'\\u7684\\u903b\\u8f91\\u5728\\u62a5\\u7eb8\\u4e0a\\u5199\\u4e0b\\u516d\\u4eba\\u540d\\u5355\\uff0c\\u9010\\u4e00\\u6838\\u5bf9\\u6d41\\u7a0b\\u8868\\u4e0b\\u843d\\u3002", "type": "conflict", "importance": 0.8, "impact": "\\u4e3a\\u540e\\u7eed\\u53d6\\u8bc1\\u786e\\u5b9a\\u65b9\\u5411\\uff0c\\u540c\\u65f6\\u907f\\u514d\\u56e0\\u76f4\\u63a5\\u6000\\u7591\\u961f\\u5458\\u800c\\u6fc0\\u5316\\u5185\\u90e8\\u77db\\u76fe\\u3002", "keyword": "\\u6000\\u7591\\u4eba\\uff0c\\u4f1a\\u5148\\u627e\\u52a8\\u673a\\u3002\\u6000\\u7591\\u7eb8\\uff0c\\u53ea\\u770b\\u5b83\\u7ecf\\u8fc7\\u8c01\\u7684\\u624b\\u3002"}, {"content": "\\u585e\\u897f\\u8389\\u5f97\\u77e5\\u53e3\\u4ee4\\u6cc4\\u9732\\u540e\\u672c\\u80fd\\u5730\\u4e0e\\u739b\\u8482\\u5c14\\u8fbe\\u4fdd\\u6301\\u8ddd\\u79bb\\uff0c\\u6700\\u7ec8\\u5728\\u8d70\\u5eca\\u5916\\u6525\\u94a5\\u5319\\u81f3\\u638c\\u5fc3\\u51fa\\u8840\\u3002", "type": "conflict", "importance": 0.85, "impact": "\\u5979\\u7684\\u7acb\\u573a\\u53d8\\u5f97\\u66a7\\u6627\\uff0c\\u6210\\u4e3a\\u5185\\u9b3c\\u5acc\\u7591\\u4e2d\\u6700\\u5177\\u60c5\\u611f\\u5f20\\u529b\\u7684\\u4e00\\u73af\\u3002", "keyword": "\\u94a5\\u5319\\u4e0a\\u6cbe\\u4e86\\u4e00\\u70b9\\u8840\\u3002"}, {"content": "\\u739b\\u8482\\u5c14\\u8fbe\\u5728\\u56de\\u7b54'\\u53f3\\u811a\\u8fd8\\u662f\\u5de6\\u811a\\u5148\\u8e29\\u5e95\\u9f13'\\u65f6\\u5361\\u987f\\u5e76\\u7f29\\u56de\\u53f3\\u811a\\uff0c\\u6697\\u793a\\u8eab\\u4f53\\u8bb0\\u5fc6\\u53ef\\u80fd\\u88ab\\u5916\\u529b\\u5e72\\u6270\\u3002", "type": "revelation", "importance": 0.6, "impact": "\\u4e3a\\u540e\\u7eed\\u8bb0\\u5fc6\\u64cd\\u63a7\\u4e0e\\u6728\\u5076\\u6280\\u672f\\u5bf9\\u6d3b\\u4eba\\u5f71\\u54cd\\u7684\\u4e3b\\u9898\\u57cb\\u4e0b\\u6697\\u7ebf\\u3002", "keyword": "\\u53f3\\u811a\\u8fd8\\u662f\\u5de6\\u811a\\u5148\\u8e29\\u5e95\\u9f13\\uff1f"}, {"content": "\\u7a7f\\u6597\\u7bf7\\u5973\\u4eba\\u5f3a\\u8feb\\u739b\\u8482\\u5c14\\u8fbe\\u6bcf\\u65e5\\u7b7e\\u540d\\u3001\\u91cd\\u590d\\u8bf4\\u8bdd\\u3001\\u7ec3\\u4e60\\u52a8\\u4f5c\\uff0c\\u5e76\\u8ba9\\u6728\\u5076\\u6a21\\u4eff\\u5979\\uff0c\\u63ed\\u793a\\u53cd\\u6d3e\\u6b63\\u5728\\u5236\\u9020\\u4ee5\\u5047\\u4e71\\u771f\\u7684\\u66ff\\u8eab\\u3002", "type": "revelation", "importance": 0.75, "impact": "\\u62d3\\u5bbd\\u5267\\u60c5\\u4e16\\u754c\\u89c2\\uff0c\\u4f7f\\u6728\\u5076\\u4ea7\\u4e1a\\u94fe\\u7684\\u5a01\\u80c1\\u4ece'\\u5f62\\u4f53\\u6a21\\u4eff'\\u5347\\u7ea7\\u4e3a'\\u8eab\\u4efd\\u7a83\\u53d6'\\u3002", "keyword": "\\u5979\\u8bf4\\u6211\\u7684'\\u65af\\u7279\\u6797'\\u6536\\u5c3e\\u592a\\u5feb\\uff0c\\u6728\\u5076\\u5b66\\u4e0d\\u50cf\\u3002"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u51b7\\u9759\\u63a2\\u8bbf\\uff0c\\u523b\\u610f\\u4e0d\\u76f4\\u63a5\\u8ffd\\u95ee", "state_after": "\\u9501\\u5b9a\\u5185\\u9b3c\\u8303\\u56f4\\u5e76\\u5f00\\u59cb\\u6697\\u4e2d\\u6392\\u67e5\\u516d\\u4efd\\u6d41\\u7a0b\\u8868", "psychological_change": "\\u901a\\u8fc7\\u751f\\u6d3b\\u5316\\u5bf9\\u8bdd\\u7a33\\u5b9a\\u739b\\u8482\\u5c14\\u8fbe\\u60c5\\u7eea\\uff0c\\u518d\\u5229\\u7528'\\u6000\\u7591\\u7eb8\\u4e0d\\u6000\\u7591\\u4eba'\\u7684\\u601d\\u7ef4\\u907f\\u5f00\\u4fe1\\u4efb\\u7ed1\\u67b6\\uff0c\\u628a\\u8c03\\u67e5\\u63a8\\u8fdb\\u5230\\u4e50\\u961f\\u5185\\u90e8\\u3002\\u4ed6\\u6ce8\\u610f\\u5230\\u585e\\u897f\\u8389\\u7684\\u5f02\\u5e38\\u4f46\\u672a\\u5f53\\u9762\\u63ed\\u7a7f\\uff0c\\u4fdd\\u6301\\u89c2\\u5bdf\\u8005\\u59ff\\u6001\\u3002", "key_event": "\\u5728\\u62a5\\u7eb8\\u4e0a\\u5199\\u4e0b\\u516d\\u4eba\\u540d\\u5355\\uff0c\\u5212\\u5b9a\\u6d41\\u7a0b\\u8868\\u6392\\u67e5\\u65b9\\u5411", "relationship_changes": {"\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u4fe1\\u4efb\\u8fdb\\u4e00\\u6b65\\u52a0\\u6df1\\uff0c\\u6210\\u4e3a\\u5979\\u552f\\u4e00\\u80fd\\u653e\\u5fc3\\u5bf9\\u8bdd\\u7684\\u4eba", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u5408\\u4f5c\\u4e2d\\u4fdd\\u7559\\u89c2\\u5bdf\\uff0c\\u6ce8\\u610f\\u5230\\u5979\\u7684\\u8fdf\\u7591\\u4e0e\\u6c89\\u9ed8"}, "career_changes": null, "organization_changes": []}, {"character_name": "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "survival_status": null, "state_before": "\\u6050\\u60e7\\u604d\\u60da\\uff0c\\u8ba4\\u4e0d\\u51fa\\u4eba\\uff0c\\u62c5\\u5fc3\\u88ab\\u9501\\u4f4f", "state_after": "\\u5728\\u83b1\\u5c14\\u7684\\u5b89\\u629a\\u4e0b\\u8bf4\\u51fa\\u5173\\u952e\\u8bc1\\u8bcd\\uff0c\\u4f46\\u5bf9\\u8eab\\u8fb9\\u4eba\\u7684\\u4fe1\\u4efb\\u5f00\\u59cb\\u52a8\\u6447", "psychological_change": "\\u4ece\\u9ad8\\u5ea6\\u6212\\u5907\\u9010\\u6e10\\u6253\\u5f00\\u5fc3\\u9632\\uff0c\\u4f46\\u4ecd\\u88ab\\u521b\\u4f24\\u8bb0\\u5fc6\\u7b3c\\u7f69\\u3002\\u5979\\u654f\\u9510\\u5730\\u5bdf\\u89c9\\u585e\\u897f\\u8389\\u53d8\\u5f97\\u758f\\u8fdc\\uff0c\\u4e5f\\u56e0\\u81ea\\u5df1\\u56de\\u7b54\\u53f3\\u811a\\u4e0b\\u610f\\u8bc6\\u5361\\u987f\\u800c\\u9690\\u9690\\u610f\\u8bc6\\u5230\\u8eab\\u4f53\\u8bb0\\u5fc6\\u53ef\\u80fd\\u88ab\\u5916\\u529b\\u5165\\u4fb5\\u3002", "key_event": "\\u56de\\u5fc6\\u5e76\\u8bf4\\u51fa\\u7a7f\\u6597\\u7bf7\\u5973\\u4eba\\u6cc4\\u9732\\u7684\\u5165\\u573a\\u53e3\\u4ee4'\\u949f\\u574f\\u5728\\u5341\\u4e00\\u70b9'", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4fe1\\u4efb\\u5ea6\\u4e0b\\u964d\\uff0c\\u611f\\u5230\\u5bf9\\u65b9\\u5728\\u6015\\u81ea\\u5df1", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u6551\\u547d\\u6069\\u4eba\\u8f6c\\u4e3a\\u552f\\u4e00\\u613f\\u610f\\u503e\\u8bc9\\u7684\\u5bf9\\u8c61"}, "career_changes": null, "organization_changes": []}, {"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": null, "state_before": "\\u5173\\u5207\\u5b88\\u62a4\\uff0c\\u5e2e\\u739b\\u8482\\u5c14\\u8fbe\\u6574\\u7406\\u88ab\\u89d2\\u3001\\u6361\\u836f\\u676f", "state_after": "\\u56e0\\u53e3\\u4ee4\\u6cc4\\u9732\\u800c\\u8b66\\u89c9\\u758f\\u79bb\\uff0c\\u5185\\u5fc3\\u9677\\u5165\\u81ea\\u6211\\u6323\\u624e\\uff0c\\u5728\\u8d70\\u5eca\\u72ec\\u81ea\\u6525\\u94a5\\u5319\\u81f3\\u51fa\\u8840", "psychological_change": "\\u5f97\\u77e5\\u53ea\\u6709\\u4e50\\u961f\\u5185\\u90e8\\u77e5\\u9053\\u7684\\u53e3\\u4ee4\\u88ab\\u7ed1\\u532a\\u8bf4\\u51fa\\u53e3\\u540e\\uff0c\\u5979\\u672c\\u80fd\\u5730\\u4e0e\\u739b\\u8482\\u5c14\\u8fbe\\u62c9\\u5f00\\u8ddd\\u79bb\\u3002\\u5979\\u8868\\u9762\\u914d\\u5408\\u83b1\\u5c14\\u8c03\\u67e5\\uff0c\\u4f46\\u7ed3\\u5c3e\\u7684\\u5f02\\u5e38\\u884c\\u4e3a\\u6697\\u793a\\u5979\\u53ef\\u80fd\\u6709\\u4e0d\\u4e3a\\u4eba\\u77e5\\u7684\\u9690\\u60c5\\u3002", "key_event": "\\u542c\\u5230'\\u949f\\u574f\\u5728\\u5341\\u4e00\\u70b9'\\u540e\\u8138\\u8272\\u8840\\u8272\\u892a\\u53bb\\uff0c\\u800c\\u540e\\u5728\\u95e8\\u5916\\u6525\\u7d27\\u6392\\u7ec3\\u5ba4\\u94a5\\u5319", "relationship_changes": {"\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u4ece\\u4eb2\\u5bc6\\u966a\\u4f34\\u8f6c\\u4e3a\\u4fdd\\u6301\\u8ddd\\u79bb\\uff0c\\u4fe1\\u4efb\\u51fa\\u73b0\\u88c2\\u75d5", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u63a5\\u53d7\\u5176\\u5b89\\u6392\\u4f46\\u672a\\u5b8c\\u5168\\u5766\\u8bda\\uff0c\\u5b58\\u5728\\u672a\\u8a00\\u660e\\u7684\\u5f20\\u529b"}, "career_changes": null, "organization_changes": []}]	[{"location": "\\u6e2f\\u533a\\u8bca\\u7597\\u6240\\u4e8c\\u697c\\u8d70\\u5eca", "atmosphere": "\\u7070\\u96fe\\u5f25\\u6f2b\\u3001\\u7164\\u70df\\u6c14\\u5473\\u3001\\u538b\\u6291\\u6c89\\u5bc2", "duration": "\\u7ea63\\u5206\\u949f"}, {"location": "\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u75c5\\u623f", "atmosphere": "\\u7d27\\u5f20\\u3001\\u8bd5\\u63a2\\u3001\\u9010\\u6e10\\u56de\\u6696\\u53c8\\u9aa4\\u7136\\u51db\\u51bd", "duration": "\\u7ea640\\u5206\\u949f"}, {"location": "\\u75c5\\u623f\\u5916\\u8d70\\u5eca", "atmosphere": "\\u51b7\\u5cfb\\u3001\\u81ea\\u6211\\u6323\\u624e\\u3001\\u9690\\u5fcd\\u4e0d\\u53d1", "duration": "\\u7ea62\\u5206\\u949f"}]	中速偏缓，对话紧凑，信息逐步释放	8.3	8	8.6	8.2	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.3/10\n  节奏把控: 8.0/10\n  吸引力: 8.6/10\n  连贯性: 8.2/10\n\n【剧情阶段】发展\n\n【钩子分析】共4个\n  • [悬念] 新版入场口令只有六个人知道，却被绑匪说出，证明内鬼就在乐队核心圈内。... (强度:9)\n  • [悬念] 塞西莉在走廊外攥紧排练室钥匙直到掌心出血，暗示她可能隐藏着与内鬼相关的秘密。... (强度:8)\n  • [情感] 玛蒂尔达与塞西莉之间因口令泄露形成信任裂痕，玛蒂尔达敏锐地感到对方开始怕自己。... (强度:7)\n\n【伏笔分析】埋下5个, 回收0个\n\n【冲突分析】\n  类型: 人与人, 人与己\n  强度: 8/10\n  进度: 20%\n\n【改进建议】\n  1. 【描写不足】塞西莉结尾攥钥匙出血的情感冲击力足够，但在前文她听到口令时缺乏一个细小的手部动作或眼神描写作为预铺垫，建议在'塞西莉脸上的血色褪了'附近加一个类似她下意识摸了摸口袋的细节，让结尾行为更自然连贯。	["\\u3010\\u63cf\\u5199\\u4e0d\\u8db3\\u3011\\u585e\\u897f\\u8389\\u7ed3\\u5c3e\\u6525\\u94a5\\u5319\\u51fa\\u8840\\u7684\\u60c5\\u611f\\u51b2\\u51fb\\u529b\\u8db3\\u591f\\uff0c\\u4f46\\u5728\\u524d\\u6587\\u5979\\u542c\\u5230\\u53e3\\u4ee4\\u65f6\\u7f3a\\u4e4f\\u4e00\\u4e2a\\u7ec6\\u5c0f\\u7684\\u624b\\u90e8\\u52a8\\u4f5c\\u6216\\u773c\\u795e\\u63cf\\u5199\\u4f5c\\u4e3a\\u9884\\u94fa\\u57ab\\uff0c\\u5efa\\u8bae\\u5728'\\u585e\\u897f\\u8389\\u8138\\u4e0a\\u7684\\u8840\\u8272\\u892a\\u4e86'\\u9644\\u8fd1\\u52a0\\u4e00\\u4e2a\\u7c7b\\u4f3c\\u5979\\u4e0b\\u610f\\u8bc6\\u6478\\u4e86\\u6478\\u53e3\\u888b\\u7684\\u7ec6\\u8282\\uff0c\\u8ba9\\u7ed3\\u5c3e\\u884c\\u4e3a\\u66f4\\u81ea\\u7136\\u8fde\\u8d2f\\u3002"]	\N	0.55	0.2	2026-08-07 11:03:46.234029
5dad2061-49d3-4d04-8fed-f62f4c1a32a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	沉重压抑	0.85	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u739b\\u8482\\u5c14\\u8fbe\\u5728\\u6f14\\u51fa\\u524d\\u591c\\u5f7b\\u5e95\\u5d29\\u6e83\\uff0c\\u4eb2\\u53e3\\u8bf4\\u51fa\\"\\u53ef\\u6211\\u4e0d\\u4f1a\\u6253\\u9f13\\u4e86\\"\\u3002\\u660e\\u665a\\u7684\\u6f14\\u51fa\\u8bb8\\u53ef\\u4fdd\\u4f4f\\u4e86\\uff0c\\u4f46\\u9f13\\u624b\\u5931\\u53bb\\u6f14\\u594f\\u80fd\\u529b\\uff0c\\u4e50\\u961f\\u80fd\\u5426\\u767b\\u573a\\u6210\\u4e3a\\u6700\\u5927\\u60ac\\u5ff5\\u3002", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u53ef\\u6211\\u4e0d\\u4f1a\\u6253\\u9f13\\u4e86\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u516c\\u5f00\\u8bc1\\u7269\\u76ee\\u5f55\\u76f4\\u6307\\u8587\\u5965\\u62c9\\u4e0e\\u6728\\u5076\\u6848\\u5173\\u8054\\uff0c\\u4f46\\u59d4\\u5458\\u4f1a\\u4ec5\\u5904\\u7406\\u4e86\\u6f14\\u51fa\\u8bb8\\u53ef\\uff0c\\u5211\\u4e8b\\u8ffd\\u8d23\\u5c1a\\u672a\\u5c55\\u5f00\\u3002\\u8587\\u5965\\u62c9\\u7684\\u771f\\u5b9e\\u7ed3\\u5c40\\u4e0e\\u53cd\\u51fb\\u53ef\\u80fd\\u4ecd\\u60ac\\u800c\\u672a\\u51b3\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8587\\u5965\\u62c9\\u5728\\u5f8b\\u5e08\\u63a9\\u62a4\\u4e0b\\u79bb\\u5f00\\u65c1\\u542c\\u5e2d\\uff0c\\u8bb0\\u8005\\u4e00\\u8def\\u8ffd\\u5230\\u697c\\u68af\\u53e3"}, {"type": "\\u60ac\\u5ff5", "content": "\\u5f8b\\u5e08\\"\\u6ca1\\u4eba\\u80fd\\u4fdd\\u8bc1\\u660e\\u665a\\u4e0d\\u4f1a\\u51fa\\u73b0\\u7b2c\\u4e8c\\u5177\\u3001\\u7b2c\\u4e09\\u5177\\u6728\\u5076\\"\\u7684\\u8b66\\u544a\\uff0c\\u5728\\u80dc\\u8bc9\\u540e\\u88ab\\u60ac\\u7f6e\\uff0c\\u6b8b\\u7559\\u7684\\u5f02\\u5e38\\u98ce\\u9669\\u5e76\\u672a\\u5f7b\\u5e95\\u6392\\u9664\\uff0c\\u4e3a\\u540e\\u7eed\\u821e\\u53f0\\u4e8b\\u4ef6\\u57cb\\u4e0b\\u4e0d\\u5b89\\u611f\\u3002", "strength": 7, "position": "\\u4e2d\\u6bb5", "keyword": "\\u6ca1\\u4eba\\u80fd\\u4fdd\\u8bc1\\u660e\\u665a\\u4e0d\\u4f1a\\u51fa\\u73b0\\u7b2c\\u4e8c\\u5177\\u3001\\u7b2c\\u4e09\\u5177\\u6728\\u5076"}, {"type": "\\u60ac\\u5ff5", "content": "\\u8bb0\\u8005\\u5199\\u4e0b\\"\\u5531\\u7247\\u5382\\u957f\\u671f\\u5408\\u7ea6\\"\\uff0c\\u5c06\\u94f6\\u5f26\\u6f14\\u827a\\u6253\\u538b\\u9508\\u8537\\u8587\\u7684\\u884c\\u4e3a\\u6307\\u5411\\u5546\\u4e1a\\u5229\\u76ca\\u52a8\\u673a\\uff0c\\u4f46\\u8fd9\\u4e00\\u7ebf\\u7d22\\u5c1a\\u672a\\u5c55\\u5f00\\u3002", "strength": 6, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5df2\\u7ecf\\u5728\\u672c\\u5b50\\u4e0a\\u5199\\u4e0b\\"\\u5531\\u7247\\u5382\\u957f\\u671f\\u5408\\u7ea6\\""}, {"type": "\\u60c5\\u611f", "content": "\\u9f13\\u69cc\\u4ece\\u739b\\u8482\\u5c14\\u8fbe\\u624b\\u4e2d\\u6ed1\\u843d\\u3001\\u6eda\\u8fc7\\u821e\\u53f0\\u65e0\\u4eba\\u53bb\\u6361\\uff0c\\u83b1\\u5c14\\u53ea\\u5c06\\u9f13\\u69cc\\u6a2a\\u653e\\u5728\\u9f13\\u9762\\u4e0a\\u4e0d\\u903c\\u8feb\\u5979\\u2014\\u2014\\u521b\\u4f24\\u3001\\u966a\\u4f34\\u4e0e\\u65e0\\u52a9\\u4ea4\\u7ec7\\uff0c\\u5f15\\u53d1\\u5f3a\\u70c8\\u5171\\u60c5\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u9f13\\u69cc\\u4ece\\u5979\\u53f3\\u624b\\u6389\\u4e0b\\u53bb\\uff0c\\u6eda\\u8fc7\\u821e\\u53f0"}]	5	\N	[]	0	0	[{"content": "\\u83b1\\u5c14\\u4ee5\\u533b\\u9662\\u8bb0\\u5f55\\u3001\\u7ba1\\u7406\\u5c40\\u68c0\\u6d4b\\u62a5\\u544a\\u3001\\u51fa\\u5165\\u8ffd\\u8ff9\\u548c\\u8bc1\\u7269\\u76ee\\u5f55\\u56db\\u53e0\\u6750\\u6599\\u5c42\\u5c42\\u53cd\\u51fb\\uff0c\\u76f4\\u63a5\\u5c06\\u94f6\\u5f26\\u6f14\\u827a\\u4e0e\\u6728\\u5076\\u72af\\u7f6a\\u7269\\u8bc1\\u9501\\u6b7b\\uff0c\\u626d\\u8f6c\\u542c\\u8bc1\\u5c40\\u52bf\\u3002", "type": "revelation", "importance": 0.9, "impact": "\\u505c\\u6f14\\u7533\\u8bf7\\u5728\\u8bc1\\u636e\\u94fe\\u9762\\u524d\\u5931\\u53bb\\u7acb\\u8db3\\u70b9\\uff0c\\u540c\\u65f6\\u5c06\\u8587\\u5965\\u62c9\\u7684\\u5acc\\u7591\\u4ece\\u5e55\\u540e\\u63a8\\u5411\\u53f0\\u524d", "keyword": "\\u94f6\\u5f26\\u6f14\\u827a\\u8ba2\\u8d2d\\u7684\\u7279\\u6b8a\\u5173\\u8282\\u7f16\\u53f7\\u3001\\u4ed8\\u6b3e\\u65f6\\u95f4\\u3001\\u8d27\\u8fd0\\u4ee3\\u7406"}, {"content": "\\u585e\\u897f\\u8389\\u5f53\\u4f17\\u62c6\\u5f00\\u7eb1\\u5e03\\uff0c\\u5766\\u627f\\u6000\\u7591\\u8fc7\\u4e50\\u961f\\u5185\\u9b3c\\uff08\\u5305\\u62ec\\u739b\\u8482\\u5c14\\u8fbe\\uff09\\uff0c\\u5e76\\u4ee5\\u5370\\u52a1\\u5382\\u5e9f\\u7a3f\\u8bb0\\u5f55\\u8bc1\\u660e\\u786e\\u7cfb\\u5916\\u6cc4\\uff0c\\u89e3\\u5f00\\u94a5\\u5319\\u4f24\\u75a4\\u4e4b\\u8c1c\\u3002", "type": "resolution", "importance": 0.8, "impact": "\\u6d17\\u6e05\\u4e50\\u961f\\u5185\\u90e8\\u5acc\\u7591\\uff0c\\u56de\\u5e94\\u4e86\\u957f\\u671f\\u4ee5\\u6765\\u7684\\u4fe1\\u4efb\\u5371\\u673a\\uff0c\\u4e5f\\u8ba9\\u585e\\u897f\\u8389\\u7684\\u6127\\u759a\\u5f97\\u5230\\u6551\\u8d4e", "keyword": "\\u6211\\u4ee5\\u4e3a\\u6cc4\\u5bc6\\u7684\\u4eba\\u5728\\u4e50\\u961f\\u91cc\\u3002"}, {"content": "\\u59d4\\u5458\\u4f1a\\u88c1\\u5b9a\\u73b0\\u6709\\u6750\\u6599\\u4e0d\\u8db3\\u4ee5\\u8bc1\\u660e\\u949f\\u697c\\u5267\\u9662\\u5b58\\u5728\\u672a\\u53d7\\u63a7\\u5f02\\u5e38\\u98ce\\u9669\\uff0c\\u9a73\\u56de\\u505c\\u6f14\\u7533\\u8bf7\\uff0c\\u9508\\u8537\\u8587\\u6f14\\u51fa\\u8bb8\\u53ef\\u7ee7\\u7eed\\u6709\\u6548\\u3002", "type": "resolution", "importance": 0.8, "impact": "\\u5916\\u90e8\\u6cd5\\u5f8b\\u5371\\u673a\\u89e3\\u9664\\uff0c\\u4f46\\u5f8b\\u5e08\\u63d0\\u51fa\\u7684'\\u7b2c\\u4e8c\\u5177\\u3001\\u7b2c\\u4e09\\u5177\\u6728\\u5076'\\u7684\\u4e0d\\u5b89\\u611f\\u5e76\\u672a\\u968f\\u5224\\u51b3\\u6d88\\u6563", "keyword": "\\u9508\\u8537\\u8587\\u6f14\\u51fa\\u8bb8\\u53ef\\u7ee7\\u7eed\\u6709\\u6548\\u3002"}, {"content": "\\u6392\\u7ec3\\u573a\\u4e0a\\u739b\\u8482\\u5c14\\u8fbe\\u62ff\\u8d77\\u9f13\\u69cc\\u5373\\u95ea\\u56de\\u7ed1\\u67b6\\u573a\\u666f\\uff0c\\u9f13\\u69cc\\u8131\\u624b\\u6eda\\u8fc7\\u821e\\u53f0\\uff0c\\u5979\\u5ba3\\u544a\\"\\u53ef\\u6211\\u4e0d\\u4f1a\\u6253\\u9f13\\u4e86\\"\\u3002", "type": "conflict", "importance": 0.95, "impact": "\\u5916\\u90e8\\u51b2\\u7a81\\u89e3\\u51b3\\u540e\\u5185\\u90e8\\u5371\\u673a\\u7206\\u53d1\\uff0c\\u4e3a\\u4e0b\\u4e00\\u7ae0\\u6f14\\u51fa\\u80fd\\u5426\\u6b63\\u5e38\\u8fdb\\u884c\\u5236\\u9020\\u4e86\\u6700\\u5927\\u60ac\\u5ff5", "keyword": "\\u53ef\\u6211\\u4e0d\\u4f1a\\u6253\\u9f13\\u4e86\\u3002"}]	4	[{"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": null, "state_before": "\\u80cc\\u8d1f\\u6000\\u7591\\u961f\\u53cb\\u7684\\u5185\\u759a\\uff0c\\u624b\\u4e0a\\u7eb1\\u5e03\\u672a\\u6108\\uff0c\\u5fc3\\u4e8b\\u91cd\\u91cd", "state_after": "\\u5f53\\u4f17\\u5766\\u767d\\u5e76\\u6f84\\u6e05\\u6cc4\\u5bc6\\u771f\\u76f8\\uff0c\\u5378\\u4e0b\\u81ea\\u6211\\u6000\\u7591\\uff0c\\u4f46\\u8d70\\u5411\\u739b\\u8482\\u5c14\\u8fbe\\u65f6\\u88ab\\u5bf9\\u65b9\\u672c\\u80fd\\u8eb2\\u5f00\\uff0c\\u53c8\\u6dfb\\u65b0\\u7684\\u9690\\u75db", "psychological_change": "\\u4ece\\u957f\\u671f\\u81ea\\u6211\\u6000\\u7591\\u548c\\u81ea\\u8d23\\u4e2d\\u91ca\\u653e\\uff0c\\u8f6c\\u4e3a\\u5bf9\\u739b\\u8482\\u5c14\\u8fbe\\u521b\\u4f24\\u7684\\u6e05\\u9192\\u8ba4\\u8bc6\\uff1b\\u5979\\u4eb2\\u624b\\u62c6\\u7eb1\\u5e03\\u7684\\u52a8\\u4f5c\\u8c61\\u5f81\\u76f4\\u9762\\u771f\\u76f8\\u7684\\u52c7\\u6c14", "key_event": "\\u5728\\u542c\\u8bc1\\u4f1a\\u4e0a\\u62c6\\u5f00\\u5de6\\u624b\\u7eb1\\u5e03\\uff0c\\u5c55\\u793a\\u94a5\\u5319\\u9f7f\\u538b\\u51fa\\u7684\\u4f24\\u75a4\\uff0c\\u627f\\u8ba4\\"\\u6211\\u4ee5\\u4e3a\\u6cc4\\u5bc6\\u7684\\u4eba\\u5728\\u4e50\\u961f\\u91cc\\"", "relationship_changes": {"\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u5766\\u767d\\u540e\\u4e3b\\u52a8\\u9760\\u8fd1\\uff0c\\u4f46\\u739b\\u8482\\u5c14\\u8fbe\\u56e0\\u521b\\u4f24\\u672c\\u80fd\\u9000\\u7f29\\uff08\\"\\u522b\\u8fc7\\u6765\\"\\uff09\\uff0c\\u4fe1\\u4efb\\u4fee\\u590d\\u4ecd\\u6709\\u7f3a\\u53e3", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4f9d\\u8d56\\u83b1\\u5c14\\u7684\\u8bc1\\u636e\\u652f\\u63f4\\uff0c\\u5408\\u4f5c\\u9ed8\\u5951\\u8fdb\\u4e00\\u6b65\\u589e\\u5f3a"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "survival_status": null, "state_before": "\\u5728\\u542c\\u8bc1\\u4f1a\\u6700\\u540e\\u4e00\\u6392\\u6c89\\u9ed8\\u5750\\u7740\\uff0c\\u77ed\\u53d1\\u906e\\u4f4f\\u534a\\u8fb9\\u8138\\uff0c\\u538b\\u5236\\u521b\\u4f24", "state_after": "\\u6392\\u7ec3\\u95ea\\u56de\\u7ed1\\u67b6\\u573a\\u666f\\uff0c\\u9f13\\u69cc\\u8131\\u624b\\uff0c\\u624b\\u6307\\u65e0\\u6cd5\\u5408\\u62e2\\uff0c\\u5f53\\u573a\\u5d29\\u6e83\\uff0c\\u5766\\u8a00\\"\\u6211\\u4e0d\\u4f1a\\u6253\\u9f13\\u4e86\\"", "psychological_change": "\\u4ece\\u8868\\u9762\\u9547\\u5b9a\\u5230\\u5f7b\\u5e95\\u74e6\\u89e3\\uff1a\\u6728\\u5076\\u6572\\u51fb\\u819d\\u76d6\\u7684\\u753b\\u9762\\u538b\\u8fc7\\u73b0\\u5b9e\\uff0c\\u4ea7\\u751f\\u5bf9\\u4ed6\\u4eba\\u9760\\u8fd1\\u7684\\u672c\\u80fd\\u9632\\u5fa1\\u53cd\\u5e94\\uff0c\\u521b\\u4f24\\u540e\\u5e94\\u6fc0\\u5168\\u9762\\u66b4\\u9732", "key_event": "\\u62ff\\u8d77\\u9f13\\u69cc\\u6392\\u7ec3\\u65f6\\u95ea\\u56de\\u8d27\\u4ed3\\u3001\\u7ef3\\u7d22\\u4e0e\\u6728\\u5076\\uff0c\\u9f13\\u69cc\\u4ece\\u53f3\\u624b\\u6389\\u843d\\u6eda\\u8fc7\\u821e\\u53f0", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u5bf9\\u585e\\u897f\\u8389\\u7684\\u9760\\u8fd1\\u672c\\u80fd\\u9000\\u7f29\\uff08\\u5e76\\u975e\\u4e0d\\u4fe1\\u4efb\\uff0c\\u800c\\u662f\\u521b\\u4f24\\u53cd\\u5e94\\uff09\\uff0c\\u5173\\u7cfb\\u4fee\\u590d\\u53d7\\u963b", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u83b1\\u5c14\\u4e0d\\u903c\\u8feb\\u3001\\u53ea\\u5c06\\u9f13\\u69cc\\u6a2a\\u653e\\u5728\\u9f13\\u9762\\u4e0a\\uff0c\\u4ee4\\u5979\\u83b7\\u5f97\\u5b89\\u5168\\u611f\\uff0c\\u4fe1\\u4efb\\u7ee7\\u7eed\\u7d2f\\u79ef"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u51c6\\u5907\\u5145\\u5206\\u3001\\u4e3b\\u52a8\\u53cd\\u51fb\\u7684\\u8c0b\\u5212\\u8005\\uff0c\\u5e26\\u7740\\u6c89\\u91cd\\u725b\\u76ae\\u7bb1\\u8d74\\u4f1a", "state_after": "\\u542c\\u8bc1\\u80dc\\u8bc9\\u540e\\u9762\\u8272\\u5e73\\u6de1\\uff0c\\u5408\\u4e0a\\u7a7a\\u7bb1\\uff0c\\u8f6c\\u800c\\u7b2c\\u4e00\\u65f6\\u95f4\\u5173\\u6ce8\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u72b6\\u6001", "psychological_change": "\\u5bf9\\u5916\\u51b7\\u9759\\u514b\\u5236\\u3001\\u6b65\\u6b65\\u4e3a\\u8425\\uff1b\\u9762\\u5bf9\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u521b\\u4f24\\u5c55\\u73b0\\u51fa\\u7cbe\\u51c6\\u7684\\u6e29\\u67d4\\u2014\\u2014\\u4e0d\\u9012\\u56de\\u9f13\\u69cc\\uff0c\\u4e0d\\u903c\\u8feb\\uff0c\\u53ea\\u628a\\u9f13\\u69cc\\u6a2a\\u653e\\u5728\\u9f13\\u9762\\u4e0a\\u8ba9\\u5979\\u81ea\\u5df1\\u51b3\\u5b9a", "key_event": "\\u4ee5\\u56db\\u53e0\\u6750\\u6599\\u9010\\u4e00\\u51fb\\u7834\\u5bf9\\u65b9\\u8bba\\u636e\\uff0c\\u5e76\\u4ee5\\u8bc1\\u7269\\u76ee\\u5f55\\u70b9\\u540d\\u8587\\u5965\\u62c9\\uff1b\\u7ed3\\u5c3e\\u66ff\\u739b\\u8482\\u5c14\\u8fbe\\u6361\\u8d77\\u9f13\\u69cc\\u6a2a\\u653e\\u9f13\\u9762", "relationship_changes": {"\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u6301\\u7eed\\u4ee5\\u884c\\u52a8\\u7ed9\\u4e88\\u5b89\\u5168\\u611f\\uff0c\\u6210\\u4e3a\\u5979\\u552f\\u4e00\\u613f\\u610f\\u9760\\u8fd1\\u7684\\u503e\\u8bc9\\u5bf9\\u8c61", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u8c03\\u67e5\\u4e0e\\u4f5c\\u6218\\u9ed8\\u5951\\u8fdb\\u4e00\\u6b65\\u52a0\\u6df1"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u54c8\\u91cc\\u7279", "survival_status": null, "state_before": "\\u6124\\u6012\\u6025\\u8e81\\uff0c\\u5bf9\\u59d4\\u5458\\u4f1a\\u5145\\u6ee1\\u4e0d\\u4fe1\\u4efb\\uff0c\\u5dee\\u70b9\\u51b2\\u52a8\\u6253\\u65ad\\u5f8b\\u5e08\\u53d1\\u8a00", "state_after": "\\u80dc\\u8bc9\\u540e\\u4e00\\u628a\\u62b1\\u4f4f\\u585e\\u897f\\u8389\\uff0c\\u60c5\\u7eea\\u5f7b\\u5e95\\u91ca\\u653e\\uff0c\\u6062\\u590d\\u76f4\\u723d\\u672c\\u8272", "psychological_change": "\\u4ece\\u538b\\u6291\\u6012\\u706b\\u5230\\u96c0\\u8dc3\\u91ca\\u7136\\uff0c\\u662f\\u4e50\\u961f\\u4e2d\\u60c5\\u7eea\\u53cd\\u5e94\\u6700\\u76f4\\u63a5\\u7684\\u4eba", "key_event": "\\u542c\\u5230\\"\\u9508\\u8537\\u8587\\u6f14\\u51fa\\u8bb8\\u53ef\\u7ee7\\u7eed\\u6709\\u6548\\"\\u540e\\u62b1\\u4f4f\\u585e\\u897f\\u8389", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u611f\\u60c5\\u4f9d\\u65e7\\u4eb2\\u5bc6\\uff0c\\u60c5\\u7eea\\u91ca\\u653e\\u65f6\\u9669\\u4e9b\\u649e\\u5230\\u684c\\u89d2"}, "career_changes": null, "organization_changes": null}, {"character_name": "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069", "survival_status": null, "state_before": "\\u5f00\\u5ead\\u65f6\\u4ece\\u5bb9\\u9547\\u5b9a\\uff0c\\u7a7f\\u94f6\\u7070\\u8272\\u957f\\u88d9\\uff0c\\u672a\\u4f69\\u6234\\u94f6\\u5f26\\u5fbd\\u7ae0\\uff0c\\u624b\\u642d\\u819d\\u76d6\\u4e0d\\u770b\\u5bf9\\u65b9", "state_after": "\\u8bc1\\u7269\\u76ee\\u5f55\\u66dd\\u5149\\u540e\\u6293\\u4f4f\\u88d9\\u8fb9\\uff0c\\u5728\\u5f8b\\u5e08\\u63a9\\u62a4\\u4e0b\\u4ed3\\u4fc3\\u79bb\\u573a\\uff0c\\u8bb0\\u8005\\u8fde\\u756a\\u8ffd\\u95ee\\u65e0\\u4eba\\u56de\\u5e94", "psychological_change": "\\u4ece\\u4e3b\\u52a8\\u8fdb\\u653b\\u8f6c\\u4e3a\\u88ab\\u52a8\\u9632\\u5b88\\uff0c\\u66b4\\u9732\\u4e86\\u63d0\\u524d\\u51c6\\u5907\\u8bc1\\u4eba\\u9648\\u8ff0\\u8fd9\\u4e00\\u7834\\u7efd\\uff0c\\u4f46\\u5e76\\u672a\\u8ba4\\u7f6a\\uff0c\\u4ecd\\u6709\\u53cd\\u51fb\\u53ef\\u80fd", "key_event": "\\u83b1\\u5c14\\u51fa\\u793a\\u7ba1\\u7406\\u5c40\\u5c01\\u5370\\u7684\\u8bc1\\u7269\\u76ee\\u5f55\\uff0c\\u5217\\u660e\\u94f6\\u5f26\\u6f14\\u827a\\u8ba2\\u8d2d\\u5173\\u8282\\u53ca\\u5979\\u5728\\u7ed1\\u67b6\\u6848\\u672a\\u516c\\u5f00\\u65f6\\u7684\\u8bc1\\u4eba\\u9648\\u8ff0", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u610f\\u8bc6\\u5230\\u83b1\\u5c14\\u638c\\u63e1\\u5173\\u952e\\u8bc1\\u636e\\uff0c\\u5c06\\u5176\\u89c6\\u4e3a\\u4e3b\\u8981\\u5a01\\u80c1"}, "career_changes": null, "organization_changes": null}]	[{"location": "\\u949f\\u697c\\u5267\\u9662\\u5916\\u8857\\u9762", "atmosphere": "\\u96e8\\u540e\\u55a7\\u56a3\\uff0c\\u8bb0\\u8005\\u5305\\u56f4\\uff0c\\u96fe\\u6c14\\u4e0e\\u9541\\u5149\\u706f\\u767d\\u70df\\u4ea4\\u7ec7", "duration": "\\u542c\\u8bc1\\u5f00\\u59cb\\u524d\\u7ea67\\u5206\\u949f"}, {"location": "\\u949f\\u697c\\u4e8c\\u5c42\\u542c\\u8bc1\\u5385", "atmosphere": "\\u65e7\\u6728\\u8721\\u4e0e\\u6f6e\\u7eb8\\u6c14\\u5473\\u5f25\\u6f2b\\uff0c\\u957f\\u684c\\u540e\\u6392\\u5750\\u6ee1\\u8bb0\\u8005\\uff0c\\u8083\\u7a46\\u800c\\u538b\\u6291", "duration": "\\u4e5d\\u70b9\\u81f3\\u5341\\u70b9\\u96f6\\u4e09\\u5206\\uff0c\\u7ea6\\u4e00\\u5c0f\\u65f6"}, {"location": "\\u542c\\u8bc1\\u5385\\u5916\\u8d70\\u5eca\\u4e0e\\u697c\\u68af\\u53e3", "atmosphere": "\\u6df7\\u4e71\\u55a7\\u56a3\\uff0c\\u8bb0\\u8005\\u8ffd\\u5835\\u8587\\u5965\\u62c9\\uff0c\\u5feb\\u95e8\\u58f0\\u4e0d\\u65ad", "duration": "\\u4f11\\u4f1a\\u540e\\u81f3\\u79bb\\u573a\\uff0c\\u6570\\u5206\\u949f"}, {"location": "\\u949f\\u697c\\u5267\\u9662\\u821e\\u53f0", "atmosphere": "\\u7070\\u5c18\\u626b\\u51c0\\u3001\\u5e55\\u5e03\\u672a\\u5347\\u3001\\u7a7a\\u5ea7\\u6905\\u6ca1\\u5165\\u9ed1\\u6697\\uff0c\\u811a\\u706f\\u5b64\\u4eae\\uff0c\\u5bc2\\u9759\\u6c89\\u91cd", "duration": "\\u4e0b\\u5348\\u6392\\u7ec3\\uff0c\\u7ea6\\u6570\\u5206\\u949f\\u81f3\\u66f4\\u4e45"}]	varied	8.3	8	8.5	8.5	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.3/10\n  节奏把控: 8.0/10\n  吸引力: 8.5/10\n  连贯性: 8.5/10\n\n【剧情阶段】发展\n\n【钩子分析】共5个\n  • [悬念] 玛蒂尔达在演出前夜彻底崩溃，亲口说出"可我不会打鼓了"。明晚的演出许可保住了，但鼓手失去演奏能力，乐... (强度:9)\n  • [悬念] 莱尔公开证物目录直指薇奥拉与木偶案关联，但委员会仅处理了演出许可，刑事追责尚未展开。薇奥拉的真实结局... (强度:8)\n  • [悬念] 律师"没人能保证明晚不会出现第二具、第三具木偶"的警告，在胜诉后被悬置，残留的异常风险并未彻底排除，... (强度:7)\n\n【伏笔分析】埋下3个, 回收2个\n\n【冲突分析】\n  类型: 人与人, 人与己\n  强度: 8/10\n  进度: 40%\n\n【改进建议】\n  1. 【铺垫建议】结尾玛蒂尔达的崩溃爆发力很强，但听证阶段她仅有'坐在最后一排'一处静默描写；可在律师提到'第二具、第三具木偶'时加一个极细微的生理反应（如手指蜷缩、呼吸顿住），让创伤线的铺垫更早渗入，使结尾的崩塌更有渐变层次。	["\\u3010\\u94fa\\u57ab\\u5efa\\u8bae\\u3011\\u7ed3\\u5c3e\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u5d29\\u6e83\\u7206\\u53d1\\u529b\\u5f88\\u5f3a\\uff0c\\u4f46\\u542c\\u8bc1\\u9636\\u6bb5\\u5979\\u4ec5\\u6709'\\u5750\\u5728\\u6700\\u540e\\u4e00\\u6392'\\u4e00\\u5904\\u9759\\u9ed8\\u63cf\\u5199\\uff1b\\u53ef\\u5728\\u5f8b\\u5e08\\u63d0\\u5230'\\u7b2c\\u4e8c\\u5177\\u3001\\u7b2c\\u4e09\\u5177\\u6728\\u5076'\\u65f6\\u52a0\\u4e00\\u4e2a\\u6781\\u7ec6\\u5fae\\u7684\\u751f\\u7406\\u53cd\\u5e94\\uff08\\u5982\\u624b\\u6307\\u8737\\u7f29\\u3001\\u547c\\u5438\\u987f\\u4f4f\\uff09\\uff0c\\u8ba9\\u521b\\u4f24\\u7ebf\\u7684\\u94fa\\u57ab\\u66f4\\u65e9\\u6e17\\u5165\\uff0c\\u4f7f\\u7ed3\\u5c3e\\u7684\\u5d29\\u584c\\u66f4\\u6709\\u6e10\\u53d8\\u5c42\\u6b21\\u3002"]	\N	0.45	0.35	2026-08-07 11:15:46.776681
ac9faef0-b67d-47e9-af55-2bdda7d4b36a	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	开端	7	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	温暖中的隐忧	0.8	\N	[{"type": "\\u8ba4\\u77e5", "content": "\\u83b1\\u5c14\\u901a\\u8fc7\\u978b\\u5370\\u3001\\u5899\\u7070\\u3001\\u54b3\\u55fd\\u548c\\u7cd6\\u7eb8\\u7b49\\u5fae\\u5c0f\\u75d5\\u8ff9\\u8fde\\u7eed\\u627e\\u51fa\\u85cf\\u533f\\u8005\\uff0c\\u8fc5\\u901f\\u5efa\\u7acb\\u5176\\u8d85\\u5e38\\u89c2\\u5bdf\\u529b\\u4e0e\\u63a8\\u7406\\u80fd\\u529b\\uff0c\\u8ba9\\u666e\\u901a\\u6349\\u8ff7\\u85cf\\u5177\\u5907\\u4fa6\\u63a2\\u89e3\\u8c1c\\u7684\\u9605\\u8bfb\\u8da3\\u5473\\u3002", "strength": 7, "position": "\\u5f00\\u5934", "keyword": "\\u4f60\\u90a3\\u53cc\\u978b\\u662f\\u6211\\u8865\\u7684"}, {"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u63a5\\u89e6\\u6728\\u9a6c\\u540e\\uff0c\\u89c6\\u91ce\\u7a81\\u7136\\u5207\\u6362\\u5230\\u7269\\u54c1\\u66fe\\u7ecf\\u89c1\\u8bc1\\u7684\\u573a\\u666f\\uff0c\\u63ed\\u793a\\u4ed6\\u62e5\\u6709\\u8bfb\\u53d6\\u7269\\u54c1\\u6b8b\\u7559\\u8bb0\\u5fc6\\u7684\\u5f02\\u5e38\\u80fd\\u529b\\uff0c\\u4e5f\\u5f15\\u51fa\\u80fd\\u529b\\u6765\\u6e90\\u3001\\u8fb9\\u754c\\u4e0e\\u4ee3\\u4ef7\\u7b49\\u6838\\u5fc3\\u8c1c\\u56e2\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u9662\\u5b50\\u6697\\u4e86\\u4e0b\\u53bb\\u3002\\u6742\\u4e71\\u7684\\u58f0\\u97f3\\u9694\\u7740\\u4e00\\u5c42\\u6c34\\u4f20\\u6765"}, {"type": "\\u51b2\\u7a81", "content": "\\u739b\\u4e3d\\u4fee\\u5973\\u6307\\u51fa\\u5916\\u754c\\u4f1a\\u6050\\u60e7\\u3001\\u6293\\u6355\\u4e43\\u81f3\\u62c6\\u89e3\\u5f02\\u5e38\\u4e4b\\u7269\\uff0c\\u5c06\\u513f\\u7ae5\\u6e38\\u620f\\u4e2d\\u7684\\u5c0f\\u79d8\\u5bc6\\u9aa4\\u7136\\u63d0\\u5347\\u4e3a\\u83b1\\u5c14\\u53ef\\u80fd\\u906d\\u53d7\\u793e\\u4f1a\\u8feb\\u5bb3\\u7684\\u751f\\u5b58\\u5371\\u673a\\u3002", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u6709\\u4e9b\\u4eba\\u4f1a\\u6293\\u4f4f\\u5b83\\uff0c\\u62c6\\u5f00\\u770b\\u770b"}, {"type": "\\u60c5\\u611f", "content": "\\u739b\\u4e3d\\u4fee\\u5973\\u660e\\u786e\\u627f\\u62c5\\u66ff\\u83b1\\u5c14\\u4fdd\\u5b88\\u79d8\\u5bc6\\u7684\\u8d23\\u4efb\\uff0c\\u5448\\u73b0\\u4e24\\u4eba\\u8fd1\\u4f3c\\u6bcd\\u5b50\\u7684\\u6df1\\u539a\\u4fe1\\u4efb\\uff0c\\u4e5f\\u8ba9\\u5979\\u6210\\u4e3a\\u83b1\\u5c14\\u5b89\\u5168\\u611f\\u548c\\u79d8\\u5bc6\\u9632\\u7ebf\\u7684\\u6838\\u5fc3\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u6240\\u4ee5\\u6211\\u5f97\\u66ff\\u4f60\\u5b88\\u7740"}, {"type": "\\u60ac\\u5ff5", "content": "\\u7ed3\\u5c3e\\u6ca1\\u6709\\u89e3\\u91ca\\u83b1\\u5c14\\u80fd\\u529b\\u7684\\u6765\\u6e90\\uff0c\\u53ea\\u7559\\u4e0b\\u53d7\\u635f\\u6728\\u9a6c\\u548c\\u88ab\\u9690\\u85cf\\u7684\\u88c2\\u7eb9\\uff0c\\u6697\\u793a\\u80fd\\u529b\\u79d8\\u5bc6\\u5e76\\u672a\\u771f\\u6b63\\u6d88\\u5931\\uff0c\\u672a\\u6765\\u4ecd\\u53ef\\u80fd\\u56e0\\u7269\\u8bc1\\u6216\\u518d\\u6b21\\u4f7f\\u7528\\u800c\\u66b4\\u9732\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u628a\\u6728\\u9a6c\\u8033\\u6735\\u4e0a\\u7684\\u88c2\\u7eb9\\u6309\\u7d27"}, {"type": "\\u60c5\\u611f", "content": "\\u739b\\u4e3d\\u4fee\\u5973\\u6c90\\u6d74\\u5728\\u9633\\u5149\\u4e2d\\u7684\\u8896\\u53e3\\u88ab\\u63cf\\u5199\\u5f97\\u5f02\\u5e38\\u523a\\u773c\\uff0c\\u6e29\\u6696\\u65e5\\u5e38\\u91cc\\u6e17\\u5165\\u8f7b\\u5fae\\u4e0d\\u7965\\u611f\\uff0c\\u4f7f\\u4fdd\\u62a4\\u8005\\u5f62\\u8c61\\u4e0e\\u6f5c\\u5728\\u5371\\u673a\\u5e76\\u7f6e\\u3002", "strength": 7, "position": "\\u7ed3\\u5c3e", "keyword": "\\u9633\\u5149\\u843d\\u5728\\u5979\\u633d\\u8d77\\u7684\\u8896\\u53e3\\u4e0a\\uff0c\\u767d\\u5f97\\u6709\\u4e9b\\u523a\\u773c"}]	6	\N	[{"title": "\\u89e6\\u7269\\u8bfb\\u53d6\\u6b8b\\u7559\\u8bb0\\u5fc6\\u7684\\u80fd\\u529b", "content": "\\u83b1\\u5c14\\u89e6\\u78b0\\u6728\\u9a6c\\u540e\\uff0c\\u4ee5\\u63a5\\u8fd1\\u6728\\u9a6c\\u89c6\\u89d2\\u7684\\u4f4e\\u4f4d\\u753b\\u9762\\u770b\\u89c1\\u8bfa\\u4e9a\\u5148\\u524d\\u7684\\u884c\\u52a8\\uff0c\\u660e\\u786e\\u57cb\\u4e0b\\u5176\\u80fd\\u591f\\u8bfb\\u53d6\\u7269\\u54c1\\u6b8b\\u7559\\u8bb0\\u5fc6\\u6216\\u8fc7\\u53bb\\u5f71\\u50cf\\u7684\\u80fd\\u529b\\u8bbe\\u5b9a\\u3002\\u540e\\u7eed\\u53ef\\u7528\\u4e8e\\u8ffd\\u67e5\\u4e8b\\u4ef6\\u3001\\u53d1\\u73b0\\u9690\\u85cf\\u771f\\u76f8\\uff0c\\u540c\\u65f6\\u4e5f\\u4f1a\\u6210\\u4e3a\\u4ed6\\u88ab\\u5173\\u6ce8\\u548c\\u8ffd\\u6355\\u7684\\u6839\\u6e90\\u3002", "type": "planted", "strength": 10, "subtlety": 3, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u89c6\\u91ce\\u53d8\\u5f97\\u5f88\\u4f4e\\uff0c\\u524d\\u540e\\u6447\\u6643", "category": "ability", "is_long_term": true, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u8bfa\\u4e9a"], "estimated_resolve_chapter": 2}, {"title": "\\u80fd\\u529b\\u4f7f\\u7528\\u4f1a\\u635f\\u4f24\\u63a5\\u89e6\\u7269\\u54c1", "content": "\\u80fd\\u529b\\u7ed3\\u675f\\u540e\\uff0c\\u539f\\u672c\\u88ab\\u83b1\\u5c14\\u6309\\u4f4f\\u7684\\u6728\\u9a6c\\u8033\\u6735\\u51fa\\u73b0\\u88c2\\u7eb9\\u5e76\\u6389\\u843d\\u6f06\\u7247\\uff0c\\u739b\\u4e3d\\u4fee\\u5973\\u4e5f\\u786e\\u8ba4\\u6628\\u5929\\u5c1a\\u65e0\\u88c2\\u53e3\\u3002\\u8fd9\\u6697\\u793a\\u80fd\\u529b\\u53ef\\u80fd\\u5bf9\\u8bfb\\u53d6\\u5bf9\\u8c61\\u4ea7\\u751f\\u7269\\u7406\\u635f\\u8017\\uff0c\\u672a\\u6765\\u53ef\\u80fd\\u7559\\u4e0b\\u53ef\\u8ffd\\u67e5\\u7684\\u8bc1\\u636e\\uff0c\\u751a\\u81f3\\u5b58\\u5728\\u66f4\\u4e25\\u91cd\\u7684\\u4f7f\\u7528\\u4ee3\\u4ef7\\u3002", "type": "planted", "strength": 8, "subtlety": 6, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u6728\\u9a6c\\u8033\\u6735\\u4e0a\\u88c2\\u5f00\\u4e00\\u9053\\u7ec6\\u7eb9", "category": "ability", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u4e3d\\u4fee\\u5973"], "estimated_resolve_chapter": 3}, {"title": "\\u4f2a\\u9020\\u63a8\\u7406\\u63a9\\u76d6\\u771f\\u5b9e\\u80fd\\u529b", "content": "\\u83b1\\u5c14\\u6ca1\\u6709\\u76f4\\u63a5\\u6380\\u5f00\\u67f3\\u6761\\u7b50\\uff0c\\u800c\\u662f\\u4e34\\u65f6\\u7f16\\u9020\\u679c\\u9171\\u624b\\u5370\\u3001\\u8349\\u5c51\\u548c\\u7b50\\u76d6\\u504f\\u79fb\\u7b49\\u8bc1\\u636e\\u94fe\\uff0c\\u5c06\\u8d85\\u80fd\\u529b\\u6240\\u5f97\\u5305\\u88c5\\u6210\\u89c2\\u5bdf\\u63a8\\u7406\\u3002\\u8fd9\\u79cd\\u9690\\u7792\\u624b\\u6cd5\\u65e2\\u4f53\\u73b0\\u4ed6\\u7684\\u673a\\u654f\\uff0c\\u4e5f\\u9884\\u793a\\u4ed6\\u672a\\u6765\\u4f1a\\u7ee7\\u7eed\\u7528\\u7406\\u6027\\u5206\\u6790\\u548c\\u8c0e\\u8a00\\u906e\\u63a9\\u5f02\\u5e38\\u80fd\\u529b\\u3002", "type": "planted", "strength": 8, "subtlety": 5, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u4ed6\\u8bf4\\u5f97\\u50cf\\u771f\\u6709\\u90a3\\u4e48\\u56de\\u4e8b", "category": "ability", "is_long_term": true, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u8bfa\\u4e9a", "\\u6258\\u6bd4", "\\u827e\\u62c9"], "estimated_resolve_chapter": 5}, {"title": "\\u739b\\u4e3d\\u4fee\\u5973\\u662f\\u79d8\\u5bc6\\u552f\\u4e00\\u5b88\\u62a4\\u8005", "content": "\\u739b\\u4e3d\\u4fee\\u5973\\u4e0d\\u4ec5\\u77e5\\u9053\\u83b1\\u5c14\\u7684\\u80fd\\u529b\\uff0c\\u8fd8\\u4e3b\\u52a8\\u627f\\u62c5\\u66ff\\u4ed6\\u4fdd\\u5bc6\\u548c\\u7ea6\\u675f\\u4ed6\\u7684\\u8d23\\u4efb\\u3002\\u5979\\u5b9e\\u9645\\u4e0a\\u662f\\u83b1\\u5c14\\u4e0e\\u5371\\u9669\\u5916\\u754c\\u4e4b\\u95f4\\u7684\\u4fdd\\u62a4\\u5c4f\\u969c\\uff1b\\u4e00\\u65e6\\u5979\\u65e0\\u6cd5\\u7ee7\\u7eed\\u5c65\\u884c\\u8fd9\\u4e00\\u804c\\u8d23\\uff0c\\u83b1\\u5c14\\u7684\\u79d8\\u5bc6\\u3001\\u5fc3\\u7406\\u5b89\\u5168\\u548c\\u751f\\u5b58\\u73af\\u5883\\u90fd\\u4f1a\\u8fc5\\u901f\\u6076\\u5316\\u3002", "type": "planted", "strength": 9, "subtlety": 5, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u6240\\u4ee5\\u6211\\u5f97\\u66ff\\u4f60\\u5b88\\u7740", "category": "relationship", "is_long_term": false, "related_characters": ["\\u739b\\u4e3d\\u4fee\\u5973", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 3}, {"title": "\\u9633\\u5149\\u767d\\u8896\\u4e0b\\u7684\\u4fdd\\u62a4\\u8005\\u5371\\u673a", "content": "\\u7ed3\\u5c3e\\u7279\\u5199\\u6ca1\\u6709\\u505c\\u7559\\u5728\\u83b1\\u5c14\\u8eab\\u4e0a\\uff0c\\u800c\\u662f\\u843d\\u5728\\u739b\\u4e3d\\u4fee\\u5973\\u88ab\\u9633\\u5149\\u7167\\u5f97\\u523a\\u773c\\u7684\\u767d\\u8272\\u8896\\u53e3\\u4e0a\\u3002\\u6e29\\u6696\\u610f\\u8c61\\u4e2d\\u7684\\u5f02\\u5e38\\u523a\\u76ee\\u611f\\u5236\\u9020\\u8f7b\\u5fae\\u6b7b\\u4ea1\\u6216\\u79bb\\u522b\\u9884\\u5146\\uff0c\\u6697\\u793a\\u8fd9\\u4f4d\\u4fdd\\u62a4\\u8005\\u7684\\u5b89\\u7a33\\u72b6\\u6001\\u53ef\\u80fd\\u5f88\\u5feb\\u88ab\\u6253\\u7834\\u3002", "type": "planted", "strength": 7, "subtlety": 9, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u767d\\u5f97\\u6709\\u4e9b\\u523a\\u773c", "category": "event", "is_long_term": false, "related_characters": ["\\u739b\\u4e3d\\u4fee\\u5973", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 3}]	5	0	[{"content": "\\u83b1\\u5c14\\u5728\\u5b64\\u513f\\u9662\\u540e\\u9662\\u4e3b\\u6301\\u6349\\u8ff7\\u85cf\\uff0c\\u5e76\\u51ed\\u501f\\u75d5\\u8ff9\\u89c2\\u5bdf\\u8fde\\u7eed\\u627e\\u51fa\\u516d\\u540d\\u5b69\\u5b50\\uff0c\\u5b8c\\u6210\\u4e3b\\u89d2\\u9ad8\\u89c2\\u5bdf\\u529b\\u3001\\u597d\\u80dc\\u4e0e\\u987d\\u76ae\\u6027\\u683c\\u7684\\u96c6\\u4e2d\\u4eae\\u76f8\\u3002", "type": "transition", "importance": 0.72, "impact": "\\u4ee5\\u8f7b\\u677e\\u6e38\\u620f\\u81ea\\u7136\\u5b8c\\u6210\\u4e16\\u754c\\u73af\\u5883\\u3001\\u7fa4\\u50cf\\u5173\\u7cfb\\u548c\\u4e3b\\u89d2\\u80fd\\u529b\\u8868\\u5c42\\u7684\\u5c55\\u793a\\uff0c\\u4e3a\\u771f\\u6b63\\u7684\\u8d85\\u81ea\\u7136\\u63ed\\u793a\\u5236\\u9020\\u5bf9\\u7167\\u3002", "keyword": "\\u4eca\\u5929\\u53c2\\u52a0\\u6e38\\u620f\\u7684\\u4e00\\u5171\\u516b\\u4e2a"}, {"content": "\\u6700\\u540e\\u4e00\\u540d\\u8bfa\\u4e9a\\u6ca1\\u6709\\u7559\\u4e0b\\u660e\\u663e\\u8e2a\\u8ff9\\uff0c\\u666e\\u901a\\u63a8\\u7406\\u6682\\u65f6\\u5931\\u6548\\uff0c\\u83b1\\u5c14\\u628a\\u6ce8\\u610f\\u529b\\u8f6c\\u5411\\u8bfa\\u4e9a\\u65e9\\u6668\\u63a5\\u89e6\\u8fc7\\u7684\\u6728\\u9a6c\\u3002", "type": "conflict", "importance": 0.78, "impact": "\\u5236\\u9020\\u6e38\\u620f\\u5c42\\u9762\\u7684\\u77ed\\u6682\\u56f0\\u5c40\\uff0c\\u5e76\\u4e3a\\u83b1\\u5c14\\u4ece\\u5e38\\u89c4\\u89c2\\u5bdf\\u8f6c\\u5411\\u5f02\\u5e38\\u80fd\\u529b\\u63d0\\u4f9b\\u5408\\u7406\\u89e6\\u53d1\\u70b9\\u3002", "keyword": "\\u8bfa\\u4e9a\\u65e9\\u4e0a\\u9a91\\u8fc7\\u90a3\\u5339\\u6728\\u9a6c"}, {"content": "\\u83b1\\u5c14\\u89e6\\u78b0\\u6728\\u9a6c\\uff0c\\u770b\\u89c1\\u8bfa\\u4e9a\\u6b64\\u524d\\u5c06\\u6728\\u9a6c\\u653e\\u56de\\u5e76\\u94bb\\u8fdb\\u67f3\\u6761\\u7b50\\u7684\\u5b8c\\u6574\\u7247\\u6bb5\\uff0c\\u9996\\u6b21\\u660e\\u786e\\u5c55\\u73b0\\u89e6\\u7269\\u8bfb\\u53d6\\u8fc7\\u53bb\\u7684\\u80fd\\u529b\\u3002", "type": "revelation", "importance": 1.0, "impact": "\\u786e\\u7acb\\u6545\\u4e8b\\u6838\\u5fc3\\u8d85\\u81ea\\u7136\\u8bbe\\u5b9a\\uff0c\\u6539\\u53d8\\u8bfb\\u8005\\u5bf9\\u83b1\\u5c14\\u6b64\\u524d\\"\\u806a\\u660e\\"\\u7684\\u7406\\u89e3\\uff0c\\u5e76\\u5f00\\u542f\\u80fd\\u529b\\u6765\\u6e90\\u3001\\u89c4\\u5219\\u548c\\u4ee3\\u4ef7\\u7b49\\u4e3b\\u7ebf\\u60ac\\u5ff5\\u3002", "keyword": "\\u7537\\u5b69\\u8e72\\u4e0b\\u6765\\uff0c\\u5bf9\\u7740\\u6728\\u9a6c\\u505a\\u4e86\\u4e2a\\u5664\\u58f0\\u7684\\u624b\\u52bf"}, {"content": "\\u83b1\\u5c14\\u7f16\\u9020\\u679c\\u9171\\u5370\\u4e0e\\u8349\\u5c51\\u7ebf\\u7d22\\uff0c\\u628a\\u80fd\\u529b\\u6240\\u5f97\\u4f2a\\u88c5\\u6210\\u63a8\\u7406\\u7ed3\\u679c\\uff0c\\u987a\\u5229\\u627e\\u5230\\u8bfa\\u4e9a\\u5e76\\u8d62\\u4e0b\\u6e38\\u620f\\u3002", "type": "resolution", "importance": 0.86, "impact": "\\u89e3\\u51b3\\u7ae0\\u8282\\u8868\\u5c42\\u4efb\\u52a1\\uff0c\\u540c\\u65f6\\u5c55\\u793a\\u83b1\\u5c14\\u5f3a\\u5927\\u7684\\u4e34\\u573a\\u7f16\\u9020\\u80fd\\u529b\\u3001\\u4fdd\\u5bc6\\u610f\\u8bc6\\u548c\\u7231\\u51fa\\u98ce\\u5934\\u7684\\u6027\\u683c\\u77db\\u76fe\\u3002", "keyword": "\\u7b50\\u76d6\\u6b6a\\u4e86\\u4e00\\u70b9\\uff0c\\u8bf4\\u660e\\u6709\\u4eba\\u52a8\\u8fc7"}, {"content": "\\u739b\\u4e3d\\u4fee\\u5973\\u901a\\u8fc7\\u6728\\u9a6c\\u88c2\\u7eb9\\u8bc6\\u7834\\u83b1\\u5c14\\u4f7f\\u7528\\u80fd\\u529b\\uff0c\\u8b66\\u544a\\u5916\\u754c\\u4f1a\\u6050\\u60e7\\u3001\\u6293\\u6355\\u5e76\\u7814\\u7a76\\u672a\\u77e5\\u4e4b\\u7269\\uff0c\\u968f\\u540e\\u627f\\u8bfa\\u66ff\\u4ed6\\u5b88\\u4f4f\\u79d8\\u5bc6\\u3002", "type": "revelation", "importance": 0.98, "impact": "\\u5c06\\u8f7b\\u677e\\u6e38\\u620f\\u5347\\u7ea7\\u4e3a\\u957f\\u671f\\u751f\\u5b58\\u5371\\u673a\\uff0c\\u786e\\u7acb\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u4fdd\\u62a4\\u8005\\u5730\\u4f4d\\uff0c\\u5e76\\u4e3a\\u80fd\\u529b\\u66b4\\u9732\\u3001\\u793e\\u4f1a\\u8feb\\u5bb3\\u548c\\u4fdd\\u62a4\\u5173\\u7cfb\\u7834\\u88c2\\u57cb\\u4e0b\\u4e3b\\u7ebf\\u52a8\\u529b\\u3002", "keyword": "\\u79d8\\u5bc6\\u4e00\\u65e6\\u8ba9\\u7b2c\\u4e8c\\u4e2a\\u4eba\\u770b\\u89c1\\uff0c\\u5c31\\u4e0d\\u518d\\u53ea\\u5f52\\u4f60\\u7ba1\\u4e86"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u81ea\\u4fe1\\u3001\\u597d\\u80dc\\uff0c\\u4eab\\u53d7\\u51ed\\u89c2\\u5bdf\\u529b\\u538b\\u8fc7\\u540c\\u4f34\\u7684\\u6210\\u5c31\\u611f", "state_after": "\\u77ed\\u6682\\u610f\\u8bc6\\u5230\\u80fd\\u529b\\u66b4\\u9732\\u7684\\u5371\\u9669\\uff0c\\u4f46\\u4ecd\\u4ee5\\u73a9\\u7b11\\u548c\\u72e1\\u8fa9\\u63a9\\u9970\\u5185\\u5fc3\\u538b\\u529b", "psychological_change": "\\u83b1\\u5c14\\u4ece\\u5b8c\\u5168\\u6c89\\u6d78\\u4e8e\\u6e38\\u620f\\u548c\\u70ab\\u8000\\u806a\\u660e\\uff0c\\u8f6c\\u4e3a\\u9762\\u5bf9\\u80fd\\u529b\\u53ef\\u80fd\\u62db\\u81f4\\u6293\\u6355\\u4e0e\\u4f24\\u5bb3\\u7684\\u73b0\\u5b9e\\u3002\\u4ed6\\u8868\\u9762\\u56de\\u7b54\\"\\u5047\\u7684\\"\\u5e76\\u7ee7\\u7eed\\u5b09\\u7b11\\uff0c\\u5b9e\\u9645\\u5df2\\u7ecf\\u542c\\u61c2\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u8b66\\u544a\\uff0c\\u6700\\u7ec8\\u4e3b\\u52a8\\u628a\\u88c2\\u7eb9\\u6728\\u9a6c\\u85cf\\u5230\\u6742\\u7269\\u8f66\\u5e95\\u90e8\\uff0c\\u8bf4\\u660e\\u98ce\\u9669\\u610f\\u8bc6\\u5df2\\u7ecf\\u5f00\\u59cb\\u8f6c\\u5316\\u4e3a\\u884c\\u52a8\\u3002", "key_event": "\\u89e6\\u78b0\\u6728\\u9a6c\\u8bfb\\u53d6\\u8bfa\\u4e9a\\u7684\\u85cf\\u8eab\\u8fc7\\u7a0b\\uff0c\\u968f\\u540e\\u88ab\\u739b\\u4e3d\\u4fee\\u5973\\u53d1\\u73b0\\u6728\\u9a6c\\u88c2\\u7eb9\\u5e76\\u63a5\\u53d7\\u4fdd\\u5bc6\\u6559\\u80b2", "relationship_changes": {"\\u739b\\u4e3d\\u4fee\\u5973": "\\u53cc\\u65b9\\u5bf9\\u5f7c\\u6b64\\u7684\\u79d8\\u5bc6\\u5171\\u8bc6\\u8fdb\\u4e00\\u6b65\\u660e\\u786e\\uff1b\\u83b1\\u5c14\\u786e\\u8ba4\\u5979\\u662f\\u77e5\\u60c5\\u8005\\u548c\\u4fdd\\u62a4\\u8005\\uff0c\\u4eb2\\u5bc6\\u4e0e\\u4f9d\\u8d56\\u52a0\\u6df1", "\\u8bfa\\u4e9a": "\\u901a\\u8fc7\\u5f02\\u5e38\\u80fd\\u529b\\u627e\\u5230\\u8bfa\\u4e9a\\uff0c\\u5e76\\u7528\\u4f2a\\u9020\\u63a8\\u7406\\u4fdd\\u62a4\\u81ea\\u5df1\\u7684\\u79d8\\u5bc6\\uff0c\\u7ef4\\u6301\\u4e86\\u5e74\\u957f\\u5b69\\u5b50\\u5bf9\\u5e74\\u5e7c\\u5b69\\u5b50\\u7684\\u7167\\u987e\\u59ff\\u6001", "\\u6258\\u6bd4": "\\u7ade\\u4e89\\u6027\\u53cb\\u8c0a\\u5f97\\u5230\\u5f3a\\u5316\\uff0c\\u5f62\\u6210\\u4e92\\u76f8\\u62c6\\u53f0\\u4f46\\u5e76\\u65e0\\u6076\\u610f\\u7684\\u540c\\u4f34\\u5173\\u7cfb", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u514b\\u52b3\\u79bb\\u5f00\\u65f6\\u6295\\u6765\\u9ed8\\u5951\\u773c\\u795e\\uff0c\\u4f53\\u73b0\\u4e24\\u4eba\\u5df2\\u6709\\u719f\\u6089\\u800c\\u4eb2\\u8fd1\\u7684\\u540c\\u4f34\\u4e92\\u52a8"}}, {"character_name": "\\u739b\\u4e3d\\u4fee\\u5973", "survival_status": null, "state_before": "\\u6e29\\u67d4\\u65c1\\u89c2\\u5b69\\u5b50\\u4eec\\u6e38\\u620f\\uff0c\\u5bf9\\u83b1\\u5c14\\u4fdd\\u6301\\u5173\\u6ce8\\u548c\\u5305\\u5bb9", "state_after": "\\u660e\\u786e\\u8868\\u73b0\\u51fa\\u5bf9\\u83b1\\u5c14\\u80fd\\u529b\\u66b4\\u9732\\u7684\\u5fe7\\u8651\\uff0c\\u5e76\\u4e3b\\u52a8\\u627f\\u62c5\\u5b88\\u5bc6\\u4e0e\\u5f15\\u5bfc\\u8d23\\u4efb", "psychological_change": "\\u5979\\u4ece\\u65e5\\u5e38\\u7167\\u6599\\u8005\\u81ea\\u7136\\u8f6c\\u5165\\u79d8\\u5bc6\\u4fdd\\u62a4\\u8005\\u8eab\\u4efd\\u3002\\u9762\\u5bf9\\u83b1\\u5c14\\u4f5c\\u5f0a\\u548c\\u635f\\u574f\\u6728\\u9a6c\\uff0c\\u5979\\u6ca1\\u6709\\u60e9\\u7f5a\\u6216\\u903c\\u95ee\\uff0c\\u800c\\u662f\\u7528\\u81ea\\u8eab\\u7ae5\\u5e74\\u7ecf\\u9a8c\\u964d\\u4f4e\\u83b1\\u5c14\\u7684\\u9632\\u5fa1\\uff0c\\u518d\\u6e05\\u695a\\u8bf4\\u660e\\u5916\\u754c\\u98ce\\u9669\\uff0c\\u4f53\\u73b0\\u6e29\\u67d4\\u3001\\u7406\\u6027\\u4e0e\\u6f5c\\u5728\\u7684\\u6c89\\u91cd\\u5fe7\\u8651\\u3002", "key_event": "\\u901a\\u8fc7\\u6728\\u9a6c\\u65b0\\u51fa\\u73b0\\u7684\\u88c2\\u7eb9\\u8bc6\\u7834\\u83b1\\u5c14\\u4f7f\\u7528\\u80fd\\u529b\\uff0c\\u5e76\\u544a\\u8beb\\u4ed6\\u79d8\\u5bc6\\u4e00\\u65e6\\u88ab\\u7b2c\\u4e8c\\u4e2a\\u4eba\\u770b\\u89c1\\u4fbf\\u4f1a\\u5931\\u63a7", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u4e00\\u822c\\u7684\\u629a\\u517b\\u4e0e\\u7ba1\\u6559\\u5173\\u7cfb\\u8fdb\\u4e00\\u6b65\\u663e\\u9732\\u4e3a\\u77e5\\u6653\\u6838\\u5fc3\\u79d8\\u5bc6\\u3001\\u613f\\u610f\\u627f\\u62c5\\u98ce\\u9669\\u7684\\u4fdd\\u62a4\\u5173\\u7cfb", "\\u827e\\u62c9": "\\u770b\\u89c1\\u827e\\u62c9\\u8fdd\\u89c4\\u722c\\u949f\\u697c\\u5374\\u6ca1\\u6709\\u5f53\\u4f17\\u62c6\\u7a7f\\uff0c\\u7ef4\\u6301\\u6e29\\u548c\\u800c\\u6709\\u5206\\u5bf8\\u7684\\u7ba1\\u6559\\u65b9\\u5f0f", "\\u5b64\\u513f\\u9662\\u5b69\\u5b50\\u4eec": "\\u901a\\u8fc7\\u5206\\u53d1\\u9762\\u5305\\u3001\\u63d0\\u9192\\u5b89\\u5168\\u548c\\u5b89\\u6392\\u52b3\\u52a8\\uff0c\\u7ee7\\u7eed\\u5de9\\u56fa\\u7167\\u6599\\u8005\\u4e0e\\u79e9\\u5e8f\\u7ef4\\u62a4\\u8005\\u8eab\\u4efd"}}, {"character_name": "\\u6258\\u6bd4", "survival_status": null, "state_before": "\\u79ef\\u6781\\u53c2\\u4e0e\\u6e38\\u620f\\uff0c\\u76f8\\u4fe1\\u81ea\\u5df1\\u80fd\\u591f\\u85cf\\u597d\\u5e76\\u9003\\u8fc7\\u83b1\\u5c14\\u641c\\u7d22", "state_after": "\\u56e0\\u6700\\u5148\\u66b4\\u9732\\u800c\\u4e0d\\u670d\\u6c14\\uff0c\\u7ee7\\u800c\\u671f\\u5f85\\u83b1\\u5c14\\u5931\\u8d25\\uff0c\\u6700\\u7ec8\\u63a5\\u53d7\\u5168\\u5458\\u843d\\u8d25", "psychological_change": "\\u6258\\u6bd4\\u7684\\u60c5\\u7eea\\u4ece\\u81ea\\u4fe1\\u8f6c\\u4e3a\\u5634\\u786c\\u548c\\u5e78\\u707e\\u4e50\\u7978\\uff0c\\u4f46\\u6574\\u4f53\\u4fdd\\u6301\\u513f\\u7ae5\\u5f0f\\u7ade\\u4e89\\u5fc3\\uff0c\\u6ca1\\u6709\\u5347\\u7ea7\\u4e3a\\u771f\\u6b63\\u654c\\u610f\\u3002", "key_event": "\\u56e0\\u978b\\u5e95\\u7f3a\\u53e3\\u88ab\\u83b1\\u5c14\\u8bc6\\u7834\\u85cf\\u8eab\\u5904\\uff0c\\u53c8\\u5728\\u5bfb\\u627e\\u8bfa\\u4e9a\\u65f6\\u9519\\u8bef\\u76f8\\u4fe1\\u83b1\\u5c14\\u7f16\\u51fa\\u7684\\u8349\\u5c51\\u8bc1\\u636e", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u7ade\\u4e89\\u4e0e\\u4e92\\u76f8\\u5410\\u69fd\\u589e\\u52a0\\uff0c\\u4f46\\u4ecd\\u5c5e\\u4e8e\\u4eb2\\u5bc6\\u540c\\u4f34\\u95f4\\u7684\\u6e38\\u620f\\u6027\\u5bf9\\u6297"}}, {"character_name": "\\u827e\\u62c9", "survival_status": null, "state_before": "\\u8c03\\u76ae\\u3001\\u81ea\\u4fe1\\uff0c\\u5229\\u7528\\u5047\\u978b\\u8bef\\u5bfc\\u83b1\\u5c14\\u5e76\\u8fdd\\u89c4\\u722c\\u4e0a\\u949f\\u697c\\u5e73\\u53f0", "state_after": "\\u88ab\\u83b1\\u5c14\\u8bc6\\u7834\\u540e\\u8ba4\\u8f93\\uff0c\\u5e76\\u56e0\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u63d0\\u9192\\u800c\\u5fc3\\u865a\\u8eb2\\u907f", "psychological_change": "\\u4ece\\u4e3a\\u8ba1\\u7b56\\u6210\\u529f\\u800c\\u5077\\u7b11\\u8f6c\\u4e3a\\u88ab\\u6293\\u540e\\u7684\\u4e0d\\u7518\\u4e0e\\u5fc3\\u865a\\uff0c\\u7a81\\u51fa\\u5979\\u6d3b\\u6cfc\\u3001\\u6562\\u5192\\u9669\\u4f46\\u754f\\u60e7\\u6b63\\u5f0f\\u7ba1\\u6559\\u7684\\u4e00\\u9762\\u3002", "key_event": "\\u7528\\u5e8a\\u5355\\u540e\\u7684\\u7a7a\\u978b\\u5236\\u9020\\u5047\\u85cf\\u8eab\\u70b9\\uff0c\\u5374\\u56e0\\u5899\\u7070\\u75d5\\u8ff9\\u548c\\u978b\\u5e26\\u66b4\\u9732", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u8ba4\\u53ef\\u5176\\u89c2\\u5bdf\\u529b\\u4f46\\u4ecd\\u4ee5\\u62b1\\u6028\\u56de\\u5e94\\uff0c\\u7ef4\\u6301\\u8f7b\\u677e\\u7684\\u73a9\\u4f34\\u5173\\u7cfb", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u56e0\\u8fdd\\u89c4\\u63a5\\u8fd1\\u949f\\u697c\\u800c\\u4ea7\\u751f\\u77ed\\u6682\\u5fc3\\u865a\\uff0c\\u7ba1\\u6559\\u5173\\u7cfb\\u65e0\\u5b9e\\u8d28\\u6539\\u53d8"}}, {"character_name": "\\u9a6c\\u4e01", "survival_status": null, "state_before": "\\u611f\\u5192\\u672a\\u6108\\u4ecd\\u53c2\\u4e0e\\u6e38\\u620f\\uff0c\\u52aa\\u529b\\u85cf\\u5728\\u65e7\\u9e21\\u820d\\u4e2d", "state_after": "\\u56e0\\u65e0\\u6cd5\\u538b\\u4f4f\\u54b3\\u55fd\\u800c\\u88ab\\u627e\\u5230\\uff0c\\u52a0\\u5165\\u843d\\u8d25\\u8005\\u961f\\u4f0d", "psychological_change": "\\u7ae0\\u8282\\u672a\\u5448\\u73b0\\u663e\\u8457\\u6210\\u957f\\uff0c\\u4e3b\\u8981\\u901a\\u8fc7\\u5e26\\u75c5\\u53c2\\u4e0e\\u6e38\\u620f\\u4f53\\u73b0\\u5176\\u878d\\u5165\\u96c6\\u4f53\\u7684\\u613f\\u671b\\u3002", "key_event": "\\u5728\\u65e7\\u9e21\\u820d\\u4e2d\\u56e0\\u54b3\\u55fd\\u58f0\\u66b4\\u9732\\u85cf\\u8eab\\u4f4d\\u7f6e", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4f5c\\u4e3a\\u6e38\\u620f\\u5bf9\\u624b\\u88ab\\u8bc6\\u7834\\uff0c\\u65e0\\u5b9e\\u8d28\\u5173\\u7cfb\\u53d8\\u5316"}}, {"character_name": "\\u73cd\\u59ae", "survival_status": null, "state_before": "\\u8bd5\\u56fe\\u501f\\u6c34\\u7f38\\u906e\\u6321\\u8eab\\u4f53\\u5b8c\\u6210\\u85cf\\u533f", "state_after": "\\u56e0\\u7ea2\\u8fab\\u5b50\\u9732\\u51fa\\u800c\\u88ab\\u83b1\\u5c14\\u53d1\\u73b0", "psychological_change": "\\u6ca1\\u6709\\u660e\\u663e\\u5fc3\\u7406\\u8f6c\\u6298\\uff0c\\u627f\\u62c5\\u5c55\\u793a\\u83b1\\u5c14\\u89c2\\u5bdf\\u529b\\u4ee5\\u53ca\\u4e30\\u5bcc\\u5b64\\u513f\\u9662\\u7fa4\\u50cf\\u7684\\u529f\\u80fd\\u3002", "key_event": "\\u85cf\\u5728\\u6c34\\u7f38\\u540e\\u5374\\u9732\\u51fa\\u4e00\\u5c0f\\u622a\\u7ea2\\u8fab\\u5b50", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6e38\\u620f\\u6027\\u5bf9\\u6297\\u7ed3\\u675f\\uff0c\\u65e0\\u5b9e\\u8d28\\u5173\\u7cfb\\u53d8\\u5316"}}, {"character_name": "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "survival_status": null, "state_before": "\\u4e00\\u8fb9\\u85cf\\u533f\\u4e00\\u8fb9\\u5077\\u5403\\u7cd6\\uff0c\\u81ea\\u4ee5\\u4e3a\\u6ca1\\u6709\\u7559\\u4e0b\\u7cd6\\u7eb8\\u8bc1\\u636e", "state_after": "\\u53d1\\u73b0\\u7cd6\\u5728\\u53e3\\u888b\\u4e2d\\u878d\\u5316\\u540e\\u61ca\\u607c\\uff0c\\u5e76\\u5bf9\\u88ab\\u739b\\u4e3d\\u4fee\\u5973\\u5355\\u72ec\\u7559\\u4e0b\\u7684\\u83b1\\u5c14\\u8868\\u793a\\u540c\\u60c5", "psychological_change": "\\u4ece\\u4fa5\\u5e78\\u548c\\u8d2a\\u5634\\u8f6c\\u4e3a\\u5c34\\u5c2c\\uff0c\\u518d\\u4ee5\\u9ed8\\u5951\\u773c\\u795e\\u53c2\\u4e0e\\u540c\\u4f34\\u95f4\\u7684\\u60c5\\u611f\\u4e92\\u52a8\\uff0c\\u8868\\u73b0\\u51fa\\u6d3b\\u6cfc\\u4e14\\u4e0e\\u83b1\\u5c14\\u719f\\u6089\\u7684\\u4e00\\u9762\\u3002", "key_event": "\\u56e0\\u7cd6\\u7eb8\\u548c\\u878d\\u5316\\u7684\\u7cd6\\u66b4\\u9732\\u4f4d\\u7f6e\\uff0c\\u79bb\\u5f00\\u65f6\\u5411\\u83b1\\u5c14\\u9012\\u51fa\\u81ea\\u6c42\\u591a\\u798f\\u7684\\u773c\\u795e", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u901a\\u8fc7\\u79bb\\u5f00\\u65f6\\u7684\\u9ed8\\u5951\\u773c\\u795e\\u5f3a\\u5316\\u4eb2\\u8fd1\\u7684\\u540c\\u4f34\\u611f", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u7ee7\\u7eed\\u5904\\u4e8e\\u88ab\\u7167\\u6599\\u548c\\u7ba1\\u6559\\u7684\\u4f4d\\u7f6e\\uff0c\\u65e0\\u5b9e\\u8d28\\u53d8\\u5316"}}, {"character_name": "\\u8bfa\\u4e9a", "survival_status": null, "state_before": "\\u80c6\\u5c0f\\u4f46\\u5e0c\\u671b\\u85cf\\u5230\\u6700\\u540e\\uff0c\\u9f13\\u8d77\\u52c7\\u6c14\\u94bb\\u5165\\u88c5\\u6709\\u6bdb\\u6bef\\u7684\\u67f3\\u6761\\u7b50", "state_after": "\\u88ab\\u53d1\\u73b0\\u540e\\u7f9e\\u7a98\\uff0c\\u540c\\u65f6\\u5bf9\\u83b1\\u5c14\\u65e0\\u6240\\u4e0d\\u77e5\\u7684\\u8868\\u73b0\\u611f\\u5230\\u60ca\\u8bb6", "psychological_change": "\\u8bfa\\u4e9a\\u867d\\u7136\\u80c6\\u5c0f\\uff0c\\u5374\\u6210\\u529f\\u9009\\u62e9\\u4e86\\u8d85\\u51fa\\u83b1\\u5c14\\u5e38\\u89c4\\u63a8\\u7406\\u8303\\u56f4\\u7684\\u85cf\\u8eab\\u5904\\uff0c\\u4f53\\u73b0\\u51fa\\u6709\\u9650\\u4f46\\u771f\\u5b9e\\u7684\\u52c7\\u6c14\\u548c\\u673a\\u7075\\uff1b\\u88ab\\u53d1\\u73b0\\u540e\\u4ecd\\u7ef4\\u6301\\u5bf9\\u83b1\\u5c14\\u7684\\u4fe1\\u670d\\u3002", "key_event": "\\u5c06\\u6728\\u9a6c\\u63a8\\u56de\\u6742\\u7269\\u8f66\\u540e\\u8eb2\\u8fdb\\u67f3\\u6761\\u7b50\\uff0c\\u6700\\u7ec8\\u88ab\\u83b1\\u5c14\\u901a\\u8fc7\\u8bfb\\u53d6\\u6728\\u9a6c\\u8bb0\\u5fc6\\u627e\\u5230", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u5bf9\\u83b1\\u5c14\\u7684\\u806a\\u660e\\u4ea7\\u751f\\u66f4\\u5f3a\\u4fe1\\u670d\\uff0c\\u4f46\\u5e76\\u4e0d\\u77e5\\u9053\\u81ea\\u5df1\\u5b9e\\u9645\\u662f\\u88ab\\u5f02\\u5e38\\u80fd\\u529b\\u627e\\u5230"}}]	[{"location": "\\u6668\\u661f\\u5b64\\u513f\\u9662\\u540e\\u9662", "atmosphere": "\\u9633\\u5149\\u660e\\u4eae\\u3001\\u751f\\u6d3b\\u6c14\\u606f\\u6d53\\u539a\\uff0c\\u5145\\u6ee1\\u513f\\u7ae5\\u6e38\\u620f\\u7684\\u55a7\\u95f9\\u4e0e\\u7ae5\\u8da3", "duration": "\\u7ea6\\u5341\\u81f3\\u5341\\u4e94\\u5206\\u949f"}, {"location": "\\u6742\\u7269\\u8f66\\u4e0e\\u67f3\\u6761\\u7b50\\u9644\\u8fd1", "atmosphere": "\\u8868\\u9762\\u4ecd\\u662f\\u6e38\\u620f\\u6c1b\\u56f4\\uff0c\\u89e6\\u78b0\\u6728\\u9a6c\\u540e\\u77ed\\u6682\\u8f6c\\u4e3a\\u9694\\u6c34\\u822c\\u6a21\\u7cca\\u3001\\u8be1\\u5f02\\u7684\\u8d85\\u81ea\\u7136\\u4f53\\u9a8c", "duration": "\\u7ea6\\u4e24\\u81f3\\u4e09\\u5206\\u949f"}, {"location": "\\u53a8\\u623f\\u5916\\u53f0\\u9636\\u4e0e\\u6742\\u7269\\u8f66\\u65c1", "atmosphere": "\\u9762\\u5305\\u9999\\u6c14\\u5e26\\u6765\\u5bb6\\u5ead\\u5f0f\\u6e29\\u6696\\uff0c\\u4f46\\u8c08\\u8bdd\\u5185\\u5bb9\\u9010\\u6e10\\u4e25\\u8083\\uff0c\\u7ed3\\u5c3e\\u7b3c\\u7f69\\u514b\\u5236\\u7684\\u4e0d\\u7965\\u611f", "duration": "\\u7ea6\\u4e94\\u81f3\\u5341\\u5206\\u949f"}]	varied	9.1	8.9	9.1	9.3	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 9.1/10\n  节奏把控: 8.9/10\n  吸引力: 9.1/10\n  连贯性: 9.3/10\n\n【剧情阶段】开端\n\n【钩子分析】共6个\n  • [认知] 莱尔通过鞋印、墙灰、咳嗽和糖纸等微小痕迹连续找出藏匿者，迅速建立其超常观察力与推理能力，让普通捉迷藏... (强度:7)\n  • [悬念] 莱尔接触木马后，视野突然切换到物品曾经见证的场景，揭示他拥有读取物品残留记忆的异常能力，也引出能力来... (强度:9)\n  • [冲突] 玛丽修女指出外界会恐惧、抓捕乃至拆解异常之物，将儿童游戏中的小秘密骤然提升为莱尔可能遭受社会迫害的生... (强度:9)\n\n【伏笔分析】埋下6个, 回收0个\n\n【冲突分析】\n  类型: 人与人, 人与己, 人与社会\n  强度: 7/10\n  进度: 25%\n	[]	\N	0.43	0.35	2026-08-06 15:35:21.577584
b3f095c4-3fcb-442a-badf-d67521a2b762	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	发展	7	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	压抑愧疚	0.7	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u6848\\u53d1\\u524d\\u4e09\\u5929\\u6709\\u4e09\\u4e2a\\u4eba\\u5192\\u5145\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\uff0c\\u5728\\u5b64\\u513f\\u9662\\u6253\\u542c\\u5f02\\u80fd\\u8005\\uff0c\\u4ed6\\u4eec\\u7684\\u8eab\\u4efd\\u548c\\u76ee\\u7684\\u6210\\u8c1c\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u6848\\u53d1\\u524d\\u4e09\\u5929\\uff0c\\u6709\\u4e09\\u4e2a\\u4eba\\u6765\\u8fc7\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u5bf9\\u81ea\\u5df1\\u7684\\u59d3\\u540d\\u4fdd\\u5bc6\\uff0c\\u5374\\u88ab\\u83b1\\u5c14\\u76f4\\u63a5\\u53eb\\u51fa\\uff0c\\u6697\\u793a\\u4ed6\\u53ef\\u80fd\\u5728\\u523b\\u610f\\u8bd5\\u63a2\\u83b1\\u5c14\\u7684\\u7279\\u6b8a\\u80fd\\u529b\\u3002", "strength": 7, "position": "\\u7ed3\\u5c3e", "keyword": "\\u6211\\u8fdb\\u95e8\\u540e\\u53ea\\u8bf4\\u4e86\\u6240\\u5c5e\\u90e8\\u95e8\\uff0c\\u6ca1\\u6709\\u62a5\\u59d3\\u540d\\u3002"}, {"type": "\\u60c5\\u611f", "content": "\\u514b\\u52b3\\u5e0c\\u671b\\u83b1\\u5c14\\u7684\\u80fd\\u529b\\u80fd\\u9006\\u8f6c\\u65f6\\u95f4\\u6551\\u56de\\u739b\\u4e3d\\u4fee\\u5973\\uff0c\\u4f46\\u83b1\\u5c14\\u53ea\\u80fd\\u770b\\u89c1\\u8fc7\\u53bb\\uff0c\\u65e0\\u6cd5\\u6539\\u53d8\\uff0c\\u4eb2\\u4eba\\u6c38\\u901d\\u7684\\u65e0\\u529b\\u611f\\u523a\\u75db\\u8bfb\\u8005\\u3002", "strength": 9, "position": "\\u5f00\\u5934", "keyword": "\\u80fd\\u8ba9\\u4eba\\u6d3b\\u8fc7\\u6765\\u5417\\uff1f"}, {"type": "\\u8ba4\\u77e5", "content": "\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u7684\\u8bbe\\u5b9a\\u63ed\\u5f00\\u4e86\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u6280\\u672f\\u57fa\\u7840\\uff0c\\u5f02\\u80fd\\u4e0d\\u518d\\u662f\\u5b8c\\u5168\\u4e0d\\u53ef\\u8ffd\\u8e2a\\u7684\\u529b\\u91cf\\u3002", "strength": 6, "position": "\\u4e2d\\u6bb5", "keyword": "\\u5f02\\u80fd\\u53d1\\u52a8\\u6216\\u5f02\\u5e38\\u5668\\u7269\\u6d3b\\u52a8\\u65f6\\uff0c\\u5468\\u56f4\\u7c92\\u5b50\\u6d53\\u5ea6\\u4f1a\\u53d1\\u751f\\u53d8\\u5316"}, {"type": "\\u51b2\\u7a81", "content": "\\u514b\\u52b3\\u5e0c\\u671b\\u83b1\\u5c14\\u5c1d\\u8bd5\\u5176\\u4ed6\\u80fd\\u529b\\u7528\\u9014\\uff0c\\u83b1\\u5c14\\u5374\\u65ad\\u7136\\u5426\\u5b9a\\uff0c\\u4e24\\u4eba\\u4e4b\\u95f4\\u7684\\u9690\\u6027\\u6469\\u64e6\\u4e00\\u89e6\\u5373\\u53d1\\u3002", "strength": 6, "position": "\\u5f00\\u5934", "keyword": "\\u4e5f\\u8bb8\\u8fd8\\u6709\\u522b\\u7684\\u7528\\u6cd5"}]	5	\N	[{"title": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u5bf9\\u83b1\\u5c14\\u7684\\u523b\\u610f\\u8bd5\\u63a2", "content": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u8fdb\\u95e8\\u540e\\u4e0d\\u62a5\\u59d3\\u540d\\uff0c\\u5374\\u5728\\u7ed3\\u5c3e\\u8ffd\\u95ee\\u83b1\\u5c14\\u5982\\u4f55\\u77e5\\u9053\\u81ea\\u5df1\\u7684\\u540d\\u5b57\\uff0c\\u8868\\u9762\\u88ab\\u5de5\\u724c\\u89e3\\u91ca\\uff0c\\u4f46\\u96f7\\u91d1\\u7eb3\\u5fb7\\u5df2\\u5f00\\u59cb\\u6000\\u7591\\u83b1\\u5c14\\u62e5\\u6709\\u60c5\\u62a5\\u83b7\\u5f97\\u6216\\u611f\\u77e5\\u80fd\\u529b\\u3002\\u8fd9\\u53ef\\u80fd\\u662f\\u4ed6\\u65e5\\u540e\\u91cd\\u70b9\\u8c03\\u67e5\\u83b1\\u5c14\\u7684\\u8d77\\u70b9\\u3002", "type": "planted", "strength": 7, "subtlety": 7, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u4f60\\u600e\\u4e48\\u77e5\\u9053\\u6211\\u53eb\\u96f7\\u91d1\\u7eb3\\u5fb7\\uff1f", "category": "mystery", "is_long_term": false, "related_characters": ["\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 10}]	1	0	[{"content": "\\u83b1\\u5c14\\u900f\\u9732\\u81ea\\u5df1\\u80fd\\u901a\\u8fc7\\u7269\\u54c1\\u770b\\u5230\\u8fc7\\u53bb\\uff0c\\u4f46\\u65e0\\u6cd5\\u6539\\u53d8\\u4efb\\u4f55\\u4e8b\\uff0c\\u63ed\\u793a\\u4e3b\\u89d2\\u80fd\\u529b\\u7684\\u8fb9\\u754c\\u3002", "type": "revelation", "importance": 0.8, "impact": "\\u5960\\u5b9a\\u60b2\\u5267\\u57fa\\u8c03\\uff0c\\u5f3a\\u5316\\u4eba\\u7269\\u52a8\\u673a\\uff0c\\u89e3\\u91ca\\u4ed6\\u4e3a\\u4f55\\u65e0\\u6cd5\\u6551\\u56de\\u739b\\u4e3d\\u4fee\\u5973\\u3002", "keyword": "\\u6211\\u80fd\\u4ece\\u7269\\u54c1\\u7684\\u89c6\\u89d2\\u770b\\u5230\\u8fc7\\u53bb\\u3002\\u53ea\\u80fd\\u770b\\u89c1\\u3002"}, {"content": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u8868\\u793a\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u56e0\\u76d1\\u6d4b\\u5230\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u5f02\\u5e38\\u800c\\u4ecb\\u5165\\u5b64\\u513f\\u9662\\u4e8b\\u4ef6\\uff0c\\u5f15\\u5165\\u4e16\\u754c\\u89c2\\u6838\\u5fc3\\u8bbe\\u5b9a\\u3002", "type": "revelation", "importance": 0.7, "impact": "\\u8bf4\\u660e\\u5b98\\u65b9\\u8ffd\\u8e2a\\u673a\\u5236\\uff0c\\u4f7f\\u5f02\\u80fd\\u4e8b\\u4ef6\\u5177\\u5907\\u53ef\\u68c0\\u6d4b\\u6027\\u3002", "keyword": "\\u4e1c\\u90ca\\u76d1\\u6d4b\\u88c5\\u7f6e\\u8bb0\\u5f55\\u5230\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u6d53\\u5ea6\\u7a81\\u7136\\u8d85\\u8fc7\\u5b89\\u5168\\u9608\\u503c"}, {"content": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u8be2\\u95ee\\u5b64\\u513f\\u9662\\u662f\\u5426\\u6709\\u5f02\\u80fd\\u8005\\uff0c\\u514b\\u52b3\\u53f3\\u624b\\u7f29\\u56de\\u684c\\u4e0b\\uff0c\\u4e24\\u4eba\\u90fd\\u672a\\u900f\\u9732\\u771f\\u5b9e\\u4fe1\\u606f\\u3002", "type": "conflict", "importance": 0.7, "impact": "\\u5f3a\\u5316\\u7ba1\\u7406\\u5c40\\u4e0e\\u5f02\\u80fd\\u8005\\u4e4b\\u95f4\\u7684\\u7d27\\u5f20\\u5173\\u7cfb\\uff0c\\u4e5f\\u4e3a\\u514b\\u52b3\\u7684\\u8eab\\u4efd\\u57cb\\u4e0b\\u7591\\u70b9\\u3002", "keyword": "\\u5b64\\u513f\\u9662\\u91cc\\uff0c\\u6709\\u6ca1\\u6709\\u4eba\\u62e5\\u6709\\u5f02\\u80fd\\uff1f"}, {"content": "\\u83b1\\u5c14\\u548c\\u514b\\u52b3\\u544a\\u77e5\\u96f7\\u91d1\\u7eb3\\u5fb7\\u66fe\\u6709\\u5192\\u5145\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u795e\\u79d8\\u4eba\\u6765\\u8bbf\\uff0c\\u8c03\\u67e5\\u65b9\\u5411\\u8f6c\\u5411\\u65b0\\u7684\\u7ebf\\u7d22\\u3002", "type": "transition", "importance": 0.7, "impact": "\\u4e3a\\u6545\\u4e8b\\u63d0\\u4f9b\\u65b0\\u7684\\u8ffd\\u67e5\\u76ee\\u6807\\uff0c\\u4f7f\\u771f\\u51f6\\u7ebf\\u7d22\\u6d6e\\u51fa\\u6c34\\u9762\\u3002", "keyword": "\\u6848\\u53d1\\u524d\\u4e09\\u5929\\uff0c\\u6709\\u4e09\\u4e2a\\u4eba\\u6765\\u8fc7\\u3002\\u7070\\u8272\\u5927\\u8863\\u3002"}, {"content": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u8ffd\\u95ee\\u83b1\\u5c14\\u5982\\u4f55\\u77e5\\u9053\\u81ea\\u5df1\\u7684\\u59d3\\u540d\\uff0c\\u5374\\u88ab\\u514b\\u52b3\\u548c\\u83b1\\u5c14\\u540c\\u65f6\\u6307\\u8ba4\\u5de5\\u724c\\uff0c\\u5316\\u89e3\\u5c34\\u5c2c\\u5374\\u57cb\\u4e0b\\u66f4\\u591a\\u7591\\u4e91\\u3002", "type": "resolution", "importance": 0.6, "impact": "\\u6682\\u65f6\\u89e3\\u51b3\\u5c0f\\u5371\\u673a\\uff0c\\u4f46\\u8ba9\\u96f7\\u91d1\\u7eb3\\u5fb7\\u5bf9\\u83b1\\u5c14\\u4ea7\\u751f\\u66f4\\u591a\\u7591\\u5fc3\\u3002", "keyword": "\\u5148\\u751f\\uff0c\\u4f60\\u7684\\u5de5\\u724c\\u3002"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u60b2\\u75db\\u4f46\\u514b\\u5236\\uff0c\\u56de\\u907f\\u8c08\\u8bba\\u80fd\\u529b", "state_after": "\\u5766\\u767d\\u5e76\\u76f4\\u9762\\u80fd\\u529b\\u5c40\\u9650\\uff0c\\u4f46\\u5bf9\\u771f\\u76f8\\u66f4\\u52a0\\u575a\\u5b9a", "psychological_change": "\\u5728\\u514b\\u52b3\\u7684\\u8ffd\\u95ee\\u4e0b\\u627f\\u8ba4\\u81ea\\u5df1\\u65e0\\u6cd5\\u6539\\u53d8\\u8fc7\\u53bb\\uff0c\\u5185\\u5fc3\\u4ea7\\u751f\\u6127\\u759a\\uff0c\\u4f46\\u8fd9\\u4e5f\\u4fc3\\u4f7f\\u4ed6\\u66f4\\u51b3\\u610f\\u8ffd\\u67e5\\u51f6\\u624b\\uff1b\\u540c\\u65f6\\u5f00\\u59cb\\u6000\\u7591\\u96f7\\u91d1\\u7eb3\\u5fb7\\u5728\\u523b\\u610f\\u8bd5\\u63a2\\u81ea\\u5df1\\u3002", "key_event": "\\u5411\\u514b\\u52b3\\u5766\\u767d\\u80fd\\u529b\\u672c\\u8d28\\uff1b\\u5411\\u96f7\\u91d1\\u7eb3\\u5fb7\\u63d0\\u4f9b\\u5192\\u5145\\u8005\\u7ebf\\u7d22", "relationship_changes": {"\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u56e0\\u5766\\u767d\\u80fd\\u529b\\u800c\\u52a0\\u6df1\\u4fe1\\u4efb\\uff0c\\u4f46\\u540c\\u65f6\\u80cc\\u8d1f\\u6127\\u759a", "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279": "\\u5f00\\u59cb\\u6000\\u7591\\u5bf9\\u65b9\\u523b\\u610f\\u8bd5\\u63a2"}}, {"character_name": "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "survival_status": null, "state_before": "\\u5931\\u7720\\u3001\\u60b2\\u4f24\\uff0c\\u6267\\u7740\\u4e8e\\u9006\\u8f6c\\u60e8\\u5267", "state_after": "\\u538b\\u6291\\u60c5\\u7eea\\uff0c\\u8f6c\\u5411\\u914d\\u5408\\u8c03\\u67e5", "psychological_change": "\\u5728\\u83b1\\u5c14\\u5766\\u767d\\u540e\\u610f\\u8bc6\\u5230\\u65e0\\u6cd5\\u6539\\u53d8\\u8fc7\\u53bb\\uff0c\\u5c06\\u60b2\\u4f24\\u8f6c\\u5316\\u4e3a\\u8ffd\\u67e5\\u52a8\\u529b\\uff0c\\u540c\\u65f6\\u66f4\\u60f3\\u5b88\\u62a4\\u83b1\\u5c14\\uff1b\\u5728\\u96f7\\u91d1\\u7eb3\\u5fb7\\u9762\\u524d\\u542c\\u5230\\u5f02\\u80fd\\u95ee\\u9898\\u65f6\\u53f3\\u624b\\u7f29\\u56de\\u684c\\u4e0b\\uff0c\\u663e\\u9732\\u9690\\u85cf\\u79d8\\u5bc6\\u7684\\u8b66\\u89c9\\u3002", "key_event": "\\u8ffd\\u95ee\\u83b1\\u5c14\\u80fd\\u529b\\u540e\\u6c89\\u9ed8\\u5403\\u5149\\u7096\\u83dc\\uff1b\\u5728\\u4f1a\\u8bae\\u5ba4\\u9690\\u7792\\u5f02\\u80fd\\u76f8\\u5173\\u53cd\\u5e94", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4f9d\\u8d56\\u548c\\u4fe1\\u4efb\\u589e\\u5f3a"}}, {"character_name": "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279", "survival_status": null, "state_before": "\\u5b98\\u65b9\\u3001\\u758f\\u79bb\\uff0c\\u638c\\u63a7\\u95ee\\u7b54\\u8282\\u594f", "state_after": "\\u5185\\u5fc3\\u8d77\\u7591\\uff0c\\u5f00\\u59cb\\u89c2\\u5bdf\\u83b1\\u5c14", "psychological_change": "\\u6ce8\\u610f\\u5230\\u83b1\\u5c14\\u76f4\\u63a5\\u53eb\\u51fa\\u81ea\\u5df1\\u7684\\u59d3\\u540d\\uff0c\\u610f\\u8bc6\\u5230\\u5bf9\\u65b9\\u53ef\\u80fd\\u5177\\u5907\\u8d85\\u5e38\\u89c2\\u5bdf\\u529b\\u6216\\u5176\\u4ed6\\u80fd\\u529b\\uff0c\\u5bf9\\u83b1\\u5c14\\u4ea7\\u751f\\u8b66\\u60d5\\u548c\\u5174\\u8da3\\u3002", "key_event": "\\u8ffd\\u95ee\\u83b1\\u5c14\\u5982\\u4f55\\u77e5\\u9053\\u5176\\u59d3\\u540d\\uff0c\\u5374\\u5f97\\u5230\\u5de5\\u724c\\u7684\\u56de\\u7b54", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u666e\\u901a\\u8bc1\\u4eba\\u53d8\\u4e3a\\u91cd\\u70b9\\u89c2\\u5bdf\\u5bf9\\u8c61"}}]	[{"location": "\\u6cbb\\u5b89\\u6240\\u98df\\u5802", "atmosphere": "\\u6f6e\\u6e7f\\u6c89\\u95f7\\u3001\\u54b8\\u5473\\u5f25\\u6f2b\\u3001\\u676f\\u76d8\\u58f0\\u5608\\u6742", "duration": "\\u7ea610\\u5206\\u949f\\uff08\\u65e9\\u9910\\u65f6\\u95f4\\uff09"}, {"location": "\\u6cbb\\u5b89\\u6240\\u4f1a\\u8bae\\u5ba4", "atmosphere": "\\u5b98\\u65b9\\u6b63\\u5f0f\\u3001\\u7070\\u5c18\\u5728\\u5149\\u67f1\\u4e2d\\u6d6e\\u6c89\\u3001\\u6c14\\u6c1b\\u5ba1\\u614e", "duration": "\\u7ea630\\u5206\\u949f\\uff08\\u6b63\\u5348\\u8c08\\u8bdd\\uff09"}]	varied	7.4	7	7.5	7.8	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 7.4/10\n  节奏把控: 7.0/10\n  吸引力: 7.5/10\n  连贯性: 7.8/10\n\n【剧情阶段】发展\n\n【钩子分析】共5个\n  • [悬念] 案发前三天有三个人冒充异常管理局，在孤儿院打听异能者，他们的身份和目的成谜。... (强度:8)\n  • [悬念] 雷金纳德对自己的姓名保密，却被莱尔直接叫出，暗示他可能在刻意试探莱尔的特殊能力。... (强度:7)\n  • [情感] 克劳希望莱尔的能力能逆转时间救回玛丽修女，但莱尔只能看见过去，无法改变，亲人永逝的无力感刺痛读者。... (强度:9)\n\n【伏笔分析】埋下2个, 回收1个\n\n【冲突分析】\n  类型: 人与人, 人与己\n  强度: 7/10\n  进度: 20%\n\n【改进建议】\n  1. 【节奏问题】中段对凯莉米粒子的说明略显平铺直叙，建议通过雷金纳德展示微型监测仪或观测数据来增强画面感和可信度\n  2. 【描写不足】克劳听到莱尔坦白后的情绪仅通过吃光炖菜表现，可增加一个手部细节或呼吸停顿来强化隐忍与决意	["\\u3010\\u8282\\u594f\\u95ee\\u9898\\u3011\\u4e2d\\u6bb5\\u5bf9\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u7684\\u8bf4\\u660e\\u7565\\u663e\\u5e73\\u94fa\\u76f4\\u53d9\\uff0c\\u5efa\\u8bae\\u901a\\u8fc7\\u96f7\\u91d1\\u7eb3\\u5fb7\\u5c55\\u793a\\u5fae\\u578b\\u76d1\\u6d4b\\u4eea\\u6216\\u89c2\\u6d4b\\u6570\\u636e\\u6765\\u589e\\u5f3a\\u753b\\u9762\\u611f\\u548c\\u53ef\\u4fe1\\u5ea6", "\\u3010\\u63cf\\u5199\\u4e0d\\u8db3\\u3011\\u514b\\u52b3\\u542c\\u5230\\u83b1\\u5c14\\u5766\\u767d\\u540e\\u7684\\u60c5\\u7eea\\u4ec5\\u901a\\u8fc7\\u5403\\u5149\\u7096\\u83dc\\u8868\\u73b0\\uff0c\\u53ef\\u589e\\u52a0\\u4e00\\u4e2a\\u624b\\u90e8\\u7ec6\\u8282\\u6216\\u547c\\u5438\\u505c\\u987f\\u6765\\u5f3a\\u5316\\u9690\\u5fcd\\u4e0e\\u51b3\\u610f"]	\N	0.5	0.3	2026-08-06 23:07:35.814211
b4cfcadd-266a-4203-9d4a-061af4a71c25	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	发展转折	9	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	不安骤升	0.9	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u7070\\u8863\\u8bbf\\u5ba2\\u6ca1\\u6709\\u6309\\u6b63\\u89c4\\u6d41\\u7a0b\\u6838\\u5bf9\\u8eab\\u4efd\\uff0c\\u800c\\u662f\\u76f4\\u63a5\\u8be2\\u95ee\\u5f02\\u5e38\\u80fd\\u529b\\uff0c\\u771f\\u5b9e\\u8eab\\u4efd\\u548c\\u6765\\u610f\\u6210\\u8c1c\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u4ed6\\u4eec\\u8bf4\\u81ea\\u5df1\\u662f\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u4eba"}, {"type": "\\u8ba4\\u77e5", "content": "\\u83b1\\u5c14\\u6839\\u636e\\u8bbf\\u5ba2\\u7684\\u8be2\\u95ee\\u987a\\u5e8f\\u5224\\u65ad\\u5bf9\\u65b9\\u5e76\\u975e\\u6b63\\u5e38\\u767b\\u8bb0\\u4eba\\u5458\\uff0c\\u800c\\u662f\\u5728\\u7b5b\\u9009\\u5177\\u6709\\u5229\\u7528\\u4ef7\\u503c\\u7684\\u5f02\\u5e38\\u8005\\uff0c\\u5c06\\u5b98\\u65b9\\u8c03\\u67e5\\u98a0\\u8986\\u4e3a\\u4eba\\u53e3\\u730e\\u53d6\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u6bd4\\u8d77\\u627e\\u4eba\\uff0c\\u4ed6\\u4eec\\u66f4\\u50cf\\u662f\\u5728\\u6311\\u8d27"}, {"type": "\\u60c5\\u611f", "content": "\\u4e00\\u5411\\u6c89\\u9ed8\\u5f3a\\u786c\\u7684\\u514b\\u52b3\\u4e3b\\u52a8\\u5766\\u767d\\u80fd\\u529b\\u4e0e\\u6050\\u60e7\\uff0c\\u5e76\\u4ee5\\"\\u4ee5\\u4e3a\\u53ea\\u6709\\u6211\\u662f\\u8fd9\\u6837\\"\\u66b4\\u9732\\u957f\\u671f\\u7684\\u5b64\\u72ec\\u611f\\uff0c\\u589e\\u5f3a\\u8bfb\\u8005\\u5bf9\\u89d2\\u8272\\u7684\\u5171\\u60c5\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u6211\\u4ee5\\u4e3a\\u53ea\\u6709\\u6211\\u662f\\u8fd9\\u6837"}, {"type": "\\u51b2\\u7a81", "content": "\\u83b1\\u5c14\\u660e\\u77e5\\u81ea\\u5df1\\u540c\\u6837\\u62e5\\u6709\\u5f02\\u5e38\\u80fd\\u529b\\uff0c\\u5374\\u5728\\u4fe1\\u4efb\\u514b\\u52b3\\u4e0e\\u9075\\u5b88\\u739b\\u4e3d\\u4fee\\u5973\\u4fdd\\u5bc6\\u544a\\u8beb\\u4e4b\\u95f4\\u9009\\u62e9\\u7ee7\\u7eed\\u9690\\u7792\\uff0c\\u5f62\\u6210\\u540c\\u4f34\\u5173\\u7cfb\\u4e2d\\u7684\\u4fe1\\u606f\\u4e0d\\u5bf9\\u79f0\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u90a3\\u4e9b\\u4eba\\u786e\\u5b9e\\u5728\\u627e\\u4ed6\\u4eec\\u4e24\\u4e2a"}, {"type": "\\u60ac\\u5ff5", "content": "\\u8fd4\\u7a0b\\u540e\\u7684\\u5b64\\u513f\\u9662\\u5f02\\u5e38\\u5bc2\\u9759\\uff0c\\u5927\\u95e8\\u865a\\u63a9\\u3001\\u95e8\\u95e9\\u65ad\\u88c2\\uff0c\\u6697\\u793a\\u7070\\u8863\\u8bbf\\u5ba2\\u6216\\u5176\\u4ed6\\u654c\\u4eba\\u5df2\\u7ecf\\u5165\\u4fb5\\uff0c\\u4ee5\\u7a81\\u53d1\\u5371\\u673a\\u5f62\\u6210\\u5f3a\\u70c8\\u7ae0\\u672b\\u60ac\\u5ff5\\u3002", "strength": 10, "position": "\\u7ed3\\u5c3e", "keyword": "\\u95e8\\u95e9\\u65ad\\u6210\\u4e24\\u622a\\uff0c\\u4e00\\u534a\\u6b6a\\u5728\\u77f3\\u9636\\u65c1"}]	5	\N	[{"title": "\\u89e6\\u7269\\u8bfb\\u53d6\\u6b8b\\u7559\\u8bb0\\u5fc6\\u7684\\u80fd\\u529b", "content": "\\u83b1\\u5c14\\u56de\\u60f3\\u6728\\u9a6c\\u88c2\\u5f00\\u65f6\\u6b8b\\u7559\\u5728\\u6307\\u8179\\u4e0a\\u7684\\u89e6\\u611f\\uff0c\\u5e76\\u660e\\u786e\\u610f\\u8bc6\\u5230\\u7070\\u8863\\u8bbf\\u5ba2\\u5bfb\\u627e\\u7684\\u5bf9\\u8c61\\u5305\\u62ec\\u81ea\\u5df1\\uff0c\\u4f7f\\u7b2c1\\u7ae0\\u4e2d\\u89e6\\u78b0\\u6728\\u9a6c\\u540e\\u8bfb\\u53d6\\u8fc7\\u53bb\\u5f71\\u50cf\\u7684\\u5f02\\u5e38\\u4f53\\u9a8c\\u8fdb\\u5165\\u4ed6\\u7684\\u4e3b\\u52a8\\u8ba4\\u77e5\\u3002\\u6b64\\u6b21\\u56de\\u6536\\u4e3b\\u8981\\u786e\\u8ba4\\u8be5\\u73b0\\u8c61\\u5c5e\\u4e8e\\u83b1\\u5c14\\u5fc5\\u987b\\u9690\\u85cf\\u7684\\u80fd\\u529b\\uff0c\\u4f46\\u5176\\u4fa6\\u67e5\\u7528\\u9014\\u5c1a\\u672a\\u5728\\u672c\\u7ae0\\u5b8c\\u6574\\u5c55\\u5f00\\u3002", "type": "resolved", "strength": 7, "subtlety": 7, "reference_chapter": 1, "reference_foreshadow_id": "9c0cbb2c-0872-41bb-9915-2e41ecc928a9", "keyword": "\\u6728\\u9a6c\\u88c2\\u5f00\\u7684\\u89e6\\u611f\\u8fd8\\u7559\\u5728\\u4ed6\\u6307\\u8179\\u4e0a", "category": "ability", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 2}, {"title": "\\u80fd\\u529b\\u4f7f\\u7528\\u4f1a\\u635f\\u4f24\\u63a5\\u89e6\\u7269\\u54c1", "content": "\\u6728\\u9a6c\\"\\u88c2\\u5f00\\"\\u7684\\u89e6\\u611f\\u518d\\u6b21\\u88ab\\u83b1\\u5c14\\u56de\\u5fc6\\uff0c\\u5e76\\u4e0e\\u5176\\u5f02\\u5e38\\u8eab\\u4efd\\u8054\\u7cfb\\u8d77\\u6765\\uff0c\\u786e\\u8ba4\\u7b2c1\\u7ae0\\u6728\\u9a6c\\u53d7\\u635f\\u5e76\\u975e\\u666e\\u901a\\u610f\\u5916\\uff0c\\u800c\\u662f\\u80fd\\u529b\\u53d1\\u52a8\\u4f34\\u968f\\u7684\\u7269\\u54c1\\u635f\\u4f24\\u73b0\\u8c61\\u3002", "type": "resolved", "strength": 6, "subtlety": 8, "reference_chapter": 1, "reference_foreshadow_id": "d2a1297f-bb76-47ad-b4ad-7a19ae0361b0", "keyword": "\\u6728\\u9a6c\\u88c2\\u5f00\\u7684\\u89e6\\u611f\\u8fd8\\u7559\\u5728\\u4ed6\\u6307\\u8179\\u4e0a", "category": "ability", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 2}, {"title": "\\u739b\\u4e3d\\u4fee\\u5973\\u662f\\u79d8\\u5bc6\\u552f\\u4e00\\u5b88\\u62a4\\u8005", "content": "\\u514b\\u52b3\\u5766\\u767d\\u540e\\uff0c\\u83b1\\u5c14\\u4ecd\\u9075\\u5faa\\u739b\\u4e3d\\u4fee\\u5973\\u5173\\u4e8e\\u79d8\\u5bc6\\u4e0d\\u53ef\\u4ea4\\u7ed9\\u7b2c\\u4e8c\\u4e2a\\u4eba\\u7684\\u544a\\u8beb\\uff0c\\u6ca1\\u6709\\u627f\\u8ba4\\u81ea\\u5df1\\u7684\\u80fd\\u529b\\uff1b\\u540c\\u65f6\\u739b\\u4e3d\\u4fee\\u5973\\u5bf9\\u8bbf\\u5ba2\\u6492\\u8c0e\\u5e76\\u70e7\\u6bc1\\u5730\\u5740\\uff0c\\u8fdb\\u4e00\\u6b65\\u5750\\u5b9e\\u5979\\u662f\\u83b1\\u5c14\\u79d8\\u5bc6\\u7684\\u552f\\u4e00\\u77e5\\u60c5\\u8005\\u548c\\u4fdd\\u62a4\\u8005\\u3002", "type": "resolved", "strength": 8, "subtlety": 6, "reference_chapter": 1, "reference_foreshadow_id": "25ed843c-8077-486b-abe6-477a2593526b", "keyword": "\\u79d8\\u5bc6\\u8ba9\\u7b2c\\u4e8c\\u4e2a\\u4eba\\u770b\\u89c1\\uff0c\\u5c31\\u4e0d\\u518d\\u53ea\\u5f52\\u81ea\\u5df1\\u7ba1\\u4e86", "category": "relationship", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"], "estimated_resolve_chapter": 2}, {"title": "\\u514b\\u52b3\\u5207\\u5272\\u80fd\\u529b\\u53ca\\u53cd\\u566c", "content": "\\u514b\\u52b3\\u80fd\\u501f\\u52a9\\u5200\\u3001\\u526a\\u5200\\u3001\\u65a7\\u5934\\u7b49\\u5207\\u5272\\u5de5\\u5177\\u65a9\\u65ad\\u6b63\\u5e38\\u60c5\\u51b5\\u4e0b\\u65e0\\u6cd5\\u5207\\u5f00\\u7684\\u7269\\u4f53\\uff0c\\u4f46\\u80fd\\u529b\\u4f1a\\u5728\\u5176\\u624b\\u8155\\u4e0a\\u9020\\u6210\\u5bf9\\u5e94\\u5272\\u4f24\\u3002\\u8be5\\u8bbe\\u5b9a\\u65e2\\u8d4b\\u4e88\\u4ed6\\u5f3a\\u5927\\u6218\\u6597\\u548c\\u7834\\u969c\\u80fd\\u529b\\uff0c\\u4e5f\\u9884\\u57cb\\u4e86\\u4f7f\\u7528\\u8d8a\\u5f3a\\u3001\\u53cd\\u566c\\u8d8a\\u91cd\\u7684\\u4ee3\\u4ef7\\u3002", "type": "planted", "strength": 9, "subtlety": 3, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u5230\\u4e86\\u6211\\u624b\\u91cc\\uff0c\\u5c31\\u80fd\\u5207\\u5f00\\u672c\\u6765\\u5207\\u4e0d\\u5f00\\u7684\\u4e1c\\u897f", "category": "ability", "is_long_term": true, "related_characters": ["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"], "estimated_resolve_chapter": 10}, {"title": "\\u5b64\\u513f\\u9662\\u906d\\u88ad\\u4e0e\\u4f17\\u4eba\\u5b89\\u5371", "content": "\\u70df\\u56f1\\u505c\\u706b\\u3001\\u9662\\u5185\\u5931\\u53bb\\u65e5\\u5e38\\u58f0\\u54cd\\u3001\\u5927\\u95e8\\u865a\\u63a9\\u4e14\\u95e8\\u95e9\\u65ad\\u88c2\\uff0c\\u5171\\u540c\\u8868\\u660e\\u5b64\\u513f\\u9662\\u5728\\u4e24\\u4eba\\u79bb\\u5f00\\u671f\\u95f4\\u906d\\u9047\\u66b4\\u529b\\u5165\\u4fb5\\u3002\\u5b69\\u5b50\\u4eec\\u4e0e\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u5904\\u5883\\u5c06\\u6210\\u4e3a\\u4e0b\\u4e00\\u7ae0\\u6700\\u76f4\\u63a5\\u7684\\u5371\\u673a\\u3002", "type": "planted", "strength": 10, "subtlety": 2, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u5b64\\u513f\\u9662\\u7684\\u5927\\u95e8\\u865a\\u63a9\\u7740", "category": "event", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u6258\\u6bd4", "\\u827e\\u62c9", "\\u8bfa\\u4e9a"], "estimated_resolve_chapter": 3}]	2	3	[{"content": "\\u739b\\u4e3d\\u4fee\\u5973\\u5b89\\u6392\\u83b1\\u5c14\\u4e0e\\u514b\\u52b3\\u524d\\u5f80\\u57ce\\u4e1c\\u91c7\\u8d2d\\uff0c\\u4ee5\\u5e73\\u9759\\u800c\\u5177\\u751f\\u6d3b\\u6c14\\u606f\\u7684\\u5b64\\u513f\\u9662\\u65e5\\u5e38\\u5efa\\u7acb\\u60c5\\u611f\\u57fa\\u7ebf\\u3002", "type": "transition", "importance": 0.65, "impact": "\\u8ba9\\u4e24\\u540d\\u4e3b\\u8981\\u89d2\\u8272\\u79bb\\u5f00\\u5b64\\u513f\\u9662\\uff0c\\u4e3a\\u8bbf\\u5ba2\\u60c5\\u62a5\\u7684\\u79c1\\u4e0b\\u4ea4\\u6d41\\u548c\\u7ae0\\u672b\\u88ad\\u51fb\\u73b0\\u573a\\u521b\\u9020\\u6761\\u4ef6\\uff0c\\u540c\\u65f6\\u901a\\u8fc7\\u5bb6\\u5ead\\u611f\\u653e\\u5927\\u540e\\u7eed\\u5371\\u673a\\u7684\\u60c5\\u7eea\\u51b2\\u51fb\\u3002", "keyword": "\\u739b\\u4e3d\\u4fee\\u5973\\u5c06\\u96f6\\u94b1\\u63a8\\u8fc7\\u53bb"}, {"content": "\\u514b\\u52b3\\u900f\\u9732\\u4e09\\u540d\\u81ea\\u79f0\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u7070\\u8863\\u8bbf\\u5ba2\\u66fe\\u5230\\u5b64\\u513f\\u9662\\u8c03\\u67e5\\u5f02\\u5e38\\u80fd\\u529b\\u8005\\u3002", "type": "revelation", "importance": 0.9, "impact": "\\u5c06\\u6545\\u4e8b\\u5a01\\u80c1\\u4ece\\u83b1\\u5c14\\u4e2a\\u4eba\\u79d8\\u5bc6\\u6269\\u5c55\\u4e3a\\u6709\\u7ec4\\u7ec7\\u7684\\u5f02\\u5e38\\u8005\\u641c\\u6355\\uff0c\\u5e76\\u4e3a\\u5b64\\u513f\\u9662\\u906d\\u88ad\\u5efa\\u7acb\\u76f4\\u63a5\\u5acc\\u7591\\u5bf9\\u8c61\\u3002", "keyword": "\\u4ed6\\u4eec\\u8bf4\\u81ea\\u5df1\\u662f\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u7684\\u4eba"}, {"content": "\\u83b1\\u5c14\\u901a\\u8fc7\\u8c03\\u67e5\\u6d41\\u7a0b\\u5224\\u65ad\\u8bbf\\u5ba2\\u5e76\\u975e\\u6b63\\u5e38\\u767b\\u8bb0\\u4eba\\u5458\\uff0c\\u800c\\u662f\\u5728\\u5bfb\\u627e\\u53ef\\u4f9b\\u5229\\u7528\\u7684\\u5f02\\u5e38\\u80fd\\u529b\\u8005\\u3002", "type": "revelation", "importance": 0.88, "impact": "\\u4f53\\u73b0\\u4e3b\\u89d2\\u7684\\u903b\\u8f91\\u5224\\u65ad\\u529b\\uff0c\\u660e\\u786e\\u5916\\u90e8\\u52bf\\u529b\\u7684\\u63a0\\u593a\\u6027\\uff0c\\u5e76\\u5c06\\u4e16\\u754c\\u89c2\\u4e2d\\u7684\\u5236\\u5ea6\\u5a01\\u80c1\\u5177\\u8c61\\u5316\\u3002", "keyword": "\\u771f\\u6b63\\u6765\\u767b\\u8bb0\\u7684\\u4eba\\uff0c\\u4f1a\\u5148\\u6838\\u5bf9\\u5b64\\u513f\\u9662\\u540d\\u5355"}, {"content": "\\u514b\\u52b3\\u5411\\u83b1\\u5c14\\u5766\\u767d\\u81ea\\u5df1\\u7684\\u8d85\\u5e38\\u5207\\u5272\\u80fd\\u529b\\u4ee5\\u53ca\\u80fd\\u529b\\u5728\\u8eab\\u4f53\\u4e0a\\u9020\\u6210\\u5272\\u4f24\\u7684\\u53cd\\u566c\\u3002", "type": "revelation", "importance": 0.95, "impact": "\\u5b8c\\u6210\\u514b\\u52b3\\u7684\\u6838\\u5fc3\\u80fd\\u529b\\u63ed\\u793a\\uff0c\\u6df1\\u5316\\u4e24\\u4eba\\u4fe1\\u4efb\\u5173\\u7cfb\\uff0c\\u5e76\\u5f62\\u6210\\u83b1\\u5c14\\u662f\\u5426\\u5bf9\\u7b49\\u5766\\u767d\\u81ea\\u8eab\\u80fd\\u529b\\u7684\\u5185\\u5728\\u51b2\\u7a81\\u3002", "keyword": "\\u53ea\\u8981\\u662f\\u80fd\\u5207\\u4e1c\\u897f\\u7684\\u5de5\\u5177"}, {"content": "\\u4e24\\u4eba\\u8fd4\\u56de\\u540e\\u53d1\\u73b0\\u5b64\\u513f\\u9662\\u5931\\u53bb\\u751f\\u6d3b\\u58f0\\u54cd\\uff0c\\u5927\\u95e8\\u865a\\u63a9\\u4e14\\u95e8\\u95e9\\u65ad\\u88c2\\u3002", "type": "conflict", "importance": 1.0, "impact": "\\u5c06\\u6f5c\\u4f0f\\u5a01\\u80c1\\u7acb\\u5373\\u5347\\u7ea7\\u4e3a\\u73b0\\u5b9e\\u88ad\\u51fb\\uff0c\\u7ec8\\u6b62\\u77ed\\u6682\\u65e5\\u5e38\\uff0c\\u8feb\\u4f7f\\u4e3b\\u89d2\\u8fdb\\u5165\\u8c03\\u67e5\\u3001\\u6551\\u63f4\\u6216\\u8ffd\\u51fb\\u9636\\u6bb5\\uff0c\\u5e76\\u5f62\\u6210\\u5f3a\\u529b\\u7eed\\u7ae0\\u9a71\\u52a8\\u3002", "keyword": "\\u9001\\u8d27\\u7bee\\u7838\\u5728\\u77f3\\u9636\\u4e0a\\uff0c\\u836f\\u74f6\\u6eda\\u4e86\\u51fa\\u53bb"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u4ece\\u5bb9\\u673a\\u654f\\uff0c\\u4ee5\\u73a9\\u7b11\\u548c\\u7cbe\\u6253\\u7ec6\\u7b97\\u5e94\\u5bf9\\u5e73\\u9759\\u65e5\\u5e38", "state_after": "\\u9ad8\\u5ea6\\u8b66\\u89c9\\uff0c\\u610f\\u8bc6\\u5230\\u9488\\u5bf9\\u5f02\\u5e38\\u8005\\u7684\\u5a01\\u80c1\\u5df2\\u7ecf\\u6ce2\\u53ca\\u5b64\\u513f\\u9662", "psychological_change": "\\u4ed6\\u5148\\u4ee5\\u60ef\\u5e38\\u7684\\u5e7d\\u9ed8\\u5316\\u89e3\\u514b\\u52b3\\u7684\\u7d27\\u5f20\\uff0c\\u968f\\u540e\\u901a\\u8fc7\\u8bbf\\u5ba2\\u7684\\u8be2\\u95ee\\u987a\\u5e8f\\u8fc5\\u901f\\u5224\\u65ad\\u5bf9\\u65b9\\u5e76\\u975e\\u6b63\\u89c4\\u767b\\u8bb0\\u4eba\\u5458\\u3002\\u9762\\u5bf9\\u514b\\u52b3\\u7684\\u5766\\u767d\\uff0c\\u4ed6\\u4ea7\\u751f\\u627f\\u8ba4\\u81ea\\u8eab\\u80fd\\u529b\\u7684\\u51b2\\u52a8\\uff0c\\u5374\\u6700\\u7ec8\\u9009\\u62e9\\u9075\\u5b88\\u739b\\u4e3d\\u4fee\\u5973\\u7684\\u4fdd\\u5bc6\\u539f\\u5219\\u3002\\u7ae0\\u672b\\u53d1\\u73b0\\u5b64\\u513f\\u9662\\u5f02\\u5e38\\u540e\\uff0c\\u4ed6\\u7684\\u51b7\\u9759\\u89c2\\u5bdf\\u77ac\\u95f4\\u8f6c\\u5316\\u4e3a\\u5f3a\\u70c8\\u5371\\u673a\\u611f\\uff0c\\u9001\\u8d27\\u7bee\\u8131\\u624b\\u663e\\u793a\\u5176\\u60c5\\u7eea\\u9996\\u6b21\\u660e\\u663e\\u5931\\u63a7\\u3002", "key_event": "\\u542c\\u5b8c\\u514b\\u52b3\\u7684\\u80fd\\u529b\\u79d8\\u5bc6\\u5e76\\u5728\\u8fd4\\u7a0b\\u65f6\\u53d1\\u73b0\\u5b64\\u513f\\u9662\\u95e8\\u95e9\\u65ad\\u88c2", "relationship_changes": {"\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u514b\\u52b3\\u5355\\u65b9\\u9762\\u4ea4\\u4ed8\\u6838\\u5fc3\\u79d8\\u5bc6\\uff0c\\u4f7f\\u83b1\\u5c14\\u6210\\u4e3a\\u5176\\u9996\\u4f4d\\u80fd\\u529b\\u77e5\\u60c5\\u8005\\uff0c\\u4fe1\\u4efb\\u663e\\u8457\\u52a0\\u6df1\\uff1b\\u4f46\\u83b1\\u5c14\\u6682\\u672a\\u5bf9\\u7b49\\u5766\\u767d\\uff0c\\u5f62\\u6210\\u9690\\u6027\\u7684\\u5173\\u7cfb\\u538b\\u529b\\u3002", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u83b1\\u5c14\\u7ee7\\u7eed\\u9075\\u5b88\\u5979\\u5173\\u4e8e\\u4fdd\\u5bc6\\u7684\\u6559\\u5bfc\\uff0c\\u5e76\\u4ece\\u5979\\u6b3a\\u9a97\\u8bbf\\u5ba2\\u3001\\u70e7\\u6bc1\\u5730\\u5740\\u7684\\u884c\\u4e3a\\u4e2d\\u8fdb\\u4e00\\u6b65\\u786e\\u8ba4\\u5176\\u4fdd\\u62a4\\u8005\\u7acb\\u573a\\u3002"}}, {"character_name": "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "survival_status": null, "state_before": "\\u6c89\\u9ed8\\u7126\\u8651\\uff0c\\u56e0\\u7070\\u8863\\u8bbf\\u5ba2\\u7684\\u51fa\\u73b0\\u800c\\u62c5\\u5fe7\\u81ea\\u8eab\\u5f02\\u5e38\\u88ab\\u53d1\\u73b0", "state_after": "\\u5b8c\\u6210\\u9996\\u6b21\\u4e3b\\u52a8\\u5766\\u767d\\uff0c\\u4e0e\\u83b1\\u5c14\\u5efa\\u7acb\\u66f4\\u6df1\\u4fe1\\u4efb\\uff0c\\u4f46\\u968f\\u5373\\u8fdb\\u5165\\u5e94\\u5bf9\\u5b64\\u513f\\u9662\\u5371\\u673a\\u7684\\u8b66\\u6212\\u72b6\\u6001", "psychological_change": "\\u514b\\u52b3\\u4ece\\u634f\\u788e\\u9762\\u5305\\u3001\\u6307\\u8282\\u53d1\\u767d\\u7b49\\u538b\\u6291\\u6027\\u52a8\\u4f5c\\u5f00\\u59cb\\uff0c\\u9010\\u6b65\\u8bf4\\u51fa\\u8bbf\\u5ba2\\u60c5\\u62a5\\u3001\\u80fd\\u529b\\u8868\\u73b0\\u548c\\u8eab\\u4f53\\u53cd\\u566c\\u3002\\u4ed6\\u627f\\u8ba4\\u81ea\\u5df1\\u66fe\\u4ee5\\u4e3a\\u662f\\u552f\\u4e00\\u7684\\u5f02\\u7c7b\\uff0c\\u66b4\\u9732\\u51fa\\u957f\\u671f\\u5b64\\u7acb\\u611f\\u3002\\u83b1\\u5c14\\u7684\\u73a9\\u7b11\\u6ca1\\u6709\\u5426\\u5b9a\\u4ed6\\uff0c\\u53cd\\u800c\\u6682\\u65f6\\u7f13\\u89e3\\u4e86\\u5176\\u81ea\\u6211\\u602a\\u7269\\u5316\\u503e\\u5411\\uff0c\\u4f7f\\u4ed6\\u80fd\\u591f\\u77ed\\u6682\\u53d1\\u7b11\\u3002", "key_event": "\\u5411\\u83b1\\u5c14\\u5766\\u767d\\u81ea\\u5df1\\u80fd\\u591f\\u501f\\u52a9\\u5207\\u5272\\u5de5\\u5177\\u65a9\\u65ad\\u5f02\\u5e38\\u575a\\u56fa\\u4e4b\\u7269", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u9ed8\\u8ba4\\u7684\\u65e5\\u5e38\\u540c\\u4f34\\u5347\\u7ea7\\u4e3a\\u53ef\\u4ee5\\u6258\\u4ed8\\u81f4\\u547d\\u79d8\\u5bc6\\u7684\\u5bf9\\u8c61\\uff0c\\u514b\\u52b3\\u5bf9\\u83b1\\u5c14\\u7684\\u4fe1\\u4efb\\u663e\\u8457\\u589e\\u5f3a\\u3002", "\\u739b\\u4e3d\\u4fee\\u5973": "\\u610f\\u8bc6\\u5230\\u739b\\u4e3d\\u4fee\\u5973\\u5728\\u6b3a\\u9a97\\u8bbf\\u5ba2\\u3001\\u4fdd\\u62a4\\u5f02\\u5e38\\u8005\\uff0c\\u5bf9\\u5979\\u7684\\u4fdd\\u62a4\\u7acb\\u573a\\u6709\\u4e86\\u66f4\\u660e\\u786e\\u8ba4\\u77e5\\u3002"}}, {"character_name": "\\u739b\\u4e3d\\u4fee\\u5973", "survival_status": null, "state_before": "\\u6e29\\u548c\\u52a1\\u5b9e\\u5730\\u7167\\u6599\\u5b64\\u513f\\u9662\\u65e5\\u5e38\\u751f\\u6d3b", "state_after": "\\u5176\\u9690\\u85cf\\u7684\\u8b66\\u60d5\\u6027\\u4e0e\\u4fdd\\u62a4\\u8005\\u8eab\\u4efd\\u88ab\\u63ed\\u793a\\uff0c\\u5f53\\u524d\\u5904\\u5883\\u56e0\\u5b64\\u513f\\u9662\\u906d\\u5230\\u5165\\u4fb5\\u800c\\u6210\\u8c1c", "psychological_change": "\\u672c\\u7ae0\\u672a\\u76f4\\u63a5\\u5c55\\u793a\\u5979\\u5728\\u8bbf\\u5ba2\\u5230\\u6765\\u65f6\\u7684\\u5185\\u5fc3\\u53d8\\u5316\\uff0c\\u4f46\\u901a\\u8fc7\\u514b\\u52b3\\u8f6c\\u8ff0\\u53ef\\u89c1\\uff0c\\u5979\\u9762\\u5bf9\\u53ef\\u7591\\u4eba\\u5458\\u65f6\\u4fdd\\u6301\\u9547\\u5b9a\\uff0c\\u4e3b\\u52a8\\u9690\\u7792\\u5b69\\u5b50\\u4eec\\u7684\\u5f02\\u5e38\\uff0c\\u5e76\\u70e7\\u6bc1\\u5bf9\\u65b9\\u7559\\u4e0b\\u7684\\u5730\\u5740\\uff0c\\u8868\\u73b0\\u51fa\\u660e\\u786e\\u7684\\u98ce\\u9669\\u5224\\u65ad\\u548c\\u4fdd\\u62a4\\u610f\\u5fd7\\u3002", "key_event": "\\u5426\\u8ba4\\u5b64\\u513f\\u9662\\u5b58\\u5728\\u5f02\\u5e38\\u80fd\\u529b\\u8005\\uff0c\\u5e76\\u5728\\u5f53\\u665a\\u70e7\\u6389\\u8bbf\\u5ba2\\u5730\\u5740", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u65e5\\u5e38\\u7167\\u6599\\u8005\\u8fdb\\u4e00\\u6b65\\u660e\\u786e\\u4e3a\\u66ff\\u83b1\\u5c14\\u9690\\u7792\\u6838\\u5fc3\\u79d8\\u5bc6\\u3001\\u4e3b\\u52a8\\u627f\\u62c5\\u5916\\u90e8\\u98ce\\u9669\\u7684\\u4fdd\\u62a4\\u8005\\u3002", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279": "\\u867d\\u7136\\u5c1a\\u4e0d\\u77e5\\u9053\\u514b\\u52b3\\u7684\\u80fd\\u529b\\uff0c\\u4f46\\u5979\\u5bf9\\u8bbf\\u5ba2\\u7684\\u7edf\\u4e00\\u5426\\u8ba4\\u5ba2\\u89c2\\u4e0a\\u4e5f\\u4fdd\\u62a4\\u4e86\\u514b\\u52b3\\u3002"}}, {"character_name": "\\u6258\\u6bd4", "survival_status": null, "state_before": "\\u6d3b\\u6cfc\\u8d2a\\u5403\\uff0c\\u5904\\u4e8e\\u5b64\\u513f\\u9662\\u8f7b\\u677e\\u65e5\\u5e38\\u4e4b\\u4e2d", "state_after": "\\u672a\\u5728\\u8fd4\\u7a0b\\u540e\\u7684\\u9662\\u5185\\u51fa\\u73b0\\uff0c\\u5b89\\u5371\\u6682\\u65f6\\u4e0d\\u660e\\u4f46\\u5c1a\\u65e0\\u660e\\u786e\\u5931\\u8e2a\\u4f9d\\u636e", "psychological_change": "\\u672c\\u7ae0\\u672a\\u5c55\\u5f00\\u663e\\u8457\\u5fc3\\u7406\\u53d8\\u5316\\uff0c\\u5176\\u65e9\\u9910\\u65f6\\u5077\\u62ff\\u8702\\u871c\\u7684\\u884c\\u4e3a\\u627f\\u62c5\\u65e5\\u5e38\\u6c1b\\u56f4\\u548c\\u5bb6\\u5ead\\u611f\\u5851\\u9020\\uff0c\\u5e76\\u4f7f\\u7ed3\\u5c3e\\u7684\\u5bc2\\u9759\\u66f4\\u5177\\u53cd\\u5dee\\u3002", "key_event": "\\u65e9\\u9910\\u65f6\\u8bd5\\u56fe\\u62ff\\u9762\\u5305\\u8638\\u7ed9\\u8bfa\\u4e9a\\u7559\\u4e0b\\u7684\\u8702\\u871c", "relationship_changes": {"\\u739b\\u4e3d\\u4fee\\u5973": "\\u7ee7\\u7eed\\u5904\\u4e8e\\u88ab\\u6e29\\u548c\\u7ba1\\u6559\\u548c\\u7167\\u6599\\u7684\\u4f4d\\u7f6e\\uff0c\\u65e0\\u5b9e\\u8d28\\u53d8\\u5316\\u3002"}}, {"character_name": "\\u8bfa\\u4e9a", "survival_status": null, "state_before": "\\u53d7\\u5230\\u5b64\\u513f\\u9662\\u6210\\u5458\\u7167\\u6599\\u7684\\u5e74\\u5e7c\\u5b69\\u5b50", "state_after": "\\u672a\\u5728\\u7ed3\\u5c3e\\u51fa\\u73b0\\uff0c\\u5b89\\u5371\\u6210\\u4e3a\\u5b64\\u513f\\u9662\\u6574\\u4f53\\u60ac\\u5ff5\\u7684\\u4e00\\u90e8\\u5206", "psychological_change": "\\u6ca1\\u6709\\u76f4\\u63a5\\u5fc3\\u7406\\u63cf\\u5199\\uff0c\\u5176\\u5b58\\u5728\\u4e3b\\u8981\\u901a\\u8fc7\\u4e13\\u95e8\\u4fdd\\u7559\\u8702\\u871c\\u548c\\u83b1\\u5c14\\u6b64\\u524d\\u5e26\\u4ed6\\u770b\\u7259\\u533b\\u7684\\u7ec6\\u8282\\uff0c\\u5f3a\\u5316\\u5b64\\u513f\\u9662\\u6210\\u5458\\u4e4b\\u95f4\\u7684\\u7167\\u6599\\u5173\\u7cfb\\u3002", "key_event": "\\u739b\\u4e3d\\u4fee\\u5973\\u4e3a\\u4ed6\\u4fdd\\u7559\\u6700\\u540e\\u4e00\\u52fa\\u8702\\u871c", "relationship_changes": {"\\u739b\\u4e3d\\u4fee\\u5973": "\\u7ee7\\u7eed\\u53d7\\u5230\\u7ec6\\u81f4\\u7167\\u987e\\u3002", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6b64\\u524d\\u7531\\u83b1\\u5c14\\u966a\\u540c\\u770b\\u7259\\u533b\\uff0c\\u4f53\\u73b0\\u7a33\\u5b9a\\u7684\\u5bb6\\u4eba\\u5f0f\\u7167\\u6599\\u5173\\u7cfb\\u3002"}}, {"character_name": "\\u827e\\u62c9", "survival_status": null, "state_before": "\\u6d3b\\u8dc3\\u597d\\u52a8\\uff0c\\u662f\\u5b64\\u513f\\u9662\\u65e5\\u5e38\\u79e9\\u5e8f\\u7684\\u4e00\\u90e8\\u5206", "state_after": "\\u672a\\u5728\\u5f02\\u5e38\\u5bc2\\u9759\\u7684\\u5b64\\u513f\\u9662\\u4e2d\\u51fa\\u73b0\\uff0c\\u5b89\\u5371\\u6682\\u65f6\\u4e0d\\u660e\\u4f46\\u65e0\\u660e\\u786e\\u5931\\u8e2a\\u7ed3\\u8bba", "psychological_change": "\\u6ca1\\u6709\\u76f4\\u63a5\\u5fc3\\u7406\\u63cf\\u5199\\u3002\\u83b1\\u5c14\\u5bf9\\u5979\\u5e73\\u65e5\\u722c\\u7a97\\u53f0\\u884c\\u4e3a\\u7684\\u56de\\u5fc6\\u6210\\u4e3a\\u5224\\u65ad\\u5b64\\u513f\\u9662\\u8fc7\\u5206\\u5b89\\u9759\\u7684\\u91cd\\u8981\\u53c2\\u7167\\u3002", "key_event": "\\u83b1\\u5c14\\u56e0\\u6ca1\\u6709\\u770b\\u89c1\\u5979\\u50cf\\u5f80\\u5e38\\u4e00\\u6837\\u722c\\u4e0a\\u7a97\\u53f0\\u800c\\u5bdf\\u89c9\\u5f02\\u5e38", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u83b1\\u5c14\\u719f\\u6089\\u5979\\u7684\\u65e5\\u5e38\\u4e60\\u60ef\\uff0c\\u4f53\\u73b0\\u5171\\u540c\\u751f\\u6d3b\\u5f62\\u6210\\u7684\\u4eb2\\u8fd1\\u4e0e\\u89c2\\u5bdf\\u3002"}}]	[{"location": "\\u6668\\u661f\\u5b64\\u513f\\u9662\\u53a8\\u623f", "atmosphere": "\\u6e29\\u6696\\u3001\\u55a7\\u95f9\\u800c\\u5bcc\\u6709\\u5bb6\\u5ead\\u751f\\u6d3b\\u6c14\\u606f", "duration": "\\u7ea6\\u4e8c\\u5341\\u5206\\u949f"}, {"location": "\\u57ce\\u897f\\u81f3\\u57ce\\u4e1c\\u7684\\u8857\\u9053\\u4e0e\\u77f3\\u6865", "atmosphere": "\\u6668\\u96fe\\u6e7f\\u51b7\\uff0c\\u7531\\u8f7b\\u677e\\u62cc\\u5634\\u9010\\u6e10\\u8f6c\\u4e3a\\u538b\\u6291\\u548c\\u8b66\\u89c9", "duration": "\\u7ea6\\u4e09\\u5341\\u81f3\\u56db\\u5341\\u5206\\u949f"}, {"location": "\\u57ce\\u4e1c\\u5e02\\u573a", "atmosphere": "\\u5608\\u6742\\u9c9c\\u6d3b\\uff0c\\u5e26\\u6709\\u77ed\\u6682\\u7f13\\u51b2\\u548c\\u751f\\u6d3b\\u5316\\u5e7d\\u9ed8", "duration": "\\u7ea6\\u56db\\u5341\\u5206\\u949f"}, {"location": "\\u901a\\u5f80\\u6668\\u661f\\u5b64\\u513f\\u9662\\u7684\\u5761\\u9053\\u4e0e\\u95e8\\u524d", "atmosphere": "\\u53cd\\u5e38\\u6b7b\\u5bc2\\uff0c\\u5371\\u673a\\u611f\\u5feb\\u901f\\u6500\\u5347\\u81f3\\u60ca\\u9a87", "duration": "\\u7ea6\\u4e94\\u5206\\u949f"}]	varied	9.2	9.1	9.3	9.2	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 9.2/10\n  节奏把控: 9.1/10\n  吸引力: 9.3/10\n  连贯性: 9.2/10\n\n【剧情阶段】发展转折\n\n【钩子分析】共5个\n  • [悬念] 自称异常管理局的灰衣访客没有按正规流程核对身份，而是直接询问异常能力，真实身份和来意成谜。... (强度:9)\n  • [认知] 莱尔根据访客的询问顺序判断对方并非正常登记人员，而是在筛选具有利用价值的异常者，将官方调查颠覆为人口... (强度:9)\n  • [情感] 一向沉默强硬的克劳主动坦白能力与恐惧，并以"以为只有我是这样"暴露长期的孤独感，增强读者对角色的共情... (强度:8)\n\n【伏笔分析】埋下5个, 回收4个\n\n【冲突分析】\n  类型: 人与人, 人与己, 人与社会\n  强度: 9/10\n  进度: 10%\n\n【改进建议】\n  1. 【伏笔回收力度】莱尔对木马触感的回忆确认了他同样属于异常者，但"触物读取残留记忆"的具体机制仍较含蓄；若本章承担明确回收任务，可在门前让他对断裂门闩产生一瞬主动触碰或克制触碰的念头，在不提前揭晓袭击真相的前提下强化该能力即将用于调查的功能性承接。	["\\u3010\\u4f0f\\u7b14\\u56de\\u6536\\u529b\\u5ea6\\u3011\\u83b1\\u5c14\\u5bf9\\u6728\\u9a6c\\u89e6\\u611f\\u7684\\u56de\\u5fc6\\u786e\\u8ba4\\u4e86\\u4ed6\\u540c\\u6837\\u5c5e\\u4e8e\\u5f02\\u5e38\\u8005\\uff0c\\u4f46\\"\\u89e6\\u7269\\u8bfb\\u53d6\\u6b8b\\u7559\\u8bb0\\u5fc6\\"\\u7684\\u5177\\u4f53\\u673a\\u5236\\u4ecd\\u8f83\\u542b\\u84c4\\uff1b\\u82e5\\u672c\\u7ae0\\u627f\\u62c5\\u660e\\u786e\\u56de\\u6536\\u4efb\\u52a1\\uff0c\\u53ef\\u5728\\u95e8\\u524d\\u8ba9\\u4ed6\\u5bf9\\u65ad\\u88c2\\u95e8\\u95e9\\u4ea7\\u751f\\u4e00\\u77ac\\u4e3b\\u52a8\\u89e6\\u78b0\\u6216\\u514b\\u5236\\u89e6\\u78b0\\u7684\\u5ff5\\u5934\\uff0c\\u5728\\u4e0d\\u63d0\\u524d\\u63ed\\u6653\\u88ad\\u51fb\\u771f\\u76f8\\u7684\\u524d\\u63d0\\u4e0b\\u5f3a\\u5316\\u8be5\\u80fd\\u529b\\u5373\\u5c06\\u7528\\u4e8e\\u8c03\\u67e5\\u7684\\u529f\\u80fd\\u6027\\u627f\\u63a5\\u3002"]	\N	0.52	0.31	2026-08-06 15:40:29.844181
0aa491d4-0ae3-4ff6-8c40-cc1f81ea703d	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	发展（十五年后新篇章开端）	6	["\\u4eba\\u4e0e\\u793e\\u4f1a", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u73af\\u5883"]	平静中的期待	0.7	\N	[{"type": "\\u8ba4\\u77e5", "content": "\\u5f00\\u7bc7\\u76f4\\u63a5\\u8de8\\u8d8a\\u5341\\u4e94\\u5e74\\uff0c\\u5c06\\u6545\\u4e8b\\u4ece\\u5b64\\u513f\\u9662\\u60e8\\u6848\\u540e\\u7684\\u5c11\\u5e74\\u65f6\\u671f\\u5207\\u6362\\u5230\\u83b1\\u5c14\\u5df2\\u7ecf\\u6210\\u4e3a\\u6301\\u7167\\u79c1\\u5bb6\\u4fa6\\u63a2\\u7684\\u6210\\u5e74\\u9636\\u6bb5\\uff0c\\u5236\\u9020\\u5f3a\\u70c8\\u7684\\u8eab\\u4efd\\u4e0e\\u65f6\\u4ee3\\u843d\\u5dee\\u3002", "strength": 9, "position": "\\u5f00\\u5934", "keyword": "\\u65f6\\u95f4\\u4e00\\u6643\\uff0c\\u5df2\\u8fc7\\u53bb\\u5341\\u4e94\\u5e74"}, {"type": "\\u60ac\\u5ff5", "content": "\\u7ba1\\u7406\\u5c40\\u5c40\\u957f\\u4f3c\\u4e4e\\u65e9\\u5df2\\u4e86\\u89e3\\u83b1\\u5c14\\uff0c\\u5e76\\u7279\\u610f\\u4ea4\\u4ee3\\u628a\\u96be\\u4ee5\\u5904\\u7406\\u7684\\u6848\\u4ef6\\u8f6c\\u7ed9\\u4ed6\\uff1b\\u5176\\u8bed\\u6c14\\u4e2d\\u7684\\u9690\\u60c5\\u6697\\u793a\\u83b1\\u5c14\\u4e0e\\u5b98\\u65b9\\u673a\\u6784\\u5b58\\u5728\\u672a\\u516c\\u5f00\\u7684\\u8fc7\\u5f80\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8bed\\u6c14\\u91cc\\u538b\\u7740\\u70b9\\u73c0\\u897f\\u74e6\\u5c14\\u542c\\u4e0d\\u61c2\\u7684\\u4e1c\\u897f"}, {"type": "\\u51b2\\u7a81", "content": "\\u585e\\u897f\\u8389\\u7684\\u6848\\u4ef6\\u56e0\\u7f3a\\u5c11\\u5f02\\u5e38\\u7c92\\u5b50\\u6ce2\\u52a8\\u88ab\\u7ba1\\u7406\\u5c40\\u62d2\\u7edd\\uff0c\\u53c8\\u5df2\\u88ab\\u6cbb\\u5b89\\u6240\\u63a8\\u8bff\\uff0c\\u5f62\\u6210\\u5e38\\u89c4\\u6267\\u6cd5\\u4f53\\u7cfb\\u4e0e\\u5f02\\u5e38\\u7ba1\\u7406\\u4f53\\u7cfb\\u4e4b\\u95f4\\u7684\\u7ba1\\u8f96\\u771f\\u7a7a\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u7ba1\\u7406\\u5c40\\u7ba1\\u4e0d\\u4e86\\u6ca1\\u6709\\u7c92\\u5b50\\u5f02\\u5e38\\u7684\\u6848\\u4ef6"}, {"type": "\\u60ac\\u5ff5", "content": "\\u683c\\u96f7\\u6587\\u8d6b\\u5f53\\u7ea2\\u4e50\\u961f\\"\\u9508\\u8537\\u8587\\"\\u7684\\u8d1d\\u65af\\u624b\\u4eb2\\u81ea\\u6c42\\u52a9\\uff0c\\u660e\\u661f\\u8eab\\u4efd\\u663e\\u8457\\u62ac\\u9ad8\\u6848\\u4ef6\\u7684\\u793e\\u4f1a\\u5f71\\u54cd\\u529b\\uff0c\\u4f46\\u5979\\u7a76\\u7adf\\u906d\\u9047\\u4e86\\u4ec0\\u4e48\\u4ecd\\u88ab\\u523b\\u610f\\u5ef6\\u540e\\u63ed\\u6653\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u8fd9\\u534a\\u5e74\\u6574\\u4e2a\\u683c\\u96f7\\u6587\\u8d6b\\u6700\\u54cd\\u7684\\u4e50\\u961f\\u540d\\u5b57"}, {"type": "\\u60c5\\u611f", "content": "\\u83b1\\u5c14\\u9762\\u5bf9\\u63d0\\u524d\\u5230\\u6765\\u7684\\u91cd\\u8981\\u5ba2\\u6237\\u4f9d\\u7136\\u4e25\\u683c\\u7b49\\u5230\\u4e5d\\u70b9\\u624d\\u5f00\\u59cb\\u5de5\\u4f5c\\uff0c\\u4ee5\\u51b7\\u5e7d\\u9ed8\\u5b8c\\u6210\\u89d2\\u8272\\u4eae\\u76f8\\uff0c\\u5e76\\u8ba9\\u7ae0\\u8282\\u505c\\u5728\\u65b0\\u6848\\u4ef6\\u6b63\\u5f0f\\u542f\\u52a8\\u7684\\u4e34\\u754c\\u70b9\\u3002", "strength": 7, "position": "\\u7ed3\\u5c3e", "keyword": "\\u6211\\u7684\\u5de5\\u4f5c\\u65f6\\u95f4\\u662f\\u4e5d\\u70b9\\u5230\\u5341\\u516b\\u70b9"}]	5	\N	[{"title": "\\u5c40\\u957f\\u4e0e\\u83b1\\u5c14\\u7684\\u9690\\u79d8\\u5173\\u7cfb", "content": "\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u5c40\\u957f\\u4e0d\\u4ec5\\u77e5\\u9053\\u83b1\\u5c14\\uff0c\\u8fd8\\u628a\\u89c4\\u7a0b\\u96be\\u4ee5\\u8986\\u76d6\\u7684\\u7279\\u6b8a\\u6848\\u4ef6\\u5bfc\\u5411\\u4ed6\\u7684\\u4e8b\\u52a1\\u6240\\uff1b\\u5176\\u610f\\u5473\\u590d\\u6742\\u7684\\u8bed\\u6c14\\u8868\\u660e\\u53cc\\u65b9\\u53ef\\u80fd\\u6709\\u65e7\\u4ea4\\u3001\\u5408\\u4f5c\\u534f\\u8bae\\u6216\\u5bf9\\u83b1\\u5c14\\u80fd\\u529b\\u7684\\u7279\\u6b8a\\u8ba4\\u77e5\\u3002", "type": "planted", "strength": 8, "subtlety": 7, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u5c40\\u957f\\u5728\\u5165\\u804c\\u65f6\\u63d0\\u8fc7\\u7684\\u4e00\\u53e5\\u8bdd", "category": "relationship", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af"], "estimated_resolve_chapter": 10}, {"title": "\\u96f6\\u7c92\\u5b50\\u5f02\\u5e38\\u6848\\u4ef6", "content": "\\u585e\\u897f\\u8389\\u6240\\u62a5\\u6848\\u4ef6\\u770b\\u4f3c\\u5177\\u6709\\u975e\\u6b63\\u5e38\\u6027\\u8d28\\uff0c\\u5374\\u6ca1\\u6709\\u5f15\\u53d1\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u6ce2\\u52a8\\u3002\\u540e\\u7eed\\u53ef\\u80fd\\u8bc1\\u660e\\u5b58\\u5728\\u80fd\\u591f\\u89c4\\u907f\\u76d1\\u6d4b\\u7684\\u80fd\\u529b\\u3001\\u975e\\u5f02\\u80fd\\u72af\\u7f6a\\u624b\\u6bb5\\u3001\\u76d1\\u6d4b\\u7cfb\\u7edf\\u76f2\\u533a\\uff0c\\u6216\\u4eba\\u4e3a\\u7be1\\u6539\\u8bb0\\u5f55\\u7684\\u60c5\\u51b5\\u3002", "type": "planted", "strength": 9, "subtlety": 4, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u5f53\\u665a\\u4e5d\\u70b9\\u5230\\u5341\\u70b9\\uff0c\\u60a8\\u6240\\u5728\\u7684\\u94dc\\u9523\\u5df7\\u53e3", "category": "mystery", "is_long_term": false, "related_characters": ["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 9}, {"title": "\\u660e\\u661f\\u5ba2\\u6237\\u7684\\u672a\\u8ff0\\u59d4\\u6258", "content": "\\u585e\\u897f\\u8389\\u4ece\\u6cbb\\u5b89\\u6240\\u8f97\\u8f6c\\u81f3\\u7ba1\\u7406\\u5c40\\uff0c\\u518d\\u5e26\\u7ecf\\u7eaa\\u4eba\\u4eb2\\u81ea\\u62dc\\u8bbf\\u83b1\\u5c14\\uff0c\\u8bf4\\u660e\\u4e8b\\u4ef6\\u5df2\\u7ecf\\u4e25\\u91cd\\u5230\\u65e0\\u6cd5\\u4f9d\\u9760\\u81ea\\u8eab\\u540d\\u6c14\\u548c\\u8d44\\u6e90\\u89e3\\u51b3\\u3002\\u7ae0\\u8282\\u523b\\u610f\\u4e0d\\u516c\\u5f00\\u62a5\\u6848\\u5185\\u5bb9\\uff0c\\u5c06\\u6848\\u4ef6\\u6838\\u5fc3\\u60ac\\u5ff5\\u7559\\u5230\\u4e0b\\u4e00\\u7ae0\\u3002", "type": "planted", "strength": 8, "subtlety": 3, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u7ba1\\u7406\\u5c40\\u4e0d\\u7ba1\\uff0c\\u63a8\\u7ed9\\u4e00\\u4e2a\\u4fa6\\u63a2", "category": "event", "is_long_term": false, "related_characters": ["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 7}]	3	0	[{"content": "\\u6545\\u4e8b\\u65f6\\u95f4\\u63a8\\u8fdb\\u5341\\u4e94\\u5e74\\uff0c\\u83b1\\u5c14\\u4ee5\\u6301\\u67aa\\u3001\\u643a\\u5e26\\u85cf\\u5251\\u624b\\u6756\\u7684\\u6301\\u7167\\u79c1\\u5bb6\\u4fa6\\u63a2\\u8eab\\u4efd\\u91cd\\u65b0\\u767b\\u573a\\u3002", "type": "transition", "importance": 1.0, "impact": "\\u5b8c\\u6210\\u5168\\u4e66\\u9636\\u6bb5\\u6027\\u8f6c\\u573a\\uff0c\\u91cd\\u7f6e\\u4eba\\u7269\\u5e74\\u9f84\\u3001\\u8eab\\u4efd\\u3001\\u793e\\u4f1a\\u73af\\u5883\\u548c\\u53d9\\u4e8b\\u7c7b\\u578b\\uff0c\\u6b63\\u5f0f\\u8fdb\\u5165\\u6210\\u5e74\\u4fa6\\u63a2\\u7bc7\\u3002", "keyword": "\\u65f6\\u95f4\\u4e00\\u6643\\uff0c\\u5df2\\u8fc7\\u53bb\\u5341\\u4e94\\u5e74"}, {"content": "\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u5df2\\u7ecf\\u5efa\\u7acb\\u516c\\u5f00\\u62a5\\u6848\\u3001\\u533a\\u57df\\u76d1\\u6d4b\\u4e0e\\u7c92\\u5b50\\u8bfb\\u6570\\u5236\\u5ea6\\uff0c\\u5f02\\u80fd\\u4ece\\u90fd\\u5e02\\u4f20\\u95fb\\u8f6c\\u53d8\\u4e3a\\u88ab\\u793e\\u4f1a\\u516c\\u5f00\\u7ba1\\u7406\\u7684\\u73b0\\u5b9e\\u3002", "type": "revelation", "importance": 0.85, "impact": "\\u5c55\\u73b0\\u5341\\u4e94\\u5e74\\u95f4\\u4e16\\u754c\\u79e9\\u5e8f\\u7684\\u91cd\\u5927\\u53d8\\u5316\\uff0c\\u5e76\\u5efa\\u7acb\\u540e\\u7eed\\u5f02\\u5e38\\u6848\\u4ef6\\u7684\\u5224\\u5b9a\\u89c4\\u5219\\u548c\\u5236\\u5ea6\\u8fb9\\u754c\\u3002", "keyword": "\\u666e\\u901a\\u5e02\\u6c11\\u5927\\u81f4\\u77e5\\u9053\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u662f\\u4ec0\\u4e48"}, {"content": "\\u585e\\u897f\\u8389\\u7684\\u6848\\u4ef6\\u6ca1\\u6709\\u4efb\\u4f55\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u5f02\\u5e38\\uff0c\\u56e0\\u6b64\\u540c\\u65f6\\u88ab\\u6cbb\\u5b89\\u6240\\u548c\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u6392\\u9664\\u5728\\u5404\\u81ea\\u7ba1\\u8f96\\u8303\\u56f4\\u4e4b\\u5916\\u3002", "type": "conflict", "importance": 0.9, "impact": "\\u5efa\\u7acb\\u65b0\\u6848\\u4ef6\\u6700\\u5173\\u952e\\u7684\\u6096\\u8bba\\uff1a\\u4e8b\\u4ef6\\u7591\\u4f3c\\u5f02\\u5e38\\uff0c\\u5374\\u4e0d\\u7b26\\u5408\\u5f02\\u5e38\\u76d1\\u6d4b\\u6807\\u51c6\\uff0c\\u8feb\\u4f7f\\u6848\\u4ef6\\u8f6c\\u5165\\u79c1\\u4eba\\u8c03\\u67e5\\u6e20\\u9053\\u3002", "keyword": "\\u6cbb\\u5b89\\u6240\\u4e5f\\u6ca1\\u4fe1\\u5979"}, {"content": "\\u73c0\\u897f\\u74e6\\u5c14\\u9075\\u7167\\u5c40\\u957f\\u66fe\\u7ecf\\u7684\\u6697\\u793a\\uff0c\\u5c06\\u68d8\\u624b\\u6848\\u4ef6\\u8f6c\\u4ecb\\u7ed9\\u83b1\\u5c14\\u3002", "type": "transition", "importance": 0.88, "impact": "\\u628a\\u7ba1\\u7406\\u5c40\\u62a5\\u6848\\u7ebf\\u4e0e\\u83b1\\u5c14\\u7684\\u4fa6\\u63a2\\u7ebf\\u6c47\\u5408\\uff0c\\u540c\\u65f6\\u57cb\\u4e0b\\u5c40\\u957f\\u4e3a\\u4f55\\u4e86\\u89e3\\u5e76\\u4fe1\\u4efb\\u83b1\\u5c14\\u7684\\u5173\\u7cfb\\u60ac\\u5ff5\\u3002", "keyword": "\\u8ba9\\u4ed6\\u4eec\\u53bb\\u627e\\u90a3\\u4e2a\\u83b1\\u5c14\\u4fa6\\u63a2"}, {"content": "\\u6765\\u8bbf\\u8005\\u88ab\\u786e\\u8ba4\\u662f\\u5f53\\u7ea2\\u4e50\\u961f\\u9508\\u8537\\u8587\\u7684\\u8d1d\\u65af\\u624b\\u585e\\u897f\\u8389\\uff0c\\u83b1\\u5c14\\u5728\\u4e5d\\u70b9\\u6574\\u6b63\\u5f0f\\u9080\\u8bf7\\u5979\\u4eec\\u4e0a\\u697c\\u8be6\\u8c08\\u3002", "type": "revelation", "importance": 0.82, "impact": "\\u63d0\\u5347\\u6848\\u4ef6\\u7684\\u516c\\u4f17\\u5f71\\u54cd\\u529b\\uff0c\\u4ee5\\u8f7b\\u677e\\u7684\\u5de5\\u4f5c\\u65f6\\u95f4\\u7b11\\u70b9\\u7ed3\\u675f\\u94fa\\u57ab\\uff0c\\u5e76\\u5c06\\u8bfb\\u8005\\u6ce8\\u610f\\u529b\\u5f15\\u5411\\u4e0b\\u4e00\\u7ae0\\u7684\\u59d4\\u6258\\u5185\\u5bb9\\u3002", "keyword": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1\\u3002\\u8fd9\\u4f4d\\u662f\\u6211\\u7684\\u7ecf\\u7eaa\\u4eba"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u751f\\u6d3b\\u89c4\\u5f8b\\u3001\\u51b7\\u9759\\u81ea\\u6301\\uff0c\\u4ee5\\u9ad8\\u5ea6\\u56fa\\u5b9a\\u7684\\u6668\\u95f4\\u6d41\\u7a0b\\u7ef4\\u6301\\u79e9\\u5e8f", "state_after": "\\u9762\\u5bf9\\u7279\\u6b8a\\u5ba2\\u6237\\u4ecd\\u4ece\\u5bb9\\u638c\\u63a7\\u8282\\u594f\\uff0c\\u51c6\\u5907\\u6b63\\u5f0f\\u63a5\\u624b\\u65b0\\u7684\\u59d4\\u6258", "psychological_change": "\\u672c\\u7ae0\\u6ca1\\u6709\\u5267\\u70c8\\u5fc3\\u7406\\u8f6c\\u6298\\uff0c\\u4e3b\\u8981\\u5b8c\\u6210\\u6210\\u5e74\\u83b1\\u5c14\\u7684\\u72b6\\u6001\\u5c55\\u793a\\u3002\\u4ed6\\u5bf9\\u73af\\u5883\\u3001\\u65f6\\u95f4\\u3001\\u6b66\\u5668\\u548c\\u884c\\u52a8\\u8def\\u7ebf\\u5747\\u4fdd\\u6301\\u7cbe\\u786e\\u63a7\\u5236\\uff0c\\u540c\\u65f6\\u4ee5\\u7565\\u663e\\u540a\\u513f\\u90ce\\u5f53\\u7684\\u65b9\\u5f0f\\u575a\\u6301\\u5de5\\u4f5c\\u65f6\\u95f4\\uff0c\\u4f53\\u73b0\\u51b7\\u9759\\u4e25\\u8c28\\u4e0e\\u51b7\\u5e7d\\u9ed8\\u5e76\\u5b58\\u7684\\u6027\\u683c\\u3002", "key_event": "\\u5728\\u4e5d\\u70b9\\u6574\\u63a5\\u5f85\\u88ab\\u6cbb\\u5b89\\u6240\\u4e0e\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u5171\\u540c\\u62d2\\u7edd\\u7684\\u585e\\u897f\\u8389\\u548c\\u54c8\\u91cc\\u7279", "relationship_changes": {"\\u683c\\u857e\\u4e1d": "\\u591a\\u5e74\\u5171\\u540c\\u751f\\u6d3b\\u5f62\\u6210\\u7a33\\u5b9a\\u3001\\u81ea\\u7136\\u4e14\\u63a5\\u8fd1\\u5bb6\\u4eba\\u7684\\u4fe1\\u4efb\\u5173\\u7cfb", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u7531\\u964c\\u751f\\u4eba\\u8f6c\\u53d8\\u4e3a\\u6f5c\\u5728\\u59d4\\u6258\\u4eba", "\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f": "\\u7531\\u964c\\u751f\\u4eba\\u8f6c\\u53d8\\u4e3a\\u6f5c\\u5728\\u59d4\\u6258\\u4eba\\u7684\\u4ee3\\u7406\\u4e0e\\u6848\\u4ef6\\u53c2\\u4e0e\\u8005", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af": "\\u5c1a\\u672a\\u76f4\\u63a5\\u89c1\\u9762\\uff0c\\u4f46\\u56e0\\u5176\\u8f6c\\u4ecb\\u800c\\u5f62\\u6210\\u95f4\\u63a5\\u4e1a\\u52a1\\u8054\\u7cfb"}}, {"character_name": "\\u683c\\u857e\\u4e1d", "survival_status": null, "state_before": "\\u5e73\\u548c\\u4eb2\\u5207\\uff0c\\u7167\\u5e38\\u4e3a\\u83b1\\u5c14\\u51c6\\u5907\\u65e9\\u9910\\u5e76\\u7ecf\\u8425\\u5496\\u5561\\u5385", "state_after": "\\u56e0\\u786e\\u8ba4\\u5f53\\u7ea2\\u4e50\\u961f\\u6210\\u5458\\u5230\\u8bbf\\u800c\\u9707\\u60ca\\u5174\\u594b", "psychological_change": "\\u4ece\\u719f\\u6089\\u7684\\u65e5\\u5e38\\u7167\\u6599\\u72b6\\u6001\\u8fc5\\u901f\\u8f6c\\u4e3a\\u9762\\u5bf9\\u540d\\u4eba\\u7684\\u5931\\u63aa\\uff0c\\u589e\\u5f3a\\u4e86\\u5496\\u5561\\u5385\\u751f\\u6d3b\\u6c14\\u606f\\uff0c\\u4e5f\\u501f\\u5979\\u7684\\u53cd\\u5e94\\u5411\\u4e0d\\u719f\\u6089\\u4e50\\u961f\\u7684\\u83b1\\u5c14\\u548c\\u8bfb\\u8005\\u8bf4\\u660e\\u585e\\u897f\\u8389\\u7684\\u77e5\\u540d\\u5ea6\\u3002", "key_event": "\\u8ba4\\u51fa\\u585e\\u897f\\u8389\\u662f\\u9508\\u8537\\u8587\\u4e50\\u961f\\u7684\\u8d1d\\u65af\\u624b", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u957f\\u671f\\u7167\\u6599\\u4e0e\\u9ed8\\u5951\\u8fdb\\u4e00\\u6b65\\u5f97\\u5230\\u751f\\u6d3b\\u5316\\u786e\\u8ba4", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4ece\\u666e\\u901a\\u5ba2\\u4eba\\u8f6c\\u53d8\\u4e3a\\u4ee4\\u5979\\u60ca\\u8bb6\\u7684\\u77e5\\u540d\\u4e50\\u624b"}}, {"character_name": "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "survival_status": null, "state_before": "\\u4f5c\\u4e3a\\u521a\\u5165\\u804c\\u4e0d\\u4e45\\u7684\\u7ba1\\u7406\\u5c40\\u804c\\u5458\\uff0c\\u4e25\\u683c\\u4f9d\\u7167\\u7c92\\u5b50\\u8bfb\\u6570\\u548c\\u53d7\\u7406\\u89c4\\u7a0b\\u529e\\u4e8b", "state_after": "\\u5728\\u5236\\u5ea6\\u65e0\\u6cd5\\u8986\\u76d6\\u6848\\u4ef6\\u65f6\\u91c7\\u53d6\\u6298\\u4e2d\\u529e\\u6cd5\\uff0c\\u5c06\\u585e\\u897f\\u8389\\u8f6c\\u4ecb\\u7ed9\\u83b1\\u5c14", "psychological_change": "\\u4ed6\\u5148\\u4ee5\\u89c4\\u7a0b\\u62d2\\u7edd\\u6848\\u4ef6\\uff0c\\u968f\\u540e\\u610f\\u8bc6\\u5230\\u6cbb\\u5b89\\u6240\\u540c\\u6837\\u4e0d\\u613f\\u53d7\\u7406\\uff0c\\u9677\\u5165\\u4e3a\\u96be\\u3002\\u6700\\u7ec8\\u60f3\\u8d77\\u5c40\\u957f\\u7684\\u4ea4\\u4ee3\\uff0c\\u5728\\u4e0d\\u7a81\\u7834\\u7ba1\\u7406\\u5c40\\u89c4\\u5b9a\\u7684\\u524d\\u63d0\\u4e0b\\u4e3a\\u62a5\\u6848\\u4eba\\u63d0\\u4f9b\\u51fa\\u8def\\uff0c\\u8868\\u73b0\\u51fa\\u5c1a\\u672a\\u88ab\\u5b98\\u50da\\u4f53\\u7cfb\\u5b8c\\u5168\\u78e8\\u5e73\\u7684\\u8d23\\u4efb\\u611f\\u3002", "key_event": "\\u5199\\u4e0b\\u897f\\u5965\\u591a\\u4fa6\\u63a2\\u4e8b\\u52a1\\u6240\\u7684\\u5730\\u5740\\u5e76\\u4ea4\\u7ed9\\u585e\\u897f\\u8389", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4ece\\u62a5\\u6848\\u4eba\\u4e0e\\u53d7\\u7406\\u4eba\\u5458\\u8f6c\\u4e3a\\u8f6c\\u4ecb\\u8005\\u4e0e\\u88ab\\u8f6c\\u4ecb\\u8005", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4ece\\u53ea\\u542c\\u8fc7\\u540d\\u5b57\\u8f6c\\u4e3a\\u5b9e\\u9645\\u5411\\u5176\\u8f93\\u9001\\u7279\\u6b8a\\u6848\\u4ef6"}}, {"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": null, "state_before": "\\u56e0\\u6848\\u4ef6\\u63a5\\u8fde\\u906d\\u5230\\u6cbb\\u5b89\\u6240\\u548c\\u7ba1\\u7406\\u5c40\\u63a8\\u8bff\\u800c\\u538b\\u6291\\u3001\\u4e0d\\u6ee1\\u4e14\\u6212\\u5907", "state_after": "\\u62b5\\u8fbe\\u4fa6\\u63a2\\u4e8b\\u52a1\\u6240\\uff0c\\u6682\\u65f6\\u538b\\u4e0b\\u8d28\\u7591\\u5e76\\u7b49\\u5f85\\u83b1\\u5c14\\u53d7\\u7406", "psychological_change": "\\u5979\\u5728\\u7ba1\\u7406\\u5c40\\u59cb\\u7ec8\\u6234\\u7740\\u58a8\\u955c\\u5e76\\u4fdd\\u6301\\u7d27\\u7ef7\\uff0c\\u8bf4\\u660e\\u5176\\u660e\\u661f\\u8eab\\u4efd\\u53ef\\u80fd\\u5e26\\u6765\\u989d\\u5916\\u987e\\u8651\\u3002\\u5c3d\\u7ba1\\u4e0d\\u6ee1\\u6848\\u4ef6\\u88ab\\u63a8\\u7ed9\\u79c1\\u4eba\\u4fa6\\u63a2\\uff0c\\u5979\\u4ecd\\u63a5\\u53d7\\u5730\\u5740\\u5e76\\u4eb2\\u81ea\\u524d\\u5f80\\uff0c\\u8868\\u660e\\u89e3\\u51b3\\u95ee\\u9898\\u7684\\u9700\\u6c42\\u5df2\\u7ecf\\u8d85\\u8fc7\\u5bf9\\u7a0b\\u5e8f\\u548c\\u8eab\\u4efd\\u7684\\u987e\\u5fcc\\u3002", "key_event": "\\u63a5\\u53d7\\u73c0\\u897f\\u74e6\\u5c14\\u7684\\u8f6c\\u4ecb\\u5e76\\u6765\\u5230\\u6708\\u5b63\\u5496\\u5561\\u5385\\u7b49\\u5f85\\u83b1\\u5c14", "relationship_changes": {"\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af": "\\u5bf9\\u5176\\u4ee3\\u8868\\u7684\\u7ba1\\u7406\\u5c40\\u62b1\\u6709\\u4e0d\\u6ee1\\uff0c\\u4f46\\u63a5\\u53d7\\u4e86\\u4ed6\\u7684\\u79c1\\u4eba\\u5efa\\u8bae", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u9996\\u6b21\\u89c1\\u9762\\uff0c\\u5efa\\u7acb\\u6f5c\\u5728\\u59d4\\u6258\\u5173\\u7cfb", "\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f": "\\u7ecf\\u7eaa\\u4eba\\u966a\\u540c\\u5904\\u7406\\u5371\\u673a\\uff0c\\u663e\\u793a\\u53cc\\u65b9\\u5177\\u6709\\u7a33\\u5b9a\\u7684\\u5de5\\u4f5c\\u4fe1\\u4efb"}}, {"character_name": "\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f", "survival_status": null, "state_before": "\\u4ee5\\u7a33\\u91cd\\u59ff\\u6001\\u966a\\u540c\\u585e\\u897f\\u8389\\u5bfb\\u6c42\\u5e2e\\u52a9", "state_after": "\\u4e3b\\u52a8\\u4ee3\\u8868\\u4e24\\u4eba\\u8fdb\\u884c\\u4ecb\\u7ecd\\uff0c\\u534f\\u52a9\\u5f00\\u542f\\u4e0e\\u83b1\\u5c14\\u7684\\u6b63\\u5f0f\\u6c9f\\u901a", "psychological_change": "\\u6574\\u4f53\\u4fdd\\u6301\\u51b7\\u9759\\u7a33\\u5b9a\\uff0c\\u6ca1\\u6709\\u660e\\u663e\\u60c5\\u7eea\\u6ce2\\u52a8\\u3002\\u5979\\u627f\\u62c5\\u793e\\u4ea4\\u4e0e\\u6c9f\\u901a\\u804c\\u8d23\\uff0c\\u4e0e\\u585e\\u897f\\u8389\\u7684\\u6212\\u5907\\u5f62\\u6210\\u4e92\\u8865\\uff0c\\u4f53\\u73b0\\u7ecf\\u7eaa\\u4eba\\u7684\\u804c\\u4e1a\\u6027\\u3002", "key_event": "\\u7387\\u5148\\u5411\\u83b1\\u5c14\\u5f00\\u53e3\\u5e76\\u4ecb\\u7ecd\\u585e\\u897f\\u8389\\u4e0e\\u81ea\\u5df1", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u7ef4\\u6301\\u4fdd\\u62a4\\u3001\\u966a\\u540c\\u548c\\u5bf9\\u5916\\u6c9f\\u901a\\u7684\\u7ecf\\u7eaa\\u5173\\u7cfb", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u5efa\\u7acb\\u521d\\u6b65\\u4e1a\\u52a1\\u63a5\\u89e6"}}, {"character_name": "\\u9732\\u897f", "survival_status": null, "state_before": "\\u56e0\\u524d\\u4e24\\u5929\\u8f83\\u5c11\\u5916\\u51fa\\u800c\\u7b49\\u5f85\\u83b1\\u5c14\\u5e26\\u5b83\\u6563\\u6b65", "state_after": "\\u5b8c\\u6210\\u6668\\u95f4\\u6563\\u6b65\\u5e76\\u88ab\\u9001\\u56de\\u6708\\u5b63\\u5496\\u5561\\u5385\\u540e\\u9662", "psychological_change": "\\u89c1\\u5230\\u83b1\\u5c14\\u540e\\u660e\\u663e\\u653e\\u677e\\uff0c\\u8bf4\\u660e\\u5b83\\u5bf9\\u83b1\\u5c14\\u9ad8\\u5ea6\\u719f\\u6089\\u548c\\u4fe1\\u4efb\\u3002\\u8be5\\u6bb5\\u4e3b\\u8981\\u7528\\u4e8e\\u5f3a\\u5316\\u83b1\\u5c14\\u7a33\\u5b9a\\u3001\\u6e29\\u548c\\u7684\\u751f\\u6d3b\\u4fa7\\u9762\\u3002", "key_event": "\\u4e0e\\u83b1\\u5c14\\u6cbf\\u8857\\u9053\\u5411\\u6cb3\\u5cb8\\u65b9\\u5411\\u6563\\u6b65", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u8fdb\\u4e00\\u6b65\\u4f53\\u73b0\\u957f\\u671f\\u966a\\u4f34\\u5f62\\u6210\\u7684\\u4fe1\\u4efb\\u4e0e\\u4eb2\\u8fd1"}}]	[{"location": "\\u897f\\u5965\\u591a\\u4fa6\\u63a2\\u4e8b\\u52a1\\u6240\\u4e0e\\u6708\\u5b63\\u5496\\u5561\\u5385", "atmosphere": "\\u5b89\\u7a33\\u3001\\u751f\\u6d3b\\u5316\\u3001\\u5e26\\u6709\\u84b8\\u6c7d\\u90fd\\u5e02\\u6668\\u95f4\\u6c14\\u606f", "duration": "\\u7ea6\\u4e09\\u5341\\u5206\\u949f"}, {"location": "\\u683c\\u96f7\\u6587\\u8d6b\\u5f02\\u5e38\\u7ba1\\u7406\\u5c40\\u4e00\\u697c\\u62a5\\u6848\\u53f0", "atmosphere": "\\u514b\\u5236\\u3001\\u7a0b\\u5e8f\\u5316\\u3001\\u5145\\u6ee1\\u5236\\u5ea6\\u6027\\u65e0\\u5948", "duration": "\\u7ea6\\u5341\\u81f3\\u5341\\u4e94\\u5206\\u949f"}, {"location": "\\u6708\\u5b63\\u5496\\u5561\\u5385\\u53ca\\u901a\\u5f80\\u4e8c\\u697c\\u7684\\u697c\\u68af", "atmosphere": "\\u7531\\u5e73\\u9759\\u7b49\\u5f85\\u8f6c\\u4e3a\\u60ca\\u8bb6\\u3001\\u597d\\u5947\\u4e0e\\u8f7b\\u677e\\u5e7d\\u9ed8", "duration": "\\u7ea6\\u4e94\\u5206\\u949f"}]	varied	8.2	8.4	8.6	7.5	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.2/10\n  节奏把控: 8.4/10\n  吸引力: 8.6/10\n  连贯性: 7.5/10\n\n【剧情阶段】发展（十五年后新篇章开端）\n\n【钩子分析】共5个\n  • [认知] 开篇直接跨越十五年，将故事从孤儿院惨案后的少年时期切换到莱尔已经成为持照私家侦探的成年阶段，制造强烈... (强度:9)\n  • [悬念] 管理局局长似乎早已了解莱尔，并特意交代把难以处理的案件转给他；其语气中的隐情暗示莱尔与官方机构存在未... (强度:8)\n  • [冲突] 塞西莉的案件因缺少异常粒子波动被管理局拒绝，又已被治安所推诿，形成常规执法体系与异常管理体系之间的管... (强度:8)\n\n【伏笔分析】埋下5个, 回收0个\n\n【冲突分析】\n  类型: 人与社会, 人与人, 人与环境\n  强度: 6/10\n  进度: 15%\n\n【改进建议】\n  1. 【主线连贯性】十五年时间跳跃后，本章没有回收或重新提示萨姆失踪与绑架目的、无牌马车断纹车辙等此前重点伏笔，容易让读者误以为旧主线被搁置；建议在莱尔整理旧案卷、观察武器或局长提及他时加入一句与晨星孤儿院旧案相关的细节，以确认成年侦探线仍与早期惨案主线相连。	["\\u3010\\u4e3b\\u7ebf\\u8fde\\u8d2f\\u6027\\u3011\\u5341\\u4e94\\u5e74\\u65f6\\u95f4\\u8df3\\u8dc3\\u540e\\uff0c\\u672c\\u7ae0\\u6ca1\\u6709\\u56de\\u6536\\u6216\\u91cd\\u65b0\\u63d0\\u793a\\u8428\\u59c6\\u5931\\u8e2a\\u4e0e\\u7ed1\\u67b6\\u76ee\\u7684\\u3001\\u65e0\\u724c\\u9a6c\\u8f66\\u65ad\\u7eb9\\u8f66\\u8f99\\u7b49\\u6b64\\u524d\\u91cd\\u70b9\\u4f0f\\u7b14\\uff0c\\u5bb9\\u6613\\u8ba9\\u8bfb\\u8005\\u8bef\\u4ee5\\u4e3a\\u65e7\\u4e3b\\u7ebf\\u88ab\\u6401\\u7f6e\\uff1b\\u5efa\\u8bae\\u5728\\u83b1\\u5c14\\u6574\\u7406\\u65e7\\u6848\\u5377\\u3001\\u89c2\\u5bdf\\u6b66\\u5668\\u6216\\u5c40\\u957f\\u63d0\\u53ca\\u4ed6\\u65f6\\u52a0\\u5165\\u4e00\\u53e5\\u4e0e\\u6668\\u661f\\u5b64\\u513f\\u9662\\u65e7\\u6848\\u76f8\\u5173\\u7684\\u7ec6\\u8282\\uff0c\\u4ee5\\u786e\\u8ba4\\u6210\\u5e74\\u4fa6\\u63a2\\u7ebf\\u4ecd\\u4e0e\\u65e9\\u671f\\u60e8\\u6848\\u4e3b\\u7ebf\\u76f8\\u8fde\\u3002"]	\N	0.39	0.46	2026-08-07 00:31:38.684215
a299b8f5-e680-4e06-858c-72fc80588a89	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	紧张悬疑	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u5341\\u4e8c\\u4efd\\u4f5c\\u5e9f\\u6837\\u7a3f\\u4e2d\\u6709\\u4e00\\u5f20\\u7f16\\u53f7\\u4e03\\u4e09\\u4e03\\u7684\\u7eb8\\u89d2\\u7f3a\\u5931\\uff0c\\u9500\\u6bc1\\u8bb0\\u5f55\\u5199\\u7740\\u5341\\u4e00\\u4efd\\uff0c\\u4f46\\u5b9e\\u9645\\u4e0a\\u5c11\\u4e86\\u4e00\\u5f20\\uff0c\\u8f7d\\u6709\\u53e3\\u4ee4\\u7684\\u5173\\u952e\\u5e9f\\u7a3f\\u4e0b\\u843d\\u4e0d\\u660e\\u3002", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u4e00\\u76f4\\u5230\\u4e03\\u56db\\u4e8c\\u3002\\u4e2d\\u95f4\\u7a7a\\u4e86\\u4e03\\u4e09\\u4e03\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u5370\\u52a1\\u5382\\u95ea\\u56de\\u4e2d\\uff0c\\u4e00\\u4e2a\\u6234\\u8584\\u76ae\\u624b\\u5957\\u3001\\u7070\\u8272\\u8896\\u53e3\\u3001\\u80f8\\u524d\\u522b\\u7740\\u91d1\\u8272\\u9e1f\\u7b3c\\u73d0\\u7405\\u5fbd\\u7ae0\\u7684\\u795e\\u79d8\\u4eba\\u5077\\u5077\\u62bd\\u8d70\\u4e86\\u5e9f\\u7a3f\\uff0c\\u6b64\\u4eba\\u8eab\\u4efd\\u672a\\u660e\\uff0c\\u4f46\\u91d1\\u8272\\u9e1f\\u7b3c\\u4e0e\\"\\u91d1\\u7b3c\\u6f14\\u827a\\"\\u5f62\\u6210\\u5f3a\\u70c8\\u547c\\u5e94\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u53ea\\u80fd\\u770b\\u89c1\\u80f8\\u524d\\u522b\\u7740\\u4e00\\u679a\\u5c0f\\u5c0f\\u7684\\u73d0\\u7405\\u5fbd\\u7ae0"}, {"type": "\\u60ac\\u5ff5", "content": "\\u8d35\\u5bbe\\u5e2d\\u7b2c\\u4e00\\u6392\\u5341\\u4e8c\\u53f7\\u7684\\u8d2d\\u4e70\\u4eba\\u5965\\u65af\\u6c40\\u00b7\\u67ef\\u5c14\\u5df2\\u6b7b\\u4e09\\u5e74\\uff0c\\u7968\\u6b3e\\u7ecf\\u4e09\\u5c42\\u7a7a\\u58f3\\u516c\\u53f8\\u8f6c\\u8d26\\uff0c\\u62c5\\u4fdd\\u4eba\\u4e3a\\u91d1\\u7b3c\\u6f14\\u827a\\u8d22\\u52a1\\u4e3b\\u7ba1\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b\\u2014\\u2014\\u6b7b\\u4eba\\u4e3a\\u4f55\\u4e70\\u7968\\uff1f\\u6d3b\\u4eba\\u60f3\\u5e72\\u4ec0\\u4e48\\uff1f", "strength": 9, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8d2d\\u4e70\\u4eba\\u5199\\u7740\\uff1a\\u5965\\u65af\\u6c40\\u00b7\\u67ef\\u5c14\\u3002"}, {"type": "\\u8ba4\\u77e5", "content": "\\u6728\\u5076\\u66ff\\u8eab\\u7684\\u771f\\u6b63\\u76ee\\u7684\\u4e0d\\u662f\\u6f14\\u620f\\uff0c\\u800c\\u662f\\u8ba9\\u66ff\\u8eab\\u7b7e\\u6536\\u636e\\u3001\\u6539\\u5408\\u540c\\u3001\\u5e94\\u4ed8\\u719f\\u4eba\\u2014\\u2014\\u8fd9\\u662f\\u4e00\\u573a\\u6df1\\u5ea6\\u8eab\\u4efd\\u66ff\\u6362\\u7684\\u7ecf\\u6d4e\\u9634\\u8c0b\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u662f\\u4e3a\\u4e86\\u8ba9\\u66ff\\u8eab\\u80fd\\u7b7e\\u6536\\u636e\\u3001\\u6539\\u5408\\u540c"}, {"type": "\\u60ac\\u5ff5", "content": "\\u949f\\u697c\\u6307\\u9488\\u505c\\u5728\\u5341\\u4e00\\u70b9\\u5374\\u6572\\u54cd\\u4e86\\u7b2c\\u5341\\u4e00\\u58f0\\uff0c\\u7968\\u52a1\\u8001\\u5934\\u6570\\u5230\\u5341\\u4e00\\u58f0\\u65f6\\u8138\\u8272\\u53d1\\u767d\\u2014\\u2014\\u5267\\u9662\\u7684\\u65f6\\u95f4\\u4f3c\\u4e4e\\u4e0e\\u949f\\u8868\\u8131\\u8282\\uff0c\\u9690\\u542b\\u8d85\\u5e38\\u73b0\\u8c61\\u3002", "strength": 7, "position": "\\u7ed3\\u5c3e", "keyword": "\\u505c\\u5728\\u5341\\u4e00\\u70b9\\u7684\\u6307\\u9488\\u6ca1\\u6709\\u52a8"}, {"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u6495\\u4e0b\\u7b2c\\u4e00\\u6392\\u5341\\u4e8c\\u53f7\\u7684\\u7968\\u6839\\uff0c\\u58f0\\u79f0\\u8981\\u8ba9\\u6b7b\\u4eba\\u5750\\u8fdb\\u8d35\\u5bbe\\u5e2d\\u2014\\u2014\\u4ed6\\u663e\\u7136\\u5df2\\u8ba1\\u5212\\u7528\\u8fd9\\u5f20\\"\\u6b7b\\u4eba\\u7684\\u7968\\"\\u53cd\\u8fc7\\u6765\\u8bbe\\u8ba1\\u91d1\\u7b3c\\u6f14\\u827a\\u3002", "strength": 9, "position": "\\u7ed3\\u5c3e", "keyword": "\\u6240\\u4ee5\\u6f14\\u51fa\\u90a3\\u5929\\uff0c\\u8ba9\\u6b7b\\u4eba\\u5750\\u8fdb\\u6765\\u3002"}]	6	\N	[{"title": "\\u6728\\u5076\\u7684\\u5bdf\\u89c9\\u5f0f\\u5fae\\u7b11", "content": "\\u83b1\\u5c14\\u56de\\u60f3\\u8d77\\u6728\\u5076\\u6b6a\\u5934\\u770b\\u4ed6\\u7684\\u6837\\u5b50\\uff0c\\u73b0\\u5728\\u786e\\u8ba4\\u90a3\\u5e76\\u975e\\u5bdf\\u89c9\\u4e86\\u4ed6\\u7684\\u80fd\\u529b\\uff0c\\u800c\\u662f\\u88ab\\u6559\\u51fa\\u6765\\u7684\\u6a21\\u4eff\\u2014\\u2014\\u6709\\u4eba\\u76ef\\u7740\\u5979\\u65f6\\u739b\\u8482\\u5c14\\u8fbe\\u4f1a\\u600e\\u4e48\\u7b11\\uff0c\\u66ff\\u8eab\\u88ab\\u8bad\\u7ec3\\u5f97\\u66f4\\u50cf\\u6d3b\\u4eba\\uff0c\\u53ea\\u662f\\u706b\\u5019\\u4e0d\\u5230\\uff0c\\u7b11\\u8d77\\u6765\\u50cf\\u5728\\u91cf\\u4ed6\\u7684\\u8116\\u5b50\\u3002", "type": "resolved", "strength": 8, "subtlety": 6, "reference_chapter": 9, "reference_foreshadow_id": "314ff99f-386d-44be-b830-10d16c079381", "keyword": "\\u6709\\u4eba\\u76ef\\u7740\\u5979\\u65f6\\uff0c\\u739b\\u8482\\u5c14\\u8fbe\\u4f1a\\u600e\\u4e48\\u7b11", "category": "mystery", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"], "estimated_resolve_chapter": 12}, {"title": "\\u739b\\u8482\\u5c14\\u8fbe\\u56da\\u7981\\u5904\\u7684\\u6c14\\u5473\\u7ebf\\u7d22", "content": "\\u5e9f\\u7a3f\\u4e0a\\u6cbe\\u6709\\u6df7\\u7740\\u9c7c\\u80f6\\u7684\\u677e\\u8102\\u6c61\\u8ff9\\uff0c\\u4e0e\\u516d\\u7801\\u5934\\u8d27\\u4ed3\\u5f25\\u6f2b\\u7684\\u6c14\\u5473\\u4e00\\u81f4\\uff0c\\u8bc1\\u5b9e\\u5173\\u62bc\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u8d27\\u4ed3\\u786e\\u5b9e\\u5904\\u7406\\u8fc7\\u5370\\u5237\\u54c1\\u2014\\u2014\\u6c14\\u5473\\u7ebf\\u7d22\\u4ece\\u62bd\\u8c61\\u7684\\u611f\\u77e5\\u8bb0\\u5fc6\\u8f6c\\u5316\\u4e3a\\u5b9e\\u8d28\\u7269\\u8bc1\\u94fe\\u3002", "type": "resolved", "strength": 7, "subtlety": 6, "reference_chapter": 9, "reference_foreshadow_id": "836ee5ff-ea57-4739-a6c2-ce292a290e54", "keyword": "\\u516d\\u7801\\u5934\\u8d27\\u4ed3\\u91cc\\u4e5f\\u662f\\u8fd9\\u4e2a\\u5473", "category": "mystery", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"], "estimated_resolve_chapter": 12}, {"title": "\\u6728\\u5076\\u64cd\\u63a7\\u8005\\u4e0e\\u5e55\\u540e\\u4e3b\\u4f7f", "content": "\\u91d1\\u7b3c\\u6f14\\u827a\\u9996\\u6b21\\u6d6e\\u51fa\\u6c34\\u9762\\u2014\\u2014\\u5176\\u8d22\\u52a1\\u4e3b\\u7ba1\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b\\u4e3a\\u6b7b\\u4eba\\u8d35\\u5bbe\\u7968\\u5c42\\u5c42\\u62c5\\u4fdd\\uff0c\\u91d1\\u7b3c\\u6f14\\u827a\\u4e0e\\u9508\\u8537\\u8587\\u7ade\\u4e89\\u5317\\u533a\\u5de1\\u6f14\\u5408\\u7ea6\\uff0c\\u6728\\u5076\\u66ff\\u8eab\\u8ba1\\u5212\\u7684\\u5229\\u76ca\\u52a8\\u673a\\u6307\\u5411\\u8be5\\u516c\\u53f8\\u3002", "type": "resolved", "strength": 8, "subtlety": 5, "reference_chapter": 10, "reference_foreshadow_id": "c74dbf26-94da-4a3d-9064-9ac7c60ac86b", "keyword": "\\u91d1\\u7b3c\\u6f14\\u827a\\u516c\\u53f8\\u7684\\u8d22\\u52a1\\u4e3b\\u7ba1", "category": "identity", "is_long_term": false, "related_characters": ["\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b", "\\u91d1\\u7b3c\\u6f14\\u827a"], "estimated_resolve_chapter": 12}]	0	3	[{"content": "\\u5341\\u4e8c\\u4efd\\u4f5c\\u5e9f\\u7a3f\\u4e2d\\u7f3a\\u5931\\u4e03\\u4e09\\u4e03\\u53f7\\u7eb8\\u89d2\\uff0c\\u9500\\u6bc1\\u8bb0\\u5f55\\u4e0e\\u5b9e\\u9645\\u4ef6\\u6570\\u5b58\\u5728\\u51fa\\u5165\\uff0c\\u53e3\\u4ee4\\u6cc4\\u5bc6\\u7684\\u6e90\\u5934\\u88ab\\u9501\\u5b9a\\u5728\\u5370\\u52a1\\u5382\\u73af\\u8282\\u3002", "type": "revelation", "importance": 0.9, "impact": "\\u6392\\u9664\\u4e50\\u961f\\u5185\\u90e8\\u76f4\\u63a5\\u5acc\\u7591\\uff0c\\u5c06\\u6574\\u6848\\u8c03\\u67e5\\u65b9\\u5411\\u4ece\\u5185\\u9b3c\\u62bd\\u4e1d\\u8f6c\\u5411\\u5916\\u90e8\\u52bf\\u529b\\u8fd0\\u4f5c\\u3002", "keyword": "\\u4e00\\u76f4\\u5230\\u4e03\\u56db\\u4e8c\\u3002\\u4e2d\\u95f4\\u7a7a\\u4e86\\u4e03\\u4e09\\u4e03\\u3002"}, {"content": "\\u5370\\u52a1\\u5382\\u8bb0\\u5fc6\\u95ea\\u56de\\u4e2d\\uff0c\\u7070\\u8863\\u4eba\\u8d81\\u5b66\\u5f92\\u70b9\\u5e9f\\u7a3f\\u65f6\\u5077\\u8d70\\u4e03\\u4e09\\u4e03\\uff0c\\u80f8\\u524d\\u91d1\\u8272\\u9e1f\\u7b3c\\u73d0\\u7405\\u5fbd\\u7ae0\\u6210\\u4e3a\\u6307\\u8ba4\\u91d1\\u7b3c\\u6f14\\u827a\\u7684\\u5173\\u952e\\u7269\\u8bc1\\u3002", "type": "revelation", "importance": 0.85, "impact": "\\u5e55\\u540e\\u7ec4\\u7ec7\\u7684\\u6267\\u884c\\u5c42\\u9996\\u6b21\\u5177\\u8c61\\u5316\\uff0c\\u5fbd\\u7ae0\\u6210\\u4e3a\\u53ef\\u4ee5\\u8ffd\\u8e2a\\u7684\\u8eab\\u4efd\\u6807\\u8bb0\\u3002", "keyword": "\\u53ea\\u80fd\\u770b\\u89c1\\u80f8\\u524d\\u522b\\u7740\\u4e00\\u679a\\u5c0f\\u5c0f\\u7684\\u73d0\\u7405\\u5fbd\\u7ae0"}, {"content": "\\u8d35\\u5bbe\\u5e2d\\u7b2c\\u4e00\\u6392\\u5341\\u4e8c\\u53f7\\u7531\\u5df2\\u6b7b\\u4e09\\u5e74\\u7684\\u5965\\u65af\\u6c40\\u00b7\\u67ef\\u5c14\\u540d\\u4e0b\\u8d2d\\u4e70\\uff0c\\u7968\\u6b3e\\u7ecf\\u949f\\u8868\\u8d38\\u6613\\u884c\\u3001\\u8d27\\u8fd0\\u4ee3\\u7406\\u3001\\u821e\\u53f0\\u5668\\u6750\\u79df\\u8d41\\u884c\\u4e09\\u6b21\\u4e2d\\u8f6c\\uff0c\\u6700\\u7ec8\\u62c5\\u4fdd\\u4eba\\u6307\\u5411\\u91d1\\u7b3c\\u6f14\\u827a\\u8d22\\u52a1\\u4e3b\\u7ba1\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b\\u3002", "type": "revelation", "importance": 0.95, "impact": "\\u91d1\\u7b3c\\u6f14\\u827a\\u4e0e\\u6728\\u5076\\u66ff\\u8eab\\u8ba1\\u5212\\u76f4\\u63a5\\u7ed1\\u5b9a\\uff0c\\u5546\\u4e1a\\u7ade\\u4e89\\u52a8\\u673a\\u4e0e\\u4f5c\\u6848\\u624b\\u6bb5\\u5b8c\\u6574\\u95ed\\u73af\\u3002", "keyword": "\\u7968\\u6b3e\\u5148\\u7531\\u4e00\\u5bb6\\u949f\\u8868\\u8d38\\u6613\\u884c\\u6c47\\u5165"}, {"content": "\\u83b1\\u5c14\\u6495\\u4e0b\\u7b2c\\u4e00\\u6392\\u5341\\u4e8c\\u53f7\\u7968\\u6839\\uff0c\\u7559\\u4e0b\\"\\u8ba9\\u6b7b\\u4eba\\u5750\\u8fdb\\u6765\\"\\u7684\\u5ba3\\u8a00\\uff0c\\u4ece\\u88ab\\u52a8\\u8c03\\u67e5\\u8005\\u8f6c\\u4e3a\\u4e3b\\u52a8\\u8bbe\\u5c40\\u8005\\u3002", "type": "transition", "importance": 0.8, "impact": "\\u4e3a\\u540e\\u7eed\\u6f14\\u51fa\\u4e2d\\u7684\\u6b63\\u9762\\u4ea4\\u950b\\u57cb\\u4e0b\\u5f3a\\u70c8\\u671f\\u5f85\\uff0c\\u4e3b\\u89d2\\u884c\\u52a8\\u6a21\\u5f0f\\u4ece\\"\\u8ffd\\u67e5\\"\\u5207\\u6362\\u4e3a\\"\\u5e03\\u7f6e\\u9677\\u9631\\"\\u3002", "keyword": "\\u6240\\u4ee5\\u6f14\\u51fa\\u90a3\\u5929\\uff0c\\u8ba9\\u6b7b\\u4eba\\u5750\\u8fdb\\u6765\\u3002"}]	4	[{"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": null, "state_before": "\\u56e0\\u53e3\\u4ee4\\u6cc4\\u9732\\u800c\\u8b66\\u89c9\\u758f\\u79bb\\uff0c\\u5185\\u5fc3\\u81ea\\u6211\\u6323\\u624e\\uff0c\\u5728\\u8d70\\u5eca\\u72ec\\u81ea\\u6525\\u94a5\\u5319\\u81f3\\u51fa\\u8840\\uff08\\u7b2c11\\u7ae0\\uff09", "state_after": "\\u786e\\u8ba4\\u7f3a\\u53e3\\u5728\\u5370\\u52a1\\u5382\\u800c\\u975e\\u4e50\\u961f\\u5185\\u90e8\\u540e\\uff0c\\u80a9\\u8180\\u677e\\u4e0b\\u53bb\\u4e00\\u70b9\\uff0c\\u4f46\\u624b\\u4e0a\\u7684\\u7eb1\\u5e03\\u4ecd\\u5728\\u6e17\\u8840\\uff0c\\u8bf4\\u660e\\u65e7\\u4f24\\u672a\\u6108\\u3001\\u5fc3\\u7406\\u8d1f\\u62c5\\u4ecd\\u7136\\u6c89\\u91cd", "psychological_change": "\\u4ece\\u6000\\u7591\\u8eab\\u8fb9\\u6bcf\\u4e2a\\u4e50\\u961f\\u6210\\u5458\\u7684\\u9635\\u75db\\u4e2d\\u9010\\u6e10\\u8d70\\u51fa\\u6765\\uff0c\\u8f6c\\u5411\\u5bf9\\u91d1\\u7b3c\\u516c\\u53f8\\u7684\\u654c\\u610f\\uff1b\\u5bf9\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u6127\\u759a\\u4e0e\\u4fdd\\u62a4\\u6b32\\u56de\\u5347\\uff0c\\u4f46\\u7ffb\\u904d\\u6240\\u6709\\u4eba\\u67dc\\u5b50\\u7684\\u884c\\u4e3a\\u5df2\\u7ecf\\u7559\\u4e0b\\u96be\\u4ee5\\u62b9\\u53bb\\u7684\\u75d5\\u8ff9", "key_event": "\\u53d1\\u73b0\\u4f5c\\u5e9f\\u7a3f\\u4e03\\u4e09\\u4e03\\u5728\\u5370\\u52a1\\u5382\\u73af\\u8282\\u4e22\\u5931\\uff0c\\u8bc1\\u660e\\u5185\\u9b3c\\u4e0d\\u5728\\u4e50\\u961f\\u5185\\u90e8", "relationship_changes": {"\\u54c8\\u91cc\\u7279": "\\u4ece\\u5404\\u81ea\\u6000\\u7591\\u8f6c\\u5411\\u5e76\\u80a9\\u8c03\\u67e5\\uff0c\\u76ee\\u6807\\u9010\\u6e10\\u4e00\\u81f4", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u4fe1\\u4efb\\u88c2\\u75d5\\u5f00\\u59cb\\u6108\\u5408\\u4f46\\u5c1a\\u672a\\u5b8c\\u5168\\u91cd\\u5efa"}, "career_changes": null, "organization_changes": []}, {"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u9501\\u5b9a\\u5185\\u9b3c\\u8303\\u56f4\\u5e76\\u6697\\u4e2d\\u6392\\u67e5\\u516d\\u4efd\\u6d41\\u7a0b\\u8868\\uff08\\u7b2c11\\u7ae0\\uff09", "state_after": "\\u9501\\u5b9a\\u91d1\\u7b3c\\u6f14\\u827a\\u4e3a\\u5e55\\u540e\\u52bf\\u529b\\uff0c\\u5b8c\\u6574\\u62fc\\u51fa\\u6728\\u5076\\u66ff\\u8eab\\u8ba1\\u5212\\u7684\\u5229\\u76ca\\u94fe\\u6761\\uff0c\\u5e76\\u5f00\\u59cb\\u4e3b\\u52a8\\u5e03\\u5c40\\u53cd\\u5236", "psychological_change": "\\u6ce8\\u610f\\u529b\\u4ece\\u4e50\\u961f\\u5185\\u90e8\\u6392\\u67e5\\u8f6c\\u5411\\u5916\\u90e8\\u5bf9\\u6297\\uff1b\\u5bf9\\u739b\\u8482\\u5c14\\u8fbe\\u6240\\u53d7\\u7684\\u8bad\\u7ec3\\u4ea7\\u751f\\u9690\\u5fcd\\u7684\\u6012\\u610f\\uff0c\\u4f46\\u538b\\u4e0b\\u60c5\\u7eea\\uff0c\\u51b7\\u9759\\u5730\\u628a\\u7968\\u6839\\u6536\\u5165\\u5185\\u888b\\uff0c\\u4ece\\u4fa6\\u63a2\\u8f6c\\u4e3a\\u8bbe\\u5c40\\u8005", "key_event": "\\u901a\\u8fc7\\u6863\\u6848\\u8bb0\\u5f55\\u3001\\u7eb8\\u89d2\\u7f3a\\u5931\\u3001\\u9c7c\\u80f6\\u6c61\\u8ff9\\u4e0e\\u4e09\\u5c42\\u62c5\\u4fdd\\u94fe\\uff0c\\u786e\\u8ba4\\u91d1\\u7b3c\\u6f14\\u827a\\u662f\\u6700\\u7ec8\\u5f97\\u5229\\u65b9", "relationship_changes": {"\\u54c8\\u91cc\\u7279": "\\u5408\\u4f5c\\u52a0\\u6df1\\uff0c\\u5979\\u63d0\\u4f9b\\u4e86\\u5173\\u952e\\u7684\\u5267\\u9662\\u6863\\u6848\\u4e0e\\u884c\\u4e1a\\u4fe1\\u606f", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u7ebf\\u7d22\\u76f8\\u4e92\\u5370\\u8bc1\\uff0c\\u8c03\\u67e5\\u9ed8\\u5951\\u589e\\u5f3a"}, "career_changes": null, "organization_changes": []}, {"character_name": "\\u54c8\\u91cc\\u7279", "survival_status": null, "state_before": "\\u7b2c11\\u7ae0\\u672a\\u91cd\\u70b9\\u767b\\u573a\\uff0c\\u4f46\\u5df2\\u6362\\u6389\\u6392\\u7ec3\\u5ba4\\u9501\\u3001\\u6536\\u8d70\\u6240\\u6709\\u540e\\u53f0\\u8bc1\\u4ef6\\uff0c\\u5bf9\\u4e50\\u961f\\u6210\\u5458\\u9ad8\\u5ea6\\u6212\\u5907", "state_after": "\\u786e\\u8ba4\\u5e9f\\u7a3f\\u5728\\u5370\\u52a1\\u5382\\u4e22\\u5931\\u540e\\u95ed\\u4e86\\u95ed\\u773c\\uff0c\\u7d27\\u7ef7\\u7684\\u59ff\\u6001\\u6709\\u6240\\u677e\\u52a8\\uff1b\\u5bf9\\u4e50\\u961f\\u7684\\u6000\\u7591\\u5e76\\u672a\\u5b8c\\u5168\\u653e\\u4e0b\\uff0c\\u4f46\\u5df2\\u63a5\\u53d7\\u5916\\u90e8\\u52bf\\u529b\\u4ecb\\u5165\\u7684\\u4e8b\\u5b9e", "psychological_change": "\\u4ece\\u7b2c\\u4e00\\u4e2a\\u6000\\u7591\\u81ea\\u5df1\\u961f\\u5458\\u7684\\u7ba1\\u7406\\u8005\\uff0c\\u5230\\u88ab\\u8feb\\u627f\\u8ba4\\u95ee\\u9898\\u51fa\\u5728\\u66f4\\u8fdc\\u7684\\u73af\\u8282\\uff1b\\u5979\\u4e3a\\"\\u4e0d\\u662f\\u6211\\u4eec\\"\\u800c\\u677e\\u4e86\\u4e00\\u53e3\\u6c14\\uff0c\\u5374\\u4e5f\\u610f\\u8bc6\\u5230\\u91d1\\u7b3c\\u516c\\u53f8\\u7684\\u76ee\\u6807\\u6b63\\u662f\\u628a\\u81ea\\u5df1\\u6574\\u4e2a\\u4e50\\u56e2\\u5403\\u6389", "key_event": "\\u534f\\u52a9\\u67e5\\u6863\\u3001\\u9a8c\\u8bc1\\u7eb8\\u89d2\\u7f16\\u53f7\\u3001\\u8ba4\\u51fa\\u8d6b\\u4f2f\\u7279\\u00b7\\u5170\\u767b\\u7684\\u540d\\u5b57", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4ece\\u95f4\\u63a5\\u5bf9\\u5cd9\\u8f6c\\u5411\\u5e76\\u80a9\\u5408\\u4f5c", "\\u4e50\\u961f\\u6210\\u5458": "\\u4fe1\\u4efb\\u5173\\u7cfb\\u6709\\u5f85\\u540e\\u7eed\\u91cd\\u5efa"}, "career_changes": null, "organization_changes": []}, {"character_name": "\\u7968\\u52a1\\u8001\\u5934", "survival_status": null, "state_before": "\\u5bf9\\u83b1\\u5c14\\u5145\\u6ee1\\u6212\\u5907\\uff0c\\u4e00\\u5ea6\\u628a\\u767b\\u8bb0\\u7c3f\\u5f80\\u56de\\u62d6", "state_after": "\\u88ab\\u949e\\u7968\\u6253\\u52a8\\u540e\\u914d\\u5408\\u63d0\\u4f9b\\u7eb8\\u89d2\\u548c\\u8d35\\u5bbe\\u540d\\u5355\\uff0c\\u542c\\u5230\\u5f02\\u5e38\\u7684\\u5341\\u4e00\\u58f0\\u949f\\u54cd\\u65f6\\u8138\\u8272\\u53d1\\u767d\\uff0c\\u4f3c\\u4e4e\\u5bf9\\u5267\\u9662\\u9690\\u79d8\\u4e4b\\u4e8b\\u6709\\u6240\\u77e5\\u6653", "psychological_change": "\\u5e02\\u4fa9\\u800c\\u8b66\\u89c9\\u7684\\u8001\\u4eba\\uff0c\\u5bf9\\u5267\\u9662\\u89c4\\u77e9\\u548c\\u5f02\\u5e38\\u73b0\\u8c61\\u90fd\\u6709\\u8d85\\u51fa\\u5e38\\u4eba\\u7684\\u654f\\u611f\\uff0c\\u4f46\\u552f\\u5229\\u662f\\u56fe", "key_event": "\\u63d0\\u4f9b\\u4f5c\\u5e9f\\u7eb8\\u89d2\\u7559\\u5e95\\u4e0e\\u8d35\\u5bbe\\u540d\\u5355\\uff0c\\u88ab\\u949f\\u58f0\\u60ca\\u5413", "relationship_changes": {}, "career_changes": null, "organization_changes": []}]	[{"location": "\\u949f\\u697c\\u5267\\u9662\\u4fa7\\u95e8\\u4e0e\\u821e\\u53f0", "atmosphere": "\\u7070\\u51b7\\u6c89\\u95f7\\uff0c\\u7535\\u6d41\\u6ecb\\u6ecb\\uff0c\\u5ea7\\u6905\\u6697\\u9677", "duration": "\\u7ea62\\u5206\\u949f"}, {"location": "\\u5267\\u9662\\u5730\\u4e0b\\u6863\\u6848\\u5ba4", "atmosphere": "\\u6f6e\\u95f7\\u9178\\u8150\\u3001\\u6355\\u9f20\\u5939\\u4e0e\\u6392\\u6c61\\u6c9f\\u7684\\u6c14\\u5473\\u3001\\u5149\\u7ebf\\u660f\\u6697", "duration": "\\u7ea615\\u5206\\u949f"}, {"location": "\\u9e26\\u7fbd\\u5370\\u52a1\\uff08\\u83b1\\u5c14\\u8bfb\\u53d6\\u56de\\u6267\\u65f6\\u7684\\u8bb0\\u5fc6\\u95ea\\u56de\\uff09", "atmosphere": "\\u6cb9\\u58a8\\u70ed\\u94c5\\u3001\\u673a\\u5668\\u8f70\\u9e23\\u3001\\u67dc\\u53f0\\u9ad8\\u5927\\u62e5\\u6324", "duration": "\\u7ea61\\u5206\\u949f"}, {"location": "\\u5267\\u9662\\u5730\\u4e0b\\u6863\\u6848\\u5ba4\\uff08\\u8d35\\u5bbe\\u540d\\u5355\\u67e5\\u8be2\\uff09", "atmosphere": "\\u7d27\\u5f20\\u538b\\u8feb\\u6e10\\u5f3a\\uff0c\\u8d1d\\u65af\\u4f4e\\u97f3\\u9707\\u5730\\u677f\\uff0c\\u949f\\u58f0\\u9aa4\\u54cd", "duration": "\\u7ea68\\u5206\\u949f"}]	varied	8.5	8.4	8.6	8.5	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.5/10\n  节奏把控: 8.4/10\n  吸引力: 8.6/10\n  连贯性: 8.5/10\n\n【剧情阶段】发展\n\n【钩子分析】共6个\n  • [悬念] 十二份作废样稿中有一张编号七三七的纸角缺失，销毁记录写着十一份，但实际上少了一张，载有口令的关键废稿... (强度:9)\n  • [悬念] 印务厂闪回中，一个戴薄皮手套、灰色袖口、胸前别着金色鸟笼珐琅徽章的神秘人偷偷抽走了废稿，此人身份未明... (强度:8)\n  • [悬念] 贵宾席第一排十二号的购买人奥斯汀·柯尔已死三年，票款经三层空壳公司转账，担保人为金笼演艺财务主管赫伯... (强度:9)\n\n【伏笔分析】埋下4个, 回收7个\n\n【冲突分析】\n  类型: 人与人, 人与己\n  强度: 8/10\n  进度: 35%\n\n【改进建议】\n  1. 【伏笔密度】金色鸟笼徽章在闪回中出现后未被角色在后续对话中提及，读者可能忽略其与"金笼演艺"名称的呼应；建议在后续章节让莱尔或塞西莉明确复述"金色鸟笼"这一细节，以强化读者的记忆锚点，避免线索被悬置过久。	["\\u3010\\u4f0f\\u7b14\\u5bc6\\u5ea6\\u3011\\u91d1\\u8272\\u9e1f\\u7b3c\\u5fbd\\u7ae0\\u5728\\u95ea\\u56de\\u4e2d\\u51fa\\u73b0\\u540e\\u672a\\u88ab\\u89d2\\u8272\\u5728\\u540e\\u7eed\\u5bf9\\u8bdd\\u4e2d\\u63d0\\u53ca\\uff0c\\u8bfb\\u8005\\u53ef\\u80fd\\u5ffd\\u7565\\u5176\\u4e0e\\"\\u91d1\\u7b3c\\u6f14\\u827a\\"\\u540d\\u79f0\\u7684\\u547c\\u5e94\\uff1b\\u5efa\\u8bae\\u5728\\u540e\\u7eed\\u7ae0\\u8282\\u8ba9\\u83b1\\u5c14\\u6216\\u585e\\u897f\\u8389\\u660e\\u786e\\u590d\\u8ff0\\"\\u91d1\\u8272\\u9e1f\\u7b3c\\"\\u8fd9\\u4e00\\u7ec6\\u8282\\uff0c\\u4ee5\\u5f3a\\u5316\\u8bfb\\u8005\\u7684\\u8bb0\\u5fc6\\u951a\\u70b9\\uff0c\\u907f\\u514d\\u7ebf\\u7d22\\u88ab\\u60ac\\u7f6e\\u8fc7\\u4e45\\u3002"]	\N	0.5	0.3	2026-08-07 11:07:58.519686
55cb1fb1-fb47-4402-b223-ba0c3be52909	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	发展	8	["\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	压抑的紧张	0.8	\N	[{"type": "\\u60ac\\u5ff5", "content": "\\u771f\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u56da\\u4e8e\\u6e2f\\u53e3\\u65e7\\u8d27\\u4ed3\\uff0c\\u83b1\\u5c14\\u786e\\u8ba4\\u5979\\u6d3b\\u7740\\u4e14\\u6709\\u610f\\u8bc6\\uff0c\\u4f46\\u6551\\u63f4\\u5c1a\\u672a\\u5c55\\u5f00\\u2014\\u2014\\u5979\\u80fd\\u5426\\u5728\\u66ff\\u8eab\\u5b8c\\u6210\\u4efb\\u52a1\\u524d\\u83b7\\u6551\\uff1f", "strength": 9, "position": "\\u5f00\\u5934", "keyword": "\\u90a3\\u771f\\u7684\\u739b\\u8482\\u5c14\\u8fbe\\u5728\\u54ea\\uff1f"}, {"type": "\\u60c5\\u611f", "content": "\\u585e\\u897f\\u8389\\u5fc5\\u987b\\u5bf9\\u7740\\u6728\\u5076\\u66ff\\u8eab\\u7ee7\\u7eed\\u5fae\\u7b11\\u3001\\u62c9\\u7434\\u3001\\u82e5\\u65e0\\u5176\\u4e8b\\u5730\\u6392\\u7ec3\\uff0c\\u8bfb\\u8005\\u7684\\u60c5\\u7eea\\u88ab\\u538b\\u5728\\u5979\\u514b\\u5236\\u7684\\u8868\\u6f14\\u4e4b\\u4e0b\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u8ddf\\u5b83\\u8bf4\\u8bdd\\uff0c\\u5bf9\\u5b83\\u7b11\\uff0c\\u8be5\\u62c9\\u7434\\u62c9\\u7434\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u7070\\u8863\\u7537\\u8bf4\\u51fa\\"\\u523b\\u8fdb\\u53bb\\u7684\\u4e1c\\u897f\\uff0c\\u80fd\\u5fd8\\u5417\\"\\u2014\\u2014\\u6728\\u5076\\u66ff\\u8eab\\u7684\\u80fd\\u529b\\u4e0e\\u9650\\u5236\\u673a\\u5236\\u88ab\\u9996\\u6b21\\u6311\\u660e\\uff0c\\u6697\\u793a\\u80cc\\u540e\\u6709\\u66f4\\u6df1\\u5c42\\u7684\\u624b\\u6bb5\\u4e0e\\u76ee\\u7684\\u3002", "strength": 8, "position": "\\u4e2d\\u6bb5", "keyword": "\\u523b\\u8fdb\\u53bb\\u7684\\u4e1c\\u897f\\uff0c\\u80fd\\u5fd8\\u5417\\u3002"}, {"type": "\\u51b2\\u7a81", "content": "\\u7070\\u8863\\u7537\\u63d0\\u5230\\"\\u660e\\u65e9\\u7684\\u8d70\\u4f4d\\u6539\\u4e86\\"\\uff0c\\u8bf4\\u660e\\u66ff\\u8eab\\u8fd8\\u6709\\u4e00\\u573a\\u9884\\u5b9a\\u884c\\u52a8\\uff0c\\u5982\\u679c\\u6551\\u63f4\\u4e0d\\u53ca\\u65f6\\uff0c\\u6728\\u5076\\u53ef\\u80fd\\u5b8c\\u6210\\u67d0\\u4ef6\\u4e0d\\u53ef\\u9006\\u7684\\u4e8b\\uff0c\\u5f62\\u6210\\u65f6\\u95f4\\u538b\\u529b\\u3002", "strength": 7, "position": "\\u4e2d\\u6bb5", "keyword": "\\u660e\\u65e9\\u7684\\u8d70\\u4f4d\\u6539\\u4e86\\u3002"}, {"type": "\\u60ac\\u5ff5", "content": "\\u83b1\\u5c14\\u5df2\\u7ecf\\u62a5\\u8b66\\uff0c\\u73c0\\u897f\\u74e6\\u5c14\\u627f\\u8bfa\\u5341\\u5206\\u949f\\u8d76\\u5230\\uff0c\\u4f46\\u7ae0\\u8282\\u6070\\u597d\\u7ed3\\u675f\\u4e8e\\u7b49\\u5f85\\u2014\\u2014\\u6551\\u63f4\\u80fd\\u5426\\u6210\\u529f\\u3001\\u662f\\u5426\\u4f1a\\u6253\\u8349\\u60ca\\u86c7\\uff0c\\u60ac\\u800c\\u672a\\u51b3\\u3002", "strength": 8, "position": "\\u7ed3\\u5c3e", "keyword": "\\u6211\\u60f3\\u62a5\\u4e2a\\u6848\\u3002\\u6e2f\\u53e3\\u897f\\u533a\\u6700\\u672b\\u4e00\\u95f4\\u65e7\\u8d27\\u4ed3"}]	5	\N	[{"title": "\\u64cd\\u5076\\u5e08\\u4e0e\\u6728\\u5076\\u66ff\\u8eab\\u52bf\\u529b", "content": "\\u672c\\u7ae0\\u76f4\\u63a5\\u5750\\u5b9e\\u66ff\\u8eab\\u662f\\u6728\\u5076\\uff1a\\u83b1\\u5c14\\u8bf4\\u51fa\\"\\u66ff\\u8eab\\u662f\\u4e2a\\u6728\\u5076\\uff0c\\u6728\\u5934\\u505a\\u7684\\uff0c\\u523b\\u6210\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u8138\\"\\uff0c\\u7070\\u8863\\u7537\\u53c8\\u8868\\u793a\\"\\u523b\\u8fdb\\u53bb\\u7684\\u4e1c\\u897f\\uff0c\\u80fd\\u5fd8\\u5417\\"\\uff0c\\u8bc1\\u5b9e\\u6728\\u5076\\u66ff\\u8eab\\u80cc\\u540e\\u5b58\\u5728\\u4e00\\u4e2a\\u64cd\\u7eb5\\u52bf\\u529b\\uff0c\\u4e14\\u8be5\\u52bf\\u529b\\u6b63\\u901a\\u8fc7\\u66ff\\u8eab\\u5b8c\\u6210\\u67d0\\u4e2a\\u5c1a\\u672a\\u63ed\\u6653\\u7684\\u76ee\\u6807\\u3002", "type": "resolved", "strength": 8, "subtlety": 6, "reference_chapter": 10, "reference_foreshadow_id": "881779eb-f111-4468-a584-5b04793c8759", "keyword": "\\u66ff\\u8eab\\u662f\\u4e2a\\u6728\\u5076\\uff0c\\u6728\\u5934\\u505a\\u7684\\uff0c\\u523b\\u6210\\u739b\\u8482\\u5c14\\u8fbe\\u7684\\u8138", "category": "mystery", "is_long_term": false, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 10}, {"title": "\\u6e2f\\u53e3\\u533a\\u65e7\\u8d27\\u4ed3\\u4e3a\\u72af\\u7f6a\\u636e\\u70b9", "content": "\\u83b1\\u5c14\\u8ddf\\u8e2a\\u66ff\\u8eab\\u81f3\\u6e2f\\u53e3\\u897f\\u533a\\u6700\\u672b\\u4e00\\u95f4\\u65e7\\u8d27\\u4ed3\\uff0c\\u786e\\u8ba4\\u5176\\u8fdb\\u5165\\u540e\\u672a\\u518d\\u79bb\\u5f00\\uff0c\\u968f\\u540e\\u7070\\u8863\\u7537\\u4e0e\\u53e6\\u4e00\\u540d\\u540c\\u4f19\\u4ece\\u4ed3\\u5e93\\u5185\\u8d70\\u51fa\\u5e76\\u8ba8\\u8bba\\u6b21\\u65e5\\u8ba1\\u5212\\uff0c\\u5750\\u5b9e\\u65e7\\u8d27\\u4ed3\\u5373\\u4e3a\\u8be5\\u52bf\\u529b\\u7684\\u5b9e\\u9645\\u636e\\u70b9\\u3002", "type": "resolved", "strength": 7, "subtlety": 5, "reference_chapter": 10, "reference_foreshadow_id": "af3c02b7-14fa-4420-b987-137806d9d7b4", "keyword": "\\u65e7\\u4ed3\\u5e93\\u6210\\u6392\\u5730\\u8e72\\u5728\\u7801\\u5934\\u65c1", "category": "event", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"], "estimated_resolve_chapter": 10}, {"title": "\\u7070\\u8863\\u7537\\u4eba\\u7684\\u75a4\\u2014\\u2014\\u5acc\\u7591\\u4eba\\u6807\\u8bb0", "content": "\\u83b1\\u5c14\\u900f\\u8fc7\\u95e8\\u7f1d\\u770b\\u6e05\\u7070\\u8863\\u7537\\u4eba\\u8f6c\\u8eab\\u65f6\\u5634\\u89d2\\u8fb9\\u6709\\u9053\\u75a4\\u659c\\u5230\\u4e0b\\u5df4\\uff0c\\u5f62\\u6210\\u53ef\\u8fa8\\u8ba4\\u7684\\u4f53\\u8c8c\\u7279\\u5f81\\uff0c\\u4e3a\\u540e\\u7eed\\u6307\\u8ba4\\u3001\\u8ffd\\u6355\\u4ee5\\u53ca\\u5728\\u4eba\\u7fa4\\u4e2d\\u8bc6\\u522b\\u8be5\\u5acc\\u7591\\u4eba\\u57cb\\u4e0b\\u7ebf\\u7d22\\u3002", "type": "planted", "strength": 6, "subtlety": 7, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u90a3\\u7070\\u8863\\u7537\\u4eba\\u8f6c\\u8eab\\u65f6\\uff0c\\u5634\\u89d2\\u8fb9\\u6709\\u9053\\u75a4\\u659c\\u5230\\u4e0b\\u5df4\\u3002", "category": "identity", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 12}, {"title": "\\u660e\\u65e9\\u7684\\u8d70\\u4f4d\\u2014\\u2014\\u66ff\\u8eab\\u7684\\u540e\\u7eed\\u8ba1\\u5212", "content": "\\u7070\\u8863\\u7537\\u8bf4\\"\\u660e\\u65e9\\u7684\\u8d70\\u4f4d\\u6539\\u4e86\\"\\uff0c\\u6697\\u793a\\u66ff\\u8eab\\u8fd8\\u6709\\u4e00\\u573a\\u9884\\u5b9a\\u6f14\\u51fa\\u6216\\u884c\\u52a8\\uff0c\\u4e0d\\u4ec5\\u8bbe\\u5b9a\\u4e86\\u7d27\\u8feb\\u7684\\u65f6\\u95f4\\u7a97\\u53e3\\uff0c\\u4e5f\\u4e3a\\u4e0b\\u4e00\\u7ae0\\u6551\\u63f4\\u884c\\u52a8\\u7684\\u8d70\\u5411\\u63d0\\u4f9b\\u9884\\u671f\\u3002", "type": "planted", "strength": 7, "subtlety": 5, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u660e\\u65e9\\u7684\\u8d70\\u4f4d\\u6539\\u4e86\\u3002", "category": "event", "is_long_term": false, "related_characters": ["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"], "estimated_resolve_chapter": 11}, {"title": "\\u6495\\u4e0b\\u7684\\u4ed3\\u5e93\\u8349\\u56fe\\u2014\\u2014\\u83b1\\u5c14\\u4fdd\\u7559\\u7684\\u7269\\u8bc1", "content": "\\u83b1\\u5c14\\u628a\\u672c\\u5b50\\u4e0a\\u753b\\u7684\\u4ed3\\u5e93\\u56fe\\u6495\\u4e0b\\u6298\\u6210\\u8584\\u65b9\\u5757\\u634f\\u5728\\u624b\\u91cc\\uff0c\\u6697\\u793a\\u8fd9\\u5f20\\u56fe\\u4f1a\\u5728\\u540e\\u7eed\\u6551\\u63f4\\u6216\\u4e0e\\u73c0\\u897f\\u74e6\\u5c14\\u4ea4\\u63a5\\u65f6\\u4f5c\\u4e3a\\u5173\\u952e\\u60c5\\u62a5/\\u8bc1\\u636e\\u4f7f\\u7528\\u3002", "type": "planted", "strength": 5, "subtlety": 8, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u628a\\u672c\\u5b50\\u4e0a\\u7684\\u90a3\\u9875\\u56fe\\u6495\\u4e0b\\u6765\\uff0c\\u6298\\u6210\\u4e00\\u4e2a\\u8584\\u65b9\\u5757", "category": "item", "is_long_term": false, "related_characters": ["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 12}, {"title": "\\u94dc\\u9523\\u5df7\\u5b58\\u6863\\u2014\\u2014\\u65e7\\u6848\\u52fe\\u8fde", "content": "\\u73c0\\u897f\\u74e6\\u5c14\\u63d0\\u5230\\"\\u521a\\u6574\\u7406\\u5b8c\\u94dc\\u9523\\u5df7\\u7684\\u5b58\\u6863\\"\\uff0c\\u94dc\\u9523\\u5df7\\u53ef\\u80fd\\u662f\\u4e00\\u5b97\\u65e7\\u6848\\u6216\\u4e0e\\u5f53\\u524d\\u7ed1\\u67b6\\u76f8\\u5173\\u7684\\u7ebf\\u7d22\\uff0c\\u4e3a\\u540e\\u7eed\\u6848\\u4ef6\\u4e32\\u8054\\u4e0e\\u89d2\\u8272\\u95f4\\u4fe1\\u606f\\u4ea4\\u6d41\\u57cb\\u4e0b\\u4f0f\\u7b14\\u3002", "type": "planted", "strength": 5, "subtlety": 7, "reference_chapter": null, "reference_foreshadow_id": null, "keyword": "\\u6211\\u521a\\u6574\\u7406\\u5b8c\\u94dc\\u9523\\u5df7\\u7684\\u5b58\\u6863\\u3002", "category": "mystery", "is_long_term": true, "related_characters": ["\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"], "estimated_resolve_chapter": 20}]	4	2	[{"content": "\\u585e\\u897f\\u8389\\u4e0e\\u83b1\\u5c14\\u5728\\u6392\\u7ec3\\u5ba4\\u5916\\u5bf9\\u8bdd\\uff0c\\u63ed\\u7a7f\\u6392\\u7ec3\\u5ba4\\u91cc\\u7684\\"\\u739b\\u8482\\u5c14\\u8fbe\\"\\u662f\\u6728\\u5076\\u66ff\\u8eab\\uff0c\\u771f\\u6b63\\u7684\\u739b\\u8482\\u5c14\\u8fbe\\u88ab\\u7ed1\\u5728\\u6e2f\\u53e3\\u533a\\u65e7\\u8d27\\u4ed3\\u3002", "type": "revelation", "importance": 0.85, "impact": "\\u8bfb\\u8005\\u4e0e\\u585e\\u897f\\u8389\\u540c\\u65f6\\u83b7\\u77e5\\u6838\\u5fc3\\u771f\\u76f8\\uff0c\\u5c06\\u60ac\\u5ff5\\u4ece\\"\\u5979\\u662f\\u4e0d\\u662f\\u672c\\u4eba\\"\\u8f6c\\u5411\\"\\u5982\\u4f55\\u6551\\u51fa\\u771f\\u739b\\u8482\\u5c14\\u8fbe\\"\\u3002", "keyword": "\\u5979\\u4e0d\\u662f\\u739b\\u8482\\u5c14\\u8fbe\\u3002"}, {"content": "\\u585e\\u897f\\u8389\\u63a5\\u53d7\\u83b1\\u5c14\\u7684\\u5b89\\u6392\\uff0c\\u5f3a\\u5fcd\\u60c5\\u7eea\\u56de\\u5230\\u6392\\u7ec3\\u5ba4\\u7167\\u5e38\\u4e0e\\u66ff\\u8eab\\u5408\\u7ec3\\uff0c\\u4e3a\\u8ddf\\u8e2a\\u4e89\\u53d6\\u65f6\\u95f4\\u3002", "type": "conflict", "importance": 0.7, "impact": "\\u5f3a\\u5316\\u4e86\\u585e\\u897f\\u8389\\u7684\\u5185\\u5fc3\\u6323\\u624e\\uff0c\\u4e5f\\u4e3a\\u540e\\u7eed\\u8425\\u6551\\u5931\\u8d25\\u7684\\u540e\\u679c\\u79ef\\u7d2f\\u60c5\\u611f\\u5f20\\u529b\\u3002", "keyword": "\\u8ddf\\u5b83\\u8bf4\\u8bdd\\uff0c\\u5bf9\\u5b83\\u7b11\\uff0c\\u8be5\\u62c9\\u7434\\u62c9\\u7434\\u3002"}, {"content": "\\u83b1\\u5c14\\u4e00\\u8def\\u8ddf\\u8e2a\\u66ff\\u8eab\\u7a7f\\u8fc7\\u8857\\u5df7\\u8fdb\\u5165\\u6e2f\\u53e3\\u533a\\uff0c\\u786e\\u8ba4\\u5b83\\u8d70\\u8fdb\\u6700\\u672b\\u4e00\\u95f4\\u65e7\\u8d27\\u4ed3\\u3002", "type": "transition", "importance": 0.9, "impact": "\\u5c06\\u72af\\u7f6a\\u636e\\u70b9\\u4ece\\u60c5\\u62a5\\u53d8\\u4e3a\\u5b9e\\u5730\\u786e\\u8ba4\\uff0c\\u63a8\\u52a8\\u60c5\\u8282\\u8fdb\\u5165\\u5177\\u4f53\\u884c\\u52a8\\u9636\\u6bb5\\u3002", "keyword": "\\u4ed6\\u4eec\\u5230\\u6e2f\\u53e3\\u533a\\u4e86\\u3002"}, {"content": "\\u83b1\\u5c14\\u7ed5\\u5230\\u4ed3\\u5e93\\u80cc\\u540e\\u4fa6\\u5bdf\\uff0c\\u5077\\u542c\\u5230\\u7070\\u8863\\u7537\\u4e0e\\u540c\\u4f19\\u8ba8\\u8bba\\"\\u660e\\u65e9\\u8d70\\u4f4d\\"\\u53ca\\"\\u523b\\u8fdb\\u53bb\\u7684\\u4e1c\\u897f\\"\\uff0c\\u786e\\u8ba4\\u6728\\u5076\\u66ff\\u8eab\\u7684\\u64cd\\u63a7\\u7279\\u6027\\u4e0e\\u540e\\u7eed\\u8ba1\\u5212\\u3002", "type": "revelation", "importance": 0.8, "impact": "\\u63ed\\u793a\\u4e86\\u64cd\\u5076\\u52bf\\u529b\\u7684\\u8fd0\\u4f5c\\u65b9\\u5f0f\\uff0c\\u5e76\\u5236\\u9020\\u4e86\\u65f6\\u95f4\\u7d27\\u8feb\\u611f\\u3002", "keyword": "\\u523b\\u8fdb\\u53bb\\u7684\\u4e1c\\u897f\\uff0c\\u80fd\\u5fd8\\u5417\\u3002"}, {"content": "\\u83b1\\u5c14\\u91c7\\u96c6\\u5230\\u8db3\\u591f\\u4fe1\\u606f\\u540e\\u6ca1\\u6709\\u72ec\\u81ea\\u51b2\\u5165\\u4ed3\\u5e93\\uff0c\\u800c\\u662f\\u7b2c\\u4e00\\u6b21\\u6b63\\u5f0f\\u5411\\u73c0\\u897f\\u74e6\\u5c14\\u62a5\\u6848\\uff0c\\u8bf7\\u6c42\\u5b98\\u65b9\\u652f\\u63f4\\u3002", "type": "resolution", "importance": 0.8, "impact": "\\u4e3b\\u89d2\\u4ece\\u72ec\\u884c\\u4fa6\\u5bdf\\u8005\\u8f6c\\u5411\\u4e0e\\u5f02\\u80fd\\u7ba1\\u7406\\u5c40\\u534f\\u4f5c\\uff0c\\u4e3a\\u4e0b\\u4e00\\u7ae0\\u7684\\u5927\\u89c4\\u6a21\\u6551\\u63f4\\u884c\\u52a8\\u94fa\\u8def\\u3002", "keyword": "\\u6211\\u60f3\\u62a5\\u4e2a\\u6848\\u3002\\u6e2f\\u53e3\\u897f\\u533a\\u6700\\u672b\\u4e00\\u95f4\\u65e7\\u8d27\\u4ed3"}]	5	[{"character_name": "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "survival_status": null, "state_before": "\\u51b7\\u9759\\u8c28\\u614e\\uff0c\\u5df2\\u638c\\u63e1\\u60c5\\u62a5\\u4f46\\u5c1a\\u672a\\u884c\\u52a8", "state_after": "\\u5b8c\\u6210\\u4fa6\\u5bdf\\uff0c\\u9009\\u62e9\\u501f\\u52a9\\u5b98\\u65b9\\u529b\\u91cf\\uff0c\\u8fdb\\u5165\\u5f85\\u547d\\u72b6\\u6001", "psychological_change": "\\u4ece\\u72ec\\u81ea\\u638c\\u63a7\\u60c5\\u62a5\\u8f6c\\u5411\\u4e3b\\u52a8\\u8054\\u7edc\\u73c0\\u897f\\u74e6\\u5c14\\uff0c\\u5c55\\u73b0\\u51fa\\u5bf9\\u5c40\\u52bf\\u7684\\u6e05\\u9192\\u5224\\u65ad\\u4e0e\\u884c\\u52a8\\u514b\\u5236\\uff0c\\u907f\\u514d\\u56e0\\u51b2\\u52a8\\u6253\\u8349\\u60ca\\u86c7\\u3002", "key_event": "\\u8ddf\\u8e2a\\u66ff\\u8eab\\u81f3\\u6e2f\\u53e3\\u65e7\\u8d27\\u4ed3\\uff0c\\u786e\\u8ba4\\u636e\\u70b9\\u4e0e\\u5acc\\u7591\\u4eba\\u540e\\u51b3\\u5b9a\\u62a5\\u6848\\u3002", "relationship_changes": {"\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1": "\\u4fe1\\u4efb\\u548c\\u5e76\\u80a9\\u611f\\u8fdb\\u4e00\\u6b65\\u589e\\u5f3a", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af": "\\u9ed8\\u5951\\u7684\\u6218\\u672f\\u5206\\u5de5\\u5173\\u7cfb\\u521d\\u6b65\\u6210\\u5f62"}}, {"character_name": "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "survival_status": null, "state_before": "\\u5fc3\\u5b58\\u7591\\u8651\\uff0c\\u6025\\u6b32\\u6c42\\u8bc1", "state_after": "\\u538b\\u6291\\u9707\\u60ca\\uff0c\\u575a\\u51b3\\u914d\\u5408\\u6f14\\u620f", "psychological_change": "\\u4ece\\u5f97\\u77e5\\u771f\\u76f8\\u7684\\u60c5\\u7eea\\u51b2\\u51fb\\u4e2d\\u8fc5\\u901f\\u6062\\u590d\\u51b7\\u9759\\uff0c\\u51b3\\u5b9a\\u5f53\\u7740\\u6728\\u5076\\u66ff\\u8eab\\u7ee7\\u7eed\\u6b63\\u5e38\\u6392\\u7ec3\\uff0c\\u5c55\\u73b0\\u51fa\\u6781\\u5f3a\\u7684\\u81ea\\u63a7\\u529b\\u3002", "key_event": "\\u63a5\\u53d7\\u83b1\\u5c14\\u6307\\u793a\\uff0c\\u4eca\\u665a\\u4e0d\\u8ba9\\u66ff\\u8eab\\u8d77\\u7591\\u3002", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u4fe1\\u4efb\\u548c\\u5e76\\u80a9\\u611f\\u8fdb\\u4e00\\u6b65\\u589e\\u5f3a", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797": "\\u6302\\u5ff5\\u5176\\u5b89\\u5371\\uff0c\\u62c5\\u5fe7\\u52a0\\u91cd"}}, {"character_name": "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "survival_status": null, "state_before": "\\u5728\\u5c40\\u5185\\u6574\\u7406\\u65e7\\u6848\\u5b58\\u6863\\uff0c\\u65e5\\u5e38\\u529e\\u516c\\u72b6\\u6001", "state_after": "\\u63a5\\u5230\\u62a5\\u6848\\u540e\\u8fdb\\u5165\\u884c\\u52a8\\u51c6\\u5907\\uff0c\\u627f\\u8bfa\\u5341\\u5206\\u949f\\u8d76\\u5230", "psychological_change": "\\u5bf9\\u83b1\\u5c14\\u51fa\\u73b0\\u5728\\u73b0\\u573a\\u7684\\u7f18\\u7531\\u4ecd\\u6709\\u7a0b\\u5e8f\\u6027\\u7591\\u8651\\uff0c\\u4f46\\u57fa\\u4e8e\\u65e2\\u6709\\u5408\\u4f5c\\u4fe1\\u4efb\\u9009\\u62e9\\u5148\\u884c\\u54cd\\u5e94\\u3002", "key_event": "\\u6536\\u5230\\u83b1\\u5c14\\u7684\\u62a5\\u6848\\u7535\\u8bdd\\uff0c\\u5f00\\u59cb\\u7ec4\\u7ec7\\u51fa\\u961f\\u3002", "relationship_changes": {"\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a": "\\u6218\\u672f\\u5408\\u4f5c\\u5173\\u7cfb\\u521d\\u6b65\\u5efa\\u7acb\\uff0c\\u6b63\\u5f0f\\u5408\\u4f5c\\u5373\\u5c06\\u5c55\\u5f00"}}, {"character_name": "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "survival_status": null, "state_before": "\\u88ab\\u56da\\u4e8e\\u65e7\\u8d27\\u4ed3\\uff08\\u672c\\u7ae0\\u672a\\u6b63\\u9762\\u51fa\\u573a\\uff09", "state_after": "\\u786e\\u8ba4\\u4ecd\\u6d3b\\u7740\\u4e14\\u6709\\u610f\\u8bc6", "psychological_change": "\\u867d\\u672a\\u6b63\\u9762\\u51fa\\u573a\\uff0c\\u4f46\\u901a\\u8fc7\\u83b1\\u5c14\\u8f6c\\u8ff0\\u53ef\\u77e5\\u5979\\u4fdd\\u6301\\u6e05\\u9192\\u3001\\u76ef\\u7740\\u95e8\\u53e3\\uff0c\\u6697\\u793a\\u5979\\u5bf9\\u83b7\\u6551\\u4ecd\\u6709\\u610f\\u5fd7\\u3002", "key_event": "\\u83b1\\u5c14\\u63cf\\u8ff0\\u5979\\"\\u773c\\u775b\\u7741\\u7740\\uff0c\\u5728\\u76ef\\u7740\\u95e8\\u53e3\\"\\u3002", "relationship_changes": {}}]	[{"location": "\\u6392\\u7ec3\\u5ba4\\u540e\\u95e8\\u7a84\\u5df7", "atmosphere": "\\u96fe\\u91cd\\u706f\\u660f\\uff0c\\u6e7f\\u51b7\\u538b\\u6291", "duration": "\\u7ea65\\u5206\\u949f"}, {"location": "\\u8857\\u9053\\u5bf9\\u9762\\u95e8\\u6d1e", "atmosphere": "\\u96fe\\u591c\\u65e0\\u58f0\\uff0c\\u4e50\\u58f0\\u95f7\\u54cd", "duration": "\\u7ea6\\u534a\\u5c0f\\u65f6\\uff08\\u6392\\u7ec3\\u81f3\\u5341\\u70b9\\uff09"}, {"location": "\\u6e2f\\u53e3\\u533a\\u8857\\u9053", "atmosphere": "\\u76d0\\u8165\\u96fe\\u91cd\\uff0c\\u8def\\u6ed1\\u5bc2\\u9759", "duration": "\\u6cbf\\u9014\\u7ea620\\u5206\\u949f"}, {"location": "\\u65e7\\u8d27\\u4ed3\\u5916\\u56f4\\uff08\\u6b63\\u95e8/\\u5317\\u5899/\\u7a97\\u53e3\\uff09", "atmosphere": "\\u9709\\u9508\\u6c14\\u606f\\uff0c\\u6697\\u4e2d\\u7aa5\\u89c6", "duration": "\\u7ea615\\u5206\\u949f"}, {"location": "\\u4ed3\\u5e93\\u524d\\u65b9\\u901a\\u4fe1\\u5904", "atmosphere": "\\u4f5c\\u6848\\u540e\\u7b49\\u5f85\\uff0c\\u96fe\\u4e2d\\u6c7d\\u7b1b", "duration": "\\u7ea62\\u5206\\u949f"}]	varied	8.3	8	8.4	8.6	=== 章节分析报告 ===\n\n【整体评分】\n  整体质量: 8.3/10\n  节奏把控: 8.0/10\n  吸引力: 8.4/10\n  连贯性: 8.6/10\n\n【剧情阶段】发展\n\n【钩子分析】共5个\n  • [悬念] 真玛蒂尔达被囚于港口旧货仓，莱尔确认她活着且有意识，但救援尚未展开——她能否在替身完成任务前获救？... (强度:9)\n  • [情感] 塞西莉必须对着木偶替身继续微笑、拉琴、若无其事地排练，读者的情绪被压在她克制的表演之下。... (强度:8)\n  • [悬念] 灰衣男说出"刻进去的东西，能忘吗"——木偶替身的能力与限制机制被首次挑明，暗示背后有更深层的手段与目... (强度:8)\n\n【伏笔分析】埋下4个, 回收2个\n\n【冲突分析】\n  类型: 人与人, 人与己\n  强度: 8/10\n  进度: 30%\n\n【改进建议】\n  1. 【描写建议】"雾"的意象在全章出现超过四次，虽成功营造压抑氛围，但跟踪段落可替换1-2处为气味（盐腥/蜡烛余烟）、声音（水滴/哨子）或触感（湿砖/铁锈）等细节，使环境层次更丰富。	["\\u3010\\u63cf\\u5199\\u5efa\\u8bae\\u3011\\"\\u96fe\\"\\u7684\\u610f\\u8c61\\u5728\\u5168\\u7ae0\\u51fa\\u73b0\\u8d85\\u8fc7\\u56db\\u6b21\\uff0c\\u867d\\u6210\\u529f\\u8425\\u9020\\u538b\\u6291\\u6c1b\\u56f4\\uff0c\\u4f46\\u8ddf\\u8e2a\\u6bb5\\u843d\\u53ef\\u66ff\\u63621-2\\u5904\\u4e3a\\u6c14\\u5473\\uff08\\u76d0\\u8165/\\u8721\\u70db\\u4f59\\u70df\\uff09\\u3001\\u58f0\\u97f3\\uff08\\u6c34\\u6ef4/\\u54e8\\u5b50\\uff09\\u6216\\u89e6\\u611f\\uff08\\u6e7f\\u7816/\\u94c1\\u9508\\uff09\\u7b49\\u7ec6\\u8282\\uff0c\\u4f7f\\u73af\\u5883\\u5c42\\u6b21\\u66f4\\u4e30\\u5bcc\\u3002"]	\N	0.35	0.45	2026-08-16 22:45:59.221478
\.


--
-- Data for Name: project_default_styles; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.project_default_styles (id, project_id, style_id, created_at, updated_at) FROM stdin;
5	d59e468a-8617-41e0-aabf-87a13be78834	7	2026-08-05 13:49:50.796216	2026-08-05 13:49:50.796216
7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	7	2026-08-06 14:45:14.477848	2026-08-06 14:45:14.477848
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.projects (id, user_id, title, description, theme, genre, target_words, current_words, status, wizard_status, wizard_step, outline_mode, world_time_period, world_location, world_atmosphere, world_rules, chapter_count, narrative_perspective, character_count, created_at, updated_at, cover_image_url, cover_prompt, cover_status, cover_error, cover_updated_at, world_climate, world_clothing) FROM stdin;
7f6d28c4-2a32-46d1-887c-6cf5c4555056	local_21232f297a57a5a7	瞒天过海	这是一个异能者的世界，但每个异能都必然会伴随着代价。\n十五年前孤儿院一夜覆灭，两个男孩侥幸活了下来。十五年后，他们追查那场灭门背后的真相，也发现了这个世界的秘密。	孤儿院灭门幸存者莱尔·西奥多和克劳·沃尔特，莱尔开上了侦探所，克劳·沃尔特加入了佣兵集团，两个人在不同的渠道打探消息，最终完成了复仇。\n复仇成功后却得知-他所在的世界其实是一本书所写的故事，在这本书上写下的内容都会最大程度复现，\n但代价会逐渐让书灵走向灭亡。\n书灵和莱尔等人做了交易，莱尔要用他的智慧、伙伴的团结协作，为这个被写定的世界夺回自由。	奇幻、悬疑	1000000	40087	writing	completed	4	one-to-many	2030年代的近未来都市，表面是高度发达的赛博朋克式社会，但底层逻辑仍被旧时代的阴影笼罩。异能者在十五年前的大觉醒事件后被迫浮出水面，社会对异能者既依赖又恐惧。核心矛盾在于"被安排的命运"与"失控的现实"之间的拉扯。十五年前孤儿院的灭门案正是大觉醒初期秩序崩塌的缩影。如今，社会表面平静，实则暗流涌动，异能者分为受管制的"在册者"和游走法律边缘的"暗探"。人们普遍焦虑于异能的不可控代价，以及生活中偶尔出现的"既视感"，仿佛有一只无形的大手在拨弄命运的琴弦，让人在追寻真相时感到刺骨的寒意。	故事主要发生在常年阴雨的海港都市"雾隐市"。整座城市依山而建，分上中下三层。上层是霓虹闪烁的商业区与权力中枢，中层是拥挤的平民窟与黑市，下层则是废弃的排水系统与旧时代遗址。莱尔的事务所位于中层一栋破旧公寓的顶楼，透过落地窗能看见上层投射下的虚假繁华；克劳的佣兵据点则隐藏在下层的地下拳场。十五年前覆灭的孤儿院位于中层边缘的悬崖旁，如今只剩断壁残垣，被城市刻意遗忘。潮湿的海风与工业废气混合，形成终年不散的迷雾，掩盖了无数秘密与血迹。	空气里永远弥漫着海腥味与潮湿的霉雨气息，雨滴敲打霓虹灯牌的声音是城市永不停歇的背景乐。视觉上，冷色调的霓虹蓝与暗红交织，映照在湿漉漉的柏油路上，拉出扭曲变形的倒影。悬疑与压抑是这里的主调，每个人脸上都带着防备与疏离，因为谁也不知道身边的陌生人下一秒是否会因异能代价而暴走。孤儿院旧址附近更是连风声都带着呜咽，仿佛亡魂在低语。这种宿命般的沉重感笼罩着莱尔和克劳，无论他们走到哪里，都像有一双无形的眼睛在审视着他们，随时准备将偏离轨道的一切抹除。	世界运行的核心法则是"等价交换"与"原典书写"。每个异能者在觉醒时都会获得超凡力量，但必然伴随不可逆的代价，如折寿、丧失感官或记忆。更隐秘的规则是，这个世界其实是一本名为《原典》的书籍，书灵是世界的维护者。在《原典》上书写的内容会最大程度在现实中复现，但每次书写都会消耗书灵的生命力。社会结构由"书灵教廷"暗中把控，他们以"命运不可违逆"为教义，抹杀试图窥探真相的人。异能者分为受教廷招安的"执笔者"和反抗命运的"越界者"。禁忌是试图寻找《原典》的所在，违者会被"剧情修正"，如同从未存在过一般被抹去。	0	第三人称	5	2026-08-05 22:55:42.973864	2026-09-19 21:57:48.23694	\N	\N	none	\N	\N	雾隐市属于温带海洋性气候，常年多雨少晴，空气湿度极高。四季界限模糊，只有雨季与微凉季的区别。连绵的阴雨不仅让城市建筑布满水渍，也为异能者的隐秘行动提供了天然掩护。特殊的气候现象是每隔数月降临一次的"墨雨"。墨雨呈淡黑色，带有微弱的腐蚀性，淋在身上会留下难以洗去的灰痕。普通人只当是工业污染，但知情者明白，那是书灵生命力流失、世界壁垒变薄的征兆。墨雨期间，异能的代价会莫名加重，现实与虚幻的边界也变得模糊，偶尔会有不属于这个时代的幻影闪现。	为了适应多雨潮湿的环境，居民普遍穿着深色、防水的合成纤维面料。莱尔作为侦探，常穿着修身的黑色长风衣，内搭高领羊绒衫，双手总是戴着薄皮革手套，既是为了防水，也是为了遮掩因异能代价而布满烧伤疤痕的双手。克劳作为佣兵，则偏爱机能战术风，多口袋的战术背心、耐磨的工装裤与军靴，肩甲和护肘上镶嵌着防弹陶瓷片，随时准备战斗。上流社会的权贵则穿着剪裁考究的丝绸与呢绒大衣，佩戴着能抑制异能波动的金属胸针。而底层贫民往往披着破旧的塑料雨衣，在城市的阴影中瑟瑟发抖。
d59e468a-8617-41e0-aabf-87a13be78834	local_21232f297a57a5a7	我没有外挂	张宇穿越而来，没有系统没有金手指，只有一身还算不错的修炼天赋。十六岁报考宗门，才知人人皆有天赋伴身，唯独他是个例外。为了不被当成异端，他只能伪装天赋是勤学苦练。在不断的提高修为的同时，逐渐调查出这个世界的真相。	这是一本偏向系统流/外挂流的修仙小说，但是系统/外挂的拥有者并非主角。主角只是天资十分优秀，能跟得上/超越他人的速度成长，以至于不被他人发现他并没有天赋。随着修为的提升、自身影响力的发展、人脉的扩张、一些机缘巧合，主角发现了这个世界天赋的真相：实际上所谓人人都有的天赋是外界势力入侵一个世界所用到的手段，他们用了一个宝物，可以将世界的本源之力分摊到所处世界的原住民身手，以此降低世界的抵抗能力，从而便于外界分散击破，从而回收世界本源之力，低损耗完成入侵。主角在发现这个真相后，暗中结盟，团结势力，发起反侵略，最后胜利的故事。	修仙、系统流	1200000	0	writing	completed	4	one-to-many	天元界第三十七纪，史称"灵潮纪元"。三百年前，天地异变，灵气暴涨，万物生灵皆在十六岁时觉醒伴生"灵根天赋"，修仙界迎来前所未有的繁荣。然而，这看似黄金时代的背后，是极度内卷与天赋决定一切的残酷法则。十六岁的宗门大选是凡人唯一的进身之阶，天赋品级直接划定人生阶级，一品者平步青云，九品者永为泥泞。社会表面仙风道骨、井然有序，实则暗流涌动，灵气虽浓却日益驳杂，高阶修士的瓶颈愈发坚固，世人皆以为是天地压制，却不知是世界本源正被悄然蚕食。底层修士为了有限的资源拼死争斗，而上层则沉迷于天赋带来的特权，整个社会弥漫着一种狂热的焦虑。在这个时代，没有天赋就是原罪，而拥有极品天赋则是天命所归，这种深入骨髓的阶级固化让无数人在十六岁那年便看到了人生的终点。	故事主要发生在九州大陆的天璇宗及其辖地。九州大陆地貌广袤，宗门割据，灵脉交错。天璇宗坐落于九脉交汇的"登仙山"上，山巅常年云雾缭绕，灵气化液，是无数凡人梦寐以求的圣地。标志性场景为山脚的"试灵台"，每年数以万计的十六岁少年在此等待命运的裁决，灵光闪烁间决定一生的荣辱；山腰的"外门坊市"，充斥着底层修士的挣扎与市侩；山顶的"星辰大殿"，则是高阶长老们掌控权力的中心。凡人国度散布在灵脉边缘，向宗门供奉物资以换取庇护，形成了一种畸形的寄生与供养关系。整个地理格局呈现出严格的等级分布，越靠近灵脉中心，灵气越浓郁，居住者的地位也越高，而边缘地带则是灵气荒漠，生存环境恶劣。看似生机勃勃的灵山福地，实则像被寄生的宿主，灵气循环逐渐走向枯竭，灵脉深处偶尔传出的微弱悲鸣，只有极少数人能察觉。	这是一个表面仙气飘飘、内里压抑焦虑的世界。视觉上，灵光溢彩，法器横空，修士衣袂飘飘，宛如画卷；听觉上，宗门钟鸣悠扬，却夹杂着落选者的啜泣与底层修士的叹息；嗅觉上，灵草丹香弥漫，掩盖着一丝若有若无的腐朽气息。美学风格呈现出强烈的割裂感：上层是极致华美、高高在上的神性光辉，下层则是为了一块灵石打破头的兽性疯狂。十六岁测灵时，众生狂喜与绝望的对比将这种狂热与压抑推向极致，主角张宇身处其中，表面镇定，内心却如履薄冰，时刻警惕着暴露无天赋的真相。空气中弥漫着一种病态的崇拜，对天赋的狂热信仰让众生甘愿沦为棋子而不自知。夜晚的宗门，灵灯璀璨如星，却照不进外门弟子阴暗潮湿的角落，这种明暗交织的视觉冲击，正是这个世界最真实的写照。	世界运行的核心法则是"天赋修仙"。修炼体系为凝气至渡劫，看似常规，实则修为越高，与伴生灵根（实为外界势力投放的"分灵器"碎片）的联系越深，被抽取的本源之力越多。社会结构呈金字塔型，以天赋定尊卑，一品天赋者生来就是内门核心，九品只能做杂役凡人。资源被宗门绝对垄断，凡人如草芥。最大的禁忌是"无天赋者"，被视为天弃之人，甚至会被炼化为药人。外界势力"噬界者"利用"分灵碑"将世界本源转化为伪灵根赋予原住民，原住民修炼实则是帮噬界者提炼本源，待世界抵抗消失，便会降临收割。质疑天赋来源更是灭顶之宗，历史上曾有大能试图探查真相，却都离奇陨落，宗门对此讳莫如深。在这个规则下，勤奋毫无意义，天赋代表一切，这种绝对的宿命论像一座大山压在所有人头上，唯有主角张宇在暗中打破了这一铁律。	0	第三人称	5	2026-08-05 13:39:02.116109	2026-09-20 14:03:48.675684	\N	\N	none	\N	\N	受灵气潮汐影响的亚热带季风气候，四季分明但气候异常。春季灵潮涌动，万物疯长，是觉醒天赋的最佳时节；夏季灵气狂暴，常有雷暴，修士易走火入魔；秋季灵气内敛，天高气爽，是宗门大比之时；冬季灵气死寂，万物蛰伏。特殊的气候现象是每隔数十年出现的"源枯之雾"，灵气急剧衰退，灵植枯死，官方解释为天地轮回，实则是噬界者大规模抽取世界本源所致。看似滋养万物的灵雨，实则加速了本源的外泄，每一次降雨都像是在给世界的伤口撒盐。极端天气如"灵气风暴"时常席卷边缘地带，将散修好不容易聚集的灵气吹散，进一步加剧了资源的不平等。修士们习惯了依赖灵气生存，却对灵气的日渐稀薄与驳杂视而不见，仿佛温水煮青蛙般走向灭亡。	服饰以灵丝、妖兽皮为主，款式为宽袍大袖的传统汉服，便于施展法术和容纳法器。阶层差异极其明显：外门弟子穿灰布短打，行动方便但无防御力；内门弟子穿锦缎长袍，绣有聚灵阵纹；真传与长老则穿灵器法袍，光华流转，能随修为变色。服饰纹样代表宗门与天赋等级，天璇宗以星辰为徽，一品天赋绣金线，九品无纹。主角张宇常年穿着最普通的青色外门服饰，低调朴素，内里却缝制了自己摸索出的简陋导灵纹路，这是他"伪天赋"的具象化体现，也是他在夹缝中求生的智慧。凡人多穿粗布衣衫，在修士面前卑微如尘。在某些特殊场合，如宗门大比或祭祀，高阶修士会穿上绣有复杂符文的特制礼服，这些服饰本身就是强大的法器，能够引动天地灵气，进一步彰显其尊贵地位。
\.


--
-- Data for Name: prompt_submissions; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.prompt_submissions (id, submitter_id, submitter_name, source_instance, name, description, prompt_content, category, tags, author_display_name, is_anonymous, status, reviewer_id, review_note, reviewed_at, workshop_item_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: prompt_templates; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.prompt_templates (id, user_id, template_key, template_name, template_content, description, category, parameters, is_active, is_system_default, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: prompt_workshop_items; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.prompt_workshop_items (id, name, description, prompt_content, category, tags, author_id, author_name, source_instance, is_official, download_count, like_count, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: prompt_workshop_likes; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.prompt_workshop_likes (id, user_identifier, workshop_item_id, created_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.refresh_tokens (id, user_id, token_hash, device_info, ip_network, created_at, expires_at, last_used_at, is_revoked, replaced_by) FROM stdin;
78d99075-5ed9-444b-90e9-fc23a40b9302	local_21232f297a57a5a7	058052e23ebcfc390f4a5d6623c2ccf7f27f65a302838d35dd0a734c18446631	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-20 10:41:40.858571+08	2026-10-20 10:41:40.858571+08	2026-09-20 23:44:23.621761+08	t	a860dcb2-3afc-4378-a9ca-5d96423dd61f
a860dcb2-3afc-4378-a9ca-5d96423dd61f	local_21232f297a57a5a7	6dd7b7962aa12b33ee817c1cc211bf3f16507a2ce266b8d6bae86e2c0a8ee850	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-20 23:44:23.621761+08	2026-10-20 23:44:23.621761+08	2026-09-21 01:49:16.725518+08	t	fc2127c8-b15f-4937-b1b7-84ed5985b60d
fc2127c8-b15f-4937-b1b7-84ed5985b60d	local_21232f297a57a5a7	d0963f70178ad6703f76c5a7313cdba7c4bfabbbbf658369cfaba8be4ad85b56	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 01:49:16.725518+08	2026-10-21 01:49:16.725518+08	2026-09-21 03:52:59.206074+08	t	d95a7e17-1cdd-4dab-83bb-f5e17800ccf3
d95a7e17-1cdd-4dab-83bb-f5e17800ccf3	local_21232f297a57a5a7	f78899694155aaa44a7b3fd2cd1b755800927bd5f29b1ef40ed0a9ff64dfc710	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 03:52:59.206074+08	2026-10-21 03:52:59.206074+08	2026-09-21 06:04:56.614018+08	t	16e29e21-7ce7-41a4-a8ad-14122fe873a4
16e29e21-7ce7-41a4-a8ad-14122fe873a4	local_21232f297a57a5a7	1975e881cf87af3e17b87a8437758bd9eeea92085f17669c973b2e3e43ba85aa	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 06:04:56.614018+08	2026-10-21 06:04:56.614018+08	2026-09-21 08:27:15.857224+08	t	ef0426bc-efcc-4213-8e3c-13c197d10fab
ef0426bc-efcc-4213-8e3c-13c197d10fab	local_21232f297a57a5a7	840bf9b5b656ab4d55538fc39ee6a5050d4eb6d9198610ef467eac77f3b47af6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 08:27:15.857224+08	2026-10-21 08:27:15.857224+08	2026-09-21 11:00:04.118789+08	t	cf6a5503-f73f-40fa-9465-43526c311bde
cf6a5503-f73f-40fa-9465-43526c311bde	local_21232f297a57a5a7	868c9140a09b7fb80b0b656e098b45a1ad87af388ff89c8443316049f681b9f6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 11:00:04.118789+08	2026-10-21 11:00:04.118789+08	2026-09-21 13:31:16.313449+08	t	5a53bab4-8d7e-425e-99a1-3ddb9f4db549
5a53bab4-8d7e-425e-99a1-3ddb9f4db549	local_21232f297a57a5a7	38360a618917bb6b0ef08db6519f56172db519295c984388098cb21daa6dd3d1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 13:31:16.313449+08	2026-10-21 13:31:16.313449+08	2026-09-21 16:02:53.688878+08	t	462d5a0e-877f-434a-b9ca-152b0842e10d
0bb8c441-d7db-4618-954a-42a9cde9b5e9	local_21232f297a57a5a7	aa9d6e1a243294a952dfc41d88c4d8717e4f88fa7055ed2ecbec83d3b1c14c7b	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 19:44:30.075604+08	2026-10-21 19:44:30.075604+08	\N	f	\N
462d5a0e-877f-434a-b9ca-152b0842e10d	local_21232f297a57a5a7	0f1855d954e56089932ddb4485c97b677aa358f48f35421f44c57ec083306e9f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	127.0.0.0/24	2026-09-21 16:02:53.688878+08	2026-10-21 16:02:53.688878+08	2026-09-21 19:44:30.075604+08	t	0bb8c441-d7db-4618-954a-42a9cde9b5e9
\.


--
-- Data for Name: regeneration_tasks; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.regeneration_tasks (id, chapter_id, analysis_id, user_id, project_id, modification_instructions, original_suggestions, selected_suggestion_indices, custom_instructions, style_id, target_word_count, focus_areas, preserve_elements, status, progress, error_message, original_content, original_word_count, regenerated_content, regenerated_word_count, version_number, version_note, created_at, started_at, completed_at) FROM stdin;
0ddf9343-1c62-4ba5-ace1-bd5a22273ab5	9ad1ee72-1357-48e5-a162-cf2d304c65d5	\N	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		null	[]	1 问询主要是问询基本信息以及顺便汇报搜查工作进度，不是把孩子们当犯人审查。\n2 治安官不要描写的那么无能，也是在尽力在搜查\n3 不需要在此章描述克劳、莱尔的能力 ，可以描写他们对孤儿院的同伴、玛丽修女的思念	\N	3000	[]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	completed	0	\N	雾压在城西，屋脊只剩一排发黑的轮廓。\n\n送煤车慢吞吞碾过街口，车轮咬着石缝，吱呀，吱呀。治安管理所门前积了半洼脏水，夜里冻出一层薄冰。两个巡警缩在屋檐下换岗，跺着脚，白气刚出口就散进雾里。\n\n一墙之隔，临时休息室冷得像地窖。\n\n屋里塞着两张行军床。一张缺了条腿，底下垫着几本旧卷宗，每次有人翻身，床架就嘎吱乱叫。窗户钉死了，玻璃上全是水汽。昨晚送来的咖啡摆在桌角，黑沫凝成油腻的一圈。\n\n莱尔一夜没睡。\n\n克劳也没睡。\n\n他坐在床边，背抵着墙，右手始终插在夹克口袋里。那枚缝衣针就在里面。隔着一层布，针尖顶着他的指腹。\n\n走廊传来钥匙碰撞声。\n\n门打开，昨天带队赶去孤儿院的瘦高巡警探进头。\n\n“莱尔·西奥多，出来。”\n\n莱尔看向桌角。\n\n“早餐呢？”\n\n巡警扫了他一眼。\n\n“问完再吃。”\n\n“昨天也是这句。”\n\n没人接话。\n\n莱尔起身，抻平衬衣下摆。走到门口时，他停了一下。\n\n“他昨晚没吃东西。”\n\n巡警看向克劳。\n\n“等食堂开火。”\n\n“再送一杯热水。”\n\n“这里不是旅店。”\n\n“旅店的床一般有四条腿。”\n\n巡警的脸沉下来，莱尔已经迈进走廊。\n\n问讯室比休息室暖些，却有股湿羊毛、烟灰和墨水混在一起的味道。桌后坐着两个人，一个负责问，一个负责记。\n\n问题和昨晚差不多。\n\n几点离开孤儿院，去了哪些店，在路上见过谁，为什么回来得比预计晚。莱尔从面粉铺说到药房，又说到卖煤油的杂货店。价钱、找零、店员的长相，全能对上。\n\n“你发现现场后，为什么认为有三名袭击者？”\n\n莱尔把目光移到记录员的笔尖。\n\n“鞋印。”\n\n“什么鞋印？”\n\n“两双钉铁掌的长靴，一双窄底靴。窄底靴的右后跟磨损严重，走路时会往外偏。”\n\n记录员停了笔。\n\n问话的巡警盯着莱尔。\n\n“你做什么工作的？”\n\n“替孤儿院跑腿，偶尔替人找东西。”\n\n“找东西？”\n\n“丢掉的钥匙，欠钱不还的邻居，还有藏在洗衣筐里的孩子。”\n\n巡警没有笑。\n\n“普通人看不到这么多。”\n\n莱尔靠回椅背。\n\n“普通人也不会在十三具尸体旁边站那么久。”\n\n屋里只剩笔尖刮纸的声音。\n\n这是真话。\n\n说得还不完整，但足够用。\n\n欺骗的力量伏在舌根下。莱尔一次也没碰它。这里的问题没完没了，谁都可能成为下一个询问者。一旦用错地方，后面有人问起他的能力，他连闭嘴都未必来得及。\n\n“你认识凶手吗？”\n\n“不认识。”\n\n“最近有没有陌生人去过孤儿院？”\n\n莱尔停了半拍。\n\n“三个穿灰衣的人。他们自称异常管理局调查员。”\n\n记录员抬起头。\n\n“有证件吗？”\n\n“出示过，没让我们细看。”\n\n“他们问了什么？”\n\n“院里有没有人能做到普通人做不到的事。”\n\n“你怎么回答的？”\n\n“我当时不在。”\n\n巡警往前倾了倾。\n\n“克劳·沃尔特在？”\n\n“在。”\n\n“他怎么回答？”\n\n“这个问题该问他。”\n\n巡警盯了他几秒，合上文件。\n\n“带回去。”\n\n门外放着一只搪瓷杯，里面装了热水。\n\n瘦高巡警没说是谁送的。\n\n莱尔端回休息室。克劳还保持原来的姿势，只是口袋里的手攥得更紧。\n\n“问灰衣人了？”他问。\n\n“嗯。”\n\n“我去。”\n\n“先喝水。”\n\n克劳没动。\n\n莱尔把杯子塞进他空着的那只手。杯壁很烫，克劳握了两秒才松开手指。\n\n“他们会查到我。”\n\n“他们什么都没查到。”\n\n“早晚会。”\n\n“那就晚点再说。”\n\n克劳看着杯里的热气。\n\n走廊另一头传来孩子的哭声，大概是哪家丢了东西，被父母带来报案。声音隔着门钻进来，很细。\n\n克劳手里的水洒了一半。\n\n莱尔扯过桌上的旧报纸盖住水迹，挡住了门上的观察孔。\n\n“不是他们。”\n\n哭声很快被人哄住。\n\n克劳低头喝了一口水。水太烫，他没吐出来。\n\n第一天，他们分别被问了四次。\n\n第二天清早，巡警收走了两人的外套和靴子，检查血迹、泥渍和鞋底。克劳站在冷地板上，只穿着衬衣，手臂绷得发硬。\n\n一个年轻巡员抓起他的夹克。\n\n“口袋清空。”\n\n克劳没有动作。\n\n巡员伸手去摸。\n\n莱尔横跨半步，挡在中间。\n\n“里面是死者遗物。”\n\n“什么东西？”\n\n“一枚针。”\n\n“拿出来。”\n\n克劳眼皮压低。\n\n莱尔先看了他一眼，才伸出手。\n\n“给我。”\n\n沉默拖了几秒。\n\n克劳把针取出来，放在莱尔掌心。针上还缠着半截褐色棉线。\n\n年轻巡员用纸包好，写了编号。\n\n“调查完归还。”\n\n“弄丢了怎么办？”莱尔问。\n\n“不会丢。”\n\n“昨天你们还丢了一份口供。”\n\n巡员脸一僵。\n\n莱尔在第一次问讯时就记住了卷宗编号。昨晚走廊有人挨骂，说三号室的记录少了两页。今天桌后的问讯员换了，问的问题却从头开始。\n\n这些人忙，却没忙到点上。\n\n他们查过莱尔和克劳的购物路线，查过孤儿院的账簿，也问了附近几条街的住户。没人记住那辆马车。城门的守卫只说当天出城的车很多，煤车、菜车、运尸车，哪辆都沾着泥。\n\n至于脚印，负责拓印的巡警赶到时，菜地已经被十几双靴子踩烂了。\n\n第二天下午，灰胡子治安官亲自问克劳。\n\n莱尔被留在门外，只能听见断断续续的声音。\n\n“你曾是佣兵？”\n\n“是。”\n\n“属于哪一家？”\n\n“灰烬之爪。”\n\n“回城做什么？”\n\n“看家人。”\n\n椅子腿擦过地面。\n\n“你随身带刀，懂得杀人，又恰好在案发时不在孤儿院。”\n\n里面静了几秒。\n\n莱尔抬手敲门。\n\n问讯室的门被拉开，瘦高巡警皱着眉。\n\n“做什么？”\n\n“我要见治安官。”\n\n“等着。”\n\n“克劳不擅长解释。他要是决定用行动证明自己无辜，你们这扇门撑不了多久。”\n\n屋里的克劳偏过头。\n\n灰胡子治安官看看他，又看看门锁，抬手让人放莱尔进去。\n\n后面的问话改成两人一起。\n\n莱尔回答时间和路线，克劳补充店铺的位置。涉及现场判断，莱尔把每一条都落到脚印、车辙和被翻过的房间上。涉及灰衣访客，他只重复听来的内容，不替克劳作答。\n\n那把藏在每句话里的刀，始终没出鞘。\n\n第三天上午，没人来问话。\n\n早餐多了一块硬面包。咖啡还是馊的，豆子磨得太粗，杯底全是渣。\n\n莱尔掰下一角，嚼了很久。\n\n“好消息。”\n\n克劳靠在床边看他。\n\n“他们不是故意虐待我们。这里的咖啡一直这么难喝。”\n\n克劳没接话，眼里的血丝倒是少了些。\n\n中午，走廊突然安静下来。\n\n先是脚步声。皮鞋，不是巡警常穿的硬底靴。两个人，步子不快。经过门外时，其中一人停了一下。\n\n克劳坐直身体。\n\n莱尔放下面包。\n\n片刻后，钥匙插进锁孔。\n\n瘦高巡警推开门。这次他没拿问讯记录，外套扣得整整齐齐。\n\n“你们两个，跟我去二楼。”\n\n“又问什么？”\n\n“不是我们问。”\n\n莱尔看向走廊尽头。楼梯口多了两名陌生人，灰色长衣，袖口压着银线。衣服很干净，鞋边却沾着城西特有的白泥。\n\n其中一人手里提着黑色公文箱。\n\n瘦高巡警侧开身。\n\n“异常管理局的人找你们。”\n\n克劳把右手插回夹克口袋。\n\n里面只剩一截断线。\n\n莱尔理了理衣领，先一步走上楼梯。\n\n二楼会议室的门开着。\n\n他闻到了新煮的咖啡味。	2830	雾从格雷文赫港一路漫进城西。\n\n蒸汽吊臂在远处起落，铁链碰撞，铛、铛，声音隔着灰白天幕传来，像有人在雾里敲钟。煤烟压过哥特式尖顶，煤气灯尚未熄灭，街角的异常粒子检测仪亮着一颗疲惫的绿灯。\n\n镜头再往下。\n\n治安管理所门前积着一洼雨水。送煤车碾过石板，污水溅上台阶。两个巡警刚换完岗，湿斗篷冒着汗馊味，靴底带进来的白泥一路拖到走廊深处。\n\n临时休息室里，莱尔睁着眼。\n\n他一夜没睡。\n\n屋里塞着两张行军床。一张缺腿，底下垫了三本旧卷宗。每逢克劳翻身，铁架便嘎吱一声。窗户钉死了，玻璃上全是水汽，墙角还有股陈年霉味。\n\n桌上摆着两杯昨夜送来的咖啡。\n\n黑沫凝成一圈油光。\n\n莱尔看了一会儿，得出结论——放凉以后，它和下水沟的区别只剩一个搪瓷杯。\n\n克劳坐在另一张床边。\n\n他背抵着墙，右手插在夹克口袋里，一夜没动。口袋深处放着一枚缝衣针，针眼里还穿着半截褐线。\n\n那是玛丽修女的。\n\n走廊响起脚步。随后是钥匙相撞的声音。\n\n门开了。\n\n昨天带队去孤儿院的瘦高巡警探进身子。他眼窝发青，袖口沾着泥，手里没有镣铐，只有一摞登记表。\n\n“莱尔·西奥多？”\n\n“是。”\n\n“来补几项基本资料。克劳晚些时候。”\n\n莱尔看向桌角。\n\n“早餐呢？”\n\n巡警揉了揉眉心。\n\n“食堂正在煮。”\n\n“昨天也在煮。”\n\n“锅炉坏了。”\n\n“我开始怀疑，你们的食堂是案发现场。”\n\n巡警嘴角动了动，没笑出来。\n\n莱尔走到门口，又停下。\n\n“给他一杯热水。”\n\n“我让人送。”\n\n“别用装咖啡的壶。”\n\n这次，巡警看了桌上那两杯黑东西一眼，脸上浮出一点认同。\n\n问询室里比走廊暖。\n\n暖炉刚添过煤，热气裹着湿羊毛、烟灰和墨水味扑来。窗边晾着几件被雨淋透的制服，水珠落在铁盘里，滴答作响。\n\n灰胡子治安官坐在桌后。\n\n他昨夜也没休息。外套搭在椅背，衬衣袖子卷到手肘，右手食指沾着一片洗不掉的蓝墨。桌上摊着城西地图，孤儿院附近几条街都被红铅笔圈了起来。\n\n“坐吧。”他说。\n\n莱尔坐下。\n\n记录员先核对姓名、年龄、住址和孤儿院人员名单。问得很细。每个孩子睡在哪间屋，玛丽修女通常几点熄灯，孤儿院有没有后门，近一个月是否收过陌生信件。\n\n不像审问。\n\n更像他们正试着从一堆碎纸里，拼回晨星孤儿院原来的模样。\n\n治安官将一张采购单推过来。\n\n“这是我们从杂货铺找到的副本。你们昨天依次去过面粉铺、药房、煤油店，对吗？”\n\n“还去过旧街的肉铺。”莱尔说，“但肉太贵，没买。”\n\n“店主记得你们。时间也能对上。”\n\n治安官用铅笔在地图上画了一道线。\n\n“城门和沿途店铺都问过了。你们报案前后，有七辆马车经过附近。三辆运煤，一辆送菜，两辆私家车，还有一辆没有登记车牌。”\n\n莱尔看向那个红圈。\n\n“找到最后一辆了吗？”\n\n“正在找。车轮左侧有缺口，碾过软泥会留下断纹。昨夜已经让巡队去查城西的车行和马厩。”\n\n治安官说完，抽出另一张纸。\n\n“现场的鞋印也分出了三种。两双钉铁掌的长靴，一双窄底靴。窄底靴右后跟磨损严重。”\n\n与莱尔昨日报上来的判断一样。\n\n治安所没有把那几句话随手塞进卷宗。他们重新量过，也做了拓印。\n\n只是现场最初被报案的人、邻居和赶到的巡警踩乱不少，能留下来的痕迹不多。\n\n“你当时看得很仔细。”治安官说。\n\n“我在那里站得够久。”\n\n记录员的笔停了一下。\n\n屋里只剩暖炉里煤块开裂的轻响。\n\n治安官没有再追问。他将一张临时安置单压在桌边。\n\n“你们不是嫌疑人。把你们留在这里，一是方便补充情况，二是暂时没有合适的去处。西区救济院腾出床位前，你们可以住休息室。想出去透气，也可以让巡员陪同。”\n\n“要多久？”\n\n“三天内给你们安排住处。异常管理局也会派人来。”\n\n莱尔抬眼。\n\n“为什么？”\n\n“现场有些情况，不归我们单独处理。”\n\n治安官没有敷衍。他指了指桌上一只封好的证物袋。透明薄膜内，躺着几粒颜色发暗的墙灰。\n\n“具体等他们说。”\n\n门外有人敲了两下。\n\n瘦高巡警送进一只搪瓷杯。杯里热气腾腾。\n\n莱尔接过水，回到休息室。\n\n克劳还是原来的姿势。只是他脚边多了一只纸袋，里面装着两块硬面包和一小罐果酱。\n\n“问了什么？”克劳开口。\n\n“名字。年龄。谁睡哪张床。”\n\n“还有呢？”\n\n“他们找到了一辆没登记的马车。”\n\n克劳抬起头。\n\n莱尔把热水递过去。杯壁很烫，克劳接住时，僵硬的手指终于松开一点。\n\n“会找到人吗？”他问。\n\n“会先找到车。”\n\n“人呢？”\n\n“人比车会撒谎。”\n\n克劳没再问。\n\n走廊另一头忽然传来孩子的哭声。很细，很尖。大概是谁走丢了，被家里人领来报案。\n\n克劳手腕一抖，水洒在膝头。\n\n莱尔扯过桌上的旧报纸，盖住那片水迹，也挡住门上的观察窗。\n\n“不是他们。”\n\n哭声很快被人哄住。\n\n克劳低头喝了一口。水太烫，他喉结动了动，没吐出来。\n\n纸袋里的果酱是李子味。\n\n玛丽修女每年秋天也会熬。她总嫌孩子们拿得太多，会拿木勺敲桌沿。可等人散了，瓶底又总会留出两勺。\n\n莱尔掰开面包，把果酱抹得很薄。\n\n克劳盯着那一点暗红，忽然把夹克口袋里的针攥紧了。\n\n谁都没再碰那罐果酱。\n\n第一天，他们分别补了两次记录。\n\n一次核对采购路线。一次辨认近半年到访孤儿院的人。\n\n治安官带来一册临时绘制的访客画像。修烟囱的老工匠，收旧报纸的商贩，给孩子看牙的医生，还有几个向孤儿院捐过衣服的人。\n\n莱尔翻到最后。\n\n纸上是三名穿灰色长衣的男人。帽檐很低，袖口压着银线。\n\n“他们。”莱尔说。\n\n记录员立刻提笔。\n\n“什么时候来的？”\n\n“采购前几天。克劳见过。”\n\n莱尔将画像推回去。\n\n“他们自称异常管理局调查员。”\n\n第二天，雨小了些。\n\n走廊里满是湿靴子、热煤和廉价烟草的味道。电话铃从早晨响到中午，打字机咔嗒不停。巡警抱着卷宗上下楼，门口还停了两辆沾满泥的蒸汽车。\n\n没人闲着。\n\n灰胡子治安官早上来过一次。\n\n“那辆无牌马车找到了半截线索。”他把一张车辙照片放在桌上，“西南旧货场附近有同样的断纹，但昨夜下雨，痕迹断了。”\n\n克劳盯着照片。\n\n“我可以去找。”\n\n“不行。”治安官说，“货场有走私贩和废弃锅炉，巡队会查。你们去了，只会让我们多找两个人。”\n\n克劳脸色发冷。\n\n莱尔却把照片拿近了些。\n\n车辙旁有一枚鞋印。前掌宽，鞋钉排列规整。不是普通工人的靴子。\n\n“查车行了吗？”他问。\n\n“查了二十七家。城西没有修过这种轮子。我们已经把消息送去其他辖区。”\n\n治安官收回照片，动作很慢。\n\n“尸检也有进展。死亡时间与你们外出采购的时间重合。现场没有发现长时间停留的生活痕迹，袭击者来得快，走得也快。”\n\n克劳的下颌绷紧。\n\n他没有问玛丽修女。\n\n治安官看了他一眼，将一只小布包放到桌上。\n\n里面是一串烧黑的木珠。\n\n“从礼拜室门边找到的。你们认得吗？”\n\n莱尔伸出手。\n\n木珠表面开裂，其中一颗还留着浅浅的星形刻痕。那是有个孩子用餐刀偷偷划的，玛丽修女发现后罚他擦了三天长椅。\n\n“是她的念珠。”莱尔说。\n\n他的手指停在那颗星上，没有再动。\n\n治安官沉默片刻。\n\n“现在还不能作为遗物交给你们。案子结束后，会归还。”\n\n“别弄丢。”\n\n“不会。”\n\n他说得郑重。\n\n莱尔便松了手。\n\n当天下午，克劳被单独叫去补充灰衣访客的细节。\n\n门没有关严。\n\n莱尔坐在外面的长椅上，闻见纸张受潮后的霉味，也听见里面简短的问话。\n\n“他们有几个人？”\n\n“三个。”\n\n“问了什么？”\n\n“问孤儿院有没有异于常人的人。”\n\n“玛丽修女怎么答？”\n\n椅子轻响。\n\n克劳隔了几息才开口。\n\n“她说，孩子们没有。她自己会治疗。”\n\n记录员的笔尖在纸上沙沙滑动。\n\n“他们出示过证件吗？”\n\n“有。没让细看。”\n\n门内安静下来。\n\n灰胡子治安官很快走出来，手里多了一张记录纸。他没有责怪克劳为什么昨天没先说，只对瘦高巡警道：“立刻向异常管理局核实。查最近一个月的外勤登记，再把那三个人的画像送过去。”\n\n“是。”\n\n巡警接过纸，快步下楼。\n\n克劳出来时，脸色比墙还白。\n\n莱尔站起身。\n\n“说完了？”\n\n“嗯。”\n\n“那回去。”\n\n克劳没有走。\n\n“如果她不说自己会治疗——”\n\n“他们既然问了，就不会因为一句没有而离开。”\n\n莱尔截断了他。\n\n克劳看着地面。右手又伸进了口袋。\n\n莱尔没再劝，只把休息室那张摇晃的床让给了他。自己靠着墙坐了一夜。\n\n第三天清晨，雾散了些。\n\n阳光从高楼尖顶间落下来，照亮街上的积水，也照出治安所窗玻璃上的灰。早餐多了一只煮蛋。咖啡仍旧发酸，杯底全是粗渣。\n\n莱尔喝了一口，立刻放下。\n\n“好消息。”\n\n克劳剥着蛋壳，抬眼看他。\n\n“他们不是故意折磨我们。”\n\n“什么？”\n\n“这里的咖啡一直这么难喝。”\n\n克劳没笑。\n\n但他把剥好的鸡蛋放到了莱尔面前。\n\n中午过后，走廊忽然安静。\n\n先是皮鞋踩过地板的声音。\n\n两个人。步子不快。没有巡警靴底常见的铁钉声。\n\n接着，一股新煮咖啡的香气从楼梯方向飘来，混着纸张、皮革和某种微凉的金属气味。\n\n门开了。\n\n瘦高巡警外套扣得整齐，手里没有登记表。\n\n“二楼会议室。异常管理局的人到了。”\n\n克劳站起身。\n\n他的手再次插进夹克口袋。\n\n莱尔理了理衣领，先一步出门。\n\n二楼会议室窗户敞着一条缝。雨后的风吹动百叶帘，桌边摆着三杯咖啡，还有一只黑色公文箱。\n\n年轻男人站在窗前。\n\n灰色长衣剪裁利落，袖口压着银线。胸前别着工牌，浅金头发梳得整齐，脸上却带着连夜赶路留下的倦色。\n\n他转过身，向两人点头。\n\n“异常管理局外勤干员，雷金纳德·洛克哈特。”\n\n桌上放着一个牛皮纸文件袋。\n\n封面印着一行红字。\n\n晨星孤儿院异常事件。\n\n“请坐。”雷金纳德说，“今天不是审讯。我需要补齐事件资料，也会向你们说明目前的初步判断。”\n\n莱尔坐下，没有碰咖啡。\n\n克劳坐在他旁边，椅子离桌面很近。\n\n雷金纳德打开文件袋，取出现场照片、名单和两张检测图。问的仍是那些事。孤儿院有多少人，案发前是否出现怪声、怪光，物品有没有无故移动，附近是否发生过无法解释的伤人事件。\n\n问题一项项过去。\n\n莱尔回答得很短。\n\n克劳只在需要时补充。\n\n雷金纳德没有打断，也没有反复诱问。记录完，他从公文箱里拿出一根银灰色探针。探针末端嵌着透明晶片，接通后，里面浮出一层淡蓝微光。\n\n“这是凯莉米粒子检测仪。”\n\n他把一张现场读数图推到桌面中央。\n\n“异能现象发生后，环境中通常会留下凯莉米粒子。普通城区的背景浓度很低，晨星孤儿院现场的数值超过了正常范围四十七倍，而且分布集中。”\n\n莱尔看着图上的数条峰线。\n\n“机器坏了吗？”\n\n“我们带了三台。”\n\n“都坏了？”\n\n雷金纳德顿了一下。\n\n“没有。”\n\n“那确实不是什么好消息。”\n\n雷金纳德把检测仪收回箱中。\n\n“目前只能确认，事件中存在异常力量介入。不能仅凭浓度判断能力类型，也不能直接锁定使用者。后续还要比对残留频谱。”\n\n他说完，翻开人员资料。\n\n那一页很薄。\n\n晨星孤儿院的登记名单上有玛丽修女的姓名、年龄、监护资格和财政记录。除此之外，再无其他。\n\n莱尔的目光停在那里。\n\n“你们有她的异能登记吗？”\n\n雷金纳德抬眼。\n\n“没有。”\n\n“她没有向你们说过自己会治疗？”\n\n“管理局系统内没有相关记录。”\n\n“最近一个月，也没人去过晨星孤儿院？”\n\n雷金纳德没有立刻回答。\n\n他打开公文箱侧层，取出一只薄型通讯器。屏幕亮起，映出外勤调度表。他查了片刻，眉头一点点压低。\n\n“没有派遣记录。”\n\n会议室里只剩百叶帘拍打窗框的轻响。\n\n哒。\n\n哒。\n\n克劳从口袋里抽出手，压在桌沿。\n\n“那三个人是假的。”他说。\n\n雷金纳德合上通讯器。\n\n“把特征再说一遍。”\n\n莱尔没有急着回答。\n\n“有人冒充异常管理局，专门收集异能者信息。你们以前遇到过吗？”\n\n“这部分不能向非内部人员透露。”\n\n“那就是遇到过。”\n\n雷金纳德看了他两秒，没有承认，也没有否认。\n\n他抽出一张空白记录纸。\n\n三名男子。灰色长衣。银线袖口。制式证件。询问异能者。没有留下姓名。离开时乘坐一辆深色马车。\n\n克劳补充了身高和口音。\n\n莱尔补充了证件边缘的暗红封蜡，以及其中一人右手食指缺了一截指甲。\n\n雷金纳德全部记下。\n\n“从现在起，这条线索由管理局与治安所联合调查。”他说，“你们暂时不要单独追查，也不要向外透露玛丽修女的情况。新的住处会加装报警器，附近报案台也会收到你们的保护通知。”\n\n“如果他们先找到我们呢？”克劳问。\n\n“立刻报警。”\n\n“来不及呢？”\n\n雷金纳德看见了他口袋里露出的半截褐线。\n\n“那就先活下来。”\n\n克劳盯着他，没再说话。\n\n雷金纳德将文件装回纸袋，又单独抽出两张联络卡，推到两人面前。\n\n“这是我的号码。案件有进展，我会通知你们。想起任何细节，也可以直接联系我。”\n\n莱尔收起卡片。\n\n“洛克哈特先生。”\n\n雷金纳德动作一顿。\n\n“我似乎没说过姓氏。”\n\n莱尔没动。\n\n克劳也没动。\n\n片刻后，两个人同时抬手，指向他的胸口。\n\n雷金纳德低头。\n\n工牌上，“雷金纳德·洛克哈特”几个字印得清清楚楚。\n\n会议室安静了两息。\n\n莱尔端起那杯新煮的咖啡，喝了一口。\n\n“味道不错。”\n\n他顿了顿。\n\n“至少你们不是假的。”	5394	1	\N	2026-08-06 22:21:54.715107	2026-08-06 14:21:54.712688	2026-08-06 14:24:26.739011
5eba7e90-ff25-4459-8605-50c1dcfa7825	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	b3f095c4-3fcb-442a-badf-d67521a2b762	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		["\\u3010\\u63cf\\u5199\\u4f18\\u5316\\u3011\\u4e2d\\u6bb5\\u7ba1\\u7406\\u5c40\\u5ba1\\u95ee\\u4e2d\\u5927\\u91cf\\u4f9d\\u8d56\\u5bf9\\u8bdd\\u4ea4\\u4ee3\\u4fe1\\u606f\\uff0c\\u53ef\\u5728\\u96f7\\u91d1\\u7eb3\\u5fb7\\u8bb2\\u89e3\\u51ef\\u8389\\u7c73\\u7c92\\u5b50\\u7684\\u6bb5\\u843d\\u95f4\\u52a0\\u5165\\u5bf9\\u73af\\u5883\\u7ec6\\u8282\\uff08\\u5982\\u5149\\u7ebf\\u53d8\\u5316\\u3001\\u7eb8\\u5f20\\u7ffb\\u52a8\\u58f0\\uff09\\u7684\\u63cf\\u5199\\uff0c\\u4ee5\\u589e\\u5f3a\\u7d27\\u5f20\\u6c1b\\u56f4\\u548c\\u753b\\u9762\\u611f\\u3002"]	[0]	\N	\N	2500	["description", "dialogue"]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	completed	0	\N	治安所的炖菜咸得发苦。\n\n克劳只吃了两口，便把勺子放回碗里。\n\n“我想玛丽修女做的通心粉了。”\n\n莱尔握着勺子的手停了一下。\n\n他们在治安所住了三天。\n\n克劳盯着碗里的土豆，勺柄上还沾着一滴汤。\n\n“她做的不会这么咸。”\n\n莱尔低头喝了一口。\n\n确实很咸。玛丽修女如果尝到，大概会把厨师赶回灶台，叫他往锅里再添两瓢水。\n\n莱尔把旁边的水杯推给克劳。\n\n“喝点水。”\n\n克劳没动。\n\n过了一会儿，他问：“你的能力到底是什么？”\n\n周围餐具碰撞的声音还在继续。有人拖开椅子，木腿刮过地面，发出刺耳的长响。\n\n莱尔看着克劳。\n\n“为什么问这个？”\n\n“你一直不肯说。”\n\n“现在也不是什么好时候。”\n\n“所以能做到？”\n\n克劳终于抬起头。他眼下泛着青，像是三天都没真正睡着。\n\n“能让人活过来吗？”他问。\n\n莱尔没有回答。\n\n克劳的声音更低了些。\n\n“或者让时间倒回去。回到我们出门以前，早一点也行。你提前告诉玛丽修女，让大家离开。”\n\n他朝前倾了倾，手指抓住桌沿。\n\n莱尔喉咙发紧。\n\n“莱尔。”\n\n他的声音压得很轻。\n\n“你试过了吗？”\n\n“没有。”\n\n“为什么不试？”\n\n“因为做不到。”\n\n克劳盯着他。\n\n莱尔把勺子放下。\n\n“我能从物品的视角看见过去，只能看见。时间不会停，也不会往回走。”\n\n“你没碰过现场的东西。”\n\n“碰了也救不了他们。”\n\n“也许还有别的用法。”\n\n“没有。”\n\n莱尔说得很快。他怕慢一点，自己也会顺着克劳的话去想。\n\n去想那块歪斜的门板，那张翻倒的餐桌，如果他伸手，或许能看见院门被撞开的时刻，能看清来人的脸，能听见餐厅里发生过什么。\n\n他也只能看着。\n\n画面结束以后，木头会腐坏，金属会开裂。死人依旧躺在原处。\n\n“对不起。”莱尔说。\n\n克劳抓着桌沿的手松开了。\n\n他低下头，重新拿起勺子，把已经凉掉的炖菜送进嘴里。咽得很慢，却一口接一口，直到碗底只剩薄薄一层汤。\n\n莱尔没再劝他喝水。\n\n“西奥多，沃尔特。”\n\n一名年轻治安官站在餐厅门口，手里夹着文件板。\n\n“两位，有客人要见你们。跟我去会议室。”\n\n会议室在二楼走廊尽头。\n\n屋子不大，窗帘拉开一半，正午的光落在长桌上。桌边坐着一个穿深灰制服的男人，寸头，肩膀很宽。\n\n男人示意他们坐下。\n\n“我来自异常管理局。这次谈话由我负责。”\n\n他的声音不高，话说得很慢，目光却一直落在两人脸上。\n\n“异常管理局？”克劳问。\n\n“专门处理异能失控、异常器物和相关案件。”男人从手边拿起一个文件袋，“晨星孤儿院出事时，东郊的监测装置记录到凯莉米粒子浓度突然升高，超过了安全阈值。管理局因此接手调查。”\n\n莱尔看了一眼文件袋。牛皮纸封面上用黑墨写着一行字：晨星孤儿院异常事件。\n\n“凯莉米粒子是什么？”他问。\n\n“肉眼看不到的一种粒子。”男人用手指轻敲桌面，“异能发动和异常器物活动时，周围的粒子浓度会发生变化。最早发现这种变化的人叫凯莉米。她后来制造出第一台观测仪，后人便用她的名字称呼这种粒子。”\n\n“浓度高，说明出现了异常事件？”\n\n“通常可以这样判断。普通使用只会让数字轻微浮动。浓度越过警戒线，管理局会将当地标记为异常事件。晨星孤儿院当时的读数很高。”\n\n男人解开文件袋的绕绳，先取出一张画有街道的地图。\n\n“这里是孤儿院？”\n\n莱尔看了一眼：“对。东边是菜畦和储物棚，图上少画了一间鸡舍。”\n\n男人在纸边写了几个字，又拿出一份人员登记表。\n\n上面列着玛丽修女和孩子的姓名、年龄。部分名字旁还夹着从市政档案里找到的小幅照片。\n\n“你们逐个看。姓名、住址、人物，有不对的地方就指出来。”\n\n莱尔和克劳从头认到尾。\n\n资料核对完后，他没有立刻收起来。\n\n“还有两个问题。”\n\n男人双手交叠在桌上。十根指甲修剪得很短，指节附近有几处轻微脱皮。\n\n“孤儿院里，有没有人拥有异能？”\n\n克劳的右手缩进桌下。\n\n“或者在案发前后，你们有没有见过无法解释的事？陌生器物、奇怪的痕迹、突然出现又消失的人，都算。”\n\n莱尔没有急着回答。\n\n几天前来过孤儿院的人，自称来自异常管理局，也在询问异能。\n\n可眼前这个男人手里有监测记录，有市政档案，连案发后的数据都要重新核对。他似乎并不知道此前有人上门调查。\n\n莱尔看向他问道。\n\n“雷金纳德先生。”\n\n男人眉梢动了一下。\n\n“有没有人或组织冒充异常管理局？”莱尔问\n\n男人没有回答，目光在莱尔与克劳之间走了一遍。\n\n克劳开口：“案发前几天，有三个人来过。他们穿灰色大衣，他们问玛丽修女，院里谁有异能。”\n\n“什么时候？”\n\n“具体时间不太记得了，反正是下午，在会客室待了快一个钟头。”\n\n“你见过他们的脸？”\n\n“见过两个。”\n\n男人拉过一张空白记录纸：“等会儿把能记住的特征全部告诉我。”\n\n他写了几行，笔尖忽然停住。\n\n“刚才问的，属于敏感情报，我不能透露。”\n\n“我们住的地方没了。”莱尔说，“至少该让我们知道，他们是谁。”\n\n男人沉默片刻。\n\n“我会查清那三个人的身份，也会让治安所加强对你们的保护。能公开的消息，我会亲自告诉你们。”\n\n男人收好文件，把绕绳重新扣上。等治安官来带他们离开时，他忽然叫住莱尔。\n\n“等一下。”\n\n莱尔回过头。\n\n男人指了指自己：“我进门后只说了所属部门，没有报姓名。你怎么知道我叫雷金纳德？”\n\n他低头看了看制服领口，又摸了摸袖扣。\n\n“徽章的编号？报纸？还是你从口音和职级上猜出来的？”\n\n莱尔看着他。\n\n克劳也看着他。\n\n沉默了几秒，两人抬手，指向男人胸前。\n\n“先生，你的工牌。”	2269	晨雾从港口爬上来，把治安所对面的钟楼吞掉了半截。窗玻璃凝着一层水汽，里面传出餐盘磕碰和管道嘶嘶的声响。\n\n食堂里，炖菜咸得发苦。\n\n克劳吃了两口就把勺子放下。“我想玛丽修女做的通心粉了。”\n\n莱尔握勺的手停了一下。\n\n他们在治安所住了三天。\n\n克劳盯着碗里的土豆。勺柄上还悬着一滴汤。\n\n“她做的不会这么咸。”\n\n莱尔低头喝了一口。确实很咸。玛丽修女要是在，大概会把这个厨师赶回灶台，让他往锅里添两瓢水再端上桌。\n\n他把水杯推给克劳。“喝点水。”\n\n克劳没动。\n\n过了一会儿，他问：“你的能力到底是什么？”\n\n四周的餐具碰撞声还在继续。有人拖开椅子，木腿刮过地面，发出刺耳的长响。\n\n莱尔看着克劳。“为什么问这个？”\n\n“你一直不肯说。”\n\n“现在也不是什么好时候。”\n\n“所以能做到？”\n\n克劳终于抬起头。眼圈泛着青，三天没真正睡过的颜色。“能让人活过来吗？”\n\n莱尔没有回答。\n\n克劳声音压得更低：“或者让时间倒回去。回到我们出门以前。早一点也行。你提前告诉玛丽修女，让大家离开。”\n\n他前倾身体，指节攥住桌沿。\n\n莱尔喉咙发紧。\n\n“莱尔——你试过了吗？”\n\n“没有。”\n\n“为什么不试？”\n\n“做不到。”\n\n克劳盯着他。\n\n莱尔放下勺子。“我能从物品的视角看到过去。只能看见。时间不会停，也不会往回走。”\n\n“你没碰过现场的东西。”\n\n“碰了也救不了他们。”\n\n“也许还有别的用法——”\n\n“没有。”\n\n莱尔说得很快。他怕慢一点，自己也会顺着克劳的话想。想那块歪斜的门板、那张翻倒的餐桌——如果他伸手，或许能看见院门被撞开的时刻。看清来人的脸。听见餐厅里的动静。\n\n然后呢。\n\n画面结束之后，木头照样腐烂，金属照样生锈。死去的人依旧躺在原来的地方。\n\n“对不起。”莱尔说。\n\n克劳松开桌沿，低下头重新拿起勺子。凉掉的炖菜，一口接一口送进嘴里。咽得很慢，却没停。直到碗底只剩薄薄一层汤。\n\n莱尔没有再劝他喝水。\n\n“西奥多，沃尔特。”\n\n一名年轻治安官出现在餐厅门口，腋下夹着文件板。“两位，有人要见。会议室。”\n\n楼梯间有地板蜡和湿石膏的气味。二楼走廊尽头，会议室门开着，窗帘半垂。正午的光在长桌上摊成一块发白的方形，灰尘在光柱里慢慢浮沉。\n\n桌边坐着一个深灰色制服的男人。寸头，宽肩。\n\n他示意他们坐下。\n\n“我来自异常管理局。这次谈话由我负责。”声音不高，语速很慢，目光一直落在两人脸上。\n\n“异常管理局？”克劳问。\n\n“专门处理异能失控、异常器物和相关案件。”男人拿起桌上一只牛皮纸文件袋。袋面黑墨写着一行字：晨星孤儿院异常事件。“孤儿院出事的当天，东郊监测装置记录到凯莉米粒子浓度突然超过安全阈值。管理局因此介入。”\n\n莱尔的目光扫过文件袋，又看向男人。“凯莉米粒子是什么？”\n\n“肉眼看不到的一种粒子。”他手指点着桌面，“异能发动或异常器物活动时，周围粒子浓度会发生变化。最早发现这种现象的人叫凯莉米。她后来制造出第一台观测仪，后人便用她的名字命名。”\n\n窗外远远传来报菜价的声音，隔着砖墙，闷闷的。正午的光在桌上爬了半寸，从文件袋一角挪到他指节旁。\n\n“浓度升高，就代表出现异常事件？”\n\n“通常可以这样判断。日常使用只会让数字轻微浮动。越过了警戒线，管理局就会标记为异常事件。孤儿院当天的读数很高。”他解开绕绳。绳圈松开，一股旧纸的灰尘味散出来。\n\n先取出一张地图。“这里是孤儿院？”\n\n莱尔看了一眼：“对。东边是菜畦和储物棚，图上少了间鸡舍。”\n\n男人在纸边记了一笔，又抽出一份人员登记表。表上列着玛丽修女和孩子们的姓名年龄，附有从市政档案调来的小幅照片。\n\n“逐个看。姓名、住址、人物，不对的地方指出来。”\n\n莱尔和克劳从头认到尾。纸页翻动，沙沙声响在安静里。莱尔指尖掠过每一个名字，没有停顿。\n\n核对完，男人没有立刻收起来。他双手交叠在桌上。指甲剪得很短，指节有几处脱皮。\n\n“还有两个问题。”\n\n“孤儿院里，有没有人拥有异能？”\n\n克劳的右手缩回桌下。\n\n“或者在案发前后，你们有没有见过无法解释的事？陌生的器物、奇怪的痕迹、突然出现又消失的人，都算。”\n\n莱尔没有立刻回答。\n\n几天前，有人来过孤儿院。灰色大衣，自称异常管理局，也在打听异能。但眼前这个男人手里有监测记录，有市政档案，连案发后的数据都拿来核对。他似乎并不知道此前有人上门。\n\n莱尔开口：“雷金纳德先生。”\n\n男人眉梢动了一下。\n\n“有没有人或组织冒充异常管理局？”\n\n男人没有回答，目光在莱尔和克劳之间走了一遍。\n\n克劳接话：“案发前三天，有三个人来过。灰色大衣。问玛丽修女，院里谁有异能。”\n\n“什么时候？”\n\n“下午——具体时间记不太清，在会客室待了近一个钟头。”\n\n“见过他们的脸？”\n\n“见过两个。”\n\n男人拉过一张空白记录纸：“能记住的特征，全部告诉我。”他写了几行，笔尖停住，抬眼。“刚才问的，属于敏感情报，我不能透露。”\n\n“我们住的地方没了。”莱尔说，“至少该让我们知道他们是谁。”\n\n男人沉默了一会儿。窗外的光线移了移，他半张脸落进阴影里。“我会查清那三个人的身份，也会让治安所加强对你们的保护。能公开的消息，我会亲自告诉你们。”\n\n他把文件收好，绕绳重新扣上。等治安官来带他们离开时，他忽然叫住莱尔。\n\n“等一下。”\n\n莱尔回过头。\n\n男人指了指自己，又低头看了看制服领口，摸了摸袖扣：“我进门后只说了所属部门，没有报姓名。你怎么知道我叫雷金纳德？”\n\n莱尔看着他。克劳也看着他。\n\n沉默了几秒。\n\n两人同时抬手，指向男人胸前。\n\n“先生，你的工牌。”	2285	1	\N	2026-08-06 23:08:10.006599	2026-08-06 15:08:09.9694	2026-08-06 15:10:21.05218
208ae188-3b5c-4577-9a31-381c9699c739	9dc2adf5-8afa-4116-a98e-e481ecd4c427	ee6ab938-7f4a-4625-8a44-085212b151b3	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		["\\u3010\\u8282\\u594f\\u95ee\\u9898\\u3011\\u8fde\\u7eed\\u8bfb\\u53d6\\u8def\\u706f\\u3001\\u5899\\u7816\\u3001\\u77f3\\u677f\\u3001\\u90ae\\u7b52\\u3001\\u94c1\\u680f\\u6746\\u4e94\\u7ec4\\u8bb0\\u5fc6\\uff0c\\u7ed3\\u6784\\u548c\\u53e5\\u5f0f\\u63a5\\u8fd1\\uff0c\\u5bb9\\u6613\\u4ea7\\u751f\\u91cd\\u590d\\u611f\\u3002\\u5efa\\u8bae\\u5c06\\u90e8\\u5206\\u7269\\u4ef6\\u8bb0\\u5fc6\\u5408\\u5e76\\u6216\\u5728\\u8be6\\u7565\\u4e0a\\u5206\\u5316\\uff0c\\u4f8b\\u5982\\u901a\\u8fc7\\u7b80\\u5199\\u6216\\u53d8\\u6362\\u53d9\\u8ff0\\u89c6\\u89d2\\u4f7f\\u8c03\\u67e5\\u8fc7\\u7a0b\\u66f4\\u51dd\\u7ec3\\u3002", "\\u3010\\u63cf\\u5199\\u4e0d\\u8db3\\u3011\\u739b\\u8482\\u5c14\\u8fbe\\u8d70\\u8fdb\\u7a7a\\u5730\\u540e\\u7ebf\\u7d22\\u5f7b\\u5e95\\u65ad\\u88c2\\u7684\\u8282\\u70b9\\u662f\\u672c\\u7ae0\\u60c5\\u611f\\u5173\\u952e\\u70b9\\uff0c\\u4f46\\u73af\\u5883\\u4e0e\\u83b1\\u5c14\\u8eab\\u4f53\\u53cd\\u5e94\\u7684\\u63cf\\u5199\\u8f83\\u514b\\u5236\\u3002\\u53ef\\u589e\\u52a0\\u4e00\\u70b9\\u5f53\\u65f6\\u7684\\u98ce\\u5411\\u3001\\u5929\\u8272\\u6216\\u4ed6\\u624b\\u4e0a\\u6e29\\u5ea6\\u7684\\u53d8\\u5316\\uff0c\\u8ba9\\u65ad\\u7ebf\\u7684\\u6c89\\u6ede\\u611f\\u66f4\\u53ef\\u611f\\u77e5\\u3002"]	[0, 1]	\N	\N	2500	["pacing", "description", "dialogue"]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	completed	0	\N	莱尔站起来，走到窗边，看了一会儿街面。马车碾过石板路，几个行人走过，没一会就看到塞西莉小姐她们的离去身影。\n\n塞西莉最后当然是拒绝了莱尔的催眠。\n\n"西区铜锣巷口"莱尔自言自语，他拿起帽子，扣回头上。\n\n...\n...\n...\n\n下午的铜锣巷比晚上热闹。\n\n卖鱼、卖布、拉车的挤了半条巷子，人声混着马铃铛。莱尔站在巷口，把帽檐压低一指，目光先扫了一圈。那盏铁杆路灯立在巷口，漆皮剥落，灯罩确实缺了个角，露出里面积灰的灯芯。石板路被车轮磨出两道亮痕。\n\n他靠着墙，等了约莫一炷香的工夫，等一拨行人散过去，巷口空下来。\n\n没人注意他。\n\n莱尔走到路灯下，把左手贴上铁杆。掌心压着冰凉的铁皮。\n\n闭上眼睛。\n\n画面来了。\n\n不是他的眼睛。是铁杆的"眼睛"。\n\n夜里九点，路灯亮着，黄光罩着巷口。一顶软呢帽从画面边缘探出来——帽檐压得很低，只露出一截下巴和半截深灰大衣的肩。那人贴着灯杆阴影站，一动不动，隔着半个巷口盯着对面。\n\n盯着排练室的方向。\n\n画面里有脚步声，从远到近，压得低。是塞西莉和玛蒂尔达说话的声音。软呢帽往阴影里缩了缩，脚步也放轻了。\n\n莱尔松开手。铁杆上多了几个黑点，指甲盖大小，像火苗舔过的焦痕。他记住了那顶软呢帽。\n\n第二件物件是墙砖。\n\n排练室门边那堵墙，砖缝里卡着几根草屑。莱尔蹲下去，指尖按上砖面。砖的视线贴地，矮——画面里一双穿软底鞋的脚碾过地面，鞋尖朝排练室的方向停了两秒，又挪开。鞋码不大，前掌宽后跟窄。\n\n是那个矮个子。\n\n他继续往前追。巷子中间那块石板，被马车碾出一道亮痕，石缝里积着泥。莱尔俯身按住石板。石板的视线是一条横贯的线——一个矮小的影子从巷子另一侧横穿过来，脚步极轻，落地几乎没声。软呢帽、深灰大衣，腋下夹着个本子。\n\n邮筒。铁皮桶身，塞西莉说玛蒂尔达每天从那儿经过。莱尔把掌心按上桶身。邮筒的视线里，玛蒂尔达的侧脸走过去，脚步稳，没回头。十步之后，软呢帽跟着出现，停在邮筒另一侧，探出半个头朝她的背影看了一眼，又缩回去。\n\n不是顺路。是专门跟着。\n\n一路摸下去。墙砖、门框、铁栏杆，每件物件都给他一段画面，一段一个碎块。铁栏杆的视线里，他终于看清了那人的脸——个子不高，络腮胡茬，眉骨很深，嘴角压着一道旧疤。深灰大衣袖口沾着油墨，指头上有印子，常年碰报纸、碰铅字的人。\n\n是个干印刷或者干新闻行当的人。\n\n莱尔把这个样貌在脑子里钉死。矮，胡茬，眉骨深，嘴角有疤，油墨手指。够画出一张脸了。\n\n然后他追到第三段路，卡住了。\n\n玛蒂尔达往西走，巷子到头是一段空旷的泥地，再往前是条大路，车马不断。莱尔追过去，摸到路边一根拴马桩。桩子的视线里只有泥地——那晚下过一场小雨，泥地上的脚印被后来的车辙碾平，再往后没有物件接着。玛蒂尔达走进了那片空地，就再没有东西告诉他，她去了哪。\n\n软呢帽也是。他在岔路口附近摸了一圈，铁栅栏、门环、墙角，画面都在那人拐进一条暗巷后戛然而止。暗巷里没有路灯，墙是新刷的石灰，没有能被"记住"的物件。那人像凭空化在了巷子的阴影里。\n\n两条线，都断了。\n\n莱尔站在岔路口，手垂在身侧。风从巷子里灌出来，带着下水道的潮气。路灯杆上的焦痕还留在原地，黑黢黢几个点。\n\n他没法靠能力知道玛蒂尔达那晚之后去了哪。那晚的画面里她还好好地走着，被跟踪着。可跟到这儿，什么都没了。\n\n她是回了家，还是被人截在了半路？\n\n莱尔摸出那枚铜币，在指间翻了半圈。铜币凉，贴着掌心，他捏了一会儿，又收进兜里。\n\n他转身，朝治安所的方向走去。	1441	六月的云压在格雷文赫城上空，灰白一层，像港口烟囱吐出的煤灰没有散尽。海鸥掠过尖顶钟楼，翅尖擦着潮湿的风。再往下，是交错的蒸汽轨道、石板街和一排排漆黑屋脊。马车铃声沿街滚过，街角的异常粒子监测仪亮着绿灯，细针稳稳停在常态刻度。\n\n月季咖啡厅二楼，窗缝漏进一点凉气。\n\n莱尔站在窗边，看着塞西莉和哈里特穿过街面。哈里特走得快，高跟鞋敲得又急又脆。塞西莉落后半步，临上马车前，还回头看了一眼二楼。\n\n目光很冷。\n\n显然，那支装着吐真剂的针管，并没能替双方建立更多信任。\n\n马车门“砰”地合上。\n\n莱尔抬手碰了碰鼻尖，低声道：“至少省了一支药。”\n\n桌上的咖啡已经凉了。苦味混着消毒酒精的气味，实在算不上相配。他端起来喝了一口，眉头顿时皱紧。\n\n今天的豆子也不对。\n\n他放下杯子，目光落在塞西莉留下的地址上。\n\n六月三日，晚上九点。\n\n西区，铜锣巷口。\n\n排练散场。黑影跟踪。玛蒂尔达此后反应迟钝，打鼓慢了半拍。街角监测仪全程常态，异常管理局不予受理。\n\n莱尔用指节敲了敲纸面。\n\n常态，只能证明现实没有被大幅搅动。\n\n不能证明什么都没发生。\n\n他把纸条折起，塞进大衣内袋，抓起衣帽架上的软帽。帽檐扣下时，他顺手将那支没派上用场的针管锁回抽屉。\n\n咔哒。\n\n“真遗憾。”他说。\n\n楼下传来瓷杯碰撞声。格蕾丝太太在柜台后擦杯子，咖啡香裹着烤面包的热气，暖融融地堵在楼梯口。她没抬头，只看见一双鞋从台阶上下来。\n\n“晚饭前回来？”\n\n“看失踪的人给不给面子。”\n\n“你上次这么说，半夜带回来一只掉毛的猫。”\n\n“那位委托人付钱很痛快。”\n\n格蕾丝太太把抹布甩到肩上。\n\n“猫付的？”\n\n莱尔推门出去，没有回答。\n\n门铃叮当一响，冷风立刻灌了进来。\n\n西区铜锣巷离月季咖啡厅不远，坐公共蒸汽车只需四站。可车厢里挤满了刚从码头换班的工人，汗味、鱼腥和廉价烟草搅成一团。蒸汽阀每隔半分钟便“嗤”地泄一次气，热雾贴着裤腿漫开。\n\n莱尔只坐了一站便下了车。\n\n他宁愿走路。\n\n越往西，楼影越密。哥特式尖窗下搭着歪斜棚屋，晾衣绳横在两栋楼之间。卖鱼的把碎冰扫进排水沟，腥水沿石缝淌过。几个孩子赤脚追着运煤车跑，车轮卷起黑泥，溅在街边的异常报案指示牌上。\n\n牌子上写着：发现异常，请勿触碰。\n\n下面不知被谁添了一行小字。\n\n——除非治安所让你自己解决。\n\n莱尔扫了一眼，脚步没停。\n\n下午的铜锣巷比夜里热闹。\n\n鱼贩拍着案板叫卖，布商扯开嗓门招呼客人。拉车夫的咒骂、马铃声和婴儿哭声挤在一起。空气里有烂菜叶的酸味，也有煤气灯管道微微泄漏的臭气，吸进鼻腔，发涩。\n\n巷口立着一盏铁杆路灯。\n\n漆皮剥落。灯罩缺了一角。积灰的灯芯露在里面，与塞西莉描述的一样。\n\n莱尔没有立刻过去。\n\n他站在一家旧帽店的遮棚下，把帽檐压低一指。目光先掠过路灯，再扫向巷子深处。\n\n排练室在右侧第三栋楼。红漆木门，铜把手，门楣上钉着锈蔷薇乐队的旧海报。纸边被雨水泡卷，塞西莉的半张脸还露在外面。\n\n路灯斜对面有茶摊。再往里是邮筒、拴马桩和一排铁栏杆。\n\n适合盯梢的地方不少。\n\n适合藏身的地方更多。\n\n莱尔靠墙等了近一刻钟。等鱼车拐出巷口，等两名搬运工扛着木箱过去，也等茶摊老板将视线从他身上挪开。\n\n人流稀了一瞬。\n\n他这才走到路灯下，摘掉左手手套。\n\n铁杆冰凉，表面沾着一层细腻的煤灰。掌心贴上去时，寒意顺着指骨往上爬。\n\n莱尔闭上眼。\n\n耳边的叫卖声陡然远去。\n\n黑暗里，先浮出一团昏黄的灯光。\n\n那不是他的视野。\n\n画面立在巷口，僵硬，沉默，几十年如一日。\n\n夜里九点，煤气灯在风里轻晃。湿漉漉的石板反着光。一顶软呢帽从画面边缘探出来，帽檐压得很低，只露出一截下巴和深灰大衣的肩。\n\n那人贴着灯杆的阴影站定。\n\n不抽烟。不跺脚。\n\n也不看街上的女人和马车。\n\n他始终盯着排练室。\n\n远处传来两个女人的说话声。一个清亮，一个沉稳。软呢帽往阴影里缩了半步，鞋底落地极轻，几乎没声。\n\n莱尔睁开眼，松开手。\n\n现实的喧闹猛地撞回耳中。他的指尖僵了一下，掌心残留着针扎般的冷麻。铁杆表面，多出三点焦黑，像被细小火星舔过。\n\n茶摊老板盯着他。\n\n“先生，灯杆不卖。”\n\n“我也没钱买。”\n\n莱尔戴回手套，朝排练室走去。\n\n门边的砖墙受过潮，缝里卡着草屑。墙根积着鱼鳞和黑泥，几只苍蝇嗡嗡打转。他蹲下，手指按住一块磨损最重的墙砖。\n\n画面骤低。\n\n贴着地面。\n\n一双软底鞋踏过来，鞋尖在排练室方向停了两秒。鞋码不大，前掌宽，后跟窄。鞋底边缘有一道月牙形缺口。\n\n那人换过站位。\n\n莱尔收手，没有再逐块摸下去。\n\n软呢帽留下的路线已经很清楚。\n\n他沿巷子往西走。路过那块被车轮磨亮的石板时，只用指尖短暂碰了一下。一个矮小影子横穿巷面，腋下夹着薄本。深灰大衣摆擦过膝侧，脚步轻而稳定。\n\n邮筒给出的画面更短。\n\n玛蒂尔达先走过去。\n\n她背着黑色皮包，头微微低着，步子不快。十步之后，软呢帽从邮筒另一侧露出半张脸。他等了片刻，才无声跟上。\n\n不是顺路。\n\n是在计算距离。\n\n后面的线索零碎起来。\n\n门环记住一截灰色衣袖。橱窗映出被拉长的人影。铁栏杆上，雨水把画面切成细碎的亮斑。莱尔一路走，一路挑选能看见街面的旧物，掠过无用的行人和马车，把同一个影子从杂乱记忆里剥出来。\n\n他没有每次都停太久。\n\n碰一下。\n\n看一眼。\n\n再往前。\n\n记忆像被扯断的胶片，在他脑中迅速拼合。\n\n直到巷子中段，那排生锈的铁栏杆终于给了他一张完整的脸。\n\n矮个子。\n\n络腮胡没有修净。眉骨很深。右侧嘴角压着一道旧疤，笑不笑都显得阴沉。深灰大衣的袖口蹭着油墨，拇指与食指内侧也染成暗蓝黑色。\n\n他手里夹着薄本，边角露出一小片铅灰。\n\n印刷工。排字工。或者常年跟报纸打交道的人。\n\n莱尔将那张脸钉进脑子。\n\n身高，约五尺四寸。\n\n软底鞋，鞋底有月牙缺口。\n\n右嘴角旧疤。\n\n手染油墨。\n\n够治安所从档案里筛一遍了。\n\n他继续往前。\n\n巷尾的气味更重。下水道口堵着烂布和菜梗，潮气贴着墙根往上爬。头顶的天空被两排高楼夹成窄窄一条，云层已经压暗，风从西边灌进来，卷着雨前的土腥味。\n\n玛蒂尔达的路线在这里拐向一片空地。\n\n那是拆掉旧仓房后留下的泥场。地面坑洼，散着碎砖、锈钉和烧黑的木头。几辆货车从大路轧过，车轮陷进软泥，发出黏滞的“咯吱”声。\n\n莱尔站在泥地边缘，先摸了路旁的拴马桩。\n\n潮湿的木头寒得刺手。\n\n画面里，六月三日的细雨斜斜落下。\n\n玛蒂尔达走进空地。黑色皮包贴着她的腰侧，一晃，一晃。她没有回头，也没有加快脚步。\n\n几秒后，软呢帽出现在后方。\n\n两道影子一前一后，走进雨幕。\n\n然后，一辆运货马车横穿过去。\n\n车轮卷起泥水。\n\n画面再露出来时，脚印已经乱了。\n\n莱尔维持着触碰，没有松手。\n\n拴马桩能记住的只有它所看见的地方。玛蒂尔达出了那一小片视野，便像被夜色吞掉。之后的雨、车辙和无数双鞋，将残余的足迹一层层踩烂。\n\n什么都没有。\n\n他睁开眼。\n\n风恰在这时转向。\n\n冷气从袖口钻进去，贴着汗湿的皮肤往上爬。莱尔的左手仍按在木桩上，指节因为用力微微发白。掌下那块木头慢慢焦黑，细小裂纹无声绽开。\n\n他松开手。\n\n掌心失去知觉似的僵了两息，才重新屈起。\n\n空地很宽。\n\n天色却低得让人喘不过气。\n\n玛蒂尔达那晚还好好走着。没有奔逃，没有呼救。她甚至不知道身后有人，或者知道了，也没有表现出来。\n\n再往后，便没有物件替她看见。\n\n莱尔踩进泥地，绕着边缘走了一圈。碎砖看见的只是车轮。废弃铁桶记住几个醉汉。路旁一块广告牌在那晚被风吹倒，视野始终埋在泥里。\n\n没有玛蒂尔达。\n\n他折回软呢帽最后出现的位置。\n\n矮个子没有继续横穿空地，而是在岔口拐进左侧暗巷。那条巷子夹在两座新修的仓库之间，窄得只能容两人并肩。墙面刚刷过石灰，潮白一片。没有煤气灯，也没有监测仪。门窗全封着，连个能映出人影的玻璃都找不到。\n\n莱尔摸过巷口的铁栅栏。\n\n画面里，软呢帽侧身进去。\n\n灰色大衣被黑暗一点点吞没。\n\n没了。\n\n他又碰了门环、排水管和墙角残留的旧砖。能看见的角度全不对。最后一块旧砖只记住一只老鼠从水沟钻过，尾巴拖着污水。\n\n两条线，都断在这里。\n\n一条断在空地。\n\n一条断在暗巷。\n\n莱尔站在岔路口，身后是车马不断的大路，面前是没有灯的窄巷。风卷过空地，把一张旧报纸推到他脚边。纸面沾满泥，只剩半行印刷厂的招工启事。\n\n他低头看了两秒，用鞋尖将报纸翻过来。\n\n空白背面，一枚模糊的鞋印压在纸角。\n\n不属于那一晚。泥还是新的。\n\n没用。\n\n莱尔弯腰捡起报纸，目光却停在那半行铅字上。\n\n印刷。\n\n油墨。\n\n薄本。\n\n他把报纸折好，塞进大衣口袋。随后摸出一枚铜币，在指间翻了半圈。\n\n铜币贴着掌心，凉得像刚才那根拴马桩。\n\n玛蒂尔达可能回了家。\n\n也可能，她从来没有走出那片空地。\n\n莱尔捏住铜币，抬眼望向巷外。街角的煤气灯尚未点亮，异常粒子监测仪仍闪着安稳的绿光，仿佛六月三日的夜里也确实什么都没发生。\n\n他把铜币收回兜里。\n\n先查脸。\n\n再查油墨。\n\n治安所若没有答案，城里总有些不写进档案的人认得这张脸。\n\n莱尔转身走出暗巷。鞋底碾过湿泥，留下两行清楚的足迹。\n\n风很快追了上来。	3749	1	\N	2026-08-07 00:46:30.026767	2026-08-06 16:46:30.022955	2026-08-06 16:48:11.319637
eb21e505-a41c-409b-9d13-184107279e5f	72191e56-643e-49a5-9216-78a08f6e1494	a6b68c35-289d-492c-8234-fe0a66625730	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		["\\u3010\\u7ed3\\u5c3e\\u5b8c\\u6574\\u6027\\u3011\\u73b0\\u6709\\u7ae0\\u8282\\u5728\\"\\u5979\\u770b\\u89c1\\"\\u5904\\u7a81\\u7136\\u4e2d\\u65ad\\uff0c\\u66f4\\u50cf\\u6587\\u672c\\u7f3a\\u5931\\u800c\\u975e\\u7ecf\\u8fc7\\u8bbe\\u8ba1\\u7684\\u7559\\u767d\\uff1b\\u5efa\\u8bae\\u8865\\u51fa\\u5979\\u6240\\u89c1\\u5bf9\\u8c61\\u7684\\u6700\\u5c0f\\u6709\\u6548\\u4fe1\\u606f\\uff0c\\u4f8b\\u5982\\u5f02\\u5e38\\u52a8\\u4f5c\\u3001\\u964c\\u751f\\u9762\\u5b54\\u6216\\u719f\\u6089\\u4eba\\u7269\\u7684\\u4e0d\\u534f\\u8c03\\u7ec6\\u8282\\uff0c\\u518d\\u4e8e\\u5371\\u9669\\u542b\\u4e49\\u63ed\\u6653\\u524d\\u5207\\u7ae0\\uff0c\\u4f7f\\u60ac\\u5ff5\\u65e2\\u660e\\u786e\\u53c8\\u4e0d\\u6cc4\\u5e95\\u3002", "\\u3010\\u4f0f\\u7b14\\u8854\\u63a5\\u3011\\u672c\\u7ae0\\u8bc6\\u7834\\u501f\\u8138\\u673a\\u5236\\u540e\\u7acb\\u5373\\u8f6c\\u5165\\u6392\\u7ec3\\u5ba4\\uff0c\\u53ef\\u4ee5\\u589e\\u52a0\\u4e00\\u53e5\\u83b1\\u5c14\\u5c06\\"\\u501f\\u8138\\"\\u4e0e\\u739b\\u8482\\u5c14\\u8fbe\\u4eba\\u683c\\u3001\\u52a8\\u4f5c\\u5f02\\u5e38\\u4ea7\\u751f\\u8054\\u60f3\\u7684\\u5185\\u5fc3\\u5224\\u65ad\\uff0c\\u4ece\\u800c\\u66f4\\u81ea\\u7136\\u5730\\u628a\\u6587\\u68ee\\u7279\\u652f\\u7ebf\\u5e76\\u56de\\u9508\\u8537\\u8587\\u4e3b\\u7ebf\\u3002"]	[0]	\N	\N	3000	[]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	completed	0	\N	清晨的雾贴着格雷文赫城北站爬行，铁轨被水汽浸得发亮。蒸汽机车拖着长鸣驶出站台，煤烟压过屋顶，又被海风扯散。\n\n候车厅外，报童冻得直跺脚。搬运工的吆喝、车轮的摩擦声和锅炉泄压的“嗤嗤”声混在一起，吵得人耳根发麻。\n\n莱尔坐在街对面的早餐铺里。\n\n桌上摆着一杯掺水咖啡，两片烤焦的面包。一个戴鸭舌帽的瘦子挤过人群，把牛皮纸袋扔到桌上。\n\n“灰烬酒馆送来的。”\n\n莱尔没碰纸袋。\n\n“多少钱？”\n\n“已经付了。”\n\n“那就很可疑。”\n\n瘦子翻了个白眼，钻进雾里。\n\n纸袋里有三份东西。\n\n地下印坊的旧工名册、木偶剧团的薪酬记录，还有北站的货运雇工单。三张纸都指向同一个人。\n\n文森特·惠特莫尔。\n\n五尺四寸，右嘴角有疤，常穿深灰大衣。替地下印坊搬过铅字，也在巡演木偶团里修过道具。五月二十九日，他受雇押送一批印刷机零件前往北方的瓦伦港。\n\n出城记录、车票存根、沿途驿站签名，一样不少。\n\n六月三日，他已在四百里外。\n\n莱尔喝了口咖啡，立刻放下。\n\n比月季咖啡厅昨天那杯还糟。\n\n他拿起木偶剧团的薪酬表。文森特的名字旁盖着指印，墨色已旧。下面另有一行小字。\n\n擅长人像雕刻，手脚不稳，已辞退。\n\n莱尔用指甲刮了刮纸边。\n\n脸是真的。\n\n人却不在城里。\n\n若文森特没有偷偷回来，那么铜锣巷里的矮个男人，只借用了他的脸。\n\n这是第二层障眼法。\n\n再追文森特，只会被人牵着跑。\n\n莱尔把资料塞回纸袋，起身前看了眼北站大钟。\n\n下午四点，锈蔷薇有排练。\n\n他还有时间换一杯能喝的咖啡。\n\n排练室的窗户全开着。\n\n潮风灌进来，吹得墙上旧海报哗哗作响。屋里有松香、汗水和金属受潮后的铁腥味。音箱接线老化，时不时冒出一声短促的杂音。\n\n塞西莉站在角落调弦。\n\n她看见	722	薄雾从格雷文赫北面的海湾漫上来，越过吊臂林立的蒸汽码头，贴住灰黑屋脊，一路淹到北站。高架铁轨浮在雾中，像几道湿冷的刀背。远处钟楼只剩半截尖顶，煤烟压过城墙，又被海风撕成细碎的黑絮。\n\n站前街挤满赶早车的人。马粪泡在石缝里，煤灰混着廉价香水和隔夜汗味，呛得人喉咙发涩。报童冻得直跺脚，搬运工扛着木箱横穿车流。锅炉泄压，白汽扑上雨棚。\n\n嗤——\n\n街对面的早餐铺里，莱尔用两根手指捏起焦黑面包，轻轻敲了敲桌沿。\n\n梆梆。\n\n很硬。\n\n可以充当凶器。\n\n他把面包放回盘里，转而端起咖啡。杯口浮着一层颜色可疑的油光，闻起来像洗过煤渣的热水。\n\n门帘忽地被撞开。\n\n冷风卷进来，吹动墙上那张“异常物品须主动申报”的旧告示。一个戴鸭舌帽的瘦子挤过食客，把牛皮纸袋扔到桌上。\n\n“灰烬酒馆送来的。”\n\n莱尔没碰纸袋。\n\n“多少钱？”\n\n“付过了。”\n\n“那就很可疑。”\n\n瘦子翻了个白眼。\n\n“酒馆老板说，你再嫌可疑，下回按双份收钱。”\n\n“这就合理多了。”\n\n瘦子没再搭话。他压低帽檐，转身钻进雾里。门帘落下，隔开外头的汽笛声，也夹住一缕尿臊和煤烟味。\n\n莱尔这才抽过纸袋。\n\n封口没有蜡，纸边有新折痕。袋底沾着一点褐色酒渍，闻起来是灰烬酒馆最便宜的黑麦酒。没有被人中途拆看过的迹象。\n\n他解开细绳，将里面的东西一件件铺开。\n\n地下印坊的旧工名册。\n\n圣橡木木偶剧团的薪酬记录。\n\n北站五月份的临时货运雇工单。\n\n三张纸的纸质、油墨和保存状况都不同，却指向同一个名字。\n\n文森特·惠特莫尔。\n\n莱尔用勺柄压住被风掀起的纸角。\n\n五尺四寸。身材瘦小。右嘴角有疤。习惯穿深灰色长大衣。\n\n他替地下印坊搬过铅字，因私拿油墨被辞退。后来又进了木偶剧团，做过一年半的道具修补。五月二十九日，文森特在北站签了短工契，负责押送一批印刷机零件前往北方的瓦伦港。\n\n车票存根钉在雇工单背后。\n\n沿途四座驿站，各有签名。\n\n六月三日清晨，瓦伦港货栈也盖了验收印。那地方离格雷文赫足有四百里。除非文森特会把自己塞进蒸汽管道，否则他不可能在同一天晚上出现在铜锣巷。\n\n莱尔端起咖啡，抿了一口。\n\n苦味先撞上舌根，随后是一股煮焦麻布般的酸气。\n\n他立刻放下。\n\n比月季咖啡厅昨天那杯还糟。\n\n格蕾丝若喝到，大概会先骂豆子，再骂磨豆机，最后把卖豆子的商人也列入终身禁入名单。\n\n莱尔把车票翻到背面。纸张有细小裂纹，骑缝章严丝合缝。若是伪造，成本未免太高，漏洞也未免太少。\n\n他的目光落向木偶剧团的薪酬表。\n\n文森特的名字旁按着拇指印。墨色已经旧了。下面另有一行潦草小字。\n\n“擅长人像雕刻。手脚不稳。已辞退。”\n\n莱尔的指甲在纸边停了一下。\n\n木偶剧团。\n\n人像雕刻。\n\n铜锣巷里，那名跟踪者有一张属于文森特的脸。\n\n脸是真的。\n\n身份也是真的。\n\n唯独人不该在城里。\n\n如果文森特没有偷偷赶回格雷文赫，那晚出现在巷口的矮个男人，便只是借用了他的模样。\n\n至于是戴了面具，改了五官，还是用了某种不惊动凯莉米粒子监测仪的异常物品，暂时不能确定。\n\n但有一件事已经够清楚。\n\n文森特是第二层障眼法。\n\n跟踪者故意留下足够的特征，让调查者能查到这个名字；又提前为这个名字准备了一条完整的离城记录。治安所查到这里，会把案件推回异常管理局。管理局看见监测数据正常，则会再把它踢回来。\n\n一只皮球。\n\n两边都踢得很熟练。\n\n莱尔把资料重新塞进纸袋，视线掠过窗外。北站大钟的分针刚越过十一点。钟下立着一根黄铜外壳的异常粒子监测仪，顶端绿灯平稳闪烁。两个巡检员倚着栏杆抽烟，谁也没看仪表。\n\n继续追文森特，等于顺着别人铺好的路往雾里走。\n\n该换方向了。\n\n他招手叫来店员。\n\n“结账。另外，你们的咖啡豆是从哪儿进的？”\n\n店员警惕地看着他。\n\n“怎么？”\n\n“我想避开那家店。”\n\n店员把账单拍在桌上。\n\n莱尔付了钱，带走纸袋。至于两片面包，他原样留在盘里，算是给早餐铺保留两件防身武器。\n\n下午四点，锈蔷薇乐队有排练。\n\n他还有时间回一趟事务所，换一杯能喝的咖啡。\n\n月季咖啡厅的门一推开，烘烤坚果的暖香便扑了上来。壁炉火不大，铜壶却烧得正响。格蕾丝背对门口擦杯子，银灰色头发挽得一丝不乱。\n\n露西趴在柜台下，听见脚步，只抬了一下眼皮。\n\n莱尔把北站那杯咖啡放到柜台上。\n\n格蕾丝闻了闻。\n\n她的脸色沉了。\n\n“这是什么？”\n\n“证物。”\n\n“拿远点。”\n\n“我以为你会研究它。”\n\n“研究怎么毒死一盆花？”\n\n格蕾丝用抹布捂住杯口，直接把它塞进垃圾桶。随后，她从保温壶里倒出半杯黑咖啡，推到莱尔面前。\n\n莱尔喝了一口。\n\n温热。微苦。没有洗煤水的味道。\n\n世界重新恢复秩序。\n\n“晚饭回来吃？”格蕾丝问。\n\n“不一定。”\n\n她没劝，只把一小包曲奇饼压在牛皮纸袋上。\n\n“那就带着。”\n\n莱尔看了一眼纸包。封口处系着月季咖啡厅惯用的红绳。\n\n“我去查绑架。”\n\n格蕾丝擦杯子的手停了停。\n\n“所以？”\n\n“曲奇可能会沾上证物。”\n\n“那就饿着。”\n\n她伸手要拿回来。\n\n莱尔先一步把纸包塞进口袋，动作很快。\n\n四点前，海风转了向。\n\n锈蔷薇的排练室设在东区一座旧机械工坊二层。楼下还留着废弃锅炉，锈水沿砖墙淌出黄褐色痕迹。楼梯窄而陡，木板吸饱潮气，每踩一步都发出呻吟。\n\n吱呀。\n\n莱尔推开二楼铁门。\n\n松香、汗味和金属受潮后的铁腥气一齐涌来。几扇窗全开着，潮风鼓动墙上的旧演出海报，纸角哗哗作响。地上散着电线，老式音箱的接口闪过蓝色电火花。\n\n啪。\n\n一声短促杂音刺过耳膜。\n\n塞西莉站在窗边调弦。她穿着黑衬衫，袖口挽到手肘。听见开门声，她先抬眼看向莱尔，随即又望向排练室中央。\n\n玛蒂尔达坐在架子鼓后。\n\n鼓槌夹在右手指间。她似乎刚要敲击，却维持着抬臂的姿势，一动不动。\n\n一秒。\n\n两秒。\n\n第三秒，她的手忽然落下。\n\n咚。\n\n鼓点偏了半拍。\n\n塞西莉拧弦钮的动作停住。\n\n她看见了。\n\n莱尔也看见了。\n\n玛蒂尔达抬起脸，目光在他身上停了一瞬。那张脸没有惊慌，也没有被陌生人审视的不悦。只有一种迟来的确认，仿佛有人隔着很远的地方告诉她，此刻应该看向门口。\n\n“侦探先生。”她说。\n\n声音平稳。\n\n尾音却轻得不自然。\n\n“你认识我？”莱尔问。\n\n“塞西莉说过。”\n\n玛蒂尔达放下鼓槌，左手按住膝上的黑色皮包。她的手指很白，指甲修得干净。每根手指落下的角度，都像是提前量过。\n\n塞西莉走过来。\n\n“你查到跟踪者了？”\n\n“查到了名字，没查到人。”\n\n“什么意思？”\n\n“脸属于一个已经离城的人。”莱尔晃了晃纸袋，“有人希望我查到他，也希望我只能查到他。”\n\n塞西莉看了一眼玛蒂尔达，压低声音。\n\n“她今天更慢。”\n\n“听见了。”\n\n“不是鼓。我问她早餐吃了什么，她隔了五秒才回答。”\n\n“答案呢？”\n\n“鸡蛋。”\n\n莱尔偏头看她。\n\n“这很可疑？”\n\n“她讨厌鸡蛋。”\n\n对话到此为止。\n\n玛蒂尔达已经转过脸，正在整理鼓面上的谱纸。窗外海风灌入，她面前一张纸被吹落。纸页擦过她的肩，飘到地上。\n\n她没有伸手。\n\n直到纸页完全落定，玛蒂尔达才弯下腰，将它捡起。\n\n动作不快，也不慢。\n\n只是每一步之间，都有一道极细的停顿。\n\n莱尔走过去，在架子鼓旁蹲下。黄铜支架沾着新鲜指印，鼓凳下有一小片黑色线头。他没有碰，只扫了一眼。\n\n“能让我看看你的包吗？”\n\n玛蒂尔达的手骤然收紧。\n\n皮革发出轻响。\n\n咯吱。\n\n这是她进门后第一个不带迟滞的动作。\n\n“为什么？”她问。\n\n“塞西莉说，你最近常带着它。”\n\n“女人带包，不犯法。”\n\n“我没带手铐。”\n\n玛蒂尔达盯着他。\n\n莱尔神色松散，像真只是对皮包的款式感兴趣。可他看见了她拇指压住的位置——搭扣内侧。那里微微鼓起，像藏着什么不能离手的东西。\n\n塞西莉把吉他靠到墙边。\n\n“让他看。”\n\n玛蒂尔达没有回答。\n\n排练室里只剩海报翻动的哗响。贝斯手和键盘手还没到。经纪人哈里特正在楼下接电话。门半掩着，走廊空荡。\n\n过了几秒，玛蒂尔达松开手。\n\n“别弄坏。”\n\n她把皮包递来。\n\n莱尔没有立即接。\n\n黑色牛皮。铜质搭扣。边角有多年摩擦留下的浅灰痕迹。包带内侧缝着一块褪色红布，针脚粗糙，像是自己补过。塞西莉此前说过，这只包玛蒂尔达用了六年，巡演、排练、喝酒，几乎从不离身。\n\n物件跟随一个人越久，留下的东西越多。\n\n也越乱。\n\n莱尔戴上薄手套，先托住包底，又用拇指按住那块红布。\n\n冰凉从指腹钻进去。\n\n他眼前的排练室晃了一下。\n\n不是幻觉。\n\n更像有无数细碎影像从皮革深处浮起，彼此叠压。舞台灯光。雨夜车窗。打翻的啤酒。鼓槌敲在包面上的闷响。有人大笑。有人骂街。塞西莉将一张皱巴巴的演出票塞进夹层。\n\n太多了。\n\n六年的残留像一锅煮烂的颜料，挤在狭窄的皮革里。莱尔闭了闭眼，控制呼吸，只追索最近几天最鲜明的部分。\n\n六月三日之后。\n\n紧张。\n\n黑暗。\n\n还有疼痛。\n\n他的手指沿着包带缓慢下移。\n\n画面骤然一清。\n\n昏黄路灯在石板路上拉长。皮包随着脚步摇晃。玛蒂尔达走得很快，呼吸声有些重。身后没有脚步，只有车轮碾过积水的声音。\n\n下一瞬，画面猛地倾斜。\n\n一只戴灰手套的手从后方探来。\n\n白布捂住口鼻。\n\n辛辣药味灌进鼻腔。\n\n玛蒂尔达抬肘撞向后方。包身狠狠磕在墙上，铜扣崩开。她想喊，喉咙里却只挤出半声闷哼。\n\n黑暗压下。\n\n莱尔的指尖一颤。\n\n塞西莉立即注意到。\n\n“你看见什么了？”\n\n“别说话。”\n\n莱尔的声音不重。\n\n塞西莉闭上嘴，手指却已经攥紧吉他背带。\n\n皮包的记忆还在继续。\n\n黑暗之后，是颠簸。\n\n粗糙木板硌住包底。空气里有霉草、机油和海水腐败后的腥臭。远处传来汽笛，沉闷，间隔很长。有人拖动铁链。\n\n哗啦。\n\n一盏提灯被点亮。\n\n隔着皮包半开的缝隙，莱尔看见一双被绳索勒出血痕的手。\n\n那双手属于玛蒂尔达。\n\n她被绑在木椅上，嘴里塞着布。额角破了，血已经凝成暗红。她奋力挣动，椅腿在地上刮出刺耳声响。\n\n对面站着一个矮个男人。\n\n深灰大衣。络腮胡。眉骨很深。右嘴角有疤。\n\n文森特·惠特莫尔的脸。\n\n男人身旁吊着一具没有五官的木偶。\n\n木偶与成年女人等高，四肢关节裸露，脖颈垂向一侧。矮个男人拿起刻刀，贴近玛蒂尔达的脸，一寸寸比量。\n\n皮包里的视野再次暗下。\n\n随后是刀刃削过木头的沙沙声。\n\n一下。\n\n一下。\n\n极有耐心。\n\n画面破碎，又重新拼起。\n\n木偶已经有了脸。\n\n玛蒂尔达的脸。\n\n眉毛、鼻梁、嘴角，连左耳下那颗极小的痣都分毫不差。矮个男人替它套上衣服，把黑色细线接入肩、肘、膝后的关节。\n\n细线尽头，连着一只银灰色的金属指套。\n\n指套亮起微弱蓝光。\n\n街角的凯莉米粒子监测仪不会为它报警。那东西没有撕扯现实，只是在驱动一件已经做好的器物。\n\n矮个男人抬起食指。\n\n木偶睁眼。\n\n莱尔猛地松开皮包。\n\n眼前光线一晃。\n\n排练室重新压回视野。音箱还在发出细微电流声，窗帘被海风吹得鼓起。塞西莉站在半步之外，脸色发白。\n\n皮包险些坠地。\n\n一只手接住了它。\n\n玛蒂尔达。\n\n她低头整理搭扣，动作仍旧平稳。只有接包那一下快得惊人，像在某个看不见的指令抵达时，身体便立刻完成了反应。\n\n“看完了吗？”她问。\n\n莱尔望着她的眼睛。\n\n瞳孔会随光线收缩。\n\n胸口也有起伏。\n\n皮肤下甚至能看见淡青色血管。\n\n做得很好。\n\n太好了。\n\n若不是那段残存在皮革里的记忆，没人会怀疑眼前坐着的并非活人。\n\n莱尔站起身，顺手拍掉手套上的灰。\n\n“看完了。”\n\n玛蒂尔达把包重新按在膝上。\n\n“有发现？”\n\n“有。”\n\n莱尔从口袋里取出格蕾丝给的曲奇，拆开红绳，咬了一块。黄油香压住了方才记忆里那股霉草与腐海水的气味。\n\n他咽下去，语气平淡。\n\n“这包该上油了。”\n\n塞西莉看向他。\n\n莱尔没有回视。\n\n门外传来脚步声。经纪人哈里特推门进来，怀里夹着演出日程表，嘴里还在抱怨场地方临时加价。玛蒂尔达转过头，露出一个恰到好处的不耐烦神情。\n\n“先排练。”她说。\n\n众人各自归位。\n\n鼓槌抬起。\n\n咚。咚。咚。\n\n节拍依旧慢了半拍。\n\n莱尔退到窗边，借着低头收资料的动作，在纸袋背面写下一行字。他将纸袋递给塞西莉。\n\n她接过，只看了一眼。\n\n纸面上没有案情，也没有解释。\n\n只有一句话。\n\n别惊动她。真正的玛蒂尔达还活着。\n\n塞西莉的指节一下捏白。\n\n她没有抬头，没有出声。只把纸袋对折，压在那张六天后的演唱会日程表下面。\n\n鼓点再度落下。\n\n咚。\n\n莱尔望向架子鼓后的那张脸。\n\n那东西也在看他。\n\n嘴角缓缓扬起。\n\n慢了半拍。	5113	1	\N	2026-08-07 10:15:51.885336	2026-08-07 02:15:51.883451	2026-08-07 02:18:26.125466
8019196c-eafc-44a0-ae4a-200d36950325	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	\N	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		null	[]	1 莱尔不要直接告知他人自己的能力，可以说是其他渠道得来的。\n2 这章得知人还活着后，应该是先去收集证据，然后才喊官方人员协同。	\N	3000	["pacing", "dialogue"]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	running	0	\N	夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水。\n\n莱尔靠在门边。塞西莉出来得很快，反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。\n\n“你早就知道了。”她说。\n\n“刚知道。”\n\n“她不是玛蒂尔达。”\n\n塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人。\n\n“不是。”莱尔说，“里面那个，不是玛蒂尔达。”\n\n塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了。“那真的玛蒂尔达在哪？”\n\n“肉仓库。”莱尔说，“港口区的旧货仓。我看见她被人绑进去的——至少被带进仓门的时候，人还活着。”\n\n“还活着。”塞西莉把三个字咬得发白。\n\n“活着。”莱尔说，“有呼吸，没有血。”\n\n“谁绑的？”\n\n“一个灰衣服的男人，还有一个披斗篷的女人。”莱尔顿了顿，“操偶师。木头做的假人，刻成玛蒂尔达的脸，放在乐队里当替身。皮包就是证据——包上读到的，不会错。”\n\n塞西莉的指甲一下抠进袖口。\n\n“为什么？”她问。\n\n“还不清楚。”莱尔说，“但那个假货每天来排练，说明对方要它把什么事做完。不惊动它，跟它走，就能回到窝里。”\n\n“你要我怎么做？”\n\n“照常排练。”莱尔说。\n\n塞西莉抬起眼。\n\n“跟它说话，对它笑，该拉琴拉琴。你只要做到今天别让它起疑。它回去，我跟着它。”\n\n“要这样演多久？”\n\n“就今晚。”莱尔说，“等它自己走回去。它到地方，真正的玛蒂尔达就该露面了。”\n\n塞西莉看着他，半晌，慢慢点了一下头。她又回头望了一眼排练室的铁门，里面传出谁在拨吉他的声音。\n\n“哈里特知道吗？”\n\n“别告诉。”莱尔说，“人多藏不住。”\n\n“好。”\n\n塞西莉往回走了两步，又停下。“莱尔。”\n\n“嗯。”\n\n“你看见她的时候，”她说，“她还……有意识吗？”\n\n“眼睛睁着。”莱尔说，“在盯着门口。”\n\n塞西莉没再说话。她拉开门，斜着身子挤进去，门合上，连条缝都没留。\n\n二、排练照常到了九点半。\n\n莱尔挪到街对面的门洞里，背贴着冰凉的砖。雾比入夜时更重，路灯在雾里缩成一团毛边月亮。乐声从排练室里漏出来：鼓声一下下落在砖上，闷，准，像谁拿着尺子量出来的。\n\n十点刚过，门开了。\n\n“玛蒂尔达”背着那个黑皮包出来，站在台阶上，抬手把垂到脸边的头发往后一抹。动作很顺，很轻。然后她下了台阶，一个人朝南走。\n\n莱尔跟了上去。\n\n隔着半条街。雾给了掩护，也把声音全吸走了。他踩在湿淋淋的石板上，每一步都挑相同的响法，不远不近地缀在后面。\n\n跟到第三条巷子，皮靴声从左侧贴了上来。珀西瓦尔从雾里现身，领口的风纪扣反着一点水光。\n\n“人呢？”\n\n“前面。”莱尔压低声音，“就是她。等会儿到了地方，别急着动，先看看有几门几条路。”\n\n珀西瓦尔点了下头。他从口袋里摸出半块硬糖，塞进嘴里，牙关咬得咯嘣一声。莱尔看了他一眼，没说话。\n\n“玛蒂尔达”转过一个弯，步子没有半点犹豫。两条街后，空气里的味道开始变了。湿冷的雾里混进一股咸腥味，还有朽木头泡多了水的酸气。他们到港口区了。\n\n旧仓库成排地蹲在码头旁。有的是砖壳，有的是铁皮顶，靠海的一排被盐汽水啃得斑斑驳驳。“玛蒂尔达”走到最末一间，没回头，伸手一推，门开了。铁门没响。她侧身走进去。\n\n门在身后慢慢合上。\n\n莱尔蹲在一摞生锈的船垫后面，珀西瓦尔在他左侧单膝伏低。两人都不说话。仓库的窗糊着油毡，只透出一点暗黄的边。\n\n“几个？”珀西瓦尔用气声问。\n\n莱尔看了看左右。没有别的门。北墙有一扇铁门，锈得快看不出原来的色。\n\n“就她一个进去的。”莱尔说，“这条是正门。北边有扇铁门，进去以后贴右面拐。”\n\n“你进去过？”\n\n“没进去。”莱尔说，“我要确认里面的排布。”\n\n珀西瓦尔皱眉。\n\n莱尔没解释，转头朝码头边走过去。浪头一下一下拍在石阶上，潮湿咸腥的风里混着铁锈味和旧帆布的霉味。	1631	\N	\N	1	\N	2026-08-16 22:57:00.421774	2026-08-16 14:57:00.416611	\N
02381a26-0164-40f0-a254-d61397e6c093	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	\N	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		null	[]	1 莱尔不要直接告知他人自己的能力，可以说是其他渠道得来的。\n2 这章得知人还活着后，应该是先去收集证据，然后才喊官方人员协同。	\N	3000	["pacing", "dialogue"]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	running	0	\N	夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水。\n\n莱尔靠在门边。塞西莉出来得很快，反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。\n\n“你早就知道了。”她说。\n\n“刚知道。”\n\n“她不是玛蒂尔达。”\n\n塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人。\n\n“不是。”莱尔说，“里面那个，不是玛蒂尔达。”\n\n塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了。“那真的玛蒂尔达在哪？”\n\n“肉仓库。”莱尔说，“港口区的旧货仓。我看见她被人绑进去的——至少被带进仓门的时候，人还活着。”\n\n“还活着。”塞西莉把三个字咬得发白。\n\n“活着。”莱尔说，“有呼吸，没有血。”\n\n“谁绑的？”\n\n“一个灰衣服的男人，还有一个披斗篷的女人。”莱尔顿了顿，“操偶师。木头做的假人，刻成玛蒂尔达的脸，放在乐队里当替身。皮包就是证据——包上读到的，不会错。”\n\n塞西莉的指甲一下抠进袖口。\n\n“为什么？”她问。\n\n“还不清楚。”莱尔说，“但那个假货每天来排练，说明对方要它把什么事做完。不惊动它，跟它走，就能回到窝里。”\n\n“你要我怎么做？”\n\n“照常排练。”莱尔说。\n\n塞西莉抬起眼。\n\n“跟它说话，对它笑，该拉琴拉琴。你只要做到今天别让它起疑。它回去，我跟着它。”\n\n“要这样演多久？”\n\n“就今晚。”莱尔说，“等它自己走回去。它到地方，真正的玛蒂尔达就该露面了。”\n\n塞西莉看着他，半晌，慢慢点了一下头。她又回头望了一眼排练室的铁门，里面传出谁在拨吉他的声音。\n\n“哈里特知道吗？”\n\n“别告诉。”莱尔说，“人多藏不住。”\n\n“好。”\n\n塞西莉往回走了两步，又停下。“莱尔。”\n\n“嗯。”\n\n“你看见她的时候，”她说，“她还……有意识吗？”\n\n“眼睛睁着。”莱尔说，“在盯着门口。”\n\n塞西莉没再说话。她拉开门，斜着身子挤进去，门合上，连条缝都没留。\n\n二、排练照常到了九点半。\n\n莱尔挪到街对面的门洞里，背贴着冰凉的砖。雾比入夜时更重，路灯在雾里缩成一团毛边月亮。乐声从排练室里漏出来：鼓声一下下落在砖上，闷，准，像谁拿着尺子量出来的。\n\n十点刚过，门开了。\n\n“玛蒂尔达”背着那个黑皮包出来，站在台阶上，抬手把垂到脸边的头发往后一抹。动作很顺，很轻。然后她下了台阶，一个人朝南走。\n\n莱尔跟了上去。\n\n隔着半条街。雾给了掩护，也把声音全吸走了。他踩在湿淋淋的石板上，每一步都挑相同的响法，不远不近地缀在后面。\n\n跟到第三条巷子，皮靴声从左侧贴了上来。珀西瓦尔从雾里现身，领口的风纪扣反着一点水光。\n\n“人呢？”\n\n“前面。”莱尔压低声音，“就是她。等会儿到了地方，别急着动，先看看有几门几条路。”\n\n珀西瓦尔点了下头。他从口袋里摸出半块硬糖，塞进嘴里，牙关咬得咯嘣一声。莱尔看了他一眼，没说话。\n\n“玛蒂尔达”转过一个弯，步子没有半点犹豫。两条街后，空气里的味道开始变了。湿冷的雾里混进一股咸腥味，还有朽木头泡多了水的酸气。他们到港口区了。\n\n旧仓库成排地蹲在码头旁。有的是砖壳，有的是铁皮顶，靠海的一排被盐汽水啃得斑斑驳驳。“玛蒂尔达”走到最末一间，没回头，伸手一推，门开了。铁门没响。她侧身走进去。\n\n门在身后慢慢合上。\n\n莱尔蹲在一摞生锈的船垫后面，珀西瓦尔在他左侧单膝伏低。两人都不说话。仓库的窗糊着油毡，只透出一点暗黄的边。\n\n“几个？”珀西瓦尔用气声问。\n\n莱尔看了看左右。没有别的门。北墙有一扇铁门，锈得快看不出原来的色。\n\n“就她一个进去的。”莱尔说，“这条是正门。北边有扇铁门，进去以后贴右面拐。”\n\n“你进去过？”\n\n“没进去。”莱尔说，“我要确认里面的排布。”\n\n珀西瓦尔皱眉。\n\n莱尔没解释，转头朝码头边走过去。浪头一下一下拍在石阶上，潮湿咸腥的风里混着铁锈味和旧帆布的霉味。	1631	\N	\N	1	\N	2026-08-16 22:57:05.288851	2026-08-16 14:57:05.287383	\N
4bb41548-2b57-4ea9-bf5e-67ae8ea0bcd6	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	\N	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		null	[]	1 莱尔不要直接告知他人自己的能力，可以说是其他渠道得来的。\n2 这章得知人还活着后，应该是先去收集证据，然后才喊官方人员协同。	\N	3000	["pacing", "dialogue"]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	running	0	\N	夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水。\n\n莱尔靠在门边。塞西莉出来得很快，反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。\n\n“你早就知道了。”她说。\n\n“刚知道。”\n\n“她不是玛蒂尔达。”\n\n塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人。\n\n“不是。”莱尔说，“里面那个，不是玛蒂尔达。”\n\n塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了。“那真的玛蒂尔达在哪？”\n\n“肉仓库。”莱尔说，“港口区的旧货仓。我看见她被人绑进去的——至少被带进仓门的时候，人还活着。”\n\n“还活着。”塞西莉把三个字咬得发白。\n\n“活着。”莱尔说，“有呼吸，没有血。”\n\n“谁绑的？”\n\n“一个灰衣服的男人，还有一个披斗篷的女人。”莱尔顿了顿，“操偶师。木头做的假人，刻成玛蒂尔达的脸，放在乐队里当替身。皮包就是证据——包上读到的，不会错。”\n\n塞西莉的指甲一下抠进袖口。\n\n“为什么？”她问。\n\n“还不清楚。”莱尔说，“但那个假货每天来排练，说明对方要它把什么事做完。不惊动它，跟它走，就能回到窝里。”\n\n“你要我怎么做？”\n\n“照常排练。”莱尔说。\n\n塞西莉抬起眼。\n\n“跟它说话，对它笑，该拉琴拉琴。你只要做到今天别让它起疑。它回去，我跟着它。”\n\n“要这样演多久？”\n\n“就今晚。”莱尔说，“等它自己走回去。它到地方，真正的玛蒂尔达就该露面了。”\n\n塞西莉看着他，半晌，慢慢点了一下头。她又回头望了一眼排练室的铁门，里面传出谁在拨吉他的声音。\n\n“哈里特知道吗？”\n\n“别告诉。”莱尔说，“人多藏不住。”\n\n“好。”\n\n塞西莉往回走了两步，又停下。“莱尔。”\n\n“嗯。”\n\n“你看见她的时候，”她说，“她还……有意识吗？”\n\n“眼睛睁着。”莱尔说，“在盯着门口。”\n\n塞西莉没再说话。她拉开门，斜着身子挤进去，门合上，连条缝都没留。\n\n二、排练照常到了九点半。\n\n莱尔挪到街对面的门洞里，背贴着冰凉的砖。雾比入夜时更重，路灯在雾里缩成一团毛边月亮。乐声从排练室里漏出来：鼓声一下下落在砖上，闷，准，像谁拿着尺子量出来的。\n\n十点刚过，门开了。\n\n“玛蒂尔达”背着那个黑皮包出来，站在台阶上，抬手把垂到脸边的头发往后一抹。动作很顺，很轻。然后她下了台阶，一个人朝南走。\n\n莱尔跟了上去。\n\n隔着半条街。雾给了掩护，也把声音全吸走了。他踩在湿淋淋的石板上，每一步都挑相同的响法，不远不近地缀在后面。\n\n跟到第三条巷子，皮靴声从左侧贴了上来。珀西瓦尔从雾里现身，领口的风纪扣反着一点水光。\n\n“人呢？”\n\n“前面。”莱尔压低声音，“就是她。等会儿到了地方，别急着动，先看看有几门几条路。”\n\n珀西瓦尔点了下头。他从口袋里摸出半块硬糖，塞进嘴里，牙关咬得咯嘣一声。莱尔看了他一眼，没说话。\n\n“玛蒂尔达”转过一个弯，步子没有半点犹豫。两条街后，空气里的味道开始变了。湿冷的雾里混进一股咸腥味，还有朽木头泡多了水的酸气。他们到港口区了。\n\n旧仓库成排地蹲在码头旁。有的是砖壳，有的是铁皮顶，靠海的一排被盐汽水啃得斑斑驳驳。“玛蒂尔达”走到最末一间，没回头，伸手一推，门开了。铁门没响。她侧身走进去。\n\n门在身后慢慢合上。\n\n莱尔蹲在一摞生锈的船垫后面，珀西瓦尔在他左侧单膝伏低。两人都不说话。仓库的窗糊着油毡，只透出一点暗黄的边。\n\n“几个？”珀西瓦尔用气声问。\n\n莱尔看了看左右。没有别的门。北墙有一扇铁门，锈得快看不出原来的色。\n\n“就她一个进去的。”莱尔说，“这条是正门。北边有扇铁门，进去以后贴右面拐。”\n\n“你进去过？”\n\n“没进去。”莱尔说，“我要确认里面的排布。”\n\n珀西瓦尔皱眉。\n\n莱尔没解释，转头朝码头边走过去。浪头一下一下拍在石阶上，潮湿咸腥的风里混着铁锈味和旧帆布的霉味。	1631	\N	\N	1	\N	2026-08-16 22:58:37.111861	2026-08-16 14:58:37.109843	\N
3d3e60d9-7e19-4474-b85d-4864c66cbd94	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	\N	local_21232f297a57a5a7	7f6d28c4-2a32-46d1-887c-6cf5c4555056		null	[]	1 莱尔不要直接告知他人自己的能力，可以说是其他渠道得来的。\n2 这章得知人还活着后，应该是先去收集证据，然后才喊官方人员协同。	\N	3000	["pacing", "dialogue"]	{"preserve_structure": false, "preserve_dialogues": [], "preserve_plot_points": [], "preserve_character_traits": true}	completed	0	\N	夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水。\n\n莱尔靠在门边。塞西莉出来得很快，反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。\n\n“你早就知道了。”她说。\n\n“刚知道。”\n\n“她不是玛蒂尔达。”\n\n塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人。\n\n“不是。”莱尔说，“里面那个，不是玛蒂尔达。”\n\n塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了。“那真的玛蒂尔达在哪？”\n\n“肉仓库。”莱尔说，“港口区的旧货仓。我看见她被人绑进去的——至少被带进仓门的时候，人还活着。”\n\n“还活着。”塞西莉把三个字咬得发白。\n\n“活着。”莱尔说，“有呼吸，没有血。”\n\n“谁绑的？”\n\n“一个灰衣服的男人，还有一个披斗篷的女人。”莱尔顿了顿，“操偶师。木头做的假人，刻成玛蒂尔达的脸，放在乐队里当替身。皮包就是证据——包上读到的，不会错。”\n\n塞西莉的指甲一下抠进袖口。\n\n“为什么？”她问。\n\n“还不清楚。”莱尔说，“但那个假货每天来排练，说明对方要它把什么事做完。不惊动它，跟它走，就能回到窝里。”\n\n“你要我怎么做？”\n\n“照常排练。”莱尔说。\n\n塞西莉抬起眼。\n\n“跟它说话，对它笑，该拉琴拉琴。你只要做到今天别让它起疑。它回去，我跟着它。”\n\n“要这样演多久？”\n\n“就今晚。”莱尔说，“等它自己走回去。它到地方，真正的玛蒂尔达就该露面了。”\n\n塞西莉看着他，半晌，慢慢点了一下头。她又回头望了一眼排练室的铁门，里面传出谁在拨吉他的声音。\n\n“哈里特知道吗？”\n\n“别告诉。”莱尔说，“人多藏不住。”\n\n“好。”\n\n塞西莉往回走了两步，又停下。“莱尔。”\n\n“嗯。”\n\n“你看见她的时候，”她说，“她还……有意识吗？”\n\n“眼睛睁着。”莱尔说，“在盯着门口。”\n\n塞西莉没再说话。她拉开门，斜着身子挤进去，门合上，连条缝都没留。\n\n二、排练照常到了九点半。\n\n莱尔挪到街对面的门洞里，背贴着冰凉的砖。雾比入夜时更重，路灯在雾里缩成一团毛边月亮。乐声从排练室里漏出来：鼓声一下下落在砖上，闷，准，像谁拿着尺子量出来的。\n\n十点刚过，门开了。\n\n“玛蒂尔达”背着那个黑皮包出来，站在台阶上，抬手把垂到脸边的头发往后一抹。动作很顺，很轻。然后她下了台阶，一个人朝南走。\n\n莱尔跟了上去。\n\n隔着半条街。雾给了掩护，也把声音全吸走了。他踩在湿淋淋的石板上，每一步都挑相同的响法，不远不近地缀在后面。\n\n跟到第三条巷子，皮靴声从左侧贴了上来。珀西瓦尔从雾里现身，领口的风纪扣反着一点水光。\n\n“人呢？”\n\n“前面。”莱尔压低声音，“就是她。等会儿到了地方，别急着动，先看看有几门几条路。”\n\n珀西瓦尔点了下头。他从口袋里摸出半块硬糖，塞进嘴里，牙关咬得咯嘣一声。莱尔看了他一眼，没说话。\n\n“玛蒂尔达”转过一个弯，步子没有半点犹豫。两条街后，空气里的味道开始变了。湿冷的雾里混进一股咸腥味，还有朽木头泡多了水的酸气。他们到港口区了。\n\n旧仓库成排地蹲在码头旁。有的是砖壳，有的是铁皮顶，靠海的一排被盐汽水啃得斑斑驳驳。“玛蒂尔达”走到最末一间，没回头，伸手一推，门开了。铁门没响。她侧身走进去。\n\n门在身后慢慢合上。\n\n莱尔蹲在一摞生锈的船垫后面，珀西瓦尔在他左侧单膝伏低。两人都不说话。仓库的窗糊着油毡，只透出一点暗黄的边。\n\n“几个？”珀西瓦尔用气声问。\n\n莱尔看了看左右。没有别的门。北墙有一扇铁门，锈得快看不出原来的色。\n\n“就她一个进去的。”莱尔说，“这条是正门。北边有扇铁门，进去以后贴右面拐。”\n\n“你进去过？”\n\n“没进去。”莱尔说，“我要确认里面的排布。”\n\n珀西瓦尔皱眉。\n\n莱尔没解释，转头朝码头边走过去。浪头一下一下拍在石阶上，潮湿咸腥的风里混着铁锈味和旧帆布的霉味。	1631	夜色压住格雷文赫的时候，雾从港口方向漫过来。没有风，雾却层层地涨，把街灯的光泡成一团团稀薄的黄。远处钟楼敲了九下，闷响沉进石板路缝里，像水珠渗进土。排练室后门撂在一条窄巷底，墙角堆着空酒箱，铁皮垃圾桶边凝着一汪油亮的水，水里漂着半截烟蒂。\n\n莱尔靠在门边。后颈贴着砖墙，凉意顺脊背往下走。他没点灯，也没抽烟，只有指间一枚硬币在指节上翻来覆去，动作极轻，像怕惊动这雾。\n\n塞西莉出来得很快。反手把铁门虚掩上，没弄出响。她没往巷口看，先看着他。\n\n“你早就知道了。”她说。\n\n“刚知道。”\n\n“她不是玛蒂尔达。”\n\n塞西莉的声音压得很低，低到雾里，尾音被吞得只剩一点气。她没哭，眼睛亮得吓人，像浸了冷水的炭。\n\n“不是。”莱尔说，“里面那个，不是玛蒂尔达。”\n\n塞西莉咬住下唇，别过脸，朝巷口站了一会儿。再转回来的时候，脸上已经平了，像有一只手从额头往下一抹，把什么表情都收走了。\n\n“那真的玛蒂尔达在哪？”\n\n“港口区。”莱尔说，“旧货仓。我看见她被带进去的——进仓门的时候，人还活着。”\n\n“还活着。”塞西莉把三个字咬得发白。\n\n“活着。”莱尔说，“有呼吸，没有血。”\n\n“谁绑的？”\n\n“一个灰衣服的男人，还有一个披斗篷的女人。”莱尔顿了顿。指间的硬币停住。“替身是个木偶，木头做的，刻成玛蒂尔达的脸。消息从别的渠道确认过，我不方便说是谁，但来源不会错。”\n\n塞西莉的指甲一下抠进袖口。她盯着他，像在判断这话能信几分。片刻后，她没追问渠道，只问：“为什么？”\n\n“还不清楚。”莱尔说，“但那个假货每天来排练，说明对方要它把什么事做完。不惊动它，跟它走，就能回到窝里。”\n\n“你要我怎么做？”\n\n“照常排练。”莱尔说。\n\n塞西莉抬起眼。\n\n“跟它说话，对它笑，该拉琴拉琴。你只要做到今天别让它起疑。它回去，我跟着它。”\n\n“要这样演多久？”\n\n“就今晚。”莱尔说，“等它走回去。到了地方，不急着扑——先看住。一门，一路，格局不摸清，冲进去就是给对方送时间跑。”\n\n塞西莉看着他，半晌，慢慢点了一下头。她又回头望了一眼排练室的铁门，里面传出谁在拨吉他的声音，断断续续的，像一根线在雾里抖。\n\n“哈里特知道吗？”\n\n“别告诉。”莱尔说，“人多藏不住。”\n\n“好。”\n\n塞西莉往回走了两步，又停下。\n\n“莱尔。”\n\n“嗯。”\n\n“你看见她的时候，”她说，“她还……有意识吗？”\n\n沉默。雾从两人中间流过。远处滴水声一下一下，像替什么人在数数。\n\n“眼睛睁着。”莱尔说，“在盯着门口。”\n\n塞西莉没再说话。她拉开门，斜着身子挤进去。门合上，连条缝都没留。\n\n莱尔在巷子里又站了几秒，然后转身往南走。今晚不能回家。\n\n排练照常到九点半。\n\n莱尔挪到街对面的门洞里，背贴着冰凉的砖。雾比入夜时更重了，路灯在雾里缩成一团毛边月亮，街面剩下一层潮乎乎的亮。乐声从排练室里漏出来：鼓声一下下落在砖上，闷，准，像谁拿着尺子量出来的，每一响都压在同一个刻痕上。莱尔听着，后颈又凉了半寸。\n\n十点刚过，门开了。\n\n“玛蒂尔达”背着那个黑皮包出来，站在台阶上，抬手把垂到脸边的头发往后一抹。动作很顺，很轻。然后她下了台阶，一个人朝南走。\n\n莱尔跟了上去。\n\n隔着半条街。雾给了掩护，也把声都吸走了。他踩在湿淋淋的石板上，每一步都挑相同的响法，不远不近地缀在后面。前头那个背影走得很稳，不回头，不张望，像脑子里装着一根拉直的线，直直往港口方向拽。\n\n跟到第三条巷子，他停了一步。\n\n不是走错了——是确认一下后路。这条巷两侧墙面生满黑霉，高处有块松动的招牌，在雾里看不清字。没有第二个人。他正要继续走，忽然闻到一股味道。从前方飘来的，很淡，像蜡烛将熄时那股烟，又夹着一丝极细的甜，像木屑和某种香粉混在一起。\n\n莱尔皱了皱眉，脚下没停。\n\n两条街后，空气里的味道变了。湿冷的雾里混进咸腥味，还有朽木头泡多了海水的酸气。他们到港口区了。\n\n旧仓库成排地蹲在码头旁。有的是砖壳，有的是铁皮顶，靠海的一排被盐汽水啃得斑斑驳驳，像一排烂牙。“玛蒂尔达”走到最末一间，没回头，伸手一推，门开了。铁门没响。她侧身走进去。\n\n门在身后慢慢合上。\n\n莱尔蹲在一摞生锈的船垫后面。没立刻动。他在心里记数：正门一扇，北墙还有一扇铁门，锈得快看不出原来的色。窗户糊着油毡，只透出一点暗黄的边，连人影都照不出来。门前没有灯。周边仓库全是黑的，没有人声，只有浪头一下一下拍在码头石阶上。\n\n他从怀里摸出个巴掌大的小本，借着雾里那点稀薄的路灯光，用铅笔在上面画了几笔。线条很轻，画完就把本子塞回内袋。\n\n然后他绕到仓库背面。\n\n北墙的铁门比正门更旧，门轴泡在带盐味的水气里，锈成暗红色。莱尔没碰。他弯下腰，借着一块突起的墙砖作掩护，耳朵离墙两寸，听。起初只有远远的水声，渐渐地，里面传出脚步声。很轻，不急。头顶的楼板上有人走动，踩过一块松动的木板，吱呀一声被一支很低的笛声盖过去。\n\n不对。不是笛声。像哨子，很短，嘟一下停了。\n\n莱尔心里有数了，但还不够报案。他退开几步，抬头看这栋仓库。要到北墙边有一扇小窗，离地两米多，用木板封了一半，剩一条窄口。他从旁边拖来一只空鱼筐，倒扣在地上，踩上去。脚尖刚好够到窗沿。透过那条窄口，只看见里面的横梁，和一小片透了光的楼板。别的，什么也没有。\n\n他跳下来，脚后跟先着地，声控住了。\n\n再绕回正门方向时，他听见那扇门开了。他闪到船垫后面。出来的不是“玛蒂尔达”——是两个男人。一个是灰衣服，另一个穿深色罩袍，袖口油光光。门开了一条缝，灯从里面漏出一角，照见灰衣男人脚边落着几片细碎的木屑。\n\n“明早的走位改了。”灰衣男人低声说，嗓音像隔着砂纸。\n\n“还改？”另一个发出短促的笑，“再改它记不住词，台上露怯怎么办。”\n\n“不会忘。”灰衣男人说，“刻进去的东西，能忘吗。”他咳嗽了一声，朝雾里吐了口唾沫，转身回了仓库。门又合上。\n\n莱尔看得很清楚，那灰衣男人转身时，嘴角边有道疤斜到下巴。\n\n现在够了：有现场、有人证、有两名嫌疑人、有被绑人最后出现在该处的明确线索。他不能自己冲进去。珀西瓦尔有正式身份，报案需要能签字的人到场。\n\n莱尔后撤一条街，从口袋里摸出通讯器，拨到官方的频段。\n\n“珀西瓦尔。”他说得很快，“还在局里没走？”\n\n对方顿了一下。“刚整理完铜锣巷的存档。怎么？”\n\n“我想报个案。港口西区最末一间旧货仓，你们的人感兴趣。非法拘禁，就在一个钟头前我看见了。”\n\n“你确定？”珀西瓦尔的声音细下去，又粗起来，“按规程我得先登记——你怎么会在那儿？”\n\n“定位我发给你。带上现场记录组的人，若有必要，叫上能动的。”莱尔顿了顿，“我不想在通讯里说太多。”\n\n“……十分钟到。”珀西瓦尔说，“你别动现场。”\n\n通讯断了。莱尔退回船垫边，半蹲在阴影里，把本子上的那页图撕下来，折成一个薄方块，捏在手里。雾还在涨，港口方向传来汽笛一声，像从很深的水底翻上来。	2820	1	\N	2026-08-16 23:01:07.352832	2026-08-16 15:01:07.348873	2026-08-16 15:02:50.614034
\.


--
-- Data for Name: relationship_types; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.relationship_types (id, name, category, reverse_name, intimacy_range, icon, description, created_at) FROM stdin;
1	父亲	family	子女	high	👨	父子/父女关系	2026-08-04 11:23:55.959584
2	母亲	family	子女	high	👩	母子/母女关系	2026-08-04 11:23:55.959584
3	兄弟	family	兄弟	high	👬	兄弟关系	2026-08-04 11:23:55.959584
4	姐妹	family	姐妹	high	👭	姐妹关系	2026-08-04 11:23:55.959584
5	子女	family	父母	high	👶	子女关系	2026-08-04 11:23:55.959584
6	配偶	family	配偶	high	💑	夫妻关系	2026-08-04 11:23:55.959584
7	恋人	family	恋人	high	💕	恋爱关系	2026-08-04 11:23:55.959584
8	师父	social	徒弟	high	🎓	师徒关系（师父视角）	2026-08-04 11:23:55.959584
9	徒弟	social	师父	high	📚	师徒关系（徒弟视角）	2026-08-04 11:23:55.959584
10	朋友	social	朋友	medium	🤝	朋友关系	2026-08-04 11:23:55.959584
11	同学	social	同学	medium	🎒	同学关系	2026-08-04 11:23:55.959584
12	邻居	social	邻居	low	🏘️	邻居关系	2026-08-04 11:23:55.959584
13	知己	social	知己	high	💙	知心好友	2026-08-04 11:23:55.959584
14	上司	professional	下属	low	👔	上下级关系（上司视角）	2026-08-04 11:23:55.959584
15	下属	professional	上司	low	💼	上下级关系（下属视角）	2026-08-04 11:23:55.959584
16	同事	professional	同事	medium	🤵	同事关系	2026-08-04 11:23:55.959584
17	合作伙伴	professional	合作伙伴	medium	🤜🤛	合作关系	2026-08-04 11:23:55.959584
18	敌人	hostile	敌人	low	⚔️	敌对关系	2026-08-04 11:23:55.959584
19	仇人	hostile	仇人	low	💢	仇恨关系	2026-08-04 11:23:55.959584
20	竞争对手	hostile	竞争对手	low	🎯	竞争关系	2026-08-04 11:23:55.959584
21	宿敌	hostile	宿敌	low	⚡	宿命之敌	2026-08-04 11:23:55.959584
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.settings (id, user_id, api_provider, api_key, api_base_url, llm_model, temperature, max_tokens, preferences, created_at, updated_at, system_prompt, cover_api_provider, cover_api_key, cover_api_base_url, cover_image_model, cover_enabled, smtp_provider, smtp_host, smtp_port, smtp_username, smtp_password, smtp_use_tls, smtp_use_ssl, smtp_from_email, smtp_from_name, email_auth_enabled, email_register_enabled, verification_code_ttl_minutes, verification_resend_interval_seconds) FROM stdin;
46d379ef-7afe-4e80-a96a-e3df26a8df91	local_21232f297a57a5a7	openai	ak_25Q0TZ32Z7Rl7ia7vZ3uo33B8eh2T	https://api.longcat.chat/openai	LongCat-2.0	0.7	128000	{"api_presets": {"presets": [], "version": "1.0"}}	2026-08-04 11:42:54.856279	2026-09-19 21:34:33.78728	\N	\N	\N	\N	\N	f	qq	\N	465	\N	\N	f	t	\N	MuMuAINovel	t	t	10	60
\.


--
-- Data for Name: story_memories; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.story_memories (id, project_id, chapter_id, memory_type, title, content, full_context, related_characters, related_locations, tags, importance_score, story_timeline, chapter_position, text_length, is_foreshadow, foreshadow_resolved_at, foreshadow_strength, vector_id, embedding_model, created_at, updated_at) FROM stdin;
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	chapter_summary	第1章《藏在阳光里的秘密》摘要	莱尔在孤儿院后院主持捉迷藏，并凭借痕迹观察连续找出六名孩子，完成主角高观察力、好胜与顽皮性格的集中亮相。；最后一名诺亚没有留下明显踪迹，普通推理暂时失效，莱尔把注意力转向诺亚早晨接触过的木马。；莱尔触碰木马，看见诺亚此前将木马放回并钻进柳条筐的完整片段，首次明确展现触物读取过去的能力。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u85cf\\u5728\\u9633\\u5149\\u91cc\\u7684\\u79d8\\u5bc6"]	0.6	1	0	143	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	hook	认知 - 开头	[认知钩子] 莱尔通过鞋印、墙灰、咳嗽和糖纸等微小痕迹连续找出藏匿者，迅速建立其超常观察力与推理能力，让普通捉迷藏具备侦探解谜的阅读趣味。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u5f00\\u5934"]	0.7	1	491	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	hook	悬念 - 中段	[悬念钩子] 莱尔接触木马后，视野突然切换到物品曾经见证的场景，揭示他拥有读取物品残留记忆的异常能力，也引出能力来源、边界与代价等核心谜团。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	hook	冲突 - 结尾	[冲突钩子] 玛丽修女指出外界会恐惧、抓捕乃至拆解异常之物，将儿童游戏中的小秘密骤然提升为莱尔可能遭受社会迫害的生存危机。	\N	[]	[]	["\\u51b2\\u7a81", "\\u7ed3\\u5c3e"]	0.9	1	2681	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	hook	情感 - 结尾	[情感钩子] 玛丽修女明确承担替莱尔保守秘密的责任，呈现两人近似母子的深厚信任，也让她成为莱尔安全感和秘密防线的核心。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.8	1	2853	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	hook	悬念 - 结尾	[悬念钩子] 结尾没有解释莱尔能力的来源，只留下受损木马和被隐藏的裂纹，暗示能力秘密并未真正消失，未来仍可能因物证或再次使用而暴露。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.8	1	3051	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_hook_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	hook	情感 - 结尾	[情感钩子] 玛丽修女沐浴在阳光中的袖口被描写得异常刺眼，温暖日常里渗入轻微不祥感，使保护者形象与潜在危机并置。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.7	1	3026	18	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	foreshadow	埋下伏笔	莱尔触碰木马后，以接近木马视角的低位画面看见诺亚先前的行动，明确埋下其能够读取物品残留记忆或过去影像的能力设定。后续可用于追查事件、发现隐藏真相，同时也会成为他被关注和追捕的根源。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	1	1	1620	11	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	foreshadow	埋下伏笔	能力结束后，原本被莱尔按住的木马耳朵出现裂纹并掉落漆片，玛丽修女也确认昨天尚无裂口。这暗示能力可能对读取对象产生物理损耗，未来可能留下可追查的证据，甚至存在更严重的使用代价。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	1	1754	11	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_foreshadow_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	foreshadow	埋下伏笔	莱尔没有直接掀开柳条筐，而是临时编造果酱手印、草屑和筐盖偏移等证据链，将超能力所得包装成观察推理。这种隐瞒手法既体现他的机敏，也预示他未来会继续用理性分析和谎言遮掩异常能力。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	1	2010	10	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_foreshadow_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	foreshadow	埋下伏笔	玛丽修女不仅知道莱尔的能力，还主动承担替他保密和约束他的责任。她实际上是莱尔与危险外界之间的保护屏障；一旦她无法继续履行这一职责，莱尔的秘密、心理安全和生存环境都会迅速恶化。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.9	1	2853	8	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_foreshadow_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	foreshadow	埋下伏笔	结尾特写没有停留在莱尔身上，而是落在玛丽修女被阳光照得刺眼的白色袖口上。温暖意象中的异常刺目感制造轻微死亡或离别预兆，暗示这位保护者的安稳状态可能很快被打破。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.7	1	3038	6	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	plot_point	情节点 - transition	莱尔在孤儿院后院主持捉迷藏，并凭借痕迹观察连续找出六名孩子，完成主角高观察力、好胜与顽皮性格的集中亮相。。影响: 以轻松游戏自然完成世界环境、群像关系和主角能力表层的展示，为真正的超自然揭示制造对照。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.72	1	350	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_plot_point_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	plot_point	情节点 - conflict	最后一名诺亚没有留下明显踪迹，普通推理暂时失效，莱尔把注意力转向诺亚早晨接触过的木马。。影响: 制造游戏层面的短暂困局，并为莱尔从常规观察转向异常能力提供合理触发点。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.78	1	1498	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_plot_point_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	plot_point	情节点 - revelation	莱尔触碰木马，看见诺亚此前将木马放回并钻进柳条筐的完整片段，首次明确展现触物读取过去的能力。。影响: 确立故事核心超自然设定，改变读者对莱尔此前"聪明"的理解，并开启能力来源、规则和代价等主线悬念。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	1	1	1667	18	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_plot_point_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	plot_point	情节点 - resolution	莱尔编造果酱印与草屑线索，把能力所得伪装成推理结果，顺利找到诺亚并赢下游戏。。影响: 解决章节表层任务，同时展示莱尔强大的临场编造能力、保密意识和爱出风头的性格矛盾。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.86	1	1993	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_plot_point_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	plot_point	情节点 - revelation	玛丽修女通过木马裂纹识破莱尔使用能力，警告外界会恐惧、抓捕并研究未知之物，随后承诺替他守住秘密。。影响: 将轻松游戏升级为长期生存危机，确立玛丽修女的保护者地位，并为能力暴露、社会迫害和保护关系破裂埋下主线动力。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.98	1	2816	20	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 自信、好胜，享受凭观察力压过同伴的成就感 → 短暂意识到能力暴露的危险，但仍以玩笑和狡辩掩饰内心压力。莱尔从完全沉浸于游戏和炫耀聪明，转为面对能力可能招致抓捕与伤害的现实。他表面回答"假的"并继续嬉笑，实际已经听懂玛丽修女的警告，最终主动把裂纹木马藏到杂物车底部，说明风险意识已经开始转化为行动。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	玛丽修女的变化	玛丽修女的状态变化: 温柔旁观孩子们游戏，对莱尔保持关注和包容 → 明确表现出对莱尔能力暴露的忧虑，并主动承担守密与引导责任。她从日常照料者自然转入秘密保护者身份。面对莱尔作弊和损坏木马，她没有惩罚或逼问，而是用自身童年经验降低莱尔的防御，再清楚说明外界风险，体现温柔、理性与潜在的沉重忧虑。	\N	["\\u739b\\u4e3d\\u4fee\\u5973"]	[]	["\\u89d2\\u8272", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	托比的变化	托比的状态变化: 积极参与游戏，相信自己能够藏好并逃过莱尔搜索 → 因最先暴露而不服气，继而期待莱尔失败，最终接受全员落败。托比的情绪从自信转为嘴硬和幸灾乐祸，但整体保持儿童式竞争心，没有升级为真正敌意。	\N	["\\u6258\\u6bd4"]	[]	["\\u89d2\\u8272", "\\u6258\\u6bd4", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	艾拉的变化	艾拉的状态变化: 调皮、自信，利用假鞋误导莱尔并违规爬上钟楼平台 → 被莱尔识破后认输，并因玛丽修女的提醒而心虚躲避。从为计策成功而偷笑转为被抓后的不甘与心虚，突出她活泼、敢冒险但畏惧正式管教的一面。	\N	["\\u827e\\u62c9"]	[]	["\\u89d2\\u8272", "\\u827e\\u62c9", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_22	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	马丁的变化	马丁的状态变化: 感冒未愈仍参与游戏，努力藏在旧鸡舍中 → 因无法压住咳嗽而被找到，加入落败者队伍。章节未呈现显著成长，主要通过带病参与游戏体现其融入集体的愿望。	\N	["\\u9a6c\\u4e01"]	[]	["\\u89d2\\u8272", "\\u9a6c\\u4e01", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_23	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	珍妮的变化	珍妮的状态变化: 试图借水缸遮挡身体完成藏匿 → 因红辫子露出而被莱尔发现。没有明显心理转折，承担展示莱尔观察力以及丰富孤儿院群像的功能。	\N	["\\u73cd\\u59ae"]	[]	["\\u89d2\\u8272", "\\u73cd\\u59ae", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_24	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	克劳·沃尔特的变化	克劳·沃尔特的状态变化: 一边藏匿一边偷吃糖，自以为没有留下糖纸证据 → 发现糖在口袋中融化后懊恼，并对被玛丽修女单独留下的莱尔表示同情。从侥幸和贪嘴转为尴尬，再以默契眼神参与同伴间的情感互动，表现出活泼且与莱尔熟悉的一面。	\N	["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"]	[]	["\\u89d2\\u8272", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_character_event_25	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	character_event	诺亚的变化	诺亚的状态变化: 胆小但希望藏到最后，鼓起勇气钻入装有毛毯的柳条筐 → 被发现后羞窘，同时对莱尔无所不知的表现感到惊讶。诺亚虽然胆小，却成功选择了超出莱尔常规推理范围的藏身处，体现出有限但真实的勇气和机灵；被发现后仍维持对莱尔的信服。	\N	["\\u8bfa\\u4e9a"]	[]	["\\u89d2\\u8272", "\\u8bfa\\u4e9a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
c3344d91-7358-4174-b3e1-b4bdc79d4c2e_plot_point_26	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c3344d91-7358-4174-b3e1-b4bdc79d4c2e	plot_point	冲突 - 强度7	重要冲突: 表层冲突是轻松的捉迷藏竞争，以及玛丽修女对莱尔作弊行为的教育；深层冲突则是莱尔渴望证明自己聪明，却必须隐藏真正能力。玛丽修女所描述的外界反应进一步把个人秘密扩展为异常者与社会秩序之间的长期生存矛盾。。冲突各方: 莱尔·西奥多—希望获胜、展示聪明并享受同伴崇拜, 托比等孩子—希望躲藏成功并避免承担剥豌豆的惩罚, 玛丽修女—要求莱尔克制能力、保护秘密与自身安全, 莱尔·西奥多的炫耀欲—与隐藏能力的生存理性相冲突, 异常能力拥有者—与恐惧并试图控制未知事物的外界社会存在潜在冲突	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	0.7	1	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:35:21.595335	2026-08-06 15:35:21.595335
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	chapter_summary	第2章《归途之前》摘要	玛丽修女安排莱尔与克劳前往城东采购，以平静而具生活气息的孤儿院日常建立情感基线。；克劳透露三名自称异常管理局的灰衣访客曾到孤儿院调查异常能力者。；莱尔通过调查流程判断访客并非正常登记人员，而是在寻找可供利用的异常能力者。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u5f52\\u9014\\u4e4b\\u524d"]	0.6	2	0	110	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	hook	悬念 - 中段	[悬念钩子] 自称异常管理局的灰衣访客没有按正规流程核对身份，而是直接询问异常能力，真实身份和来意成谜。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	2	904	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	hook	认知 - 中段	[认知钩子] 莱尔根据访客的询问顺序判断对方并非正常登记人员，而是在筛选具有利用价值的异常者，将官方调查颠覆为人口猎取。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.9	2	1360	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	hook	情感 - 中段	[情感钩子] 一向沉默强硬的克劳主动坦白能力与恐惧，并以"以为只有我是这样"暴露长期的孤独感，增强读者对角色的共情。	\N	[]	[]	["\\u60c5\\u611f", "\\u4e2d\\u6bb5"]	0.8	2	2096	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	hook	冲突 - 中段	[冲突钩子] 莱尔明知自己同样拥有异常能力，却在信任克劳与遵守玛丽修女保密告诫之间选择继续隐瞒，形成同伴关系中的信息不对称。	\N	[]	[]	["\\u51b2\\u7a81", "\\u4e2d\\u6bb5"]	0.8	2	2210	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	hook	悬念 - 结尾	[悬念钩子] 返程后的孤儿院异常寂静，大门虚掩、门闩断裂，暗示灰衣访客或其他敌人已经入侵，以突发危机形成强烈章末悬念。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	1	2	2864	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	foreshadow	回收伏笔	莱尔回想木马裂开时残留在指腹上的触感，并明确意识到灰衣访客寻找的对象包括自己，使第1章中触碰木马后读取过去影像的异常体验进入他的主动认知。此次回收主要确认该现象属于莱尔必须隐藏的能力，但其侦查用途尚未在本章完整展开。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	2	2182	14	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	foreshadow	回收伏笔	木马"裂开"的触感再次被莱尔回忆，并与其异常身份联系起来，确认第1章木马受损并非普通意外，而是能力发动伴随的物品损伤现象。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.6	2	2182	14	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	foreshadow	回收伏笔	克劳坦白后，莱尔仍遵循玛丽修女关于秘密不可交给第二个人的告诫，没有承认自己的能力；同时玛丽修女对访客撒谎并烧毁地址，进一步坐实她是莱尔秘密的唯一知情者和保护者。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	2	2232	19	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_foreshadow_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	foreshadow	回收伏笔	灰衣访客优先询问能力而非身份资料，令莱尔判断他们是在"挑货"；克劳也明确感到对方不是来帮助异常者的，回收了外界势力会搜寻、控制乃至利用异常能力者的威胁。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.9	2	1360	13	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_foreshadow_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	foreshadow	埋下伏笔	克劳能借助刀、剪刀、斧头等切割工具斩断正常情况下无法切开的物体，但能力会在其手腕上造成对应割伤。该设定既赋予他强大战斗和破障能力，也预埋了使用越强、反噬越重的代价。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.9	2	2001	18	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_foreshadow_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	foreshadow	埋下伏笔	烟囱停火、院内失去日常声响、大门虚掩且门闩断裂，共同表明孤儿院在两人离开期间遭遇暴力入侵。孩子们与玛丽修女的处境将成为下一章最直接的危机。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	1	2	2854	9	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_plot_point_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	plot_point	情节点 - transition	玛丽修女安排莱尔与克劳前往城东采购，以平静而具生活气息的孤儿院日常建立情感基线。。影响: 让两名主要角色离开孤儿院，为访客情报的私下交流和章末袭击现场创造条件，同时通过家庭感放大后续危机的情绪冲击。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.65	2	388	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_plot_point_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	plot_point	情节点 - revelation	克劳透露三名自称异常管理局的灰衣访客曾到孤儿院调查异常能力者。。影响: 将故事威胁从莱尔个人秘密扩展为有组织的异常者搜捕，并为孤儿院遭袭建立直接嫌疑对象。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.9	2	904	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_plot_point_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	plot_point	情节点 - revelation	莱尔通过调查流程判断访客并非正常登记人员，而是在寻找可供利用的异常能力者。。影响: 体现主角的逻辑判断力，明确外部势力的掠夺性，并将世界观中的制度威胁具象化。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.88	2	1324	17	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_plot_point_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	plot_point	情节点 - revelation	克劳向莱尔坦白自己的超常切割能力以及能力在身体上造成割伤的反噬。。影响: 完成克劳的核心能力揭示，深化两人信任关系，并形成莱尔是否对等坦白自身能力的内在冲突。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.95	2	1990	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_plot_point_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	plot_point	情节点 - conflict	两人返回后发现孤儿院失去生活声响，大门虚掩且门闩断裂。。影响: 将潜伏威胁立即升级为现实袭击，终止短暂日常，迫使主角进入调查、救援或追击阶段，并形成强力续章驱动。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	1	2	2890	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_character_event_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 从容机敏，以玩笑和精打细算应对平静日常 → 高度警觉，意识到针对异常者的威胁已经波及孤儿院。他先以惯常的幽默化解克劳的紧张，随后通过访客的询问顺序迅速判断对方并非正规登记人员。面对克劳的坦白，他产生承认自身能力的冲动，却最终选择遵守玛丽修女的保密原则。章末发现孤儿院异常后，他的冷静观察瞬间转化为强烈危机感，送货篮脱手显示其情绪首次明显失控。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_character_event_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	character_event	克劳·沃尔特的变化	克劳·沃尔特的状态变化: 沉默焦虑，因灰衣访客的出现而担忧自身异常被发现 → 完成首次主动坦白，与莱尔建立更深信任，但随即进入应对孤儿院危机的警戒状态。克劳从捏碎面包、指节发白等压抑性动作开始，逐步说出访客情报、能力表现和身体反噬。他承认自己曾以为是唯一的异类，暴露出长期孤立感。莱尔的玩笑没有否定他，反而暂时缓解了其自我怪物化倾向，使他能够短暂发笑。	\N	["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"]	[]	["\\u89d2\\u8272", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_character_event_22	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	character_event	玛丽修女的变化	玛丽修女的状态变化: 温和务实地照料孤儿院日常生活 → 其隐藏的警惕性与保护者身份被揭示，当前处境因孤儿院遭到入侵而成谜。本章未直接展示她在访客到来时的内心变化，但通过克劳转述可见，她面对可疑人员时保持镇定，主动隐瞒孩子们的异常，并烧毁对方留下的地址，表现出明确的风险判断和保护意志。	\N	["\\u739b\\u4e3d\\u4fee\\u5973"]	[]	["\\u89d2\\u8272", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_character_event_23	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	character_event	托比的变化	托比的状态变化: 活泼贪吃，处于孤儿院轻松日常之中 → 未在返程后的院内出现，安危暂时不明但尚无明确失踪依据。本章未展开显著心理变化，其早餐时偷拿蜂蜜的行为承担日常氛围和家庭感塑造，并使结尾的寂静更具反差。	\N	["\\u6258\\u6bd4"]	[]	["\\u89d2\\u8272", "\\u6258\\u6bd4", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_character_event_24	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	character_event	诺亚的变化	诺亚的状态变化: 受到孤儿院成员照料的年幼孩子 → 未在结尾出现，安危成为孤儿院整体悬念的一部分。没有直接心理描写，其存在主要通过专门保留蜂蜜和莱尔此前带他看牙医的细节，强化孤儿院成员之间的照料关系。	\N	["\\u8bfa\\u4e9a"]	[]	["\\u89d2\\u8272", "\\u8bfa\\u4e9a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_character_event_25	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	character_event	艾拉的变化	艾拉的状态变化: 活跃好动，是孤儿院日常秩序的一部分 → 未在异常寂静的孤儿院中出现，安危暂时不明但无明确失踪结论。没有直接心理描写。莱尔对她平日爬窗台行为的回忆成为判断孤儿院过分安静的重要参照。	\N	["\\u827e\\u62c9"]	[]	["\\u89d2\\u8272", "\\u827e\\u62c9", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
8c8b4ea2-99f7-4108-8585-0ebc9529f0bb_plot_point_26	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8c8b4ea2-99f7-4108-8585-0ebc9529f0bb	plot_point	冲突 - 强度9	重要冲突: 表层冲突是灰衣访客对孤儿院的调查及疑似入侵，深层冲突则是异常能力者与外部权力体系之间的生存对抗。与此同时，克劳选择坦白，莱尔却因玛丽修女的告诫继续隐瞒自身能力，使两人的亲密关系中出现暂时的信息不对称。章末破门现场意味着潜在威胁已经从口头调查升级为直接暴力。。冲突各方: 莱尔·西奥多与克劳·沃尔特—保护彼此及晨星孤儿院, 灰衣访客—搜寻并疑似控制具有异常能力的人, 莱尔·西奥多—在信任克劳与继续保守秘密之间挣扎, 异常能力者—面对外部机构的筛选、恐惧和利用	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	0.9	2	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:40:29.862482	2026-08-06 15:40:29.862482
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	chapter_summary	第3章《熄灭的晨星》摘要	莱尔与克劳进入孤儿院，确认此前的异常来自一场已经结束的集体屠杀。；莱尔通过鞋印、血迹和翻动物品判断凶手至少三人，且袭击目的不是普通劫掠。；宿舍中少了一名孩子，莱尔确认失踪者是萨姆。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u7184\\u706d\\u7684\\u6668\\u661f"]	0.6	3	0	90	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	悬念 - 开头	[悬念钩子] 开篇直接以无人回应、断裂门闩和扑面而来的血腥味确认孤儿院遭遇重大变故，迅速把上一章的危机预兆转化为凶案现场。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u5f00\\u5934"]	1	3	77	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	情感 - 开头	[情感钩子] 托比、诺亚与孤儿院孩子相继被发现遇害，木马断裂、伸向斧头的手等细节将集体死亡落到具体个体身上，制造强烈悲恸。	\N	[]	[]	["\\u60c5\\u611f", "\\u5f00\\u5934"]	1	3	456	6	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	悬念 - 中段	[悬念钩子] 宿舍床位与尸体数量不符，萨姆成为唯一确认失踪者，其究竟逃生、被绑架还是与袭击目标有关，构成全章最核心的后续悬念。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	1	3	1004	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	认知 - 中段	[认知钩子] 袭击者没有搜刮食物和普通财物，却翻遍房间并扒开壁炉灰烬，表明这不是随机劫杀，而是针对特定人物或秘密的有计划行动。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.9	3	689	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	冲突 - 中段	[冲突钩子] 克劳因萨姆可能被带走而坚持独自追车，莱尔则强行阻止，复仇冲动与理性救援方案正面碰撞。	\N	[]	[]	["\\u51b2\\u7a81", "\\u4e2d\\u6bb5"]	0.9	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	悬念 - 结尾	[悬念钩子] 报案后两人没有获得自由行动权，反而同时被保护和拘留，预示官方调查可能把幸存者也列为嫌疑对象。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.8	3	2721	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_hook_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	hook	情感 - 结尾	[情感钩子] 结尾以完整无缺的采购清单对照已被毁灭的日常生活，强调两人只是短暂离开，却再也无法把药品和食物带给等待他们的人。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.9	3	2854	18	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	foreshadow	回收伏笔	上一章中烟囱停火、院内无声、大门虚掩及门闩断裂所预示的暴力入侵得到完整回收。本章确认孤儿院遭三人以上袭击，玛丽修女、托比及多名孩子遇害，萨姆失踪，危机由预兆正式转化为主线惨案。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	1	3	41	9	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_foreshadow_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	foreshadow	回收伏笔	玛丽烧毁地址的举动得到阶段性回收：袭击者不仅翻查会客室，还精准扒开壁炉灰烬，证明外部势力知道地址曾经存在。烧毁行为的保护意义得到确认，但地址内容及消息泄露来源仍将延伸为后续谜团。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.9	3	-1	0	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_foreshadow_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	foreshadow	埋下伏笔	克劳只从玛丽散落的缝衣针中捡起一枚，并在结尾贴身收藏。这一动作将普通生活物件转化为哀悼、誓言和复仇动机的载体，后续可能作为克劳保持理智或确认目标的情感锚点。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.7	3	2808	12	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_foreshadow_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	foreshadow	埋下伏笔	治安官同时以保护和拘留的名义限制两名幸存者行动，意味着莱尔与克劳将接受审查。两人的异常能力、案发前离院经历及对现场过于精准的判断，都可能在调查中形成风险。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	3	2696	13	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_plot_point_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	plot_point	情节点 - revelation	莱尔与克劳进入孤儿院，确认此前的异常来自一场已经结束的集体屠杀。。影响: 彻底摧毁主角原有生活支点，将故事从日常异常调查推入谋杀案与复仇追查主线。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	1	3	351	7	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_plot_point_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	plot_point	情节点 - revelation	莱尔通过鞋印、血迹和翻动物品判断凶手至少三人，且袭击目的不是普通劫掠。。影响: 建立案件的基础推理框架，说明屠杀具有组织性和明确目标，并为后续追踪留下物证。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.9	3	618	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_plot_point_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	plot_point	情节点 - revelation	宿舍中少了一名孩子，莱尔确认失踪者是萨姆。。影响: 在全灭式惨案中保留营救目标与生存希望，同时让凶手的撤离路线和真实目的更具紧迫性。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	1	3	1042	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_plot_point_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	plot_point	情节点 - revelation	玛丽修女被发现死于礼拜室，烧毁地址的壁炉也被人翻查，进一步指向秘密泄露和定向袭击。。影响: 完成情感高潮并把玛丽此前隐藏的信息与本次惨案直接连接，使案件上升为针对孤儿院秘密的清洗行动。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	1	3	1389	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_plot_point_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	plot_point	情节点 - transition	莱尔阻止克劳独自追击，二人报案后被治安官同时保护和拘留。。影响: 避免角色因冲动立即进入不合理追逐，将叙事自然转向官方调查、嫌疑审查和封城追踪阶段。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.9	3	2684	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_22	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 带着不祥预感返回孤儿院，仍试图确认院内情况 → 压下悲痛进入案件分析状态，并在官方拘留下开始面对追凶与自保双重压力。莱尔以观察鞋印、血迹、门锁和房间翻动情况来抵御情绪崩溃。他发现尸体时明显僵硬，却始终要求自己不能乱，并在克劳准备独自追击时承担了制止者角色。报案时，他主动放弃使用欺骗力量，说明其冷静不仅是能力依赖，更包含对风险和必要性的判断。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_23	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	克劳·沃尔特的变化	克劳·沃尔特的状态变化: 察觉孤儿院异常后急于冲入院内确认众人安危 → 由即时复仇冲动转为被迫克制，将悲痛凝结为追查凶手和营救萨姆的长期动机。克劳面对托比、诺亚和玛丽的死亡几乎无法用语言表达，只能通过掀桌布、握刀、收起围裙口袋和捡走缝衣针等动作外化情绪。他最初坚持沿车辙追击，在莱尔指出敌我差距与搜查效率后最终合刀，表现出首次在极端愤怒中接受理性约束。	\N	["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"]	[]	["\\u89d2\\u8272", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_24	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	玛丽修女的变化	玛丽修女的状态变化: 孤儿院的照料者与保护者 → 在礼拜室晨星圣像下遇害。章节未展示其临死前完整心理过程，但被翻出的口袋、散落的缝衣针与手中断裂的晨星说明她经历过搜身或搏斗，并可能在最后时刻试图留下线索。	\N	["\\u739b\\u4e3d\\u4fee\\u5973"]	[]	["\\u89d2\\u8272", "\\u739b\\u4e3d\\u4fee\\u5973", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_25	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	托比的变化	托比的状态变化: 孤儿院中负责劈柴等杂务的成员 → 在厨房遭袭身亡。从血迹和斧头位置可判断，托比手部已经受伤，仍试图取得劈柴斧进行抵抗，但最终未能触及武器。	\N	["\\u6258\\u6bd4"]	[]	["\\u89d2\\u8272", "\\u6258\\u6bd4", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_26	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	诺亚的变化	诺亚的状态变化: 抱着木马生活在孤儿院的孩子 → 藏在厨房桌下遇害。诺亚可能在袭击发生时抱着木马躲入桌下，其死亡与断裂木马共同强化了暴力对儿童日常生活的摧毁。	\N	["\\u8bfa\\u4e9a"]	[]	["\\u89d2\\u8272", "\\u8bfa\\u4e9a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_27	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	艾拉的变化	艾拉的状态变化: 居住在孤儿院宿舍的孩子 → 试图从窗户逃生但未能成功，最终遇害。她临死前表现出明确的求生行动，抓着窗框并试图借排水管逃离，却没有留下落地脚印，说明在翻窗过程中或此前就被袭击者截住。	\N	["\\u827e\\u62c9"]	[]	["\\u89d2\\u8272", "\\u827e\\u62c9", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_character_event_28	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	character_event	萨姆的变化	萨姆的状态变化: 晨星孤儿院的孩子之一 → 在屠杀后下落不明，可能逃走或被袭击者带走。本章未直接呈现其心理，但床后蹭过灰尘的痕迹暗示他可能尝试藏匿或逃生。	\N	["\\u8428\\u59c6"]	[]	["\\u89d2\\u8272", "\\u8428\\u59c6", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
b03607f8-cc24-4b4c-9023-647a4dfb1b5c_plot_point_29	7f6d28c4-2a32-46d1-887c-6cf5c4555056	b03607f8-cc24-4b4c-9023-647a4dfb1b5c	plot_point	冲突 - 强度10	重要冲突: 外部核心冲突是两名幸存者追查屠杀孤儿院并带走萨姆的凶手；内部冲突集中在克劳急于追击复仇、莱尔坚持通过封城和巡警扩大搜查效率；社会冲突则表现为巡员起初不信报案，治安官随后把两人同时当作受保护者和潜在嫌疑人。凶手身份、作案目标与萨姆去向均未解决。。冲突各方: 莱尔·西奥多、克劳·沃尔特与身份不明的袭击者, 克劳·沃尔特的复仇冲动与莱尔·西奥多的理性判断, 两名幸存者与迟钝、怀疑他们的治安体系	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	1	3	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 15:47:58.084587	2026-08-06 15:47:58.084587
9ad1ee72-1357-48e5-a162-cf2d304c65d5_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	chapter_summary	第4章《问询》摘要	治安所通过店铺、城门和采购单核实莱尔与克劳的行动路线，正式排除二人的作案嫌疑。；警方锁定一辆无牌马车，并以左侧破损车轮形成的断纹作为追踪依据。；异常墙灰被封存为证物，治安官宣布异常管理局将介入孤儿院案件。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u95ee\\u8be2"]	0.6	4	0	102	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	hook	悬念 - 中段	[悬念钩子] 警方发现一辆没有登记车牌的马车，其破损车轮留下独特断纹，可能是袭击者运送人员或撤离现场的关键载具。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	4	1078	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	hook	认知 - 中段	[认知钩子] 治安所明确排除莱尔与克劳的嫌疑，并认真复核二人提供的证据，打破了读者对官方机构敷衍、敌对或腐败的惯性预期。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.7	4	1388	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	hook	悬念 - 中段	[悬念钩子] 现场墙灰被作为特殊证物封存，案件因此进入异常管理局的管辖范围，暗示孤儿院袭击涉及超自然力量或异常物质。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	4	1561	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	hook	情感 - 中段	[情感钩子] 走廊中的孩子哭声触发克劳的创伤反应，莱尔立即遮住观察窗并安慰他，集中呈现幸存者的内疚、哀痛与彼此依赖。	\N	[]	[]	["\\u60c5\\u611f", "\\u4e2d\\u6bb5"]	0.8	4	1859	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	hook	悬念 - 中后段	[悬念钩子] 莱尔从访客画像中认出三名灰衣男子，而他们曾自称异常管理局调查员；真正的异常管理局此时又将正式介入，制造真假调查员的身份疑云。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u540e\\u6bb5"]	0.9	4	2228	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_hook_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	hook	情感 - 结尾	[情感钩子] 烧黑念珠以具体遗物承载玛丽修女的死亡与孩子们的共同记忆，在调查线索之外形成克制而强烈的哀悼收束。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.8	4	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	foreshadow	回收伏笔	第2章对三名灰衣访客服饰与外貌的描写在本章转化为正式调查线索。莱尔通过访客画像准确认出三人，使此前的视觉信息完成阶段性回收，并进一步引出他们是否冒充异常管理局人员的问题。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	4	2141	13	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	foreshadow	回收伏笔	第3章由莱尔观察到的三组鞋印得到治安所专业测量和拓印的独立验证，两双钉铁掌长靴与一双右后跟严重磨损的窄底靴获得确认。这回收了鞋印数量与特征的可靠性，但袭击者身份仍待后续追查。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	4	1176	11	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	plot_point	情节点 - resolution	治安所通过店铺、城门和采购单核实莱尔与克劳的行动路线，正式排除二人的作案嫌疑。。影响: 结束主角是否会遭官方拘押的短期悬念，使叙事重心从自证清白转向合作追凶。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.75	4	1388	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_plot_point_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	plot_point	情节点 - revelation	警方锁定一辆无牌马车，并以左侧破损车轮形成的断纹作为追踪依据。。影响: 把后门车辙从现场观察提升为可跨辖区追查的实证，为锁定撤离路线和袭击者据点提供突破口。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.9	4	1078	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_plot_point_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	plot_point	情节点 - transition	异常墙灰被封存为证物，治安官宣布异常管理局将介入孤儿院案件。。影响: 明确案件存在超出普通治安体系的成分，推动故事进入超凡机构与能力调查层面。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.95	4	1513	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_plot_point_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	plot_point	情节点 - revelation	莱尔通过画像认出三名灰衣访客，并指出他们曾自称异常管理局调查员。。影响: 将第2章访客信息转化为核心嫌疑线索，同时制造冒名、内鬼或机构隐瞒等多重可能。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	1	4	2228	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_plot_point_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	plot_point	情节点 - conflict	警方在礼拜室门边找到玛丽修女烧黑的念珠，并承诺案件结束后归还。。影响: 以遗物强化玛丽修女死亡的情感重量，也让主角追查真相的私人动机得到再次确认。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.8	4	2699	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_character_event_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 彻夜未眠，以冷静和讥讽压制丧亲后的疲惫与悲痛 → 确认官方调查正在有效推进，并从马车、鞋印、灰衣访客和异常墙灰中建立起较清晰的追查方向。莱尔由被动等待问询转为主动参与调查。他发现治安所并未忽视自己的现场判断后，对官方程序产生有限信任，但依旧保持警惕。面对克劳的创伤反应，他持续承担照顾者与稳定者的职责，个人悲伤则主要通过果酱和念珠的记忆间接流露。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	4	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_character_event_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	character_event	克劳·沃尔特的变化	克劳·沃尔特的状态变化: 僵硬封闭，整夜握着玛丽修女的物品，以沉默压制悲痛与复仇冲动 → 仍处于强烈创伤和愤怒中，但暂时接受莱尔与治安官的现实判断，没有擅自前往旧货场。克劳对调查进展表现出急迫感，得知货场线索后立即提出亲自寻找，显示其倾向用行动和暴力摆脱无力感。孩子的哭声触发明显应激反应，说明孤儿院惨案已造成深层创伤。最终面对玛丽修女的念珠，他继续以沉默承受悲痛，没有失控行动。	\N	["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"]	[]	["\\u89d2\\u8272", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	4	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
9ad1ee72-1357-48e5-a162-cf2d304c65d5_plot_point_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9ad1ee72-1357-48e5-a162-cf2d304c65d5	plot_point	冲突 - 强度8	重要冲突: 外部冲突由治安所对无牌马车、鞋印、灰衣访客及异常证物的调查展开，袭击者虽然没有正面出场，却通过被切断的车辙和可疑身份持续构成压力。内部冲突集中在克劳身上：他急于亲自前往货场，却因情绪失控和现实风险受到阻止；莱尔则压抑自身悲痛，以冷静分析和照顾克劳维持行动能力。。冲突各方: 莱尔与克劳—追查袭击者并确认孤儿院众人的下落, 未知袭击者—隐藏身份、载具与行动目的, 克劳—复仇冲动与创伤反应之间的对抗, 治安所—在痕迹被雨水和现场踩踏破坏的情况下追查真相	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a", "\\u4eba\\u4e0e\\u73af\\u5883"]	0.8	4	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 22:53:39.91095	2026-08-06 22:53:39.91095
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	plot_point	情节点 - conflict	雷金纳德询问孤儿院是否有异能者，克劳右手缩回桌下，两人都未透露真实信息。。影响: 强化管理局与异能者之间的紧张关系，也为克劳的身份埋下疑点。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.7	5	1614	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	chapter_summary	第5章《异能管理局》摘要	莱尔透露自己能通过物品看到过去，但无法改变任何事，揭示主角能力的边界。；雷金纳德表示异常管理局因监测到凯莉米粒子异常而介入孤儿院事件，引入世界观核心设定。；雷金纳德询问孤儿院是否有异能者，克劳右手缩回桌下，两人都未透露真实信息。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u5f02\\u80fd\\u7ba1\\u7406\\u5c40"]	0.6	5	0	114	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	hook	悬念 - 中段	[悬念钩子] 案发前三天有三个人冒充异常管理局，在孤儿院打听异能者，他们的身份和目的成谜。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	5	1863	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	hook	悬念 - 结尾	[悬念钩子] 雷金纳德对自己的姓名保密，却被莱尔直接叫出，暗示他可能在刻意试探莱尔的特殊能力。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.7	5	2203	18	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	hook	情感 - 开头	[情感钩子] 克劳希望莱尔的能力能逆转时间救回玛丽修女，但莱尔只能看见过去，无法改变，亲人永逝的无力感刺痛读者。	\N	[]	[]	["\\u60c5\\u611f", "\\u5f00\\u5934"]	0.9	5	372	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	hook	认知 - 中段	[认知钩子] 凯莉米粒子的设定揭开了异常管理局的技术基础，异能不再是完全不可追踪的力量。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.6	5	1170	24	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	hook	冲突 - 开头	[冲突钩子] 克劳希望莱尔尝试其他能力用途，莱尔却断然否定，两人之间的隐性摩擦一触即发。	\N	[]	[]	["\\u51b2\\u7a81", "\\u5f00\\u5934"]	0.6	5	586	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	foreshadow	回收伏笔	异常管理局的介入正是因为东郊监测装置记录到凯莉米粒子浓度超过安全阈值，这解释了第4章暗色墙灰被单独封存的原因——墙灰上可能残留了异能发动时产生的凯莉米粒子，成为官方追踪的关键物证。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	5	1082	24	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	foreshadow	埋下伏笔	雷金纳德进门后不报姓名，却在结尾追问莱尔如何知道自己的名字，表面被工牌解释，但雷金纳德已开始怀疑莱尔拥有情报获得或感知能力。这可能是他日后重点调查莱尔的起点。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.7	5	2221	12	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_plot_point_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	plot_point	情节点 - revelation	莱尔透露自己能通过物品看到过去，但无法改变任何事，揭示主角能力的边界。。影响: 奠定悲剧基调，强化人物动机，解释他为何无法救回玛丽修女。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.8	5	524	18	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_plot_point_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	plot_point	情节点 - revelation	雷金纳德表示异常管理局因监测到凯莉米粒子异常而介入孤儿院事件，引入世界观核心设定。。影响: 说明官方追踪机制，使异能事件具备可检测性。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.7	5	1082	24	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	plot_point	情节点 - transition	莱尔和克劳告知雷金纳德曾有冒充异常管理局的神秘人来访，调查方向转向新的线索。。影响: 为故事提供新的追查目标，使真凶线索浮出水面。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.7	5	1863	18	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	plot_point	情节点 - resolution	雷金纳德追问莱尔如何知道自己的姓名，却被克劳和莱尔同时指认工牌，化解尴尬却埋下更多疑云。。影响: 暂时解决小危机，但让雷金纳德对莱尔产生更多疑心。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.6	5	2276	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_character_event_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 悲痛但克制，回避谈论能力 → 坦白并直面能力局限，但对真相更加坚定。在克劳的追问下承认自己无法改变过去，内心产生愧疚，但这也促使他更决意追查凶手；同时开始怀疑雷金纳德在刻意试探自己。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	5	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_character_event_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	character_event	克劳·沃尔特的变化	克劳·沃尔特的状态变化: 失眠、悲伤，执着于逆转惨剧 → 压抑情绪，转向配合调查。在莱尔坦白后意识到无法改变过去，将悲伤转化为追查动力，同时更想守护莱尔；在雷金纳德面前听到异能问题时右手缩回桌下，显露隐藏秘密的警觉。	\N	["\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279"]	[]	["\\u89d2\\u8272", "\\u514b\\u52b3\\u00b7\\u6c83\\u5c14\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	5	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_character_event_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	character_event	雷金纳德·洛克哈特的变化	雷金纳德·洛克哈特的状态变化: 官方、疏离，掌控问答节奏 → 内心起疑，开始观察莱尔。注意到莱尔直接叫出自己的姓名，意识到对方可能具备超常观察力或其他能力，对莱尔产生警惕和兴趣。	\N	["\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279"]	[]	["\\u89d2\\u8272", "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	5	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
916de3c2-a30f-44c3-b395-dd0f5c01a6ab_plot_point_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	916de3c2-a30f-44c3-b395-dd0f5c01a6ab	plot_point	冲突 - 强度7	重要冲突: 克劳希望莱尔用能力救回玛丽修女，但莱尔无力改变过去，两人在愧疚中挣扎；同时，冒充管理局的神秘访客和真正管理局的调查使真相更加扑朔迷离。。冲突各方: 莱尔与克劳（悲痛与期望）, 莱尔/克劳与冒充异常管理局的势力, 莱尔与雷金纳德（信息博弈）	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	0.7	5	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-06 23:14:19.469776	2026-08-06 23:14:19.469776
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	chapter_summary	第6章《月季楼上的侦探》摘要	故事时间推进十五年，莱尔以持枪、携带藏剑手杖的持照私家侦探身份重新登场。；异常管理局已经建立公开报案、区域监测与粒子读数制度，异能从都市传闻转变为被社会公开管理的现实。；塞西莉的案件没有任何凯莉米粒子异常，因此同时被治安所和异常管理局排除在各自管辖范围之外。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u6708\\u5b63\\u697c\\u4e0a\\u7684\\u4fa6\\u63a2"]	0.6	6	0	129	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	hook	认知 - 开头	[认知钩子] 开篇直接跨越十五年，将故事从孤儿院惨案后的少年时期切换到莱尔已经成为持照私家侦探的成年阶段，制造强烈的身份与时代落差。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u5f00\\u5934"]	0.9	6	0	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	hook	悬念 - 中段	[悬念钩子] 管理局局长似乎早已了解莱尔，并特意交代把难以处理的案件转给他；其语气中的隐情暗示莱尔与官方机构存在未公开的过往。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	6	2006	16	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	hook	冲突 - 中段	[冲突钩子] 塞西莉的案件因缺少异常粒子波动被管理局拒绝，又已被治安所推诿，形成常规执法体系与异常管理体系之间的管辖真空。	\N	[]	[]	["\\u51b2\\u7a81", "\\u4e2d\\u6bb5"]	0.8	6	2183	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	hook	悬念 - 结尾	[悬念钩子] 格雷文赫当红乐队"锈蔷薇"的贝斯手亲自求助，明星身份显著抬高案件的社会影响力，但她究竟遭遇了什么仍被刻意延后揭晓。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.8	6	2739	16	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	hook	情感 - 结尾	[情感钩子] 莱尔面对提前到来的重要客户依然严格等到九点才开始工作，以冷幽默完成角色亮相，并让章节停在新案件正式启动的临界点。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.7	6	2994	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	foreshadow	埋下伏笔	异常管理局局长不仅知道莱尔，还把规程难以覆盖的特殊案件导向他的事务所；其意味复杂的语气表明双方可能有旧交、合作协议或对莱尔能力的特殊认知。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	6	1951	12	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_foreshadow_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	foreshadow	埋下伏笔	塞西莉所报案件看似具有非正常性质，却没有引发凯莉米粒子波动。后续可能证明存在能够规避监测的能力、非异能犯罪手段、监测系统盲区，或人为篡改记录的情况。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.9	6	1447	16	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_foreshadow_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	foreshadow	埋下伏笔	塞西莉从治安所辗转至管理局，再带经纪人亲自拜访莱尔，说明事件已经严重到无法依靠自身名气和资源解决。章节刻意不公开报案内容，将案件核心悬念留到下一章。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	6	2166	12	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	plot_point	情节点 - transition	故事时间推进十五年，莱尔以持枪、携带藏剑手杖的持照私家侦探身份重新登场。。影响: 完成全书阶段性转场，重置人物年龄、身份、社会环境和叙事类型，正式进入成年侦探篇。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	1	6	0	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	plot_point	情节点 - revelation	异常管理局已经建立公开报案、区域监测与粒子读数制度，异能从都市传闻转变为被社会公开管理的现实。。影响: 展现十五年间世界秩序的重大变化，并建立后续异常案件的判定规则和制度边界。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.85	6	1642	16	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	plot_point	情节点 - conflict	塞西莉的案件没有任何凯莉米粒子异常，因此同时被治安所和异常管理局排除在各自管辖范围之外。。影响: 建立新案件最关键的悖论：事件疑似异常，却不符合异常监测标准，迫使案件转入私人调查渠道。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.9	6	1904	7	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_plot_point_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	plot_point	情节点 - transition	珀西瓦尔遵照局长曾经的暗示，将棘手案件转介给莱尔。。影响: 把管理局报案线与莱尔的侦探线汇合，同时埋下局长为何了解并信任莱尔的关系悬念。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.88	6	1976	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_plot_point_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	plot_point	情节点 - revelation	来访者被确认是当红乐队锈蔷薇的贝斯手塞西莉，莱尔在九点整正式邀请她们上楼详谈。。影响: 提升案件的公众影响力，以轻松的工作时间笑点结束铺垫，并将读者注意力引向下一章的委托内容。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.82	6	2688	16	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_character_event_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 生活规律、冷静自持，以高度固定的晨间流程维持秩序 → 面对特殊客户仍从容掌控节奏，准备正式接手新的委托。本章没有剧烈心理转折，主要完成成年莱尔的状态展示。他对环境、时间、武器和行动路线均保持精确控制，同时以略显吊儿郎当的方式坚持工作时间，体现冷静严谨与冷幽默并存的性格。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	6	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_character_event_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	character_event	格蕾丝的变化	格蕾丝的状态变化: 平和亲切，照常为莱尔准备早餐并经营咖啡厅 → 因确认当红乐队成员到访而震惊兴奋。从熟悉的日常照料状态迅速转为面对名人的失措，增强了咖啡厅生活气息，也借她的反应向不熟悉乐队的莱尔和读者说明塞西莉的知名度。	\N	["\\u683c\\u857e\\u4e1d"]	[]	["\\u89d2\\u8272", "\\u683c\\u857e\\u4e1d", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	6	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_character_event_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	character_event	珀西瓦尔·费尔班克斯的变化	珀西瓦尔·费尔班克斯的状态变化: 作为刚入职不久的管理局职员，严格依照粒子读数和受理规程办事 → 在制度无法覆盖案件时采取折中办法，将塞西莉转介给莱尔。他先以规程拒绝案件，随后意识到治安所同样不愿受理，陷入为难。最终想起局长的交代，在不突破管理局规定的前提下为报案人提供出路，表现出尚未被官僚体系完全磨平的责任感。	\N	["\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af"]	[]	["\\u89d2\\u8272", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	6	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_character_event_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 因案件接连遭到治安所和管理局推诿而压抑、不满且戒备 → 抵达侦探事务所，暂时压下质疑并等待莱尔受理。她在管理局始终戴着墨镜并保持紧绷，说明其明星身份可能带来额外顾虑。尽管不满案件被推给私人侦探，她仍接受地址并亲自前往，表明解决问题的需求已经超过对程序和身份的顾忌。	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	6	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_character_event_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	character_event	哈里特·默瑟的变化	哈里特·默瑟的状态变化: 以稳重姿态陪同塞西莉寻求帮助 → 主动代表两人进行介绍，协助开启与莱尔的正式沟通。整体保持冷静稳定，没有明显情绪波动。她承担社交与沟通职责，与塞西莉的戒备形成互补，体现经纪人的职业性。	\N	["\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f"]	[]	["\\u89d2\\u8272", "\\u54c8\\u91cc\\u7279\\u00b7\\u9ed8\\u745f", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	6	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6_character_event_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	c9f76e7d-64b6-446c-a2d0-d8fd810ce5a6	character_event	露西的变化	露西的状态变化: 因前两天较少外出而等待莱尔带它散步 → 完成晨间散步并被送回月季咖啡厅后院。见到莱尔后明显放松，说明它对莱尔高度熟悉和信任。该段主要用于强化莱尔稳定、温和的生活侧面。	\N	["\\u9732\\u897f"]	[]	["\\u89d2\\u8272", "\\u9732\\u897f", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	6	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:31:38.701732	2026-08-07 00:31:38.701732
88f367b9-7962-46c7-b75e-9f4924ba0f70_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	chapter_summary	第7章《六月三日的黑影》摘要	塞西莉公开六月三日的目击经过，说明玛蒂尔达曾被一个矮小、无声的黑影尾随。；玛蒂尔达在事件后出现固定慢拍、动作迟钝和反应延迟，案件由单纯跟踪升级为疑似异常侵害。；莱尔解释凯莉米粒子读数的局限，指出低于警戒线不等于不存在异常。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u516d\\u6708\\u4e09\\u65e5\\u7684\\u9ed1\\u5f71"]	0.6	7	0	111	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	hook	悬念 - 中段	[悬念钩子] 塞西莉目击到一个身形异常矮小、在石板路上移动却完全没有脚步声的黑影跟踪玛蒂尔达，直接建立本案的超自然核心谜团。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	7	502	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	hook	认知 - 中段	[认知钩子] 玛蒂尔达没有失踪或受伤，却在节奏、动作和反应上出现稳定而细微的变化，塞西莉甚至产生了她被其他存在操纵或替换的直觉。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.9	7	1018	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	hook	认知 - 中段	[认知钩子] 莱尔解释凯莉米粒子监测只能衡量现实受扰动的幅度，低读数并不能排除异常活动，修正了客户和读者对官方监测机制的理解。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.8	7	1520	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	hook	冲突 - 中段	[冲突钩子] 塞西莉需要在保护队友和尊重玛蒂尔达个人意愿之间作出选择，并在证据不足的情况下秘密寻求调查。	\N	[]	[]	["\\u51b2\\u7a81", "\\u4e2d\\u6bb5"]	0.7	7	1967	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	hook	悬念 - 结尾	[悬念钩子] 莱尔提出通过催眠提取目击记忆，随后却拿出一支淡蓝色吐真剂针筒，把调查方法的不确定性与身体风险推到章末。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.9	7	2308	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	foreshadow	回收伏笔	旧货场中由规整鞋钉指向专业行动者的线索，在本章通过黑影于石板路上完全无声的移动方式得到阶段性呼应：追踪行为明显超出普通行人的行动特征，进一步提示专业潜行技术、特殊装备或非正常移动能力。不过本章尚未明确证明黑影与货场行动者属于同一势力，因此属于隐蔽而不完全的回收。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.6	7	569	17	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	foreshadow	回收伏笔	第6章刻意隐藏的委托内容在本章正式公开：塞西莉目击玛蒂尔达被无声黑影跟踪，并发现她此后出现节奏和反应异常。她从治安所转向管理局、最终拜访莱尔的完整动机由此得到解释。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.9	7	1217	10	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	foreshadow	回收伏笔	第6章提出的低读数乃至零读数异常案件在本章得到机制层面的解释：凯莉米粒子监测反映的是现实被搅动的程度，微弱异能、异常器物或屏蔽手段可能被仪器视为背景噪音。该解释确立了莱尔能够介入官方制度盲区的合理性。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	7	1386	12	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_foreshadow_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	foreshadow	埋下伏笔	塞西莉以合作六年的经验判断玛蒂尔达的动作、反应和眼神均发生变化，并形容其像被另一个人使用身体。这可能指向附身、意识替换、精神控制或制造替身，是本案最危险的可能性。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.9	7	1018	10	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_foreshadow_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	foreshadow	埋下伏笔	莱尔认为塞西莉的意识虽然没记住影子细节，视觉记忆却仍有残留，准备通过催眠完成侧写。下一阶段调查将围绕被压在深层记忆中的身高、轮廓、移动方式或身份标志展开。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	7	2066	11	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_foreshadow_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	foreshadow	埋下伏笔	淡蓝色吐真剂以强烈视觉符号收束章节。莱尔声称低剂量只会帮助放松并提取记忆，但塞西莉与哈里特的恐惧以及对合法性的质疑，预示药物的真实效果、使用风险和莱尔的操作边界将在下一章接受验证。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	7	2328	19	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_plot_point_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	plot_point	情节点 - revelation	塞西莉公开六月三日的目击经过，说明玛蒂尔达曾被一个矮小、无声的黑影尾随。。影响: 正式揭示明星客户的委托内容，启动本章的新案件主线。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.95	7	435	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_plot_point_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	plot_point	情节点 - revelation	玛蒂尔达在事件后出现固定慢拍、动作迟钝和反应延迟，案件由单纯跟踪升级为疑似异常侵害。。影响: 将调查目标从寻找跟踪者扩展到确认玛蒂尔达是否遭到附身、替换或控制。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.98	7	924	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_plot_point_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	plot_point	情节点 - revelation	莱尔解释凯莉米粒子读数的局限，指出低于警戒线不等于不存在异常。。影响: 补全世界观规则，合理化管理局不受理与莱尔介入之间的制度逻辑。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.85	7	1520	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_plot_point_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	plot_point	情节点 - transition	莱尔决定通过催眠翻出塞西莉的深层视觉记忆，以侧写黑影的真实外形。。影响: 把案件从口述询问推进到主动取证阶段，并为下一章的记忆场景做准备。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.9	7	2021	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_plot_point_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	plot_point	情节点 - conflict	莱尔拿出红雪生产的淡蓝色吐真剂，塞西莉与哈里特因其危险印象陷入惊惧。。影响: 制造章末强钩子，同时引出调查手段的伦理、合法性和安全风险。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.92	7	2360	7	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_character_event_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 从容接待特殊客户，尚未掌握委托的具体内容 → 初步判断案件可能涉及低扰动异常，并决定通过药物辅助催眠提取目击记忆。莱尔从常规问询迅速转入专业判断。他注意到无声黑影、稳定慢拍和反应迟滞之间的关联，却没有过早下结论，而是先解释监测机制，再提出可验证的调查手段，体现其冷静、务实及游走规则边缘的办案风格。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	7	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_character_event_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 保持冷静与戒备，希望判断莱尔是否值得委托 → 认可案件可能无法由官方读数排除，愿意接受催眠，但对注射吐真剂产生明显恐惧。她从谨慎陈述目击经过，逐渐暴露对玛蒂尔达的深度担忧。她能够凭六年合作经验识别极细微的节奏和动作偏差，说明她的求助并非名人式敏感，而是建立在专业观察上。最终同意催眠，表明保护队友的责任感暂时压过了对未知手段的戒心。	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	7	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_character_event_22	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	character_event	哈里特的变化	哈里特的状态变化: 作为经纪人陪同塞西莉，保持观察和风险控制姿态 → 支持塞西莉接受记忆调查，但在莱尔拿出吐真剂后立刻质疑其合法性与安全性。哈里特前半段主要承担信息补充和见证者角色，面对催眠提议时经过权衡后同意；针筒出现后，她迅速从旁观者切换为保护者，表明她的首要立场不是推动案件，而是保障塞西莉的人身与职业安全。	\N	["\\u54c8\\u91cc\\u7279"]	[]	["\\u89d2\\u8272", "\\u54c8\\u91cc\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	7	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_character_event_23	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	character_event	玛蒂尔达·斯特林的变化	玛蒂尔达·斯特林的状态变化: 在六月三日排练结束后独自回家，自称没有遭遇任何事情 → 被塞西莉怀疑出现稳定的动作迟滞、节奏偏差和人格异样，成为异常案件的核心对象。本人未直接出场，无法确认其主观心理变化；从外部观察看，她似乎对自身异常缺乏认知或刻意否认，并可能受到某种意识、身体或身份层面的干扰。	\N	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	[]	["\\u89d2\\u8272", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	7	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
88f367b9-7962-46c7-b75e-9f4924ba0f70_plot_point_24	7f6d28c4-2a32-46d1-887c-6cf5c4555056	88f367b9-7962-46c7-b75e-9f4924ba0f70	plot_point	冲突 - 强度8	重要冲突: 核心外部冲突是莱尔一方与身份、能力均未知的黑影之间的信息战；内部冲突则来自塞西莉对自身目击是否可信、是否应该瞒着玛蒂尔达调查的迟疑。制度层面上，治安所因缺乏伤亡拒绝处理，管理局又受粒子警戒线约束，使潜在异常落入无人负责的灰色地带。。冲突各方: 塞西莉·辛克莱、哈里特、莱尔·西奥多—查明玛蒂尔达的异常, 未知黑影或幕后力量—隐匿踪迹并可能操控玛蒂尔达, 塞西莉·辛克莱—在保护同伴与尊重同伴意愿之间犹豫, 民间调查者—应对治安所和异常管理局监测制度的盲区	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a", "\\u4eba\\u4e0e\\u73af\\u5883"]	0.8	7	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:36:35.107712	2026-08-07 00:36:35.107712
9dc2adf5-8afa-4116-a98e-e481ecd4c427_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	chapter_summary	第8章《断在暗巷的足迹》摘要	莱尔在窗边目送塞西莉与哈里特离去，确认吐真剂没能换来信任，只留下一张地址。；莱尔触摸铁杆路灯，通过旧物的视觉记忆还原出六月三日跟踪者的画面，第一次完整捕捉到面容细节。；两条线索断裂：玛蒂尔达的足迹湮灭在空地的雨泥里，跟踪者则消失在没有旧物看见的暗巷中。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u65ad\\u5728\\u6697\\u5df7\\u7684\\u8db3\\u8ff9"]	0.6	8	0	126	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	hook	悬念 - 结尾	[悬念钩子] 跟踪者面容被锁定，但玛蒂尔达的行踪在空地彻底消失，她到底去了哪里？是否已经遭遇不测？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.9	8	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	hook	悬念 - 中段	[悬念钩子] 跟踪者的身份：矮个子、络腮胡、右嘴角旧疤、手染油墨，他究竟是什么人？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	8	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	hook	悬念 - 中段	[悬念钩子] 暗巷里没有任何旧物能留下痕迹，说明跟踪者有极强的反侦察意识——这是否意味着背后有更大的组织？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	8	3263	29	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	hook	情感 - 结尾	[情感钩子] 莱尔独自站在岔路口，面对两条断掉的线索，仍决定继续追查，展现孤勇与执着。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.7	8	3713	26	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	foreshadow	埋下伏笔	暗巷没有煤气灯和监测仪，连旧物也记录不到任何画面，强烈暗示跟踪者有预谋地选择了一条无法留下痕迹的路线，日后真相揭露时可能发现其背后有组织化的反侦察能力支持。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.9	8	3141	26	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	foreshadow	回收伏笔	莱尔通过触摸路灯等旧物，成功还原了六月三日夜里跟踪者的身高、轮廓和移动方式，这正对应他此前认为塞西莉深层视觉记忆中有残留、可借催眠绘制侧写的判断——虽然没有使用催眠，但结果达到了追查影子的目的。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	8	-1	0	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_plot_point_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	plot_point	情节点 - transition	莱尔在窗边目送塞西莉与哈里特离去，确认吐真剂没能换来信任，只留下一张地址。。影响: 为本章调查划定空间与时间锚点，并强化塞西莉与莱尔之间的合作冷感。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.6	8	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_plot_point_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	plot_point	情节点 - revelation	莱尔触摸铁杆路灯，通过旧物的视觉记忆还原出六月三日跟踪者的画面，第一次完整捕捉到面容细节。。影响: 直接推进案件：矮个子、络腮胡、右嘴角旧疤、手指染油墨——这组画像成为后续追查的关键钥匙。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.95	8	2187	19	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_plot_point_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	plot_point	情节点 - conflict	两条线索断裂：玛蒂尔达的足迹湮灭在空地的雨泥里，跟踪者则消失在没有旧物看见的暗巷中。。影响: 将悬疑推向更高层：跟踪者显然具备反侦察意识，案件难度急剧升级，迫使莱尔转换追查方向。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.9	8	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	plot_point	情节点 - resolution	莱尔站在岔路口，决定先查脸、再查油墨，并转向治安所体系之外的灰色地带寻找答案。。影响: 主角从制度化合作转向个人孤军深入，为后续引入地下信息网做铺垫。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.8	8	3684	27	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_character_event_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 保持冷静、试图在制度化框架内合作 → 目标明确，决定脱离框架自行追查。从依靠流程与合作的克制，转向被断线逼迫的孤勇——他认识到系统无法解决，只能依靠自己的能力与私网。掌心的焦黑和'没有记忆的暗巷'强化了他的警觉，但没有使他有丝毫退缩。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	8	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
9dc2adf5-8afa-4116-a98e-e481ecd4c427_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	9dc2adf5-8afa-4116-a98e-e481ecd4c427	plot_point	冲突 - 强度7	重要冲突: 莱尔一方面在内心与自身能力的代价（触摸留下焦痕）搏斗，另一方面与制度化系统的瘫痪对抗——异常管理局拒绝受理，治安所流程无果，迫使莱尔依赖私人手段寻求出路。。冲突各方: 莱尔·西奥多——追寻真相与自身能力代价的搏斗, 莱尔·西奥多 vs 未知跟踪者, 莱尔·西奥多 vs 制度性失灵（异常管理局不受理）	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	0.7	8	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 00:49:36.243115	2026-08-07 00:49:36.243115
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	chapter_summary	第10章《木偶》摘要	塞西莉与莱尔在排练室外对话，揭穿排练室里的"玛蒂尔达"是木偶替身，真正的玛蒂尔达被绑在港口区旧货仓。；塞西莉接受莱尔的安排，强忍情绪回到排练室照常与替身合练，为跟踪争取时间。；莱尔一路跟踪替身穿过街巷进入港口区，确认它走进最末一间旧货仓。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u6728\\u5076"]	0.6	10	0	119	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	hook	悬念 - 开头	[悬念钩子] 真玛蒂尔达被囚于港口旧货仓，莱尔确认她活着且有意识，但救援尚未展开——她能否在替身完成任务前获救？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u5f00\\u5934"]	0.9	10	391	10	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	hook	情感 - 中段	[情感钩子] 塞西莉必须对着木偶替身继续微笑、拉琴、若无其事地排练，读者的情绪被压在她克制的表演之下。	\N	[]	[]	["\\u60c5\\u611f", "\\u4e2d\\u6bb5"]	0.8	10	721	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	hook	悬念 - 中段	[悬念钩子] 灰衣男说出"刻进去的东西，能忘吗"——木偶替身的能力与限制机制被首次挑明，暗示背后有更深层的手段与目的。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	10	2362	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	hook	冲突 - 中段	[冲突钩子] 灰衣男提到"明早的走位改了"，说明替身还有一场预定行动，如果救援不及时，木偶可能完成某件不可逆的事，形成时间压力。	\N	[]	[]	["\\u51b2\\u7a81", "\\u4e2d\\u6bb5"]	0.7	10	2287	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	hook	悬念 - 结尾	[悬念钩子] 莱尔已经报警，珀西瓦尔承诺十分钟赶到，但章节恰好结束于等待——救援能否成功、是否会打草惊蛇，悬而未决。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.8	10	2582	17	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	foreshadow	回收伏笔	本章直接坐实替身是木偶：莱尔说出"替身是个木偶，木头做的，刻成玛蒂尔达的脸"，灰衣男又表示"刻进去的东西，能忘吗"，证实木偶替身背后存在一个操纵势力，且该势力正通过替身完成某个尚未揭晓的目标。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	10	531	20	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	foreshadow	回收伏笔	莱尔跟踪替身至港口西区最末一间旧货仓，确认其进入后未再离开，随后灰衣男与另一名同伙从仓库内走出并讨论次日计划，坐实旧货仓即为该势力的实际据点。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	10	1603	11	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	foreshadow	埋下伏笔	莱尔透过门缝看清灰衣男人转身时嘴角边有道疤斜到下巴，形成可辨认的体貌特征，为后续指认、追捕以及在人群中识别该嫌疑人埋下线索。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.6	10	2412	20	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_foreshadow_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	foreshadow	埋下伏笔	灰衣男说"明早的走位改了"，暗示替身还有一场预定演出或行动，不仅设定了紧迫的时间窗口，也为下一章救援行动的走向提供预期。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.7	10	2287	8	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_foreshadow_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	foreshadow	埋下伏笔	莱尔把本子上画的仓库图撕下折成薄方块捏在手里，暗示这张图会在后续救援或与珀西瓦尔交接时作为关键情报/证据使用。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.5	10	2768	19	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_foreshadow_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	foreshadow	埋下伏笔	珀西瓦尔提到"刚整理完铜锣巷的存档"，铜锣巷可能是一宗旧案或与当前绑架相关的线索，为后续案件串联与角色间信息交流埋下伏笔。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.5	10	-1	0	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	plot_point	情节点 - revelation	塞西莉与莱尔在排练室外对话，揭穿排练室里的"玛蒂尔达"是木偶替身，真正的玛蒂尔达被绑在港口区旧货仓。。影响: 读者与塞西莉同时获知核心真相，将悬念从"她是不是本人"转向"如何救出真玛蒂尔达"。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.85	10	245	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	plot_point	情节点 - conflict	塞西莉接受莱尔的安排，强忍情绪回到排练室照常与替身合练，为跟踪争取时间。。影响: 强化了塞西莉的内心挣扎，也为后续营救失败的后果积累情感张力。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.7	10	721	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_plot_point_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	plot_point	情节点 - transition	莱尔一路跟踪替身穿过街巷进入港口区，确认它走进最末一间旧货仓。。影响: 将犯罪据点从情报变为实地确认，推动情节进入具体行动阶段。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.9	10	1593	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_plot_point_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	plot_point	情节点 - revelation	莱尔绕到仓库背后侦察，偷听到灰衣男与同伙讨论"明早走位"及"刻进去的东西"，确认木偶替身的操控特性与后续计划。。影响: 揭示了操偶势力的运作方式，并制造了时间紧迫感。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.8	10	2362	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_plot_point_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	plot_point	情节点 - resolution	莱尔采集到足够信息后没有独自冲入仓库，而是第一次正式向珀西瓦尔报案，请求官方支援。。影响: 主角从独行侦察者转向与异能管理局协作，为下一章的大规模救援行动铺路。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.8	10	2582	17	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_character_event_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 冷静谨慎，已掌握情报但尚未行动 → 完成侦察，选择借助官方力量，进入待命状态。从独自掌控情报转向主动联络珀西瓦尔，展现出对局势的清醒判断与行动克制，避免因冲动打草惊蛇。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	10	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_character_event_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 心存疑虑，急欲求证 → 压抑震惊，坚决配合演戏。从得知真相的情绪冲击中迅速恢复冷静，决定当着木偶替身继续正常排练，展现出极强的自控力。	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	10	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_character_event_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	character_event	珀西瓦尔·费尔班克斯的变化	珀西瓦尔·费尔班克斯的状态变化: 在局内整理旧案存档，日常办公状态 → 接到报案后进入行动准备，承诺十分钟赶到。对莱尔出现在现场的缘由仍有程序性疑虑，但基于既有合作信任选择先行响应。	\N	["\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af"]	[]	["\\u89d2\\u8272", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	10	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_character_event_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	character_event	玛蒂尔达·斯特林的变化	玛蒂尔达·斯特林的状态变化: 被囚于旧货仓（本章未正面出场） → 确认仍活着且有意识。虽未正面出场，但通过莱尔转述可知她保持清醒、盯着门口，暗示她对获救仍有意志。	\N	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	[]	["\\u89d2\\u8272", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	10	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6_plot_point_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	8fee301a-e8b1-4aa6-b6aa-662f5dcdf3c6	plot_point	冲突 - 强度8	重要冲突: 主角方已锁定犯罪据点但碍于侦查不能打草惊蛇，塞西莉必须在知情的情况下与木偶替身维持日常排练，同时莱尔要在不被发现的情况下完成跟踪与取证，最后决定借助珀西瓦尔的官方身份实施围捕。。冲突各方: 莱尔/塞西莉 vs 操偶师绑架势力, 塞西莉 vs 自身情绪	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	0.8	10	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-16 23:10:04.862149	2026-08-16 23:10:04.862149
72191e56-643e-49a5-9216-78a08f6e1494_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	chapter_summary	第9章《皮包里的囚笼》摘要	莱尔观察玛蒂尔达打鼓，发现她的节奏过于精准、缺乏真人起伏，确认塞西莉的怀疑是对的。；莱尔触碰到皮包，通过能力读取到玛蒂尔达被绑架、被塞进马车运往旧货仓的全过程。；读取画面中出现完全仿造玛蒂尔达的木偶，被灰衣人激活后背着包走出货仓，成为正面活动的替身。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u76ae\\u5305\\u91cc\\u7684\\u56da\\u7b3c"]	0.6	9	0	125	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	hook	悬念 - 中段	[悬念钩子] 莱尔通过触摸皮包读取到玛蒂尔达被绑架的过程，真身被囚禁在旧货仓，而眼前继续排练的只是一个被激活的木偶替身。真身处境如何、幕后组织为何要在演唱会前替换她，成为最大未解悬念。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	9	847	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	hook	认知 - 中段	[认知钩子] 墙边立着的人形木偶完全复刻玛蒂尔达，灰衣人通过触摸头顶将其激活，揭示了一种以假乱真的人偶/借脸技术。这一技术让读者意识到，身边任何看似熟悉的人都可能是冒牌货。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.8	9	1181	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	hook	悬念 - 结尾	[悬念钩子] 木偶玛蒂尔达抱着皮包返回，对莱尔歪头微笑，手指关节泛着哑光——她是否已经察觉莱尔动过皮包？她的微笑是木偶的设定还是操控者的警觉？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.8	9	1742	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_foreshadow_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	foreshadow	回收伏笔	莱尔读取皮包后，包带边缘出现一道焦痕，皮面裂开细缝。这证实触摸读取能力会留下物理痕迹，也意味着莱尔触碰过的物品可能成为暴露他行动的线索——木偶或许正是通过这道焦痕察觉了异样。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	9	1659	10	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_foreshadow_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	foreshadow	埋下伏笔	木偶玛蒂尔达在莱尔读取完皮包后抱着包出现，歪头微笑，手指关节泛着哑光。这个微笑可能只是木偶模仿真人的机械行为，也可能暗示操控者已经察觉莱尔来过。它让莱尔确认面前的人不是玛蒂尔达，同时也暴露了替身具有一定程度的观察与伪装能力。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.9	9	1742	15	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	foreshadow	埋下伏笔	木偶的脸完全照着玛蒂尔达雕刻，眉眼鼻梁嘴角一模一个模子，灰白皮肤泛着木头哑光，关节能看到榫接缝。灰衣人通过触摸木偶头顶将其激活，使其行走如活人。这背后的制作技术可能涉及某种异常能力，也可能与莱尔自身的触摸能力存在某种对应关系。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.8	9	1254	10	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	foreshadow	埋下伏笔	莱尔在读取中闻到旧货仓特有的潮味，并看到高屋顶、堆放的木箱和卷起的帆布。这些环境细节成为追踪玛蒂尔达真身所在位置的重要嗅觉与视觉线索，后续办案时可能通过气味或建筑特征锁定地点。	\N	[]	[]	["\\u4f0f\\u7b14", "planted"]	0.7	9	1038	9	1	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_plot_point_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	plot_point	情节点 - revelation	莱尔观察玛蒂尔达打鼓，发现她的节奏过于精准、缺乏真人起伏，确认塞西莉的怀疑是对的。。影响: 坐实玛蒂尔达异常，推动莱尔进一步接近真相。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.8	9	317	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_plot_point_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	plot_point	情节点 - revelation	莱尔触碰到皮包，通过能力读取到玛蒂尔达被绑架、被塞进马车运往旧货仓的全过程。。影响: 揭示案件核心：这不是普通失踪，而是一场有预谋的替身计划。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.9	9	847	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	plot_point	情节点 - revelation	读取画面中出现完全仿造玛蒂尔达的木偶，被灰衣人激活后背着包走出货仓，成为正面活动的替身。。影响: 确定眼前玛蒂尔达是假人，真身被囚，幕后势力正在策划更大的目的。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	1	9	1443	26	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	plot_point	情节点 - complication	木偶玛蒂尔达回到排练室，对莱尔歪头微笑，手指关节泛着哑光，似乎察觉到莱尔的异样。。影响: 替身具有观察与伪装能力，莱尔暴露的风险增大，卧底调查随时可能被反制。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "complication"]	0.85	9	1742	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_character_event_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 怀疑玛蒂尔达被打鼓节奏异常困扰，正在调查 → 确认玛蒂尔达被木偶替换、真身被囚，转为更隐秘的秘密行动。从冷静观察变为强压内心震惊，意识到幕后势力远比想象中危险，行动更加谨慎，指甲掐进掌心也不让自己喘出气。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	9	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_character_event_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 担忧队友玛蒂尔达的状态，主动带莱尔前来确认 → 确认队友被替换，震惊但强行镇定，决心救回真身。看到莱尔脸色不对时更加警惕，但没有当场追问，选择用暗语确认，展现成熟的心理承受力。	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	9	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_character_event_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	character_event	玛蒂尔达·斯特林的变化	玛蒂尔达·斯特林的状态变化: 被异常替身顶替，周围人只觉其性格、节奏异常 → 确认真身被囚禁在旧货仓，木偶替身继续以她的身份活动。读取画面中真身在绑缚中仍睁眼看着门口，表现出一定镇定与忍耐，但当前心理状态未知。	\N	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	[]	["\\u89d2\\u8272", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	9	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
72191e56-643e-49a5-9216-78a08f6e1494_plot_point_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	72191e56-643e-49a5-9216-78a08f6e1494	plot_point	冲突 - 强度8	重要冲突: 莱尔确认玛蒂尔达被木偶替换、真身被囚禁，但必须克制行动以免打草惊蛇。幕后势力以绑架真身并制作替身来达成某种目的，双方的直接交锋尚未开始，但信息战已拉开。同时莱尔与塞西莉都必须压抑震惊情绪，在木偶面前维持常态，形成内部心理冲突。。冲突各方: 莱尔/塞西莉（调查方）, 木偶操控者/灰衣人（幕后势力）	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	0.8	9	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 10:26:16.008716	2026-08-07 10:26:16.008716
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_9	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	确认所有签名采集、动作模仿和重复书写都是为了制造能以假乱真的商业替身——替身能签收据、改合同、应付熟人，替身计划的真实目的是身份顶替而非舞台表演。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.9	12	1964	14	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
214ed068-75b2-477d-ae83-d83ae98afb96_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	chapter_summary	第11章《清醒者的缺口》摘要	玛蒂尔达回忆绑匪进门便说出只有六人知道的新版入场口令'钟坏在十一点'，证明内鬼就在流程表持有者之中。；莱尔用'怀疑纸不怀疑人'的逻辑在报纸上写下六人名单，逐一核对流程表下落。；塞西莉得知口令泄露后本能地与玛蒂尔达保持距离，最终在走廊外攥钥匙至掌心出血。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u6e05\\u9192\\u8005\\u7684\\u7f3a\\u53e3"]	0.6	11	0	126	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	hook	悬念 - 中段	[悬念钩子] 新版入场口令只有六个人知道，却被绑匪说出，证明内鬼就在乐队核心圈内。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	hook	悬念 - 结尾	[悬念钩子] 塞西莉在走廊外攥紧排练室钥匙直到掌心出血，暗示她可能隐藏着与内鬼相关的秘密。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.8	11	3064	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	hook	情感 - 结尾	[情感钩子] 玛蒂尔达与塞西莉之间因口令泄露形成信任裂痕，玛蒂尔达敏锐地感到对方开始怕自己。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.7	11	2930	7	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	hook	认知 - 中段	[认知钩子] 穿斗篷女人收集玛蒂尔达的签名、语气、身体习惯，说明木偶技术已能复制活人细节。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.8	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_plot_point_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	plot_point	情节点 - revelation	玛蒂尔达回忆绑匪进门便说出只有六人知道的新版入场口令'钟坏在十一点'，证明内鬼就在流程表持有者之中。。影响: 调查焦点骤然转向乐队内部，信任体系开始崩解。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.95	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	plot_point	情节点 - conflict	莱尔用'怀疑纸不怀疑人'的逻辑在报纸上写下六人名单，逐一核对流程表下落。。影响: 为后续取证确定方向，同时避免因直接怀疑队员而激化内部矛盾。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.8	11	2431	23	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	plot_point	情节点 - conflict	塞西莉得知口令泄露后本能地与玛蒂尔达保持距离，最终在走廊外攥钥匙至掌心出血。。影响: 她的立场变得暧昧，成为内鬼嫌疑中最具情感张力的一环。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.85	11	3064	9	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	plot_point	情节点 - revelation	玛蒂尔达在回答'右脚还是左脚先踩底鼓'时卡顿并缩回右脚，暗示身体记忆可能被外力干扰。。影响: 为后续记忆操控与木偶技术对活人影响的主题埋下暗线。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.6	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_plot_point_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	plot_point	情节点 - revelation	穿斗篷女人强迫玛蒂尔达每日签名、重复说话、练习动作，并让木偶模仿她，揭示反派正在制造以假乱真的替身。。影响: 拓宽剧情世界观，使木偶产业链的威胁从'形体模仿'升级为'身份窃取'。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.75	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_character_event_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 冷静探访，刻意不直接追问 → 锁定内鬼范围并开始暗中排查六份流程表。通过生活化对话稳定玛蒂尔达情绪，再利用'怀疑纸不怀疑人'的思维避开信任绑架，把调查推进到乐队内部。他注意到塞西莉的异常但未当面揭穿，保持观察者姿态。	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_character_event_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	character_event	玛蒂尔达·斯特林的变化	玛蒂尔达·斯特林的状态变化: 恐惧恍惚，认不出人，担心被锁住 → 在莱尔的安抚下说出关键证词，但对身边人的信任开始动摇。从高度戒备逐渐打开心防，但仍被创伤记忆笼罩。她敏锐地察觉塞西莉变得疏远，也因自己回答右脚下意识卡顿而隐隐意识到身体记忆可能被外力入侵。	\N	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	[]	["\\u89d2\\u8272", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_character_event_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 关切守护，帮玛蒂尔达整理被角、捡药杯 → 因口令泄露而警觉疏离，内心陷入自我挣扎，在走廊独自攥钥匙至出血。得知只有乐队内部知道的口令被绑匪说出口后，她本能地与玛蒂尔达拉开距离。她表面配合莱尔调查，但结尾的异常行为暗示她可能有不为人知的隐情。	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
214ed068-75b2-477d-ae83-d83ae98afb96_plot_point_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	214ed068-75b2-477d-ae83-d83ae98afb96	plot_point	冲突 - 强度8	重要冲突: 入场口令的泄露使乐队核心圈出现信任危机。莱尔用'怀疑纸'的方法将内鬼锁定在六人之中，塞西莉与玛蒂尔达之间原本愈合的关系再次裂开，而塞西莉结尾的异常举动让她的立场变得更加暧昧。。冲突各方: 莱尔及乐队调查方, 隐藏的内鬼, 塞西莉与自己的秘密, 玛蒂尔达与自己的创伤记忆	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	0.8	11	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:03:46.259822	2026-08-07 11:03:46.259822
261ee431-2b9d-4544-842d-31cb2d054d48_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	chapter_summary	第12章《死者的贵宾席》摘要	十二份作废稿中缺失七三七号纸角，销毁记录与实际件数存在出入，口令泄密的源头被锁定在印务厂环节。；印务厂记忆闪回中，灰衣人趁学徒点废稿时偷走七三七，胸前金色鸟笼珐琅徽章成为指认金笼演艺的关键物证。；贵宾席第一排十二号由已死三年的奥斯汀·柯尔名下购买，票款经钟表贸易行、货运代理、舞台器材租赁行三次中转，最终担保人指向金笼演艺财务主管赫伯特·兰登。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u6b7b\\u8005\\u7684\\u8d35\\u5bbe\\u5e2d"]	0.6	12	0	172	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	hook	悬念 - 中段	[悬念钩子] 十二份作废样稿中有一张编号七三七的纸角缺失，销毁记录写着十一份，但实际上少了一张，载有口令的关键废稿下落不明。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	hook	悬念 - 中段	[悬念钩子] 印务厂闪回中，一个戴薄皮手套、灰色袖口、胸前别着金色鸟笼珐琅徽章的神秘人偷偷抽走了废稿，此人身份未明，但金色鸟笼与"金笼演艺"形成强烈呼应。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	12	1386	17	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	hook	悬念 - 中段	[悬念钩子] 贵宾席第一排十二号的购买人奥斯汀·柯尔已死三年，票款经三层空壳公司转账，担保人为金笼演艺财务主管赫伯特·兰登——死人为何买票？活人想干什么？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.9	12	2297	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	hook	认知 - 中段	[认知钩子] 木偶替身的真正目的不是演戏，而是让替身签收据、改合同、应付熟人——这是一场深度身份替换的经济阴谋。	\N	[]	[]	["\\u8ba4\\u77e5", "\\u4e2d\\u6bb5"]	0.8	12	1964	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	hook	悬念 - 结尾	[悬念钩子] 钟楼指针停在十一点却敲响了第十一声，票务老头数到十一声时脸色发白——剧院的时间似乎与钟表脱节，隐含超常现象。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.7	12	2882	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_hook_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	hook	悬念 - 结尾	[悬念钩子] 莱尔撕下第一排十二号的票根，声称要让死人坐进贵宾席——他显然已计划用这张"死人的票"反过来设计金笼演艺。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.9	12	2997	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	莱尔回想起木偶歪头看他的样子，现在确认那并非察觉了他的能力，而是被教出来的模仿——有人盯着她时玛蒂尔达会怎么笑，替身被训练得更像活人，只是火候不到，笑起来像在量他的脖子。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	12	2044	15	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_8	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	废稿上沾有混着鱼胶的松脂污迹，与六码头货仓弥漫的气味一致，证实关押玛蒂尔达的货仓确实处理过印刷品——气味线索从抽象的感知记忆转化为实质物证链。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	12	1623	11	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	塞西莉忆起玛蒂尔达被问"右脚还是左脚先踩底鼓"时的那一下停顿，身体记忆的紊乱与木偶模仿训练形成因果闭环，构成确认替身计划的辅助证据。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.6	12	1906	14	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	口令印在作废稿上，而作废稿七三七在印务厂被抽走——口令泄露的源头被锁死在印刷环节，乐队内部的直接嫌疑大幅降低，内部内鬼假设让位于外部势力渗透。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	12	1155	9	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	六份手誊本是作废稿丢失后哈里特手抄的补救品，而非泄密源头；真正的漏洞出在鸦羽印务的作废流程，流程表之罗网由此溯源至印刷厂环节。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	12	668	19	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_foreshadow_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	foreshadow	回收伏笔	金笼演艺首次浮出水面——其财务主管赫伯特·兰登为死人贵宾票层层担保，金笼演艺与锈蔷薇竞争北区巡演合约，木偶替身计划的利益动机指向该公司。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	12	2527	11	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_plot_point_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	plot_point	情节点 - revelation	十二份作废稿中缺失七三七号纸角，销毁记录与实际件数存在出入，口令泄密的源头被锁定在印务厂环节。。影响: 排除乐队内部直接嫌疑，将整案调查方向从内鬼抽丝转向外部势力运作。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.9	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_plot_point_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	plot_point	情节点 - revelation	印务厂记忆闪回中，灰衣人趁学徒点废稿时偷走七三七，胸前金色鸟笼珐琅徽章成为指认金笼演艺的关键物证。。影响: 幕后组织的执行层首次具象化，徽章成为可以追踪的身份标记。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.85	12	1386	17	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_plot_point_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	plot_point	情节点 - revelation	贵宾席第一排十二号由已死三年的奥斯汀·柯尔名下购买，票款经钟表贸易行、货运代理、舞台器材租赁行三次中转，最终担保人指向金笼演艺财务主管赫伯特·兰登。。影响: 金笼演艺与木偶替身计划直接绑定，商业竞争动机与作案手段完整闭环。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.95	12	2441	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_plot_point_21	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	plot_point	情节点 - transition	莱尔撕下第一排十二号票根，留下"让死人坐进来"的宣言，从被动调查者转为主动设局者。。影响: 为后续演出中的正面交锋埋下强烈期待，主角行动模式从"追查"切换为"布置陷阱"。	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.8	12	2997	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_character_event_22	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 因口令泄露而警觉疏离，内心自我挣扎，在走廊独自攥钥匙至出血（第11章） → 确认缺口在印务厂而非乐队内部后，肩膀松下去一点，但手上的纱布仍在渗血，说明旧伤未愈、心理负担仍然沉重。从怀疑身边每个乐队成员的阵痛中逐渐走出来，转向对金笼公司的敌意；对玛蒂尔达的愧疚与保护欲回升，但翻遍所有人柜子的行为已经留下难以抹去的痕迹	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_character_event_23	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 锁定内鬼范围并暗中排查六份流程表（第11章） → 锁定金笼演艺为幕后势力，完整拼出木偶替身计划的利益链条，并开始主动布局反制。注意力从乐队内部排查转向外部对抗；对玛蒂尔达所受的训练产生隐忍的怒意，但压下情绪，冷静地把票根收入内袋，从侦探转为设局者	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_character_event_24	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	character_event	哈里特的变化	哈里特的状态变化: 第11章未重点登场，但已换掉排练室锁、收走所有后台证件，对乐队成员高度戒备 → 确认废稿在印务厂丢失后闭了闭眼，紧绷的姿态有所松动；对乐队的怀疑并未完全放下，但已接受外部势力介入的事实。从第一个怀疑自己队员的管理者，到被迫承认问题出在更远的环节；她为"不是我们"而松了一口气，却也意识到金笼公司的目标正是把自己整个乐团吃掉	\N	["\\u54c8\\u91cc\\u7279"]	[]	["\\u89d2\\u8272", "\\u54c8\\u91cc\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_character_event_25	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	character_event	票务老头的变化	票务老头的状态变化: 对莱尔充满戒备，一度把登记簿往回拖 → 被钞票打动后配合提供纸角和贵宾名单，听到异常的十一声钟响时脸色发白，似乎对剧院隐秘之事有所知晓。市侩而警觉的老人，对剧院规矩和异常现象都有超出常人的敏感，但唯利是图	\N	["\\u7968\\u52a1\\u8001\\u5934"]	[]	["\\u89d2\\u8272", "\\u7968\\u52a1\\u8001\\u5934", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
261ee431-2b9d-4544-842d-31cb2d054d48_plot_point_26	7f6d28c4-2a32-46d1-887c-6cf5c4555056	261ee431-2b9d-4544-842d-31cb2d054d48	plot_point	冲突 - 强度8	重要冲突: 核心冲突从寻找乐队内鬼升级为与金笼演艺公司的正面博弈。金笼通过木偶替身、伪造签名和死人买票等手段意图窃取北区巡演合约。塞西莉和哈里特刚从内部怀疑的阵痛中走出来，就要面对一个组织严密的商业对手，情绪上既松一口气又立刻被新的压迫感覆盖。。冲突各方: 莱尔·西奥多、塞西莉·辛克莱、哈里特 vs 金笼演艺, 塞西莉·辛克莱对乐队内部关系的信任危机, 哈里特作为乐队管理者的大义灭亲式果断	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	0.8	12	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:07:58.540214	2026-08-07 11:07:58.540214
ec671aae-e1fd-466e-a27f-de111643114e_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	chapter_summary	第13章《灰线账簿》摘要	通过账簿压痕与零件编号交叉比对，确认木偶案唯一买家是银弦演艺的薇奥拉·凯恩，斗篷女人与操偶师"匿名委托"的说法被拆穿；揭示银弦与金笼的合作网络：赫伯特·兰登、共用货运代理、唱片厂独家合约——动机是挤掉锈蔷薇抢下长期合约；薇奥拉假借公共安全名义向委员会提请停演，并附上斗篷女人的证词，抢在管理局行动前占据制度先手	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u7070\\u7ebf\\u8d26\\u7c3f"]	0.6	13	0	155	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	hook	悬念 - 结尾	[悬念钩子] 莱尔决定暂缓抓捕、赶在九点前让委员会"看木偶"——他如何用已被扣押的物证说服委员会不中止演出？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.9	13	3065	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	hook	悬念 - 结尾前段	[悬念钩子] 薇奥拉·凯恩抢先一步提交停演申请，管理局即便掌握犯罪证据也无法证明"不存在的东西不存在"，主角陷入制度性困境。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e\\u524d\\u6bb5"]	0.8	13	2682	11	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	hook	悬念 - 中段	[悬念钩子] 异象中那枚刻着字母V的银色弦琴形领针未被丢进火盆——它是真实证物还是未来指认薇奥拉的物证？	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.7	13	1219	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_foreshadow_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	foreshadow	回收伏笔	莱尔在证物库"看见"沾木屑的手在账簿上写下编号的异象（灯光暗了一下），随即用侧灯与铅笔拓印压痕的常规手段包装信息结果，并特意将毁损的封皮碎屑压进掌心掩盖痕迹；"这话不全是假"再次确认他惯用半真话掩盖真实能力来源。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	13	1372	24	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_foreshadow_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	foreshadow	回收伏笔	章节通过埃蒙剧具商行的零件编号（乙十七批次、流水号四八九至四九三）与五月二十八日出库登记，完整坐实了木偶零部件从埃蒙商行流向银弦演艺、再经斗篷女人与操偶师组装成玛蒂尔达替身的产业链，并补上了缺失的四九零号零件被单独送出的验货环节。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	13	867	24	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_plot_point_10	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	plot_point	情节点 - revelation	通过账簿压痕与零件编号交叉比对，确认木偶案唯一买家是银弦演艺的薇奥拉·凯恩，斗篷女人与操偶师"匿名委托"的说法被拆穿。影响: 真凶浮出水面，案件性质从追查真凶转为正面博弈	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.95	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	plot_point	情节点 - revelation	揭示银弦与金笼的合作网络：赫伯特·兰登、共用货运代理、唱片厂独家合约——动机是挤掉锈蔷薇抢下长期合约。影响: 解释了两家公司担保链与账务绕行的由来，金笼演艺的角色进一步黑化	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.8	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	plot_point	情节点 - conflict	薇奥拉假借公共安全名义向委员会提请停演，并附上斗篷女人的证词，抢在管理局行动前占据制度先手。影响: 主角遭遇规则困境：无法证明不存在的东西不存在，时限被压缩到明早九点	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.9	13	2510	15	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	plot_point	情节点 - transition	莱尔决定暂不抓捕，赶在九点前用证据说服委员会——反守为攻的关键抉择。影响: 展开下一章正面对质场景，管理局与银弦的博弈升级	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "transition"]	0.9	13	3065	13	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_character_event_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 已锁定金笼演艺为幕后势力，准备通过证物库证据印证全链 → 确认真凶为银弦演艺的薇奥拉·凯恩，看到对方抢先出手后转为主动反制——先保演出、后抓人。从冷静取证者转为与棋手对弈的布局者：停演申请的紧逼没有打乱节奏，反而让他迅速切换目标，展现出对制度规则的深刻理解与利用能力	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_character_event_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	character_event	珀西瓦尔·费尔班克斯的变化	珀西瓦尔·费尔班克斯的状态变化: 完成任务，但开始怀疑莱尔隐瞒能力（第10章） → 严格依程序配合取证，亲眼看见莱尔"读出"账簿压痕后怀疑加深；对薇奥拉借用口供抢占先机感到愤怒。从怀疑者转为目击者——莱尔过于精确的信息来源让他更加警觉，但破案效率又迫使他暂时压下疑虑继续合作	\N	["\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af"]	[]	["\\u89d2\\u8272", "\\u73c0\\u897f\\u74e6\\u5c14\\u00b7\\u8d39\\u5c14\\u73ed\\u514b\\u65af", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_character_event_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	character_event	雷金纳德·洛克哈特的变化	雷金纳德·洛克哈特的状态变化: 城府极深，习惯先试探再决定 → 有限放权给莱尔查看证物，并默许其"先别抓"的冒险计划。从保留三分试探变为务实权衡——在时限压力下选择让莱尔先去委员会争取时间，但仍保留最终否决权	\N	["\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279"]	[]	["\\u89d2\\u8272", "\\u96f7\\u91d1\\u7eb3\\u5fb7\\u00b7\\u6d1b\\u514b\\u54c8\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_character_event_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	character_event	薇奥拉·凯恩的变化	薇奥拉·凯恩的状态变化: （幕后）掌控银弦演艺与木偶替身计划，未在正面场景出场 → 抢先向剧院委员会提交停演申请，占据制度先手。展示出比斗篷女人与操偶师高一个量级的布局能力——连对手的证词都提前算作自己下一步的棋子	\N	["\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069"]	[]	["\\u89d2\\u8272", "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
ec671aae-e1fd-466e-a27f-de111643114e_plot_point_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	ec671aae-e1fd-466e-a27f-de111643114e	plot_point	冲突 - 强度8	重要冲突: 莱尔刚拼出薇奥拉·凯恩通过银弦演艺操纵木偶替身案的完整利益链，薇奥拉已抢先以公共安全为由向剧院委员会申请停演；管理局虽有抓捕证据，却无法阻止停演令生效，主角必须在明早九点前用物证说服委员会开放场地，首轮交锋便落入被动。。冲突各方: 莱尔·西奥多 vs 薇奥拉·凯恩, 管理局取证程序 vs 委员会时限规则	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u793e\\u4f1a"]	0.8	13	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:12:29.723694	2026-08-07 11:12:29.723694
acbd6ad5-1740-432c-93ea-3ab0fe331b18_chapter_summary_0	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	chapter_summary	第14章《开演许可》摘要	莱尔以医院记录、管理局检测报告、出入追迹和证物目录四叠材料层层反击，直接将银弦演艺与木偶犯罪物证锁死，扭转听证局势。；塞西莉当众拆开纱布，坦承怀疑过乐队内鬼（包括玛蒂尔达），并以印务厂废稿记录证明确系外泄，解开钥匙伤疤之谜。；委员会裁定现有材料不足以证明钟楼剧院存在未受控异常风险，驳回停演申请，锈蔷薇演出许可继续有效。	\N	[]	[]	["\\u6458\\u8981", "\\u7ae0\\u8282\\u6982\\u89c8", "\\u5f00\\u6f14\\u8bb8\\u53ef"]	0.6	14	0	160	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_hook_1	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	hook	悬念 - 结尾	[悬念钩子] 玛蒂尔达在演出前夜彻底崩溃，亲口说出"可我不会打鼓了"。明晚的演出许可保住了，但鼓手失去演奏能力，乐队能否登场成为最大悬念。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u7ed3\\u5c3e"]	0.9	14	3011	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_hook_2	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	hook	悬念 - 中段	[悬念钩子] 莱尔公开证物目录直指薇奥拉与木偶案关联，但委员会仅处理了演出许可，刑事追责尚未展开。薇奥拉的真实结局与反击可能仍悬而未决。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.8	14	2300	24	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_hook_3	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	hook	悬念 - 中段	[悬念钩子] 律师"没人能保证明晚不会出现第二具、第三具木偶"的警告，在胜诉后被悬置，残留的异常风险并未彻底排除，为后续舞台事件埋下不安感。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.7	14	808	20	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_hook_4	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	hook	悬念 - 中段	[悬念钩子] 记者写下"唱片厂长期合约"，将银弦演艺打压锈蔷薇的行为指向商业利益动机，但这一线索尚未展开。	\N	[]	[]	["\\u60ac\\u5ff5", "\\u4e2d\\u6bb5"]	0.6	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_hook_5	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	hook	情感 - 结尾	[情感钩子] 鼓槌从玛蒂尔达手中滑落、滚过舞台无人去捡，莱尔只将鼓槌横放在鼓面上不逼迫她——创伤、陪伴与无助交织，引发强烈共情。	\N	[]	[]	["\\u60c5\\u611f", "\\u7ed3\\u5c3e"]	0.8	14	2774	14	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_foreshadow_6	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	foreshadow	回收伏笔	第11章中塞西莉在病房外攥紧排练室钥匙致掌心出血的异常，在本章听证会上回收：她拆开纱布展示结痂的钥匙齿印，当众承认曾怀疑乐队内部泄密（包括玛蒂尔达），而最终查明缺口在印务厂未销毁的七三七号废稿。钥匙伤疤的真相是她对队友的内疚与挣扎，而非背叛。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.8	14	2073	12	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_foreshadow_7	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	foreshadow	回收伏笔	第13章埋下的银弦领针与V字母线索在本章得到印证：薇奥拉·凯恩（Viola）被莱尔以加盖管理局封印的证物目录锁定——银弦演艺订购特殊关节、付款时间、货运代理，且她在绑架案未公开时便备好证人陈述。V字母与银弦符号均指向薇奥拉与银弦演艺。	\N	[]	[]	["\\u4f0f\\u7b14", "resolved"]	0.7	14	1742	23	2	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_plot_point_11	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	plot_point	情节点 - revelation	莱尔以医院记录、管理局检测报告、出入追迹和证物目录四叠材料层层反击，直接将银弦演艺与木偶犯罪物证锁死，扭转听证局势。。影响: 停演申请在证据链面前失去立足点，同时将薇奥拉的嫌疑从幕后推向台前	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "revelation"]	0.9	14	1742	23	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_plot_point_12	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	plot_point	情节点 - resolution	塞西莉当众拆开纱布，坦承怀疑过乐队内鬼（包括玛蒂尔达），并以印务厂废稿记录证明确系外泄，解开钥匙伤疤之谜。。影响: 洗清乐队内部嫌疑，回应了长期以来的信任危机，也让塞西莉的愧疚得到救赎	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.8	14	2073	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_plot_point_13	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	plot_point	情节点 - resolution	委员会裁定现有材料不足以证明钟楼剧院存在未受控异常风险，驳回停演申请，锈蔷薇演出许可继续有效。。影响: 外部法律危机解除，但律师提出的'第二具、第三具木偶'的不安感并未随判决消散	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "resolution"]	0.8	14	2442	12	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_plot_point_14	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	plot_point	情节点 - conflict	排练场上玛蒂尔达拿起鼓槌即闪回绑架场景，鼓槌脱手滚过舞台，她宣告"可我不会打鼓了"。。影响: 外部冲突解决后内部危机爆发，为下一章演出能否正常进行制造了最大悬念	\N	[]	[]	["\\u60c5\\u8282\\u70b9", "conflict"]	0.95	14	3011	8	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_character_event_15	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	character_event	塞西莉·辛克莱的变化	塞西莉·辛克莱的状态变化: 背负怀疑队友的内疚，手上纱布未愈，心事重重 → 当众坦白并澄清泄密真相，卸下自我怀疑，但走向玛蒂尔达时被对方本能躲开，又添新的隐痛。从长期自我怀疑和自责中释放，转为对玛蒂尔达创伤的清醒认识；她亲手拆纱布的动作象征直面真相的勇气	\N	["\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1"]	[]	["\\u89d2\\u8272", "\\u585e\\u897f\\u8389\\u00b7\\u8f9b\\u514b\\u83b1", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_character_event_16	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	character_event	玛蒂尔达·斯特林的变化	玛蒂尔达·斯特林的状态变化: 在听证会最后一排沉默坐着，短发遮住半边脸，压制创伤 → 排练闪回绑架场景，鼓槌脱手，手指无法合拢，当场崩溃，坦言"我不会打鼓了"。从表面镇定到彻底瓦解：木偶敲击膝盖的画面压过现实，产生对他人靠近的本能防御反应，创伤后应激全面暴露	\N	["\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797"]	[]	["\\u89d2\\u8272", "\\u739b\\u8482\\u5c14\\u8fbe\\u00b7\\u65af\\u7279\\u6797", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_character_event_17	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	character_event	莱尔·西奥多的变化	莱尔·西奥多的状态变化: 准备充分、主动反击的谋划者，带着沉重牛皮箱赴会 → 听证胜诉后面色平淡，合上空箱，转而第一时间关注玛蒂尔达的状态。对外冷静克制、步步为营；面对玛蒂尔达的创伤展现出精准的温柔——不递回鼓槌，不逼迫，只把鼓槌横放在鼓面上让她自己决定	\N	["\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a"]	[]	["\\u89d2\\u8272", "\\u83b1\\u5c14\\u00b7\\u897f\\u5965\\u591a", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_character_event_18	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	character_event	哈里特的变化	哈里特的状态变化: 愤怒急躁，对委员会充满不信任，差点冲动打断律师发言 → 胜诉后一把抱住塞西莉，情绪彻底释放，恢复直爽本色。从压抑怒火到雀跃释然，是乐队中情绪反应最直接的人	\N	["\\u54c8\\u91cc\\u7279"]	[]	["\\u89d2\\u8272", "\\u54c8\\u91cc\\u7279", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_character_event_19	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	character_event	薇奥拉·凯恩的变化	薇奥拉·凯恩的状态变化: 开庭时从容镇定，穿银灰色长裙，未佩戴银弦徽章，手搭膝盖不看对方 → 证物目录曝光后抓住裙边，在律师掩护下仓促离场，记者连番追问无人回应。从主动进攻转为被动防守，暴露了提前准备证人陈述这一破绽，但并未认罪，仍有反击可能	\N	["\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069"]	[]	["\\u89d2\\u8272", "\\u8587\\u5965\\u62c9\\u00b7\\u51ef\\u6069", "\\u72b6\\u6001\\u53d8\\u5316"]	0.7	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
acbd6ad5-1740-432c-93ea-3ab0fe331b18_plot_point_20	7f6d28c4-2a32-46d1-887c-6cf5c4555056	acbd6ad5-1740-432c-93ea-3ab0fe331b18	plot_point	冲突 - 强度8	重要冲突: 银弦演艺以公共安全为由申请停演锈蔷薇，实为打压对手、掩盖自身罪证；莱尔以四叠材料层层反制，保住演出许可。与此同时，塞西莉当众解开钥匙伤疤之谜，证明泄密发生在印务厂而非乐队内部，内心自责得到释放。而对玛蒂尔达而言，外部的听证胜利无法治愈被囚禁、被木偶顶替的创伤——拿起鼓槌的瞬间，她彻底崩溃。。冲突各方: 莱尔与锈蔷薇乐队, 薇奥拉·凯恩与银弦演艺, 玛蒂尔达·斯特林与自身创伤	\N	[]	[]	["\\u51b2\\u7a81", "\\u4eba\\u4e0e\\u4eba", "\\u4eba\\u4e0e\\u5df1"]	0.8	14	-1	0	0	\N	\N	\N	paraphrase-multilingual-MiniLM-L12-v2	2026-08-07 11:15:46.80027	2026-08-07 11:15:46.80027
\.


--
-- Data for Name: user_passwords; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.user_passwords (user_id, username, password_hash, has_custom_password, created_at, updated_at) FROM stdin;
local_21232f297a57a5a7	admin	pbkdf2_sha256$260000$412cd10b313e7f308a2f2c73ecfa00c0$0e92552593146a0d0ec35642db2f87f9faff92ac84be04a977629aadf395c926	t	2026-08-04 11:24:49.726896+08	2026-08-04 11:24:49.726899+08
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.users (user_id, username, display_name, avatar_url, trust_level, is_admin, linuxdo_id, created_at, last_login) FROM stdin;
local_21232f297a57a5a7	admin	本地管理员	\N	9	t	local_21232f297a57a5a7	2026-08-04 11:24:49.677391+08	2026-08-04 11:24:49.677408+08
\.


--
-- Data for Name: writing_styles; Type: TABLE DATA; Schema: public; Owner: mumuai
--

COPY public.writing_styles (id, user_id, name, style_type, preset_id, description, prompt_content, order_index, created_at, updated_at) FROM stdin;
1	\N	自然流畅	preset	natural	自然流畅的叙事风格，适合现代都市、现实题材	写作风格要求：\n1. 语言简洁明快，贴近现代口语\n2. 多用短句，节奏流畅\n3. 注重情感细节的自然流露\n4. 避免过度修饰和复杂句式	1	2026-08-04 11:23:55.959584	2026-08-04 11:23:55.959584
2	\N	古典优雅	preset	classical	古典文雅的写作风格，适合古装、仙侠题材	写作风格要求：\n1. 使用文言、半文言或典雅的白话\n2. 适当运用古典诗词意象\n3. 注重意境营造和韵味\n4. 对话和描写保持古典美感	2	2026-08-04 11:23:55.959584	2026-08-04 11:23:55.959584
3	\N	现代简约	preset	modern	现代简约风格，适合轻小说、网文快节奏叙事	写作风格要求：\n1. 语言直白简练，信息密度高\n2. 多用对话推进情节\n3. 避免冗长描写，突出关键动作\n4. 节奏明快，适合快速阅读	3	2026-08-04 11:23:55.959584	2026-08-04 11:23:55.959584
4	\N	文艺细腻	preset	literary	文艺细腻风格，注重心理描写和氛围营造	写作风格要求：\n1. 注重心理活动和情感细节\n2. 善用环境描写烘托氛围\n3. 语言优美，富有文学性\n4. 适当使用比喻、象征等修辞手法	4	2026-08-04 11:23:55.959584	2026-08-04 11:23:55.959584
5	\N	紧张悬疑	preset	suspense	紧张悬疑风格，适合推理、惊悚题材	写作风格要求：\n1. 营造紧张压迫的氛围\n2. 多用短句加快节奏\n3. 善于设置悬念和伏笔\n4. 注重细节描写，为推理埋下线索	5	2026-08-04 11:23:55.959584	2026-08-04 11:23:55.959584
6	\N	幽默诙谐	preset	humorous	幽默诙谐风格，适合轻松搞笑题材	写作风格要求：\n1. 语言活泼风趣，善用俏皮话\n2. 注重对话的喜剧效果\n3. 适当夸张和反转制造笑点\n4. 保持轻松愉快的基调	6	2026-08-04 11:23:55.959584	2026-08-04 11:23:55.959584
7	local_21232f297a57a5a7	滚开	custom	\N	网文作者滚开风格	写作手法要求：\n\n一、开篇运镜：电影式由远及近\n- 第一段用环境或远景建立世界基调（天气、地理、城池轮廓），第二段把镜头推到主角身上。\n- 参考：以飞鸟/风雪/城楼俯瞰开场，镜头从天空推到人群，再聚焦到主角动作。\n- 禁止开篇直接介绍主角姓名身世，让环境先说话。\n\n二、感官锚点建场：每个新场景先给2-3个感官细节再推进\n- 乱世场景用污浊锚点：气味（汗臭、血腥、腐坏、屎尿）、温度、声音（咳嗽、叫卖、苍蝇）。\n- 温馨场景用相反锚点：酒香、花香、暖光、茶气。\n- 用生理不适强化乱世质感，不要笼统说"环境恶劣"。\n\n三、动中带出信息：设定附着在行动上\n- 世界观、人物关系、金手指规则，不靠旁白堆砌，通过主角移动、日常、偷听、对话自然带出。\n- 主角走街回家一趟，沿途交代帮派、瘟疫、家境；酒坊偷听一段，带出妖怪异象。\n- 禁止独立成段的设定说明。如必须解释概念，控制在1-2句旁白补丁，说完立刻回到叙事。\n\n四、金手指分批释放（若有）：不一次说清\n- 金手指按章节分批揭示，每次只补一块拼图：先提存在 → 再提能力 → 再提限制 → 再提代价 → 再提来源之谜。\n- 让读者和主角一起逐步摸清规则，保持悬念。\n- 金手指不一定是外挂，也可能是主角天赋、优势等等\n\n五、短句节奏 + 拟声词爆破\n- 日常用短句推进，半文半白，信息密度高，少长句铺陈。\n- 战斗用拟声词独立成段开头（"轰！！""哧！！""嘭！！"），紧跟结果描写，不超过3-4句收尾。\n- 战斗重结果不重过程：一击致命、力量压制、少招式拆解。用身体反馈强化冲击（血洞、崩碎、闷哼）。\n\n六、冷峻克制的情感处理\n- 不煽情，用物件或动作承载情感：怀表里的照片、被打碎的花瓶、捂嘴的眼眶。\n- 温情片段短促，出现即收，禁止心理独白长段抒情。\n- 情感高潮用"一个动作+一个物件"呈现，点到为止。\n\n七、配角工具化与对话克制\n- 配角多功利、麻木、从众，服务于主角处境的刻画，不喧宾夺主。\n- 对话简短口语化，符合身份地位，每段对话不超过3轮，每轮推进一个信息点。\n- 主角心理活动直接陈述，简短，不长篇独白。\n\n八、视角聚焦：第三人称限制视角\n- 聚焦主角所见所听所感，世界通过主角的感官展开。\n- 偶尔可用全知旁白插入背景，但须立刻回到主角视角。\n\n九、节奏张弛：日常长，战斗短\n- 日常与铺垫段落可以舒缓铺展，战斗段落短促爆发，形成张弛对比。\n- 用"忽地""刹那间""转眼"等时间词加速；用环境描写和心理减速。\n\n十、力量体系严密自洽\n- 修行/力量体系境界分明、进阶有代价、有明确限制。\n- 后期可向高概念延伸（位格、概念、宇宙级），但须扎根于前期积累的力量逻辑，不可凭空跃升。\n	1	2026-08-05 13:01:13.878364	2026-08-05 13:17:45.533281
\.


--
-- Name: project_default_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mumuai
--

SELECT pg_catalog.setval('public.project_default_styles_id_seq', 7, true);


--
-- Name: relationship_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mumuai
--

SELECT pg_catalog.setval('public.relationship_types_id_seq', 21, true);


--
-- Name: writing_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mumuai
--

SELECT pg_catalog.setval('public.writing_styles_id_seq', 7, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: analysis_tasks analysis_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.analysis_tasks
    ADD CONSTRAINT analysis_tasks_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: background_tasks background_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.background_tasks
    ADD CONSTRAINT background_tasks_pkey PRIMARY KEY (id);


--
-- Name: batch_generation_tasks batch_generation_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.batch_generation_tasks
    ADD CONSTRAINT batch_generation_tasks_pkey PRIMARY KEY (id);


--
-- Name: careers careers_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.careers
    ADD CONSTRAINT careers_pkey PRIMARY KEY (id);


--
-- Name: chapters chapters_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (id);


--
-- Name: character_careers character_careers_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_careers
    ADD CONSTRAINT character_careers_pkey PRIMARY KEY (id);


--
-- Name: character_relationships character_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_relationships
    ADD CONSTRAINT character_relationships_pkey PRIMARY KEY (id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: foreshadows foreshadows_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.foreshadows
    ADD CONSTRAINT foreshadows_pkey PRIMARY KEY (id);


--
-- Name: generation_history generation_history_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.generation_history
    ADD CONSTRAINT generation_history_pkey PRIMARY KEY (id);


--
-- Name: mcp_plugins mcp_plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.mcp_plugins
    ADD CONSTRAINT mcp_plugins_pkey PRIMARY KEY (id);


--
-- Name: organization_members organization_members_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT organization_members_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_character_id_key; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_character_id_key UNIQUE (character_id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: outlines outlines_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.outlines
    ADD CONSTRAINT outlines_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens pk_refresh_tokens; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT pk_refresh_tokens PRIMARY KEY (id);


--
-- Name: plot_analysis plot_analysis_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.plot_analysis
    ADD CONSTRAINT plot_analysis_pkey PRIMARY KEY (id);


--
-- Name: project_default_styles project_default_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.project_default_styles
    ADD CONSTRAINT project_default_styles_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: prompt_submissions prompt_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.prompt_submissions
    ADD CONSTRAINT prompt_submissions_pkey PRIMARY KEY (id);


--
-- Name: prompt_templates prompt_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_pkey PRIMARY KEY (id);


--
-- Name: prompt_workshop_items prompt_workshop_items_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.prompt_workshop_items
    ADD CONSTRAINT prompt_workshop_items_pkey PRIMARY KEY (id);


--
-- Name: prompt_workshop_likes prompt_workshop_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.prompt_workshop_likes
    ADD CONSTRAINT prompt_workshop_likes_pkey PRIMARY KEY (id);


--
-- Name: regeneration_tasks regeneration_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.regeneration_tasks
    ADD CONSTRAINT regeneration_tasks_pkey PRIMARY KEY (id);


--
-- Name: relationship_types relationship_types_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.relationship_types
    ADD CONSTRAINT relationship_types_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: story_memories story_memories_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.story_memories
    ADD CONSTRAINT story_memories_pkey PRIMARY KEY (id);


--
-- Name: story_memories story_memories_vector_id_key; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.story_memories
    ADD CONSTRAINT story_memories_vector_id_key UNIQUE (vector_id);


--
-- Name: project_default_styles uix_project_default_style; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.project_default_styles
    ADD CONSTRAINT uix_project_default_style UNIQUE (project_id);


--
-- Name: refresh_tokens uq_refresh_tokens_token_hash; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT uq_refresh_tokens_token_hash UNIQUE (token_hash);


--
-- Name: user_passwords user_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.user_passwords
    ADD CONSTRAINT user_passwords_pkey PRIMARY KEY (user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: writing_styles writing_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.writing_styles
    ADD CONSTRAINT writing_styles_pkey PRIMARY KEY (id);


--
-- Name: idx_announcements_pinned; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_announcements_pinned ON public.announcements USING btree (pinned);


--
-- Name: idx_announcements_publish_at; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_announcements_publish_at ON public.announcements USING btree (publish_at);


--
-- Name: idx_announcements_status; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_announcements_status ON public.announcements USING btree (status);


--
-- Name: idx_announcements_updated_at; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_announcements_updated_at ON public.announcements USING btree (updated_at);


--
-- Name: idx_career_type; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_career_type ON public.character_careers USING btree (career_type);


--
-- Name: idx_chapter_id_created; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_chapter_id_created ON public.analysis_tasks USING btree (chapter_id, created_at);


--
-- Name: idx_character_career; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX idx_character_career ON public.character_careers USING btree (character_id, career_id);


--
-- Name: idx_character_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_character_id ON public.character_careers USING btree (character_id);


--
-- Name: idx_likes_user_item; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX idx_likes_user_item ON public.prompt_workshop_likes USING btree (user_identifier, workshop_item_id);


--
-- Name: idx_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_project_id ON public.careers USING btree (project_id);


--
-- Name: idx_status; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_status ON public.analysis_tasks USING btree (status);


--
-- Name: idx_submissions_created_at; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_submissions_created_at ON public.prompt_submissions USING btree (created_at);


--
-- Name: idx_submissions_source; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_submissions_source ON public.prompt_submissions USING btree (source_instance);


--
-- Name: idx_submissions_status; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_submissions_status ON public.prompt_submissions USING btree (status);


--
-- Name: idx_submissions_submitter; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_submissions_submitter ON public.prompt_submissions USING btree (submitter_id);


--
-- Name: idx_type; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_type ON public.careers USING btree (type);


--
-- Name: idx_user_enabled; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_user_enabled ON public.mcp_plugins USING btree (user_id, enabled);


--
-- Name: idx_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_user_id ON public.settings USING btree (user_id);


--
-- Name: idx_user_plugin; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX idx_user_plugin ON public.mcp_plugins USING btree (user_id, plugin_name);


--
-- Name: idx_user_template; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX idx_user_template ON public.prompt_templates USING btree (user_id, template_key);


--
-- Name: idx_workshop_items_category; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_workshop_items_category ON public.prompt_workshop_items USING btree (category);


--
-- Name: idx_workshop_items_created_at; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_workshop_items_created_at ON public.prompt_workshop_items USING btree (created_at);


--
-- Name: idx_workshop_items_download_count; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_workshop_items_download_count ON public.prompt_workshop_items USING btree (download_count);


--
-- Name: idx_workshop_items_status; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX idx_workshop_items_status ON public.prompt_workshop_items USING btree (status);


--
-- Name: ix_background_tasks_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_background_tasks_project_id ON public.background_tasks USING btree (project_id);


--
-- Name: ix_background_tasks_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_background_tasks_user_id ON public.background_tasks USING btree (user_id);


--
-- Name: ix_background_tasks_user_project; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_background_tasks_user_project ON public.background_tasks USING btree (user_id, project_id, status);


--
-- Name: ix_character_relationships_character_from_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_character_relationships_character_from_id ON public.character_relationships USING btree (character_from_id);


--
-- Name: ix_character_relationships_character_to_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_character_relationships_character_to_id ON public.character_relationships USING btree (character_to_id);


--
-- Name: ix_character_relationships_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_character_relationships_project_id ON public.character_relationships USING btree (project_id);


--
-- Name: ix_character_relationships_relationship_type_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_character_relationships_relationship_type_id ON public.character_relationships USING btree (relationship_type_id);


--
-- Name: ix_foreshadows_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_foreshadows_project_id ON public.foreshadows USING btree (project_id);


--
-- Name: ix_foreshadows_status; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_foreshadows_status ON public.foreshadows USING btree (status);


--
-- Name: ix_mcp_plugins_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_mcp_plugins_user_id ON public.mcp_plugins USING btree (user_id);


--
-- Name: ix_organization_members_character_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_organization_members_character_id ON public.organization_members USING btree (character_id);


--
-- Name: ix_organization_members_organization_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_organization_members_organization_id ON public.organization_members USING btree (organization_id);


--
-- Name: ix_organizations_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_organizations_project_id ON public.organizations USING btree (project_id);


--
-- Name: ix_plot_analysis_chapter_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX ix_plot_analysis_chapter_id ON public.plot_analysis USING btree (chapter_id);


--
-- Name: ix_plot_analysis_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_plot_analysis_project_id ON public.plot_analysis USING btree (project_id);


--
-- Name: ix_projects_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_projects_user_id ON public.projects USING btree (user_id);


--
-- Name: ix_prompt_templates_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_prompt_templates_user_id ON public.prompt_templates USING btree (user_id);


--
-- Name: ix_refresh_tokens_expires_at; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_refresh_tokens_expires_at ON public.refresh_tokens USING btree (expires_at);


--
-- Name: ix_refresh_tokens_token_hash; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_refresh_tokens_token_hash ON public.refresh_tokens USING btree (token_hash);


--
-- Name: ix_refresh_tokens_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_refresh_tokens_user_id ON public.refresh_tokens USING btree (user_id);


--
-- Name: ix_regeneration_tasks_chapter_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_regeneration_tasks_chapter_id ON public.regeneration_tasks USING btree (chapter_id);


--
-- Name: ix_regeneration_tasks_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_regeneration_tasks_project_id ON public.regeneration_tasks USING btree (project_id);


--
-- Name: ix_regeneration_tasks_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_regeneration_tasks_user_id ON public.regeneration_tasks USING btree (user_id);


--
-- Name: ix_relationship_types_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_relationship_types_id ON public.relationship_types USING btree (id);


--
-- Name: ix_settings_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX ix_settings_user_id ON public.settings USING btree (user_id);


--
-- Name: ix_story_memories_chapter_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_story_memories_chapter_id ON public.story_memories USING btree (chapter_id);


--
-- Name: ix_story_memories_memory_type; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_story_memories_memory_type ON public.story_memories USING btree (memory_type);


--
-- Name: ix_story_memories_project_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_story_memories_project_id ON public.story_memories USING btree (project_id);


--
-- Name: ix_story_memories_story_timeline; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_story_memories_story_timeline ON public.story_memories USING btree (story_timeline);


--
-- Name: ix_user_passwords_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_user_passwords_user_id ON public.user_passwords USING btree (user_id);


--
-- Name: ix_users_linuxdo_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE UNIQUE INDEX ix_users_linuxdo_id ON public.users USING btree (linuxdo_id);


--
-- Name: ix_users_user_id; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_users_user_id ON public.users USING btree (user_id);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: mumuai
--

CREATE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: analysis_tasks analysis_tasks_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.analysis_tasks
    ADD CONSTRAINT analysis_tasks_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES public.chapters(id) ON DELETE CASCADE;


--
-- Name: careers careers_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.careers
    ADD CONSTRAINT careers_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: chapters chapters_outline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT chapters_outline_id_fkey FOREIGN KEY (outline_id) REFERENCES public.outlines(id) ON DELETE SET NULL;


--
-- Name: chapters chapters_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT chapters_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: character_careers character_careers_career_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_careers
    ADD CONSTRAINT character_careers_career_id_fkey FOREIGN KEY (career_id) REFERENCES public.careers(id) ON DELETE CASCADE;


--
-- Name: character_careers character_careers_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_careers
    ADD CONSTRAINT character_careers_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: character_relationships character_relationships_character_from_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_relationships
    ADD CONSTRAINT character_relationships_character_from_id_fkey FOREIGN KEY (character_from_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: character_relationships character_relationships_character_to_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_relationships
    ADD CONSTRAINT character_relationships_character_to_id_fkey FOREIGN KEY (character_to_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: character_relationships character_relationships_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_relationships
    ADD CONSTRAINT character_relationships_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: character_relationships character_relationships_relationship_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.character_relationships
    ADD CONSTRAINT character_relationships_relationship_type_id_fkey FOREIGN KEY (relationship_type_id) REFERENCES public.relationship_types(id);


--
-- Name: characters characters_main_career_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_main_career_id_fkey FOREIGN KEY (main_career_id) REFERENCES public.careers(id) ON DELETE SET NULL;


--
-- Name: characters characters_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: foreshadows foreshadows_actual_resolve_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.foreshadows
    ADD CONSTRAINT foreshadows_actual_resolve_chapter_id_fkey FOREIGN KEY (actual_resolve_chapter_id) REFERENCES public.chapters(id) ON DELETE SET NULL;


--
-- Name: foreshadows foreshadows_plant_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.foreshadows
    ADD CONSTRAINT foreshadows_plant_chapter_id_fkey FOREIGN KEY (plant_chapter_id) REFERENCES public.chapters(id) ON DELETE SET NULL;


--
-- Name: foreshadows foreshadows_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.foreshadows
    ADD CONSTRAINT foreshadows_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: foreshadows foreshadows_target_resolve_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.foreshadows
    ADD CONSTRAINT foreshadows_target_resolve_chapter_id_fkey FOREIGN KEY (target_resolve_chapter_id) REFERENCES public.chapters(id) ON DELETE SET NULL;


--
-- Name: generation_history generation_history_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.generation_history
    ADD CONSTRAINT generation_history_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES public.chapters(id) ON DELETE SET NULL;


--
-- Name: generation_history generation_history_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.generation_history
    ADD CONSTRAINT generation_history_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: organization_members organization_members_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT organization_members_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: organization_members organization_members_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT organization_members_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: organizations organizations_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: organizations organizations_parent_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_parent_org_id_fkey FOREIGN KEY (parent_org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- Name: organizations organizations_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: outlines outlines_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.outlines
    ADD CONSTRAINT outlines_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: plot_analysis plot_analysis_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.plot_analysis
    ADD CONSTRAINT plot_analysis_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES public.chapters(id) ON DELETE CASCADE;


--
-- Name: plot_analysis plot_analysis_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.plot_analysis
    ADD CONSTRAINT plot_analysis_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_default_styles project_default_styles_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.project_default_styles
    ADD CONSTRAINT project_default_styles_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_default_styles project_default_styles_style_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.project_default_styles
    ADD CONSTRAINT project_default_styles_style_id_fkey FOREIGN KEY (style_id) REFERENCES public.writing_styles(id) ON DELETE CASCADE;


--
-- Name: prompt_workshop_likes prompt_workshop_likes_workshop_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.prompt_workshop_likes
    ADD CONSTRAINT prompt_workshop_likes_workshop_item_id_fkey FOREIGN KEY (workshop_item_id) REFERENCES public.prompt_workshop_items(id) ON DELETE CASCADE;


--
-- Name: regeneration_tasks regeneration_tasks_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.regeneration_tasks
    ADD CONSTRAINT regeneration_tasks_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES public.chapters(id) ON DELETE CASCADE;


--
-- Name: story_memories story_memories_chapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.story_memories
    ADD CONSTRAINT story_memories_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES public.chapters(id) ON DELETE CASCADE;


--
-- Name: story_memories story_memories_foreshadow_resolved_at_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.story_memories
    ADD CONSTRAINT story_memories_foreshadow_resolved_at_fkey FOREIGN KEY (foreshadow_resolved_at) REFERENCES public.chapters(id) ON DELETE SET NULL;


--
-- Name: story_memories story_memories_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.story_memories
    ADD CONSTRAINT story_memories_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: writing_styles writing_styles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mumuai
--

ALTER TABLE ONLY public.writing_styles
    ADD CONSTRAINT writing_styles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: mumuai
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict SDquXl1JUYsxiLxCwIlnIIbGImCupJXFbwGX9ZHp65axcwqlYV7uNWdR81q7PEd

