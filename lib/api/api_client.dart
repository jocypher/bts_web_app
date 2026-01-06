import 'package:dio/dio.dart';


class Api {
  Api._();

  static final Api instance = Api._();
  static final String baseUrl = 'https://bts-knowledge-based-system.onrender.com/';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 7),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  Future<Response> post(String endPoint,
      {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(endPoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> put(String endPoint,
      {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.put(endPoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> get(String endPoint) async {
    try {
      final response = await _dio.get(endPoint);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        return Exception(data['message'] ?? 'Server error');
      }

      if (data is String) {
        return Exception(data);
      }
    }

    return Exception("Network Error");
  }

}
