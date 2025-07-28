import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'dart:developer' as developer;

// Обработчик фоновых сообщений
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('🔔 Background message received: ${message.messageId}', name: 'NotificationService');
  
  // Инициализируем уведомления для фонового режима
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  // Показываем локальное уведомление
  await _showLocalNotification(message);
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'nutry_flow_channel',
    'NutryFlow Notifications',
    channelDescription: 'Уведомления от NutryFlow',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );
  
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'NutryFlow',
    message.notification?.body ?? '',
    platformChannelSpecifics,
    payload: json.encode(message.data),
  );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  NotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _isInitialized = false;

  // Типы уведомлений
  static const String _mealReminderChannel = 'meal_reminders';
  static const String _workoutReminderChannel = 'workout_reminders';
  static const String _goalReminderChannel = 'goal_reminders';
  static const String _generalChannel = 'general_notifications';

  /// Инициализация сервиса уведомлений
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('🔔 Initializing notification service', name: 'NotificationService');

      // Настройка Firebase Messaging
      await _setupFirebaseMessaging();

      // Настройка локальных уведомлений
      await _setupLocalNotifications();

      // Запрос разрешений
      await _requestPermissions();

      // Получение FCM токена
      await _getFCMToken();

      _isInitialized = true;
      developer.log('🔔 Notification service initialized successfully', name: 'NotificationService');
    } catch (e) {
      developer.log('🔔 Failed to initialize notification service: $e', name: 'NotificationService');
      rethrow;
    }
  }

  /// Настройка Firebase Messaging
  Future<void> _setupFirebaseMessaging() async {
    // Регистрируем обработчик фоновых сообщений
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Обработчик сообщений когда приложение открыто
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Обработчик нажатия на уведомление
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Обработчик инициализации приложения через уведомление
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Настройка локальных уведомлений
  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    // Создаем каналы для Android
    await _createNotificationChannels();
  }

  /// Создание каналов уведомлений для Android
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel mealReminderChannel = AndroidNotificationChannel(
        _mealReminderChannel,
        'Напоминания о еде',
        description: 'Уведомления о времени приема пищи',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      const AndroidNotificationChannel workoutReminderChannel = AndroidNotificationChannel(
        _workoutReminderChannel,
        'Напоминания о тренировках',
        description: 'Уведомления о запланированных тренировках',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      const AndroidNotificationChannel goalReminderChannel = AndroidNotificationChannel(
        _goalReminderChannel,
        'Напоминания о целях',
        description: 'Уведомления о достижении целей',
        importance: Importance.medium,
        playSound: true,
        enableVibration: false,
      );

      const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
        _generalChannel,
        'Общие уведомления',
        description: 'Общие уведомления от NutryFlow',
        importance: Importance.defaultImportance,
        playSound: true,
        enableVibration: false,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(mealReminderChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(workoutReminderChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(goalReminderChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(generalChannel);
    }
  }

  /// Запрос разрешений на уведомления
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    developer.log('🔔 Notification permission status: ${settings.authorizationStatus}', name: 'NotificationService');
  }

  /// Получение FCM токена
  Future<void> _getFCMToken() async {
    _fcmToken = await _firebaseMessaging.getToken();
    developer.log('🔔 FCM Token: $_fcmToken', name: 'NotificationService');

    // Сохраняем токен в Supabase
    if (_fcmToken != null) {
      await _saveFCMTokenToSupabase(_fcmToken!);
    }

    // Слушаем обновления токена
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _saveFCMTokenToSupabase(newToken);
      developer.log('🔔 FCM Token refreshed: $newToken', name: 'NotificationService');
    });
  }

  /// Сохранение FCM токена в Supabase
  Future<void> _saveFCMTokenToSupabase(String token) async {
    try {
      final user = SupabaseService.instance.currentUser;
      if (user != null) {
        await SupabaseService.instance.saveUserData('user_fcm_tokens', {
          'user_id': user.id,
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        developer.log('🔔 FCM token saved to Supabase', name: 'NotificationService');
      }
    } catch (e) {
      developer.log('🔔 Failed to save FCM token to Supabase: $e', name: 'NotificationService');
    }
  }

  /// Обработка сообщений в foreground
  void _handleForegroundMessage(RemoteMessage message) {
    developer.log('🔔 Foreground message received: ${message.messageId}', name: 'NotificationService');
    developer.log('🔔 Message data: ${message.data}', name: 'NotificationService');

    // Показываем локальное уведомление
    _showLocalNotificationFromMessage(message);
  }

  /// Обработка нажатия на уведомление
  void _handleNotificationTap(RemoteMessage message) {
    developer.log('🔔 Notification tapped: ${message.messageId}', name: 'NotificationService');
    developer.log('🔔 Message data: ${message.data}', name: 'NotificationService');

    // Обработка различных типов уведомлений
    final data = message.data;
    final type = data['type'];

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

  /// Обработка нажатия на локальное уведомление
  void _handleLocalNotificationTap(NotificationResponse response) {
    developer.log('🔔 Local notification tapped: ${response.payload}', name: 'NotificationService');

    if (response.payload != null) {
      final data = json.decode(response.payload!);
      final type = data['type'];

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
  }

  /// Показ локального уведомления из сообщения
  Future<void> _showLocalNotificationFromMessage(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'] ?? 'general';

    String channelId;
    switch (type) {
      case 'meal_reminder':
        channelId = _mealReminderChannel;
        break;
      case 'workout_reminder':
        channelId = _workoutReminderChannel;
        break;
      case 'goal_achievement':
        channelId = _goalReminderChannel;
        break;
      default:
        channelId = _generalChannel;
        break;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      'NutryFlow Notifications',
      channelDescription: 'Уведомления от NutryFlow',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'NutryFlow',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: json.encode(data),
    );
  }

  /// Обработка напоминания о еде
  void _handleMealReminder(Map<String, dynamic> data) {
    developer.log('🔔 Handling meal reminder: $data', name: 'NotificationService');
    // Здесь можно добавить навигацию к экрану еды
  }

  /// Обработка напоминания о тренировке
  void _handleWorkoutReminder(Map<String, dynamic> data) {
    developer.log('🔔 Handling workout reminder: $data', name: 'NotificationService');
    // Здесь можно добавить навигацию к экрану тренировок
  }

  /// Обработка достижения цели
  void _handleGoalAchievement(Map<String, dynamic> data) {
    developer.log('🔔 Handling goal achievement: $data', name: 'NotificationService');
    // Здесь можно добавить навигацию к экрану целей
  }

  /// Обработка общего уведомления
  void _handleGeneralNotification(Map<String, dynamic> data) {
    developer.log('🔔 Handling general notification: $data', name: 'NotificationService');
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
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      'NutryFlow Notifications',
      channelDescription: 'Уведомления от NutryFlow',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    developer.log('🔔 Local notification scheduled for: $scheduledDate', name: 'NotificationService');
  }

  /// Отмена локального уведомления
  Future<void> cancelLocalNotification(int id) async {
    await _localNotifications.cancel(id);
    developer.log('🔔 Local notification cancelled: $id', name: 'NotificationService');
  }

  /// Отмена всех локальных уведомлений
  Future<void> cancelAllLocalNotifications() async {
    await _localNotifications.cancelAll();
    developer.log('🔔 All local notifications cancelled', name: 'NotificationService');
  }

  /// Получение FCM токена
  String? get fcmToken => _fcmToken;

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;
} 