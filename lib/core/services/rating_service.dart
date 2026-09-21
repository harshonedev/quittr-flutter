import 'dart:async';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingService {
  final Logger _logger = Logger();

  static const String _hasRatedKey = 'has_rated_app';
  static const String _lastRatingPromptKey = 'last_rating_prompt';
  static const int _minUsageTimeInSeconds = 180; // 3 minutes

  Timer? _usageTimer;
  int _elapsedTimeInSeconds = 0;

  void startTrackingUsageTime(Function onTimeReached) {
    _usageTimer
        ?.cancel(); // Cancel any existing timer before starting a new one
    _usageTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTimeInSeconds++;
      if (_elapsedTimeInSeconds >= _minUsageTimeInSeconds) {
        _checkAndShowRatingPrompt(onTimeReached);
        _usageTimer?.cancel();
      }
    });
  }

  void dispose() {
    if (_usageTimer != null && _usageTimer!.isActive) {
      _usageTimer?.cancel();
    }
  }

  Future<void> _checkAndShowRatingPrompt(Function onTimeReached) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRated = prefs.getBool(_hasRatedKey) ?? false;
    final lastPrompt = prefs.getInt(_lastRatingPromptKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    _logger.i(
        'Checking rating prompt: hasRated=$hasRated, lastPrompt=$lastPrompt, now=$now');

    // Don't show if user has already rated or was prompted in the last 7 days
    if (!hasRated && (now - lastPrompt > 7 * 24 * 60 * 60 * 1000)) {
      onTimeReached();
    }
  }

  Future<void> setHasRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasRatedKey, true);
  }

  Future<void> setLastRatingPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _lastRatingPromptKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> openPlayStore() async {
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.breakfree';
    final uri = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      await setHasRated();
    }
  }
}
