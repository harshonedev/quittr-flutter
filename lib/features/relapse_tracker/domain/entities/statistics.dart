import 'package:equatable/equatable.dart';
import 'package:quittr/features/relapse_tracker/domain/entities/relapse_entry.dart';

class Statistics extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final int totalCleanDays;
  final double successRate;
  final Map<String, int> triggerFrequency;
  final Map<EmotionalState, int> emotionalStateFrequency;

  const Statistics({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCleanDays,
    required this.successRate,
    required this.triggerFrequency,
    required this.emotionalStateFrequency,
  });

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        totalCleanDays,
        successRate,
        triggerFrequency,
        emotionalStateFrequency,
      ];
}
