import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SubmitDataHobies with ChangeNotifier {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

 Future<Database> _initDatabase() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'hobiesdata.db');
  
  print('Database Path: $path'); // Debugging line
  
  try {
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE mytable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            selection TEXT,
            date TEXT,
            title TEXT,
            Descreption TEXT,
            ischeckerd INTEGER,
            timeremaind TEXT,
            isdaned INTEGER DEFAULT 0
          )
        ''');
        print("Database table created successfully!");
      },
    );
  } catch (e) {
    print("Error creating database: $e");
    rethrow;
  }
}
}
