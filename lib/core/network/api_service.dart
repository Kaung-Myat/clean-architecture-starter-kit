import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_client.dart';
import 'exceptions/api_exception.dart';
import 'exceptions/network_exception.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(dio: ref.watch(dioClientProvider));
});

/// The single seam the data layer talks to. Every [DioException] is converted
/// through [_mapDioError] into a typed [ApiException] / [NetworkException].
class ApiService {
  const ApiService({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<Response<dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _request(() => _dio.get(url, queryParameters: queryParameters, options: options));

  Future<Response<dynamic>> post({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _request(() => _dio.post(url, data: data, queryParameters: queryParameters, options: options));

  Future<Response<dynamic>> put({
    required String url,
    Object? data,
    Options? options,
  }) =>
      _request(() => _dio.put(url, data: data, options: options));

  Future<Response<dynamic>> patch({
    required String url,
    Object? data,
    Options? options,
  }) =>
      _request(() => _dio.patch(url, data: data, options: options));

  Future<Response<dynamic>> delete({
    required String url,
    Object? data,
    Options? options,
  }) =>
      _request(() => _dio.delete(url, data: data, options: options));

  Future<Response<dynamic>> uploadFile({
    required String url,
    required String filePath,
    String field = 'file',
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      field: await MultipartFile.fromFile(filePath),
    });
    return _request(() => _dio.post(url, data: formData, options: options));
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() send,
  ) async {
    try {
      return await send();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Object _mapDioError(DioException e) {
    final response = e.response;
    if (response != null) {
      return ApiException.fromResponse(response);
    }
    return NetworkException.fromDio(e);
  }
}
