import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/session_usecase.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/users/data/datasources/users_local_data_source.dart';
import '../../features/users/data/datasources/users_remote_data_source.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/domain/repositories/users_repository.dart';
import '../../features/users/domain/usecases/get_users_usecase.dart';
import '../../features/users/presentation/cubit/users_cubit.dart';
import '../localization/locale_cubit.dart';
import '../network/dio_client.dart';
import '../settings/locale_storage.dart';
import '../storage/secure_storage.dart';

final getIt = GetIt.instance;
const usersBoxName = 'reqres_users';


Future<void> setupDependencies({GetIt? locator}) async {
  final sl = locator ?? getIt;
  final usersBox = await Hive.openBox<String>(usersBoxName);
  final settingsBox = await Hive.openBox<String>(LocaleStorage.boxName);
  sl.registerSingleton<Box<String>>(
    usersBox,
    instanceName: usersBoxName,
    dispose: (box) => box.close(),
  );
  sl.registerSingleton<Box<String>>(
    settingsBox,
    instanceName: LocaleStorage.boxName,
    dispose: (box) => box.close(),
  );
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(
    () => sl<DioClient>().dio,
    dispose: (dio) => dio.close(force: true),
  );
  sl.registerLazySingleton<SecureStorage>(() => const SecureStorage());
  sl.registerLazySingleton<LocaleStorage>(
    () => LocaleStorage(sl<Box<String>>(instanceName: LocaleStorage.boxName)),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<UsersLocalDataSource>(
    () => UsersLocalDataSource(sl<Box<String>>(instanceName: usersBoxName)),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<SecureStorage>()),
  );
  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      remote: sl<UsersRemoteDataSource>(),
      local: sl<UsersLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SessionUseCase>(
    () => SessionUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(sl<UsersRepository>()),
  );
  // Providers own these cubits and close them when their widget is disposed.
  sl.registerFactory<LocaleCubit>(() => LocaleCubit(sl<LocaleStorage>()));
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: sl<LoginUseCase>(),
      sessionUseCase: sl<SessionUseCase>(),
    ),
  );
  sl.registerFactory<UsersCubit>(() => UsersCubit(sl<GetUsersUseCase>()));
}
