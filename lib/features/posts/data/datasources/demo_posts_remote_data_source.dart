import '../../../../core/domain/pagination_meta.dart';
import '../../../../core/network/exceptions/api_exception.dart';
import '../models/post_model.dart';
import 'posts_remote_data_source.dart';

/// Offline demo posts — paginated list + validation errors for create.
class DemoPostsRemoteDataSource implements PostsRemoteDataSource {
  static const _total = 55;

  @override
  Future<PostsPageDto> getPosts({required int page, int perPage = 20}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final totalPages = (_total / perPage).ceil().clamp(1, 999);
    final safePage = page.clamp(1, totalPages);
    final start = (safePage - 1) * perPage;
    final end = (start + perPage).clamp(0, _total);

    final items = List.generate(
      end - start,
      (i) {
        final n = start + i + 1;
        return PostModel(
          id: '$n',
          title: 'Demo post #$n',
          body: 'Body for demo post #$n. Replace with a real API in prod.',
        );
      },
    );

    return PostsPageDto(
      items: items,
      meta: PaginationMeta(
        currentPage: safePage,
        totalPages: totalPages,
        totalRows: _total,
      ),
    );
  }

  @override
  Future<PostModel> getPost(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final n = int.tryParse(id) ?? 0;
    if (n < 1 || n > _total) {
      throw const ApiException(statusCode: 404, message: 'Post not found.');
    }
    return PostModel(
      id: id,
      title: 'Demo post #$id',
      body: 'Body for demo post #$id. Deep-link / route-extra sample.',
    );
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    // Simulate server-side field errors for the form convention sample.
    final errors = <String, List<String>>{};
    if (title.trim().length < 3) {
      errors['title'] = ['Title must be at least 3 characters.'];
    }
    if (title.trim().toLowerCase() == 'forbidden') {
      errors['title'] = ['This title is not allowed.'];
    }
    if (body.trim().length < 10) {
      errors['body'] = ['Body must be at least 10 characters.'];
    }
    if (errors.isNotEmpty) {
      throw ApiException(
        statusCode: 422,
        message: 'Validation failed.',
        errors: errors,
      );
    }

    return PostModel(
      id: '${_total + 1}',
      title: title.trim(),
      body: body.trim(),
    );
  }
}
