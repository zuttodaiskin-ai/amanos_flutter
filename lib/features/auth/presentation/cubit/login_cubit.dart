import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/session_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SessionUseCase sessionUseCase;
  LoginCubit({required this.loginUseCase, required this.sessionUseCase})
    : super(LoginCheckingSession());

  Future<void> restoreSession() async {
    try {
      final authenticated = await sessionUseCase.hasSession();
      if (!isClosed) emit(authenticated ? LoginSuccess() : LoginInitial());
    } catch (_) {
      if (!isClosed) {
        emit(LoginFailure(const AppFailure(AppFailureCode.sessionReadFailed)));
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (state is LoginLoading) return;
    email = email.trim();
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure(const AppFailure(AppFailureCode.credentialsRequired)));
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      emit(LoginFailure(const AppFailure(AppFailureCode.invalidEmail)));
      return;
    }
    emit(LoginLoading());
    try {
      await loginUseCase(email: email, password: password);
      if (!isClosed) emit(LoginSuccess());
    } catch (error) {
      if (!isClosed) {
        emit(LoginFailure(AppFailure.from(error)));
      }
    }
  }

  Future<void> logout() async {
    await sessionUseCase.logout();
    if (!isClosed) emit(LoginInitial());
  }
}
