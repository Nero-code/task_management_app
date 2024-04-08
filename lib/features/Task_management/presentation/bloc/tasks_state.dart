part of 'tasks_bloc.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

final class TasksInitial extends TasksState {}

final class LoadedTasksState extends TasksState {
  final List<t.Task> tasks;

  final bool reachedTheEnd;

  const LoadedTasksState({required this.tasks, required this.reachedTheEnd});
  @override
  List<Object> get props => [...tasks, reachedTheEnd];
}

final class LoadingTasksState extends TasksState {}

final class UpdatedTasksState extends TasksState {
  final List<t.Task> tasks;
  const UpdatedTasksState({required this.tasks});
}

final class ErrorTasksState extends TasksState {
  final String errMsg;
  const ErrorTasksState({required this.errMsg});

  @override
  List<Object> get props => [errMsg];
}
