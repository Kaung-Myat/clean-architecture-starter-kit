import 'package:flutter/material.dart';

import '../colors.dart';
import '../dimensions.dart';
import 'app_colors_extension.dart';

final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  extensions: const [AppColorsExtension.dark],
  appBarTheme: const AppBarTheme(centerTitle: true, scrolledUnderElevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(Dimens.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius),
      ),
    ),
  ),
);
