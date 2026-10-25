import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:amanos_flutter/core/network/api_exception.dart';
import 'package:amanos_flutter/core/network/dio_client.dart';
import 'package:amanos_flutter/core/storage/secure_storage.dart';
import 'package:amanos_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:amanos_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:amanos_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:amanos_flutter/features/auth/domain/usecases/session_usecase.dart';
import 'package:amanos_flutter/features/auth/presentation/cubit/login_cubit.dart';
import 'package:amanos_flutter/features/auth/presentation/cubit/login_state.dart';
import 'package:amanos_flutter/features/users/data/datasources/users_local_data_source.dart';
import 'package:amanos_flutter/features/users/data/datasources/users_remote_data_source.dart';
import 'package:amanos_flutter/features/users/data/repositories/users_repository_impl.dart';
import 'package:amanos_flutter/features/users/domain/usecases/get_users_usecase.dart';
import 'package:amanos_flutter/features/users/presentation/cubit/users_cubit.dart';

class StubAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions) respond;
  StubAdapter(this.respond);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);
  @override
  void close({bool force = false}) {}
}

class MemorySession extends SecureStorage {
  String? token;
  bool failLogout = false;
  @override
  Future<void> saveToken(String token) async => this.token = token;
  @override
  Future<bool> hasSession() async => token?.isNotEmpty ?? false;
  @override
  Future<void> clearSession() async {
    if (failLogout) throw Exception('storage unavailable');
    token = null;
  }
}

ResponseBody jsonResponse(Object data, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Map<String, Object> usersResponse(int page, {int perPage = 6}) => {
  'page': page,
  'per_page': perPage,
  'total': 12,
  'total_pages': 2,
  'data': [
    {
      'id': page,
      'email': 'user$page@reqres.in',
      'first_name': 'User',
      'last_name': '$page',
      'avatar': 'https://example.com/avatar.png',
    },
  ],
};

void main() {
  late Directory temp;
  late Box<String> box;
  late Dio dio;
  late UsersRepositoryImpl repository;
  bool offline = false;
  int? status;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('amanos_hive_test_');
    Hive.init(temp.path);
    box = await Hive.openBox<String>('users');
    offline = false;
    status = null;
    dio = DioClient(apiKey: 'test-key').dio;
    dio.httpClientAdapter = StubAdapter((options) async {
      expect(options.uri.path, '/api/users');
      expect(options.headers['x-api-key'], 'test-key');
      if (offline) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      }
      if (status != null) {
        return jsonResponse({'error': 'Rejected'}, status: status!);
      }
      return jsonResponse(
        usersResponse(
          options.queryParameters['page'] as int,
          perPage: options.queryParameters['per_page'] as int,
        ),
      );
    });
    repository = UsersRepositoryImpl(
      remote: UsersRemoteDataSource(dio),
      local: UsersLocalDataSource(box),
    );
  });

  tearDown(() async {
    dio.close(force: true);
    await Hive.close();
    await temp.delete(recursive: true);
  });

  test(
    'pages persist in Hive across reopen and remain separate offline',
    () async {
      final first = await repository.getUsers(page: 1);
      await repository.getUsers(page: 2);
      expect(first.isFromCache, false);
      expect(first.data.totalPages, 2);

      await box.close();
      box = await Hive.openBox<String>('users');
      repository = UsersRepositoryImpl(
        remote: UsersRemoteDataSource(dio),
        local: UsersLocalDataSource(box),
      );
      offline = true;

      final cachedFirst = await repository.getUsers(page: 1);
      final cachedSecond = await repository.getUsers(page: 2);
      expect(cachedFirst.isFromCache, true);
      expect(cachedFirst.data.users.single.email, 'user1@reqres.in');
      expect(cachedSecond.data.page, 2);
      expect(cachedSecond.data.users.single.id, 2);
      expect(cachedSecond.data.total, 12);
    },
  );

  test(
    'uncached offline pages fail rather than showing another page',
    () async {
      await repository.getUsers(page: 1);
      offline = true;
      await expectLater(
        repository.getUsers(page: 2),
        throwsA(isA<ApiException>()),
      );
      await expectLater(
        repository.getUsers(page: 1, perPage: 3),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test(
    'authorization and rate-limit failures are not masked by the cache',
    () async {
      await repository.getUsers(page: 1);
      for (final code in [401, 403, 429, 500]) {
        status = code;
        await expectLater(
          repository.getUsers(page: 1),
          throwsA(isA<ApiException>()),
        );
      }
    },
  );

  test(
    'refresh replaces stored data and a corrupted cache reports failure',
    () async {
      await repository.getUsers(page: 1);
      dio.httpClientAdapter = StubAdapter((_) async {
        final data = usersResponse(1);
        data['total'] = 15;
        return jsonResponse(data);
      });
      expect((await repository.getUsers(page: 1)).data.total, 15);
      dio.httpClientAdapter = StubAdapter((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
        );
      });
      expect((await repository.getUsers(page: 1)).data.total, 15);
      await box.put('users_v1_6_1', '{invalid json');
      await expectLater(
        repository.getUsers(page: 1),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test(
    'pagination retains the visible page when the next page fails',
    () async {
      final cubit = UsersCubit(GetUsersUseCase(repository));
      await cubit.loadPage(1);
      offline = true;
      await cubit.loadPage(2);
      expect(cubit.state.result!.data.page, 1);
      expect(cubit.state.requestedPage, 2);
      expect(cubit.state.error, isNotNull);
      expect(cubit.state.isLoading, false);
      offline = false;
      await cubit.loadPage(cubit.state.requestedPage);
      expect(cubit.state.result!.data.page, 2);
      expect(cubit.state.error, isNull);
      await cubit.close();
    },
  );

  test(
    'login saves token, restores session and logs out without saving password',
    () async {
      final session = MemorySession();
      dio.httpClientAdapter = StubAdapter((options) async {
        expect(options.uri.path, '/api/login');
        expect(options.data, {
          'email': 'eve.holt@reqres.in',
          'password': 'cityslicka',
        });
        return jsonResponse({'token': 'demo-token'});
      });
      final auth = AuthRepositoryImpl(AuthRemoteDataSource(dio), session);
      final cubit = LoginCubit(
        loginUseCase: LoginUseCase(auth),
        sessionUseCase: SessionUseCase(auth),
      );
      await cubit.restoreSession();
      expect(cubit.state, isA<LoginInitial>());
      await cubit.login(email: ' eve.holt@reqres.in ', password: 'cityslicka');
      expect(cubit.state, isA<LoginSuccess>());
      expect(session.token, 'demo-token');
      await cubit.close();

      final restored = LoginCubit(
        loginUseCase: LoginUseCase(auth),
        sessionUseCase: SessionUseCase(auth),
      );
      await restored.restoreSession();
      expect(restored.state, isA<LoginSuccess>());
      session.failLogout = true;
      await expectLater(restored.logout(), throwsException);
      expect(restored.state, isA<LoginSuccess>());
      session.failLogout = false;
      await restored.logout();
      expect(restored.state, isA<LoginInitial>());
      expect(session.token, isNull);
      await restored.close();
    },
  );

  test('empty token and failed login cannot create a saved session', () async {
    final session = MemorySession();
    final auth = AuthRepositoryImpl(AuthRemoteDataSource(dio), session);
    dio.httpClientAdapter = StubAdapter(
      (_) async => jsonResponse({'token': ''}),
    );
    await expectLater(
      auth.login(email: 'eve.holt@reqres.in', password: 'cityslicka'),
      throwsA(isA<ApiException>()),
    );
    expect(session.token, isNull);
    dio.httpClientAdapter = StubAdapter(
      (_) async => jsonResponse({'error': 'user not found'}, status: 400),
    );
    final cubit = LoginCubit(
      loginUseCase: LoginUseCase(auth),
      sessionUseCase: SessionUseCase(auth),
    );
    await cubit.login(email: 'eve.holt@reqres.in', password: 'wrong');
    expect(cubit.state, isA<LoginFailure>());
    expect((cubit.state as LoginFailure).message, 'user not found');
    expect(session.token, isNull);
    await cubit.close();
  });
}
