import 'package:flutter/material.dart';

import '../../app/config/dimensions.dart';
import 'app_elevated_button.dart';

/// Full-screen offline UI. Shown when a request fails with `NetworkException`.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({
    super.key,
    required this.onRetry,
    this.message = 'No internet connection.',
  });

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64),
            const SizedBox(height: Dimens.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: Dimens.lg),
            AppElevatedButton(label: 'Retry', icon: Icons.refresh, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

/// Compact inline offline banner (e.g. pinned above a list).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.message = 'You are offline.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.errorContainer,
      padding: const EdgeInsets.symmetric(vertical: Dimens.sm, horizontal: Dimens.md),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 18, color: scheme.onErrorContainer),
          const SizedBox(width: Dimens.sm),
          Text(message, style: TextStyle(color: scheme.onErrorContainer)),
        ],
      ),
    );
  }
}
