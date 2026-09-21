import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/core/services/image_picker_service.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import '../bloc/profile_bloc.dart';

Future<void> showProfilePhotoPicker(BuildContext context) async {
  final ImagePickerService picker = sl<ImagePickerService>();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext dialogContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () async {
                dialogContext.pop();
                final imagePath = await picker.pickImage(ImageSource.camera);
                if (context.mounted && imagePath != null) {
                  // Add the UpdateProfilePhotoEvent to update the profile photo
                  context
                      .read<ProfileBloc>()
                      .add(UpdateProfilePhotoEvent(imagePath));

                  // Trigger the "Identity Established" achievement
                  try {
                    context.read<AchievementsBloc>().add(UnlockAchievementEvent(
                        UnlockAchievementEvent.addProfilePhoto));

                    // Add a delay to give time for the achievement state to update
                    Future.delayed(const Duration(milliseconds: 500), () {
                      // Show achievement unlocked snackbar
                      if (context.read<AchievementsBloc>().state
                          is AchievementUnlocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                "New Achievement Unlocked: Identity Established +10 points"),
                            action: SnackBarAction(
                              label: 'See',
                              onPressed: () {
                                context.push('/achievements');
                              },
                            ),
                          ),
                        );
                      }
                    });
                  } catch (e) {
                    debugPrint("Error unlocking profile photo achievement: $e");
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () async {
                dialogContext.pop();
                final imagePath = await picker.pickImage(ImageSource.gallery);
                if (context.mounted && imagePath != null) {
                  // Add the UpdateProfilePhotoEvent to update the profile photo
                  context
                      .read<ProfileBloc>()
                      .add(UpdateProfilePhotoEvent(imagePath));

                  // Trigger the "Identity Established" achievement
                  try {
                    context.read<AchievementsBloc>().add(UnlockAchievementEvent(
                        UnlockAchievementEvent.addProfilePhoto));

                    // Add a delay to give time for the achievement state to update
                    Future.delayed(const Duration(milliseconds: 500), () {
                      // Show achievement unlocked snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              "New Achievement Unlocked: Identity Established +10 points"),
                          action: SnackBarAction(
                            label: 'See',
                            onPressed: () {
                              context.push('/achievements');
                            },
                          ),
                        ),
                      );
                    });
                  } catch (e) {
                    debugPrint("Error unlocking profile photo achievement: $e");
                  }
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
