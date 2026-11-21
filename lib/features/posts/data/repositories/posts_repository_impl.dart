import '../../domain/entities/paginated_posts.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_data_source.dart';

class PostsRepositoryImpl implements IPostsRepository {
  const PostsRepositoryImpl({required PostsRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final PostsRemoteDataSource _remote;

  @override
  Future<PaginatedPosts> getPosts({required int page, int perPage = 20}) async {
    final dto = await _remote.getPosts(page: page, perPage: perPage);
    return PaginatedPosts(
      items: dto.items.map((m) => m.toEntity()).toList(),
      meta: dto.meta,
    );
  }

  @override
  Future<PostEntity> getPost(String id) async {
    final model = await _remote.getPost(id);
    return model.toEntity();
  }

  @override
  Future<PostEntity> createPost({
    required String title,
    required String body,
  }) async {
    final model = await _remote.createPost(title: title, body: body);
    return model.toEntity();
  }
}
