import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/quiz_controller.dart';
import 'core/theme/app_theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuizController()..loadCategories(),
      child: const QuizzicalApp(),
    ),
  );
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzical',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
