import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/menu_item.dart';
import 'package:uuid/uuid.dart';

class RecipeService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MenuItem>> getAllRecipes() async {
    try {
      final response = await _client.from('recipes').select();

      return response.map(MenuItem.fromJson).toList();
    } catch (e) {
      // Таблица recipes не найдена, возвращаем пустой список
      return [];
    }
  }

  Future<void> saveRecipe(MenuItem recipe, List<File> photos) async {
    // 1. Загружаем фото в Storage
    final photoUrls = <String>[];
    for (final photo in photos) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${photo.path.split('/').last}';
      await _client.storage.from('recipes').upload(fileName, photo);
      final url = _client.storage.from('recipes').getPublicUrl(fileName);
      photoUrls.add(url);
    }

    // 2. Создаем JSON для рецепта
    final recipeJson = recipe.toJson();
    recipeJson['photos'] = photoUrls;

    // 3. Сохраняем рецепт в таблицу
    await _client.from('recipes').insert(recipeJson);
  }

  Future<void> updateRecipe(MenuItem recipe,
      {List<File>? newPhotos, List<String>? photosToDelete}) async {
    // 1. Удаляем фото, помеченные для удаления
    if (photosToDelete != null && photosToDelete.isNotEmpty) {
      final fileNamesToDelete =
          photosToDelete.map((url) => url.split('/').last).toList();
      await _client.storage.from('recipes').remove(fileNamesToDelete);
    }

    // 2. Загружаем новые фото
    final List<String> updatedPhotoUrls = recipe.photos
        .where((p) => !photosToDelete.toString().contains(p.url))
        .map((p) => p.url)
        .toList();

    if (newPhotos != null && newPhotos.isNotEmpty) {
      for (final photo in newPhotos) {
        final fileName = '${const Uuid().v4()}_${photo.path.split('/').last}';
        await _client.storage.from('recipes').upload(fileName, photo);
        final url = _client.storage.from('recipes').getPublicUrl(fileName);
        updatedPhotoUrls.add(url);
      }
    }

    // 3. Обновляем запись в базе
    final recipeJson = recipe.toJson();
    recipeJson['photos'] = updatedPhotoUrls.map((url) => {'url': url}).toList();

    await _client.from('recipes').update(recipeJson).eq('id', recipe.id);
  }

  Future<void> deleteRecipe(String recipeId) async {
    // 1. Получить данные о рецепте, чтобы узнать URL фото
    final response = await _client
        .from('recipes')
        .select('photos')
        .eq('id', recipeId)
        .single();
    final List<dynamic> photosData = response['photos'];

    // 2. Удалить каждое фото из Storage
    if (photosData.isNotEmpty) {
      final List<String> photoFileNames = photosData.map((photo) {
        final url = photo['url'] as String;
        // Извлекаем имя файла из URL
        return url.split('/').last;
      }).toList();

      await _client.storage.from('recipes').remove(photoFileNames);
    }

    // 3. Удалить саму запись о рецепте
    await _client.from('recipes').delete().eq('id', recipeId);
  }
}
