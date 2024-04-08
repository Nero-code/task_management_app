import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/features/Task_management/data/models/task_model.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart';
import 'package:task_management_app/features/Task_management/presentation/bloc/tasks_bloc.dart';

class AddUpdateTasksScreen extends StatefulWidget {
  const AddUpdateTasksScreen({
    super.key,
  });

  @override
  State<AddUpdateTasksScreen> createState() => _AddUpdateTasksScreenState();
}

class _AddUpdateTasksScreenState extends State<AddUpdateTasksScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final panCtrl = TextEditingController();

  Future<void> initStrings(BuildContext context, Task args) async {
    await Future.delayed(Duration(seconds: 1));

    nameCtrl.text = args.name;
    yearCtrl.text = args.year;
    colorCtrl.text = args.color;
    panCtrl.text = args.pantoneValue;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    yearCtrl.dispose();
    colorCtrl.dispose();
    panCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Task?;
    print(args?.id);
    if (args != null) {
      initStrings(context, args);
    }
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(args?.name ?? "New Task"),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text.rich(
                              TextSpan(
                                text: 'Name',
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a Name";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: yearCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text.rich(
                              TextSpan(
                                text: 'Year',
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          maxLength: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a year";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            final regx = RegExp(r'^[^0-9]+$');
                            if (value.isNotEmpty) {
                              final digit = value.substring(value.length - 1);
                              if (digit.contains(regx)) {
                                yearCtrl.text =
                                    value.substring(0, value.length - 1);
                              }
                            }
                            // final match = regx.hasMatch();
                            // if (match) {
                            //   yearCtrl.text =
                            //       yearCtrl.text.substring(0, value.length - 1);
                            // }
                          },
                        ),
                        TextFormField(
                          controller: colorCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text.rich(
                              TextSpan(
                                text: 'Color',
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a hex color";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: panCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text.rich(
                              TextSpan(
                                text: 'Pantone Value',
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter something";
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          child: Text("SAVE"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final temp = TaskModel(
                                id: args?.id,
                                name: nameCtrl.text,
                                year: yearCtrl.text,
                                color: colorCtrl.text,
                                pantoneValue: panCtrl.text,
                                isFinished: false,
                              );

                              if (temp == args) {
                                print("Identical");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Nothing changed..."),
                                  ),
                                );
                              } else if (args == null) {
                                BlocProvider.of<TasksBloc>(context).add(
                                  AddTaskEvent(task: temp),
                                );
                                Navigator.of(context).pop();
                              } else {
                                print(args.id);

                                print(temp.id);

                                BlocProvider.of<TasksBloc>(context).add(
                                  UpdateTaskEvent(task: temp),
                                );
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                      ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
