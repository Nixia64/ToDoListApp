import 'package:dart_tp_note/database.dart';
import 'package:dart_tp_note/model/category.dart';
import '../model/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepository extends ChangeNotifier{
  final _tableName = 'tasks';
  final Database _db = TodoLDB().database;
  late List<Task> _list = [];

  TaskRepository() {
    _db.query(_tableName).then((data) {
      _list = data.map((e) => Task.fromMap(e)).toList();
      notifyListeners();
    });
  }

  int get count => _list.length;
  Task get(int index) => _list[index];

  insert(Task task) async {
    _list.add(task);
    await _db.insert(_tableName, task.toMap());
    notifyListeners();
  }

  update(Task task) async {
    await _db.update(_tableName, task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id]);
    notifyListeners();
  }

  delete(Task task) async {
    _list.remove(task);
    await _db.delete(_tableName,
        where: 'id = ?',
        whereArgs: [task.id]);
    notifyListeners();
  }

  Future<int> getCount(Category category) async {
    final count = await _db.query(_tableName,
        where: 'category_id = ?',
        whereArgs: [category.id]);
    return count.length;
  }

  Future<List<Task>> getAll(Category category) async {
    List<Map<String, dynamic>> maps = await _db.query(
      _tableName,
      where: 'category_id = ?',
      whereArgs: [category.id]
    );
    return maps.map((e) => Task.fromMap(e)).toList();
  }
}