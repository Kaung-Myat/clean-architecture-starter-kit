import 'package:flutter/material.dart';

import '../colors.dart';

/// Design tokens that don't fit in [ColorScheme] (custom background, shadows).
/// Access via `context.colors` (see `context_extension.dart`).
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.customBackground,
    required this.cardShadow,
    required this.success,
    required this.warning,
  });

  final Color customBackground;
  final Color cardShadow;
  final Color success;
  final Color warning;

  static const light = AppColorsExtension(
    customBackground: AppColors.lightBackground,
    cardShadow: AppColors.lightCardShadow,
    success: AppColors.success,
    warning: AppColors.warning,
  );

  static const dark = AppColorsExtension(
    customBackground: AppColors.darkBackground,
    cardShadow: AppColors.darkCardShadow,
    success: AppColors.success,
    warning: AppColors.warning,
  );

  @override
  AppColorsExtension copyWith({
    Color? customBackground,
    Color? cardShadow,
    Color? success,
    Color? warning,
  }) {
    return AppColorsExtension(
      customBackground: customBackground ?? this.customBackground,
      cardShadow: cardShadow ?? this.cardShadow,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      customBackground: Color.lerp(customBackground, other.customBackground, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
