import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/activity_session.dart';
import '../../domain/entities/activity_stats.dart';
import '../models/activity_session_model.dart';
import '../models/activity_stats_model.dart';

class ActivityTrackingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Activity Sessions

  Future<ActivitySession> startActivitySession(ActivitySession session) async {
    try {
      final response = await _supabase
          .from('activity_sessions')
          .insert(ActivitySessionModel.fromEntity(session).toJson())
          .select()
          .single();

      return ActivitySessionModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка при начале сессии: $e');
    }
  }

  Future<ActivitySession> updateActivitySession(ActivitySession session) async {
    try {
      await _supabase
          .from('activity_sessions')
          .update(ActivitySessionModel.fromEntity(session).toJson())
          .eq('id', session.id);

      return await getSessionById(session.id) ?? session;
    } catch (e) {
      throw Exception('Ошибка при обновлении сессии: $e');
    }
  }

  Future<ActivitySession> completeActivitySession(String sessionId) async {
    try {
      final now = DateTime.now();
      await _supabase.from('activity_sessions').update({
        'status': 'completed',
        'completed_at': now.toIso8601String(),
      }).eq('id', sessionId);

      final session = await getSessionById(sessionId);
      if (session == null) {
        throw Exception('Сессия не найдена');
      }
      return session;
    } catch (e) {
      throw Exception('Ошибка при завершении сессии: $e');
    }
  }

  Future<ActivitySession?> getCurrentSession(String userId) async {
    try {
      final response = await _supabase.from('activity_sessions').select('''
            *,
            workouts (*)
          ''').eq('user_id', userId).eq('status', 'in_progress').maybeSingle();

      if (response == null) return null;
      return ActivitySessionModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка при получении текущей сессии: $e');
    }
  }

  Future<List<ActivitySession>> getUserSessions(String userId,
      {DateTime? from, DateTime? to}) async {
    try {
      final response = await _supabase.from('activity_sessions').select('''
            *,
            workouts (*)
          ''').eq('user_id', userId).order('started_at', ascending: false);

      List<ActivitySession> sessions = response
          .map((json) => ActivitySessionModel.fromJson(json).toEntity())
          .toList();

      // Фильтруем по датам на стороне Dart
      if (from != null) {
        sessions = sessions
            .where((session) => session.startedAt
                .isAfter(from.subtract(const Duration(seconds: 1))))
            .toList();
      }
      if (to != null) {
        sessions = sessions
            .where((session) =>
                session.startedAt.isBefore(to.add(const Duration(days: 1))))
            .toList();
      }

      return sessions;
    } catch (e) {
      throw Exception('Ошибка при получении сессий: $e');
    }
  }

  Future<ActivitySession?> getSessionById(String id) async {
    try {
      final response = await _supabase.from('activity_sessions').select('''
            *,
            workouts (*)
          ''').eq('id', id).maybeSingle();

      if (response == null) return null;
      return ActivitySessionModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка при получении сессии: $e');
    }
  }

  // Activity Stats

  Future<ActivityStats> getDailyStats(String userId, DateTime date) async {
    try {
      final response = await _supabase
          .from('activity_stats')
          .select()
          .eq('user_id', userId)
          .eq('date', date.toIso8601String().split('T')[0])
          .maybeSingle();

      if (response == null) {
        // Создаем пустую статистику для дня
        return ActivityStats(
          id: '',
          userId: userId,
          date: date,
          totalWorkouts: 0,
          totalDurationMinutes: 0,
          totalCaloriesBurned: 0,
          totalExercises: 0,
          categoryBreakdown: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      return ActivityStatsModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка при получении дневной статистики: $e');
    }
  }

  Future<List<ActivityStats>> getWeeklyStats(
      String userId, DateTime weekStart) async {
    try {
      final weekEnd = weekStart.add(const Duration(days: 7));
      final response = await _supabase
          .from('activity_stats')
          .select()
          .eq('user_id', userId)
          .order('date');

      List<ActivityStats> stats = response
          .map((json) => ActivityStatsModel.fromJson(json).toEntity())
          .toList();

      // Фильтруем по неделе на стороне Dart
      stats = stats
          .where((stat) =>
              stat.date
                  .isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
              stat.date.isBefore(weekEnd))
          .toList();

      return stats;
    } catch (e) {
      throw Exception('Ошибка при получении недельной статистики: $e');
    }
  }

  Future<List<ActivityStats>> getMonthlyStats(
      String userId, DateTime monthStart) async {
    try {
      final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 1);
      final response = await _supabase
          .from('activity_stats')
          .select()
          .eq('user_id', userId)
          .order('date');

      List<ActivityStats> stats = response
          .map((json) => ActivityStatsModel.fromJson(json).toEntity())
          .toList();

      // Фильтруем по месяцу на стороне Dart
      stats = stats
          .where((stat) =>
              stat.date
                  .isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
              stat.date.isBefore(monthEnd))
          .toList();

      return stats;
    } catch (e) {
      throw Exception('Ошибка при получении месячной статистики: $e');
    }
  }

  Future<ActivityStats> updateDailyStats(ActivityStats stats) async {
    try {
      final response = await _supabase
          .from('activity_stats')
          .upsert(ActivityStatsModel.fromEntity(stats).toJson())
          .select()
          .single();

      return ActivityStatsModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка при обновлении статистики: $e');
    }
  }

  // Analytics

  Future<Map<String, dynamic>> getActivityAnalytics(String userId,
      {DateTime? from, DateTime? to}) async {
    try {
      final sessions = await getUserSessions(userId, from: from, to: to);

      final int totalWorkouts = sessions.length;
      final int totalDuration = sessions.fold(
          0, (sum, session) => sum + (session.durationMinutes ?? 0));
      final int totalCalories = sessions.fold(
          0, (sum, session) => sum + (session.caloriesBurned ?? 0));

      // Категории упражнений
      final Map<String, int> categoryBreakdown = {};
      for (final session in sessions) {
        if (session.workout != null) {
          for (final exercise in session.workout!.exercises) {
            final category =
                _getCategoryDisplayName(exercise.exercise.category);
            categoryBreakdown[category] =
                (categoryBreakdown[category] ?? 0) + 1;
          }
        }
      }

      return {
        'total_workouts': totalWorkouts,
        'total_duration_minutes': totalDuration,
        'total_calories_burned': totalCalories,
        'average_duration':
            totalWorkouts > 0 ? totalDuration / totalWorkouts : 0,
        'average_calories':
            totalWorkouts > 0 ? totalCalories / totalWorkouts : 0,
        'category_breakdown': categoryBreakdown,
        'most_active_category': categoryBreakdown.isNotEmpty
            ? categoryBreakdown.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key
            : 'Нет данных',
      };
    } catch (e) {
      throw Exception('Ошибка при получении аналитики: $e');
    }
  }

  Future<int> getTotalWorkouts(String userId) async {
    try {
      final response = await _supabase
          .from('activity_sessions')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'completed');

      return response.length;
    } catch (e) {
      throw Exception('Ошибка при получении общего количества тренировок: $e');
    }
  }

  Future<int> getTotalDuration(String userId,
      {DateTime? from, DateTime? to}) async {
    try {
      final response = await _supabase
          .from('activity_sessions')
          .select('duration_minutes, started_at')
          .eq('user_id', userId)
          .eq('status', 'completed');

      List<Map<String, dynamic>> sessions =
          List<Map<String, dynamic>>.from(response);

      // Фильтруем по датам на стороне Dart
      if (from != null) {
        sessions = sessions.where((session) {
          final startedAt = DateTime.parse(session['started_at']);
          return startedAt.isAfter(from.subtract(const Duration(seconds: 1)));
        }).toList();
      }
      if (to != null) {
        sessions = sessions.where((session) {
          final startedAt = DateTime.parse(session['started_at']);
          return startedAt.isBefore(to.add(const Duration(days: 1)));
        }).toList();
      }

      return sessions.fold<int>(
          0, (sum, json) => sum + ((json['duration_minutes'] ?? 0) as int));
    } catch (e) {
      throw Exception('Ошибка при получении общего времени: $e');
    }
  }

  Future<int> getTotalCaloriesBurned(String userId,
      {DateTime? from, DateTime? to}) async {
    try {
      final response = await _supabase
          .from('activity_sessions')
          .select('calories_burned, started_at')
          .eq('user_id', userId)
          .eq('status', 'completed');

      List<Map<String, dynamic>> sessions =
          List<Map<String, dynamic>>.from(response);

      // Фильтруем по датам на стороне Dart
      if (from != null) {
        sessions = sessions.where((session) {
          final startedAt = DateTime.parse(session['started_at']);
          return startedAt.isAfter(from.subtract(const Duration(seconds: 1)));
        }).toList();
      }
      if (to != null) {
        sessions = sessions.where((session) {
          final startedAt = DateTime.parse(session['started_at']);
          return startedAt.isBefore(to.add(const Duration(days: 1)));
        }).toList();
      }

      return sessions.fold<int>(
          0, (sum, json) => sum + ((json['calories_burned'] ?? 0) as int));
    } catch (e) {
      throw Exception('Ошибка при получении общего количества калорий: $e');
    }
  }

  String _getCategoryDisplayName(dynamic category) {
    switch (category.toString()) {
      case 'legs':
        return 'Ноги';
      case 'back':
        return 'Спина';
      case 'chest':
        return 'Грудь';
      case 'shoulders':
        return 'Плечи';
      case 'arms':
        return 'Руки';
      case 'core':
        return 'Пресс';
      case 'cardio':
        return 'Кардио';
      case 'flexibility':
        return 'Растяжка';
      case 'yoga':
        return 'Йога';
      default:
        return 'Другое';
    }
  }
}
