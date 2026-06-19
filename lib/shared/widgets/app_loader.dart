import 'package:flutter/material.dart';

/// Centered progress indicator used for full-screen loading states.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 28, this.strokeWidth = 3});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(strokeWidth: strokeWidth),
      ),
    );
  }
}
