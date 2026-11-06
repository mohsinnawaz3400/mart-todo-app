import 'package:flutter/material.dart';
import 'task_controller.dart';

class TaskFilterState extends ChangeNotifier {
  String _query = '';
  String _category = 'All';
  String _status = 'All';
  TaskSort _sort = TaskSort.dueDate;

  String get query => _query;
  String get category => _category;
  String get status => _status;
  TaskSort get sort => _sort;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setSort(TaskSort value) {
    _sort = value;
    notifyListeners();
  }

  void clear() {
    _query = '';
    _category = 'All';
    _status = 'All';
    _sort = TaskSort.dueDate;
    notifyListeners();
  }
}
