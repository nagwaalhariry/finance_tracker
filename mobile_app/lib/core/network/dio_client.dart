import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    return dio;
  }
}
