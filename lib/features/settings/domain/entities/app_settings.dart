import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final int? id;
  final bool isDarkMode;
  final bool enableNotifications;
  final String language;

  const AppSettings({
    this.id,
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.language = 'en',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isDarkMode': isDarkMode ? 1 : 0,
      'enableNotifications': enableNotifications ? 1 : 0,
      'language': language,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] as int?,
      isDarkMode: map['isDarkMode'] == 1,
      enableNotifications: map['enableNotifications'] == 1,
      language: map['language'] as String,
    );
  }

  AppSettings copyWith({
    bool? isDarkMode,
    bool? enableNotifications,
    String? language,
  }) {
    return AppSettings(
      id: id,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [id, isDarkMode, enableNotifications, language];
}
