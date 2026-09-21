import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/core/injection_container.dart';
import '../bloc/settings_bloc.dart';
import '../../domain/entities/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(LoadSettings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = state.settings ?? const AppSettings();

            return ListView(
              children: [
                _buildSection(
                  context,
                  'Subscription',
                  [
                    ListTile(
                      leading: const Icon(Icons.card_membership),
                      title: const Text('Manage Subscription'),
                      subtitle: const Text(
                          'View and manage your subscription details'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push('/subscription-management');
                      },
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'App Settings',
                  [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Enable dark theme'),
                      value: settings.isDarkMode,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                              UpdateSettings(
                                settings.copyWith(isDarkMode: value),
                              ),
                            );
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Notifications'),
                      subtitle: const Text('Enable push notifications'),
                      value: settings.enableNotifications,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(UpdateSettings(
                            settings.copyWith(enableNotifications: value)));
                      },
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Privacy',
                  [
                    ListTile(
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push('/privacy-policy');
                      },
                    ),
                    ListTile(
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push('/terms');
                      },
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'About',
                  [
                    ListTile(
                      title: const Text('Version'),
                      trailing: const Text('1.0.0'),
                    ),
                    ListTile(
                      title: const Text('Licenses'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showLicensePage(context: context);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}
