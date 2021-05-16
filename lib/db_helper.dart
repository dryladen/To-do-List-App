import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'Task.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id',
      TODO = 'todo',
      TANGGAL = 'tanggal',
      TABLE = 'task',
      DB_NAME = 'task.db';

  /* Check if the database exits or not. If not make one and return it */
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /*  */
  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $TODO TEXT, $TANGGAL TEXT)");
  }

  Future<Task> save(Task task) async {
    var dbClient = await db;
    task.id = await dbClient.insert(TABLE, task.toMap());
    return task;

    // await dbClient.transaction((txn) {
    //   var query = "INSERT INTO $TABLE ($TODO) VALUES ('" + task.todo + "')";
    //   return await txn.rawInsert(query);
    // });
  }

  Future<List<Task>> getTask() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TABLE, columns: [ID, TODO]);
    // List<Map> maps = dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Task> tasks = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i -= -1) {
        tasks.add(Task.fromMap(maps[i]));
      }
    }
    return tasks;
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async{
    var dbClient = await db;

    return await dbClient.update(TABLE, task.toMap(), where: '$ID = ?', whereArgs: [task.id]);
  }

  Future closeDB() async{
    var dbClient = await db;
    dbClient.close();
  }

}
