# 🚀 TaskFlow - Application Gestionnaire de Tâches

Une application Flutter moderne et élégante pour gérer vos tâches intelligemment avec une interface utilisateur impeccable.

## ✨ Améliorations Récentes

### 🌐 Traduction Complète en Français
- ✅ Tous les textes de l'interface convertis en français
- ✅ Constantes centralisées pour une maintenance facile
- ✅ Support complet du français dans tous les écrans

### 🎨 Design Moderne et Élégant
- ✅ Nouveau système de thème moderne avec Material 3
- ✅ Palettes de couleurs cohérentes et professionnelles
- ✅ Animations fluides et transitions en douceur
- ✅ Carte des tâches améliorée avec meilleur contraste
- ✅ Profil utilisateur avec design hautement moderne

### 🎯 Fonctionnalités d'Interface
- ✅ Boutons dégradés élégants avec ombre
- ✅ Champs de formulaire avec meilleure accessibilité
- ✅ Icônes colorées et modernes
- ✅ Espacements et paddings optimisés
- ✅ Navigation fluide et intuitive

## 📁 Structure du Projet

```
lib/
├── main.dart                          # Point d'entrée de l'application
├── constants/
│   ├── app_strings.dart              # Tous les textes en français
│   └── app_dimensions.dart           # Dimensions et espacements
├── themes/
│   └── app_theme.dart                # Système de thème moderne
├── views/                             # Écrans de l'application
│   ├── login_screen.dart             # Écran de connexion
│   ├── register_screen.dart          # Écran d'enregistrement
│   ├── dashboard_screen.dart         # Tableau de bord
│   ├── my_tasks_screen.dart          # Mes tâches
│   ├── task_detail_screen.dart       # Détails de la tâche
│   ├── add_edit_task_screen.dart     # Ajout/Édition de tâche
│   ├── profile_screen.dart           # Profil utilisateur
│   └── collaboratif_screen.dart      # Tâches collaboratives
├── widgets/                           # Widgets personnalisés
│   ├── task_card.dart                # Carte de tâche améliorée
│   ├── gradient_button.dart          # Bouton dégradé personnalisé
│   ├── custom_textfield.dart         # Champ de texte personnalisé
│   └── custom_button.dart            # Bouton personnalisé
├── models/                            # Modèles de données
├── viewmodels/                        # ViewModels (logique métier)
└── services/                          # Services

```

## 🎨 Système de Thème

### Couleurs Primaires
- **Primaire**: `#6366F1` (Indigo)
- **Secondaire**: `#8B5CF6` (Violet)
- **Accent**: `#EC4899` (Rose)

### Couleurs de Statut
- **Succès**: `#10B981` (Vert)
- **Avertissement**: `#F59E0B` (Ambre)
- **Erreur**: `#EF4444` (Rouge)
- **Info**: `#3B82F6` (Bleu)

### Styles de Texte
- **Titre Large**: 20pt, FontWeight.w600
- **Titre Moyen**: 16pt, FontWeight.w600
- **Corps**: 14pt, FontWeight.w400
- **Petit Texte**: 12pt, FontWeight.w400

### Composants
- **Rayons de bordure**: 12-16px (arrondi moderne)
- **Élévation des cartes**: 2dp avec ombre subtile
- **Espacements**: Multiples de 8px pour cohérence

## 📱 Écrans

### 1. **Écran de Connexion** 
- Formulaire épuré avec champs améliorés
- Bouton dégradé élégant
- Support des comptes existants
- Validation des formulaires

### 2. **Écran d'Enregistrement**
- Formulaire complet avec validation
- Confirmation du mot de passe
- Navigation facile vers la connexion

### 3. **Tableau de Bord**
- Statistiques visuelles avec cartes dégradées
- Résumé des tâches d'aujourd'hui
- Accent sur les métriques clés
- Interface de rafraîchissement

### 4. **Mes Tâches**
- Filtrage par statut (Toutes, Complétées, En attente, Retardées)
- Recherche de tâches
- Cartes de tâches améliorées
- Actions rapides (Éditer, Supprimer)

### 5. **Détails de la Tâche**
- Vue complète des informations
- Badges de statut colorés
- Actions (Marquer comme complétée, Retour)
- Édition et suppression

### 6. **Profil Utilisateur**
- En-tête dégradé avec avatar
- Informations du compte
- Statistiques utilisateur
- Paramètres et options

## 🚀 Démarrage

```bash
# Cloner le projet
git clone <repository-url>

# Accéder au dossier
cd task_manager_app

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

## 📦 Dépendances

- `flutter`: SDK Flutter
- `provider`: Gestion d'état
- `intl`: Internationalisation
- `http`: Requêtes HTTP
- `shared_preferences`: Stockage local
- `sqflite`: Base de données locale

## 🌙 Thème Clair/Sombre

L'application prend en charge automatiquement les thèmes clair et sombre selon les préférences du système.

## 🎯 Prochaines Améliorations

- [ ] Support multilingue complet
- [ ] Notifications push
- [ ] Mode hors ligne amélioré
- [ ] Synchronisation en temps réel
- [ ] Partage de tâches
- [ ] Rappels personnalisés

## 📝 Notes

- Tous les textes sont stockés dans `constants/app_strings.dart`
- Les dimensions sont centralisées dans `constants/app_dimensions.dart`
- Le système de thème est dans `themes/app_theme.dart`
- Les widgets personnalisés sont réutilisables

## 🤝 Contribution

Les contributions sont bienvenues! Veuillez soumettre un PR avec vos modifications.

## 📄 Licence

MIT License

---

**Créé avec ❤️ en Flutter**
