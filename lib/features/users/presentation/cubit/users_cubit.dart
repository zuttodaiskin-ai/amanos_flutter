import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsersUseCase getUsersUseCase;
  UsersCubit(this.getUsersUseCase) : super(const UsersState());

  Future<void> loadPage(int page) async {
    if (state.isLoading || page < 1) return;
    final previous = state.result;
    emit(UsersState(result: previous, isLoading: true, requestedPage: page));
    try {
      final result = await getUsersUseCase(page: page);
      if (!isClosed) emit(UsersState(result: result, requestedPage: page));
    } catch (error) {
      if (!isClosed) {
        emit(
          UsersState(
            result: previous,
            requestedPage: page,
            error: AppFailure.from(error),
          ),
        );
      }
    }
  }

  Future<void> refresh() =>
      loadPage(state.result?.data.page ?? state.requestedPage);
}
