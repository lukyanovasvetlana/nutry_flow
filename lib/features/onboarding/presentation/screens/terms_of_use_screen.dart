import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

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
          'Условия использования',
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
              'Условия использования NutryFlow',
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
              '1. Принятие условий',
              'Используя приложение NutryFlow, вы соглашаетесь с настоящими условиями использования. '
                  'Если вы не согласны с какими-либо положениями, пожалуйста, не используйте приложение.',
            ),
            _buildSection(
              '2. Описание сервиса',
              'NutryFlow — это приложение для отслеживания питания, планирования приёмов пищи и достижения целей в области здоровья. '
                  'Сервис предоставляет персонализированные рекомендации на основе введённых вами данных.',
            ),
            _buildSection(
              '3. Регистрация и учётная запись',
              'Для использования всех функций приложения необходимо создать учётную запись. '
                  'Вы несёте ответственность за сохранение конфиденциальности своих учётных данных и за все действия, совершённые под вашей учётной записью.',
            ),
            _buildSection(
              '4. Правила использования',
              'При использовании NutryFlow вы обязуетесь:\n'
                  '• Предоставлять достоверную информацию\n'
                  '• Не использовать приложение в незаконных целях\n'
                  '• Не пытаться получить несанкционированный доступ к данным других пользователей\n'
                  '• Соблюдать авторские права и права интеллектуальной собственности',
            ),
            _buildSection(
              '5. Ограничение ответственности',
              'NutryFlow предоставляется «как есть». Мы не гарантируем точность рекомендаций по питанию. '
                  'Информация в приложении не заменяет консультацию с врачом или диетологом. '
                  'Перед изменением рациона питания проконсультируйтесь со специалистом.',
            ),
            _buildSection(
              '6. Изменение условий',
              'Мы оставляем за собой право изменять условия использования. '
                  'О существенных изменениях мы уведомим вас через приложение. '
                  'Продолжение использования сервиса после изменений означает ваше согласие с новыми условиями.',
            ),
            _buildSection(
              '7. Контакты',
              'По вопросам условий использования свяжитесь с нами:\n'
                  '• Email: support@nutryflow.com\n'
                  '• Телефон: +7 (800) 123-45-67',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
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
