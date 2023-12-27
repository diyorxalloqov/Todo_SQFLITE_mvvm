// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app_sqflite/core/constants/app_color.dart';
import 'package:todo_app_sqflite/core/constants/app_icons.dart';
import 'package:todo_app_sqflite/view/pages/all_todos.dart';
import 'package:todo_app_sqflite/view/pages/completed_todos.dart';
import 'package:todo_app_sqflite/view/pages/todo_create_page.dart';
import 'package:todo_app_sqflite/view_model/bloc/all_todo/todo_bloc.dart';
import 'package:todo_app_sqflite/view_model/bloc/completed_todo/completed_todo_bloc.dart';
import 'package:todo_app_sqflite/widgets/title_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TodoBloc _todoBloc;
  late CompletedTodoBloc _completedTodoBloc;
  int _currentIndex = 0;

  @override
  void initState() {
    _todoBloc = TodoBloc();
    _completedTodoBloc = CompletedTodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _todoBloc,
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: TitleWidget(
                  text: _currentIndex == 0 ? 'TODO APP' : 'Completed Task'),
              actions: _currentIndex == 0
                  ? [
                      SizedBox(
                          child: Stack(children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                        Positioned(
                            left: 12,
                            top: 15,
                            child: Text(
                              DateTime.now().day.toString(),
                              style: const TextStyle(color: Colors.white),
                            ))
                      ])),
                      const SizedBox(width: 10)
                    ]
                  : [],
            ),
            body: _currentIndex == 0
                ? BlocProvider.value(
                    value: _completedTodoBloc,
                    child: AllTodos(todoBloc: _todoBloc),
                  )
                : const CompletedTodos(),
            bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle: TextStyle(color: primaryColor),
              unselectedLabelStyle: const TextStyle(color: Colors.blueGrey),
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.all), label: 'all'),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.check_1),
                    label: 'Completed'),
              ],
              currentIndex: _currentIndex,
              onTap: (value) {
                _currentIndex = value;
                setState(() {});
              },
            ),
            floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoCreatePage(
                                    todoBloc: _todoBloc,
                                  )));
                    },
                    shape: const CircleBorder(),
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.add, color: Colors.white))
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
