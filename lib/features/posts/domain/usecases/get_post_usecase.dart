import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostUseCase {
  const GetPostUseCase({required IPostsRepository repository})
      : _repository = repository;

  final IPostsRepository _repository;

  Future<PostEntity> call(String id) => _repository.getPost(id);
}
