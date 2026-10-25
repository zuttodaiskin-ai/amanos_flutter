import 'dart:io';

import 'package:amanos_flutter/app.dart';
import 'package:amanos_flutter/core/di/service_locator.dart';
import 'package:amanos_flutter/core/errors/app_failure.dart';
import 'package:amanos_flutter/core/localization/locale_cubit.dart';
import 'package:amanos_flutter/core/localization/localized_failure.dart';
import 'package:amanos_flutter/core/network/api_exception.dart';
import 'package:amanos_flutter/core/network/dio_client.dart';
import 'package:amanos_flutter/core/settings/locale_storage.dart';
import 'package:amanos_flutter/core/storage/secure_storage.dart';
import 'package:amanos_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:amanos_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:amanos_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:amanos_flutter/features/auth/domain/usecases/session_usecase.dart';
import 'package:amanos_flutter/features/auth/presentation/cubit/login_cubit.dart';
import 'package:amanos_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:amanos_flutter/features/users/data/datasources/users_local_data_source.dart';
import 'package:amanos_flutter/features/users/data/datasources/users_remote_data_source.dart';
import 'package:amanos_flutter/features/users/data/models/users_page_model.dart';
import 'package:amanos_flutter/features/users/domain/repositories/users_repository.dart';
import 'package:amanos_flutter/features/users/domain/usecases/get_users_usecase.dart';
import 'package:amanos_flutter/features/users/presentation/cubit/users_cubit.dart';
import 'package:amanos_flutter/features/users/presentation/pages/users_page.dart';
import 'package:amanos_flutter/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'reqres_flow_test.dart'
    show MemorySession, StubAdapter, jsonResponse, usersResponse;

// Widget tests keep storage in memory to avoid mixing filesystem futures with
// Flutter's fake clock. Unit tests below verify real Hive persistence separately.
class MemoryLocaleStorage extends LocaleStorage {
  String? selected;
  MemoryLocaleStorage(super.box);

  @override
  String? get languageCode => selected;

  @override
  Future<void> saveLanguageCode(String code) async => selected = code;
}

class MemoryUsersStorage extends UsersLocalDataSource {
  final pages = <String, UsersPageModel>{};
  MemoryUsersStorage(super.box);

  @override
  Future<void> savePage(UsersPageModel page) async {
    pages['${page.perPage}_${page.page}'] = page;
  }

  @override
  UsersPageModel? getPage({required int page, required int perPage}) =>
      pages['${perPage}_$page'];
}

Future<void> waitFor(WidgetTester tester, Finder finder) async {
  // Hive and Dio use real asynchronous I/O alongside the widget test clock.
  for (var i = 0; i < 100; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  expect(finder, findsWidgets);
}

Future<void> chooseLanguage(WidgetTester tester, String language) async {
  await tester.tap(find.byIcon(Icons.language));
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    await tester.tap(find.text(language).last);
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });
  await tester.pumpAndSettle();
}

void main() {
  late Directory temp;
  late MemorySession session;
  late bool offline;
  late int userRequests;
  late List<Map<String, dynamic>> loginRequests;
  MemoryLocaleStorage? widgetSettings;
  MemoryUsersStorage? widgetCache;

  Future<void> registerWidgetStorage() async {
    await getIt.unregister<LocaleStorage>();
    await getIt.unregister<UsersLocalDataSource>();
    getIt.registerSingleton<LocaleStorage>(widgetSettings!);
    getIt.registerSingleton<UsersLocalDataSource>(widgetCache!);
  }

  Future<void> useWidgetStorage() async {
    widgetSettings = MemoryLocaleStorage(getIt<LocaleStorage>().box);
    widgetCache = MemoryUsersStorage(getIt<UsersLocalDataSource>().box);
    await registerWidgetStorage();
  }

  Future<void> configure() async {
    await setupDependencies();
    await getIt.unregister<SecureStorage>();
    getIt.registerSingleton<SecureStorage>(session);
    if (widgetSettings != null) await registerWidgetStorage();
    getIt<Dio>().httpClientAdapter = StubAdapter((options) async {
      if (offline) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      }
      if (options.path == '/login') {
        loginRequests.add(Map<String, dynamic>.from(options.data as Map));
        return jsonResponse({'token': 'test-session'});
      }
      expect(options.path, '/users');
      userRequests++;
      return jsonResponse(
        usersResponse(options.queryParameters['page'] as int),
      );
    });
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('amanos_locale_test_');
    Hive.init(temp.path);
    session = MemorySession();
    offline = false;
    userRequests = 0;
    loginRequests = [];
    widgetSettings = null;
    widgetCache = null;
    await configure();
  });

  tearDown(() async {
    await getIt.reset();
    await Hive.close();
    await temp.delete(recursive: true);
  });

  test('DI shares services and use cases but creates fresh cubits', () async {
    expect(getIt<Dio>(), same(getIt<DioClient>().dio));
    expect(getIt<AuthRemoteDataSource>().dio, same(getIt<Dio>()));
    expect(getIt<UsersRemoteDataSource>().dio, same(getIt<Dio>()));
    expect(getIt<AuthRepository>(), same(getIt<AuthRepository>()));
    expect(getIt<UsersRepository>(), same(getIt<UsersRepository>()));
    expect(getIt<LoginUseCase>(), same(getIt<LoginUseCase>()));
    expect(getIt<SessionUseCase>(), same(getIt<SessionUseCase>()));
    expect(getIt<GetUsersUseCase>(), same(getIt<GetUsersUseCase>()));
    final firstLogin = getIt<LoginCubit>();
    final secondLogin = getIt<LoginCubit>();
    final firstUsers = getIt<UsersCubit>();
    final secondUsers = getIt<UsersCubit>();
    final firstLocale = getIt<LocaleCubit>();
    final secondLocale = getIt<LocaleCubit>();
    expect(firstLogin, isNot(same(secondLogin)));
    expect(firstUsers, isNot(same(secondUsers)));
    expect(firstLocale, isNot(same(secondLocale)));
    await firstLogin.close();
    await secondLogin.close();
    await firstUsers.close();
    await secondUsers.close();
    await firstLocale.close();
    await secondLocale.close();
  });

  test('locale survives box reopen without touching the users cache', () async {
    final locale = getIt<LocaleCubit>();
    expect(locale.state, const Locale('ar'));
    final cache = getIt<UsersLocalDataSource>().box;
    final settings = getIt<LocaleStorage>().box;
    expect(cache.name, usersBoxName);
    expect(settings.name, LocaleStorage.boxName);
    await cache.put('sentinel', 'existing cache');
    await locale.setLocale(const Locale('en'));
    await locale.setLocale(const Locale('fr'));
    expect(locale.state, const Locale('en'));
    expect(cache.keys, ['sentinel']);
    await locale.close();
    await getIt.reset();
    await configure();
    final restored = getIt<LocaleCubit>();
    expect(restored.state, const Locale('en'));
    expect(getIt<UsersLocalDataSource>().box.get('sentinel'), 'existing cache');
    await restored.setLocale(const Locale('ar'));
    await restored.close();
  });

  test('failed settings writes preserve the current locale', () async {
    final locale = getIt<LocaleCubit>();
    await getIt<LocaleStorage>().box.close();
    await expectLater(
      locale.setLocale(const Locale('en')),
      throwsA(isA<HiveError>()),
    );
    expect(locale.state, const Locale('ar'));
    await locale.close();
  });

  test('every failure has a message in both generated locales', () async {
    final ar = await AppLocalizations.delegate.load(const Locale('ar'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    for (final code in AppFailureCode.values) {
      final failure = AppFailure(code);
      expect(failure.localize(ar), isNotEmpty);
      expect(failure.localize(en), isNotEmpty);
      expect(failure.localize(ar), isNot(failure.localize(en)));
    }
    final apiError = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          data: {'error': 'user not found'},
        ),
      ),
    );
    expect(apiError.code, AppFailureCode.userNotFound);
    expect(apiError.message, 'user not found');
    expect(apiError.localize(ar), ar.userNotFound);
    expect(apiError.localize(en), en.userNotFound);
  });

  for (final code in ['ar', 'en']) {
    testWidgets('login, users, pagination, offline and logout in $code', (
      tester,
    ) async {
      await useWidgetStorage();
      tester.view.physicalSize = const Size(1100, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final l10n = await AppLocalizations.delegate.load(Locale(code));
      if (code == 'en') {
        await tester.runAsync(
          () => getIt<LocaleStorage>().saveLanguageCode('en'),
        );
      }
      await tester.pumpWidget(const AmanosApp());
      await waitFor(tester, find.byType(LoginPage));
      expect(
        Directionality.of(tester.element(find.byType(LoginPage))),
        code == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      await tester.tap(find.widgetWithText(ElevatedButton, l10n.login));
      await tester.pumpAndSettle();
      expect(find.text(l10n.credentialsRequired), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'invalid-email');
      await tester.enterText(find.byType(TextField).last, 'password');
      await tester.tap(find.widgetWithText(ElevatedButton, l10n.login));
      await tester.pumpAndSettle();
      expect(find.text(l10n.invalidEmail), findsOneWidget);

      await tester.tap(find.text(l10n.useDemoAccount));
      await tester.tap(find.widgetWithText(ElevatedButton, l10n.login));
      await waitFor(tester, find.text('User 1'));
      expect(find.text(l10n.users), findsOneWidget);
      expect(loginRequests.single, {
        'email': 'eve.holt@reqres.in',
        'password': 'cityslicka',
      });
      expect(session.token, 'test-session');
      await tester.tap(find.text(l10n.next));
      await waitFor(tester, find.text('User 2'));
      expect(find.text(l10n.pageIndicator(2, 2)), findsOneWidget);
      final requestsBeforeSwitch = userRequests;
      final otherCode = code == 'ar' ? 'en' : 'ar';
      final other = await AppLocalizations.delegate.load(Locale(otherCode));
      await chooseLanguage(tester, otherCode == 'en' ? 'English' : 'العربية');
      expect(find.text(other.users), findsOneWidget);
      expect(find.text('User 2'), findsOneWidget);
      expect(userRequests, requestsBeforeSwitch);
      expect(
        Directionality.of(tester.element(find.byType(UsersPage))),
        otherCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      await tester.tap(find.byTooltip(other.userDetails));
      await tester.pumpAndSettle();
      expect(find.text(other.userId(2)), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(AlertDialog))),
        otherCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      await tester.tap(find.text(other.close));
      await tester.pumpAndSettle();

      offline = true;
      await tester.tap(find.byTooltip(other.refresh));
      await waitFor(tester, find.text(other.cachedData));
      await tester.tap(find.text(other.previous));
      await waitFor(tester, find.text('User 1'));
      expect(find.text(other.cachedData), findsOneWidget);
      await chooseLanguage(tester, code == 'en' ? 'English' : 'العربية');
      expect(find.text(l10n.cachedData), findsOneWidget);
      expect(find.text('User 1'), findsOneWidget);

      // Recreate providers and DI with saved settings/cache and an offline session.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await getIt.reset();
        await configure();
      });
      await tester.pumpWidget(const AmanosApp());
      await waitFor(tester, find.text(l10n.cachedData));
      expect(find.text(l10n.users), findsOneWidget);
      expect(find.text('User 1'), findsOneWidget);
      await tester.tap(find.byTooltip(l10n.logout));
      await waitFor(tester, find.byType(LoginPage));
      expect(session.token, isNull);
      expect(getIt<LocaleStorage>().languageCode, code);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  }

  testWidgets(
    'language menu retranslates existing validation and saves English',
    (tester) async {
      await useWidgetStorage();
      tester.view.physicalSize = const Size(1100, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final ar = await AppLocalizations.delegate.load(const Locale('ar'));
      final en = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.pumpWidget(const AmanosApp());
      await waitFor(tester, find.byType(LoginPage));
      await tester.tap(find.widgetWithText(ElevatedButton, ar.login));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'draft@reqres.in');
      await chooseLanguage(tester, 'English');
      expect(find.text(en.credentialsRequired), findsOneWidget);
      expect(find.text('draft@reqres.in'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(LoginPage))),
        TextDirection.ltr,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await getIt.reset();
        await configure();
      });
      await tester.pumpWidget(const AmanosApp());
      await waitFor(tester, find.byType(LoginPage));
      expect(find.text(en.email), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(LoginPage))),
        TextDirection.ltr,
      );
      await chooseLanguage(tester, 'العربية');
      expect(find.text(ar.email), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(LoginPage))),
        TextDirection.rtl,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
