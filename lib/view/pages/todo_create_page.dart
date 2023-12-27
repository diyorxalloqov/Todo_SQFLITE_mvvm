import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/core/constants/app_color.dart';
import 'package:todo_app_sqflite/model/TaskModel.dart';
import 'package:todo_app_sqflite/view_model/bloc/all_todo/todo_bloc.dart';
import 'package:todo_app_sqflite/widgets/title_widget.dart';

class TodoCreatePage extends StatefulWidget {
  final TodoBloc todoBloc;
  const TodoCreatePage({super.key, required this.todoBloc});

  @override
  State<TodoCreatePage> createState() => _TodoCreatePageState();
}

class _TodoCreatePageState extends State<TodoCreatePage> {
  late TextEditingController _titleController;

  late TextEditingController _detailController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _detailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            )),
        backgroundColor: primaryColor,
        title: const TitleWidget(text: 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 35),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _detailController,
              decoration: const InputDecoration(hintText: 'Detail'),
            ),
            const SizedBox(height: 72),
            ElevatedButton(
                onPressed: () {
                  widget.todoBloc.add(TodoCreateEvent(
                      taskModelCreate: TaskModel(
                          title: _titleController.text,
                          detail: _detailController.text)));
                  _titleController.clear();
                  _detailController.clear();
                  Navigator.maybePop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    fixedSize: const Size(double.infinity, 65)),
                child: const Center(
                    child: Text(
                  "ADD",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )))
          ],
        ),
      ),
    );
  }
}
