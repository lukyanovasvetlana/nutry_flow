# Задача: Валидация по чек-листу (Flutter/Chibis App)

Эта задача описывает процесс валидации проектной документации по чек-листам. Агент должен следовать этим инструкциям для системной и тщательной проверки артефактов с учётом специфики мобильных Flutter-приложений.

## Контекст

Метод BMAD использует различные чек-листы для обеспечения качества и полноты проектных артефактов. Маппинг между чек-листами и требуемыми документами описан в `checklist-mappings`. Это позволяет легко добавлять новые чек-листы без изменения этой задачи.

## Инструкции

1. **Первичная оценка**
   - Проверь `checklist-mappings` для доступных чек-листов
   - Если пользователь указал название чек-листа:
     - Найди точное совпадение в checklist-mappings.yml
     - Если нет точного совпадения — попробуй нестрогое сопоставление (например, "архитектурный чек-лист" → "architect-checklist")
     - Если найдено несколько совпадений — уточни у пользователя
     - После выбора — используй путь checklist_file из маппинга
   - Если чек-лист не указан:
     - Спроси пользователя, какой чек-лист использовать
     - Покажи доступные варианты из checklist-mappings.yml
   - Уточни, как работать с чек-листом:
     - По секциям (интерактивный режим)
     - Сразу весь (YOLO-режим)

2. **Поиск документов**
   - Найди требуемые документы и их стандартные локации в `checklist-mappings`
   - Для каждого документа:
     - Проверь все стандартные пути из маппинга
     - Если не найден — спроси у пользователя, где находится документ
   - Убедись, что все необходимые документы доступны

3. **Обработка чек-листа**
   Если выбран интерактивный режим:
   - Проходи по каждой секции чек-листа по очереди
   - Для каждой секции:
     - Изучи все пункты
     - Проверь каждый пункт по соответствующей документации
     - Покажи выводы по секции
     - Получи подтверждение пользователя перед переходом к следующей секции

   Если выбран YOLO-режим:
   - Проверь все секции сразу
   - Составь полный отчёт по всем пунктам
   - Покажи итоговый анализ пользователю

4. **Подход к валидации**
   Для каждого пункта чек-листа:
   - Прочитай и пойми требование
   - Найди в документации явные или неявные подтверждения выполнения требования
   - Учитывай специфику Flutter: feature-based архитектура, BLoC, Supabase, Firebase, CI/CD, тестирование, документация, UX, мобильные best practices
   - Отметь пункт как:
     - ✅ ВЫПОЛНЕНО: Требование явно выполнено
     - ❌ НЕ ВЫПОЛНЕНО: Требование не выполнено или покрытие недостаточно
     - ⚠️ ЧАСТИЧНО: Выполнено частично, требуется доработка
     - N/A: Не применимо к данному случаю

5. **Анализ секции**
   Для каждой секции:
   - Подсчитай процент выполнения
   - Выдели общие проблемы по невыполненным пунктам
   - Дай конкретные рекомендации по улучшению (с учётом Flutter/мобильных best practices)
   - В интерактивном режиме обсуди выводы с пользователем
   - Зафиксируй решения и пояснения пользователя

6. **Финальный отчёт**
   Подготовь summary, включающее:
   - Общий статус выполнения чек-листа
   - Процент выполнения по секциям
   - Список невыполненных пунктов с контекстом
   - Конкретные рекомендации по улучшению
   - Все пункты, отмеченные как N/A, с обоснованием

## Особенности для Flutter/Chibis App

1. **Архитектурный чек-лист**
   - Проверяй полноту технической архитектуры с учётом feature-based структуры, BLoC, DI, Supabase, Firebase, CI/CD, тестирования, документации, мобильных best practices
   - Убедись, что покрыты вопросы безопасности, масштабируемости, производительности, мобильных интеграций
   - Проверь, что описаны деплой и эксплуатация для мобильных платформ

2. **Frontend-архитектурный чек-лист**
   - Валидация UI/UX-спецификаций (Material 3, accessibility, мобильные паттерны)
   - Проверка структуры компонентов, организации кода, подхода к state management (BLoC)
   - Убедись, что учтены responsive-дизайн, производительность, best practices Flutter

3. **PM-чек-лист**
   - Проверяй чёткость продуктовых требований, user stories, acceptance criteria
   - Убедись, что учтены исследования рынка, UX, мобильные тренды
   - Проверь, что описана техническая реализуемость для Flutter

4. **Story-чек-листы**
   - Проверяй наличие чётких acceptance criteria, технического контекста, зависимостей
   - Убедись, что story тестируемы, ценность для пользователя явно указана
   - Проверь, что story соответствуют архитектуре и best practices Flutter

## Критерии успеха

Валидация чек-листа считается завершённой, если:

1. Все релевантные пункты проверены
2. Для каждого пункта есть чёткий статус (выполнено/не выполнено/частично/N/A)
3. Даны конкретные рекомендации по невыполненным пунктам
4. Пользователь ознакомился с выводами и подтвердил их
5. Финальный отчёт содержит все решения и обоснования

## Пример взаимодействия

Агент: "Проверяю доступные чек-листы... В checklist-mappings.yml есть такие варианты. Какой использовать?"

Пользователь: "Архитектурный чек-лист"

Агент: "Работать по секциям (интерактивно) или сразу весь анализ (YOLO)?"

Пользователь: "Интерактивно"

Агент: "По маппингу нужен файл architecture.md. Стандартный путь — docs/architecture.md. Проверить там?"

[Дальнейшее взаимодействие по ответам пользователя...]
