import '../../domain/entities/login_result.dart';

class LoginResponseModel {
  final bool mfaRequired;
  final String? token;
  final int? userId;
  final String? name;
  final String? email;
  final String? role;
  final String? message;
  final String? devCode;

  const LoginResponseModel({
    required this.mfaRequired,
    this.token,
    this.userId,
    this.name,
    this.email,
    this.role,
    this.message,
    this.devCode,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return LoginResponseModel(
      mfaRequired: json['mfa_required'] ?? false,
      token: json['token'],
      userId: json['user_id'] ?? user?['id'],
      name: user?['name'],
      email: user?['email'],
      role: user?['role'],
      message: json['message'],
      devCode: json['dev_code']?.toString(),
    );
  }

  LoginResult toEntity() {
    return LoginResult(
      mfaRequired: mfaRequired,
      token: token,
      userId: userId,
      name: name,
      email: email,
      role: role,
      message: message,
      devCode: devCode,
    );
  }
}
