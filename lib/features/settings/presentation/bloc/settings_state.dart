part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final AppSettings? settings;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState._({
    this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  const SettingsState.initial() : this._();
  const SettingsState.loading() : this._(isLoading: true);
  const SettingsState.loaded(AppSettings settings) : this._(settings: settings);
  const SettingsState.error(String message) : this._(errorMessage: message);

  @override
  List<Object?> get props => [settings, isLoading, errorMessage];
}
