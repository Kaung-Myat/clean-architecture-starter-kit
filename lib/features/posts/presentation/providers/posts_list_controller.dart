import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/pagination_meta.dart';
import '../../di/posts_providers.dart';
import '../../domain/entities/post_entity.dart';

part 'posts_list_controller.g.dart';

class PostsListState {
  const PostsListState({
    this.items = const [],
    this.meta = PaginationMeta.empty,
    this.isLoadingMore = false,
  });

  final List<PostEntity> items;
  final PaginationMeta meta;
  final bool isLoadingMore;

  bool get hasMore => meta.hasNextPage;

  PostsListState copyWith({
    List<PostEntity>? items,
    PaginationMeta? meta,
    bool? isLoadingMore,
  }) {
    return PostsListState(
      items: items ?? this.items,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@riverpod
class PostsListController extends _$PostsListController {
  @override
  Future<PostsListState> build() async {
    final page = await ref.read(getPostsUseCaseProvider)(page: 1);
    return PostsListState(items: page.items, meta: page.meta);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.meta.currentPage + 1;
      final page = await ref.read(getPostsUseCaseProvider)(page: nextPage);
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          meta: page.meta,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
