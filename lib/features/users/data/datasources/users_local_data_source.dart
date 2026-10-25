import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/users_page_model.dart';

class UsersLocalDataSource {
  final Box<String> box;
  UsersLocalDataSource(this.box);
  String _key(int page, int perPage) => 'users_v1_${perPage}_$page';

  Future<void> savePage(UsersPageModel page) =>
      box.put(_key(page.page, page.perPage), jsonEncode(page.toJson()));

  UsersPageModel? getPage({required int page, required int perPage}) {
    final json = box.get(_key(page, perPage));
    if (json == null) return null;
    return UsersPageModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }
}
