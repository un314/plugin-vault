# 我的 Trae 技能库

本仓库备份本机 `C:\Users\dizey\.trae-cn\skills\` 下的全部技能，每个技能一个独立文件夹。

## 技能清单

- `agency-agents` — 299 个专业角色代理（工程、设计、营销、财务、产品、研究、安全等 19 个部门）。当用户要求以某个专家身份工作，或需要特定领域专家介入时使用。
- `agile-pm-workflow` — Guides novice PMs through a 7-step agile workflow: dialogue-based requirement gathering, drafting PRD skeleton, HTML prototype creation (via frontend-design), mermaid flowcharts, and final PRD with iframe slices.
- `brainstorming` — You MUST use this before any creative work - creating features, building components, adding functionality, modifying behavior, or planning anything new, in software or out of it (a talk, a business, a renovation).
- `diagnosing-superpowers` — Use when a superpowers session went wrong and your human partner wants to know why — repeated work, ignored plans, stumbles, poor results, a skill that didn't fire, "it took too long", "why is it so expensive", "what is it doing" — or wants to build a bug report for the superpowers maintainers, for the current session or a past one identified by id or path, on any harness.
- `dispatching-parallel-agents` — Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies
- `executing-plans` — Use when executing an implementation plan in the current session as the implementer yourself — your human partner chose inline execution, or no subagent tool is available
- `finishing-a-development-branch` — Use when implementation is complete, all tests pass, and you need to decide how to integrate the work
- `frontend-design` — Build a frontend with a deliberate visual direction held through palette, typography, structure, and texture, with on-screen strings that name real information rather than fabricated demo data or filler labels. Use when building or restyling a frontend.
- `goutoujunshi` — 恋爱军师与情绪支持 skill。用于心动、暧昧、追求、聊天记录或截图分析、约会、关系确认、多人选择、冲突、冷淡、投入失衡、分手、复合、出轨、婚姻或家庭问题；也用于分析关系信号、设计主动推进或退出策略、润色可直接发送的话术，以及把冷读、自然流、Blueprint、Mystery 等经典社交体系转译成真实、互惠、可退出的沟通能力。支持分析ChatLab已有数据和经同意可撤销的长期关系档案，不负责导出聊天软件数据。首次使用时为用户及一个或多个目标对象建立包含 MBTI、主观综合评分和关系背景的档案。
- `newshub` — >-
- `receiving-code-review` — Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation
- `requesting-code-review` — Use when completing tasks, implementing major features, or before merging to verify work meets requirements
- `rpa-yinqi-reconciliation` — 在 cloud.acctedu.com 银企对账实操题中自动填写银行存款余额调节表并保存，并完成 UiPath 工程本地发布。当用户要做银企对账实操题、调节表输入框填不进去、或需要完整复刻本次 RPA 作业时使用。不适用于其他课程任务。
- `scrapling-official` — Scrape web pages using Scrapling with HTTP requests, stealth browsers, JavaScript rendering, browser actions, API response capture, concurrent spiders, and adaptive parsing. Use when asked to scrape, crawl, or extract data from websites; web_fetch fails; the site has anti-bot protections; write Python code to scrape/crawl; or write spiders.
- `subagent-driven-development` — Use when executing implementation plans with independent tasks in the current session
- `systematic-debugging` — Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
- `taste-skill` — >-
- `test-driven-development` — Use when implementing any feature or bugfix, before writing implementation code
- `uipath-exam-env-setup` — 在另一台 Windows 设备复刻本机 UiPath 23.10 考试环境，涵盖安装、账号登录、禁用自动更新、许可与依赖校验、工程迁移、考前自检与回滚。当用户要在机房电脑或新设备配置 UiPath 考试环境时使用，不用于日常流程开发。
- `uipath-studio-automation` — Automate UiPath Studio on Windows through computer-use plus hand-edited XAML. Use when creating, editing, validating, running, or packaging UiPath workflow projects (RPA 财务机器人作业/考试, UiPath Studio 23.10, VB, Windows target, 含经典 Excel 活动). Do not use for web UI automation outside UiPath.
- `using-git-worktrees` — Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback
- `using-superpowers` — Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
- `verification-before-completion` — Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
- `writing-plans` — Use when you have a spec or requirements for a multi-step task, before touching code
- `writing-skills` — Use when creating new skills, editing existing skills, or verifying skills work before deployment

## 恢复方式（换电脑 / 重装）

把需要的技能文件夹整体复制回 `C:\Users\dizey\.trae-cn\skills\` 即可，无需其他配置。

## 同步机制

- 本机新增技能 -> 自动复制进本仓库对应文件夹 -> 自动提交并推送到 GitHub
- GitHub 上新增的技能文件夹 -> 自动复制回本机技能目录
- 每天定时执行一次
