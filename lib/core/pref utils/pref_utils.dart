import 'package:get_storage/get_storage.dart';

class PrefUtils {
  final GetStorage getStorage = GetStorage();

  static const String startDateTimeKey = 'start_date_time';
  static const String relapsedDatesKey = 'relapsed_dates';

  void setStartDateTime(DateTime dateTime) {
    getStorage.write(startDateTimeKey, dateTime.toIso8601String());
    print("Saved start datetime: ${dateTime.toIso8601String()}");
  }

  DateTime? getStartDateTime() {
    String? storedDateTime = getStorage.read(startDateTimeKey);
    return storedDateTime != null ? DateTime.parse(storedDateTime) : null;
  }

  void resetTimer() {
    getStorage.remove(relapsedDatesKey);
    print("Timer reset - start datetime cleared");
  }

  // Keep existing relapsed dates methods
  void setRelapsedDates(List<DateTime> dates) {
    final dateStrings = dates.map((date) => date.toIso8601String()).toList();
    getStorage.write(relapsedDatesKey, dateStrings);
  }

  List<DateTime> getRelapsedDates() {
    final List<dynamic>? dateStrings = getStorage.read(relapsedDatesKey);
    print(dateStrings.toString());
    return dateStrings?.map((str) => DateTime.parse(str as String)).toList() ??
        [];
  }
}
