import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class PhonePage extends StatelessWidget {
  final Widget child;
  final bool safe;

  const PhonePage({super.key, required this.child, this.safe = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: safe ? SafeArea(child: child) : child,
    );
  }
}
