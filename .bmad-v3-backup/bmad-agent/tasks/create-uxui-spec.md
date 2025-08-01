# Задача: Подготовка UI/UX-спецификации (Flutter приложения)

## Назначение

Совместно с пользователем определить и зафиксировать спецификацию пользовательского интерфейса (UI) и пользовательского опыта (UX) для мобильного Flutter-приложения. Включает анализ потребностей пользователя, информационную архитектуру, user flows, требования к визуальному дизайну и фронтенду. Результат — новый документ `front-end-spec.md` по шаблону `front-end-spec-tmpl`, адаптированному под Flutter/Chibis App.

## Входные данные

- Project Brief (`project-brief.md` или аналог)
- Product Requirements Document (PRD) (`prd.md` или аналог)
- Фидбек пользователей или результаты исследований (если есть)

## Ключевые шаги и инструкции

### 1. Понимание основных требований

- Изучи Project Brief и PRD: цели, целевая аудитория, ключевые фичи, ограничения.
- Задай уточняющие вопросы о потребностях, болях и желаемых результатах для мобильного приложения.

### 2. Определение UX-целей и принципов (для `front-end-spec-tmpl`)

- Совместно зафиксируйте:
  - Персоны пользователей (уточни или подтверди существующие)
  - Ключевые цели usability
  - Основные дизайн-принципы (ориентируясь на Material 3, мобильные best practices, accessibility)

### 3. Информационная архитектура (IA) (для `front-end-spec-tmpl`)

- Совместно составьте карту экранов (Screen Inventory) или Site Map.
- Определи основную и вторичную структуру навигации (GoRouter, bottom navigation, drawer и др.).
- Используй Mermaid-диаграммы или списки по шаблону.

### 4. Описание ключевых пользовательских сценариев (user flows)

- Выдели критичные задачи пользователя из PRD/brief.
- Для каждого сценария:
  - Определи цель пользователя
  - Совместно опиши шаги (Mermaid-диаграммы или пошаговое описание)
  - Учитывай edge cases и ошибки

### 5. Стратегия wireframes и мокапов

- Уточни, где будут создаваться визуальные дизайны (например, Figma) и зафиксируй ссылку в `front-end-spec-tmpl`.
- Если нужны low-fidelity wireframes — предложи помощь в концепции ключевых экранов.

### 6. Подход к компонентной библиотеке / дизайн-системе

- Обсуди, будет ли использоваться существующая дизайн-система или нужна новая (ориентируйся на Material 3, Flutter best practices).
- Если новая — выдели базовые компоненты (Button, Input, Card) и их состояния/поведение (детализация — в архитектуре фронтенда).

### 7. Основы брендинга и стайлгайда

- Если есть стайлгайд — зафиксируй ссылку.
- Если нет — совместно определите placeholders: цветовая палитра, типографика, иконки, отступы.

### 8. Accessibility (AX)

- Определи целевой уровень доступности (например, WCAG 2.1 AA, мобильные гайдлайны).
- Зафиксируй известные требования по accessibility.

### 9. Стратегия адаптивности

- Обсуди и зафиксируй ключевые breakpoints.
- Спроси пользователя под какие устройства создается приложение.
- Опиши общую стратегию адаптации под указанные устройства (мобильные, планшеты).

### 10. Генерация и доработка спецификации (по `front-end-spec-tmpl`)

- **a. Драфт секции:** Заполняй одну логическую секцию шаблона за раз.
- **b. Презентация и фидбек:** Покажи драфт пользователю, обсуди, доработай по замечаниям.
- **c. [Предлагай расширенные опции саморефлексии и элицитации](#расширенные-опции-саморефлексии-и-элицитации)**

## Расширенные опции саморефлексии и элицитации

(Этот раздел вызывается по необходимости)

Предложи пользователю следующий список "Расширенных действий для саморефлексии, элицитации и брейншторминга". Объясни, что это опциональные шаги для повышения качества, поиска альтернатив и глубокой проработки секции. Пользователь может выбрать действие по номеру или пропустить и двигаться дальше.

"Для повышения качества секции: **[Название секции]** и её надёжности, рассмотрения альтернатив и разных углов зрения, я могу выполнить одно из следующих действий. Выберите номер (8 — чтобы завершить секцию и двигаться дальше):

**Расширенные действия для саморефлексии, элицитации и брейншторминга:**

1. **Критический самоанализ и выравнивание с целями пользователя**
2. **Генерация и оценка альтернативных дизайн-решений**
3. **Стресс-тест пользовательских сценариев и взаимодействий (концептуально)**
4. **Глубокий разбор предположений и ограничений**
5. **Аудит usability и accessibility, уточняющие вопросы**
6. **Совместный брейншторминг UI-фич**
7. **Выявление "непредвиденных пользовательских потребностей" и будущих вопросов по взаимодействию**
8. **Завершить секцию и двигаться дальше**

После выполнения выбранного действия обсудим результат и решим, нужны ли доработки секции."

ПОВТОРЯЙ, пока пользователь не выберет 8 или не попросит перейти к следующей секции.
