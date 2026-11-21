import '../entities/paginated_posts.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  const GetPostsUseCase({required IPostsRepository repository})
      : _repository = repository;

  final IPostsRepository _repository;

  Future<PaginatedPosts> call({required int page, int perPage = 20}) =>
      _repository.getPosts(page: page, perPage: perPage);
}
