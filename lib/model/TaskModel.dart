import 'package:flutter/foundation.dart';

class TaskModel {
  final int? id;
  final String? title;
  final String? detail;

  const TaskModel({this.id, @required this.title, @required this.detail});

  toMap() => {'id': id, 'title': title, 'detail': detail};

  @override
  String toString() => "$id ${title ?? ""} ${detail ?? ""}";
}
