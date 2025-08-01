# Документ Требований к Продукту (PRD) "NutryFlow"

## Цель, Задачи и Контекст

NutryFlow - это комплексное мобильное приложение для управления питанием и здоровым образом жизни. Основная цель - создать единую платформу, которая объединит контроль питания, водного баланса и физической активности в одном месте, предоставляя пользователям полную картину их здоровья и помогая достигать поставленных целей.

### Ключевые Задачи:
1. Разработать MVP с базовым функционалом отслеживания питания и физической активности к концу Q2 2024
2. Достичь 10,000 активных пользователей в течение первых 3 месяцев после релиза
3. Получить средний рейтинг 4.5+ в App Store и Google Play
4. Обеспечить retention rate 40% на 30-й день после установки

## Функциональные Требования (MVP)

### 1. Управление Питанием
- **Отслеживание калорий и ЖБУ:**
  - Ввод потребленных продуктов с указанием количества
  - Автоматический подсчет калорий и макронутриентов
  - Дневной лимит калорий с визуализацией прогресса
  - История потребления по дням/неделям/месяцам

- **База данных продуктов:**
  - Поиск по названию продукта
  - Фильтрация по категориям
  - Сканирование штрих-кодов
  - Возможность добавления пользовательских продуктов

- **Дневник питания:**
  - Разделение по приемам пищи (завтрак, обед, ужин, перекусы)
  - Визуализация дневного рациона
  - Возможность копирования приемов пищи
  - Экспорт данных

### 2. Контроль Водного Баланса
- **Отслеживание потребления воды:**
  - Ввод количества выпитой воды
  - Установка дневной нормы
  - Визуализация прогресса
  - Напоминания о необходимости пить воду

### 3. Физическая Активность
- **Базовое отслеживание тренировок:**
  - Ввод типа тренировки
  - Длительность и интенсивность
  - Сожженные калории
  - Интеграция с Apple Health/Google Fit

- **Календарь тренировок:**
  - Просмотр запланированных тренировок
  - История выполненных тренировок
  - Статистика по типам тренировок

### 4. Персонализация
- **Настройка целей:**
  - Установка целей по калориям
  - Настройка соотношения ЖБУ
  - Выбор уровня активности
  - Установка целей по воде

- **Напоминания:**
  - Напоминания о приемах пищи
  - Напоминания о тренировках
  - Напоминания о необходимости пить воду
  - Настраиваемое время напоминаний

## Нефункциональные Требования (MVP)

### 1. Производительность
- Время запуска приложения < 2 секунд
- Плавная анимация (60 FPS)
- Отзывчивый интерфейс (< 100ms)
- Эффективное использование батареи
- Оптимизация для старых устройств

### 2. Безопасность
- Безопасное хранение пользовательских данных
- Шифрование локальных данных
- Защита от несанкционированного доступа
- Соответствие GDPR
- Безопасная аутентификация

### 3. Надежность
- Работа в оффлайн-режиме
- Автоматическая синхронизация при восстановлении соединения
- Резервное копирование данных
- Обработка ошибок сети
- Восстановление после сбоев

### 4. Масштабируемость
- Поддержка большого количества пользователей
- Эффективное использование ресурсов
- Оптимизация хранения данных
- Возможность добавления новых функций

## Пользовательское Взаимодействие и Дизайн-Цели

### Общее Видение и Опыт
- Современный и минималистичный Material Design 3
- Интуитивно понятный интерфейс
- Фокус на простоте использования
- Визуальная привлекательность и мотивация

### Ключевые Парадигмы Взаимодействия
- Быстрый доступ к основным функциям через нижнюю навигацию
- Свайпы для навигации между разделами
- Жесты для быстрого ввода данных
- Виджеты для быстрого доступа к ключевым метрикам

### Основные Экраны
1. **Главный экран:**
   - Обзор дневного прогресса
   - Быстрый доступ к основным функциям
   - Виджеты с ключевыми метриками

2. **Дневник питания:**
   - Список приемов пищи
   - Форма добавления продуктов
   - Визуализация макронутриентов

3. **Тренировки:**
   - Календарь тренировок
   - Форма добавления тренировки
   - История и статистика

4. **Профиль:**
   - Настройки целей
   - Персональные данные
   - Настройки приложения

### Стремления к Доступности
- Поддержка динамического размера шрифта
- Высокий контраст для важных элементов
- Поддержка скрин-ридеров
- Адаптивный дизайн для разных размеров экрана

### Целевые Устройства/Платформы
- iOS 13+ и Android 8.0+
- Поддержка различных размеров экрана
- Оптимизация для iPhone и Android-устройств

## Технические Предположения

### Архитектура Репозитория и Сервисов
- Monorepo с Flutter-приложением
- Supabase для бэкенда (Auth, Database, Storage, Functions)
- Firebase для аналитики и уведомлений

### Стек Технологий для Фронтенда
- Flutter (Dart) для кроссплатформенной разработки
- BLoC для управления состоянием
- GoRouter для навигации
- GetIt для dependency injection
- Material Design 3 для UI

### Требования к Тестированию
- Unit-тесты для бизнес-логики
- Widget-тесты для UI компонентов
- Интеграционные тесты для ключевых сценариев
- E2E тесты для критических путей
- Тестирование на разных устройствах и версиях ОС

## Обзор Эпиков

### Эпик 1: Базовая Функциональность Питания
- **Цель:** Реализовать базовый функционал отслеживания питания и калорий

- **История 1:** Как пользователь, я хочу добавлять продукты в дневник питания, чтобы отслеживать потребленные калории и макронутриенты
  - Критерии приемки:
    - Возможность поиска продуктов в базе данных
    - Ввод количества продукта
    - Автоматический подсчет калорий и ЖБУ
    - Сохранение в дневник

- **История 2:** Как пользователь, я хочу видеть общий прогресс по калориям за день, чтобы контролировать свое питание
  - Критерии приемки:
    - Визуализация дневного лимита калорий
    - Отображение потребленных калорий
    - Разбивка по приемам пищи
    - Возможность просмотра истории

### Эпик 2: Контроль Водного Баланса
- **Цель:** Реализовать функционал отслеживания потребления воды

- **История 1:** Как пользователь, я хочу отмечать количество выпитой воды, чтобы следить за водным балансом
  - Критерии приемки:
    - Быстрый ввод количества воды
    - Визуализация прогресса
    - Настройка дневной нормы
    - История потребления

### Эпик 3: Физическая Активность
- **Цель:** Реализовать базовый функционал отслеживания тренировок

- **История 1:** Как пользователь, я хочу добавлять информацию о тренировках, чтобы отслеживать физическую активность
  - Критерии приемки:
    - Выбор типа тренировки
    - Ввод длительности
    - Подсчет сожженных калорий
    - Сохранение в календарь

### Эпик 4: Персонализация
- **Цель:** Реализовать настройку персональных целей и предпочтений

- **История 1:** Как пользователь, я хочу настраивать свои цели по калориям и макронутриентам, чтобы персонализировать приложение
  - Критерии приемки:
    - Установка дневного лимита калорий
    - Настройка соотношения ЖБУ
    - Выбор уровня активности
    - Сохранение настроек

## Идеи, Выходящие за Рамки MVP

1. **Расширенное управление питанием:**
   - AI-рекомендации по питанию
   - Планировщик питания
   - Рецепты и meal prep
   - Интеграция с доставкой продуктов

2. **Социальные функции:**
   - Группы по интересам
   - Соревнования и челленджи
   - Обмен рецептами и планами питания

3. **Расширенная аналитика:**
   - Детальная статистика и графики
   - Экспорт данных
   - Интеграция с другими фитнес-трекерами

4. **Профессиональные функции:**
   - Режимы для разных видов спорта
   - Интеграция с тренерами
   - Планы подготовки к соревнованиям

## Журнал Изменений

| Изменение | Дата | Версия | Описание | Автор |
| --------- | ---- | ------ | --------- | ----- |
| Создание PRD | 2024-03-21 | 1.0.0 | Первоначальная версия PRD | PO | 