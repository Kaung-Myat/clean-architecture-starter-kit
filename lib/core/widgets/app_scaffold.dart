import 'package:flutter/material.dart';

/// Thin [Scaffold] wrapper that standardises padding and safe-area handling.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.all(16),
    this.safeArea = true,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsets padding;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: body);
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: safeArea ? SafeArea(child: content) : content,
    );
  }
}
