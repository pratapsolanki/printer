import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../data/product.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "products";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}printer.db';
      _db =
          await openDatabase(path, version: _version, onCreate: (db, version) {
        debugPrint('Create a new one');
        var createTable = "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "productName STRING,productImage STRING,"
            "price REAL,productDescription STRING,"
            "qty INTEGER,"
            "date STRING)";
        debugPrint('query $createTable');
        return db.execute(createTable);
      });
    } catch (e) {
      debugPrint("error");
      debugPrint(e.toString());
    }
  }

  static Future<int> insert(Product? product) async {
    return await _db?.insert(_tableName, product!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(Product product) async {
    return await _db!
        .delete(_tableName, where: "id=?", whereArgs: [product.id]);
  }

  static Future<int> updateProduct(Product? product) async {
    return await _db?.update(_tableName, product!.toJson()) ?? 1;
  }

  static updateQty(int id, int qty) async {
    return await _db!.rawUpdate('''
    UPDATE products
    SET qty = ?
    WHERE id = ?
    ''', [qty, id]);
  }
}
