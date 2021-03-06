import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/model/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;

  

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      Directory _path = await getApplicationDocumentsDirectory();
      print('PATH : $_path.');
      _db = await openDatabase(join(_path.path, 'TodoDatabase.db'),
          version: _version, onCreate: onCreate);
      print('DB: $_db');
      print("SUDAH");
    } catch (ex) {
      print('Error: ' + ex);
    }
  }

  static Future<void> dropTable() async {
    if (_db == null) {
      return;
    }
    try {
      Directory _path = await getApplicationDocumentsDirectory();
      print(_path.path);
      _db = await openDatabase(join(await getDatabasesPath(), 'todoTable.db'),
          version: _version);
      onDrop(_db, _version);
      print("Sudah dihapus");
    } catch (ex) {
      print('Error: ' + ex);
    }
  }

  static void onDrop(Database db, int version) async =>
      await db.execute('DROP TABLE IF EXISTS todoTable');

  static void onCreate(Database db, int version) async => await db.execute(
      'CREATE TABLE ${ToDo.table} (id INTEGER PRIMARY KEY NOT NULL, task STRING, tanggal STRING, jam STRING, dateTime STRING, isDone INTEGER NOT NULL)');

  static Future<List<Map<dynamic, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
