import 'package:equatable/equatable.dart';

class RelapseEntry extends Equatable {
  final String id;
  final DateTime timestamp;
  final List<String> triggers;
  final String? notes;
  final EmotionalState emotionalState;
  final String userId;

  const RelapseEntry({
    required this.id,
    required this.timestamp,
    required this.triggers,
    this.notes,
    required this.emotionalState,
    required this.userId,
  });

  @override
  List<Object?> get props =>
      [id, timestamp, triggers, notes, emotionalState, userId];
}

enum EmotionalState { stressed, lonely, bored, anxious, tired, other }
