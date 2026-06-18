import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_screen.dart';

class MyTasksScreen extends StatefulWidget {
  final String? initialFilter;
  
  const MyTasksScreen({super.key, this.initialFilter});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  final _searchController = TextEditingController();
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'all';
    
    // Appliquer le filtre initial si présent
    if (widget.initialFilter != null && widget.initialFilter == 'today') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
        taskViewModel.setFilterType('pending');
        _selectedFilter = 'pending';
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une tâche...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          Provider.of<TaskViewModel>(context, listen: false)
                              .setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                Provider.of<TaskViewModel>(context, listen: false)
                    .setSearchQuery(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Toutes', 'all'),
                        const SizedBox(width: 8),
                         _buildFilterChip('Aujourd\'hui', 'today'),  
                        _buildFilterChip('Terminées', 'completed'),
                        const SizedBox(width: 8),
                        _buildFilterChip('En cours', 'pending'),
                        const SizedBox(width: 8),
                        _buildFilterChip('En retard', 'overdue'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<TaskViewModel>(
              builder: (context, taskViewModel, child) {
                if (taskViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (taskViewModel.tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune tâche',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Appuyez sur le bouton + pour ajouter une tâche',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: taskViewModel.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskViewModel.tasks[index];
                    return TaskCard(
                      task: task,
                      onToggle: () {
                        taskViewModel.toggleTaskStatus(task);
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditTaskScreen(task: task),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteDialog(context, taskViewModel, task);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
         
        });
        Provider.of<TaskViewModel>(context, listen: false)
            .setFilterType(_selectedFilter);
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TaskViewModel viewModel, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: Text('Voulez-vous vraiment supprimer "${task.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteTask(task.id!);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}