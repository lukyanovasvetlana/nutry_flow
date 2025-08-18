import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_styles.dart';
import '../../domain/entities/insight_article.dart';
import '../../domain/entities/insight_video.dart';

import '../widgets/article_card.dart';
import '../widgets/video_card.dart';

class ArticleDetailScreen extends StatefulWidget {
  final InsightArticle article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  List<InsightArticle> _relatedArticles = [];
  List<InsightVideo> _relatedVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRelatedContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRelatedContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Имитируем загрузку данных
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _relatedArticles = _getMockRelatedArticles()
            .where((article) => article.id != widget.article.id)
            .take(3)
            .toList();
        _relatedVideos = _getMockRelatedVideos().take(2).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<InsightArticle> _getMockRelatedArticles() {
    return [
      const InsightArticle(
        id: 'related1',
        title: 'Правильное питание для спортсменов',
        description: 'Особенности питания для людей, занимающихся спортом.',
        author: 'Диетолог Мария Сидорова',
        authorAvatar: 'https://via.placeholder.com/40',
        category: 'Питание',
        readTime: '6 мин',
        date: '2024-01-10',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['спорт', 'питание', 'энергия'],
      ),
      const InsightArticle(
        id: 'related2',
        title: 'Восстановление после тренировок',
        description:
            'Как правильно восстанавливаться после интенсивных тренировок.',
        author: 'Тренер Алексей Петров',
        authorAvatar: 'https://via.placeholder.com/40',
        category: 'Тренировки',
        readTime: '7 мин',
        date: '2024-01-09',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['восстановление', 'тренировки', 'здоровье'],
      ),
      const InsightArticle(
        id: 'related3',
        title: 'Витамины и минералы для здоровья',
        description: 'Важные витамины и минералы для поддержания здоровья.',
        author: 'Доктор Елена Козлова',
        authorAvatar: 'https://via.placeholder.com/40',
        category: 'Здоровье',
        readTime: '8 мин',
        date: '2024-01-08',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['витамины', 'минералы', 'здоровье'],
      ),
    ];
  }

  List<InsightVideo> _getMockRelatedVideos() {
    return [
      const InsightVideo(
        id: 'video1',
        title: 'Утренняя зарядка за 10 минут',
        description: 'Быстрая и эффективная утренняя зарядка для бодрости.',
        author: 'Тренер Анна Иванова',
        authorAvatar: 'https://via.placeholder.com/40',
        category: 'Тренировки',
        duration: '10:30',
        date: '2024-01-10',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video1.mp4',
        isRecommended: true,
        tags: ['зарядка', 'утро', 'энергия'],
      ),
      const InsightVideo(
        id: 'video2',
        title: 'Приготовление здорового завтрака',
        description: 'Рецепты быстрых и полезных завтраков.',
        author: 'Шеф-повар Михаил Сидоров',
        authorAvatar: 'https://via.placeholder.com/40',
        category: 'Рецепты',
        duration: '8:45',
        date: '2024-01-09',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video2.mp4',
        isRecommended: false,
        tags: ['завтрак', 'рецепты', 'питание'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Подробности',
          style: AppStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: _shareArticle,
          ),
          IconButton(
            icon:
                const Icon(Icons.bookmark_border, color: AppColors.textPrimary),
            onPressed: _bookmarkArticle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Header
            _buildArticleHeader(),

            // Article Content
            _buildArticleContent(),

            // Tags
            _buildTags(),

            // Related Articles
            if (!_isLoading && _relatedArticles.isNotEmpty) ...[
              const SizedBox(height: 32),
              _buildRelatedArticles(),
            ],

            // Related Videos
            if (!_isLoading && _relatedVideos.isNotEmpty) ...[
              const SizedBox(height: 32),
              _buildRelatedVideos(),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category and date
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.button.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.article.category,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.button,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.article.date,
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            widget.article.title,
            style: AppStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          // Author and read time
          Row(
            children: [
              Text(
                widget.article.authorAvatar,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.author,
                      style: AppStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.article.readTime,
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article image placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.article,
              size: 64,
              color: AppColors.button,
            ),
          ),
          const SizedBox(height: 24),

          // Article content
          Text(
            _getArticleContent(),
            style: AppStyles.bodyLarge.copyWith(
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Теги',
            style: AppStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.article.tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.button,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticles() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Похожие статьи',
            style: AppStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._relatedArticles.map((article) => ArticleCard(
                article: article,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Похожие видео',
            style: AppStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._relatedVideos.map((video) => VideoCard(
                video: video,
                onTap: () => _playVideo(video),
              )),
        ],
      ),
    );
  }

  String _getArticleContent() {
    // Полное содержание статьи на русском языке
    return '''Эта статья погружает нас в важность правильной гидратации для поддержания оптимального здоровья. Узнайте, как вода влияет на все аспекты нашего организма, от улучшения работы мозга до повышения физической производительности.

Вода является основой жизни, составляя около 60% массы тела взрослого человека. Каждая клетка, ткань и орган в нашем теле нуждается в воде для правильного функционирования. От регулирования температуры тела до смазывания суставов - вода играет решающую роль в поддержании нашего здоровья.

Почему важна гидратация

Правильная гидратация имеет решающее значение для каждой системы организма, от поддержания объема крови до регулирования температуры тела. Обезвоживание может привести к усталости, головным болям и снижению когнитивных функций. Поддержание правильного уровня гидратации - один из самых простых и эффективных способов поддержать общее здоровье.

Признаки обезвоживания

Обезвоживание происходит, когда вы теряете больше воды, чем потребляете. Это может привести к серьезным последствиям для здоровья, если не принять меры. Некоторые признаки обезвоживания включают:

• Головные боли
• Усталость  
• Сухость во рту
• Темная моча

Советы для поддержания гидратации

Когда дело доходит до гидратации, важно помнить, что около 80% процентов потребности в жидкости должно поступать из питьевой воды - речь идет о том, чтобы ваше тело получало то, что ему нужно для оптимального функционирования.

- Доктор Амелия Джонсон -

Сколько воды вам действительно нужно?

Общее правило "8 стаканов в день" - это хорошая отправная точка, но индивидуальные потребности различаются. Факторы, влияющие на потребность в воде, включают уровень активности, климат, общее состояние здоровья и наличие беременности или кормления грудью.

Заключение

Гидратация является неотъемлемой частью поддержания вашего здоровья. Понимание того, как вода влияет на ваше тело и принятие простых мер по поддержанию правильного уровня гидратации, может значительно улучшить ваше самочувствие. Помните, что правильная гидратация - это не только употребление воды в течение дня, но и понимание потребностей вашего тела в гидратации.''';
  }

  void _shareArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Поделиться статьей: ${widget.article.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _bookmarkArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Статья добавлена в закладки: ${widget.article.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _playVideo(InsightVideo video) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открыть видео: ${video.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
