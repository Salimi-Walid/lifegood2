import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHobbies {
  static final SQLiteHobbies instance = SQLiteHobbies._init();
  static Database? _database;

  SQLiteHobbies._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hobbies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hobbies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        title TEXT,
        description TEXT,
        date TEXT,
        isReminderEnabled INTEGER,
        reminderTime TEXT,
        isDone INTEGER
      )
    ''');
  }

  Future<int> insertHobby(Map<String, dynamic> hobby) async {
    final db = await instance.database;
    return await db.insert('hobbies', hobby);
  }

  Future<List<Map<String, dynamic>>> getHobbies() async {
    final db = await instance.database;
    return await db.query('hobbies');
  }

  Future<int> deleteHobby(int id) async {
    final db = await instance.database;
    return await db.delete('hobbies', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateHobby(int id, Map<String, dynamic> updatedHobby) async {
    final db = await instance.database;
    return await db.update(
      'hobbies',
      updatedHobby,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
