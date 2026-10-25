import 'app_user.dart';

class UsersPage {
  final List<AppUser> users;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  const UsersPage({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });
}

class UsersPageResult {
  final UsersPage data;
  final bool isFromCache;
  final bool cacheWriteFailed;
  const UsersPageResult({
    required this.data,
    this.isFromCache = false,
    this.cacheWriteFailed = false,
  });
}
