import 'package:flutter/material.dart';

import '../colors.dart';
import '../dimensions.dart';
import 'app_colors_extension.dart';

final ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  extensions: const [AppColorsExtension.light],
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
