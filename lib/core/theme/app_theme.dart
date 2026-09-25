import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: AppColors.page,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal),
        useMaterial3: true,
        fontFamily: 'Arial',
      );
}
