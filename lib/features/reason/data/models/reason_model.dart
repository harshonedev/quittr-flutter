import '../../domain/entities/reason.dart';

class ReasonModel extends Reason {
  const ReasonModel({
    required super.id,
    required super.reason,
    required super.createdAt,
  });

  factory ReasonModel.fromMap(Map<String, dynamic> map) {
    return ReasonModel(
      id: map['id'],
      reason: map['reason'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ReasonModel copyWith({
    String? id,
    String? reason,
    DateTime? createdAt,
  }) {
    return ReasonModel(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
