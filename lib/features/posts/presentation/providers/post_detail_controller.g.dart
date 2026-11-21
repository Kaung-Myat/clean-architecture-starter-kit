// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostDetailController)
final postDetailControllerProvider = PostDetailControllerFamily._();

final class PostDetailControllerProvider
    extends $AsyncNotifierProvider<PostDetailController, PostEntity> {
  PostDetailControllerProvider._({
    required PostDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailControllerHash();

  @override
  String toString() {
    return r'postDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostDetailController create() => PostDetailController();

  @override
  bool operator ==(Object other) {
    return other is PostDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailControllerHash() =>
    r'bc3da065f6a6db52af1aa72ad127c083400e8879';

final class PostDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostDetailController,
          AsyncValue<PostEntity>,
          PostEntity,
          FutureOr<PostEntity>,
          String
        > {
  PostDetailControllerFamily._()
    : super(
        retry: null,
        name: r'postDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostDetailControllerProvider call(String id) =>
      PostDetailControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'postDetailControllerProvider';
}

abstract class _$PostDetailController extends $AsyncNotifier<PostEntity> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<PostEntity> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostEntity>, PostEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostEntity>, PostEntity>,
              AsyncValue<PostEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
