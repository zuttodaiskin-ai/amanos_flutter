import '../entities/users_page.dart';
import '../repositories/users_repository.dart';

class GetUsersUseCase {
  final UsersRepository repository;
  GetUsersUseCase(this.repository);
  Future<UsersPageResult> call({required int page, int perPage = 6}) =>
      repository.getUsers(page: page, perPage: perPage);
}
