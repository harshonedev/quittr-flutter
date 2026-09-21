import 'package:quittr/features/side%20effects/domian/entites/side_effect.dart';

class SideEffectsModel extends SideEffect {

  SideEffectsModel({required int id , required String text}) : super( id, text);


  // New method to create a copy of the instance with optional new values
  SideEffectsModel copyWith({int? id, String? text}) {
    return SideEffectsModel(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  // Convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  // Create an instance from a JSON map
  factory SideEffectsModel.fromJson(Map<String, dynamic> json) {
    return SideEffectsModel(
      id: json['id'],
      text: json['text'],
    );
  }


}