import 'package:dio/dio.dart';
import '../models/users_page_model.dart';

class UsersRemoteDataSource {
  final Dio dio;
  UsersRemoteDataSource(this.dio);
  Future<UsersPageModel> getUsers({
    required int page,
    required int perPage,
  }) async {
    final response = await dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return UsersPageModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
