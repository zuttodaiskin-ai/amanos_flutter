import 'package:hive/hive.dart';

class LocaleStorage {
  static const boxName = 'app_settings';
  static const _localeKey = 'locale';
  final Box<String> box;

  LocaleStorage(this.box);

  String? get languageCode => box.get(_localeKey);

  Future<void> saveLanguageCode(String code) => box.put(_localeKey, code);
}
