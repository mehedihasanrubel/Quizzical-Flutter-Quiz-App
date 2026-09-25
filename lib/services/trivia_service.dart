import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';
import '../models/quiz_category.dart';
import '../models/quiz_question.dart';

class TriviaService {
  static const _categoryUrl = 'https://opentdb.com/api_category.php';

  Future<List<QuizCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse(_categoryUrl));
    if (response.statusCode != 200) {
      throw Exception('Category request failed');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final all = (data['trivia_categories'] as List)
        .map((e) => QuizCategory.fromJson(e as Map<String, dynamic>))
        .toList();

    return [
      for (final id in AppConstants.allowedCategoryIds)
        ...all.where((category) => category.id == id),
    ];
  }

  Future<List<QuizQuestion>> fetchQuestions({
    required int categoryId,
    required int amount,
    required String difficulty,
    required String type,
  }) async {
    final params = <String, String>{
      'amount': '$amount',
      'category': '$categoryId',
      'type': type == 'Multiple Choice' ? 'multiple' : 'boolean',
    };

    if (difficulty != 'Any Difficulty') {
      params['difficulty'] = difficulty.toLowerCase();
    }

    final uri = Uri.https('opentdb.com', '/api.php', params);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Question request failed');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final responseCode = data['response_code'] as int? ?? -1;
    if (responseCode != 0) {
      throw Exception('OpenTDB returned code $responseCode');
    }

    final raw = data['results'] as List;
    final questions = raw
        .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
        .toList();

    if (questions.isEmpty) {
      throw Exception('No questions returned');
    }

    return questions;
  }
}
