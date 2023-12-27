import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app_sqflite/core/constants/app_color.dart';
import 'package:todo_app_sqflite/core/constants/app_icons.dart';
import 'package:todo_app_sqflite/model/TaskModel.dart';
import 'package:todo_app_sqflite/view/pages/todo_edit_page.dart';
import 'package:todo_app_sqflite/view_model/bloc/all_todo/todo_bloc.dart';
import 'package:todo_app_sqflite/view_model/bloc/completed_todo/completed_todo_bloc.dart';

class AllTodos extends StatelessWidget {
  final TodoBloc todoBloc;
  const AllTodos({super.key, required this.todoBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoEditPage(
                                          todoBloc: todoBloc, index: index)));
                            },
                            icon: SvgPicture.asset(AppIcons.pen)),
                        IconButton(
                            onPressed: () {
                              todoBloc.add(TodoDeleteEvent(
                                  id: state.taskmodel[index].id!.toInt()));
                            },
                            icon: SvgPicture.asset(AppIcons.trash)),
                        BlocProvider.value(
                          value: CompletedTodoBloc(),
                          child: IconButton(
                              onPressed: () {
                                todoBloc.add(TodoDeleteEvent(
                                    id: state.taskmodel[index].id!.toInt()));
                                context.read<CompletedTodoBloc>().add(
                                    CompletedTodoCreateEvent(
                                        taskModelCreate: TaskModel(
                                            id: state.taskmodel[index].id,
                                            title: state.taskmodel[index].title,
                                            detail: state
                                                .taskmodel[index].detail)));
                              },
                              icon: SvgPicture.asset(AppIcons.check)),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: state.taskmodel.length,
            ),
    );
  }
}
