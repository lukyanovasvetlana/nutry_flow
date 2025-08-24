/// Сущность пользователя в системе аутентификации
/// 
/// Представляет основную информацию о пользователе, включая идентификатор,
/// email и временные метки создания/обновления.
/// 
/// Пример использования:
/// ```dart
/// // Создание пользователя
/// final user = User(
///   id: 'user123',
///   email: 'user@example.com',
///   createdAt: DateTime.now(),
/// );
/// 
/// // Сериализация в JSON
/// final json = user.toJson();
/// 
/// // Десериализация из JSON
/// final userFromJson = User.fromJson(json);
/// ```
class User {
  /// Уникальный идентификатор пользователя
  final String id;
  
  /// Email адрес пользователя
  final String email;
  
  /// Дата и время создания пользователя
  final DateTime? createdAt;
  
  /// Дата и время последнего обновления пользователя
  final DateTime? updatedAt;

  /// Создает экземпляр пользователя
  /// 
  /// [id] - уникальный идентификатор (обязательный)
  /// [email] - email адрес (обязательный)
  /// [createdAt] - дата создания (опционально)
  /// [updatedAt] - дата обновления (опционально)
  User({
    required this.id,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  /// Создает пользователя из JSON данных
  /// 
  /// [json] - Map с данными пользователя
  /// 
  /// Throws [FormatException] если JSON имеет неверный формат
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email)';
  }
}
