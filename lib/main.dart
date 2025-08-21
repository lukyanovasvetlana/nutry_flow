import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nutry_flow/core/architecture/architecture.dart';
import 'package:nutry_flow/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Загрузка переменных окружения (если файл существует)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('⚠️ .env file not found, using demo mode');
  }

  // Проверяем демо-режим
  print('🔵 Main: SupabaseConfig.isDemo = ${SupabaseConfig.isDemo}');
  print('🔵 Main: SupabaseConfig.url = ${SupabaseConfig.url}');
  print('🔵 Main: SupabaseConfig.anonKey = ${SupabaseConfig.anonKey}');

  // Проверяем, что демо-режим действительно работает
  if (SupabaseConfig.isDemo) {
    print('🔵 Main: ✅ Demo mode is ACTIVE');
  } else {
    print('🔵 Main: ❌ Demo mode is NOT active');
  }

  try {
    // Инициализация архитектуры приложения
    print('🏗️ Main: Initializing AppArchitecture...');
    await AppArchitecture().initialize();
    print('✅ Main: AppArchitecture initialized successfully');

    // Запуск приложения
    runApp(AppArchitecture().createApp());
    
  } catch (e, stackTrace) {
    print('❌ Main: Failed to initialize AppArchitecture: $e');
    print('❌ Stack trace: $stackTrace');
    
    // Fallback: показываем экран ошибки
    runApp(const _ErrorApp());
  }
}

/// Fallback приложение для случаев ошибки инициализации
class _ErrorApp extends StatelessWidget {
  const _ErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutryFlow - Error',
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ошибка инициализации'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red,
                ),
                SizedBox(height: 24),
                Text(
                  'Не удалось инициализировать приложение',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Попробуйте перезапустить приложение или обратитесь в службу поддержки.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
