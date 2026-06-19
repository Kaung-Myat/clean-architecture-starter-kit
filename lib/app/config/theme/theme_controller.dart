import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/shared_pref_service.dart';

part 'theme_controller.g.dart';

/// Holds the active [ThemeMode] and persists it via [SharedPrefService].
@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    final index = ref.watch(sharedPrefServiceProvider).themeModeIndex;
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(sharedPrefServiceProvider).setThemeModeIndex(mode.index);
    state = mode;
  }

  Future<void> toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    return setThemeMode(next);
  }
}
