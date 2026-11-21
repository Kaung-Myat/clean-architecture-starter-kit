import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/env/env.dart';
import '../../../core/network/api_service.dart';
import '../data/datasources/demo_posts_remote_data_source.dart';
import '../data/datasources/posts_remote_data_source.dart';
import '../data/datasources/posts_remote_data_source_impl.dart';
import '../data/repositories/posts_repository_impl.dart';
import '../domain/repositories/posts_repository.dart';
import '../domain/usecases/create_post_usecase.dart';
import '../domain/usecases/get_post_usecase.dart';
import '../domain/usecases/get_posts_usecase.dart';

final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>((ref) {
  if (Env.demoMode) return DemoPostsRemoteDataSource();
  return PostsRemoteDataSourceImpl(apiService: ref.watch(apiServiceProvider));
});

final postsRepositoryProvider = Provider<IPostsRepository>((ref) {
  return PostsRepositoryImpl(
    remoteDataSource: ref.watch(postsRemoteDataSourceProvider),
  );
});

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  return GetPostsUseCase(repository: ref.watch(postsRepositoryProvider));
});

final getPostUseCaseProvider = Provider<GetPostUseCase>((ref) {
  return GetPostUseCase(repository: ref.watch(postsRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(repository: ref.watch(postsRepositoryProvider));
});
