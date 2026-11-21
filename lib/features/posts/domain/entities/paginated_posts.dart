import 'package:equatable/equatable.dart';

import '../../../../core/domain/pagination_meta.dart';
import 'post_entity.dart';

class PaginatedPosts extends Equatable {
  const PaginatedPosts({
    required this.items,
    required this.meta,
  });

  final List<PostEntity> items;
  final PaginationMeta meta;

  @override
  List<Object?> get props => [items, meta];
}
