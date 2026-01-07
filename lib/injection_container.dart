import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'features/users/data/datasources/user_remote_data_source.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/create_user.dart';
import 'features/users/domain/usecases/delete_user.dart';
import 'features/users/domain/usecases/get_users.dart';
import 'features/users/domain/usecases/update_user.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => UserBloc(
      getUsers: sl(),
      createUser: sl(),
      updateUser: sl(),
      deleteUser: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton(() => Dio());
}
