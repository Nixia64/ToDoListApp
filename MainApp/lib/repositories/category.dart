import 'package:dart_tp_note/database.dart';
import 'package:dart_tp_note/model/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository extends ChangeNotifier{
  final _tableName = 'categories';
  final Database _db = TodoLDB().database;
  late List<Category> _list = [];

  CategoryRepository() {
    _db.query(_tableName).then((data) {
      _list = data.map((e) => Category.fromMap(e)).toList();
      notifyListeners();
    });
  }

  int get count => _list.length;
  Category get(int index) => _list[index];

  insert(Category category) async {
    _list.add(category);
    await _db.insert(_tableName, category.toMap());
    notifyListeners();
  }

  update(Category category) async {
    await _db.update(_tableName, category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id]);
    notifyListeners();
  }

  delete(Category category) async {
    _list.remove(category);
    await _db.delete(_tableName,
        where: 'id = ?',
        whereArgs: [category.id]);
    notifyListeners();
  }

  Future<List<Category>> getAll() async {
    List<Map<String, dynamic>> maps = await _db.query(
        _tableName,
    );
    return maps.map((e) => Category.fromMap(e)).toList();
  }
}