import 'dart:async';

import 'package:flutter/foundation.dart';

/// Debounces rapid calls (e.g. search-as-you-type). Remember to [dispose].
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 350)});

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
