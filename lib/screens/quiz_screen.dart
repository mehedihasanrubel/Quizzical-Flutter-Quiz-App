import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz_question.dart';
import '../widgets/phone_page.dart';
import 'results_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PhonePage(
        child: Consumer<QuizController>(
          builder: (context, c, _) {
            final q = c.currentQuestion;
            if (q == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                QuizHeader(controller: c),
                LinearProgressIndicator(
                  value: c.progress,
                  minHeight: 4,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.blue),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                    child: Column(
                      children: [
                        QuestionCard(q.question),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: q.answers.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) => AnswerButton(
                              answer: q.answers[i],
                              question: q,
                              controller: c,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: c.answered
                                ? () {
                                    final isLast = c.isLastQuestion;
                                    c.nextQuestion();
                                    if (isLast && context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ResultsScreen(),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  AppColors.teal.withOpacity(.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: Text(
                              c.isLastQuestion ? 'FINISH' : 'NEXT',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class QuizHeader extends StatelessWidget {
  final QuizController controller;
  const QuizHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 44),
          Text(
            '${controller.currentIndex + 1}/${controller.questions.length}',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
          ),
          TextButton.icon(
            onPressed: () {
              controller.exitQuiz();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.exit_to_app_rounded, size: 13),
            label: const Text(
              'EXIT',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  const QuestionCard(this.question, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        question,
        style: const TextStyle(
          fontSize: 13,
          height: 1.35,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String answer;
  final QuizQuestion question;
  final QuizController controller;

  const AnswerButton({
    super.key,
    required this.answer,
    required this.question,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedAnswer == answer;
    final correct = answer == question.correctAnswer;

    Color background = Colors.white;
    if (controller.answered && correct) {
      background = AppColors.green;
    } else if (controller.answered && selected && !correct) {
      background = AppColors.red;
    }

    return InkWell(
      onTap: controller.answered ? null : () => controller.answerQuestion(answer),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                answer,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            if (controller.answered && correct)
              const Icon(Icons.check_circle_outline, size: 17),
            if (controller.answered && selected && !correct)
              const Icon(Icons.cancel_outlined, size: 17),
            if (!controller.answered)
              const Icon(Icons.radio_button_unchecked, size: 17),
          ],
        ),
      ),
    );
  }
}
