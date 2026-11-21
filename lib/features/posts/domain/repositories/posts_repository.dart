import '../entities/paginated_posts.dart';
import '../entities/post_entity.dart';

abstract interface class IPostsRepository {
  Future<PaginatedPosts> getPosts({required int page, int perPage = 20});

  Future<PostEntity> getPost(String id);

  Future<PostEntity> createPost({required String title, required String body});
}
