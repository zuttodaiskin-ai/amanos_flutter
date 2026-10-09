abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginMfaRequired extends LoginState {
  final int userId;
  final String message;
  final String? devCode;

  LoginMfaRequired({required this.userId, required this.message, this.devCode});
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}

class MfaVerificationLoading extends LoginState {}

class MfaVerificationSuccess extends LoginState {}

class MfaVerificationFailure extends LoginState {
  final String message;

  MfaVerificationFailure(this.message);
}
