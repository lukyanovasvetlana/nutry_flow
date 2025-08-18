import '../models/exercise.dart';

class ExerciseService {
  static final List<Exercise> _exercises = [
    Exercise(
      id: '1',
      name: 'Приседания',
      category: 'Ноги',
      difficulty: 'Beginner',
      sets: 4,
      reps: 12,
      restSeconds: 60,
      iconName: 'fitness_center',
      description:
          'Комплексное упражнение, которое задействует квадрицепсы, подколенные сухожилия и ягодицы.',
      targetMuscles: ['Квадрицепсы', 'Подколенные сухожилия', 'Ягодицы'],
      equipment: ['Собственный вес'],
    ),
    Exercise(
      id: '2',
      name: 'Становая тяга',
      category: 'Спина',
      difficulty: 'Advanced',
      sets: 3,
      reps: 10,
      restSeconds: 90,
      iconName: 'fitness_center',
      description:
          'Базовое комплексное упражнение, которое прорабатывает всю заднюю цепь мышц.',
      targetMuscles: [
        'Подколенные сухожилия',
        'Ягодицы',
        'Поясница',
        'Трапеции'
      ],
      equipment: ['Штанга', 'Блины'],
    ),
    Exercise(
      id: '3',
      name: 'Жим лежа',
      category: 'Грудь',
      difficulty: 'Intermediate',
      sets: 3,
      reps: 8,
      restSeconds: 60,
      iconName: 'fitness_center',
      description:
          'Классическое упражнение для верхней части тела, нацеленное на грудь, плечи и трицепсы.',
      targetMuscles: ['Грудь', 'Плечи', 'Трицепсы'],
      equipment: ['Штанга', 'Скамья', 'Блины'],
    ),
    Exercise(
      id: '4',
      name: 'Подтягивания',
      category: 'Спина',
      difficulty: 'Intermediate',
      sets: 4,
      reps: 8,
      restSeconds: 90,
      iconName: 'fitness_center',
      description:
          'Упражнение с собственным весом, которое прорабатывает спину и бицепсы.',
      targetMuscles: ['Широчайшие', 'Ромбовидные', 'Бицепсы'],
      equipment: ['Турник'],
    ),
    Exercise(
      id: '5',
      name: 'Планка',
      category: 'Пресс',
      difficulty: 'Beginner',
      sets: 3,
      reps: 60,
      restSeconds: 30,
      iconName: 'fitness_center',
      description:
          'Изометрическое упражнение для кора, которое укрепляет всю среднюю часть тела.',
      targetMuscles: ['Пресс', 'Плечи', 'Ягодицы'],
      equipment: ['Собственный вес'],
    ),
    Exercise(
      id: '6',
      name: 'Бег',
      category: 'Кардио',
      difficulty: 'Beginner',
      sets: 1,
      reps: 1,
      restSeconds: 0,
      duration: '30 мин',
      iconName: 'directions_run',
      description:
          'Кардиоупражнение, которое улучшает выносливость и сжигает калории.',
      targetMuscles: ['Ноги', 'Сердечно-сосудистая система'],
      equipment: ['Беговые кроссовки'],
    ),
    Exercise(
      id: '7',
      name: 'Выпады',
      category: 'Ноги',
      difficulty: 'Beginner',
      sets: 3,
      reps: 15,
      restSeconds: 60,
      iconName: 'fitness_center',
      description:
          'Одностороннее упражнение для ног, которое улучшает баланс и силу.',
      targetMuscles: ['Квадрицепсы', 'Подколенные сухожилия', 'Ягодицы'],
      equipment: ['Собственный вес'],
    ),
    Exercise(
      id: '8',
      name: 'Жим плечами',
      category: 'Плечи',
      difficulty: 'Intermediate',
      sets: 3,
      reps: 10,
      restSeconds: 60,
      iconName: 'fitness_center',
      description: 'Жимовое движение над головой, которое прорабатывает плечи.',
      targetMuscles: ['Плечи', 'Трицепсы', 'Пресс'],
      equipment: ['Гантели'],
    ),
    Exercise(
      id: '9',
      name: 'Подъемы на бицепс',
      category: 'Руки',
      difficulty: 'Beginner',
      sets: 3,
      reps: 12,
      restSeconds: 45,
      iconName: 'fitness_center',
      description: 'Изолирующее упражнение, которое прорабатывает бицепсы.',
      targetMuscles: ['Бицепсы'],
      equipment: ['Гантели'],
    ),
    Exercise(
      id: '10',
      name: 'Велосипед',
      category: 'Кардио',
      difficulty: 'Beginner',
      sets: 1,
      reps: 1,
      restSeconds: 0,
      duration: '45 мин',
      iconName: 'directions_bike',
      description:
          'Низкоударное кардиоупражнение, которое укрепляет мышцы ног.',
      targetMuscles: ['Ноги', 'Сердечно-сосудистая система'],
      equipment: ['Велосипед'],
    ),
    Exercise(
      id: '11',
      name: 'Альпинист',
      category: 'Пресс',
      difficulty: 'Intermediate',
      sets: 4,
      reps: 20,
      restSeconds: 30,
      iconName: 'fitness_center',
      description:
          'Динамическое упражнение, которое сочетает кардио и укрепление кора.',
      targetMuscles: ['Пресс', 'Плечи', 'Ноги'],
      equipment: ['Собственный вес'],
    ),
    Exercise(
      id: '12',
      name: 'Йога (Растяжка)',
      category: 'Растяжка',
      difficulty: 'Beginner',
      sets: 1,
      reps: 1,
      restSeconds: 0,
      duration: '60 мин',
      iconName: 'self_improvement',
      description:
          'Практика, которая сочетает физические позы, дыхание и медитацию.',
      targetMuscles: ['Все тело'],
      equipment: ['Коврик для йоги'],
    ),
  ];

  static List<Exercise> getAllExercises() {
    return _exercises;
  }

  static List<Exercise> searchExercises(String query) {
    if (query.isEmpty) return _exercises;

    return _exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query.toLowerCase()) ||
          exercise.category.toLowerCase().contains(query.toLowerCase()) ||
          exercise.targetMuscles.any(
              (muscle) => muscle.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  static List<Exercise> filterByCategory(String category) {
    if (category.isEmpty || category == 'All') return _exercises;
    return _exercises
        .where((exercise) => exercise.category == category)
        .toList();
  }

  static List<Exercise> filterByDifficulty(String difficulty) {
    if (difficulty.isEmpty || difficulty == 'All') return _exercises;
    return _exercises
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  static List<String> getCategories() {
    return [
      'All',
      'Ноги',
      'Спина',
      'Грудь',
      'Плечи',
      'Руки',
      'Пресс',
      'Кардио',
      'Растяжка'
    ];
  }

  static List<String> getDifficulties() {
    return ['All', 'Beginner', 'Intermediate', 'Advanced'];
  }

  static Exercise? getExerciseById(String id) {
    try {
      return _exercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }
}
