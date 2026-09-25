class AppConstants {
  static const appName = 'Quizzical';
  static const quizTimeSeconds = 20;
  static const defaultQuestionCount = 10;

  // Only these six OpenTDB categories are shown in the app.
  static const allowedCategoryIds = <int>[9, 10, 23, 17, 25, 18];

  static const categoryImages = <int, String>{
    9: 'assets/general.svg',
    10: 'assets/books.svg',
    23: 'assets/history.svg',
    17: 'assets/science.svg',
    25: 'assets/art.svg',
    18: 'assets/vehicles.svg',
  };
}
