// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostsListController)
final postsListControllerProvider = PostsListControllerProvider._();

final class PostsListControllerProvider
    extends $AsyncNotifierProvider<PostsListController, PostsListState> {
  PostsListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsListControllerHash();

  @$internal
  @override
  PostsListController create() => PostsListController();
}

String _$postsListControllerHash() =>
    r'0a0582e40362934deebf793e095ad261057190e3';

abstract class _$PostsListController extends $AsyncNotifier<PostsListState> {
  FutureOr<PostsListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostsListState>, PostsListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostsListState>, PostsListState>,
              AsyncValue<PostsListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
