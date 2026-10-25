import '../../domain/entities/users_page.dart';
import 'user_model.dart';

class UsersPageModel {
  final List<UserModel> users;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  const UsersPageModel({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });
  factory UsersPageModel.fromJson(Map<String, dynamic> json) => UsersPageModel(
    users: (json['data'] as List)
        .map(
          (item) => UserModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
    page: json['page'] as int,
    perPage: json['per_page'] as int,
    total: json['total'] as int,
    totalPages: json['total_pages'] as int,
  );
  Map<String, dynamic> toJson() => {
    'data': users.map((user) => user.toJson()).toList(),
    'page': page,
    'per_page': perPage,
    'total': total,
    'total_pages': totalPages,
  };
  UsersPage toEntity() => UsersPage(
    users: List.unmodifiable(users),
    page: page,
    perPage: perPage,
    total: total,
    totalPages: totalPages,
  );
}
