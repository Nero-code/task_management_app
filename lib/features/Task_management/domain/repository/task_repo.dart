import 'package:dartz/dartz.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart'
    as t;

abstract class TasksRepo {
  Future<Either<Failure, List<t.Task>>> getTasks();
  Future<Either<Failure, List<t.Task>>> updateTask(t.Task task);
  Future<Either<Failure, List<t.Task>>> deleteTask(t.Task tasks);
  Future<Either<Failure, List<t.Task>>> createTask(TaskModel task);
}
