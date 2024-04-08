import 'package:dartz/dartz.dart';
import 'package:task_management_app/core/connections/network_info.dart';
import 'package:task_management_app/core/failures/exceptions.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/data/sources/local_tasks_source.dart';
import 'package:task_management_app/features/Task_management/data/sources/remote_tasks_source.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart'
    as t;
import 'package:task_management_app/features/Task_management/domain/repository/task_repo.dart';

class TasksRepoImpl implements TasksRepo {
  final LocalTasksSource localTasksSource;
  final RemoteTasksSource remoteTasksSource;
  final NetworkInfo networkInfo;

  TasksRepoImpl(
      this.localTasksSource, this.remoteTasksSource, this.networkInfo);

  int currentPage = 0, lastPage = 1;
  int localCurrentPage = 0, localLastPage = 1;
  List<t.Task> loadedTasks = [];

  bool fetchOnce = false;

  @override
  Future<Either<Failure, List<t.Task>>> createTask(TaskModel task) async {
    try {
      await localTasksSource.addTask(task);
      loadedTasks.add(task);
      return Right(List.from(loadedTasks));
    } catch (e) {
      return const Left(OfflineFailure("No Internet connection!"));
    }
  }

  @override
  Future<Either<Failure, List<t.Task>>> deleteTask(t.Task task) async {
    try {
      await localTasksSource.deleteTask(task);
      loadedTasks.remove(task);
      return Right(List.from(loadedTasks));
    } catch (e) {
      return const Left(DatabaseFailure("database Err!"));
    }
  }

  @override
  Future<Either<Failure, List<t.Task>>> getTasks() async {
    print("get Tasks");
    if (await networkInfo.isConnected()) {
      try {
        if (currentPage == lastPage) {
          return Left(EndOfFileFailure("", tasksList: List.from(loadedTasks)));
        }

        final res = await remoteTasksSource.getTasks(currentPage++);
        print("from repo: $res");
        for (var i in res) {
          final task = await localTasksSource.addTask(i as TaskModel);
          if (!loadedTasks.contains(task)) {
            loadedTasks.add(task);
          }
        }
        print("From local loadedTasks: $loadedTasks");
        // loadedTasks.toSet().toList();
        ++currentPage;
        ++localCurrentPage;
        lastPage = currentPage + 1;
        localLastPage = localCurrentPage + 1;

        return Right(List.from(loadedTasks));
      } on EndOfFileException {
        lastPage = currentPage;
        return Left(
            EndOfFileFailure("EndOfFile!", tasksList: List.from(loadedTasks)));
      } catch (e) {
        print(e);
        return Left(Failure("Unknown Err!"));
      }
    } else {
      try {
        final res = await localTasksSource.getTasks(localCurrentPage++);

        for (var i in res) {
          final task = await localTasksSource.addTask(i as TaskModel);
          if (!loadedTasks.contains(task)) {
            loadedTasks.add(task);
          }
        }

        ++currentPage;
        ++localCurrentPage;
        lastPage = currentPage + 1;
        localLastPage = localCurrentPage + 1;

        if (res.isEmpty) {
          return Left(EndOfFileFailure("No more data",
              tasksList: List.from(loadedTasks)));
        }
        return Right(List.from(res));
      } on EmptyCacheException {
        return const Left(EmptyCacheFailure("No Saved Records!"));
      } catch (e) {
        return const Left(Failure("Unknown Err!"));
      }
    }
  }

  @override
  Future<Either<Failure, List<t.Task>>> updateTask(t.Task task) async {
    try {
      print("Update task: ${task.id}");
      await localTasksSource.updateTask(task as TaskModel);
      loadedTasks[loadedTasks.indexWhere((element) => element.id == task.id)] =
          task;
      return Right(List.from(loadedTasks));
    } on DatabaseException {
      return const Left(DatabaseFailure(""));
    }
  }
}
