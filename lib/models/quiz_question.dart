import 'dart:math';

class QuizQuestion {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  QuizQuestion({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.answers,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final correct = decodeHtml(json['correct_answer'] as String);
    final incorrect = (json['incorrect_answers'] as List)
        .map((e) => decodeHtml(e.toString()))
        .toList();

    final answers = <String>[correct, ...incorrect]..shuffle(Random());

    return QuizQuestion(
      category: decodeHtml(json['category'] as String),
      difficulty: json['difficulty'] as String,
      question: decodeHtml(json['question'] as String),
      correctAnswer: correct,
      answers: answers,
    );
  }
}

String decodeHtml(String value) {
  return value
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&eacute;', 'é')
      .replaceAll('&ouml;', 'ö')
      .replaceAll('&uuml;', 'ü')
      .replaceAll('&rsquo;', '’')
      .replaceAll('&ldquo;', '“')
      .replaceAll('&rdquo;', '”');
}
