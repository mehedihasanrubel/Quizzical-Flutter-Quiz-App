import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../models/quiz_category.dart';
import '../models/quiz_question.dart';
import '../services/preferences_service.dart';
import '../services/trivia_service.dart';

class QuizController extends ChangeNotifier {
  QuizController({
    TriviaService? triviaService,
    PreferencesService? preferencesService,
  })  : _triviaService = triviaService ?? TriviaService(),
        _preferencesService = preferencesService ?? PreferencesService();

  final TriviaService _triviaService;
  final PreferencesService _preferencesService;

  List<QuizCategory> categories = [];
  List<QuizQuestion> questions = [];

  bool categoriesLoading = false;
  bool quizLoading = false;
  String? error;

  int selectedCategoryId = AppConstants.allowedCategoryIds.first;
  String selectedCategoryName = 'General Knowledge';
  int amount = AppConstants.defaultQuestionCount;
  String difficulty = 'Any Difficulty';
  String type = 'Multiple Choice';

  int currentIndex = 0;
  int score = 0;
  int remainingSeconds = AppConstants.quizTimeSeconds;
  bool answered = false;
  String? selectedAnswer;
  DateTime? quizStartedAt;
  Duration totalTime = Duration.zero;

  Timer? _timer;

  QuizQuestion? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex];

  double get progress =>
      questions.isEmpty ? 0 : (currentIndex + 1) / questions.length;

  Future<void> loadCategories() async {
    if (categories.isNotEmpty || categoriesLoading) return;

    categoriesLoading = true;
    error = null;
    notifyListeners();

    try {
      categories = await _triviaService.fetchCategories();
    } catch (_) {
      error = 'Could not load categories. Check your internet and retry.';
    } finally {
      categoriesLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(QuizCategory category) {
    selectedCategoryId = category.id;
    selectedCategoryName = category.name;
    notifyListeners();
  }

  Future<void> loadSavedConfig() async {
    final config = await _preferencesService.loadQuizConfig();
    amount = config['amount'] as int;
    difficulty = config['difficulty'] as String;
    type = config['type'] as String;
    notifyListeners();
  }

  void setAmount(int value) {
    amount = value;
    notifyListeners();
  }

  void setDifficulty(String value) {
    difficulty = value;
    notifyListeners();
  }

  void setQuestionType(String value) {
    type = value;
    notifyListeners();
  }

  Future<bool> startQuiz() async {
    quizLoading = true;
    error = null;
    notifyListeners();

    await _preferencesService.saveQuizConfig(
      amount: amount,
      difficulty: difficulty,
      type: type,
    );

    try {
      questions = await _triviaService.fetchQuestions(
        categoryId: selectedCategoryId,
        amount: amount,
        difficulty: difficulty,
        type: type,
      );

      currentIndex = 0;
      score = 0;
      answered = false;
      selectedAnswer = null;
      remainingSeconds = AppConstants.quizTimeSeconds;
      quizStartedAt = DateTime.now();
      totalTime = Duration.zero;
      _startTimer();
      return true;
    } catch (_) {
      error = 'Could not fetch questions. Try again with the same settings.';
      return false;
    } finally {
      quizLoading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (answered || questions.isEmpty) return;

      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        answerQuestion(null);
      }
    });
  }

  void answerQuestion(String? answer) {
    if (answered || currentQuestion == null) return;

    answered = true;
    selectedAnswer = answer;

    if (answer != null && answer == currentQuestion!.correctAnswer) {
      score++;
    }

    notifyListeners();
  }

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  void nextQuestion() {
    if (!answered) return;

    if (isLastQuestion) {
      finishQuiz();
      return;
    }

    currentIndex++;
    answered = false;
    selectedAnswer = null;
    remainingSeconds = AppConstants.quizTimeSeconds;
    notifyListeners();
  }

  void finishQuiz() {
    _timer?.cancel();
    totalTime = DateTime.now().difference(quizStartedAt ?? DateTime.now());
    notifyListeners();
  }

  void exitQuiz() {
    _timer?.cancel();
  }

  void resetForNewQuiz() {
    _timer?.cancel();
    questions = [];
    currentIndex = 0;
    score = 0;
    answered = false;
    selectedAnswer = null;
    remainingSeconds = AppConstants.quizTimeSeconds;
    totalTime = Duration.zero;
    quizStartedAt = null;
    error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
