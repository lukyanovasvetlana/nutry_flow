# Документация API NutryFlow

## 1. Обзор API

### 1.1 Базовый URL
```
Production: https://your-project.supabase.co
Development: https://your-dev-project.supabase.co
```

### 1.2 Аутентификация
API использует JWT токены для аутентификации. Токен должен передаваться в заголовке `Authorization`:
```
Authorization: Bearer <jwt_token>
```

### 1.3 Формат Ответов
Все ответы возвращаются в формате JSON с следующей структурой:

#### Успешный ответ:
```json
{
  "data": {
    // Данные ответа
  },
  "message": "Операция выполнена успешно"
}
```

#### Ответ с ошибкой:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Описание ошибки",
    "details": {}
  }
}
```

## 2. Аутентификация

### 2.1 Регистрация пользователя
```http
POST /auth/v1/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Ответ:**
```json
{
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "created_at": "2024-01-01T00:00:00Z"
    },
    "session": {
      "access_token": "jwt_token",
      "refresh_token": "refresh_token",
      "expires_at": 1234567890
    }
  }
}
```

### 2.2 Вход пользователя
```http
POST /auth/v1/token?grant_type=password
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Ответ:**
```json
{
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com"
    },
    "session": {
      "access_token": "jwt_token",
      "refresh_token": "refresh_token",
      "expires_at": 1234567890
    }
  }
}
```

### 2.3 Обновление токена
```http
POST /auth/v1/token?grant_type=refresh_token
Content-Type: application/json

{
  "refresh_token": "refresh_token"
}
```

### 2.4 Выход пользователя
```http
POST /auth/v1/logout
Authorization: Bearer <jwt_token>
```

## 3. Управление Пользователями

### 3.1 Получение профиля пользователя
```http
GET /rest/v1/users?select=*&id=eq.{user_id}
Authorization: Bearer <jwt_token>
```

**Ответ:**
```json
{
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "first_name": "Иван",
    "last_name": "Иванов",
    "birth_date": "1990-01-01",
    "height": 180,
    "weight": 75,
    "activity_level": "moderately_active",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

### 3.2 Обновление профиля пользователя
```http
PATCH /rest/v1/users?id=eq.{user_id}
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "first_name": "Иван",
  "last_name": "Иванов",
  "birth_date": "1990-01-01",
  "height": 180,
  "weight": 75,
  "activity_level": "moderately_active"
}
```

## 4. Управление Питанием

### 4.1 Получение списка продуктов
```http
GET /rest/v1/products?select=*&name=ilike.*{search_term}*
Authorization: Bearer <jwt_token>
```

**Параметры:**
- `search_term` (опционально) - поисковый запрос
- `limit` (опционально) - количество результатов (по умолчанию 50)
- `offset` (опционально) - смещение для пагинации

**Ответ:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Яблоко",
      "calories_per_100g": 52.0,
      "protein_per_100g": 0.3,
      "carbs_per_100g": 14.0,
      "fats_per_100g": 0.2,
      "barcode": "1234567890123",
      "category": "fruits",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### 4.2 Добавление продукта в дневник
```http
POST /rest/v1/nutrition_log
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "product_id": "uuid",
  "quantity_grams": 150.0,
  "meal_type": "breakfast",
  "consumed_at": "2024-01-01T08:00:00Z"
}
```

**Ответ:**
```json
{
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "product_id": "uuid",
    "quantity_grams": 150.0,
    "meal_type": "breakfast",
    "consumed_at": "2024-01-01T08:00:00Z",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

### 4.3 Получение дневника питания
```http
GET /rest/v1/nutrition_log?select=*,products(*)&user_id=eq.{user_id}&consumed_at=gte.{date}&consumed_at=lt.{next_date}
Authorization: Bearer <jwt_token>
```

**Параметры:**
- `date` - дата в формате ISO (YYYY-MM-DD)
- `next_date` - следующая дата для диапазона

**Ответ:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "product_id": "uuid",
      "quantity_grams": 150.0,
      "meal_type": "breakfast",
      "consumed_at": "2024-01-01T08:00:00Z",
      "created_at": "2024-01-01T00:00:00Z",
      "products": {
        "id": "uuid",
        "name": "Яблоко",
        "calories_per_100g": 52.0,
        "protein_per_100g": 0.3,
        "carbs_per_100g": 14.0,
        "fats_per_100g": 0.2
      }
    }
  ]
}
```

### 4.4 Обновление записи в дневнике
```http
PATCH /rest/v1/nutrition_log?id=eq.{log_id}
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "quantity_grams": 200.0,
  "meal_type": "lunch"
}
```

### 4.5 Удаление записи из дневника
```http
DELETE /rest/v1/nutrition_log?id=eq.{log_id}
Authorization: Bearer <jwt_token>
```

### 4.6 Получение статистики питания
```http
GET /functions/v1/calculate-nutrition
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "user_id": "uuid",
  "date": "2024-01-01"
}
```

**Ответ:**
```json
{
  "data": {
    "calories": 1850.5,
    "protein": 85.2,
    "carbs": 220.1,
    "fats": 65.8,
    "water": 1500,
    "meals": {
      "breakfast": {
        "calories": 450.0,
        "protein": 25.0,
        "carbs": 55.0,
        "fats": 15.0
      },
      "lunch": {
        "calories": 650.0,
        "protein": 35.0,
        "carbs": 75.0,
        "fats": 25.0
      },
      "dinner": {
        "calories": 550.0,
        "protein": 30.0,
        "carbs": 60.0,
        "fats": 20.0
      },
      "snacks": {
        "calories": 200.5,
        "protein": 5.2,
        "carbs": 30.1,
        "fats": 5.8
      }
    }
  }
}
```

## 5. Управление Водным Балансом

### 5.1 Добавление записи о потреблении воды
```http
POST /rest/v1/water_log
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "amount_ml": 250,
  "consumed_at": "2024-01-01T10:00:00Z"
}
```

**Ответ:**
```json
{
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "amount_ml": 250,
    "consumed_at": "2024-01-01T10:00:00Z",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

### 5.2 Получение истории потребления воды
```http
GET /rest/v1/water_log?select=*&user_id=eq.{user_id}&consumed_at=gte.{date}&consumed_at=lt.{next_date}&order=consumed_at.desc
Authorization: Bearer <jwt_token>
```

**Ответ:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "amount_ml": 250,
      "consumed_at": "2024-01-01T10:00:00Z",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### 5.3 Получение статистики воды за день
```http
GET /functions/v1/calculate-water-stats
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "user_id": "uuid",
  "date": "2024-01-01"
}
```

**Ответ:**
```json
{
  "data": {
    "total_consumed_ml": 2000,
    "daily_goal_ml": 2500,
    "remaining_ml": 500,
    "percentage_completed": 80.0,
    "entries_count": 8
  }
}
```

## 6. Управление Физической Активностью

### 6.1 Добавление записи о тренировке
```http
POST /rest/v1/activity_log
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "activity_type": "running",
  "duration_minutes": 45,
  "calories_burned": 350,
  "distance_km": 5.5,
  "performed_at": "2024-01-01T18:00:00Z"
}
```

**Ответ:**
```json
{
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "activity_type": "running",
    "duration_minutes": 45,
    "calories_burned": 350,
    "distance_km": 5.5,
    "performed_at": "2024-01-01T18:00:00Z",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

### 6.2 Получение истории тренировок
```http
GET /rest/v1/activity_log?select=*&user_id=eq.{user_id}&performed_at=gte.{date}&performed_at=lt.{next_date}&order=performed_at.desc
Authorization: Bearer <jwt_token>
```

**Ответ:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "activity_type": "running",
      "duration_minutes": 45,
      "calories_burned": 350,
      "distance_km": 5.5,
      "performed_at": "2024-01-01T18:00:00Z",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### 6.3 Получение статистики активности
```http
GET /functions/v1/calculate-activity-stats
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "user_id": "uuid",
  "date": "2024-01-01"
}
```

**Ответ:**
```json
{
  "data": {
    "total_calories_burned": 450,
    "total_duration_minutes": 60,
    "total_distance_km": 7.5,
    "activities_count": 2,
    "activities_by_type": {
      "running": {
        "count": 1,
        "duration_minutes": 45,
        "calories_burned": 350,
        "distance_km": 5.5
      },
      "walking": {
        "count": 1,
        "duration_minutes": 15,
        "calories_burned": 100,
        "distance_km": 2.0
      }
    }
  }
}
```

## 7. Управление Целями

### 7.1 Получение целей пользователя
```http
GET /rest/v1/user_goals?select=*&user_id=eq.{user_id}
Authorization: Bearer <jwt_token>
```

**Ответ:**
```json
{
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "daily_calories": 2000,
    "daily_protein": 150.0,
    "daily_carbs": 250.0,
    "daily_fats": 65.0,
    "daily_water_ml": 2500,
    "activity_level": "moderately_active",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

### 7.2 Обновление целей пользователя
```http
PATCH /rest/v1/user_goals?user_id=eq.{user_id}
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "daily_calories": 2200,
  "daily_protein": 160.0,
  "daily_carbs": 270.0,
  "daily_fats": 70.0,
  "daily_water_ml": 2800,
  "activity_level": "very_active"
}
```

### 7.3 Создание целей пользователя
```http
POST /rest/v1/user_goals
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "daily_calories": 2000,
  "daily_protein": 150.0,
  "daily_carbs": 250.0,
  "daily_fats": 65.0,
  "daily_water_ml": 2500,
  "activity_level": "moderately_active"
}
```

## 8. Supabase Edge Functions

### 8.1 Расчет питания за день
```typescript
// supabase/functions/calculate-nutrition/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { user_id, date } = await req.json()
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? ''
  )
  
  const { data, error } = await supabase
    .from('nutrition_log')
    .select(`
      *,
      products (*)
    `)
    .eq('user_id', user_id)
    .gte('consumed_at', date)
    .lt('consumed_at', new Date(date.getTime() + 24 * 60 * 60 * 1000))
  
  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' }
    })
  }
  
  const totals = data.reduce((acc, log) => {
    const product = log.products
    const multiplier = log.quantity_grams / 100
    
    acc.calories += product.calories_per_100g * multiplier
    acc.protein += product.protein_per_100g * multiplier
    acc.carbs += product.carbs_per_100g * multiplier
    acc.fats += product.fats_per_100g * multiplier
    
    return acc
  }, { calories: 0, protein: 0, carbs: 0, fats: 0 })
  
  return new Response(JSON.stringify(totals), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

### 8.2 Расчет статистики воды
```typescript
// supabase/functions/calculate-water-stats/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { user_id, date } = await req.json()
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? ''
  )
  
  // Получаем цели пользователя
  const { data: goals } = await supabase
    .from('user_goals')
    .select('daily_water_ml')
    .eq('user_id', user_id)
    .single()
  
  // Получаем записи о воде за день
  const { data: waterLogs } = await supabase
    .from('water_log')
    .select('amount_ml')
    .eq('user_id', user_id)
    .gte('consumed_at', date)
    .lt('consumed_at', new Date(date.getTime() + 24 * 60 * 60 * 1000))
  
  const totalConsumed = waterLogs?.reduce((sum, log) => sum + log.amount_ml, 0) ?? 0
  const dailyGoal = goals?.daily_water_ml ?? 2500
  const remaining = Math.max(0, dailyGoal - totalConsumed)
  const percentageCompleted = (totalConsumed / dailyGoal) * 100
  
  return new Response(JSON.stringify({
    total_consumed_ml: totalConsumed,
    daily_goal_ml: dailyGoal,
    remaining_ml: remaining,
    percentage_completed: Math.round(percentageCompleted * 100) / 100,
    entries_count: waterLogs?.length ?? 0
  }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

## 9. Обработка Ошибок

### 9.1 Коды ошибок
- `AUTH_REQUIRED` - Требуется аутентификация
- `INVALID_TOKEN` - Недействительный токен
- `PERMISSION_DENIED` - Отказано в доступе
- `VALIDATION_ERROR` - Ошибка валидации данных
- `NOT_FOUND` - Ресурс не найден
- `SERVER_ERROR` - Внутренняя ошибка сервера

### 9.2 Примеры ошибок
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Неверный формат email",
    "details": {
      "field": "email",
      "value": "invalid-email"
    }
  }
}
```

```json
{
  "error": {
    "code": "PERMISSION_DENIED",
    "message": "У вас нет прав для доступа к этому ресурсу",
    "details": {
      "resource": "nutrition_log",
      "action": "read"
    }
  }
}
```

## 10. Rate Limiting

API имеет ограничения на количество запросов:
- 1000 запросов в минуту для аутентифицированных пользователей
- 100 запросов в минуту для неаутентифицированных пользователей

При превышении лимита возвращается ошибка:
```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Превышен лимит запросов. Попробуйте позже.",
    "details": {
      "retry_after": 60
    }
  }
}
```

## 11. Webhooks

### 11.1 Подписка на события
```http
POST /rest/v1/webhooks
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "url": "https://your-app.com/webhook",
  "events": ["nutrition_log.insert", "water_log.insert", "activity_log.insert"]
}
```

### 11.2 Формат webhook события
```json
{
  "type": "INSERT",
  "table": "nutrition_log",
  "record": {
    "id": "uuid",
    "user_id": "uuid",
    "product_id": "uuid",
    "quantity_grams": 150.0,
    "meal_type": "breakfast",
    "consumed_at": "2024-01-01T08:00:00Z"
  },
  "old_record": null,
  "schema": "public"
}
```

Эта документация API предоставляет полное описание всех эндпоинтов и интеграций для проекта NutryFlow. 