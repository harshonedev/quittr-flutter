import 'package:quittr/features/motivaton/domain/entity/motivational_quotes.dart';

class MotivationalQuotesModel extends MotivationalQuotes {
  MotivationalQuotesModel({required int id, required String text})
      : super(id, text);

  // Method to convert a MotivationalQuotes instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  // Factory method to create a MotivationalQuotes instance from a JSON map
  factory MotivationalQuotesModel.fromJson(Map<String, dynamic> json) {
    return MotivationalQuotesModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }

  // Method to create a copy of the instance with optional new values
  MotivationalQuotesModel copyWith({int? id, String? text}) {
    return MotivationalQuotesModel(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}
