import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/localization/generated/translations.g.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/extensions/async_value_ui.dart';
import '../../../../core/utils/infinite_scroll_mixin.dart';
import '../../../../core/utils/reconnect_refresh.dart';
import '../providers/posts_list_controller.dart';
import '../routing/post_detail_extra.dart';

class PostsListScreen extends ConsumerStatefulWidget {
  const PostsListScreen({super.key});

  @override
  ConsumerState<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends ConsumerState<PostsListScreen>
    with InfiniteScrollMixin {
  @override
  Future<void> onLoadMore() {
    return ref.read(postsListControllerProvider.notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(postsListControllerProvider);

    ref.listenReconnectRefresh(
      () => ref.read(postsListControllerProvider.notifier).refresh(),
    );

    // Keep loading pages until the viewport is filled.
    ref.listen(postsListControllerProvider, (prev, next) {
      final prevLen = prev?.asData?.value.items.length ?? 0;
      final nextLen = next.asData?.value.items.length ?? 0;
      if (nextLen > prevLen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ensureViewportFilled();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(t.posts.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.createPost),
        child: const Icon(Icons.add),
      ),
      body: async.whenApp(
        onRetry: () => ref.read(postsListControllerProvider.notifier).refresh(),
        offlineMessage: t.common.offline,
        errorMessage: t.common.somethingWentWrong,
        data: (state) {
          if (state.items.isEmpty) {
            return Center(child: Text(t.posts.empty));
          }
          return ListView.separated(
            controller: scrollController,
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final post = state.items[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  context.pushNamed(
                    RouteNames.postDetail,
                    pathParameters: {'id': post.id},
                    queryParameters: {'highlight': 'true'},
                    extra: PostDetailExtra(title: post.title),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
