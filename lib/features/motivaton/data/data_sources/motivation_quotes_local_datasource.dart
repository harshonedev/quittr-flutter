import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quittr/features/motivaton/data/models/motivational_quotes_model.dart';

abstract interface class MotivationQuotesLocalDatasource {
  Future<List<MotivationalQuotesModel>> getMotivaionalQuotes();
}

class MotivationQuotesLocalDatasourceImpl
    implements MotivationQuotesLocalDatasource {
  @override
  Future<List<MotivationalQuotesModel>> getMotivaionalQuotes() async {
    try {
      // Read the JSON file
      final String response =
          await rootBundle.loadString('assets/data/motivational_quotes.json');
      final data = await json.decode(response);

      List<dynamic> motivationalQuotes = data['quotes'];

      return motivationalQuotes
          .map((quotes) => MotivationalQuotesModel.fromJson(quotes))
          .toList();
    } catch (error) {
      throw Exception('Failed to load quotes: ${error.toString()}');
    }
  }
}
