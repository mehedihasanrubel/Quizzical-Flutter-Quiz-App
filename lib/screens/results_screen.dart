import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/phone_page.dart';
import 'category_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhonePage(
      safe: true,
      child: Consumer<QuizController>(
        builder: (context, c, _) {
          final percentage = ((c.score / max(1, c.questions.length)) * 100).round();
          final success = percentage >= 50;

          return LayoutBuilder(
            builder: (context, constraints) {
              final imageHeight = (constraints.maxHeight * .34).clamp(190.0, 260.0).toDouble();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          success ? 'assets/result_success.svg' : 'assets/result_try.svg',
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          success ? 'Congratulations!' : 'Keep Trying!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 280),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                          decoration: BoxDecoration(
                            color: success ? const Color(0xFF79DFA0) : const Color(0xFFFF4A1F),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: success ? const Color(0xFFC7F5D7) : const Color(0xFFFFB5A3),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.08),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            '$percentage%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: success ? AppColors.text : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          success
                              ? 'Great work! You have a strong score. Ready for another challenge?'
                              : 'Keep practicing and try again. You are getting closer!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.text),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Score  ${c.score}/${c.questions.length}   •   Time  ${c.totalTime.inSeconds}s',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              c.resetForNewQuiz();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const CategoryScreen()),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: AppColors.teal.withOpacity(.25),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text(
                              'PLAY AGAIN',
                              style: TextStyle(fontSize: 14, letterSpacing: .3, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
