import 'package:dio/dio.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    final options = BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );
    _dio = Dio(options);
  }
  Dio get dio => _dio;
}
