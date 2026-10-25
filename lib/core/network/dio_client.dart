import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({String apiKey = const String.fromEnvironment('REQRES_API_KEY')})
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://reqres.in/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            if (apiKey.isNotEmpty) 'x-api-key': apiKey,
          },
        ),
      );
}
