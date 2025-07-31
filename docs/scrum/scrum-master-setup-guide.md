# Scrum Master Setup Guide - NutryFlow

## 🚀 Быстрый старт

### Шаг 1: Настройка GitHub Secrets

Добавьте следующие secrets в настройках вашего GitHub репозитория:

1. Перейдите в **Settings** → **Secrets and variables** → **Actions**
2. Добавьте следующие secrets:

```bash
# Обязательные
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx  # GitHub Personal Access Token

# Опциональные (для уведомлений)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxx/yyy/zzz
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/xxx/yyy
```

### Шаг 2: Настройка Labels

Создайте следующие labels в вашем репозитории:

```bash
# Sprint Labels
sprint-active
sprint-planning
retrospective
team-happiness

# Priority Labels
priority-high
priority-medium
priority-low

# Story Points Labels
story-points-1
story-points-2
story-points-3
story-points-5
story-points-8
story-points-13

# Epic Labels
epic-onboarding
epic-navigation
epic-dashboard
epic-activity
epic-menu
epic-meal-plan

# Status Labels
in-progress
blocker
bug
documentation
```

### Шаг 3: Первый запуск

1. Перейдите в **Actions** → **Scrum Master Automation**
2. Нажмите **Run workflow**
3. Выберите действие `daily-report`
4. Нажмите **Run workflow**

## 📋 Ежедневные операции

### Daily Standup

**Время**: Ежедневно в 9:00 UTC (12:00 МСК)
**Автоматизация**: GitHub Actions генерирует отчет

**Что делать**:
1. Проверьте автоматически сгенерированный отчет
2. Обновите статус задач в GitHub Issues
3. Отметьте блокеры с label `blocker`
4. Обновите story points в labels

### Sprint Planning

**Частота**: Каждые 2 недели
**Длительность**: 2 часа

**Процесс**:
1. Запустите workflow с действием `planning-template`
2. Заполните параметры:
   - `sprint_number`: Номер спринта
   - `start_date`: Дата начала (YYYY-MM-DD)
   - `end_date`: Дата окончания (YYYY-MM-DD)
   - `goal`: Цель спринта
3. Создайте GitHub Issue с шаблоном
4. Добавьте задачи в Sprint Backlog
5. Назначьте story points

### Sprint Review

**Частота**: В конце каждого спринта
**Длительность**: 1 час

**Процесс**:
1. Запустите workflow с действием `velocity`
2. Проанализируйте метрики
3. Демонстрируйте готовый функционал
4. Обновите Product Backlog

### Sprint Retrospective

**Частота**: После каждого Sprint Review
**Длительность**: 45 минут

**Процесс**:
1. Запустите workflow с действием `retrospective-template`
2. Заполните шаблон ретроспективы
3. Определите action items
4. Обновите процессы на основе feedback

## 📊 Метрики и KPI

### Автоматически отслеживаемые метрики

| Метрика | Описание | Целевое значение |
|---------|----------|------------------|
| Velocity | Story points за спринт | 20-30 points |
| Defect Rate | % дефектов от общего числа задач | < 20% |
| Cycle Time | Среднее время выполнения задачи | < 5 дней |
| Sprint Goal Achievement | % достижения целей спринта | > 80% |
| Team Happiness | Индекс удовлетворенности команды | > 4/5 |

### Как интерпретировать метрики

#### Velocity
- **Высокий (>30)**: Команда может брать больше задач
- **Нормальный (20-30)**: Стабильная работа
- **Низкий (<20)**: Нужно анализировать причины

#### Defect Rate
- **Низкий (<10%)**: Отличное качество
- **Средний (10-20%)**: Приемлемо
- **Высокий (>20%)**: Требует внимания

#### Cycle Time
- **Короткий (<3 дня)**: Эффективная работа
- **Средний (3-5 дней)**: Нормально
- **Длинный (>5 дней)**: Нужно разбивать задачи

## 🔧 Ручные команды

### Генерация ежедневного отчета

```bash
python scripts/scrum_automation.py \
  --action daily-report \
  --github-token YOUR_TOKEN \
  --repo owner/repo \
  --webhook-url YOUR_WEBHOOK_URL
```

### Создание шаблона планирования

```bash
python scripts/scrum_automation.py \
  --action planning-template \
  --github-token YOUR_TOKEN \
  --repo owner/repo \
  --sprint-number 3 \
  --start-date 2024-01-15 \
  --end-date 2024-01-28 \
  --goal "Implement user profile management"
```

### Генерация метрик спринта

```bash
python scripts/generate_sprint_metrics.py \
  --github-token YOUR_TOKEN \
  --repo owner/repo \
  --output sprint_report.md
```

### Создание burndown chart

```bash
python scripts/generate_burndown_chart.py \
  --github-token YOUR_TOKEN \
  --repo owner/repo \
  --sprint-duration 14
```

## 🎯 Best Practices

### Для Scrum Master

1. **Ежедневный мониторинг**
   - Проверяйте автоматические отчеты
   - Отслеживайте блокеры
   - Обновляйте метрики

2. **Еженедельный анализ**
   - Анализируйте тренды velocity
   - Проверяйте качество задач
   - Обновляйте процессы

3. **Ежемесячный обзор**
   - Проводите глубокий анализ метрик
   - Обновляйте Definition of Done
   - Планируйте улучшения

### Для команды

1. **Обновление задач**
   - Регулярно обновляйте статус задач
   - Добавляйте story points к задачам
   - Отмечайте блокеры

2. **Качество кода**
   - Следуйте Definition of Done
   - Пишите тесты
   - Проводите code review

3. **Коммуникация**
   - Участвуйте в daily standup
   - Делитесь проблемами
   - Предлагайте улучшения

## 🚨 Troubleshooting

### Проблема: Не генерируются отчеты

**Решение**:
1. Проверьте GitHub token
2. Убедитесь, что есть задачи с label `sprint-active`
3. Проверьте права доступа к репозиторию

### Проблема: Неправильные story points

**Решение**:
1. Убедитесь, что задачи имеют правильные labels
2. Проверьте формат: `story-points-X`
3. Обновите labels вручную

### Проблема: Не работают уведомления

**Решение**:
1. Проверьте webhook URL
2. Убедитесь, что URL активен
3. Проверьте права доступа к каналу

### Проблема: Нет данных для burndown chart

**Решение**:
1. Убедитесь, что задачи имеют story points
2. Проверьте, что есть завершенные задачи
3. Убедитесь, что даты закрытия корректны

## 📈 Расширенная настройка

### Интеграция с Slack

1. Создайте Slack app
2. Добавьте webhook URL в secrets
3. Настройте каналы для уведомлений

### Интеграция с Discord

1. Создайте webhook в Discord
2. Добавьте URL в secrets
3. Настройте права доступа

### Кастомные метрики

1. Отредактируйте `scripts/scrum_automation.py`
2. Добавьте новые функции расчета
3. Обновите отчеты

## 📞 Поддержка

### Контакты
- **Scrum Master**: [ВАШ_КОНТАКТ]
- **Technical Lead**: [TECH_LEAD]
- **Product Owner**: [PRODUCT_OWNER]

### Документация
- [Scrum Master Guide](scrum-master-guide.md)
- [Product Backlog](product-backlog.md)
- [Sprint Templates](sprint-templates.md)

### Полезные ссылки
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Scrum Guide](https://scrumguides.org/)
- [Agile Manifesto](https://agilemanifesto.org/)

---

**Версия**: 1.0
**Последнее обновление**: [DATE]
**Следующий обзор**: [NEXT_REVIEW_DATE] 