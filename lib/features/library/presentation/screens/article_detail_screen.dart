import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import '../../domain/entities/article.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();

    // Trigger the "Knowledge Seeker" achievement when article is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context
            .read<AchievementsBloc>()
            .add(UnlockAchievementEvent(UnlockAchievementEvent.readArticle));
      } catch (e) {
        debugPrint("Error unlocking article reading achievement: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout adjustments
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isLargeScreen = screenSize.width > 600;
    final isLandscape = screenSize.width > screenSize.height;

    // Responsive padding and font size scaling
    final horizontalPadding = isLargeScreen ? 32.0 : 20.0;
    final titleFontSize = isSmallScreen ? 20.0 : (isLargeScreen ? 28.0 : 24.0);
    final bodyFontSize = isSmallScreen ? 14.0 : (isLargeScreen ? 18.0 : 16.0);

    // Calculate max width for improved readability on large screens
    final contentMaxWidth = isLargeScreen ? 700.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AchievementsBloc, AchievementsState>(
        listener: (context, state) {
          if (state is AchievementUnlocked) {
            debugPrint("Achievement unlocked: ${state.achievement.title}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "New Achievement Unlocked: +${state.achievement.pointsAwarded} points"),
                action: SnackBarAction(
                  label: 'See',
                  onPressed: () {
                    context.push('/achievements');
                  },
                ),
              ),
            );
          }

          if (state is AchievementsError) {
            debugPrint("Error unlocking achievement: ${state.message}");
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: horizontalPadding * 0.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Article ${widget.article.orderInCategory}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.article.readingTime.inMinutes > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  widget.article.formattedReadingTime,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        Text(
                          widget.article.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                              ),
                        ),
                        if (widget.article.publishedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Published: ${widget.article.getFormattedDate('')}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        if (widget.article.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.article.imageUrl!,
                                width: double.infinity,
                                height: isLandscape ? 180 : 220,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: isLandscape ? 180 : 220,
                                  width: double.infinity,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withOpacity(0.3),
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Text(
                          widget.article.content,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                    fontSize: bodyFontSize,
                                  ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
