import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  const Profile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl];
}
