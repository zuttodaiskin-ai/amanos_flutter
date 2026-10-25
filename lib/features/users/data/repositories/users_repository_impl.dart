import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/users_page.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_local_data_source.dart';
import '../datasources/users_remote_data_source.dart';
import '../models/users_page_model.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remote;
  final UsersLocalDataSource local;
  UsersRepositoryImpl({required this.remote, required this.local});

  @override
  Future<UsersPageResult> getUsers({required int page, int perPage = 6}) async {
    final UsersPageModel response;
    try {
      response = await remote.getUsers(page: page, perPage: perPage);
    } on DioException catch (error) {
      // An authentication/rate-limit/server error is not an offline result.
      if (!ApiException.isConnectionFailure(error)) {
        throw ApiException.fromDio(error);
      }
      final UsersPageModel? cached;
      try {
        cached = local.getPage(page: page, perPage: perPage);
      } catch (_) {
        throw const ApiException(AppFailureCode.cacheReadFailed);
      }
      if (cached == null) {
        throw const ApiException(AppFailureCode.uncachedPage);
      }
      return UsersPageResult(data: cached.toEntity(), isFromCache: true);
    }
    try {
      await local.savePage(response);
    } catch (_) {
      return UsersPageResult(data: response.toEntity(), cacheWriteFailed: true);
    }
    return UsersPageResult(data: response.toEntity());
  }
}
