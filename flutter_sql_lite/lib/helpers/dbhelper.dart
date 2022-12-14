import 'dart:io';
import 'dart:async';

import 'package:flutter_sql_lite/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  DbHelper._createObject();
  factory DbHelper() {
    if (_dbHelper == null) _dbHelper = DbHelper._createObject();
    return _dbHelper!;
  }

  //method untuk membuat database dan return objek database yang telah dibuat
  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db'; //path database
    //perintah untuk hapus database: await deleteDatabase(path);
    // Delete the database
    //await deleteDatabase(path);

    //method openDatabase akan create sebuah database dan menyimpannya pada path
    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  //method call back _createDb
  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL UNIQUE,password TEXT NOT NULL,email TEXT NOT NULL UNIQUE)");
    await db.execute(
        "CREATE TABLE profiles (id INTEGER PRIMARY KEY AUTOINCREMENT,id_user INTEGER NOT NULL, fullname TEXT,phone TEXT,address TEXT)");
    await db.execute(
        "CREATE TABLE tugas (id INTEGER PRIMARY KEY AUTOINCREMENT,matakuliah Text NOT NULL, uraian_tugas TEXT NOT NULL,deadline DATE NOT NULL,status Text NOT NULL)");
  }

  //method untuk mengecek apakah DB sudah ada? kalau belum create DB, selanjutnya dia return objek database
  Future<Database> getDatabase() async {
    //await initDb();
    if (_database == null) _database = await initDb();
    return _database!;
  }

  Future<int> insertUser(User object) async {
    Database db = await this.getDatabase();
    int count = 0;
    try {
      count = await db.insert('users', object.toMap());
    } catch (e) {
      print(e.toString());
    }
    return count;
  }

  //Read
  Future<List<Map<String, dynamic>>> selectUser(
      String username, String password) async {
    Database db = await this.getDatabase();
    var mapList = await db.query('users',
        where: "username='$username' AND password='$password'");
    return mapList;
  }

  //Read
  Future<List<Map<String, dynamic>>> selectAllUser() async {
    Database db = await this.getDatabase();
    var mapList = await db.query('users');
    return mapList;
  }

  Future<int> deleteAllUsers() async {
    Database db = await this.getDatabase();
    int count = await db.delete('users');
    return count;
  }

  Future<int> updateUserPassword(int idUser, String password) async {
    Database db = await this.getDatabase();
    //pakai rawupdate tidak perlu tipe objek map
    int count = await db.rawUpdate(
        'UPDATE users SET password = ? WHERE id = ?', ['$password', '$idUser']);
    return count;
  }

  Future<int> updateUserEmail(int idUser, String email) async {
    Database db = await this.getDatabase();
    //pakai rawupdate tidak perlu tipe objek map
    int count = await db.rawUpdate(
        'UPDATE users SET email = ? WHERE id = ?', ['$email', '$idUser']);
    return count;
  }

  //Read
  Future<List<Map<String, dynamic>>> selectUserOnId(int id) async {
    Database db = await this.getDatabase();
    var mapList = await db.query('users', where: "id='$id' ");
    return mapList;
  }

  /*Future<int> insertTugas(Tugas object) async {
    Database db = await this.getDatabase();
    print(object.toMap());
    int count = await db.insert('tugas', object.toMap());
    return count;
  }

  //Read
  Future<List<Map<String, dynamic>>> selectAllTugas() async {
    var mapList;
    Database db = await this.getDatabase();
    try {
      mapList = await db.query('tugas');
    } catch (e) {}
    return mapList;
  }

  Future<int> updateStatusTugas(int id, String status) async {
    Database db = await this.getDatabase();
    //pakai rawupdate tidak perlu tipe objek map
    int count = await db.rawUpdate(
        'UPDATE tugas SET status = ? WHERE id = ?', ['$status', '$id']);
    return count;
  }*/
}
