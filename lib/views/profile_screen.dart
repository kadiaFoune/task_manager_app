import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../main.dart';
import 'login_screen.dart';
import '../viewmodels/task_viewmodel.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, authViewModel),
            const SizedBox(height: 24),
            _buildProfileInfo(context, authViewModel),
            const SizedBox(height: 24),
            _buildActionsCard(context, authViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthViewModel authViewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            authViewModel.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            authViewModel.userEmail,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, AuthViewModel authViewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations du compte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.email, 'Email', authViewModel.userEmail),
            const Divider(),
            _buildInfoRow(Icons.person, 'Nom d\'utilisateur', authViewModel.userName),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Membre depuis', '2024'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, AuthViewModel authViewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // THÈME
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.palette, color: Colors.purple, size: 24),
            ),
            title: const Text(
              'Thème',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Changer l\'apparence de l\'application'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(height: 1),
          // LANGUE
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.language, color: Colors.green, size: 24),
            ),
            title: const Text(
              'Langue',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Français, English'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(height: 1),
          // MEMBRES DU GROUPE
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.group, color: Colors.orange, size: 24),
            ),
            title: const Text(
              'Membres du groupe',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Inviter et gérer les membres'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onTap: () => _showMembersDialog(context),
          ),
          const Divider(height: 1),
          // Confidentialité
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.privacy_tip, color: Colors.teal, size: 24),
            ),
            title: const Text('Confidentialité'),
            subtitle: const Text('Gérer vos données personnelles'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onTap: () => _showPrivacyDialog(context),
          ),
          const Divider(height: 1),
          // À propos
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.info, color: Colors.blue, size: 24),
            ),
            title: const Text('À propos'),
            subtitle: const Text('Version 1.0.0'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          // Déconnexion
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 24),
            ),
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Se déconnecter de votre compte'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.red),
            onTap: () => _showLogoutDialog(context, authViewModel),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir le thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.light_mode, color: Colors.orange, size: 28),
              ),
              title: const Text('Mode clair', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Thème lumineux pour une meilleure visibilité'),
              trailing: _isDarkMode == false ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () {
                Navigator.pop(context);
                _applyTheme(context, false);
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.dark_mode, color: Colors.white, size: 28),
              ),
              title: const Text('Mode sombre', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Thème sombre pour une utilisation nocturne'),
              trailing: _isDarkMode == true ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () {
                Navigator.pop(context);
                _applyTheme(context, true);
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.smartphone, color: Colors.white, size: 28),
              ),
              title: const Text('Mode système', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Utilise le thème par défaut de votre appareil'),
              onTap: () {
                Navigator.pop(context);
                _applySystemTheme(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _applyTheme(BuildContext context, bool isDark) {
    final myAppState = context.findAncestorStateOfType<MyAppState>();
    if (myAppState != null) {
      myAppState.toggleTheme(isDark);
    }
    
    setState(() {
      _isDarkMode = isDark;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
            const SizedBox(width: 12),
            Text(isDark ? 'Mode sombre activé' : 'Mode clair activé'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _applySystemTheme(BuildContext context) {
    final myAppState = context.findAncestorStateOfType<MyAppState>();
    if (myAppState != null) {
      myAppState.setSystemTheme();
    }
    
    final brightness = MediaQuery.of(context).platformBrightness;
    final isSystemDark = brightness == Brightness.dark;
    
    setState(() {
      _isDarkMode = isSystemDark;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.smartphone, color: Colors.white),
            SizedBox(width: 12),
            Text('Thème système activé'),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag, color: Colors.blue, size: 28),
              ),
              title: const Text('Français', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Langue par défaut'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Langue française - Fonctionnalité à venir'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag, color: Colors.red, size: 28),
              ),
              title: const Text('English', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Change language to English'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('English language - Coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Membres du groupe'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: CircleAvatar(child: Text('V')),
                title: Text('Vous'),
                subtitle: Text('Admin'),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(child: Text('A')),
                title: const Text('Alice Martin'),
                subtitle: const Text('Membre'),
              ),
              ListTile(
                leading: const CircleAvatar(child: Text('T')),
                title: const Text('Thomas Dubois'),
                subtitle: const Text('Membre'),
              ),
              const Divider(),
              const Text(
                'Invitez des membres pour collaborer',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invitation de membres - Fonctionnalité à venir'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Inviter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confidentialité'),
        content: const Text(
          'Vos données sont stockées localement sur votre appareil et sur nos serveurs sécurisés. '
          'Nous ne partageons pas vos informations personnelles avec des tiers.\n\n'
          '• Données personnelles : nom, email\n'
          '• Données des tâches : titres, descriptions, dates\n'
          '• Aucune donnée n\'est vendue à des tiers',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('À propos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('TaskFlow - Application de gestion de tâches collaborative', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Développé avec Flutter & Spring Boot'),
            SizedBox(height: 8),
            Text('© 2024 TaskFlow. Tous droits réservés.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              // Vider les tâches avant déconnexion
              final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
              taskViewModel.clearTasks();
              
              await authViewModel.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}