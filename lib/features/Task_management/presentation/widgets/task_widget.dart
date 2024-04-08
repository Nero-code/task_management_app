import 'package:flutter/material.dart';
import 'package:task_management_app/features/Task_management/domain/entities/task.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.onChange,
    required this.onTap,
    required this.onDelete,
  });

  final Task task;
  final void Function(bool? s) onChange;
  final VoidCallback onTap, onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: task.isFinished
            ? Color.fromARGB(255, 119, 175, 120)
            : const Color.fromARGB(45, 158, 158, 158),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Checkbox(
                value: task.isFinished,
                onChanged: (newVal) {
                  onChange(newVal);
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${task.name}"),
                  Text("Year: ${task.year}"),
                  Text("color: ${task.color}"),
                  Text("pantone value: ${task.pantoneValue}"),
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                splashRadius: 25,
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
