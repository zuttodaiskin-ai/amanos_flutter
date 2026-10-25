import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage;
  const SecureStorage({this.storage = const FlutterSecureStorage()});

  Future<void> saveToken(String token) =>
      storage.write(key: 'reqres_token', value: token);
  Future<bool> hasSession() async =>
      (await storage.read(key: 'reqres_token'))?.isNotEmpty ?? false;
  Future<void> clearSession() => storage.delete(key: 'reqres_token');
}
