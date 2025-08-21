import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/article_card.dart';
import '../widgets/video_card.dart';
import '../widgets/tag_chip.dart';
import '../widgets/author_card.dart';
import '../widgets/section_header.dart';
import '../../domain/entities/insight_article.dart';
import '../../domain/entities/insight_video.dart';
import '../../domain/entities/insight_tag.dart';
import '../../domain/entities/insight_author.dart';
import 'article_detail_screen.dart';

class HealthArticlesScreen extends StatefulWidget {
  const HealthArticlesScreen({super.key});

  @override
  State<HealthArticlesScreen> createState() => _HealthArticlesScreenState();
}

class _HealthArticlesScreenState extends State<HealthArticlesScreen> {
  // Данные для статей и контента
  late List<InsightArticle> _articles;
  late List<InsightVideo> _videos;
  late List<InsightTag> _tags;
  late List<InsightAuthor> _authors;
  late InsightArticle _featuredArticle;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _featuredArticle = const InsightArticle(
      id: 'featured1',
      title: '10 принципов здорового питания для активной жизни',
      description:
          'Узнайте основные принципы правильного питания, которые помогут вам поддерживать энергию и здоровье в течение всего дня.',
      author: 'Доктор Анна Петрова',
      authorAvatar: '👩‍⚕️',
      category: 'Питание',
      readTime: '8 мин',
      date: '2024-01-15',
      imageUrl: 'https://via.placeholder.com/400x200',
      isFeatured: true,
      tags: ['питание', 'здоровье', 'энергия'],
    );

    _articles = [
      const InsightArticle(
        id: '1',
        title: 'Эффективные тренировки дома',
        description: 'Как поддерживать форму без посещения спортзала.',
        author: 'Тренер Михаил Сидоров',
        authorAvatar: '💪',
        category: 'Тренировки',
        readTime: '6 мин',
        date: '2024-01-14',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['тренировки', 'дом', 'фитнес'],
      ),
      const InsightArticle(
        id: '2',
        title: 'Польза витамина D',
        description: 'Важность витамина D для иммунитета и здоровья.',
        author: 'Диетолог Елена Козлова',
        authorAvatar: '🥗',
        category: 'Здоровье',
        readTime: '5 мин',
        date: '2024-01-13',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['витамины', 'иммунитет'],
      ),
      const InsightArticle(
        id: '3',
        title: 'Рецепт полезного завтрака',
        description: 'Быстрый и питательный завтрак для энергии.',
        author: 'Шеф-повар Игорь Морозов',
        authorAvatar: '👨‍🍳',
        category: 'Рецепты',
        readTime: '4 мин',
        date: '2024-01-12',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['завтрак', 'рецепты'],
      ),
      const InsightArticle(
        id: '4',
        title: 'Как правильно пить воду',
        description: 'Важность правильного питьевого режима.',
        author: 'Диетолог Мария Сидорова',
        authorAvatar: '👩‍⚕️',
        category: 'Здоровье',
        readTime: '3 мин',
        date: '2024-01-11',
        imageUrl: 'https://via.placeholder.com/300x200',
        tags: ['вода', 'гидратация'],
      ),
    ];

    _videos = [
      const InsightVideo(
        id: 'video1',
        title: 'Утренняя зарядка за 10 минут',
        description: 'Быстрая и эффективная утренняя зарядка.',
        author: 'Тренер Анна Иванова',
        authorAvatar: '👨‍⚕️',
        category: 'Тренировки',
        duration: '10:30',
        date: '2024-01-10',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video1.mp4',
        isRecommended: true,
        tags: ['зарядка', 'утро'],
      ),
      const InsightVideo(
        id: 'video2',
        title: 'Приготовление здорового завтрака',
        description: 'Рецепты быстрых и полезных завтраков.',
        author: 'Шеф-повар Михаил Сидоров',
        authorAvatar: '👨‍⚕️',
        category: 'Рецепты',
        duration: '8:45',
        date: '2024-01-09',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video2.mp4',
        tags: ['завтрак', 'рецепты'],
      ),
    ];

    _tags = [
      const InsightTag(
          id: '1',
          name: 'Питание',
          category: 'Питание',
          color: '#4CAF50',
          articleCount: 15),
      const InsightTag(
          id: '2',
          name: 'Тренировки',
          category: 'Тренировки',
          color: '#2196F3',
          articleCount: 12),
      const InsightTag(
          id: '3',
          name: 'Здоровье',
          category: 'Здоровье',
          color: '#FF9800',
          articleCount: 8),
      const InsightTag(
          id: '4',
          name: 'Рецепты',
          category: 'Рецепты',
          color: '#9C27B0',
          articleCount: 20),
      const InsightTag(
          id: '5',
          name: 'Витамины',
          category: 'Здоровье',
          color: '#F44336',
          articleCount: 6),
      const InsightTag(
          id: '6',
          name: 'Мотивация',
          category: 'Психология',
          color: '#009688',
          articleCount: 10),
    ];

    _authors = [
      const InsightAuthor(
        id: '1',
        name: 'Доктор Анна Петрова',
        title: 'Диетолог',
        avatar: '👩‍⚕️',
        bio: 'Специалист по здоровому питанию с 10-летним опытом',
        articlesCount: 25,
        followersCount: 1200,
        isVerified: true,
      ),
      const InsightAuthor(
        id: '2',
        name: 'Тренер Михаил Сидоров',
        title: 'Фитнес-тренер',
        avatar: '💪',
        bio: 'Персональный тренер и специалист по функциональному тренингу',
        articlesCount: 18,
        followersCount: 890,
        isVerified: true,
      ),
      const InsightAuthor(
        id: '3',
        name: 'Диетолог Елена Козлова',
        title: 'Нутрициолог',
        avatar: '🥗',
        bio: 'Эксперт по спортивному питанию и диетологии',
        articlesCount: 22,
        followersCount: 1100,
        isVerified: false,
      ),
    ];
  }

  List<InsightArticle> get _filteredArticles {
    if (_searchQuery.isEmpty) return _articles;
    return _articles
        .where((article) =>
            article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            article.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            article.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            article.category
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            article.tags.any((tag) =>
                tag.toLowerCase().contains(_searchQuery.toLowerCase())))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dynamicTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Статьи о здоровье',
          style: TextStyle(
            color: AppColors.dynamicTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border,
                color: AppColors.dynamicTextPrimary),
            onPressed: () {
              // TODO: Show bookmarks
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поиск
            _buildSearchSection(),
            const SizedBox(height: 24),

            // Главная статья
            _buildFeaturedArticle(),
            const SizedBox(height: 24),

            // Рекомендуемые статьи
            _buildRecommendedArticles(),
            const SizedBox(height: 24),

            // Видео-контент
            _buildRecommendedVideos(),
            const SizedBox(height: 24),

            // Трендовые теги
            _buildTrendingTags(),
            const SizedBox(height: 24),

            // Топ авторы
            _buildTopAuthors(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SearchBarWidget(
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query;
        });
      },
      onClear: () {
        setState(() {
          _searchQuery = '';
        });
      },
    );
  }

  Widget _buildFeaturedArticle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Главная статья',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ArticleDetailScreen(article: _featuredArticle),
              ),
            );
          },
          child: ArticleCard(article: _featuredArticle, isLarge: true),
        ),
      ],
    );
  }

  Widget _buildRecommendedArticles() {
    final articles = _filteredArticles.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Рекомендуемые статьи',
          onViewAll: () {
            // TODO: Navigate to all articles
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Переход к всем статьям')),
            );
          },
        ),
        const SizedBox(height: 12),
        if (articles.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Ничего не найдено',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          )
        else
          ...articles.map((article) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                  child: ArticleCard(article: article),
                ),
              )),
      ],
    );
  }

  Widget _buildRecommendedVideos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Рекомендуемые видео',
          onViewAll: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Переход к всем видео')),
            );
          },
        ),
        const SizedBox(height: 12),
        ..._videos.map((video) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Воспроизведение видео: ${video.title}')),
                  );
                },
                child: VideoCard(video: video),
              ),
            )),
      ],
    );
  }

  Widget _buildTrendingTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Трендовые теги',
          onViewAll: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Переход к всем тегам')),
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags
              .map((tag) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchQuery = tag.name;
                      });
                    },
                    child: TagChip(tag: tag),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTopAuthors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Топ авторы',
          onViewAll: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Переход к всем авторам')),
            );
          },
        ),
        const SizedBox(height: 12),
        ..._authors.map((author) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Профиль автора: ${author.name}')),
                  );
                },
                child: AuthorCard(author: author),
              ),
            )),
      ],
    );
  }
}
