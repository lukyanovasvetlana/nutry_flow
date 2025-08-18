# Доступ к Репозиторию - NutryFlow

## 🔐 Настройка доступа для разработчиков

### Шаг 1: Получение доступа к GitHub

1. **Обратитесь к Tech Lead** или **Scrum Master** для получения доступа
2. Предоставьте ваш GitHub username
3. Укажите желаемый уровень доступа:
   - **Read**: Только чтение кода
   - **Write**: Чтение и создание веток
   - **Maintain**: Управление репозиторием
   - **Admin**: Полный доступ

### Шаг 2: Настройка SSH ключей (рекомендуется)

```bash
# Генерация SSH ключа
ssh-keygen -t ed25519 -C "your_email@example.com"

# Добавление ключа в ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Копирование публичного ключа
cat ~/.ssh/id_ed25519.pub
```

3. Добавьте публичный ключ в GitHub:
   - Settings → SSH and GPG keys → New SSH key
   - Вставьте скопированный ключ

### Шаг 3: Клонирование репозитория

```bash
# Через SSH (рекомендуется)
git clone git@github.com:your-org/nutry_flow.git

# Или через HTTPS
git clone https://github.com/your-org/nutry_flow.git
```

## 👥 Роли и права доступа

### Developer (Разработчик)
- ✅ Чтение кода
- ✅ Создание веток
- ✅ Создание Pull Requests
- ✅ Комментирование Issues
- ❌ Слияние в main ветку
- ❌ Удаление веток

### Maintainer (Технический лид)
- ✅ Все права Developer
- ✅ Слияние Pull Requests
- ✅ Управление Issues
- ✅ Управление Labels
- ✅ Удаление веток
- ❌ Удаление репозитория

### Admin (Администратор)
- ✅ Все права Maintainer
- ✅ Управление настройками репозитория
- ✅ Управление правами доступа
- ✅ Удаление репозитория

## 🔑 Настройка Personal Access Token

Для автоматизации и CI/CD:

1. Перейдите в GitHub Settings → Developer settings → Personal access tokens
2. Создайте новый token с правами:
   - `repo` (полный доступ к репозиториям)
   - `workflow` (для GitHub Actions)
   - `write:packages` (для публикации пакетов)

```bash
# Использование токена
git clone https://YOUR_TOKEN@github.com/your-org/nutry_flow.git
```

## 🛡️ Безопасность

### Правила работы с репозиторием

1. **Никогда не коммитьте секреты**:
   ```bash
   # Добавьте в .gitignore
   .env
   *.key
   google-services.json
   GoogleService-Info.plist
   ```

2. **Используйте переменные окружения**:
   ```bash
   # Вместо хардкода
   SUPABASE_URL=https://your-project.supabase.co
   ```

3. **Проверяйте код перед коммитом**:
   ```bash
   flutter analyze
   flutter test
   ```

### Защита веток

- **main**: Защищена, требует Pull Request
- **develop**: Защищена, требует Pull Request
- **feature/***: Свободный доступ для разработчиков

## 📋 Чек-лист доступа

- [ ] GitHub аккаунт создан
- [ ] Доступ к репозиторию получен
- [ ] SSH ключи настроены (опционально)
- [ ] Personal Access Token создан (для CI/CD)
- [ ] Репозиторий склонирован локально
- [ ] Git настроен с вашими данными
- [ ] Первый коммит создан

## 🚨 Устранение проблем

### Проблема: Доступ запрещен
```bash
# Проверьте права доступа
git ls-remote git@github.com:your-org/nutry_flow.git

# Проверьте SSH ключи
ssh -T git@github.com
```

### Проблема: Не удается клонировать
```bash
# Проверьте URL репозитория
git remote -v

# Попробуйте HTTPS вместо SSH
git clone https://github.com/your-org/nutry_flow.git
```

### Проблема: Не удается push
```bash
# Проверьте права на ветку
git push origin feature/your-branch

# Создайте Pull Request вместо прямого push в main
```

## 📞 Контакты для получения доступа

### Tech Lead
- **Email**: [tech.lead@company.com]
- **Slack**: @tech-lead
- **Discord**: @tech-lead

### Scrum Master
- **Email**: [scrum.master@company.com]
- **Slack**: @scrum-master
- **Discord**: @scrum-master

### DevOps Engineer
- **Email**: [devops@company.com]
- **Slack**: @devops
- **Discord**: @devops

## 🔄 Процесс добавления нового разработчика

1. **Запрос доступа**:
   - Разработчик обращается к Tech Lead
   - Указывает GitHub username и желаемую роль

2. **Проверка**:
   - Tech Lead проверяет квалификацию
   - Определяет подходящий уровень доступа

3. **Настройка**:
   - Добавление в команду GitHub
   - Настройка прав доступа
   - Отправка приглашения

4. **Онбординг**:
   - Отправка ссылки на документацию
   - Помощь с настройкой среды
   - Первое задание

## 📚 Дополнительные ресурсы

- [GitHub Documentation](https://docs.github.com/)
- [GitHub Security](https://docs.github.com/en/github/security)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub CLI](https://cli.github.com/)

---

**Версия**: 1.0  
**Последнее обновление**: [DATE]  
**Ответственный**: Tech Lead
