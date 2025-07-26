import 'dart:io';
import 'package:uuid/uuid.dart';

class RecipePhoto {
  final String id;
  final String? url;
  final File? file;
  final int order;

  RecipePhoto({
    String? id,
    this.url,
    this.file,
    required this.order,
  }) : id = id ?? const Uuid().v4();

  factory RecipePhoto.fromJson(Map<String, dynamic> json) {
    return RecipePhoto(
      id: json['id'] as String?,
      url: json['url'] as String?,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'order': order,
    };
  }
} 