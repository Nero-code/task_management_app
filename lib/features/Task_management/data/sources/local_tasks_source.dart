import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/core/constants/constants.dart';
import 'package:task_management_app/core/failures/exceptions.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart';

abstract class LocalTasksSource {
  Future<List<Task>> getTasks(int page);
  Future<void> deleteTask(Task taskList);
  Future<void> updateTask(TaskModel task);
  Future<Task> addTask(TaskModel task);
}

class LocalTasksSourceImpl implements LocalTasksSource {
  final Database database;

  LocalTasksSourceImpl(this.database);

  @override
  Future<List<Task>> getTasks(int page) async {
    final result = await database.query(TASKSTABLE, limit: 6, offset: page * 6);
    final List<Task> list = [];
    if (result.isNotEmpty) {
      result.forEach((element) {
        list.add(TaskModel.fromJson(element));
      });
      return list;
    } else if (result.isEmpty && page > 1) {
      return [];
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Task> addTask(TaskModel task) async {
    final temp = task;
    final result = await database.query(TASKSTABLE);
    if (result.isNotEmpty) {
      for (var i in result) {
        if (i["id"] == temp.id) {
          return TaskModel.fromJson(i);
        }
      }
    }
    print("add task: ${temp.toJson()}");
    temp.toJson().addAll({"id": null});
    print("add task: ${task.toJson()}");

    final id = await database.insert(
      TASKSTABLE,
      temp.toJson(),
    );
    temp.toJson().addAll({"id": id});
    return temp;
  }

  @override
  Future<void> deleteTask(Task task) async {
    print("Deep in Delete ${task.id}");
    await database.delete(
      TASKSTABLE,
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    print("Deep in update ");
    print(task.toJson());

    await database
        .update(TASKSTABLE, task.toJson(), where: "id=?", whereArgs: [task.id]);
    return task;
  }
}
