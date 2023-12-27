part of 'completed_todo_bloc.dart';

@immutable
class CompletedTodoState extends Equatable {
  final List<TaskModel> taskmodel;
  final String error;
  final ActionStatus status;

  const CompletedTodoState({
    this.taskmodel = const [],
    this.error = '',
    this.status = ActionStatus.initial,
  });

  CompletedTodoState copyWith(
      {List<TaskModel>? taskmodel,
      ActionStatus? status,
      String? error,
      int? currentIndex}) {
    return CompletedTodoState(
      error: error ?? this.error,
      taskmodel: taskmodel ?? this.taskmodel,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, error, taskmodel];
}
