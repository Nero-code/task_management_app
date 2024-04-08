import 'package:task_management_app/features/Task_management/domain/entities/task.dart';
import 'package:json_annotation/json_annotation.dart';
part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends Task {
  const TaskModel(
      {required super.id,
      required super.name,
      required super.year,
      required super.color,
      super.isFinished,
      required super.pantoneValue});

  factory TaskModel.fromJson(Map<String, dynamic> data) =>
      _$TaskModelFromJson(data);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
