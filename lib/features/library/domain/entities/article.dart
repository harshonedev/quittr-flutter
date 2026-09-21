class Article {
  final String id;
  final String title;
  final String content;
  final String category;
  final int orderInCategory;
  final String? imageUrl;
  final Duration readingTime;
  final DateTime? publishedDate;
  final bool isPremium;

  const Article({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.orderInCategory,
    this.imageUrl,
    this.readingTime = const Duration(minutes: 5),
    this.publishedDate,
    this.isPremium = false,
  });

  /// Returns a shorter version of the content for previews
  String get previewContent {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  /// Returns a formatted reading time (e.g., "5 min read")
  String get formattedReadingTime {
    final minutes = readingTime.inMinutes;
    return '$minutes min read';
  }

  /// Returns a formatted published date
  String getFormattedDate(String format) {
    if (publishedDate == null) return '';

    // Simple formatting, can be enhanced with intl package
    final day = publishedDate!.day.toString().padLeft(2, '0');
    final month = publishedDate!.month.toString().padLeft(2, '0');
    final year = publishedDate!.year.toString();

    return '$day/$month/$year';
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      orderInCategory: json['orderInCategory'] as int,
      imageUrl: json['imageUrl'] as String?,
      readingTime: json['readingTimeMinutes'] != null
          ? Duration(minutes: json['readingTimeMinutes'] as int)
          : const Duration(minutes: 5),
      publishedDate: json['publishedDate'] != null
          ? DateTime.parse(json['publishedDate'] as String)
          : null,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'orderInCategory': orderInCategory,
      'imageUrl': imageUrl,
      'readingTimeMinutes': readingTime.inMinutes,
      'publishedDate': publishedDate?.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  /// Creates a copy of this Article with the given fields replaced with new values
  Article copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    int? orderInCategory,
    String? imageUrl,
    Duration? readingTime,
    DateTime? publishedDate,
    bool? isPremium,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      orderInCategory: orderInCategory ?? this.orderInCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      readingTime: readingTime ?? this.readingTime,
      publishedDate: publishedDate ?? this.publishedDate,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class ArticleCategory {
  final String name;
  final List<Article> articles;
  final String? description;
  final String? iconName;

  const ArticleCategory({
    required this.name,
    required this.articles,
    this.description,
    this.iconName,
  });

  /// Gets the total number of articles in the category
  int get articleCount => articles.length;

  /// Gets the total reading time for all articles in this category
  Duration get totalReadingTime {
    return articles.fold(
        Duration.zero, (total, article) => total + article.readingTime);
  }

  /// Gets a formatted string of the total reading time
  String get formattedTotalReadingTime {
    final minutes = totalReadingTime.inMinutes;
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hr';
      } else {
        return '$hours hr $remainingMinutes min';
      }
    }
  }

  /// Creates a copy of this ArticleCategory with the given fields replaced with new values
  ArticleCategory copyWith({
    String? name,
    List<Article>? articles,
    String? description,
    String? iconName,
  }) {
    return ArticleCategory(
      name: name ?? this.name,
      articles: articles ?? this.articles,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
    );
  }
}
