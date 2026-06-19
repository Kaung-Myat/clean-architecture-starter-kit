import 'package:flutter/material.dart';

import '../../app/config/dimensions.dart';
import 'app_elevated_button.dart';

/// Standard full-screen error UI (5xx / unexpected). Always pass an [onRetry].
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.onRetry,
    this.message = 'Something went wrong.',
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
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
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
