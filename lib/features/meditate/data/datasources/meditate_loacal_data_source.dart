import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quittr/features/meditate/data/models/quotes_model.dart';

abstract interface class MeditateLoacalDataSource {
  Future<List<QuotesModel>> getQuotes();
}

class MeditateLoacalDataSourceImpl implements MeditateLoacalDataSource {
  @override
  Future<List<QuotesModel>> getQuotes() async {
    try {
      // Read the JSON file
      final String response =
          await rootBundle.loadString('assets/data/quotes.json');
      final data = await json.decode(response);

      // Convert the JSON data to a list of QuotesModel
      final List<dynamic> quotesJson = data['quotes'];
      return quotesJson.map((quote) => QuotesModel.fromJson(quote)).toList();
    } catch (error) {
      throw Exception('Failed to load quotes: ${error.toString()}');
    }
  }
}
