import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'task_viewmodel.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
class AuthViewModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userName = '';
  String _userEmail = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await ApiService.isLoggedIn();
    if (_isAuthenticated) {
      final userInfo = await ApiService.getUserInfo();
      _userName = userInfo['name'] ?? '';
      _userEmail = userInfo['email'] ?? '';
    }
    notifyListeners();
  }

Future<bool> login(String email, String password) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();
  
  try {
    // ✅ Nettoyer les anciennes données
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    final userData = await ApiService.login(email, password);
    _isAuthenticated = true;
    _userEmail = userData['email'];
    _userName = userData['name'];
    _errorMessage = null;
    print('✅ Utilisateur connecté: $_userEmail');
    return true;
  } catch (e) {
    _errorMessage = e.toString();
    print('❌ Erreur login: $e');
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final userData = await ApiService.register(name, email, password);
      _isAuthenticated = true;
      _userEmail = email;
      _userName = name;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Future<void> logout() async {
  // ✅ Vider les tâches avant la déconnexion
  final taskViewModel = TaskViewModel();
  taskViewModel.clearTasks();
  
  await ApiService.logout();
  _isAuthenticated = false;
  _userName = '';
  _userEmail = '';
  _errorMessage = null;
  notifyListeners();
  print('🔓 Déconnecté - données vidées');
}
}