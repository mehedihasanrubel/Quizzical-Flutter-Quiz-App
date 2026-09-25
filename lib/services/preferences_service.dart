import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<Map<String, dynamic>> loadQuizConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'amount': prefs.getInt('amount') ?? 10,
      'difficulty': prefs.getString('difficulty') ?? 'Any Difficulty',
      'type': prefs.getString('type') ?? 'Multiple Choice',
    };
  }

  Future<void> saveQuizConfig({
    required int amount,
    required String difficulty,
    required String type,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('amount', amount);
    await prefs.setString('difficulty', difficulty);
    await prefs.setString('type', type);
  }
}
