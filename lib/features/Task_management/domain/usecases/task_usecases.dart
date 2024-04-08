import 'package:dartz/dartz.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart'
    as tm;
import 'package:task_management_app/features/Task_management/domain/repository/task_repo.dart';

class TasksUsecases {
  final TasksRepo repo;
  TasksUsecases(this.repo);
  Future<Either<Failure, List<tm.Task>>> getTasks() async {
    return await repo.getTasks();
  }

  Future<Either<Failure, List<tm.Task>>> updateTask(TaskModel task) async {
    return await repo.updateTask(task);
  }

  Future<Either<Failure, List<tm.Task>>> deleteTask(tm.Task tasks) async {
    return await repo.deleteTask(tasks);
  }

  Future<Either<Failure, List<tm.Task>>> createTask(TaskModel task) async {
    return await repo.createTask(task);
  }
}
