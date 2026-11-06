import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/tasks/models/task_model.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      AppConstants.databaseName,
    );

    return openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tasksTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority TEXT NOT NULL,
        due_date TEXT,
        reminder_at TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_due_date
      ON ${AppConstants.tasksTable} (due_date)
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_completed
      ON ${AppConstants.tasksTable} (is_completed)
    ''');
  }

  // CREATE
  Future<int> insertTask(TaskModel task) async {
    final db = await database;

    return db.insert(
      AppConstants.tasksTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ ALL
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;

    final result = await db.query(
      AppConstants.tasksTable,
      orderBy: 'created_at DESC',
    );

    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  // READ SINGLE
  Future<TaskModel?> getTaskById(String id) async {
    final db = await database;

    final result = await db.query(
      AppConstants.tasksTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return TaskModel.fromMap(result.first);
  }

  // UPDATE
  Future<int> updateTask(TaskModel task) async {
    final db = await database;

    return db.update(
      AppConstants.tasksTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(String id) async {
    final db = await database;

    return db.delete(
      AppConstants.tasksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL
  Future<int> deleteAllTasks() async {
    final db = await database;

    return db.delete(AppConstants.tasksTable);
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
