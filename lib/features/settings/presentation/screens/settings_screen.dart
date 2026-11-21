import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/localization/generated/translations.g.dart';
import '../../../../app/config/localization/locale_controller.dart';
import '../../../../app/config/theme/theme.dart';
import '../../../../core/auth/session_controller.dart';
import '../../../../core/env/app_flavor.dart';
import '../../../../core/env/env.dart';
import '../../../../core/env/flavor_controller.dart';
import '../../../../core/services/navigation_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final flavor = ref.watch(flavorControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.settings.flavor),
            subtitle: Text(flavor.name),
            trailing: DropdownButton<AppFlavor>(
              value: flavor,
              items: AppFlavor.values
                  .map(
                    (f) => DropdownMenuItem(
                      value: f,
                      child: Text(f.name),
                    ),
                  )
                  .toList(),
              onChanged: Env.isProd
                  ? null
                  : (value) {
                      if (value == null) return;
                      ref
                          .read(flavorControllerProvider.notifier)
                          .setFlavor(value);
                    },
            ),
          ),
          SwitchListTile(
            title: Text(t.settings.darkMode),
            value: themeMode == ThemeMode.dark,
            onChanged: (dark) {
              ref.read(themeControllerProvider.notifier).setThemeMode(
                    dark ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
          ListTile(
            title: Text(t.settings.language),
            subtitle: Text(locale.languageCode),
            trailing: DropdownButton<AppLocale>(
              value: locale,
              items: AppLocale.values
                  .map(
                    (l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.languageCode),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                ref.read(localeControllerProvider.notifier).changeLocale(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(t.auth.logOut),
            onTap: () async {
              await ref.read(sessionControllerProvider.notifier).signOut();
              NavigationService.goAuth();
            },
          ),
        ],
      ),
    );
  }
}
