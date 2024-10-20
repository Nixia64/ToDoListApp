import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoLDB {
  static final TodoLDB _instance = TodoLDB._internal();
  factory TodoLDB() => _instance;
  TodoLDB._internal();

  late final Database database;

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE categories('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'count INT)'
    );
    await db.execute(
        'CREATE TABLE tasks('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'over INTEGER, '
            'category_id INTEGER, '
            'FOREIGN KEY(category_id) REFERENCES categories(id) '
            'ON DELETE CASCADE)'
    );
  }

  open() async {
    database = await openDatabase(
        join(await getDatabasesPath(), 'todolist.db'),
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        });
  }

}