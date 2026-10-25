import '../entities/users_page.dart';

abstract class UsersRepository {
  Future<UsersPageResult> getUsers({required int page, int perPage = 6});
}
