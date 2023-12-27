import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/model/TaskModel.dart';

class SQLDBService {
  final String allTableName = 'Todo';
  final String completedTableName = 'completed';

  SQLDBService._init();

  static final SQLDBService _db = SQLDBService._init();

  factory SQLDBService() => _db;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return openDatabase(join(documentsDirectory.path, 'task_database.data.db'),
        version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  _onCreate(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $allTableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, detail TEXT)",
    );
    await db.execute(
      "CREATE TABLE $completedTableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, detail TEXT)",
    );
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS $allTableName");
    await db.execute(
      "CREATE TABLE $allTableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, detail TEXT)",
    );
    await db.execute("DROP TABLE IF EXISTS $completedTableName");
    await db.execute(
      "CREATE TABLE $completedTableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, detail TEXT)",
    );
  }

  // get Todos all
  Future<List<TaskModel>> getALlData() async {
    var res = await ((await database)!.query(allTableName));
    if (res.isNotEmpty) {
      List<TaskModel> data = res
          .map((e) => TaskModel(
              id: int.tryParse(e['id'].toString()),
              title: e['title'].toString(),
              detail: e['detail'].toString()))
          .toList();
      return data;
    } else {
      return [];
    }
  }

  // / input data to db write function

  Future insertData(TaskModel data) async =>
      await ((await database)!.insert(allTableName, data.toMap()));

  /// update data to db

  Future updateData(TaskModel data) async =>
      await ((await database)!.update(allTableName, data.toMap(),
          where: "id = ?", whereArgs: [data.id]));

  ///  delete data from db

  Future deleteData(int id) async => await ((await database)!
      .delete(allTableName, where: "id = ?", whereArgs: [id]));

  /// delete database table
  Future deleteTable() async => await ((await database)!.delete(allTableName));

  ///
  ///  completed todos
  Future<List<TaskModel>> getALlTodosCompleted() async {
    var res = await ((await database)!.query(completedTableName));
    if (res.isNotEmpty) {
      List<TaskModel> data = res
          .map((e) => TaskModel(
              id: int.tryParse(e['id'].toString()),
              title: e['title'].toString(),
              detail: e['detail'].toString()))
          .toList();
      return data;
    } else {
      return [];
    }
  }

  // / input data to db write function

  Future insertCompletedTodos(TaskModel data) async =>
      await ((await database)!.insert(completedTableName, data.toMap()));

  ///  delete data from db

  Future deleteCompletedTodos(int id) async => await ((await database)!
      .delete(completedTableName, where: "id = ?", whereArgs: [id]));
}
