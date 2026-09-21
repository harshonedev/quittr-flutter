import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;
  final bool isNewUser;

  const User({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
    this.isNewUser = false,
  });

  @override
  List<Object?> get props => [id, email, name, photoUrl, isNewUser];
}
