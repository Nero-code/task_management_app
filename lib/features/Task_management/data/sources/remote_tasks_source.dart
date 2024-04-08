import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_management_app/core/constants/constants.dart';
import 'package:task_management_app/core/failures/exceptions.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart';

abstract class RemoteTasksSource {
  Future<List<Task>> getTasks(int page);
  Future<void> deleteTask(Task taskList);
  Future<void> updateTask(TaskModel task);
  Future<void> addTask(TaskModel task);
}

class RemoteTasksSourceImpl implements RemoteTasksSource {
  final http.Client client;

  RemoteTasksSourceImpl(this.client);

  @override
  Future<void> addTask(TaskModel task) async {
    final result = await client.post(Uri.parse(HTTP_API + HTTP_USER_SUFFIX),
        body: task.toJson());
    if (result.statusCode == 201) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    final result = await client.delete(
      Uri.parse(HTTP_API + HTTP_USER_SUFFIX + "/${task.id}"),
    );
    if (result.statusCode == 204) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Task>> getTasks(int page) async {
    final result = await client.get(
      Uri.parse(HTTP_API + HTTP_TASKS_SUFFIX + "?page=$page"),
    );

    final List<TaskModel> list = [];
    if (result.statusCode == 200) {
      final List<dynamic> data = jsonDecode(result.body)['data'];

      if (data.isEmpty) {
        throw EndOfFileException();
      }
      data.forEach(
        (element) {
          final e = Map<String, dynamic>.from(element);
          list.add(TaskModel.fromJson(e));
        },
      );
      return list;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {}
}
