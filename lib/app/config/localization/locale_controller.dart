import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/shared_pref_service.dart';
import 'generated/translations.g.dart';

part 'locale_controller.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  @override
  AppLocale build() {
    final saved = ref.watch(sharedPrefServiceProvider).localeCode;
    if (saved != null) {
      final locale = AppLocaleUtils.parse(saved);
      LocaleSettings.setLocale(locale);
      return locale;
    }
    LocaleSettings.useDeviceLocale();
    return LocaleSettings.currentLocale;
  }

  Future<void> changeLocale(AppLocale newLocale) async {
    LocaleSettings.setLocale(newLocale);
    state = newLocale;
    await ref.read(sharedPrefServiceProvider).setLocaleCode(newLocale.languageCode);
  }
}
