import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/core/routing/app_router.dart';
import 'package:quittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:quittr/features/profile/domain/repositories/profile_repository.dart';
import 'package:quittr/features/profile/domain/usecases/update_profile_photo.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/relapse_tracker/presentation/bloc/relapse_tracker_bloc.dart';
import '../bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          if (state.isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.of(context, rootNavigator: true)
                .popUntil((route) => route.isFirst);
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            } else if (state.profile == null &&
                !state.isLoading &&
                state.errorMessage == null) {
              // Account deleted or signed out
              context
                  .read<RelapseTrackerBloc>()
                  .add(RelapseTrackerResetTimerEvent());
              AppRouter.isAuthenticated = false;
              context.go('/auth');
            }
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!));
              }

              final profile = state.profile;
              if (profile == null) {
                return const Center(child: Text('No profile data'));
              }

              final String displayName =
                  (profile.displayName?.isNotEmpty ?? false)
                      ? profile.displayName!
                      : "Username";

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text('You'),
                    centerTitle: false,
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  backgroundImage: profile.photoUrl != null
                                      ? NetworkImage(profile.photoUrl!)
                                      : null,
                                  child: profile.photoUrl == null
                                      ? Text(
                                          displayName[0],
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              if (state.isUploadingPhoto)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(127),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              // Positioned(
                              //   bottom: 0,
                              //   right: 0,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color:
                              //           Theme.of(context).colorScheme.primary,
                              //       shape: BoxShape.circle,
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: Colors.black.withAlpha(25),
                              //           spreadRadius: 2,
                              //           blurRadius: 10,
                              //         ),
                              //       ],
                              //     ),
                              //     child: IconButton(
                              //         icon: const Icon(Icons.camera_alt),
                              //         color: Theme.of(context)
                              //             .colorScheme
                              //             .onPrimary,
                              //         onPressed:
                              //             () {} //showProfilePhotoPicker(context),
                              //         ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            displayName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile.email ?? '',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          _ProfileMenuItem(
                            icon: Icons.edit_outlined,
                            title: 'Edit Profile',
                            onTap: () async {
                              await context.push('/profile/edit');
                              if (context.mounted) {
                                context.read<ProfileBloc>().add(LoadProfile());
                              }
                            },
                          ),
                          Divider(
                            height: 1,
                            indent: 56,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          _ProfileMenuItem(
                            icon: Icons.lightbulb_outline,
                            title: 'Reason for Change',
                            onTap: () => context.push('/reasons'),
                          ),
                          Divider(
                            height: 1,
                            indent: 56,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          _ProfileMenuItem(
                            icon: Icons.book_outlined,
                            title: 'Recovery Journal',
                            onTap: () => context.push('/journal'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 24,
                      ),
                      child: Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          children: [
                            _ProfileMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Settings',
                              onTap: () => context.push('/settings'),
                            ),
                            Divider(
                              height: 1,
                              indent: 56,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            _ProfileMenuItem(
                              icon: Icons.logout_outlined,
                              title: 'Sign Out',
                              textColor: Theme.of(context).colorScheme.error,
                              iconColor: Theme.of(context).colorScheme.error,
                              onTap: () {
                                _showSignOutDialog(context);
                              },
                            ),
                            Divider(
                              height: 1,
                              indent: 56,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            _ProfileMenuItem(
                              icon: Icons.delete_outline,
                              title: 'Delete Account',
                              textColor: Theme.of(context).colorScheme.error,
                              iconColor: Theme.of(context).colorScheme.error,
                              onTap: () {
                                _showDeleteAccountDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              context.read<ProfileBloc>().add(SignOut());
              context
                  .read<RelapseTrackerBloc>()
                  .add(RelapseTrackerResetTimerEvent());

              AppRouter.isAuthenticated = false;
              context.go('/auth');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProfileBloc>().add(DeleteAccount());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color:
                  iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor ?? Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
