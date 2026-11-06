import '../../../core/localization/app_localizations.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime? dueDate;
  final DateTime? reminderAt;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.priority,
    this.dueDate,
    this.reminderAt,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'reminder_at': reminderAt?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      category: map['category'] as String,
      priority: map['priority'] as String,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      reminderAt: map['reminder_at'] != null
          ? DateTime.parse(map['reminder_at'])
          : null,
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  TaskModel copyWith({
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? dueDate,
    DateTime? reminderAt,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      reminderAt: reminderAt ?? this.reminderAt,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
