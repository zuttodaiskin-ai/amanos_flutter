import '../../../../core/network/api_exception.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/login_result.dart';

class LoginResponseModel {
  final String token;
  const LoginResponseModel({required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException(AppFailureCode.invalidLoginResponse);
    }
    return LoginResponseModel(token: token);
  }

  LoginResult toEntity() => LoginResult(token: token);
}
