import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/article.dart';

class ArticleService {
  Future<List<ArticleCategory>> loadArticles() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/articles.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> sections = jsonMap['sections'];

    final List<ArticleCategory> categories = [];

    for (final section in sections) {
      section.forEach((categoryName, articlesList) {
        final List<Article> articles = [];
        int orderInCategory = 1;

        for (final articleMap in articlesList) {
          articles.add(
            Article(
              id: orderInCategory.toString(), // Using order as ID for now
              title: articleMap['title'],
              content: articleMap['description'],
              category: categoryName,
              orderInCategory: orderInCategory++,
            ),
          );
        }

        categories.add(
          ArticleCategory(
            name: categoryName,
            articles: articles,
          ),
        );
      });
    }

    return categories;
  }
}
