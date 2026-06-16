import 'package:shared_preferences/shared_preferences.dart';

class UserPrefsService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _userNameKey = 'user_name';
  static const String _userAgeKey = 'user_age';
  static const String _userGradeKey = 'user_grade';

  /// Returns true if the user has already completed the onboarding flow.
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Saves the user profile data and marks onboarding as complete.
  static Future<void> saveUserProfile({
    required String name,
    required int age,
    required String grade,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setInt(_userAgeKey, age);
    await prefs.setString(_userGradeKey, grade);
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Returns a map with the stored user profile, or null values if not set.
  static Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey),
      'age': prefs.getInt(_userAgeKey),
      'grade': prefs.getString(_userGradeKey),
    };
  }

  /// Clears all user data and resets onboarding (useful for testing/logout).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
