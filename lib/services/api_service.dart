import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/collaboratif_task_model.dart';

class ApiService {
   static const String baseUrl = 'http://127.0.0.1:8080/api';

  
  // ============ AUTHENTIFICATION ============
  
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      await _saveUserInfo(data);
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }
  
 static Future<Map<String, dynamic>> login(String email, String password) async {
  //  Nettoyer les anciennes données avant login
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    await _saveToken(data['token']);
    await _saveUserInfo(data);
    print('✅ Connexion réussie pour: ${data['email']}');
    return data;
  } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Login failed');
  }
}
  // ============ GESTION DES TÂCHES ============
  
  static Future<List<Task>> getTasks() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        dueDate: DateTime.parse(json['dueDate']),
        priority: json['priority'],
        isCompleted: json['isCompleted'],
      )).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }
  
  static Future<Task> createTask(Task task) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'priority': task.priority,
        'isCompleted': task.isCompleted,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task(
        id: data['id'],
        title: data['title'],
        description: data['description'] ?? '',
        dueDate: DateTime.parse(data['dueDate']),
        priority: data['priority'],
        isCompleted: data['isCompleted'],
      );
    } else {
      throw Exception('Failed to create task');
    }
  }
  
  static Future<Task> updateTask(Task task) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/${task.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'priority': task.priority,
        'isCompleted': task.isCompleted,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task(
        id: data['id'],
        title: data['title'],
        description: data['description'] ?? '',
        dueDate: DateTime.parse(data['dueDate']),
        priority: data['priority'],
        isCompleted: data['isCompleted'],
      );
    } else {
      throw Exception('Failed to update task');
    }
  }
  
  static Future<void> deleteTask(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
  
  static Future<Task> toggleTaskStatus(int id) async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/tasks/$id/toggle'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task(
        id: data['id'],
        title: data['title'],
        description: data['description'] ?? '',
        dueDate: DateTime.parse(data['dueDate']),
        priority: data['priority'],
        isCompleted: data['isCompleted'],
      );
    } else {
      throw Exception('Failed to toggle task status');
    }
  }
  
  // ============ TÂCHES COLLABORATIVES ============
  // ============ RÉCUPÉRER TOUTES LES TÂCHES (pour collaboratif) ============

static Future<List<CollaboratifTask>> fetchAllCollaborativeTasks() async {
  final token = await getToken();
  if (token == null) {
    print('❌ Token null');
    return [];
  }
  
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    print('📊 Status fetchAllCollaborativeTasks: ${response.statusCode}');
    print('📊 Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('✅ ${data.length} tâches collaboratives récupérées');
      
      return data.map((json) {
        // ✅ Afficher l'ID utilisateur pour debug
        print('  - Tâche: "${json['title']}" (user: ${json['userId']})');
        
        return CollaboratifTask(
          id: json['id'] ?? 0,
          title: json['title'] ?? 'Sans titre',
          description: json['description'] ?? '',
          completed: json['isCompleted'] ?? false,
          userId: json['userId'] ?? 0,  // ✅ userId dans le JSON
        );
      }).toList();
    } else {
      print('❌ Erreur: ${response.statusCode} - ${response.body}');
      return [];
    }
  } catch (e) {
    print('❌ Exception fetchAllCollaborativeTasks: $e');
    return [];
  }
}
  static Future<List<CollaboratifTask>> fetchUserCollaborativeTasks(int userId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Vous devez être connecté');
    }
    
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CollaboratifTask(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        completed: json['isCompleted'] ?? false,
        userId: json['userId'],
      )).toList();
    } else {
      throw Exception('Erreur chargement tâches utilisateur: ${response.statusCode}');
    }
  }
  
  // ============ UTILITAIRES ============
  
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }
  
  static Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}
  
  static Future<void> _saveUserInfo(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', data['id']);
    await prefs.setString('user_email', data['email']);
    await prefs.setString('user_name', data['name']);
  }
  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwt_token');
  }
  
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('user_id'),
      'email': prefs.getString('user_email'),
      'name': prefs.getString('user_name'),
    };
  }
}