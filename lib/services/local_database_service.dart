import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDataBaseService {
  static final LocalDataBaseService instance = LocalDataBaseService._init();
  static Database? _database;

  LocalDataBaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createTodoDB);
  }

  Future _createTodoDB(Database db, int version) async {
    try {
      const String createTodoTable = '''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
      )
      ''';
      await db.execute(createTodoTable);
    } catch (e) {
      throw Exception('Error creating DB: $e');
    }
  }

  Future<int> insertTodo(String table, Map<String, dynamic> values) async {
    try {
      final db = await instance.database;
    return await db.insert(table, values);
    } catch (e) {
      throw Exception('Error inserting todo: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTodos(String table) async {
    try {
      final db = await instance.database;
    return await db.query(table, orderBy: 'id DESC');
    } catch (e) {
      throw Exception('Error get todos: $e');
    }
    
  }

  Future<int> updateTodo(String table, Map<String, dynamic> values, String where, List<Object?> whereArgs) async {
    try {
      final db = await instance.database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw Exception('Error update todo: $e');}
  }

  Future<int> deleteTodo(String table, String where, List<Object?> whereArgs) async {
    try {
       final db = await instance.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw Exception('Error delete todo: $e');}
    }
  
  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
