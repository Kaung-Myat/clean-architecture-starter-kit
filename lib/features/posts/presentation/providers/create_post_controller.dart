import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/posts_providers.dart';
import '../../domain/entities/post_entity.dart';

part 'create_post_controller.g.dart';

@riverpod
class CreatePostController extends _$CreatePostController {
  @override
  FutureOr<PostEntity?> build() => null;

  Future<PostEntity?> submit({
    required String title,
    required String body,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(createPostUseCaseProvider)(title: title, body: body),
    );
    return state.asData?.value;
  }

  void reset() => state = const AsyncData(null);
}
