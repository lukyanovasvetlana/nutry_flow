import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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

  factory UserModel.fromSupabaseUser(dynamic supabaseUser) {
    return UserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      createdAt: supabaseUser.createdAt,
      updatedAt: supabaseUser.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
