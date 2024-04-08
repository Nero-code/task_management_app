import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String name, year, pantoneValue, color;
  final bool isFinished;

  const Task({
    required this.id,
    required this.name,
    required this.year,
    required this.color,
    required this.pantoneValue,
    this.isFinished = false,
  });

  @override
  List<Object?> get props => [name, year, color, pantoneValue, isFinished];
}
