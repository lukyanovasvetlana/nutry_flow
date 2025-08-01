# Шаблон Плана Шардирования Документов

Этот план указывает агенту, как разбивать большие исходные документы на более мелкие, гранулированные файлы во время его Фазы Библиотекаря. Агент будет ссылаться на этот план, чтобы идентифицировать исходные документы, конкретные разделы для извлечения и целевые имена файлов для шардированного контента.

---

## 1. Исходный Документ: PRD (Документ Требований к Проекту)

- **Примечание для Агента:** Подтвердите точное имя файла PRD с пользователем (например, `PRD.md`, `ProjectRequirements.md`, `prdx.y.z.md`).

### 1.1. Грануляция по Эпикам

- **Инструкция:** Для каждого Эпика, определенного в PRD:
- **Исходный Раздел(ы) для Копирования:** Полный текст для Эпика, включая его основное описание, цели и все связанные пользовательские истории или подробные требования под этим Эпиком. Убедитесь, что захватываете контент, начинающийся с заголовка типа "**Epic X:**" до следующего такого заголовка или конца раздела "Обзор Эпика".
- **Шаблон Целевого Файла:** `docs/epic-<id>.md`
  - _Примечание Агента: `<id>` должен соответствовать номеру Эпика._

---

## 2. Исходный Документ: Основной Архитектурный Документ

- **Примечание для Агента:** Подтвердите точное имя файла с пользователем (например, `architecture.md`, `SystemArchitecture.md`, `документ-архитектуры.md`).

### 2.1. Основные Архитектурные Гранулы

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "API Reference", "API Endpoints", "Service Interfaces" или "API Reference". Переведите название на "API Reference".
- **Целевой Файл:** `docs/api-reference.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "Data Models", "Database Schema", "Entity Definitions" или "Модели Данных". Переведите название на "Модели Данных".
- **Целевой Файл:** `docs/data-models.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Environment Variables Documentation", "Configuration Settings", "Deployment Parameters", или соответствующие подразделы в "Инфраструктура и Обзор Развертывания" (или "Infrastructure and Deployment Overview"), если выделенный раздел не найден. Переведите название на "Переменные Окружения".
- **Целевой Файл:** `docs/environment-vars.md`

  - _Примечание Агента: Приоритизируйте выделенный раздел 'Переменные Окружения' или связанный исходник 'environment-vars.md', если доступны. В противном случае извлеките соответствующие детали конфигурации из 'Инфраструктура и Обзор Развертывания'. Этот шард предназначен для специфических определений и использования переменных._

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "Project Structure" или "Структура Проекта". Переведите название на "Структура Проекта".
- **Целевой Файл:** `docs/project-structure.md`

  - _Примечание Агента: Если проект включает несколько репозиториев (не монорепо), убедитесь, что этот файл четко описывает структуру каждого соответствующего репозитория или ссылается на подфайлы, если необходимо._

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "Technology Stack", "Key Technologies", "Libraries and Frameworks", "Definitive Tech Stack Selections" или "Окончательный Выбор Технологического Стека". Переведите название на "Технологический Стек".
- **Целевой Файл:** `docs/tech-stack.md`

- **Исходный Раздел(ы) для Копирования:** Разделы, детализирующие "Coding Standards", "Development Guidelines", "Best Practices", "Testing Strategy", "Testing Decisions", "QA Processes", "Overall Testing Strategy", "Error Handling Strategy", "Security Best Practices" или "Стандарты Кодирования", "Общая Стратегия Тестирования", "Стратегия Обработки Ошибок", "Лучшие Практики Безопасности". Переведите название на "Операционные Руководства".
- **Целевой Файл:** `docs/operational-guidelines.md`

  - _Примечание Агента: Этот файл объединяет несколько ключевых операционных аспектов. Убедитесь, что контент из каждого исходного раздела ("Стандарты Кодирования", "Общая Стратегия Тестирования", "Стратегия Обработки Ошибок", "Лучшие Практики Безопасности") четко разграничен под своим собственным заголовком H3 (###) или H4 (####) внутри этого документа._

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Component View" (включая подразделы типа "Architectural / Design Patterns Adopted") или "Вид Компонентов". Переведите название на "Вид Компонентов".
- **Целевой Файл:** `docs/component-view.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Core Workflow / Sequence Diagrams" (включая все поддиаграммы) или "Основной Рабочий Процесс / Диаграммы Последовательности". Переведите название на "Диаграммы Последовательности".
- **Целевой Файл:** `docs/sequence-diagrams.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Infrastructure and Deployment Overview" или "Инфраструктура и Обзор Развертывания". Переведите название на "Инфраструктура и Развертывание".
- **Целевой Файл:** `docs/infra-deployment.md`

  - _Примечание Агента: Это для более широкого обзора, отличающегося от специфического `docs/environment-vars.md`._

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Key Reference Documents" или "Ключевые Ссылочные Документы". Переведите название на "Ключевые Ссылки".
- **Целевой Файл:** `docs/key-references.md`

---

## 3. Исходный Документ(ы): Документация, Специфичная для Фронтенда

- **Примечание для Агента:** Подтвердите имена файлов с пользователем (например, `front-end-architecture.md`, `front-end-spec.md`, `ui-guidelines.md`, `архитектура-фронтенда.md`). Может существовать несколько документов по Фронтенду.

### 3.1. Гранулы Фронтенда

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "Front-End Project Structure" или "Detailed Frontend Directory Structure" или "Структура Проекта Фронтенда". Переведите название на "Структура Проекта Фронтенда".
- **Целевой Файл:** `docs/front-end-project-structure.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "UI Style Guide", "Brand Guidelines", "Visual Design Specifications", "Styling Approach" или "Руководство по Стилю UI". Переведите название на "Руководство по Стилю Фронтенда".
- **Целевой Файл:** `docs/front-end-style-guide.md`

  - _Примечание Агента: Этот раздел может быть подразделом или ссылаться на другие документы (например, `ui-ux-spec.txt`). Извлеките основную философию стиля и подход, определенные в самом документе архитектуры фронтенда._

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "Component Library", "Reusable UI Components Guide", "Atomic Design Elements", "Component Breakdown & Implementation Details" или "Библиотека Компонентов UI". Переведите название на "Руководство по Компонентам Фронтенда".
- **Целевой Файл:** `docs/front-end-component-guide.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), детализирующие "Front-End Coding Standards" (особенно для разработки UI, например, стиль JavaScript/TypeScript, соглашения по именованию CSS, лучшие практики доступности для FE) или "Стандарты Кодирования Фронтенда". Переведите название на "Стандарты Кодирования Фронтенда".
- **Целевой Файл:** `docs/front-end-coding-standards.md`

  - _Примечание Агента: Выделенного раздела верхнего уровня для этого может не существовать. Если не найден, этот шард может быть пустым или требовать перекрестных ссылок с основными стандартами кодирования архитектуры. Извлеките любые специфические для фронтенда соглашения по кодированию, упомянутые в документе._

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "State Management In-Depth" или "Управление Состоянием". Переведите название на "Управление Состоянием Фронтенда".
- **Целевой Файл:** `docs/front-end-state-management.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "API Interaction Layer" или "Слой Взаимодействия с API". Переведите название на "Взаимодействие с API Фронтенда".
- **Целевой Файл:** `docs/front-end-api-interaction.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Routing Strategy" или "Стратегия Маршрутизации". Переведите название на "Стратегия Маршрутизации Фронтенда".
- **Целевой Файл:** `docs/front-end-routing-strategy.md`

- **Исходный Раздел(ы) для Копирования:** Раздел(ы), озаглавленные "Frontend Testing Strategy" или "Стратегия Тестирования Фронтенда". Переведите название на "Стратегия Тестирования Фронтенда".
- **Целевой Файл:** `docs/front-end-testing-strategy.md`

---

CRITICAL: **Управление Индексом:** После создания файлов обновите `docs/index.md` по мере необходимости, чтобы ссылаться и описывать каждый документ - не упоминайте гранулы или откуда он был шардирован, только назначение документа - поскольку индекс также может содержать другие ссылки на документы.
