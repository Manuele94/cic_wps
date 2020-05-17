import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbManager {
  static final DbManager _singleton = DbManager._internal(); //istanza singleton

  factory DbManager() =>
      _singleton; //istanza restituita quando viene chiamata dall'esterno
  DbManager._internal(); //viene reso il costruttore disponibile all'esterno

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return openDatabase(path.join(dbPath, 'user.db'), onCreate: (db, version) {
      db.execute(
          'CREATE TABLE user(id TEXT PRIMARY KEY,username TEXT,sUser TEXT,password TEXT,locationOfBelonging TEXT)');
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < newVersion) {
        db.execute("ALTER TABLE user ADD COLUMN locationOfBelonging TEXT;");
      }
    }, version: 2);
  }

  static Future<void> insert(String table, Map<String, Object> user) async {
    final db = await DbManager.database();
    db.insert(table, user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbManager.database();
    return db.query(table);
  }

  Future<void> modifyUserLocation(String table, String location) async {
    final dbUser = await getData(table);
    final user = dbUser.first;

    await DbManager.insert('user', {
      'id': user["id"],
      'username': user["username"],
      'sUser': user["s_User"],
      'password': user["password"],
      'locationOfBelonging': location
    });
  }

//  await DatabaseHandler.insert('user', {
//                 'id': 0,
//                 'username': response.getUserDetail.username,
//                 's_user': response.getUserDetail.s_user,
//                 'password': response.getUserDetail.password});

}
