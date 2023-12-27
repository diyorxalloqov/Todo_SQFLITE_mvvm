import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/db/sqlDBService.dart';
import 'package:todo_app_sqflite/model/TaskModel.dart';
import 'package:todo_app_sqflite/core/enum/status.dart';

part 'completed_todo_event.dart';
part 'completed_todo_state.dart';

class CompletedTodoBloc extends Bloc<CompletedTodoEvent, CompletedTodoState> {
  final SQLDBService _sqldbService = SQLDBService();

  CompletedTodoBloc() : super(const CompletedTodoState()) {
    on<CompletedTodoGetEvent>(_getTodos);
    add(CompletedTodoGetEvent());
    on<CompletedTodoCreateEvent>(_createTodo);
    on<CompletedTodoDeleteEvent>(_deleteTodo);
  }

  FutureOr<void> _getTodos(
      CompletedTodoGetEvent event, Emitter<CompletedTodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      var res = await _sqldbService.getALlTodosCompleted();
      emit(state.copyWith(status: ActionStatus.isSuccess, taskmodel: res));
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }

  FutureOr<void> _createTodo(
      CompletedTodoCreateEvent event, Emitter<CompletedTodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      await _sqldbService.insertCompletedTodos(event.taskModelCreate);
      emit(state.copyWith(status: ActionStatus.isSuccess));
      add(CompletedTodoGetEvent());
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }

  FutureOr<void> _deleteTodo(
      CompletedTodoDeleteEvent event, Emitter<CompletedTodoState> emit) async {
    emit(state.copyWith(status: ActionStatus.isLoading));
    try {
      await _sqldbService.deleteCompletedTodos(event.id);
      emit(state.copyWith(status: ActionStatus.isSuccess));
      add(CompletedTodoGetEvent());
    } on DatabaseException catch (e) {
      print(e.result);
      emit(state.copyWith(status: ActionStatus.isError, error: e.toString()));
    }
  }
}
