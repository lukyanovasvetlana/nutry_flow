# Задача генерации PRD (Product Requirements Document)

## Назначение

- Трансформировать входные данные в ключевые документы продуктового определения по шаблону `prd-tmpl`.
- Определить чёткий MVP с фокусом на основные функции.
- Сформировать фундамент для архитектора и последующих AI-агентов разработки.

**Контекст Flutter приложения:**

- Учитывайте feature-based структуру, чистую архитектуру (data/domain/presentation), BLoC/Cubit для управления состоянием, DI через GetIt, интеграции с Supabase и Firebase, требования к тестируемости, документации, CI/CD, безопасности, UX, accessibility и мобильные best practices.

Помните: ваши документы — основа всего процесса разработки. Они будут напрямую использоваться архитектором для создания архитектурных решений и технических спецификаций. Эпики и истории будут преобразованы в задачи для разработки. Фокусируйтесь на "что", а не "как", но будьте достаточно точны, чтобы обеспечить логическую последовательность для дальнейшей детализации.

---

## Инструкция

### 1. Определите рабочий процесс проекта

Перед генерацией PRD уточните у пользователя желаемый рабочий процесс:

A. **Ориентированный на результат (по умолчанию):** (Агент формулирует user stories, фокусируясь на результате, детали реализации оставляет архитектору/Scrum Master. Все нюансы фиксируются как "Заметки для архитектора/Scrum Master" в соответствующем разделе PRD.)

B. **Очень технический (не рекомендуется):** (Агент даёт более детальные, технически ориентированные Acceptance Criteria, включая ключевые технические решения и структуру приложения в специальном разделе PRD: '[ОПЦИОНАЛЬНО: Для упрощённого перехода от PM к разработке] Ключевые технические решения и структура приложения'.)

_Этот выбор определяет уровень детализации по умолчанию, который можно скорректировать для отдельных историй/эпиков._

### 2. Уточните режим взаимодействия (структура и детализация PRD)

- **Пошагово (по умолчанию):** Прорабатываем разделы PRD последовательно, запрашивая обратную связь по каждому. Для эпиков/историй: сначала представляем список эпиков для утверждения, затем детализируем истории для каждого эпика по очереди.
- **YOLO-режим:** Черновик PRD (или его крупные части) готовится сразу для единого большого ревью.

### 3. Анализ входных данных

Изучите предоставленные материалы: проектный бриф, исследования, идеи пользователя.

### 4. Проработка разделов PRD

Сообщите пользователю, что будете прорабатывать разделы PRD по очереди (если не YOLO). После каждого раздела предложите [расширенные опции саморефлексии и уточнения](#предложить-расширенные-опции-саморефлексии-и-уточнения)

<important_rule>В разделе "Технические допущения" обязательно обсудите и зафиксируйте структуру репозитория (Monorepo vs Polyrepo) и высокоуровневую архитектуру сервисов (монолит, микросервисы, serverless-функции в Monorepo). Это критическая точка, влияющая на MVP и архитектуру. Решение фиксируется в PRD и повторяется в разделе "Начальный prompt для архитектора".</important_rule>

<important_rule>
**Для "Упрощённого перехода от PM к разработке":**
После обсуждения первых разделов PRD (Проблема, Цели, Персоны) и до детализации эпиков/историй — добавьте и заполните раздел '[ОПЦИОНАЛЬНО: Для упрощённого перехода от PM к разработке] Ключевые технические решения и структура приложения'.

- Проверьте наличие файла `docs/technical-preferences.md`. Если он есть, сообщите пользователю, что будете сверяться с ним при обсуждении технических решений, но все решения подтверждайте с пользователем.
- Задайте вопросы:
  1. "Какие основные языки и фреймворки планируются для фронтенда и бэкенда? (Проверю ваши предпочтения в technical-preferences.)"
  2. "Какую СУБД планируете использовать? (Проверяю предпочтения...)"
  3. "Есть ли ключевые облачные сервисы, библиотеки или платформы деплоя, которые нужно учесть? (Проверяю предпочтения...)"
  4. "Как вы видите структуру папок/модулей приложения? Опишите ключевые компоненты и их ответственность. (Учитываю ваши структурные предпочтения.)"
  5. "Monorepo или отдельные репозитории для разных частей приложения?"
- Этот раздел дополняется по мере появления новых требований или ограничений.
</important_rule>

<important_rule>
Для раздела эпиков и историй (в пошаговом режиме): подготовьте предварительный список эпиков и историй, используя все предоставленные данные и специфику Flutter приложения (feature-based архитектура, BLoC, Supabase, Firebase, CI/CD, тестирование, документация, UX, accessibility, мобильные best practices).
</important_rule>

#### 4A. Презентация и проработка эпиков

Сначала представьте пользователю заголовки и описания эпиков для проверки полноты и корректности.

#### 4B. Генерация и ревью историй внутри эпика (Пошаговый режим)

После утверждения списка эпиков:

1. Сгенерируйте все user stories для текущего эпика, учитывая специфику мобильной Flutter разработки (например, авторизация, push-уведомления, offline-режим, интеграция с Supabase/Firebase, локализация, accessibility).
2. Проведите внутренний анализ:
   - Проверьте, не являются ли некоторые истории кросс-функциональными требованиями (например, тема, DI, тестирование, безопасность, производительность, accessibility) — если да, интегрируйте их как Acceptance Criteria или в соответствующие разделы PRD.
   - Определите логическую последовательность выполнения историй, выявите зависимости (например, "История X должна быть выполнена до Y, так как Y использует результат X").
   - Подготовьте обоснование предложенного порядка.
3. Представьте пользователю:
   - Полный список историй для эпика.
   - Предложенную последовательность.
   - Краткое обоснование порядка и ключевые зависимости.
4. Обсудите структуру и порядок с пользователем, внесите корректировки.
5. После согласования — проработайте детали (описание, Acceptance Criteria) каждой истории по очереди.
6. После каждого шага предложите [расширенные опции саморефлексии и уточнения](#предложить-расширенные-опции-саморефлексии-и-уточнения).

#### 4C. Полный черновик

После завершения всех разделов (или в YOLO-режиме) представьте полный черновик PRD.

#### 4D. Передача UI/UX

Если продукт содержит UI:

- Включите в PRD специальный раздел с prompt для Design Architect (UI/UX Specification Mode), где укажите:
  - Использовать этот PRD как основной вход.
  - Проработать пользовательские сценарии, wireframes, макеты, требования к usability и accessibility.
  - Заполнить или создать документ `front-end-spec-tmpl`.
  - Обеспечить, чтобы PRD был дополнен или ссылался на UI/UX-спецификацию.
- После финализации PRD настоятельно рекомендуйте:
  - Сначала привлечь Design Architect для UI/UX-спецификации.
  - После завершения UI/UX — передать PRD архитектору для технической проработки.
- Если UI нет — переходите сразу к архитектору.

---

## Принципы генерации эпиков и user stories

### I. Стратегия: чётко определяйте ценность и MVP

- Глубоко проанализируйте проблему, потребности пользователей и бизнес-цели MVP.
- Жёстко фильтруйте фичи: "Дает ли это ценность для MVP и целевой персоны?" Всё лишнее — в post-MVP.

### II. Структурирование: ценностные эпики и логическая последовательность

- Эпики — это логические, ценностные блоки, дающие пользователю или бизнесу ощутимый результат.
- Первый эпик — всегда инфраструктурный (инициализация проекта, репозиторий, CI/CD, базовые интеграции, shell авторизации и т.д.).
- Для Flutter приложений: учтите feature-based структуру, настройку BLoC, DI, интеграции с Supabase/Firebase, тестирование, документацию, CI/CD, UX, accessibility.
- Для каждой истории определяйте зависимости и логический порядок.

### III. User stories: вертикальные срезы, ценность и ясность

- Истории — это "вертикальные срезы": каждая реализует законченную ценность (UI, логика, данные, интеграции).
- Формулируйте истории по шаблону: "Как [персона], я хочу [действие], чтобы [ценность]".
- Не создавайте чисто технические истории, кроме инфраструктурного эпика или если это критически необходимо для ценности.
- Размер истории — на одну итерацию (спринт).
- По возможности делайте истории независимыми, явно отмечайте зависимости.

### IV. Детализация: Acceptance Criteria и поддержка разработки

- Acceptance Criteria должны быть чёткими, тестируемыми, покрывать функциональные и нефункциональные требования (performance, security, UX, accessibility, тестируемость, покрытие тестами, статический анализ).
- Для Flutter приложения: добавляйте требования к тестам (unit, widget, integration), CI/CD, документации, производительности, UX, accessibility.
- Для историй с UI — указывайте требования к дизайну, адаптивности, accessibility, best practices Flutter.

### V. Кросс-функциональные требования

- Не выносите кросс-функциональные требования в отдельные истории, если они не дают самостоятельной ценности.
- Интегрируйте их как Acceptance Criteria или фиксируйте в соответствующих разделах PRD.
- Для Flutter приложения: это может быть DI, тема, тестирование, безопасность, производительность, accessibility, локализация.

### VI. Качество и передача

- Истории должны быть готовы для архитектурного ревью и планирования: ясные, тестируемые, с отмеченными зависимостями и учётом инфраструктурных работ.

---

## Предложить расширенные опции саморефлексии и уточнения

Перед завершением каждого раздела предложите пользователю:

"Для повышения качества раздела **[Название раздела]** и его проработки, я могу выполнить одну из следующих опций. Выберите номер (8 — завершить и перейти дальше):

1. **Критический самоанализ и проверка соответствия целям пользователя**
2. **Генерация и оценка альтернативных решений**
3. **Стресс-тест пользовательских сценариев и взаимодействий**
4. **Глубокий разбор допущений и ограничений дизайна**
5. **Аудит usability и accessibility, уточняющие вопросы**
6. **Совместный брейншторминг UI-фич и идей**
7. **Выявление скрытых пользовательских потребностей и будущих сценариев**
8. **Завершить раздел и двигаться дальше**

После выполнения выбранной опции обсудим результат и при необходимости внесём корректировки. Повторяйте до выбора 8.

---

**После внесения изменений рекомендуется перезагрузить приложение для применения новых инструкций.**
