import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/core/constants/app_color.dart';
import 'package:todo_app_sqflite/model/TaskModel.dart';
import 'package:todo_app_sqflite/view_model/bloc/all_todo/todo_bloc.dart';
import 'package:todo_app_sqflite/widgets/title_widget.dart';

class TodoEditPage extends StatefulWidget {
  final TodoBloc todoBloc;
  final int index;
  const TodoEditPage({super.key, required this.index, required this.todoBloc});

  @override
  State<TodoEditPage> createState() => _TodoCreatePageState();
}

class _TodoCreatePageState extends State<TodoEditPage> {
  late TextEditingController _updateTitleController;

  late TextEditingController _updateDetailController;

  @override
  void initState() {
    _updateTitleController = TextEditingController();
    _updateDetailController = TextEditingController();
    _updateTitleController.text =
        widget.todoBloc.state.taskmodel[widget.index].title.toString();
    _updateDetailController.text =
        widget.todoBloc.state.taskmodel[widget.index].detail.toString();
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
        title: const TitleWidget(text: 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 35),
            TextField(
              controller: _updateTitleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _updateDetailController,
              decoration: const InputDecoration(hintText: 'Detail'),
            ),
            const SizedBox(height: 72),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.todoBloc.add(TodoUpdateEvent(
                          taskmodelnew: TaskModel(
                              id: widget
                                  .todoBloc.state.taskmodel[widget.index].id,
                              title: _updateTitleController.text,
                              detail: _updateDetailController.text)));
                      _updateTitleController.clear();
                      _updateDetailController.clear();
                      Navigator.maybePop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: const Size(170, 65)),
                    child: const Center(
                        child: Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ))),
                const Spacer(),
                ElevatedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: const Size(170, 65)),
                    child: const Center(
                        child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
