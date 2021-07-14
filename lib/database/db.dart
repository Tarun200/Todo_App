import 'dart:async';
import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'as p;
import 'package:todo_app/database/model.dart';
abstract class Db{
  static Database? _db;
   static Future init() async{
    try{
      String _path = await getDatabasesPath();
      String _databasepath = p.join(_path,'todolist.db');
      _db = await openDatabase(_databasepath, version: 1,onCreate: onCreate);
    }
    catch(e){
      print(e);
    }
  }
  static void onCreate(Database db,int version) async {
    await db.execute('CREATE TABLE todo (id INTEGER PRIMARY KEY NOT NULL,name STRING)');
  }
   static Future<List<Map<String,dynamic>>> query(String table) async =>
     await _db!.query(table);
   static Future<int> insert(String table,ToDoAttributes todo) async=>
       await _db!.insert(table, todo.toMap());
   static Future<int> delete(String table,ToDoAttributes todo) async=>
       await _db!.delete(table,where: 'id = ?',whereArgs: [todo.id]);
}