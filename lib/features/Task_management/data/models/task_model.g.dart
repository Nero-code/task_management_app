// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'],
      name: json['name'] as String,
      year: json['year'].toString(),
      color: json['color'] as String,
      pantoneValue: json['pantone_value'] as String,
      isFinished: bool.parse((json['isFinished'] ?? "false")),
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'year': instance.year,
      'color': instance.color,
      'pantone_value': instance.pantoneValue,
      'isFinished': "${instance.isFinished}",
    };
