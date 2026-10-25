import '../../domain/entities/users_page.dart';
import '../../../../core/errors/app_failure.dart';

class UsersState {
  final UsersPageResult? result;
  final bool isLoading;
  final AppFailure? error;
  final int requestedPage;
  const UsersState({
    this.result,
    this.isLoading = false,
    this.error,
    this.requestedPage = 1,
  });
}
