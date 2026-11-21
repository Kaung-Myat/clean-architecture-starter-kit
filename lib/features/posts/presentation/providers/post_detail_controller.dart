import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/posts_providers.dart';
import '../../domain/entities/post_entity.dart';

part 'post_detail_controller.g.dart';

@riverpod
class PostDetailController extends _$PostDetailController {
  @override
  Future<PostEntity> build(String id) {
    return ref.read(getPostUseCaseProvider)(id);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(id));
  }
}
