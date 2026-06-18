# Guide de Style et Bonnes Pratiques - TaskFlow

## 📋 Utilisation des Constantes

### Tous les textes doivent utiliser `app_strings.dart`

❌ **À ÉVITER:**
```dart
Text('Ajouter une tâche')
Text('Mes tâches')
```

✅ **À FAIRE:**
```dart
import '../constants/app_strings.dart';
Text(AppStrings.addTask)
Text(AppStrings.myTasks)
```

## 🎨 Utilisation du Système de Thème

### Utiliser le thème de contexte

❌ **À ÉVITER:**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
  ),
)
```

✅ **À FAIRE:**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
  ),
)
```

## 📏 Espacements Cohérents

### Utiliser les valeurs standards

❌ **À ÉVITER:**
```dart
SizedBox(height: 15)
SizedBox(width: 18)
```

✅ **À FAIRE:**
```dart
import '../constants/app_dimensions.dart';
SizedBox(height: AppDimensions.spacing16)
SizedBox(width: AppDimensions.spacing16)
```

### Valeurs Recommandées
- Entre éléments: `spacing8` ou `spacing12`
- Entre sections: `spacing16` ou `spacing24`
- Marges externes: `spacing16` ou `spacing20`

## 🔘 Boutons

### Utiliser le bouton dégradé pour les actions principales

```dart
import '../widgets/gradient_button.dart';

GradientButton(
  onPressed: () {},
  label: AppStrings.save,
  isLoading: _isLoading,
)
```

### Utiliser les boutons thématisés pour les actions secondaires

```dart
OutlinedButton(
  onPressed: () {},
  child: Text(AppStrings.cancel),
)
```

## 🎯 Rayons de Bordure

### Valeurs Standard

- Petits éléments: `radiusSmall` (8px)
- Cartes/Champs: `radiusMedium` (12px)
- Dialogues: `radiusLarge` (16px)
- Grands conteneurs: `radiusXL` (20px)

```dart
BorderRadius.circular(AppDimensions.radiusMedium)
```

## 📱 Cartes

### Format Standard

```dart
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
  ),
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(AppDimensions.spacing16),
    child: // Contenu
  ),
)
```

## 🏷️ Texte

### Utiliser les styles du thème

```dart
// Titre large
Text('Titre', style: Theme.of(context).textTheme.headlineSmall)

// Corps
Text('Description', style: Theme.of(context).textTheme.bodyMedium)

// Petit texte
Text('Aide', style: Theme.of(context).textTheme.bodySmall)
```

## 🎨 Couleurs

### Palette Principale

```dart
Theme.of(context).colorScheme.primary      // #6366F1
Theme.of(context).colorScheme.secondary    // #8B5CF6
Colors.green                                // Succès
Colors.orange                               // Avertissement
Colors.red                                  // Erreur
```

## 🔄 Thème Clair/Sombre

L'application supporte automatiquement les deux thèmes. Toujours utiliser:

```dart
Theme.of(context).brightness == Brightness.dark
```

Au lieu de valeurs en dur pour les couleurs.

## 🗂️ Structure des Dossiers

Suivre la structure existante:

```
lib/
├── constants/         # Valeurs constantes
├── themes/           # Thèmes
├── views/            # Écrans
├── widgets/          # Composants réutilisables
├── viewmodels/       # Logique métier
├── models/           # Modèles de données
└── services/         # Services
```

## 📝 Commentaires et Documentation

### Documenter les widgets complexes

```dart
/// Widget affichant une liste de tâches filtrées
/// 
/// [tasks] - Liste des tâches à afficher
/// [onTap] - Callback quand une tâche est sélectionnée
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTap;
  
  const TaskList({
    required this.tasks,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

## 🧪 Tests

### Chaque nouveau widget/écran doit avoir des tests

```dart
void main() {
  testWidgets('Affiche le titre correctement', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MonWidget(),
      ),
    );
    
    expect(find.text('Titre'), findsOneWidget);
  });
}
```

## 🚀 Performance

### Bonnes pratiques

1. Utiliser `const` pour les widgets statiques
2. Utiliser `Consumer` pour les réactivités locales
3. Limiter les reconstructions inutiles
4. Utiliser `RepaintBoundary` pour les sections complexes

```dart
const SizedBox(height: 16)  // ✅ const
SizedBox(height: 16)        // ❌ pas const
```

## 🔐 Sécurité

### Mots de passe

```dart
// Toujours masquer dans l'interface
TextFormField(
  obscureText: true,
  // ...
)
```

### Données sensibles

```dart
// Ne jamais afficher les logs sensibles
// debugPrint(userData);  // ❌
```

## 📲 Responsive Design

### Adapter aux différentes tailles d'écran

```dart
MediaQuery.of(context).size.width > 600
    ? GridView.count(crossAxisCount: 3)
    : GridView.count(crossAxisCount: 2)
```

## 🎯 Résumé des Points Clés

✅ Utiliser `AppStrings` pour tous les textes
✅ Utiliser `Theme.of(context)` pour les couleurs
✅ Utiliser `AppDimensions` pour les espacements
✅ Maintenir une cohérence visuelle
✅ Documenter le code complexe
✅ Tester les nouveaux widgets
✅ Respecter la structure des dossiers
✅ Optimiser les performances

---

**Version**: 1.0
**Mise à jour**: Juin 2026
