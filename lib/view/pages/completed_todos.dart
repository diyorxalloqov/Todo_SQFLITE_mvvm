import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app_sqflite/core/constants/app_color.dart';
import 'package:todo_app_sqflite/core/constants/app_icons.dart';
import 'package:todo_app_sqflite/view_model/bloc/completed_todo/completed_todo_bloc.dart';

class CompletedTodos extends StatefulWidget {
  const CompletedTodos({super.key});

  @override
  State<CompletedTodos> createState() => _CompletedTodosState();
}

class _CompletedTodosState extends State<CompletedTodos> {
  late CompletedTodoBloc _completedTodoBloc;

  @override
  void initState() {
    _completedTodoBloc = CompletedTodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _completedTodoBloc,
      child: BlocBuilder<CompletedTodoBloc, CompletedTodoState>(
        builder: (context, state) => state.taskmodel.isEmpty
            ? const Center(
                child: Text(
                "has not Todos",
                style: TextStyle(color: Colors.black54, fontSize: 20),
              ))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        state.taskmodel[index].title.toString(),
                        style: TextStyle(color: primaryColor),
                      ),
                      subtitle: Text(
                        state.taskmodel[index].detail.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                _completedTodoBloc.add(CompletedTodoDeleteEvent(
                                    id: state.taskmodel[index].id!.toInt()));
                              },
                              icon: SvgPicture.asset(AppIcons.trash)),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: state.taskmodel.length,
              ),
      ),
    );
  }
}
