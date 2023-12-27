part of 'todo_bloc.dart';

@immutable
class TodoState extends Equatable {
  final List<TaskModel> taskmodel;
  final String error;
  final ActionStatus status;

  const TodoState({
    this.taskmodel = const [],
    this.error = '',
    this.status = ActionStatus.initial,
  });

  TodoState copyWith(
      {List<TaskModel>? taskmodel,
      ActionStatus? status,
      String? error,
      int? currentIndex}) {
    return TodoState(
      error: error ?? this.error,
      taskmodel: taskmodel ?? this.taskmodel,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, error, taskmodel];
}
