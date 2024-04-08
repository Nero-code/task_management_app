part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

final class GetTasksEvent extends TasksEvent {}

final class RefreshTasksEvent extends TasksEvent {}

final class UpdateTaskEvent extends TasksEvent {
  final TaskModel task;
  const UpdateTaskEvent({required this.task});
}

final class DeleteTasksEvent extends TasksEvent {
  final t.Task tasks;
  const DeleteTasksEvent({required this.tasks});
}

final class AddTaskEvent extends TasksEvent {
  final TaskModel task;
  const AddTaskEvent({required this.task});
}

final class MarkTaskEvent extends TasksEvent {
  final t.Task task;
  final bool mark;
  const MarkTaskEvent({required this.task, required this.mark});
}
