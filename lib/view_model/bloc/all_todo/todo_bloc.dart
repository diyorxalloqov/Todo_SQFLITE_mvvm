import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/db/sqlDBService.dart';
import 'package:todo_app_sqflite/model/TaskModel.dart';
import 'package:todo_app_sqflite/core/enum/status.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final SQLDBService _sqldbService = SQLDBService();

  TodoBloc() : super(const TodoState()) {
    on<TodoGetEvent>(_getTodos);
    add(TodoGetEvent());
    on<TodoCreateEvent>(_createTodo);
    on<TodoDeleteEvent>(_deleteTodo);
    on<TodoUpdateEvent>(_updateTodo);

  }

  FutureOr<void> _getTodos(TodoGetEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      var res = await _sqldbService.getALlData();
      emit(state.copyWith(status: ActionStatus.isSuccess, taskmodel: res));
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }

  FutureOr<void> _createTodo(
      TodoCreateEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      await _sqldbService.insertData(event.taskModelCreate);
      emit(state.copyWith(status: ActionStatus.isSuccess));
      add(TodoGetEvent());
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }

  FutureOr<void> _deleteTodo(
      TodoDeleteEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      await _sqldbService.deleteData(event.id);
      emit(state.copyWith(status: ActionStatus.isSuccess));
      add(TodoGetEvent());
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }

  FutureOr<void> _updateTodo(
      TodoUpdateEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      await _sqldbService.updateData(event.taskmodelnew);
      emit(state.copyWith(status: ActionStatus.isSuccess));
      add(TodoGetEvent());
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }
}
