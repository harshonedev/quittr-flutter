import 'package:equatable/equatable.dart';

class Reason extends Equatable {
  final String? id;
  final String reason;
  final DateTime createdAt;

  const Reason({
    this.id,
    required this.reason,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, reason, createdAt];
}
