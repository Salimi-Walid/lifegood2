import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteTodos {
  static final SQLiteTodos instance = SQLiteTodos._init();
  static Database? _database;

  SQLiteTodos._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo);
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await instance.database;
    return await db.query('todos');
  }

  Future<int> updateTodo(int id, Map<String, dynamic> updatedTodo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      updatedTodo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
