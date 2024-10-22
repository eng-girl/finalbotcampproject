import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = 'http://localhost:3000/api/v1/';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> get(String path) {
    return _dio.get(path);
  }

// Additional methods for PUT, DELETE, etc. can be added here if needed
}
