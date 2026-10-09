import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

class VerifyMfaUseCase {
  final AuthRepository repository;

  VerifyMfaUseCase(this.repository);

  Future<LoginResult> call({required int userId, required String code}) {
    return repository.verifyMfa(userId: userId, code: code);
  }
}
