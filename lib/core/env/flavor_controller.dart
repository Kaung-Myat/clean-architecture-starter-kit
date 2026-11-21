import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_flavor.dart';
import 'env.dart';

part 'flavor_controller.g.dart';

/// Runtime flavor override (dev/uat toggles). Prod builds should ignore UI switches.
@riverpod
class FlavorController extends _$FlavorController {
  @override
  AppFlavor build() {
    Env.useFlavor(Env.flavor);
    return Env.flavor;
  }

  void setFlavor(AppFlavor flavor) {
    Env.useFlavor(flavor);
    state = flavor;
  }
}
