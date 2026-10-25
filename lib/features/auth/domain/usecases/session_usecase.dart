import '../repositories/auth_repository.dart';

class SessionUseCase {
  final AuthRepository repository;
  SessionUseCase(this.repository);
  Future<bool> hasSession() => repository.hasSession();
  Future<void> logout() => repository.logout();
}
