part of 'completed_todo_bloc.dart';

@immutable
sealed class CompletedTodoEvent extends Equatable {
  const CompletedTodoEvent();
}

class CompletedTodoGetEvent extends CompletedTodoEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CompletedTodoDeleteEvent extends CompletedTodoEvent {
  final int id;

  const CompletedTodoDeleteEvent({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class CompletedTodoCreateEvent extends CompletedTodoEvent {
  final TaskModel taskModelCreate;

  const CompletedTodoCreateEvent({required this.taskModelCreate});

  @override
  // TODO: implement props
  List<Object?> get props => [taskModelCreate];
}
