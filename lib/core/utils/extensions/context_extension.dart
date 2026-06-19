import 'package:flutter/material.dart';

import '../../../app/config/theme/app_colors_extension.dart';

/// Theme & media-query shortcuts. Access design tokens via `context.colors`.
extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Custom design tokens from [AppColorsExtension].
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.light;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
