# Push-уведомления в NutryFlow

## Обзор

NutryFlow использует Firebase Cloud Messaging (FCM) для отправки push-уведомлений пользователям. Система поддерживает как локальные, так и удаленные уведомления.

## Архитектура

### 1. Компоненты системы
- **NotificationService** - основной сервис для работы с уведомлениями
- **NotificationRepository** - репозиторий для управления данными уведомлений
- **NotificationBloc** - BLoC для управления состоянием уведомлений
- **Edge Function** - Supabase функция для отправки push-уведомлений

### 2. Типы уведомлений
- **Локальные уведомления** - планируются на устройстве
- **Push-уведомления** - отправляются через Firebase
- **Напоминания о еде** - уведомления о времени приема пищи
- **Напоминания о тренировках** - уведомления о запланированных тренировках
- **Напоминания о целях** - уведомления о достижении целей

## Настройка Firebase

### 1. Создание проекта Firebase
```bash
# Установка Firebase CLI
npm install -g firebase-tools

# Вход в Firebase
firebase login

# Инициализация проекта
firebase init
```

### 2. Настройка Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
  <application>
    <service
      android:name="io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService"
      android:exported="false">
      <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
      </intent-filter>
    </service>
  </application>
</manifest>
```

### 3. Настройка iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

## Использование

### 1. Инициализация сервиса
```dart
// В main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await Firebase.initializeApp();
  
  // Инициализация сервиса уведомлений
  await NotificationService.instance.initialize();
  
  runApp(const MyApp());
}
```

### 2. Запрос разрешений
```dart
// Автоматически запрашивается в NotificationService
// Можно проверить статус разрешений
final settings = await FirebaseMessaging.instance.getNotificationSettings();
print('Authorization status: ${settings.authorizationStatus}');
```

### 3. Получение FCM токена
```dart
final token = await FirebaseMessaging.instance.getToken();
print('FCM Token: $token');

// Слушаем обновления токена
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  print('Token refreshed: $newToken');
});
```

## Типы уведомлений

### 1. Локальные уведомления
```dart
// Планирование локального уведомления
await NotificationService.instance.scheduleLocalNotification(
  id: 1,
  title: 'Время приема пищи',
  body: 'Не забудьте про завтрак',
  scheduledDate: DateTime.now().add(Duration(hours: 1)),
  payload: '{"type": "meal_reminder"}',
  channelId: 'meal_reminders',
);

// Отмена уведомления
await NotificationService.instance.cancelLocalNotification(1);
```

### 2. Push-уведомления
```dart
// Отправка через репозиторий
await notificationRepository.sendPushNotification(
  userId: 'user-123',
  title: 'Цель достигнута! 🎉',
  body: 'Поздравляем! Вы достигли цели: похудеть на 5 кг',
  type: 'goal_achievement',
  data: {
    'goal_name': 'Похудеть на 5 кг',
    'achievement': 'Цель достигнута',
  },
);
```

### 3. Напоминания о еде
```dart
// Планирование напоминания о еде
await notificationRepository.scheduleMealReminder(
  mealTime: DateTime.now().add(Duration(hours: 2)),
  mealName: 'Обед',
  description: 'Время для обеда',
);
```

### 4. Напоминания о тренировках
```dart
// Планирование напоминания о тренировке
await notificationRepository.scheduleWorkoutReminder(
  workoutTime: DateTime.now().add(Duration(hours: 3)),
  workoutName: 'Кардио тренировка',
  description: '30 минут бега',
);
```

## Каналы уведомлений (Android)

### 1. Создание каналов
```dart
// Автоматически создаются в NotificationService
const AndroidNotificationChannel mealReminderChannel = AndroidNotificationChannel(
  'meal_reminders',
  'Напоминания о еде',
  description: 'Уведомления о времени приема пищи',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);
```

### 2. Настройка важности
- **High** - для критических уведомлений (еда, тренировки)
- **Medium** - для информационных уведомлений (цели)
- **Default** - для общих уведомлений

## Обработка уведомлений

### 1. Foreground обработка
```dart
// В NotificationService
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Foreground message: ${message.messageId}');
  print('Message data: ${message.data}');
  
  // Показываем локальное уведомление
  _showLocalNotificationFromMessage(message);
});
```

### 2. Background обработка
```dart
// Обработчик фоновых сообщений
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
  
  // Инициализируем уведомления
  await FlutterLocalNotificationsPlugin().initialize(
    const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
  );
  
  // Показываем уведомление
  await _showLocalNotification(message);
}
```

### 3. Обработка нажатий
```dart
// Обработка нажатия на уведомление
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('Notification tapped: ${message.messageId}');
  
  // Навигация к соответствующему экрану
  final data = message.data;
  final type = data['type'];
  
  switch (type) {
    case 'meal_reminder':
      // Навигация к экрану еды
      break;
    case 'workout_reminder':
      // Навигация к экрану тренировок
      break;
    case 'goal_achievement':
      // Навигация к экрану целей
      break;
  }
});
```

## Настройки пользователя

### 1. Сохранение настроек
```dart
final preferences = NotificationPreferences(
  mealRemindersEnabled: true,
  workoutRemindersEnabled: true,
  goalRemindersEnabled: true,
  generalNotificationsEnabled: true,
  mealReminderTime: DateTime.now().add(Duration(hours: 1)),
  workoutReminderTime: DateTime.now().add(Duration(hours: 2)),
  goalReminderTime: DateTime.now().add(Duration(days: 1)),
);

await notificationRepository.saveNotificationPreferences(preferences);
```

### 2. Получение настроек
```dart
final preferences = await notificationRepository.getNotificationPreferences();
print('Meal reminders enabled: ${preferences.mealRemindersEnabled}');
```

## Edge Function

### 1. Развертывание функции
```bash
# В директории supabase
supabase functions deploy send-push-notification
```

### 2. Настройка переменных окружения
```bash
# В Supabase Dashboard
FIREBASE_SERVER_KEY=your_firebase_server_key
```

### 3. Использование функции
```dart
// В репозитории
await supabase.functions.invoke('send-push-notification', body: {
  'tokens': tokens,
  'title': title,
  'body': body,
  'data': {
    'type': type,
    ...data,
  },
});
```

## Тестирование

### 1. Тестирование локальных уведомлений
```dart
test('should schedule local notification', () async {
  final notification = ScheduledNotification(
    id: 1,
    title: 'Test Notification',
    body: 'Test body',
    type: 'test',
    scheduledDate: DateTime.now().add(Duration(seconds: 5)),
  );
  
  await notificationRepository.scheduleNotification(notification);
  
  // Проверяем, что уведомление запланировано
  final notifications = await notificationRepository.getScheduledNotifications();
  expect(notifications, contains(notification));
});
```

### 2. Тестирование push-уведомлений
```dart
test('should send push notification', () async {
  await notificationRepository.sendPushNotification(
    userId: 'test-user',
    title: 'Test Title',
    body: 'Test Body',
    type: 'test',
  );
  
  // Проверяем, что функция вызвана
  verify(mockSupabase.functions.invoke('send-push-notification', body: any)).called(1);
});
```

## Лучшие практики

### 1. Оптимизация производительности
- Используйте кэширование FCM токенов
- Группируйте уведомления по времени
- Избегайте спама уведомлениями

### 2. UX рекомендации
- Предоставляйте пользователю контроль над уведомлениями
- Используйте понятные и информативные сообщения
- Добавляйте действия в уведомления

### 3. Безопасность
- Валидируйте данные уведомлений
- Используйте HTTPS для всех запросов
- Ограничивайте частоту отправки

## Отладка

### 1. Логирование
```dart
developer.log('🔔 Notification sent: $title', name: 'NotificationService');
developer.log('🔔 FCM Token: $token', name: 'NotificationService');
```

### 2. Проверка статуса
```dart
// Проверка инициализации
if (NotificationService.instance.isInitialized) {
  print('Notification service is ready');
}

// Проверка FCM токена
final token = NotificationService.instance.fcmToken;
if (token != null) {
  print('FCM token available: $token');
}
```

### 3. Тестирование на устройстве
- Всегда тестируйте на реальном устройстве
- Проверяйте работу в фоновом режиме
- Тестируйте различные сценарии нажатий

## Мониторинг

### 1. Метрики
- Количество отправленных уведомлений
- Процент доставки
- Время отклика пользователей

### 2. Аналитика
- Отслеживание взаимодействий с уведомлениями
- Анализ эффективности разных типов уведомлений
- Оптимизация времени отправки

## Будущие улучшения

### 1. Персонализация
- Адаптивные уведомления на основе поведения
- Интеллектуальное планирование времени
- Контекстные уведомления

### 2. Расширенная функциональность
- Rich notifications с изображениями
- Интерактивные уведомления
- Группировка уведомлений

### 3. Интеграция
- Интеграция с календарем
- Синхронизация с фитнес-трекерами
- Интеграция с социальными сетями 