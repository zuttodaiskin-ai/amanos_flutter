import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/verify_mfa_usecase.dart';

import 'features/auth/presentation/cubit/login_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  final dioClient = DioClient();

  final authRemoteDataSource = AuthRemoteDataSource(dioClient.dio);

  final authRepository = AuthRepositoryImpl(authRemoteDataSource);

  final loginUseCase = LoginUseCase(authRepository);

  final verifyMfaUseCase = VerifyMfaUseCase(authRepository);

  runApp(
    AmanosApp(loginUseCase: loginUseCase, verifyMfaUseCase: verifyMfaUseCase),
  );
}

class AmanosApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final VerifyMfaUseCase verifyMfaUseCase;

  const AmanosApp({
    super.key,
    required this.loginUseCase,
    required this.verifyMfaUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amanos',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => LoginCubit(
          loginUseCase: loginUseCase,
          verifyMfaUseCase: verifyMfaUseCase,
        ),
        child: const LoginPage(),
      ),
    );
  }
}
