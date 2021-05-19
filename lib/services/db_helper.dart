import 'dart:async';
import 'package:path/path.dart';
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
      String _path = await getDatabasesPath();
      print('PATH : $_path');
      _db = await openDatabase(join(await getDatabasesPath(), 'todotable.db'), version: _version, onCreate: onCreate);
      print('DB: $_db');
      print("SUDAH");
    } catch (ex) {
      print('Error: ' + ex);
    }
  }

  static void onCreate(Database db, int version) async => await db.execute(
      'CREATE TABLE todotable (id INTEGER PRIMARY KEY NOT NULL, task STRING, tanggal STRING)');

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async => await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

}
