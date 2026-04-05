import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class NetworkManager {
  NetworkManager(Dio dio)
      : _dio = dio
          ..options = BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: <String, dynamic>{
              Headers.contentTypeHeader: Headers.jsonContentType,
            },
          );

  final Dio _dio;

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(path);
      return _extractData(response);
    } on DioException catch (error) {
      throw _mapDioToException(error);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final Response<dynamic> response =
          await _dio.post<dynamic>(path, data: data);
      return _extractData(response);
    } on DioException catch (error) {
      throw _mapDioToException(error);
    }
  }

  Map<String, dynamic> _extractData(Response<dynamic> response) {
    final dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw const ServerException('Invalid response format from server');
  }

  Exception _mapDioToException(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown) {
      return NetworkException(error.message ?? 'No network connection');
    }

    final int? code = error.response?.statusCode;
    final dynamic payload = error.response?.data;
    final String fallback = 'Server error occurred';
    if (payload is Map<String, dynamic> && payload['message'] is String) {
      return ServerException(payload['message'] as String);
    }

    return ServerException(
      code == null ? fallback : 'Server error [$code]',
    );
  }
}
