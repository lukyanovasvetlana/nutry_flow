# Scrum Master Integration - NutryFlow

## 🎯 Обзор

Комплексная интеграция Scrum Master в проект NutryFlow с автоматизацией процессов, метриками и инструментами для эффективного управления Agile-разработкой.

## 🚀 Быстрый старт

### 1. Настройка окружения

```bash
# Установка зависимостей
pip install -r scripts/requirements.txt

# Настройка GitHub token
export GITHUB_TOKEN=your_github_token
```

### 2. Первый запуск

```bash
# Генерация ежедневного отчета
python scripts/scrum_automation.py \
  --action daily-report \
  --github-token $GITHUB_TOKEN \
  --repo owner/nutry_flow
```

### 3. Настройка GitHub Actions

1. Перейдите в **Settings** → **Secrets and variables** → **Actions**
2. Добавьте `GITHUB_TOKEN` и опционально `SLACK_WEBHOOK_URL`
3. Включите GitHub Actions в репозитории

## 📁 Структура файлов

```
docs/scrum/
├── scrum-master-integration.md    # Основная документация интеграции
├── scrum-master-setup-guide.md   # Руководство по настройке
├── scrum-master-guide.md         # Общее руководство Scrum Master
├── product-backlog.md            # Product Backlog
├── sprint-1-backlog.md          # Sprint 1 Backlog
├── sprint-2-backlog.md          # Sprint 2 Backlog
└── daily-scrum-template.md      # Шаблон ежедневного стендапа

scripts/
├── scrum_automation.py          # Основной скрипт автоматизации
├── generate_sprint_metrics.py   # Генерация метрик спринта
├── generate_burndown_chart.py   # Создание burndown chart
├── requirements.txt             # Python зависимости
└── daily-standup.sh            # Bash скрипт для стендапа

.github/workflows/
└── scrum-automation.yml        # GitHub Actions для автоматизации
```

## 🔧 Основные функции

### Автоматизация процессов

- ✅ **Ежедневные отчеты** - автоматическая генерация стендапов
- ✅ **Sprint Planning** - шаблоны для планирования спринтов
- ✅ **Retrospectives** - шаблоны для ретроспектив
- ✅ **Burndown Charts** - визуализация прогресса спринта
- ✅ **Team Happiness** - опросы удовлетворенности команды

### Метрики и KPI

- 📊 **Velocity** - скорость команды в story points
- 📊 **Defect Rate** - процент дефектов
- 📊 **Cycle Time** - время выполнения задач
- 📊 **Sprint Goal Achievement** - достижение целей спринта
- 📊 **Team Happiness Index** - индекс удовлетворенности

### Интеграции

- 🔗 **GitHub Issues** - управление задачами
- 🔗 **GitHub Actions** - автоматизация процессов
- 🔗 **Slack/Discord** - уведомления команды
- 🔗 **Matplotlib** - визуализация метрик

## 📋 Ежедневные операции

### Daily Standup (9:00 UTC)

```bash
# Автоматический запуск через GitHub Actions
# Или ручной запуск:
python scripts/scrum_automation.py --action daily-report
```

### Sprint Planning (каждые 2 недели)

```bash
python scripts/scrum_automation.py \
  --action planning-template \
  --sprint-number 3 \
  --start-date 2024-01-15 \
  --end-date 2024-01-28 \
  --goal "Implement user profile management"
```

### Sprint Review (конец спринта)

```bash
python scripts/scrum_automation.py --action velocity
python scripts/generate_sprint_metrics.py
```

### Sprint Retrospective (после review)

```bash
python scripts/scrum_automation.py \
  --action retrospective-template \
  --sprint-number 3
```

## 📊 Метрики

### Автоматически отслеживаемые

| Метрика | Целевое значение | Описание |
|---------|------------------|----------|
| Velocity | 20-30 points | Story points за спринт |
| Defect Rate | < 20% | Процент дефектов |
| Cycle Time | < 5 дней | Время выполнения задач |
| Goal Achievement | > 80% | Достижение целей спринта |
| Team Happiness | > 4/5 | Удовлетворенность команды |

### Визуализация

- 📈 **Burndown Charts** - графики сгорания задач
- 📊 **Sprint Metrics** - детальные метрики спринта
- 📋 **Status Distribution** - распределение по статусам
- 🎯 **Priority Analysis** - анализ приоритетов

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

## 🚨 Troubleshooting

### Частые проблемы

1. **Не генерируются отчеты**
   - Проверьте GitHub token
   - Убедитесь в наличии задач с label `sprint-active`

2. **Неправильные story points**
   - Проверьте формат labels: `story-points-X`
   - Обновите labels вручную

3. **Не работают уведомления**
   - Проверьте webhook URL
   - Убедитесь в правах доступа

## 📞 Поддержка

### Документация
- [Setup Guide](scrum-master-setup-guide.md) - подробная настройка
- [Integration Guide](scrum-master-integration.md) - детали интеграции
- [Scrum Master Guide](scrum-master-guide.md) - общее руководство

### Контакты
- **Scrum Master**: [ВАШ_КОНТАКТ]
- **Technical Lead**: [TECH_LEAD]
- **Product Owner**: [PRODUCT_OWNER]

## 🔄 Версионирование

- **v1.0** - Базовая интеграция Scrum Master
- **v1.1** - Добавление автоматизации метрик
- **v1.2** - Интеграция с Slack/Discord
- **v1.3** - Расширенные визуализации

---

**Статус**: ✅ Активно
**Последнее обновление**: [DATE]
**Следующий обзор**: [NEXT_REVIEW_DATE] 