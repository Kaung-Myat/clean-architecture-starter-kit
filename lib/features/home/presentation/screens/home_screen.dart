import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/localization/generated/translations.g.dart';
import '../../../../core/env/flavor_controller.dart';
import '../../../../core/utils/extensions/async_value_ui.dart';
import '../../../../core/utils/reconnect_refresh.dart';
import '../providers/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final homeAsync = ref.watch(homeControllerProvider);
    final flavor = ref.watch(flavorControllerProvider);

    ref.listenReconnectRefresh(
      () => ref.read(homeControllerProvider.notifier).refresh(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                flavor.name.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
      body: homeAsync.whenApp(
        onRetry: () => ref.read(homeControllerProvider.notifier).refresh(),
        offlineMessage: t.common.offline,
        errorMessage: t.common.somethingWentWrong,
        data: (message) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
