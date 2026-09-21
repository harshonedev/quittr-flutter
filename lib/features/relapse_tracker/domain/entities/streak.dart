import 'package:equatable/equatable.dart';

class Streak extends Equatable {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int durationInDays;
  final bool isActive;

  const Streak({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.durationInDays,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, startDate, endDate, durationInDays, isActive];
}
