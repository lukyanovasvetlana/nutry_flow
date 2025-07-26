# Руководство по Развертыванию NutryFlow

## 1. Обзор Развертывания

### 1.1 Архитектура Развертывания
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Supabase      │    │   Firebase      │
│   (iOS/Android) │◄──►│   (Backend)     │◄──►│   (Analytics)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   App Store     │    │   PostgreSQL    │    │   Crashlytics   │
│   Google Play   │    │   Storage       │    │   FCM           │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 1.2 Окружения
- **Development** - для разработки и тестирования
- **Staging** - для предварительного тестирования
- **Production** - для продакшена

## 2. Настройка Supabase

### 2.1 Создание проекта
1. Перейдите на [supabase.com](https://supabase.com)
2. Создайте новый проект
3. Запишите URL и API ключи

### 2.2 Настройка базы данных
```sql
-- Создание таблиц
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  first_name TEXT,
  last_name TEXT,
  birth_date DATE,
  height INTEGER,
  weight DECIMAL(5,2),
  activity_level TEXT DEFAULT 'moderately_active',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  calories_per_100g DECIMAL(8,2) NOT NULL,
  protein_per_100g DECIMAL(8,2) NOT NULL,
  carbs_per_100g DECIMAL(8,2) NOT NULL,
  fats_per_100g DECIMAL(8,2) NOT NULL,
  barcode TEXT,
  category TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE nutrition_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  quantity_grams DECIMAL(8,2) NOT NULL,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  consumed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE water_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  amount_ml INTEGER NOT NULL,
  consumed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE activity_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  activity_type TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  calories_burned INTEGER,
  distance_km DECIMAL(8,2),
  performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE user_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  daily_calories INTEGER NOT NULL,
  daily_protein DECIMAL(8,2) NOT NULL,
  daily_carbs DECIMAL(8,2) NOT NULL,
  daily_fats DECIMAL(8,2) NOT NULL,
  daily_water_ml INTEGER NOT NULL,
  activity_level TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2.3 Настройка Row Level Security (RLS)
```sql
-- Включение RLS для всех таблиц
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE nutrition_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE water_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_goals ENABLE ROW LEVEL SECURITY;

-- Политики для users
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Политики для products (публичный доступ для чтения)
CREATE POLICY "Anyone can view products" ON products
  FOR SELECT USING (true);

-- Политики для nutrition_log
CREATE POLICY "Users can view own nutrition log" ON nutrition_log
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own nutrition log" ON nutrition_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own nutrition log" ON nutrition_log
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own nutrition log" ON nutrition_log
  FOR DELETE USING (auth.uid() = user_id);

-- Политики для water_log
CREATE POLICY "Users can view own water log" ON water_log
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own water log" ON water_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own water log" ON water_log
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own water log" ON water_log
  FOR DELETE USING (auth.uid() = user_id);

-- Политики для activity_log
CREATE POLICY "Users can view own activity log" ON activity_log
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own activity log" ON activity_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own activity log" ON activity_log
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own activity log" ON activity_log
  FOR DELETE USING (auth.uid() = user_id);

-- Политики для user_goals
CREATE POLICY "Users can view own goals" ON user_goals
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own goals" ON user_goals
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own goals" ON user_goals
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own goals" ON user_goals
  FOR DELETE USING (auth.uid() = user_id);
```

### 2.4 Настройка Edge Functions
```bash
# Установка Supabase CLI
npm install -g supabase

# Инициализация проекта
supabase init

# Логин в Supabase
supabase login

# Связывание с проектом
supabase link --project-ref YOUR_PROJECT_REF
```

Создание Edge Functions:
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

Развертывание функций:
```bash
supabase functions deploy calculate-nutrition
supabase functions deploy calculate-water-stats
supabase functions deploy calculate-activity-stats
```

## 3. Настройка Firebase

### 3.1 Создание проекта
1. Перейдите на [firebase.google.com](https://firebase.google.com)
2. Создайте новый проект
3. Добавьте приложения для iOS и Android

### 3.2 Настройка iOS
1. Скачайте `GoogleService-Info.plist`
2. Добавьте в iOS проект через Xcode
3. Добавьте в `.gitignore`:
```
ios/Runner/GoogleService-Info.plist
```

### 3.3 Настройка Android
1. Скачайте `google-services.json`
2. Добавьте в `android/app/`
3. Добавьте в `.gitignore`:
```
android/app/google-services.json
```

### 3.4 Настройка зависимостей
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_messaging: ^14.7.10
```

### 3.5 Инициализация Firebase
```dart
// lib/core/config/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    
    // Настройка Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    // Настройка Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }
}
```

## 4. Настройка Окружений

### 4.1 Конфигурация окружений
```dart
// lib/core/config/environment.dart
enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static Environment _environment = Environment.dev;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static String get supabaseUrl {
    switch (_environment) {
      case Environment.dev:
        return const String.fromEnvironment('SUPABASE_URL_DEV');
      case Environment.staging:
        return const String.fromEnvironment('SUPABASE_URL_STAGING');
      case Environment.prod:
        return const String.fromEnvironment('SUPABASE_URL_PROD');
    }
  }
  
  static String get supabaseAnonKey {
    switch (_environment) {
      case Environment.dev:
        return const String.fromEnvironment('SUPABASE_ANON_KEY_DEV');
      case Environment.staging:
        return const String.fromEnvironment('SUPABASE_ANON_KEY_STAGING');
      case Environment.prod:
        return const String.fromEnvironment('SUPABASE_ANON_KEY_PROD');
    }
  }
  
  static bool get isProduction => _environment == Environment.prod;
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
}
```

### 4.2 Файлы конфигурации
```bash
# .env.dev
SUPABASE_URL_DEV=https://dev-project.supabase.co
SUPABASE_ANON_KEY_DEV=your-dev-anon-key
FIREBASE_PROJECT_ID_DEV=nutryflow-dev

# .env.staging
SUPABASE_URL_STAGING=https://staging-project.supabase.co
SUPABASE_ANON_KEY_STAGING=your-staging-anon-key
FIREBASE_PROJECT_ID_STAGING=nutryflow-staging

# .env.prod
SUPABASE_URL_PROD=https://prod-project.supabase.co
SUPABASE_ANON_KEY_PROD=your-prod-anon-key
FIREBASE_PROJECT_ID_PROD=nutryflow-prod
```

## 5. CI/CD Pipeline

### 5.1 GitHub Actions
```yaml
# .github/workflows/flutter.yml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.2.3'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Analyze project source
        run: flutter analyze
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --debug
      
      - name: Build iOS
        run: flutter build ios --no-codesign

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.2.3'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.2.3'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign
      
      - name: Upload iOS build
        uses: actions/upload-artifact@v3
        with:
          name: release-ios
          path: build/ios/iphoneos/Runner.app
```

### 5.2 Fastlane для автоматического деплоя
```ruby
# fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    setup_ci if is_ci
    
    # Увеличить версию
    increment_build_number
    
    # Собрать приложение
    build_ios_app(
      scheme: "Runner",
      export_method: "app-store",
      configuration: "Release"
    )
    
    # Загрузить в TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end
  
  desc "Build and upload to App Store"
  lane :release do
    setup_ci if is_ci
    
    # Увеличить версию
    increment_version_number
    increment_build_number
    
    # Собрать приложение
    build_ios_app(
      scheme: "Runner",
      export_method: "app-store",
      configuration: "Release"
    )
    
    # Загрузить в App Store
    upload_to_app_store(
      force: true,
      skip_metadata: true,
      skip_screenshots: true
    )
  end
end

platform :android do
  desc "Build and upload to Play Store"
  lane :beta do
    # Собрать APK
    gradle(
      task: "clean assembleRelease"
    )
    
    # Загрузить в Play Store
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end
  
  desc "Build and upload to Play Store"
  lane :release do
    # Собрать AAB
    gradle(
      task: "clean bundleRelease"
    )
    
    # Загрузить в Play Store
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end
end
```

## 6. Развертывание в App Store

### 6.1 Подготовка к публикации
1. Создайте App Store Connect аккаунт
2. Создайте приложение в App Store Connect
3. Настройте метаданные приложения

### 6.2 Настройка подписи
```bash
# Создание сертификатов
fastlane match init
fastlane match development
fastlane match appstore
```

### 6.3 Автоматический деплой
```bash
# Бета-версия
fastlane ios beta

# Продакшн
fastlane ios release
```

## 7. Развертывание в Google Play

### 7.1 Подготовка к публикации
1. Создайте Google Play Console аккаунт
2. Создайте приложение в Google Play Console
3. Настройте метаданные приложения

### 7.2 Настройка подписи
```bash
# Создание keystore
keytool -genkey -v -keystore nutryflow.keystore -alias nutryflow -keyalg RSA -keysize 2048 -validity 10000
```

### 7.3 Конфигурация подписи
```gradle
// android/app/build.gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 7.4 Автоматический деплой
```bash
# Бета-версия
fastlane android beta

# Продакшн
fastlane android release
```

## 8. Мониторинг и Аналитика

### 8.1 Настройка мониторинга
```dart
// lib/core/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
  
  static Future<void> setUserProperties({
    required String userId,
    required String userType,
  }) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_type', value: userType);
  }
  
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }
}
```

### 8.2 Настройка Crashlytics
```dart
// lib/core/services/crashlytics_service.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  static Future<void> logError(
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.recordError(error, stackTrace);
  }
  
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
  
  static Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }
  
  static Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}
```

## 9. Безопасность

### 9.1 Переменные окружения
```bash
# Никогда не коммитьте секреты в репозиторий
echo "*.env" >> .gitignore
echo "*.keystore" >> .gitignore
echo "google-services.json" >> .gitignore
echo "GoogleService-Info.plist" >> .gitignore
```

### 9.2 GitHub Secrets
Настройте секреты в GitHub:
- `SUPABASE_URL_DEV`
- `SUPABASE_ANON_KEY_DEV`
- `SUPABASE_URL_STAGING`
- `SUPABASE_ANON_KEY_STAGING`
- `SUPABASE_URL_PROD`
- `SUPABASE_ANON_KEY_PROD`
- `FIREBASE_SERVICE_ACCOUNT_KEY`

### 9.3 Проверка безопасности
```bash
# Проверка зависимостей
flutter pub deps

# Анализ кода
flutter analyze

# Проверка лицензий
flutter pub deps --style=tree
```

## 10. Резервное копирование

### 10.1 База данных
```bash
# Автоматическое резервное копирование Supabase
# Настройте в Supabase Dashboard -> Settings -> Database
```

### 10.2 Файлы
```bash
# Резервное копирование конфигурационных файлов
tar -czf config-backup-$(date +%Y%m%d).tar.gz .env* fastlane/ android/app/google-services.json ios/Runner/GoogleService-Info.plist
```

## 11. Чек-лист развертывания

### 11.1 Перед развертыванием
- [ ] Все тесты проходят
- [ ] Код проанализирован линтером
- [ ] Версия приложения обновлена
- [ ] Чейнджлог обновлен
- [ ] Скриншоты обновлены
- [ ] Метаданные приложения обновлены

### 11.2 После развертывания
- [ ] Проверена работа в TestFlight/Internal Testing
- [ ] Проверена работа в продакшене
- [ ] Мониторинг настроен
- [ ] Аналитика работает
- [ ] Уведомления работают

Это руководство по развертыванию обеспечивает полный процесс деплоя приложения NutryFlow от разработки до продакшена. 