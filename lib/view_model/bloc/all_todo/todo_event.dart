part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoUpdateEvent extends TodoEvent {
  final TaskModel taskmodelnew;

  const TodoUpdateEvent({required this.taskmodelnew});

  @override
  // TODO: implement props
  List<Object?> get props => [taskmodelnew];
}

class TodoGetEvent extends TodoEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TodoDeleteEvent extends TodoEvent {
  final int id;

  const TodoDeleteEvent({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class TodoCreateEvent extends TodoEvent {
  final TaskModel taskModelCreate;

  const TodoCreateEvent({required this.taskModelCreate});

  @override
  // TODO: implement props
  List<Object?> get props => [taskModelCreate];
}


