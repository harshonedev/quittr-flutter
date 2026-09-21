import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/settings/domain/entities/app_settings.dart';
import 'package:quittr/features/settings/domain/repositories/settings_repository.dart';

class ThemeCubit extends Cubit<bool> {
  final SettingsRepository _settingsRepository;
  late final StreamSubscription<AppSettings> _settingsSubscription;

  ThemeCubit({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(false) {
    // Listen to settings changes
    _settingsSubscription =
        _settingsRepository.settingsStream.listen((settings) {
      emit(settings.isDarkMode);
    });

    // Load initial settings
    _settingsRepository.getSettings().then((result) {
      result.fold(
        (failure) => null,
        (settings) => emit(settings.isDarkMode),
      );
    });
  }

  @override
  Future<void> close() {
    _settingsSubscription.cancel();
    return super.close();
  }
}
