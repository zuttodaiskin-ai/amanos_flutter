import 'package:dio/dio.dart';

import '../errors/app_failure.dart';

class ApiException extends AppFailure {
  const ApiException(super.code, {super.detail});

  factory ApiException.fromDio(DioException error) {
    if (isConnectionFailure(error)) {
      return const ApiException(AppFailureCode.connection);
    }
    if (error.response?.statusCode == 403) {
      return const ApiException(AppFailureCode.forbidden);
    }
    if (error.response?.statusCode == 429) {
      return const ApiException(AppFailureCode.rateLimited);
    }
    final data = error.response?.data;
    final detail = data is Map ? data['error'] ?? data['message'] : null;
    final code = switch (detail) {
      'user not found' => AppFailureCode.userNotFound,
      'Missing email or username' => AppFailureCode.missingEmail,
      'Missing password' => AppFailureCode.missingPassword,
      _ when error.response?.statusCode == 401 => AppFailureCode.unauthorized,
      _ => AppFailureCode.requestFailed,
    };
    return ApiException(code, detail: detail is String ? detail : null);
  }

  static bool isConnectionFailure(DioException error) =>
      error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout;
}
