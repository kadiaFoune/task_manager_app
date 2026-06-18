import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = '';
  String _filterType = 'all';
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted && !t.isOverdue).length;
  int get overdueTasks => _tasks.where((t) => t.isOverdue).length;
  int get todayTasks => _tasks.where((t) => 
    !t.isCompleted && 
    t.dueDate.day == DateTime.now().day &&
    t.dueDate.month == DateTime.now().month &&
    t.dueDate.year == DateTime.now().year
  ).length;

  TaskViewModel() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _tasks = await ApiService.getTasks();
      applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final newTask = await ApiService.createTask(task);
      _tasks.add(newTask);
      applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await ApiService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        applyFilters();
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await ApiService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    try {
      final updatedTask = await ApiService.toggleTaskStatus(task.id!);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        applyFilters();
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }
// ✅ Forcer le rechargement des tâches
Future<void> refreshTasks() async {
  await loadTasks();
  print('🔄 Tâches rechargées');
}
  void setSearchQuery(String query) {
    _searchQuery = query;
    applyFilters();
  }

  void setFilterType(String filterType) {
    _filterType = filterType;
    applyFilters();
  }

void applyFilters() {
  var filtered = List<Task>.from(_tasks);
  
  if (_searchQuery.isNotEmpty) {
    filtered = filtered.where((task) =>
      task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      task.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }
  
  switch (_filterType) {
    case 'completed':
      filtered = filtered.where((t) => t.isCompleted).toList();
      break;
    case 'today':  // ✅ AJOUTEZ CE CASE
      filtered = filtered.where((t) => 
        !t.isCompleted && 
        t.dueDate.day == DateTime.now().day &&
        t.dueDate.month == DateTime.now().month &&
        t.dueDate.year == DateTime.now().year
      ).toList();
      break;
    case 'pending':
      filtered = filtered.where((t) => !t.isCompleted && !t.isOverdue).toList();
      break;
    case 'overdue':
      filtered = filtered.where((t) => t.isOverdue).toList();
      break;
  }
  
  _filteredTasks = filtered;
  notifyListeners();
}
  // ============ RÉINITIALISATION ============

void clearTasks() {
  _tasks = [];
  _filteredTasks = [];
  _searchQuery = '';
  _filterType = 'all';
  _errorMessage = null;
  _isLoading = false;
  notifyListeners();
  print('🧹 Tâches vidées');
}
}