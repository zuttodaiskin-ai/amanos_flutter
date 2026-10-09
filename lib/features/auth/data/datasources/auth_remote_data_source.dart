import 'package:dio/dio.dart';

import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final data = Map<String, dynamic>.from(response.data);

      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData is Map) {
        final data = Map<String, dynamic>.from(responseData);

        final message = data['error'] ?? data['message'];

        if (message != null) {
          throw Exception(message.toString());
        }
      }

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('تعذر الاتصال بالخادم');
      }

      throw Exception('حدث خطأ أثناء تسجيل الدخول');
    }
  }

  Future<LoginResponseModel> verifyMfa({
    required int userId,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        '/login/verify-mfa',
        data: {'user_id': userId, 'code': code},
      );

      final data = Map<String, dynamic>.from(response.data);

      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData is Map) {
        final data = Map<String, dynamic>.from(responseData);

        final message = data['error'] ?? data['message'];

        if (message != null) {
          throw Exception(message.toString());
        }
      }

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('تعذر الاتصال بالخادم');
      }

      throw Exception('حدث خطأ أثناء التحقق من الرمز');
    }
  }
}
