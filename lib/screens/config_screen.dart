import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/phone_page.dart';
import '../widgets/simple_top_bar.dart';
import 'quiz_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizController>().loadSavedConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhonePage(
      child: Consumer<QuizController>(
        builder: (context, c, _) {
          return Column(
            children: [
              SimpleTopBar(
                title: 'Quizzical',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/config.svg',
                          height: 115,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Quizzical',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Configuration\n${c.selectedCategoryName}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            height: 1.35,
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _FieldLabel('Number of Questions'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              min: 1,
                              max: 50,
                              divisions: 49,
                              value: c.amount.toDouble(),
                              activeColor: AppColors.blue,
                              onChanged: (v) => c.setAmount(v.round()),
                            ),
                          ),
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${c.amount}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.blue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      const _FieldLabel('Difficulty Level'),
                      _DropField(
                        value: c.difficulty,
                        items: const [
                          'Any Difficulty',
                          'Easy',
                          'Medium',
                          'Hard',
                        ],
                        onChanged: (v) {
                          if (v != null) c.setDifficulty(v);
                        },
                      ),
                      const SizedBox(height: 12),
                      const _FieldLabel('Question Type'),
                      _DropField(
                        value: c.type,
                        items: const ['Multiple Choice', 'True / False'],
                        onChanged: (v) {
                          if (v != null) c.setQuestionType(v);
                        },
                      ),
                      if (c.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          c.error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 11,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: c.quizLoading
                              ? null
                              : () async {
                                  final ok = await c.startQuiz();
                                  if (!context.mounted) return;
                                  if (ok) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const QuizScreen(),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: c.quizLoading
                              ? const SizedBox(
                                  width: 19,
                                  height: 19,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'START',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
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
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DropField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFB8C5C3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 17),
          style: const TextStyle(fontSize: 11, color: AppColors.text),
          items: items
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
