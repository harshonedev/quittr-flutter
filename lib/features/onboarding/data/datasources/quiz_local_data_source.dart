import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/quiz_question.dart';

abstract class QuizLocalDataSource {
  Future<List<QuizQuestion>> getQuizQuestions();
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  @override
  Future<List<QuizQuestion>> getQuizQuestions() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/quiz.json');
      final List<dynamic> jsonList = json.decode(jsonString)['questions'];

      return jsonList.map((json) {
        return QuizQuestion(
          id: json['id'].toString(),
          question: json['question'],
          options: json['options'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load quiz questions: $e');
    }
  }
}
