import 'package:flutter/material.dart';

import '../../../core/database/database_helper.dart';
import '../models/task_model.dart';

enum TaskSort { dueDate, newest, oldest, priority, titleAZ, titleZA }

class TaskController extends ChangeNotifier {
  final DatabaseHelper _database = DatabaseHelper.instance;

  List<TaskModel> _tasks = [];

  bool _isLoading = false;
  String? _error;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  bool get isLoading => _isLoading;

  String? get error => _error;

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  bool _isBeforeToday(DateTime date) {
    final today = DateUtils.dateOnly(DateTime.now());
    return DateUtils.dateOnly(date).isBefore(today);
  }

  bool isToday(DateTime? date) {
    if (date == null) return false;
    return DateUtils.isSameDay(date, DateTime.now());
  }

  bool _isTaskOverdue(TaskModel task) {
    if (task.isCompleted) return false;

    if (task.dueDate != null && _isBeforeToday(task.dueDate!)) {
      return true;
    }

    if (task.reminderAt != null &&
        DateUtils.isSameDay(task.reminderAt, DateTime.now()) &&
        DateTime.now().isAfter(task.reminderAt!)) {
      return true;
    }

    return false;
  }

  int get overdueTasks => _tasks.where(_isTaskOverdue).length;

  double get completionPercentage {
    if (totalTasks == 0) return 0;
    return completedTasks / totalTasks;
  }

  List<TaskModel> get todayTasks {
    final result = _tasks.where((task) => isToday(task.dueDate)).toList();

    result.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      if (a.reminderAt == null && b.reminderAt == null) {
        return _compareTasksByDate(a, b);
      }

      if (a.reminderAt == null) return 1;
      if (b.reminderAt == null) return -1;

      return a.reminderAt!.compareTo(b.reminderAt!);
    });

    return result;
  }

  List<TaskModel> get upcomingTasks {
    final today = DateUtils.dateOnly(DateTime.now());

    return _tasks.where((task) {
      if (task.isCompleted || task.dueDate == null) {
        return false;
      }

      return DateUtils.dateOnly(task.dueDate!).isAfter(today);
    }).toList()..sort(_compareTasksByDate);
  }

  List<TaskModel> get overdueTaskList {
    return _tasks.where(_isTaskOverdue).toList()..sort(_compareTasksByDate);
  }

  List<TaskModel> get sortedTasks {
    final result = [..._tasks];

    result.sort((a, b) {
      final aToday = isToday(a.dueDate);
      final bToday = isToday(b.dueDate);

      if (aToday != bToday) {
        return aToday ? -1 : 1;
      }

      return _compareTasksByDate(a, b);
    });

    return result;
  }

  int _compareTasksByDate(TaskModel a, TaskModel b) {
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;

    return a.dueDate!.compareTo(b.dueDate!);
  }

  // LOAD TASKS
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _database.getAllTasks();
    } catch (e) {
      _error = e.toString();
      debugPrint('Load tasks error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ADD TASK
  Future<void> addTask({
    required String title,
    required String description,
    required String category,
    required String priority,
    DateTime? dueDate,
    DateTime? reminderAt,
  }) async {
    final now = DateTime.now();

    final task = TaskModel(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      priority: priority,
      dueDate: dueDate,
      reminderAt: reminderAt,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    await _database.insertTask(task);
    await loadTasks();
  }

  // UPDATE TASK
  Future<void> updateTask(TaskModel task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());

    await _database.updateTask(updatedTask);
    await loadTasks();
  }

  // TOGGLE COMPLETION
  Future<void> toggleTask(TaskModel task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );

    await _database.updateTask(updatedTask);
    await loadTasks();
  }

  // DELETE TASK
  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);
    await loadTasks();
  }

  // CLEAR COMPLETED TASKS
  Future<void> clearCompletedTasks() async {
    final completed = _tasks.where((task) => task.isCompleted).toList();

    for (final task in completed) {
      await _database.deleteTask(task.id);
    }

    await loadTasks();
  }

  // SEARCH AND FILTER
  List<TaskModel> filterTasks({
    String query = '',
    String category = 'All',
    String status = 'All',
    TaskSort sort = TaskSort.dueDate,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    final result = _tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(normalizedQuery) ||
          task.description.toLowerCase().contains(normalizedQuery);

      final matchesCategory = category == 'All' || task.category == category;

      final matchesStatus = switch (status) {
        'Pending' => !task.isCompleted && !_isTaskOverdue(task),
        'Completed' => task.isCompleted,
        'Overdue' => _isTaskOverdue(task),
        _ => true,
      };

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();

    result.sort((a, b) {
      switch (sort) {
        case TaskSort.dueDate:
          return _compareTasksByDate(a, b);

        case TaskSort.newest:
          return b.createdAt.compareTo(a.createdAt);

        case TaskSort.oldest:
          return a.createdAt.compareTo(b.createdAt);

        case TaskSort.priority:
          const priorityOrder = {'high': 0, 'medium': 1, 'low': 2};

          return (priorityOrder[a.priority.toLowerCase()] ?? 3).compareTo(
            priorityOrder[b.priority.toLowerCase()] ?? 3,
          );

        case TaskSort.titleAZ:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());

        case TaskSort.titleZA:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      }
    });

    return result;
  }
}
