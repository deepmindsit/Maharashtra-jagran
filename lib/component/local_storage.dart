import 'package:maharashtrajagran/utils/exported_path.dart';

const bookmarkKey = "fav_ids";

class LocalStorage {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ✅ Save list of strings
  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  /// ✅ Get list of strings
  static Future<List<String>> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  // Add new ID
  Future<void> addFavoriteId(String id) async {
    List<String> ids = await LocalStorage.getStringList(bookmarkKey);
    if (!ids.contains(id)) {
      ids.add(id);
      await LocalStorage.setStringList(bookmarkKey, ids);
    }
  }

  // Remove ID
  Future<void> removeFavoriteId(String id) async {
    List<String> ids = await LocalStorage.getStringList(bookmarkKey);
    ids.remove(id);
    await LocalStorage.setStringList(bookmarkKey, ids);
  }

  // Get all IDs
  Future<List<String>> getFavoritesIds() async {
    return await LocalStorage.getStringList(bookmarkKey);
  }

  Future<bool> isDemo() async {
    final key = await LocalStorage.getString('auth_key');
    return key!.isNotEmpty;
  }
}
