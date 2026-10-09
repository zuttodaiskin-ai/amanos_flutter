import '../../domain/entities/login_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );

    return response.toEntity();
  }

  @override
  Future<LoginResult> verifyMfa({
    required int userId,
    required String code,
  }) async {
    final response = await remoteDataSource.verifyMfa(
      userId: userId,
      code: code,
    );

    return response.toEntity();
  }
}
