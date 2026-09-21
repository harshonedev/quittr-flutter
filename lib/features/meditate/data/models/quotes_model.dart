import 'package:quittr/features/meditate/domain/entities/quotes.dart';

class QuotesModel extends Quotes {
  QuotesModel({required int id, required String text}) : super(id, text);

  factory QuotesModel.fromJson(Map<String, dynamic> json) {
    return QuotesModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  QuotesModel copyWith({
    int? id,
    String? text,
  }) {
    return QuotesModel(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}
