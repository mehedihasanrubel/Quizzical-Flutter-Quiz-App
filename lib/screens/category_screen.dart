import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz_category.dart';
import '../widgets/error_retry.dart';
import '../widgets/phone_page.dart';
import '../widgets/simple_top_bar.dart';
import 'config_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizController>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhonePage(
      child: Consumer<QuizController>(
        builder: (context, controller, _) {
          if (controller.categoriesLoading && controller.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null && controller.categories.isEmpty) {
            return ErrorRetry(
              message: controller.error!,
              onRetry: controller.loadCategories,
            );
          }

          return Column(
            children: [
              SimpleTopBar(
                title: 'Quizzical',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const horizontalPadding = 14.0;
                    const verticalPadding = 8.0;
                    const gap = 10.0;
                    final cardWidth =
                        (constraints.maxWidth - horizontalPadding * 2 - gap) / 2;
                    final cardHeight =
                        (constraints.maxHeight - verticalPadding * 2 - gap * 2) /
                            3;

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        horizontalPadding,
                        verticalPadding,
                        horizontalPadding,
                        verticalPadding,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: gap,
                        mainAxisSpacing: gap,
                        childAspectRatio: cardWidth / cardHeight,
                      ),
                      itemCount: controller.categories.length,
                      itemBuilder: (_, index) {
                        final category = controller.categories[index];
                        return CategoryCard(
                          category: category,
                          index: index,
                          onTap: () {
                            controller.selectCategory(category);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConfigScreen(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackColors = [
      const Color(0xFFD7F1EA),
      const Color(0xFFD2F6D8),
      const Color(0xFFFFE5A9),
      const Color(0xFFE7C4F6),
      const Color(0xFFFFB8B8),
      const Color(0xFFB9D7F3),
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: fallbackColors[index % fallbackColors.length],
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 2),
                color: Color(0x16000000),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              AppConstants.categoryImages[category.id]!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
