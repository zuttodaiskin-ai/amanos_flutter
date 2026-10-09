import '../entities/login_result.dart';

abstract class AuthRepository {
  Future<LoginResult> login({required String email, required String password});

  Future<LoginResult> verifyMfa({required int userId, required String code});
}
