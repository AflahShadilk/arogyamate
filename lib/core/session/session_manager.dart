import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserLoggedIn = 'UserLoggedIn';
  static const String _keyHasSeen = 'welcome';
  static const String _keyIsDarkMode = 'isDarkMode';
  static const String _keyProfileImage = 'image';
  static const String _keyHospitalName = 'name';
  static const String _keyHospitalId = 'id';



  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUserLoggedIn) ?? false;
  }

  static Future<bool> hasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeen) ?? false;
  }


  static Future<void> saveLogin({
    required String image,
    required String name,
    required String id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImage, image);
    await prefs.setString(_keyHospitalName, name);
    await prefs.setString(_keyHospitalId, id);
    await prefs.setBool(_keyUserLoggedIn, true);
  }

  static Future<void> setWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeen, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserLoggedIn);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyProfileImage);
    return (value != null && value.isNotEmpty) ? value : null;
  }

  static Future<String?> getHospitalName() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyHospitalName);
    return (value != null && value.isNotEmpty) ? value : null;
  }

  static Future<String?> getHospitalId() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyHospitalId);
    return (value != null && value.isNotEmpty) ? value : null;
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDarkMode, value);
  }
}
