import '../../../../core/network/api_routes.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/models/pagination_meta_mapper.dart';
import '../models/post_model.dart';
import 'posts_remote_data_source.dart';

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  PostsRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<PostsPageDto> getPosts({required int page, int perPage = 20}) async {
    final response = await _apiService.get(
      url: ApiRoutes.posts,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = response.data as Map<String, dynamic>;
    final rawItems = (data['data'] ?? data['items'] ?? []) as List<dynamic>;
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
    final metaJson = (data['meta'] ?? data['pagination'] ?? <String, dynamic>{})
        as Map<String, dynamic>;
    return PostsPageDto(
      items: items,
      meta: PaginationMetaMapper.fromJson(metaJson),
    );
  }

  @override
  Future<PostModel> getPost(String id) async {
    final response = await _apiService.get(url: '${ApiRoutes.posts}/$id');
    return PostModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
  }) async {
    final response = await _apiService.post(
      url: ApiRoutes.posts,
      data: {'title': title, 'body': body},
    );
    return PostModel.fromJson(response.data as Map<String, dynamic>);
  }
}
