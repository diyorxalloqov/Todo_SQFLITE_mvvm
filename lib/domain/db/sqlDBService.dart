import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/domain/model/data/TaskModel.dart';

class SQLDBService {
  final String tableName = 'Todo';
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
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  _onCreate(Database db, int newVersion) => db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, path TEXT, isFinish INTEGER)",
      );

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS $tableName");
    _onCreate(db, newVersion);
  }

  Future<List<TaskModel>> getALlData() async {
    var res = await ((await database)!.query(tableName));
    if (res.isNotEmpty) {
      List<TaskModel> data = res
          .map((e) => TaskModel(
              id: int.tryParse(e['id'].toString()),
              title: e['title'].toString(),
              isFinish: int.parse(e['isFinish'].toString())))
          .toList();
      return data;
    } else {
      return [];
    }
  }

  // / input data to db write function

  Future insertData(TaskModel data) async =>
      await ((await database)!.insert(tableName, data.toMap()));

  /// update data to db

  Future updateData(TaskModel data) async => await ((await database)!
      .update(tableName, data.toMap(), where: "id = ?", whereArgs: [data.id]));

  ///  delete data from db

  Future deleteData(int id) async => await ((await database)!
      .delete(tableName, where: "id = ?", whereArgs: [id]));

  /// delete database table

  Future deleteTable() async => await ((await database)!.delete(tableName));
}
