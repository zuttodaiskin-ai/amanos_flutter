import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings/locale_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  final LocaleStorage storage;

  LocaleCubit(this.storage)
    : super(Locale(storage.languageCode == 'en' ? 'en' : 'ar'));

  Future<void> setLocale(Locale locale) async {
    if (locale == state || !['ar', 'en'].contains(locale.languageCode)) return;
    // Persist before emitting so an unsuccessful write leaves the selection intact.
    await storage.saveLanguageCode(locale.languageCode);
    if (!isClosed) emit(Locale(locale.languageCode));
  }
}
