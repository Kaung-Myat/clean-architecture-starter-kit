import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/localization/generated/translations.g.dart';
import '../../../../core/utils/extensions/async_value_ui.dart';
import '../providers/post_detail_controller.dart';
import '../routing/post_detail_extra.dart';

/// Deep-link sample: `/posts/:id?highlight=true` + optional [PostDetailExtra].
class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({
    super.key,
    required this.id,
    this.highlight = false,
    this.extra,
  });

  final String id;
  final bool highlight;
  final PostDetailExtra? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(postDetailControllerProvider(id));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(extra?.title ?? t.posts.detailTitle),
      ),
      body: Column(
        children: [
          if (highlight)
            MaterialBanner(
              content: Text(t.posts.highlightBanner),
              backgroundColor: scheme.secondaryContainer,
              actions: const [SizedBox.shrink()],
            ),
          Expanded(
            child: async.whenApp(
              onRetry: () =>
                  ref.read(postDetailControllerProvider(id).notifier).refresh(),
              offlineMessage: t.common.offline,
              errorMessage: t.common.somethingWentWrong,
              data: (post) => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.posts.idLabel(id: post.id),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(post.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
