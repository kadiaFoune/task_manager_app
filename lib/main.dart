import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/task_viewmodel.dart';
import 'viewmodels/collaboratif_viewmodel.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final themePreference = prefs.getString('themePreference') ?? 'system';
  
  ThemeMode initialThemeMode;
  switch (themePreference) {
    case 'light':
      initialThemeMode = ThemeMode.light;
      break;
    case 'dark':
      initialThemeMode = ThemeMode.dark;
      break;
    default:
      initialThemeMode = ThemeMode.system;
  }
  
  runApp(MyApp(initialThemeMode: initialThemeMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  
  const MyApp({super.key, required this.initialThemeMode});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late String _themePreference;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _themePreference = _getThemePreferenceFromMode(_themeMode);
  }

  String _getThemePreferenceFromMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _getThemeModeFromPreference(String preference) {
    switch (preference) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggleTheme(bool isDark) async {
    final newPreference = isDark ? 'dark' : 'light';
    _themePreference = newPreference;
    _themeMode = _getThemeModeFromPreference(newPreference);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themePreference', newPreference);
    
    setState(() {});
  }

  void setSystemTheme() async {
    _themePreference = 'system';
    _themeMode = ThemeMode.system;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themePreference', 'system');
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => CollaboratifViewModel()),
      ],
      child: MaterialApp(
        title: 'TaskFlow',
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        themeMode: _themeMode,
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}