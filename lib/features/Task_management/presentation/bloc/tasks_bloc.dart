import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart'
    as t;
import 'package:task_management_app/features/Task_management/domain/usecases/task_usecases.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksUsecases usecases;
  bool reachedTheEnd = false;
  TasksBloc(this.usecases) : super(TasksInitial()) {
    on<TasksEvent>((event, emit) async {
      if (event is GetTasksEvent) {
        //
        //  GetTasksEvent
        //

        final either = await usecases.getTasks();
        either.fold((fail) {
          if (fail is EmptyCacheFailure) {
            emit(ErrorTasksState(errMsg: fail.errMsg));
          } else if (fail is EndOfFileFailure) {
            reachedTheEnd = true;
            emit(
              LoadedTasksState(
                  tasks: List.from(fail.tasksList),
                  reachedTheEnd: reachedTheEnd),
            );
          } else {
            print("Other Error");
            emit(ErrorTasksState(errMsg: fail.errMsg));
          }
        }, (tasksList) {
          print("Loaded");
          emit(
            LoadedTasksState(
                tasks: List.from(tasksList), reachedTheEnd: reachedTheEnd),
          );
        });
      } else if (event is RefreshTasksEvent) {
        emit(LoadingTasksState());
        final either = await usecases.getTasks();
        either.fold((fail) {
          if (fail is EmptyCacheFailure) {
            emit(ErrorTasksState(errMsg: fail.errMsg));
          } else if (fail is EndOfFileFailure) {
            reachedTheEnd = true;
            emit(
              LoadedTasksState(
                  tasks: List.from(fail.tasksList),
                  reachedTheEnd: reachedTheEnd),
            );
          } else {
            print("Other Error");
            emit(ErrorTasksState(errMsg: fail.errMsg));
          }
        }, (tasksList) {
          print("Loaded");
          emit(
            LoadedTasksState(
                tasks: List.from(tasksList), reachedTheEnd: reachedTheEnd),
          );
        });
      } else if (event is DeleteTasksEvent) {
        //
        //  DeleteTasksEvent
        //
        final either = await usecases.deleteTask(event.tasks);
        either.fold((fail) {
          emit(ErrorTasksState(errMsg: fail.errMsg));
        }, (r) {
          emit(LoadedTasksState(tasks: r, reachedTheEnd: reachedTheEnd));
        });
      } else if (event is UpdateTaskEvent) {
        //
        //  UpdateTaskEvent
        //
        final either = await usecases.updateTask(event.task);
        either.fold((fail) {
          emit(ErrorTasksState(errMsg: fail.errMsg));
        }, (tasksList) {
          emit(
              LoadedTasksState(tasks: tasksList, reachedTheEnd: reachedTheEnd));
        });
      } else if (event is AddTaskEvent) {
        //
        //  AddTaskEvent
        //

        final either = await usecases.createTask(event.task);
        either.fold((fail) {
          emit(ErrorTasksState(errMsg: fail.errMsg));
        }, (tasksList) {
          emit(
            LoadedTasksState(tasks: tasksList, reachedTheEnd: reachedTheEnd),
          );
        });
      } else if (event is MarkTaskEvent) {
        //
        //  MarkTaskEvent
        //
        final either = await usecases.updateTask(
          TaskModel(
              id: event.task.id,
              name: event.task.name,
              year: event.task.year,
              color: event.task.color,
              isFinished: event.mark,
              pantoneValue: event.task.pantoneValue),
        );
        either.fold((l) {
          emit(
            ErrorTasksState(errMsg: l.errMsg),
          );
        }, (newList) {
          emit(
            LoadedTasksState(tasks: newList, reachedTheEnd: reachedTheEnd),
          );
        });
      }
    });
  }
}
