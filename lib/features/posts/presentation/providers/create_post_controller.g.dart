// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePostController)
final createPostControllerProvider = CreatePostControllerProvider._();

final class CreatePostControllerProvider
    extends $AsyncNotifierProvider<CreatePostController, PostEntity?> {
  CreatePostControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostControllerHash();

  @$internal
  @override
  CreatePostController create() => CreatePostController();
}

String _$createPostControllerHash() =>
    r'cb36292887c9082d2fbfc942f5e51504e9c5b785';

abstract class _$CreatePostController extends $AsyncNotifier<PostEntity?> {
  FutureOr<PostEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostEntity?>, PostEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostEntity?>, PostEntity?>,
              AsyncValue<PostEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
