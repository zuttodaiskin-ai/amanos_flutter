import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/verify_mfa_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final VerifyMfaUseCase verifyMfaUseCase;

  LoginCubit({required this.loginUseCase, required this.verifyMfaUseCase})
    : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure('الرجاء إدخال البريد الإلكتروني وكلمة المرور'));
      return;
    }

    emit(LoginLoading());

    try {
      final result = await loginUseCase(email: email, password: password);

      if (result.mfaRequired) {
        emit(
          LoginMfaRequired(
            userId: result.userId!,
            message: result.message ?? 'مطلوب رمز التحقق',
            devCode: result.devCode,
          ),
        );
        return;
      }

      emit(LoginSuccess());
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');

      emit(LoginFailure(message));
    }
  }

  Future<void> verifyMfa({required int userId, required String code}) async {
    if (code.isEmpty) {
      emit(MfaVerificationFailure('الرجاء إدخال رمز التحقق'));
      return;
    }

    emit(MfaVerificationLoading());

    try {
      await verifyMfaUseCase(userId: userId, code: code);

      emit(MfaVerificationSuccess());
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');

      emit(MfaVerificationFailure(message));
    }
  }
}
