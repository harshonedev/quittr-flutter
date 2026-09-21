import 'package:quittr/features/achievements/domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required String id,
    required String title,
    required String description,
    required int pointsAwarded,
    required String iconName,
    required bool isUnlocked,
    DateTime? unlockedAt,
    required int requiredDays,
    required AchievementType type,
  }) : super(
          id: id,
          title: title,
          description: description,
          pointsAwarded: pointsAwarded,
          iconName: iconName,
          isUnlocked: isUnlocked,
          unlockedAt: unlockedAt,
          requiredDays: requiredDays,
          type: type,
        );

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      pointsAwarded: json['points_awarded'] as int,
      iconName: json['icon_name'] as String,
      isUnlocked: json['is_unlocked'] as bool,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'] as String)
          : null,
      requiredDays: json['required_days'] as int,
      type: AchievementType.values.firstWhere(
          (type) => type.name == (json['type'] as String),
          orElse: () => AchievementType.milestone),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points_awarded': pointsAwarded,
      'icon_name': iconName,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'required_days': requiredDays,
      'type': type.name,
    };
  }

  AchievementModel copyWithModel({
    String? id,
    String? title,
    String? description,
    int? pointsAwarded,
    String? iconName,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? requiredDays,
    AchievementType? type,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      iconName: iconName ?? this.iconName,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requiredDays: requiredDays ?? this.requiredDays,
      type: type ?? this.type,
    );
  }
}
