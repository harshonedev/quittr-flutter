import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final int pointsAwarded;
  final String iconName;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int requiredDays; // For streak-based achievements
  final AchievementType type;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsAwarded,
    required this.iconName,
    required this.isUnlocked,
    this.unlockedAt,
    required this.requiredDays,
    required this.type,
  });

  Achievement copyWith({
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
    return Achievement(
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        pointsAwarded,
        iconName,
        isUnlocked,
        unlockedAt,
        requiredDays,
        type,
      ];
}

enum AchievementType {
  streak, // For continuous days without relapse
  action, // For completing specific actions (e.g., writing journal entries)
  milestone // For reaching specific milestones (e.g., first week complete)
}
