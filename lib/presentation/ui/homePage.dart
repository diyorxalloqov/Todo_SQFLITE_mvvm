// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/domain/db/sqlDBService.dart';
import 'package:todo_app_sqflite/domain/model/data/TaskModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _isFinishController = TextEditingController();

  final TextEditingController _updateTitleController = TextEditingController();

  final TextEditingController _updateIsFinishController =
      TextEditingController();

  final SQLDBService _sqldbService = SQLDBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFLITE TODO APP"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 0.5.toInt(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Title"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _isFinishController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Finish"),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: FutureBuilder(
                future: _sqldbService.getALlData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.data is String) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    List<TaskModel> data = snapshot.data as List<TaskModel>;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Update"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _updateTitleController,
                                        decoration: const InputDecoration(
                                          hintText: "Update title",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _updateIsFinishController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: "Update isFinish",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Orqaga"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_updateTitleController
                                                .text.isNotEmpty) {
                                              int isFinishValue = int.tryParse(
                                                      _updateIsFinishController
                                                          .text) ??
                                                  0;
                                              TaskModel updatedTask = TaskModel(
                                                title:
                                                    _updateTitleController.text,
                                                isFinish: isFinishValue,
                                                id: data[index].id,
                                              );
                                              await _sqldbService
                                                  .updateData(updatedTask);
                                              Navigator.pop(context);
                                              _updateIsFinishController.clear();
                                              _updateTitleController.clear();
                                              setState(() {});
                                            }
                                          },
                                          child: const Text("Update"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Delete"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(data[index].title.toString()),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Orqaga")),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    _sqldbService.deleteData(
                                                        data[index].id!);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child:
                                                      const Text("O'chirish"))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          title: Text(data[index].title.toString()),
                          subtitle: Text(data[index].isFinish.toString()),
                          trailing: Text(data[index].id.toString()),
                        );
                      },
                      itemCount: data.length,
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            _sqldbService.insertData(TaskModel(
                title: _titleController.text,
                isFinish: int.parse(_isFinishController.text)));
            _titleController.clear();
            _isFinishController.clear();
            setState(() {});
          },
          label: const Text("save")),
    );
  }
}
