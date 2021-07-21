import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:qr_test/model/visitor.dart';

class VisitorDb {
  static final VisitorDb instance = VisitorDb._init();

  static Database? _database;

  VisitorDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('visitor.db');
    return _database!;
  }

  Future<Database> _initDB(String name) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, name);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    // final boolType = 'BOOLEAN NOT NULL';
    // final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $visitor_table ( 
  ${VisitorFields.id} $idType, 
  ${VisitorFields.name} $textType,
  ${VisitorFields.number} $textType,
  ${VisitorFields.time} $textType

  )
''');
  }

  Future<Visitor> readVisitor(int id) async {
    final db = await instance.database;
    final maps = await db.query(visitor_table,
        columns: VisitorFields.values,
        where: '${VisitorFields.id}=?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Visitor.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Visitor>> readAllVisitors() async {
    final db = await instance.database;
    final orderBy = '${VisitorFields.time} ASC';
    final result = await db.query(visitor_table, orderBy: orderBy);

    return result.map((json) => Visitor.fromJson(json)).toList();
  }

  Future<Visitor> create(Visitor visitor) async {
    final db = await instance.database;
    final id = await db.insert(visitor_table, visitor.toJson());
    return visitor.copy(id: id);
  }
}
