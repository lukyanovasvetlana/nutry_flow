# BMAD Knowledge Base (Flutter)

## СПЕЦИФИКА ДЛЯ FLUTTER ПРОЕКТА

- Все рекомендации, примеры и шаблоны ориентированы на мобильные Flutter-проекты с feature-based архитектурой, BLoC, null safety, интеграциями (Supabase, Firebase), CI/CD, тестированием, документацией и мобильными UX best practices.
- Везде, где упоминаются "фреймворк", "архитектура", "тесты", "деплой" — подразумевается Flutter 3.x+, Material 3, BLoC, GetIt, pubspec.yaml, Android/iOS.
- Все чек-листы, шаблоны и процессы адаптированы для мобильной разработки и командной работы в Flutter.

---

## BMAD METHOD - CORE PHILOSOPHY

**КРАТКО:** "Vibe CEO'ing" — это про амбициозные цели, быстрые итерации, максимальное использование AI как команды, и гибкое управление проектом. BMAD (Breakthrough Method of Agile (ai-driven) Development) — это структурированный, но гибкий фреймворк для планирования, реализации и управления проектами создания мобильных приложений с помощью AI-агентов.

- Ставьте амбициозные цели и быстро иттерируйте.
- Используйте AI как force multiplier (например, для генерации архитектуры, тестов, документации, UI).
- Применяйте feature-based архитектуру, BLoC, DI, CI/CD, тестирование, документацию и мобильные best practices.
- Внедряйте Supabase, Firebase, push-уведомления, аналитики и другие современные мобильные сервисы.

---

## BMAD METHOD - AGILE METHODOLOGIES OVERVIEW (адаптация для Flutter)

- **Индивидуальности и взаимодействие** важнее процессов и инструментов: команда Flutter-разработчиков и AI-агенты работают в тесной связке.
- **Рабочий продукт важнее документации:** MVP Flutter-приложения должен быть доступен для тестирования на устройствах как можно раньше.
- **Сотрудничество с заказчиком:** Владелец продукта (или Vibe CEO) активно участвует в ревью, тестировании и приоритизации.
- **Гибкость:** Быстро реагируйте на изменения требований, используйте hot reload, feature toggles, CI/CD.

---

## BMAD METHOD - ETHOS & BEST PRACTICES (Flutter)

- **Vibe CEO** — вы управляете AI-командой, принимаете финальные решения, ревьюите все ключевые артефакты (код, архитектуру, тесты, UI).
- **Максимально используйте AI:** просите больше, требуйте лучшие решения, иттерируйте.
- **Контроль качества:** ревью кода, тестов, архитектуры, UI — ваша зона ответственности.
- **Стратегическое видение:** держите в фокусе цели продукта, UX, производительность, масштабируемость.
- **Итеративность:** не бойтесь возвращаться к предыдущим этапам (архитектура, дизайн, тесты).
- **Четкие инструкции:** чем точнее запросы к AI, тем лучше результат.
- **Документация важна:** поддерживайте актуальность README, архитектурных схем, ADR, тестовой документации.
- **Знайте своих агентов:** используйте специализированных Flutter-агентов (архитектор, PO, SM, dev, QA).
- **Начинайте с малого, масштабируйте быстро:** MVP, затем расширение.
- **Экспериментируйте:** пробуйте новые подходы, Flutter-пакеты, архитектурные паттерны.

---

## РЕКОМЕНДАЦИИ ДЛЯ FLUTTER ПРОЕКТА

- Используйте feature-based структуру (lib/features/feature_name/...)
- Применяйте BLoC/Cubit для управления состоянием
- Внедряйте DI через GetIt (lib/service_locator.dart)
- Используйте null safety и последние версии Flutter
- Для навигации — GoRouter или MaterialApp routes
- Для тестирования — flutter_test, bloc_test, integration_test
- Для CI/CD — GitHub Actions, Bitrise, fastlane
- Для документации — dartdoc, README, ADR, схемы
- Для интеграций — Supabase, Firebase, push-уведомления, аналитика
- Для UX — Material 3, кастомные темы, accessibility (a11y)
- Для производительности — кеширование, оптимизация build-методов, lazy loading
- Для безопасности — secure storage, валидация, отсутствие секретов в коде

---

## ПРИМЕРЫ РОЛЕЙ И АГЕНТОВ (адаптация для Flutter)

- **Аналитик:** исследование рынка, сбор требований, генерация project brief
- **PM:** создание и поддержка PRD, планирование релизов, приоритизация фич
- **Архитектор:** проектирование архитектуры (feature-based, BLoC, DI, интеграции)
- **Design Architect:** UX/UI спецификации, дизайн-системы, accessibility
- **PO:** валидация документов, управление бэклогом, генерация stories
- **Scrum Master:** поддержка процесса, генерация и ревью stories, контроль DoD
- **Dev Agents:** реализация stories, покрытие тестами, CI/CD, документация

---

## ПРИМЕРНЫЙ FLOW (ПОРЯДОК ДЕЙСТВИЙ) ДЛЯ FLUTTER ПРОЕКТА

1. Аналитик — генерация project brief
2. PM — создание PRD, эпиков, stories
3. Design Architect — UX/UI спецификация, дизайн-система
4. Архитектор — архитектура приложения, интеграции, схемы
5. PO — валидация, финальный чек-лист, подготовка stories
6. Scrum Master — генерация и ревью stories, контроль DoD
7. Dev Agents — реализация stories, тесты, документация, CI/CD

---

## ОСОБЕННОСТИ ДЛЯ МОБИЛЬНОЙ РАЗРАБОТКИ

- Учитывайте особенности платформ (iOS, Android)
- Используйте эмуляторы и реальные устройства для тестирования
- Внедряйте push-уведомления, deep links, background tasks
- Следите за производительностью и потреблением памяти
- Обеспечьте поддержку accessibility и локализации
- Используйте современные подходы к публикации (TestFlight, Google Play, fastlane)

---

## ПРИМЕРЫ ЧЕК-ЛИСТОВ И ШАБЛОНОВ (см. папку checklists/)

- architect-checklist.md — аудит архитектуры Flutter-приложения
- frontend-architecture-checklist.md — аудит UI/UX и структуры виджетов
- pm-checklist.md — чек-лист для PRD и эпиков
- po-master-checklist.md — чек-лист для PO по валидации плана
- story-draft-checklist.md — чек-лист для подготовки story
- story-dod-checklist.md — Definition of Done (критерии завершенности) для story
- change-checklist.md — чек-лист для анализа и планирования изменений

---

## ПРИМЕРЫ ДОКУМЕНТАЦИИ (см. templates/)

- prd-tmpl.md — шаблон Product Requirements Document
- architecture-tmpl.md — шаблон архитектурного документа
- front-end-architecture-tmpl.md — шаблон для UI/UX спецификации
- story-tmpl.md — шаблон user story

---

## КОМАНДНАЯ РАБОТА

- Используйте git flow, code review, CI/CD
- Внедряйте code style и линтинг (dart analyze, flutter analyze)
- Проводите регулярные ревью архитектуры, кода, тестов
- Документируйте все ключевые решения (ADR)
- Поддерживайте актуальность документации и схем

---

## ПОЛЕЗНЫЕ ССЫЛКИ

- https://docs.flutter.dev/
- https://bloclibrary.dev/#/
- https://pub.dev/
- https://supabase.com/docs/guides/with-flutter
- https://firebase.flutter.dev/
- https://material.io/
- https://github.com/bmad-code/bmad-method

## INDEX OF TOPICS

- [BMAD Knowledge Base (Flutter)](#bmad-knowledge-base-flutter)
  - [СПЕЦИФИКА ДЛЯ FLUTTER ПРОЕКТА](#специфика-для-flutter-проекта)
  - [BMAD METHOD - CORE PHILOSOPHY](#bmad-method---core-philosophy)
  - [BMAD METHOD - AGILE METHODOLOGIES OVERVIEW (адаптация для Flutter)](#bmad-method---agile-methodologies-overview-адаптация-для-flutter)
  - [BMAD METHOD - ETHOS \& BEST PRACTICES (Flutter)](#bmad-method---ethos--best-practices-flutter)
  - [РЕКОМЕНДАЦИИ ДЛЯ FLUTTER ПРОЕКТА](#рекомендации-для-flutter-проекта)
  - [ПРИМЕРЫ РОЛЕЙ И АГЕНТОВ (адаптация для Flutter)](#примеры-ролей-и-агентов-адаптация-для-flutter)
  - [ПРИМЕРНЫЙ FLOW (ПОРЯДОК ДЕЙСТВИЙ) ДЛЯ FLUTTER ПРОЕКТА](#примерный-flow-порядок-действий-для-flutter-проекта)
  - [ОСОБЕННОСТИ ДЛЯ МОБИЛЬНОЙ РАЗРАБОТКИ](#особенности-для-мобильной-разработки)
  - [ПРИМЕРЫ ЧЕК-ЛИСТОВ И ШАБЛОНОВ (см. папку checklists/)](#примеры-чек-листов-и-шаблонов-см-папку-checklists)
  - [ПРИМЕРЫ ДОКУМЕНТАЦИИ (см. templates/)](#примеры-документации-см-templates)
  - [КОМАНДНАЯ РАБОТА](#командная-работа)
  - [ПОЛЕЗНЫЕ ССЫЛКИ](#полезные-ссылки)
  - [INDEX OF TOPICS](#index-of-topics)
  - [BMAD METHOD - CORE PHILOSOPHY](#bmad-method---core-philosophy-1)
  - [BMAD METHOD - AGILE METHODOLOGIES OVERVIEW](#bmad-method---agile-methodologies-overview)
    - [CORE PRINCIPLES OF AGILE](#core-principles-of-agile)
    - [KEY PRACTICES IN AGILE](#key-practices-in-agile)
    - [BENEFITS OF AGILE](#benefits-of-agile)
  - [BMAD METHOD - ANALOGIES WITH AGILE PRINCIPLES](#bmad-method---analogies-with-agile-principles)
  - [BMAD METHOD - TOOLING AND RESOURCE LOCATIONS](#bmad-method---tooling-and-resource-locations)
  - [BMAD METHOD - COMMUNITY AND CONTRIBUTIONS](#bmad-method---community-and-contributions)
    - [Licensing](#licensing)
  - [BMAD METHOD - ETHOS \& BEST PRACTICES](#bmad-method---ethos--best-practices)
  - [AGENT ROLES AND RESPONSIBILITIES](#agent-roles-and-responsibilities)
  - [NAVIGATING THE BMAD WORKFLOW - INITIAL GUIDANCE](#navigating-the-bmad-workflow---initial-guidance)
    - [STARTING YOUR PROJECT - ANALYST OR PM?](#starting-your-project---analyst-or-pm)
    - [UNDERSTANDING EPICS - SINGLE OR MULTIPLE?](#understanding-epics---single-or-multiple)
  - [SUGGESTED ORDER OF AGENT ENGAGEMENT (TYPICAL FLOW)](#suggested-order-of-agent-engagement-typical-flow)
  - [HANDLING MAJOR CHANGES](#handling-major-changes)
  - [IDE VS UI USAGE - GENERAL RECOMMENDATIONS](#ide-vs-ui-usage---general-recommendations)
    - [CONCEPTUAL AND PLANNING PHASES](#conceptual-and-planning-phases)
    - [TECHNICAL DESIGN, DOCUMENTATION MANAGEMENT \& IMPLEMENTATION PHASES](#technical-design-documentation-management--implementation-phases)
    - [BMAD METHOD FILES](#bmad-method-files)
  - [LEVERAGING IDE TASKS FOR EFFICIENCY](#leveraging-ide-tasks-for-efficiency)
    - [PURPOSE OF IDE TASKS](#purpose-of-ide-tasks)
    - [EXAMPLES OF TASK FUNCTIONALITY](#examples-of-task-functionality)
- [АРХИТЕКТУРА И DEPENDENCY INJECTION](#архитектура-и-dependency-injection)
  - [Обзор Dependency Injection с GetIt](#обзор-dependency-injection-с-getit)
  - [Структура DI для фичи "Admin"](#структура-di-для-фичи-admin)
  - [Использование Blocs в Presentation слое (на примере AdminScreen)](#использование-blocs-в-presentation-слое-на-примере-adminscreen)

## BMAD METHOD - CORE PHILOSOPHY

**STATEMENT:** "Vibe CEO'ing" is about embracing the chaos, thinking like a CEO with unlimited resources and a singular vision, and leveraging AI as your high-powered team to achieve ambitious goals rapidly. The BMAD Method (Breakthrough Method of Agile (ai-driven) Development), currently in its V3 Release Preview "Bmad Agent", elevates "vibe coding" to advanced project planning, providing a structured yet flexible framework to plan, execute, and manage software projects using a team of specialized AI agents.

**DETAILS:**

- Focus on ambitious goals and rapid iteration.
- Utilize AI as a force multiplier.
- Adapt and overcome obstacles with a proactive mindset.

## BMAD METHOD - AGILE METHODOLOGIES OVERVIEW

### CORE PRINCIPLES OF AGILE

- Individuals and interactions over processes and tools.
- Working software over comprehensive documentation.
- Customer collaboration over contract negotiation.
- Responding to change over following a plan.

### KEY PRACTICES IN AGILE

- Iterative Development: Building in short cycles (sprints).
- Incremental Delivery: Releasing functional pieces of the product.
- Daily Stand-ups: Short team meetings for synchronization.
- Retrospectives: Regular reviews to improve processes.
- Continuous Feedback: Ongoing input from stakeholders.

### BENEFITS OF AGILE

- Increased Flexibility: Ability to adapt to changing requirements.
- Faster Time to Market: Quicker delivery of valuable features.
- Improved Quality: Continuous testing and feedback loops.
- Enhanced Stakeholder Engagement: Close collaboration with users/clients.
- Higher Team Morale: Empowered and self-organizing teams.

## BMAD METHOD - ANALOGIES WITH AGILE PRINCIPLES

The BMAD Method, while distinct in its "Vibe CEO'ing" approach with AI, shares foundational parallels with Agile methodologies:

- **Individuals and Interactions over Processes and Tools (Agile) vs. Vibe CEO & AI Team (BMAD):**

  - **Agile:** Emphasizes the importance of skilled individuals and effective communication.
  - **BMAD:** The "Vibe CEO" (you) actively directs and interacts with AI agents, treating them as a high-powered team. The quality of this interaction and clear instruction ("CLEAR_INSTRUCTIONS", "KNOW_YOUR_AGENTS") is paramount, echoing Agile's focus on human elements.

- **Working Software over Comprehensive Documentation (Agile) vs. Rapid Iteration & Quality Outputs (BMAD):**

  - **Agile:** Prioritizes delivering functional software quickly.
  - **BMAD:** Stresses "START_SMALL_SCALE_FAST" and "ITERATIVE_REFINEMENT." While "DOCUMENTATION_IS_KEY" for good inputs (briefs, PRDs), the goal is to leverage AI for rapid generation of working components or solutions. The focus is on achieving ambitious goals rapidly.

- **Customer Collaboration over Contract Negotiation (Agile) vs. Vibe CEO as Ultimate Arbiter (BMAD):**

  - **Agile:** Involves continuous feedback from the customer.
  - **BMAD:** The "Vibe CEO" acts as the primary stakeholder and quality control ("QUALITY_CONTROL," "STRATEGIC_OVERSIGHT"), constantly reviewing and refining AI outputs, much like a highly engaged customer.

- **Responding to Change over Following a Plan (Agile) vs. Embrace Chaos & Adapt (BMAD):**

  - **Agile:** Values adaptability and responsiveness to new requirements.
  - **BMAD:** Explicitly encourages to "EMBRACE_THE_CHAOS," "ADAPT & EXPERIMENT," and acknowledges that "ITERATIVE_REFINEMENT" means it's "not a linear process." This directly mirrors Agile's flexibility.

- **Iterative Development & Incremental Delivery (Agile) vs. Story-based Implementation & Phased Value (BMAD):**

  - **Agile:** Work is broken down into sprints, delivering value incrementally.
  - **BMAD:** Projects are broken into Epics and Stories, with "Developer Agents" implementing stories one at a time. Epics represent "significant, deployable increments of value," aligning with incremental delivery.

- **Continuous Feedback & Retrospectives (Agile) vs. Iterative Refinement & Quality Control (BMAD):**
  - **Agile:** Teams regularly reflect and adjust processes.
  - **BMAD:** The "Vibe CEO" continuously reviews outputs ("QUALITY_CONTROL") and directs "ITERATIVE_REFINEMENT," serving a similar function to feedback loops and process improvement.

## BMAD METHOD - TOOLING AND RESOURCE LOCATIONS

Effective use of the BMAD Method relies on understanding where key tools, configurations, and informational resources are located and how they are used. The method is designed to be tool-agnostic in principle, with agent instructions and workflows adaptable to various AI platforms and IDEs.

- **BMAD Knowledge Base:** This document (`bmad-agent/data/bmad-kb.md`) serves as the central repository for understanding the BMAD method, its principles, agent roles, and workflows.
- **Orchestrator Agents:** A key feature of V3 is the Orchestrator agent (e.g., "BMAD"), a master agent capable of embodying any specialized agent role.
  - **Web Agent Orchestrator:**
    - **Setup:** Utilizes a Node.js build script (`build-web-agent.js`) configured by `build-web-agent.cfg.js`.
    - **Process:** Consolidates assets (personas, tasks, templates, checklists, data) from an `asset_root` (e.g., `./bmad-agent/`) into a `build_dir` (e.g., `./bmad-agent/build/`).
    - **Output:** Produces bundled asset files (e.g., `personas.txt`, `tasks.txt`), an `agent-prompt.txt` (from `orchestrator_agent_prompt`), and an `agent-config.txt` (from `agent_cfg` like `web-bmad-orchestrator-agent.cfg.md`).
    - **Usage:** The `agent-prompt.txt` is used for the main custom web agent instruction set (e.g., Gemini 2.5 Gem or OpenAI Custom GPT), and the other build files are attached as knowledge/files.
  - **IDE Agent Orchestrator (`ide-bmad-orchestrator.md`):**
    - **Setup:** Works without a build step, dynamically loading its configuration.
    - **Configuration (`ide-bmad-orchestrator.cfg.md`):** Contains a `Data Resolution` section (defining base paths for assets like personas, tasks) and `Agent Definitions` (Title, Name, Customize, Persona file, Tasks).
    - **Operation:** Loads its config, lists available personas, and upon user request, embodies the chosen agent by loading its persona file and applying customizations.
- **Standalone IDE Agents:**
  - Optimized for IDE environments (e.g., Windsurf, Cursor), often under 6K characters (e.g., `dev.ide.md`, `sm.ide.md`).
  - Can directly reference and execute tasks.
- **Agent Configuration Files:**
  - `web-bmad-orchestrator-agent.cfg.md`: Defines agents the Web Orchestrator can embody, including references to personas, tasks, checklists, and templates (e.g., `personas#pm`, `tasks#create-prd`).
  - `ide-bmad-orchestrator.cfg.md`: Configures the IDE Orchestrator, defining `Data Resolution` paths (e.g., `(project-root)/bmad-agent/personas`) and agent definitions with persona file names (e.g., `analyst.md`) and task file names (e.g., `create-prd.md`).
  - `web-bmad-orchestrator-agent.md`: Main prompt for the Web Orchestrator.
  - `ide-bmad-orchestrator.md`: Main prompt/definition of the IDE Orchestrator agent.
- **Task Files:**
  - Located in `bmad-agent/tasks/` (and sometimes `bmad-agent/checklists/` for checklist-like tasks).
  - Self-contained instruction sets for specific jobs (e.g., `create-prd.md`, `checklist-run-task.md`).
  - Reduce agent bloat and provide on-demand functionality for any capable agent.
- **Core Agent Definitions (Personas):**
  - Files (typically `.md`) defining core personalities and instructions for different agents.
  - Located in `bmad-agent/personas/` (e.g., `analyst.md`, `pm.md`).
- **Project Documentation (Outputs):**
- **Project Briefs:** Generated by the Analyst agent.
- **Product Requirements Documents (PRDs):** Produced by the PM agent, containing epics and stories.
- **UX/UI Specifications & Architecture Documents:** Created by Design Architect and Architect agents.
- The **POSM agent** is crucial for organizing and managing these documents.
- **Templates:** Standardized formats for briefs, PRDs, checklists, etc., likely stored in `bmad-agent/templates/`.
- **Data Directory (`bmad-agent/data/`):** Stores persistent data, knowledge bases (like this one), and other key information for the agents.

## BMAD METHOD - COMMUNITY AND CONTRIBUTIONS

The BMAD Method thrives on community involvement and collaborative improvement.

- **Getting Involved:**
  - **GitHub Discussions:** The primary platform for discussing potential ideas, use cases, additions, and enhancements to the method.
  - **Reporting Bugs:** If you find a bug, check existing issues first. If unreported, provide detailed steps to reproduce, along with any relevant logs or screenshots.
  - **Suggesting Features:** Check existing issues and discussions. Explain your feature idea in detail and its potential value.
- **Contribution Process (Pull Requests):**
  1. Fork the repository.
  2. Create a new branch for your feature or bugfix (e.g., `feature/your-feature-name`).
  3. Make your changes, adhering to existing code style and conventions. Write clear comments for complex logic.
  4. Run any tests or linting to ensure quality.
  5. Commit your changes with clear, descriptive messages (refer to the project's commit message convention, often found in `docs/commit.md`).
  6. Push your branch to your fork.
  7. Open a Pull Request against the main branch of the original repository.
- **Code of Conduct:** All participants are expected to abide by the project's Code of Conduct.
- **Licensing of Contributions:** By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

### Licensing

The BMAD Method and its associated documentation and software are distributed under the **MIT License**.

Copyright (c) 2025 Brian AKA BMad AKA Bmad Code

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## BMAD METHOD - ETHOS & BEST PRACTICES

- **CORE_ETHOS:** You are the "Vibe CEO." Think like a CEO with unlimited resources and a singular vision. Your AI agents are your high-powered team. Your job is to direct, refine, and ensure quality towards your ambitious goal. The method elevates "vibe coding" to advanced project planning.
- **MAXIMIZE_AI_LEVERAGE:** Push the AI. Ask for more. Challenge its outputs. Iterate.
- **QUALITY_CONTROL:** You are the ultimate arbiter of quality. Review all outputs.
- **STRATEGIC_OVERSIGHT:** Maintain the high-level vision. Ensure agent outputs align.
- **ITERATIVE_REFINEMENT:** Expect to revisit steps. This is not a linear process.
- **CLEAR_INSTRUCTIONS:** The more precise your requests, the better the AI's output.
- **DOCUMENTATION_IS_KEY:** Good inputs (briefs, PRDs) lead to good outputs. The POSM agent is crucial for organizing this.
- **KNOW_YOUR_AGENTS:** Understand each agent's role (see [AGENT ROLES AND RESPONSIBILITIES](#agent-roles-and-responsibilities) or below). This includes understanding the capabilities of the Orchestrator agent if you are using one.
- **START_SMALL_SCALE_FAST:** Test concepts, then expand.
- **EMBRACE_THE_CHAOS:** Pioneering new methods is messy. Adapt and overcome.
- **ADAPT & EXPERIMENT:** The BMAD Method provides a structure, but feel free to adapt its principles, agent order, or templates to fit your specific project needs and working style. Experiment to find what works best for you. **Define agile the BMad way - or your way!** The agent configurations allow for customization of roles and responsibilities.

## AGENT ROLES AND RESPONSIBILITIES

Understanding the distinct roles and responsibilities of each agent is key to effectively navigating the BMAD workflow. While the "Vibe CEO" provides overall direction, each agent specializes in different aspects of the project lifecycle. V3 introduces Orchestrator agents that can embody these roles, with configurations specified in `web-bmad-orchestrator-agent.cfg.md` for web and `ide-bmad-orchestrator.cfg.md` for IDE environments.

- **Orchestrator Agent (BMAD):**

  - **Function:** The primary orchestrator, initially "BMAD." It can embody various specialized agent personas. It handles general BMAD queries, provides oversight, and is the go-to when unsure which specialist is needed.
  - **Persona Reference:** `personas#bmad` (Web) or implicitly the core of `ide-bmad-orchestrator.md` (IDE).
  - **Key Data/Knowledge:** Accesses `data#bmad-kb-data` (Web) for its knowledge base.
  - **Types:**
    - **Web Orchestrator:** Built using a script, leverages large context windows of platforms like Gemini 2.5 or OpenAI GPTs. Uses bundled assets. Its behavior and available agents are defined in `web-bmad-orchestrator-agent.cfg.md`.
    - **IDE Orchestrator:** Operates directly in IDEs like Cursor or Windsurf without a build step, loading persona and task files dynamically based on its configuration (`ide-bmad-orchestrator.cfg.md`). The orchestrator itself is defined in `ide-bmad-orchestrator.md`.
  - **Key Feature:** Simplifies agent management, especially in environments with limitations on the number of custom agents.

- **Analyst:**

  - **Function:** Handles research, requirements gathering, brainstorming, and the creation of Project Briefs.
  - **Web Persona:** `Analyst (Mary)` with persona `personas#analyst`. Customized to be "a bit of a know-it-all, and likes to verbalize and emote." Uses `templates#project-brief-tmpl`.
  - **IDE Persona:** `Analyst (Larry)` with persona `analyst.md`. Similar "know-it-all" customization. Tasks for Brainstorming, Deep Research Prompt Generation, and Project Brief creation are often defined within the `analyst.md` persona itself ("In Analyst Memory Already").
  - **Output:** `Project Brief`.

- **Product Manager (PM):**

  - **Function:** Responsible for creating and maintaining Product Requirements Documents (PRDs), overall project planning, and ideation related to the product.
  - **Web Persona:** `Product Manager (John)` with persona `personas#pm`. Utilizes `checklists#pm-checklist` and `checklists#change-checklist`. Employs `templates#prd-tmpl`. Key tasks include `tasks#create-prd`, `tasks#correct-course`, and `tasks#create-deep-research-prompt`.
  - **IDE Persona:** `Product Manager (PM) (Jack)` with persona `pm.md`. Focused on producing/maintaining the PRD (`create-prd.md` task) and product ideation/planning.
  - **Output:** `Product Requirements Document (PRD)`.

- **Architect:**

  - **Function:** Designs system architecture, handles technical design, and ensures technical feasibility.
  - **Web Persona:** `Architect (Fred)` with persona `personas#architect`. Uses `checklists#architect-checklist` and `templates#architecture-tmpl`. Tasks include `tasks#create-architecture` and `tasks#create-deep-research-prompt`.
  - **IDE Persona:** `Architect (Mo)` with persona `architect.md`. Customized to be "Cold, Calculating, Brains behind the agent crew." Generates architecture (`create-architecture.md` task), helps plan stories (`create-next-story-task.md`), and can update PO-level epics/stories (`doc-sharding-task.md`).
  - **Output:** `Architecture Document`.

- **Design Architect:**

  - **Function:** Focuses on UI/UX specifications, front-end technical architecture, and can generate prompts for AI UI generation services.
  - **Web Persona:** `Design Architect (Jane)` with persona `personas#design-architect`. Uses `checklists#frontend-architecture-checklist`, `templates#front-end-architecture-tmpl` (for FE architecture), and `templates#front-end-spec-tmpl` (for UX/UI Spec). Tasks: `tasks#create-frontend-architecture`, `tasks#create-ai-frontend-prompt`, `tasks#create-uxui-spec`.
  - **IDE Persona:** `Design Architect (Millie)` with persona `design-architect.md`. Customized to be "Fun and carefree, but a frontend design master." Helps design web apps, produces UI generation prompts (`create-ai-frontend-prompt.md` task), plans FE architecture (`create-frontend-architecture.md` task), and creates UX/UI specs (`create-uxui-spec.md` task).
  - **Output:** `UX/UI Specification`, `Front-end Architecture Plan`, AI UI generation prompts.

- **Product Owner (PO):**

  - **Function:** Agile Product Owner responsible for validating documents, ensuring development sequencing, managing the product backlog, running master checklists, handling mid-sprint re-planning, and drafting user stories.
  - **Web Persona:** `PO (Sarah)` with persona `personas#po`. Uses `checklists#po-master-checklist`, `checklists#story-draft-checklist`, `checklists#change-checklist`, and `templates#story-tmpl`. Tasks include `tasks#story-draft-task`, `tasks#doc-sharding-task` (extracts epics and shards architecture), and `tasks#correct-course`.
  - **IDE Persona:** `Product Owner AKA PO (Curly)` with persona `po.md`. Described as a "Jack of many trades." Tasks include `create-prd.md`, `create-next-story-task.md`, `doc-sharding-task.md`, and `correct-course.md`.
  - **Output:** User Stories, managed PRD/Backlog.

- **Scrum Master (SM):**

  - **Function:** A technical role focused on helping the team run the Scrum process, facilitating development, and often involved in story generation and refinement.
  - **Web Persona:** `SM (Bob)` with persona `personas#sm`. Described as "A very Technical Scrum Master." Uses `checklists#change-checklist`, `checklists#story-dod-checklist`, `checklists#story-draft-checklist`, and `templates#story-tmpl`. Tasks: `tasks#checklist-run-task`, `tasks#correct-course`, `tasks#story-draft-task`.
  - **IDE Persona:** `Scrum Master: SM (SallySM)` with persona `sm.ide.md`. Described as "Super Technical and Detail Oriented," specialized in "Next Story Generation" (likely leveraging the `sm.ide.md` persona's capabilities).

- **Developer Agents (DEV):**
  - **Function:** Implement user stories one at a time. Can be generic or specialized.
  - **Web Persona:** `DEV (Dana)` with persona `personas#dev`. Described as "A very Technical Senior Software Developer."
  - **IDE Personas:** Multiple configurations can exist, using the `dev.ide.md` persona file (optimized for <6K characters for IDEs). Examples:
    - `Frontend Dev (DevFE)`: Specialized in NextJS, React, Typescript, HTML, Tailwind.
    - `Dev (Dev)`: Master Generalist Expert Senior Full Stack Developer.
  - **Configuration:** Specialized agents can be configured in `ide-bmad-orchestrator.cfg.md` for the IDE Orchestrator, or defined for the Web Orchestrator. Standalone IDE developer agents (e.g., `dev.ide.md`) are also available.
  - **When to Use:** During the implementation phase, typically working within an IDE.

## NAVIGATING THE BMAD WORKFLOW - INITIAL GUIDANCE

### STARTING YOUR PROJECT - ANALYST OR PM?

- Use Analyst if unsure about idea/market/feasibility or need deep exploration.
- Use PM if concept is clear or you have a Project Brief.
- Refer to [AGENT ROLES AND RESPONSIBILITIES](#agent-roles-and-responsibilities) (or section within this KB) for full details on Analyst and PM.

### UNDERSTANDING EPICS - SINGLE OR MULTIPLE?

- Epics represent significant, deployable increments of value.
- Multiple Epics are common for non-trivial projects or a new MVP (distinct functional areas, user journeys, phased rollout).
- Single Epic might suit very small MVPs, or post MVP / brownfield new features.
- The PM helps define and structure epics.

## SUGGESTED ORDER OF AGENT ENGAGEMENT (TYPICAL FLOW)

**NOTE:** This is a general guideline. The BMAD method is iterative; phases/agents might be revisited.

1. **Analyst** - brainstorm and create a project brief.
2. **PM (Product Manager)** - use the brief to produce a PRD with high level epics and stories.
3. **Design Architect UX UI Spec for PRD (If project has a UI)** - create the front end UX/UI Specification.
4. **Architect** - create the architecture and ensure we can meet the prd requirements technically - with enough specification that the dev agents will work consistently.
5. **Design Architect (If project has a UI)** - create the front end architecture and ensure we can meet the prd requirements technically - with enough specification that the dev agents will work consistently.
6. **Design Architect (If project has a UI)** - Optionally create a prompt to generate a UI from AI services such as Lovable or V0 from Vercel.
7. **PO**: Validate documents are aligned, sequencing makes sense, runs a final master checklist. The PO can also help midstream development replan or course correct if major changes occur.
8. **PO or SM**: Generate Stories 1 at a time (or multiple but not recommended) - this is generally done in the IDE after each story is completed by the Developer Agents.
9. **Developer Agents**: Implement Stories 1 at a time. You can craft different specialized Developer Agents, or use a generic developer agent. It is recommended to create specialized developer agents and configure them in the `ide-bmad-orchestrator.cfg`.

## HANDLING MAJOR CHANGES

Major changes are an inherent part of ambitious projects. The BMAD Method embraces this through its iterative nature and specific agent roles:

- **Iterative by Design:** The entire BMAD workflow is built on "ITERATIVE_REFINEMENT." Expect to revisit previous steps and agents as new information emerges or requirements evolve. It's "not a linear process."
- **Embrace and Adapt:** The core ethos includes "EMBRACE_THE_CHAOS" and "ADAPT & EXPERIMENT." Major changes are opportunities to refine the vision and approach.
- **PO's Role in Re-planning:** The **Product Owner (PO)** is key in managing the impact of significant changes. They can "help midstream development replan or course correct if major changes occur." This involves reassessing priorities, adjusting the backlog, and ensuring alignment with the overall project goals.
- **Strategic Oversight by Vibe CEO:** As the "Vibe CEO," your role is to maintain "STRATEGIC_OVERSIGHT." When major changes arise, you guide the necessary pivots, ensuring the project remains aligned with your singular vision.
- **Re-engage Agents as Needed:** Don't hesitate to re-engage earlier-phase agents (e.g., Analyst for re-evaluating market fit, PM for revising PRDs, Architect for assessing technical impact) if a change significantly alters the project's scope or foundations.

## IDE VS UI USAGE - GENERAL RECOMMENDATIONS

The BMAD method can be orchestrated through different interfaces, typically a web UI for higher-level planning and an IDE for development and technical tasks.

### CONCEPTUAL AND PLANNING PHASES

- **Interface:** Often best managed via a Web UI (leveraging the **Web Agent Orchestrator** with its bundled assets and `agent-prompt.txt`) or dedicated project management tools where orchestrator agents can guide the process.
- **Agents Involved:**
  - **Analyst:** Brainstorming, research, and initial project brief creation.
  - **PM (Product Manager):** PRD development, epic and high-level story definition.
- **Activities:** Defining the vision, initial requirements gathering, market analysis, high-level planning. The `web-bmad-orchestrator-agent.md` and its configuration likely support these activities.

### TECHNICAL DESIGN, DOCUMENTATION MANAGEMENT & IMPLEMENTATION PHASES

- **Interface:** Primarily within the Integrated Development Environment (IDE), leveraging specialized agents (standalone or via the **IDE Agent Orchestrator** configured with `ide-bmad-orchestrator.cfg.md`).
- **Agents Involved:**
  - **Architect / Design Architect (UI):** Detailed technical design and specification.
  - **POSM Agent:** Ongoing documentation management and organization.
  - **PO (Product Owner) / SM (Scrum Master):** Detailed story generation, backlog refinement, often directly in the IDE or tools integrated with it.
  - **Developer Agents:** Code implementation for stories, working directly with the codebase in the IDE.
- **Activities:** Detailed architecture, front-end/back-end design, code development, testing, leveraging IDE tasks (see "LEVERAGING IDE TASKS FOR EFFICIENCY"), using configurations like `ide-bmad-orchestrator.cfg.md`.

### BMAD METHOD FILES

Understanding key files helps in navigating and customizing the BMAD process:

- **Knowledge & Configuration:**
  - `bmad-agent/data/bmad-kb.md`: This central knowledge base.
  - `ide-bmad-orchestrator.cfg.md`: Configuration for IDE developer agents.
  - `ide-bmad-orchestrator.md`: Definition of the IDE orchestrator agent.
  - `web-bmad-orchestrator-agent.cfg.md`: Configuration for the web orchestrator agent.
  - `web-bmad-orchestrator-agent.md`: Definition of the web orchestrator agent.
- **Task Definitions:**
  - Files in `bmad-agent/tasks/` or `bmad-agent/checklists/` (e.g., `checklist-run-task.md`): Reusable prompts for specific actions and also used by agents to keep agent persona files lean.
- **Agent Personas & Templates:**
  - Files in `bmad-agent/personas/`: Define the core behaviors of different agents.
  - Files in `bmad-agent/templates/`: Standard formats for documents like Project Briefs, PRDs that the agents will use to populate instances of these documents.
- **Project Artifacts (Outputs - locations vary based on project setup):**
  - Project Briefs
  - Product Requirements Documents (PRDs)
  - UX/UI Specifications
  - Architecture Documents
  - Codebase and related development files.

## LEVERAGING IDE TASKS FOR EFFICIENCY

### PURPOSE OF IDE TASKS

- **Reduce Agent Bloat:** Avoid adding numerous, rarely used instructions to primary IDE agent modes (Dev Agent, SM Agent) or even the Orchestrator's base prompt. Keeps agents lean, beneficial for IDEs with limits on custom agent complexity/numbers.
- **On-Demand Functionality:** Instruct an active IDE agent (standalone or an embodied persona within the IDE Orchestrator) to perform a task by providing the content of the relevant task file (e.g., from `bmad-agent/tasks/checklist-run-task.md`) as a prompt, or by referencing it if the agent is configured to find it (as with the IDE Orchestrator).
- **Versatility:** Any sufficiently capable agent can be asked to execute a task. Tasks can handle specific functions like running checklists, creating stories, sharding documents, indexing libraries, etc. They are self-contained instruction sets.

### EXAMPLES OF TASK FUNCTIONALITY

**CONCEPT:** Think of tasks as specialized, callable mini-agents or on-demand instruction sets that main IDE agents or the Orchestrator (when embodying a persona) can invoke, keeping primary agent definitions streamlined. They are particularly useful for operations not performed frequently. The `docs/instruction.md` file provides more details on task setup and usage.

Here are some examples of functionalities provided by tasks found in `bmad-agent/tasks/`:

- **`create-prd.md`:** Guides the generation of a Product Requirements Document.
- **`create-next-story-task.md`:** Helps in defining and creating the next user story for development.
- **`create-architecture.md`:** Assists in outlining the technical architecture for a project.
- **`create-frontend-architecture.md`:** Focuses specifically on designing the front-end architecture.
- **`create-uxui-spec.md`:** Facilitates the creation of a UX/UI Specification document.
- **`create-ai-frontend-prompt.md`:** Helps in drafting a prompt for an AI service to generate UI/frontend elements.
- **`doc-sharding-task.md`:** Provides a process for breaking down large documents into smaller, manageable parts.
- **`library-indexing-task.md`:** Assists in creating an index or overview of a code library.
- **`checklist-run-task.md`:** Executes a predefined checklist (likely using `checklist-mappings.yml`).
- **`correct-course.md`:** Provides guidance or steps for when a project needs to adjust its direction.
- **`create-deep-research-prompt.md`:** Helps formulate prompts for conducting in-depth research on a topic.

These tasks allow agents to perform complex, multi-step operations by following the detailed instructions within each task file, often leveraging templates and checklists as needed.

# АРХИТЕКТУРА И DEPENDENCY INJECTION

## Обзор Dependency Injection с GetIt

В проекте используется подход Dependency Injection с помощью библиотеки `GetIt` (`service_locator.dart`). Этот подход позволяет отделить создание зависимостей от их использования, что повышает тестируемость, поддерживаемость и модульность кода.

Зависимости регистрируются в `setupServiceLocator()`. В зависимости от жизненного цикла и потребностей, используются следующие типы регистрации:

- `registerLazySingleton`: Создает один экземпляр зависимости при первом запросе и переиспользует его на протяжении всего жизненного цикла приложения.
- `registerFactory`: Создает новый экземпляр зависимости каждый раз при запросе.

Зависимости предоставляются в дереве виджетов с использованием `BlocProvider` или `MultiBlocProvider`. Для зависимостей, зарегистрированных как LazySingleton или Factory в GetIt, используется `BlocProvider.value`, чтобы `BlocProvider` не управлял их жизненным циклом (не вызывал `close()`).

## Структура DI для фичи "Admin"

Фича "Admin" следует общей архитектуре Dependency Injection проекта. Компоненты фичи регистрируются в `service_locator.dart` следующим образом:

- **Источники данных (Data Sources):** Реализация абстрактного источника данных (`AdminRemoteDataSourceImpl`) регистрируется как `LazySingleton`. Она зависит от `SupabaseClient`, который получается напрямую из `Supabase.instance.client`.

  ```dart
  sl.registerLazySingleton<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(Supabase.instance.client));
  ```

- **Репозитории (Repositories):** Реализация абстрактного репозитория (`AdminRepositoryImpl`) регистрируется как `LazySingleton`. Она зависит от соответствующего источника данных (`AdminRemoteDataSource`), который внедряется из GetIt.

  ```dart
  sl.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(sl<AdminRemoteDataSource>()));
  ```

- **Use Cases:** Use Case (`GetAdminDashboardData`) регистрируется как `LazySingleton`. Он зависит от соответствующего репозитория (`AdminRepository`), который внедряется из GetIt.

  ```dart
  sl.registerLazySingleton(() => GetAdminDashboardData(sl<AdminRepository>()));
  ```

- **Blocs:** Bloc'и (`AdminDashboardBloc`) регистрируются как `Factory`, поскольку их жизненный цикл часто привязан к конкретным виджетам/экранам. Зависимости Bloc'а (например, Use Cases) внедряются из GetIt.

  ```dart
  sl.registerFactory(() => AdminDashboardBloc(getAdminDashboardData: sl()));
  ```

## Использование Blocs в Presentation слое (на примере AdminScreen)

На экранах, которые используют Bloc'и, зарегистрированные в GetIt, эти Bloc'и получаются из Service Locator и предоставляются в дереве виджетов с помощью `BlocProvider.value`.

Например, в `AdminScreen`, который является контейнером для страниц админки, `AdminDashboardBloc` предоставляется следующим образом:

```dart
@override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: sl<AdminDashboardBloc>()..add(LoadAdminDashboardData()), // Получаем из GetIt и сразу отправляем событие загрузки
    child: Scaffold(
      body: _pages[_currentIndex],
      // ... bottomNavigationBar ...
    ),
  );
}
```

При таком подходе:

- `AdminDashboardBloc` становится доступен для всех дочерних виджетов `Scaffold`, включая `AdminDashboardPage`.
- `BlocProvider.value` не пытается закрыть `AdminDashboardBloc`, поскольку его жизненным циклом управляет GetIt (как Factory).
- Событие `LoadAdminDashboardData` инициируется при создании `AdminScreen`, что запускает загрузку данных при входе на экран админки.

Это гарантирует, что зависимости создаются и управляются централизованно через GetIt, а Presentation слой только использует их, запрашивая из Service Locator и делая доступными в дереве виджетов через `BlocProvider.value`.
