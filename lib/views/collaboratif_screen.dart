import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../viewmodels/collaboratif_viewmodel.dart';
import '../models/collaboratif_task_model.dart';
import '../services/api_service.dart';

class CollaboratifScreen extends StatefulWidget {
  const CollaboratifScreen({super.key});

  @override
  State<CollaboratifScreen> createState() => _CollaboratifScreenState();
}

class _CollaboratifScreenState extends State<CollaboratifScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedUserId;
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCurrentUser();
    await _loadUsers();
    _loadAllTasks();
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await ApiService.getUserInfo();
      print('👤 Utilisateur connecté: ${_currentUser?['email']} (ID: ${_currentUser?['id']})');
    } catch (e) {
      print('❌ Erreur chargement utilisateur courant: $e');
    }
  }

  Future<void> _loadUsers() async {
    try {
      final token = await ApiService.getToken();
      if (token == null) {
        print('❌ Token null');
        return;
      }
      
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('📊 ${data.length} utilisateurs récupérés');
        
        _users = data.map((user) => {
          'id': user['id'],
          'name': user['name'] ?? 'Utilisateur ${user['id']}',
          'email': user['email'],
        }).toList();
        
        if (_currentUser != null) {
          final filteredUsers = _users.where((u) => u['id'] != _currentUser!['id']).toList();
          if (filteredUsers.isNotEmpty) {
            _selectedUserId = filteredUsers[0]['id'];
            print('🔍 Utilisateur sélectionné: ${filteredUsers[0]['name']} (ID: $_selectedUserId)');
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('❌ Erreur chargement utilisateurs: $e');
    }
  }

  void _loadAllTasks() {
    final viewModel = Provider.of<CollaboratifViewModel>(context, listen: false);
    viewModel.fetchAllTasks();
  }

  void _loadUserTasks(int userId) {
    final viewModel = Provider.of<CollaboratifViewModel>(context, listen: false);
    viewModel.fetchUserTasks(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tâches collaboratives'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tous les utilisateurs'),
            Tab(text: 'Par utilisateur'),
          ],
          onTap: (index) {
            if (index == 1 && _selectedUserId != null) {
              _loadUserTasks(_selectedUserId!);
            } else if (index == 0) {
              _loadAllTasks();
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllTasksTab(),
          _buildUserTasksTab(),
        ],
      ),
    );
  }

  Widget _buildAllTasksTab() {
    return Consumer<CollaboratifViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ✅ Filtrage direct dans la vue
        final filteredTasks = viewModel.tasks.where((task) {
          final currentUserId = viewModel.currentUserId;
          return currentUserId == null || task.userId != currentUserId;
        }).toList();

        if (filteredTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucune tâche des autres utilisateurs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Les tâches que vous créez sont personnelles',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.fetchAllTasks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return _buildTaskCard(task);
            },
          ),
        );
      },
    );
  }

  Widget _buildUserTasksTab() {
    final filteredUsers = _users.where((user) {
      if (_currentUser == null) return true;
      return user['id'] != _currentUser!['id'];
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<int>(
            value: _selectedUserId,
            decoration: InputDecoration(
              labelText: 'Sélectionner un utilisateur',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            items: filteredUsers.map((user) {
              return DropdownMenuItem<int>(
                value: user['id'],
                child: Text(user['name'] ?? 'Utilisateur ${user['id']}'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedUserId = value;
                });
                _loadUserTasks(value);
              }
            },
          ),
        ),
        Expanded(
          child: Consumer<CollaboratifViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune tâche pour cet utilisateur',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cet utilisateur n\'a pas encore créé de tâches',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.tasks.length,
                itemBuilder: (context, index) {
                  final task = viewModel.tasks[index];
                  return _buildTaskCard(task);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(CollaboratifTask task) {
    String statutTexte = task.completed ? 'Terminée' : 'En cours';
    Color statutCouleur = task.completed ? Colors.green : Colors.orange;
    
    String userName = 'Utilisateur ${task.userId}';
    final user = _users.firstWhere((u) => u['id'] == task.userId, orElse: () => {});
    if (user.isNotEmpty && user['name'] != null) {
      userName = user['name'];
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statutCouleur.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statutCouleur),
                  ),
                  child: Text(
                    statutTexte,
                    style: TextStyle(
                      color: statutCouleur,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  task.completed ? Icons.check_circle : Icons.pending,
                  size: 16,
                  color: task.completed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  task.completed ? 'Terminée' : 'En attente',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}