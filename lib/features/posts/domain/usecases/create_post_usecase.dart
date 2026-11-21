import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class CreatePostUseCase {
  const CreatePostUseCase({required IPostsRepository repository})
      : _repository = repository;

  final IPostsRepository _repository;

  Future<PostEntity> call({required String title, required String body}) =>
      _repository.createPost(title: title, body: body);
}
