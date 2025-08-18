import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:nutry_flow/core/services/supabase_service.dart';
import 'dart:developer' as developer;
// import 'package:timezone/timezone.dart' as tz;

// Обработчик фоновых сообщений
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   developer.log('🔔 Background message received: ${message.messageId}', name: 'NotificationService');
//
//   // Инициализируем уведомления для фонового режима
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   // Показываем локальное уведомление
//   await _showLocalNotification(message);
// }

// Future<void> _showLocalNotification(RemoteMessage message) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'nutry_flow_channel',
//     'NutryFlow Notifications',
//     channelDescription: 'Уведомления от NutryFlow',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: true,
//   );
//
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   await flutterLocalNotificationsPlugin.show(
//     message.hashCode,
//     message.notification?.title ?? 'NutryFlow',
//     message.notification?.body ?? '',
//     platformChannelSpecifics,
//     payload: json.encode(message.data),
//   );
// }

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  NotificationService._();

  // late FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _isInitialized = false;

  // Типы уведомлений
  static const String _generalChannel = 'general_notifications';

  /// Инициализация уведомлений
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('🔔 NotificationService: Initializing notification service',
          name: 'NotificationService');

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Настройка для Android
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Настройка для iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Общие настройки
      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Инициализация
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Настройка Firebase Messaging
      // _firebaseMessaging = FirebaseMessaging.instance;

      // Запрос разрешений
      // await _requestPermissions();

      // Настройка обработчиков сообщений
      // await _setupMessageHandlers();

      // Создание каналов уведомлений
      await _createNotificationChannels();

      _isInitialized = true;
      developer.log(
          '🔔 NotificationService: Notification service initialized successfully',
          name: 'NotificationService');
    } catch (e) {
      developer.log(
          '🔔 NotificationService: Failed to initialize notification service: $e',
          name: 'NotificationService');
      rethrow;
    }
  }

  /// Запрос разрешений на уведомления
  // Future<void> _requestPermissions() async {
  //   try {
  //     // Запрос разрешений для локальных уведомлений
  //     final localSettings = await _localNotifications
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.requestNotificationsPermission();

  //     // Запрос разрешений для Firebase Messaging
  //     final messagingSettings = await _firebaseMessaging.requestPermission(
  //       alert: true,
  //       announcement: false,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true,
  //     );

  //     developer.log('🔔 NotificationService: Permission status - Local: $localSettings, Firebase: ${messagingSettings.authorizationStatus}', name: 'NotificationService');
  //   } catch (e) {
  //     developer.log('🔔 NotificationService: Failed to request permissions: $e', name: 'NotificationService');
  //   }
  // }

  /// Настройка обработчиков сообщений Firebase
  // Future<void> _setupMessageHandlers() async {
  //   try {
  //     // Обработчик сообщений в фоне
  //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //     // Обработчик сообщений когда приложение открыто
  //     FirebaseMessaging.onMessage.listen(_onMessageReceived);

  //     // Обработчик нажатия на уведомление
  //     FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpenedApp);

  //     // Получение токена FCM
  //     final token = await _firebaseMessaging.getToken();
  //     if (token != null) {
  //       developer.log('🔔 NotificationService: FCM Token: $token', name: 'NotificationService');
  //       await _saveFCMToken(token);
  //     }

  //     // Обработчик обновления токена
  //     _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);
  //   } catch (e) {
  //     developer.log('🔔 NotificationService: Failed to setup message handlers: $e', name: 'NotificationService');
  //   }
  // }

  /// Создание каналов уведомлений для Android
  Future<void> _createNotificationChannels() async {
    try {
      const androidChannel = AndroidNotificationChannel(
        'general',
        'Общие уведомления',
        description: 'Канал для общих уведомлений приложения',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      const reminderChannel = AndroidNotificationChannel(
        'reminders',
        'Напоминания',
        description: 'Канал для напоминаний о приемах пищи и тренировках',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      const achievementChannel = AndroidNotificationChannel(
        'achievements',
        'Достижения',
        description: 'Канал для уведомлений о достижениях',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(reminderChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(achievementChannel);

      developer.log('🔔 NotificationService: Notification channels created',
          name: 'NotificationService');
    } catch (e) {
      developer.log(
          '🔔 NotificationService: Failed to create notification channels: $e',
          name: 'NotificationService');
    }
  }

  /// Получение FCM токена
  // Future<void> _getFCMToken() async {
  //   _fcmToken = await _firebaseMessaging.getToken();
  //   developer.log('🔔 FCM Token: $_fcmToken', name: 'NotificationService');

  //   // Сохраняем токен в Supabase
  //   if (_fcmToken != null) {
  //     await _saveFCMTokenToSupabase(_fcmToken!);
  //   }

  //   // Слушаем обновления токена
  //   _firebaseMessaging.onTokenRefresh.listen((newToken) {
  //     _fcmToken = newToken;
  //     _saveFCMTokenToSupabase(newToken);
  //     developer.log('🔔 FCM Token refreshed: $newToken', name: 'NotificationService');
  //   });
  // }

  /// Обработка сообщений в foreground
  // void _handleForegroundMessage(RemoteMessage message) {
  //   developer.log('🔔 Foreground message received: ${message.messageId}', name: 'NotificationService');
  //   developer.log('🔔 Message data: ${message.data}', name: 'NotificationService');

  //   // Показываем локальное уведомление
  //   _showLocalNotificationFromMessage(message);
  // }

  /// Обработка нажатия на уведомление
  // void _handleNotificationTap(RemoteMessage message) {
  //   developer.log('🔔 Notification tapped: ${message.messageId}', name: 'NotificationService');
  //   developer.log('🔔 Message data: ${message.data}', name: 'NotificationService');

  //   // Обработка различных типов уведомлений
  //   final data = message.data;
  //   final type = data['type'];

  //   switch (type) {
  //     case 'meal_reminder':
  //       _handleMealReminder(data);
  //       break;
  //     case 'workout_reminder':
  //       _handleWorkoutReminder(data);
  //       break;
  //     case 'goal_achievement':
  //       _handleGoalAchievement(data);
  //       break;
  //     default:
  //       _handleGeneralNotification(data);
  //       break;
  //   }
  // }

  /// Показ локального уведомления из сообщения
  // Future<void> _showLocalNotificationFromMessage(RemoteMessage message) async {
  //   final data = message.data;
  //   final type = data['type'] ?? 'general';

  //   String channelId;
  //   switch (type) {
  //     case 'meal_reminder':
  //       channelId = _mealReminderChannel;
  //       break;
  //     case 'workout_reminder':
  //       channelId = _workoutReminderChannel;
  //       break;
  //     case 'goal_achievement':
  //       channelId = _goalReminderChannel;
  //       break;
  //     default:
  //       channelId = _generalChannel;
  //       break;
  //   }

  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     channelId,
  //     'NutryFlow Notifications',
  //     channelDescription: 'Уведомления от NutryFlow',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: true,
  //   );

  //   final NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await _localNotifications.show(
  //     message.hashCode,
  //     message.notification?.title ?? 'NutryFlow',
  //     message.notification?.body ?? '',
  //     platformChannelSpecifics,
  //     payload: json.encode(data),
  //   );
  // }

  /// Обработка напоминания о еде
  void _handleMealReminder(Map<String, dynamic> data) {
    developer.log('🔔 Handling meal reminder: $data',
        name: 'NotificationService');
    // Здесь можно добавить навигацию к экрану еды
  }

  /// Обработка напоминания о тренировке
  void _handleWorkoutReminder(Map<String, dynamic> data) {
    developer.log('🔔 Handling workout reminder: $data',
        name: 'NotificationService');
    // Здесь можно добавить навигацию к экрану тренировок
  }

  /// Обработка достижения цели
  void _handleGoalAchievement(Map<String, dynamic> data) {
    developer.log('🔔 Handling goal achievement: $data',
        name: 'NotificationService');
    // Здесь можно добавить навигацию к экрану целей
  }

  /// Обработка общего уведомления
  void _handleGeneralNotification(Map<String, dynamic> data) {
    developer.log('🔔 Handling general notification: $data',
        name: 'NotificationService');
    // Здесь можно добавить общую обработку
  }

  /// Планирование локального уведомления
  Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = _generalChannel,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      'NutryFlow Notifications',
      channelDescription: 'Уведомления от NutryFlow',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    developer.log('🔔 Local notification scheduled for: $scheduledDate',
        name: 'NotificationService');
  }

  /// Отмена локального уведомления
  Future<void> cancelLocalNotification(int id) async {
    await _localNotifications.cancel(id);
    developer.log('🔔 Local notification cancelled: $id',
        name: 'NotificationService');
  }

  /// Отмена всех локальных уведомлений
  Future<void> cancelAllLocalNotifications() async {
    await _localNotifications.cancelAll();
    developer.log('🔔 All local notifications cancelled',
        name: 'NotificationService');
  }

  /// Получение FCM токена
  String? get fcmToken => _fcmToken;

  /// Обработка нажатия на локальное уведомление
  void _onNotificationTapped(NotificationResponse response) {
    try {
      developer.log(
          '🔔 NotificationService: Local notification tapped: ${response.payload}',
          name: 'NotificationService');

      if (response.payload != null) {
        final data = json.decode(response.payload!);
        _handleNotificationData(data);
      }
    } catch (e) {
      developer.log(
          '🔔 NotificationService: Failed to handle notification tap: $e',
          name: 'NotificationService');
    }
  }

  /// Обработка данных уведомления
  void _handleNotificationData(Map<String, dynamic> data) {
    final type = data['type'] as String?;

    switch (type) {
      case 'meal_reminder':
        _handleMealReminder(data);
        break;
      case 'workout_reminder':
        _handleWorkoutReminder(data);
        break;
      case 'goal_achievement':
        _handleGoalAchievement(data);
        break;
      default:
        _handleGeneralNotification(data);
        break;
    }
  }

  /// Обработка сообщения Firebase
  // void _onMessageReceived(RemoteMessage message) {
  //   try {
  //     developer.log('🔔 NotificationService: Firebase message received: ${message.notification?.title}', name: 'NotificationService');
  //
  //     final data = message.data;
  //     _handleNotificationData(data);
  //   } catch (e) {
  //     developer.log('🔔 NotificationService: Failed to handle Firebase message: $e', name: 'NotificationService');
  //   }
  // }

  /// Обработка открытия уведомления Firebase
  // void _onNotificationOpenedApp(RemoteMessage message) {
  //   try {
  //     developer.log('🔔 NotificationService: Firebase notification opened: ${message.notification?.title}', name: 'NotificationService');
  //
  //     final data = message.data;
  //     _handleNotificationData(data);
  //   } catch (e) {
  //     developer.log('🔔 NotificationService: Failed to handle Firebase notification open: $e', name: 'NotificationService');
  //   }
  // }

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;
}
