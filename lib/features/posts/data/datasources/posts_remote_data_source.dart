import '../models/post_model.dart';
import '../../../../core/domain/pagination_meta.dart';

class PostsPageDto {
  const PostsPageDto({required this.items, required this.meta});

  final List<PostModel> items;
  final PaginationMeta meta;
}

abstract interface class PostsRemoteDataSource {
  Future<PostsPageDto> getPosts({required int page, int perPage = 20});

  Future<PostModel> getPost(String id);

  Future<PostModel> createPost({required String title, required String body});
}
