import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:quittr/features/profile/domain/repositories/profile_repository.dart';
import 'package:quittr/features/profile/domain/usecases/update_profile_photo.dart';
import 'package:quittr/features/profile/domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: sl<ProfileRepository>(),
        authRepository: sl<AuthRepository>(),
        updateProfilePhoto: sl<UpdateProfilePhoto>(),
      )..add(LoadProfile()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Handle errors
          if (state.errorMessage != null) {
            // Dismiss loading dialog if showing
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final profile = state.profile;
              if (profile == null) {
                return const Center(child: Text('No profile data'));
              }

              // Set initial value for the controller
              _displayNameController.text = profile.displayName ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        final updatedProfile = Profile(
                          uid: profile.uid,
                          displayName: _displayNameController.text.trim(),
                          email: profile.email,
                          photoUrl: profile.photoUrl,
                        );
                        context
                            .read<ProfileBloc>()
                            .add(UpdateProfile(updatedProfile));
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.isLoading)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          Text(state.isLoading ? "Saving..." : 'Save Changes'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
