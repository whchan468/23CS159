import 'package:shared_preferences/shared_preferences.dart';

class SStorage {
  static final SStorage _instance = SStorage();

  static SStorage getInstance() {
    return _instance;
  }

  Future<void> insertTime(String key, DateTime time) async {
    final value = time.millisecondsSinceEpoch;
    final storage = await SharedPreferences.getInstance();
    await storage.setInt(key, value);
  }

  Future<DateTime> getTime(String key) async {
    final storage = await SharedPreferences.getInstance();
    final result = await storage.getInt(key);
    if (result != null) return DateTime.fromMillisecondsSinceEpoch(result);
    return DateTime.now();
  }
}
