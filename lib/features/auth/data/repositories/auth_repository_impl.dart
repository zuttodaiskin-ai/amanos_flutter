import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/login_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;
  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );
    await secureStorage.saveToken(response.token);
    return response.toEntity();
  }

  @override
  Future<bool> hasSession() => secureStorage.hasSession();
  @override
  Future<void> logout() => secureStorage.clearSession();
}
