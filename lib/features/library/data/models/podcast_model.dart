import 'package:quittr/features/library/domain/entities/podcast.dart';

class PodcastModel extends Podcast {
  PodcastModel({required super.title, required super.filePath});

  // Factory constructor to create a PodcastModel from JSON
  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      title: json['title'] as String,
      filePath: json['filePath'] as String,
    );
  }

  // Method to convert a PodcastModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'filePath': filePath,
    };
  }
}
