import 'package:flutter/material.dart';

/// Drives "load more" for paginated lists.
///
/// Mix into a `State`/`ConsumerState`, attach [scrollController] to the
/// scrollable, implement [onLoadMore], and call [ensureViewportFilled] after
/// the first frame so short first pages keep loading until the viewport fills.
mixin InfiniteScrollMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();

  /// Distance from the bottom (px) at which [onLoadMore] fires.
  double get loadMoreThreshold => 300;

  /// Implement to fetch the next page.
  Future<void> onLoadMore();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => ensureViewportFilled());
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - loadMoreThreshold) {
      onLoadMore();
    }
  }

  /// If the content doesn't fill the viewport, trigger another page.
  void ensureViewportFilled() {
    if (!mounted || !scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.maxScrollExtent <= 0 && position.hasContentDimensions) {
      onLoadMore();
    }
  }
}
