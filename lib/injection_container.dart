import 'package:get_it/get_it.dart' as di;
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/core/connections/network_info.dart';
import 'package:task_management_app/features/Auth/data/repository_impl/auth_repo_impl.dart';
import 'package:task_management_app/features/Auth/data/sources/local_auth_source.dart';
import 'package:task_management_app/features/Auth/data/sources/remote_auth_source.dart';
import 'package:task_management_app/features/Auth/domain/repository/auth_repo.dart';
import 'package:task_management_app/features/Auth/domain/usecases/auth_usecases.dart';
import 'package:task_management_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_management_app/features/Task_management/data/repository_impl/task_repo_impl.dart';
import 'package:task_management_app/features/Task_management/data/sources/local_tasks_source.dart';
import 'package:task_management_app/features/Task_management/data/sources/remote_tasks_source.dart';
import 'package:task_management_app/features/Task_management/domain/repository/task_repo.dart';
import 'package:task_management_app/features/Task_management/domain/usecases/task_usecases.dart';
import 'package:task_management_app/features/Task_management/presentation/bloc/tasks_bloc.dart';

final sl = di.GetIt.instance;

Future<void> init() async {
  //////////////////////////////////////////////////////////////////////////////
  ///   D A T A B A S E
  //////////////////////////////////////////////////////////////////////////////
  const databaseName = 'database.db';
  // await deleteDatabase(join(await getDatabasesPath(), databaseName));
  final db = await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE IF NOT EXISTS User(id INTEGER PRIMARY KEY, email TEXT, password TEXT, token TEXT)');

      db.execute(
          'CREATE TABLE IF NOT EXISTS Tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, year TEXT, color TEXT, pantone_value TEXT, isFinished TEXT)');
    },
    version: 1,
  );
  sl.registerLazySingleton<Database>(() => db);

  //////////////////////////////////////////////////////////////////////////////
  ///   D A T A   S O U R C E S
  //////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<LocalAuthSource>(() => LocalAuthSourceImpl(sl()));
  sl.registerLazySingleton<RemoteAuthSource>(() => RemoteAuthSourceImpl(sl()));

  sl.registerLazySingleton<LocalTasksSource>(() => LocalTasksSourceImpl(sl()));
  sl.registerLazySingleton<RemoteTasksSource>(
      () => RemoteTasksSourceImpl(sl()));

  //////////////////////////////////////////////////////////////////////////////
  ///   R E P O S I T O R Y
  //////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<TasksRepo>(() => TasksRepoImpl(sl(), sl(), sl()));

  //////////////////////////////////////////////////////////////////////////////
  ///   U S E C A S E S
  //////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<TasksUsecases>(() => TasksUsecases(sl()));
  sl.registerLazySingleton<AuthUsecases>(() => AuthUsecases(sl()));

  //////////////////////////////////////////////////////////////////////////////
  ///  B L O C
  //////////////////////////////////////////////////////////////////////////////

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
  sl.registerFactory<TasksBloc>(() => TasksBloc(sl()));

  //////////////////////////////////////////////////////////////////////////////
  ///   O T H E R
  //////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
