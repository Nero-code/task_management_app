import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_management_app/features/Task_management/presentation/bloc/tasks_bloc.dart';
import 'package:task_management_app/features/Task_management/presentation/widgets/task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();

  bool rechedTheEnd = false;

  @override
  void initState() {
    controller.addListener(() {
      if (!rechedTheEnd &&
          controller.position.atEdge &&
          controller.position.pixels != 0) {
        BlocProvider.of<TasksBloc>(context).add(GetTasksEvent());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Management"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (contxt) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: Text(
                          "you are about to log out, please confirm your choice."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(LogoutEvent());
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed("/Auth");
                            },
                            child: Text("Ok"))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final block = BlocProvider.of<TasksBloc>(context).stream.first;
          BlocProvider.of<TasksBloc>(context).add(RefreshTasksEvent());
          await block;
        },
        child: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state is LoadedTasksState) {
              if (state.tasks.isEmpty) {
                return const Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_done_outlined,
                          size: 50,
                        ),
                        Text("No Tasks for Today"),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: state.tasks.length + 1,
                controller: controller,
                itemBuilder: (context, index) {
                  if (index == state.tasks.length) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: state.reachedTheEnd
                            ? const Text("No More Data...")
                            : const CircularProgressIndicator(),
                      ),
                    );
                  }
                  return TaskWidget(
                    task: state.tasks[index],
                    onTap: () {
                      Navigator.pushNamed(
                          context, "/Home/add_update_tasks_page",
                          arguments: state.tasks[index]);
                    },
                    onChange: (newVal) {
                      if (newVal != null) {
                        BlocProvider.of<TasksBloc>(context).add(
                          MarkTaskEvent(task: state.tasks[index], mark: newVal),
                        );
                      }
                    },
                    onDelete: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Task?"),
                              content: Text(
                                  "you are about to delete this task, please confirm..."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red)),
                                  onPressed: () {
                                    BlocProvider.of<TasksBloc>(context).add(
                                      DeleteTasksEvent(
                                          tasks: state.tasks[index]),
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Task ${state.tasks[index].name} Deleted Successfully")));
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          });
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              );
            } else if (state is ErrorTasksState) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Text(state.errMsg),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, "/Home/add_update_tasks_page");
        },
      ),
    );
  }
}
