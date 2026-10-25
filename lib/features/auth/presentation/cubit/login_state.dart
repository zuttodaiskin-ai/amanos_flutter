import '../../../../core/errors/app_failure.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginCheckingSession extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final AppFailure failure;
  LoginFailure(this.failure);

  String get message => failure.message;
}
