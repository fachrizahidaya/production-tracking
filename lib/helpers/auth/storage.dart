import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  static final Storage instance = Storage._init();
  static Database? _database;

  Storage._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            access_token TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE menus (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            menu_data TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE menus (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              menu_data TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> insertUserData(Map<String, dynamic> userData) async {
    final db = await instance.database;
    await db.insert(
        'user',
        {
          // 'user_id': userData['user_id'].toString(),
          'access_token': userData['access_token'].toString(),
          'username': userData['username'] ?? '',
          // 'name': userData['name'] ?? '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final db = await instance.database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearUserData() async {
    final db = await instance.database;
    await db.delete('user');
  }

  Future<String?> getAccessToken() async {
    final db = await instance.database;
    final result = await db.query('user', columns: ['access_token'], limit: 1);

    if (result.isNotEmpty) {
      return result.first['access_token'] as String?;
    }
    return null;
  }

  Future<void> insertMenus(List<dynamic> menus) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      await txn.delete('menus'); // Clear old data

      for (var menu in menus) {
        await txn.insert('menus', {
          'menu_data': jsonEncode(menu),
        });
      }
    });
  }

  Future<List<dynamic>> getMenus() async {
    final db = await instance.database;
    final result = await db.query('menus', columns: ['menu_data']);
    if (result.isEmpty) return [];

    // Decode each stored JSON menu
    return result.map((row) => jsonDecode(row['menu_data'] as String)).toList();
  }

  Future<void> clearMenus() async {
    final db = await instance.database;
    await db.delete('menus');
  }
}
