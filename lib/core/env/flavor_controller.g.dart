// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flavor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runtime flavor override (dev/uat toggles). Prod builds should ignore UI switches.

@ProviderFor(FlavorController)
final flavorControllerProvider = FlavorControllerProvider._();

/// Runtime flavor override (dev/uat toggles). Prod builds should ignore UI switches.
final class FlavorControllerProvider
    extends $NotifierProvider<FlavorController, AppFlavor> {
  /// Runtime flavor override (dev/uat toggles). Prod builds should ignore UI switches.
  FlavorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorControllerHash();

  @$internal
  @override
  FlavorController create() => FlavorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppFlavor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppFlavor>(value),
    );
  }
}

String _$flavorControllerHash() => r'20196f26824b7eab0e57d0478a1b73e3c8347079';

/// Runtime flavor override (dev/uat toggles). Prod builds should ignore UI switches.

abstract class _$FlavorController extends $Notifier<AppFlavor> {
  AppFlavor build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppFlavor, AppFlavor>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppFlavor, AppFlavor>,
              AppFlavor,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
