import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Политика конфиденциальности',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Политика конфиденциальности NutryFlow',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Последнее обновление: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Сбор информации',
              'Мы собираем информацию, которую вы предоставляете нам напрямую, включая:\n'
              '• Личные данные (имя, email, возраст)\n'
              '• Информацию о здоровье и целях\n'
              '• Данные о питании и активности\n'
              '• Фотографии блюд (по желанию)',
            ),
            
            _buildSection(
              '2. Использование информации',
              'Мы используем собранную информацию для:\n'
              '• Предоставления персонализированных рекомендаций\n'
              '• Отслеживания прогресса достижения целей\n'
              '• Улучшения качества наших услуг\n'
              '• Отправки уведомлений и обновлений',
            ),
            
            _buildSection(
              '3. Защита данных',
              'Мы принимаем серьезные меры для защиты ваших данных:\n'
              '• Шифрование данных при передаче\n'
              '• Безопасное хранение в облаке\n'
              '• Ограниченный доступ сотрудников\n'
              '• Регулярные проверки безопасности',
            ),
            
            _buildSection(
              '4. Передача данных третьим лицам',
              'Мы не продаем и не передаем ваши персональные данные третьим лицам без вашего согласия, за исключением случаев, предусмотренных законом.',
            ),
            
            _buildSection(
              '5. Ваши права',
              'Вы имеете право:\n'
              '• Получать доступ к своим данным\n'
              '• Исправлять неточную информацию\n'
              '• Удалять свои данные\n'
              '• Ограничивать обработку данных\n'
              '• Переносить данные в другие сервисы',
            ),
            
            _buildSection(
              '6. Файлы cookie',
              'Мы используем файлы cookie для улучшения работы приложения и анализа использования. Вы можете отключить cookie в настройках браузера.',
            ),
            
            _buildSection(
              '7. Изменения в политике',
              'Мы можем обновлять эту политику конфиденциальности. О существенных изменениях мы уведомим вас через приложение или email.',
            ),
            
            _buildSection(
              '8. Контакты',
              'Если у вас есть вопросы о политике конфиденциальности, свяжитесь с нами:\n'
              '• Email: privacy@nutryflow.com\n'
              '• Телефон: +7 (800) 123-45-67\n'
              '• Адрес: г. Москва, ул. Примерная, д. 1',
            ),
            
            const SizedBox(height: 32),
            
            // Кнопка согласия
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Понятно',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
} 