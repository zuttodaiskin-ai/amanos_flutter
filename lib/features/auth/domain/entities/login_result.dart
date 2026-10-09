class LoginResult {
  final bool mfaRequired;
  final String? token;
  final int? userId;
  final String? name;
  final String? email;
  final String? role;
  final String? message;
  final String? devCode;

  const LoginResult({
    required this.mfaRequired,
    this.token,
    this.userId,
    this.name,
    this.email,
    this.role,
    this.message,
    this.devCode,
  });
}
