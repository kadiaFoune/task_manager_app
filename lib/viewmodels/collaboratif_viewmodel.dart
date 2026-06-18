import 'package:flutter/material.dart';
import '../models/collaboratif_task_model.dart';
import '../services/api_service.dart';

class CollaboratifViewModel extends ChangeNotifier {
  List<CollaboratifTask> _allTasks = [];
  List<CollaboratifTask> _filteredTasks = [];
  bool _isLoading = false;
  int? _currentUserId;

  // ✅ Rendre accessible pour le filtrage
  int? get currentUserId => _currentUserId;
  List<CollaboratifTask> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;

  // ✅ Récupérer l'ID de l'utilisateur connecté
  Future<void> _setCurrentUserId() async {
    try {
      final userInfo = await ApiService.getUserInfo();
      _currentUserId = userInfo['id'];
      print('👤 ID utilisateur connecté: $_currentUserId');
    } catch (e) {
      print('❌ Erreur récupération ID utilisateur: $e');
    }
  }

  // ✅ Récupérer TOUTES les tâches et filtrer
  Future<void> fetchAllTasks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _setCurrentUserId();
      
      _allTasks = await ApiService.fetchAllCollaborativeTasks();
      print('📊 Toutes les tâches reçues: ${_allTasks.length}');
      
      for (var task in _allTasks) {
        print('  - Tâche: "${task.title}" (user: ${task.userId})');
      }
      
      // ✅ Filtrer : exclure l'utilisateur connecté
      if (_currentUserId != null) {
        _filteredTasks = _allTasks.where((task) {
          return task.userId != _currentUserId;
        }).toList();
        print('📊 Tâches des autres utilisateurs: ${_filteredTasks.length}');
      } else {
        _filteredTasks = _allTasks;
      }
      
    } catch (e) {
      print('❌ Erreur fetchAllTasks: $e');
      _filteredTasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Récupérer les tâches d'un utilisateur spécifique
  Future<void> fetchUserTasks(int userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _setCurrentUserId();
      
      _allTasks = await ApiService.fetchAllCollaborativeTasks();
      print('📊 Toutes les tâches reçues: ${_allTasks.length}');
      
      if (_currentUserId != null) {
        _filteredTasks = _allTasks.where((task) {
          return task.userId == userId && task.userId != _currentUserId;
        }).toList();
        print('📊 Tâches de l\'utilisateur $userId (hors moi): ${_filteredTasks.length}');
      } else {
        _filteredTasks = _allTasks.where((task) {
          return task.userId == userId;
        }).toList();
      }
      
    } catch (e) {
      print('❌ Erreur fetchUserTasks: $e');
      _filteredTasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}