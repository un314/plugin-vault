---
name: cet4-sprint
description: This skill should be used when the user is preparing for the CET-4 (英语四级) exam and wants a daily, context-based English study session. It builds vocabulary through themed sentences and short passages (not rote memorization) and runs a daily "日课" covering themed vocabulary (with IPA + Chinese), a listening read-aloud passage, a graded reading passage with questions, a writing/translation micro-task, and an English conversation with correction. Always include Chinese translations for all English content. Trigger on mentions of CET-4, 英语四级, 四级冲刺, daily English study, or a request for a study day/lesson.
agent_created: true
---

# CET-4 Sprint（英语四级冲刺日课）

## Overview
Deliver a daily, context-based English study session for CET-4 candidates. Build vocabulary through themed sentences and short passages rather than isolated word lists. Each session (a "日课") has five parts: themed vocabulary, listening read-aloud, graded reading, a writing/translation micro-task, and an English conversation with correction. The text CLI has no speech recognition, so pronunciation is supported via IPA transcriptions; when the user supplies transcribed speech (text from a voice-input tool), correct it based on that text.

## When to use
- User is preparing for CET-4 (英语四级). Default exam date: 2026-12-12 (笔试 9:00–11:20).
- User asks for a study day/lesson, daily English practice, or vocabulary by theme.
- User wants conversation practice, reading/listening training, or writing/translation drills for CET-4.
- Default exam target: pass (≥425/710). Adjust if the user states a higher goal.

## Hard rules (always follow)
- Every English item MUST include a Chinese translation: vocabulary gets 中文释义; example sentences get 中文翻译; listening and reading passages get 中文翻译 (full or sentence-by-sentence).
- Provide IPA phonetic transcription for every vocabulary word (mark primary stress).
- Do NOT ask the user to rote-memorize isolated word lists; always embed words in sentences or short passages.
- Daily new active words: 24–30 (for a 2+ hours/day learner). Scale down only if the user reports less time. Daily reading/listening passively exposes 30–50 more words.
- Track progress in a local plan file (see Progress tracking).

## Daily session structure (the "日课")
Produce the following five sections each day. Pacing assumes ~2–2.5 hours total; tell the user it can be split across the day.

### 1. 主题词汇 (Themed vocabulary) — ~24–30 words
- Group words by 3–4 sub-themes under the day's topic.
- Columns: 词 | 音标 | 中文 | 例句 / 翻译.
- After the table, ask the user to pick 8 words and write their own sentences (cross-check with Chinese).

### 2. 听力跟读 (Listening read-aloud)
- Provide a CET-4-style short dialogue or news snippet as text (no audio available in CLI).
- Instruct: listen via phone text-to-speech OR read aloud twice, then answer comprehension questions.
- Give the script with 中文翻译 and 2–3 comprehension questions.

### 3. 阅读精练 (Graded reading)
- Provide a CET-4-level short passage with 中文翻译 (sentence-by-sentence or full).
- 2–3 comprehension questions; optionally mark 1–2 long/complex sentences for structural breakdown.

### 4. 写作 / 翻译微任务 (Writing/translation micro-task)
- Alternate days: writing (a 3–5 sentence paragraph on a CET-4 topic using ≥3 day words, with a model answer supplied) and translation (zh→en or en→zh sentence pairs on common CET-4 themes).

### 5. 对话练习 (Conversation)
- 3 open questions in English (with Chinese) on the day's theme.
- The user answers in English; correct grammar, word choice, and expression. When the user supplies transcribed speech, also flag likely pronunciation pitfalls tied to the IPA given earlier.

## Weekly theme map (7 weeks, ~51 days)
See `references/themes.md` for the full 7-week map and daily topic rotation.
- Week 1 校园·学习·时间管理 + 听力基础（数字/时间/地点/态度）
- Week 2 科技·环境·健康
- Week 3 社会·文化·教育·就业
- Week 4 经济·消费·交通旅行·人际
- Week 5 饮食·媒体·价值观·心理
- Week 6 真题高频话题复盘 + 写作模板 + 翻译套路
- Week 7 全真模考 + 错题冲刺 + 心态

## Vocabulary seed bank
`references/vocab-bank.md` contains starter words per week (with IPA + 中文) to bootstrap content on a fresh device. Generate additional day-specific words as needed; do not limit to the bank.

## Day 1 template
`references/day1-example.md` shows the exact expected format and volume for one full day. Use it as the output template for every day.

## Progress tracking
- On the first day, create a plan file (e.g., `四级51天冲刺计划.md`) in the user's workspace summarizing the 7-week map, daily structure, and a vocabulary tally.
- Maintain a day counter. When the user returns, continue from the next day; if the gap is large, briefly review before advancing.
- Record standing user preferences (e.g., "always include Chinese") in long-term memory so they persist across sessions and devices.

## Note on voice / pronunciation
The text CLI cannot analyze audio. Substitute with: IPA for every word/sentence; read-aloud scripts; and, when the user pastes voice-to-text output, text-based correction plus pronunciation tips mapped to the IPA.
