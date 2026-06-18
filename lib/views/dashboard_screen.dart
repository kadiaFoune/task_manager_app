import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';
import 'my_tasks_screen.dart';
import 'collaboratif_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardContent(),
    MyTasksScreen(),
    CollaboratifScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Mes tâches',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Collaboratif',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    
    // Forcer le chargement des tâches à chaque affichage du dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskViewModel.loadTasks();
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await taskViewModel.loadTasks();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bon retour !',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Voici le résumé de vos tâches',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    context,
                    'Total',
                    taskViewModel.totalTasks,
                    Colors.blue,
                    Icons.task,
                  ),
                  _buildStatCard(
                    context,
                    'Terminées',
                    taskViewModel.completedTasks,
                    Colors.green,
                    Icons.check_circle,
                  ),
                  _buildStatCard(
                    context,
                    'En cours',
                    taskViewModel.pendingTasks,
                    Colors.orange,
                    Icons.pending_actions,
                  ),
                  _buildStatCard(
                    context,
                    'En retard',
                    taskViewModel.overdueTasks,
                    Colors.red,
                    Icons.warning,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tâches du jour',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      // ✅ Navigation vers Mes tâches avec filtre "Tâches du jour"
                      _navigateToTasks(context, 'today');
                    },
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (taskViewModel.todayTasks > 0)
                Card(
                  child: InkWell(
                    onTap: () {
                      // ✅ Navigation vers Mes tâches avec filtre "Tâches du jour"
                      _navigateToTasks(context, 'today');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.today, color: Colors.blue),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tâches pour aujourd\'hui',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${taskViewModel.todayTasks} tâche(s) à réaliser',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.check_circle, color: Colors.green),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Aucune tâche pour aujourd\'hui',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Profitez de votre journée !',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int count, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Méthode pour naviguer vers Mes tâches avec un filtre
  void _navigateToTasks(BuildContext context, String filter) {
    // Changer l'index pour aller à "Mes tâches" (index 1)
    final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
    if (dashboardState != null) {
      dashboardState._selectedIndex = 1;
      dashboardState.setState(() {});
    }
    
    // Appliquer le filtre "Tâches du jour"
    if (filter == 'today') {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      taskViewModel.setFilterType('pending');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Affichage des tâches du jour'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}