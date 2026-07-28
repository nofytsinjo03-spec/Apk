# VONONA — App de préparation aux concours de la Police malgache

Projet Flutter de départ pour l'application EAP / EIP / EOP / ECP, reprenant
le design de la maquette (vert institutionnel, ivoire, or, rouge drapeau).

## Structure du projet

```
vonona_flutter/
├── pubspec.yaml                     # dépendances (google_fonts, provider)
├── lib/
│   ├── main.dart                    # point d'entrée
│   ├── app_state.dart               # état global (niveau, abonnement, utilisateur)
│   ├── theme/
│   │   └── app_theme.dart           # couleurs + typographies
│   ├── widgets/
│   │   └── rank_chevrons.dart       # galon de progression (élément signature)
│   └── screens/
│       ├── login_screen.dart        # connexion / inscription
│       ├── dashboard_screen.dart    # tableau de bord + niveau + matières
│       ├── courses_screen.dart      # chapitres, gratuit vs verrouillé
│       └── subscription_screen.dart # formules + M'vola / Orange / Airtel Money
```

## Installer et lancer

1. Installer Flutter (https://docs.flutter.dev/get-started/install) — nécessite
   un ordinateur (Windows/Mac/Linux), pas possible directement depuis le mobile.
2. Dans un terminal, à la racine du dossier `vonona_flutter` :
   ```
   flutter pub get
   flutter run
   ```
3. Pour générer l'APK Android final :
   ```
   flutter build apk --release
   ```
   L'APK sera dans `build/app/outputs/flutter-apk/app-release.apk`.

## Ce qui est déjà fonctionnel (démo, sans backend)

- Navigation complète : Connexion → Dashboard → Cours → Abonnement.
- L'état "abonné / non abonné" est simulé en mémoire (`AppState`). Une fois
  le paiement "confirmé" sur l'écran Abonnement, les chapitres verrouillés
  passent en accessible dans la session en cours.
- Les 4 niveaux (EAP/EIP/EOP/ECP) sont modélisés dans `app_state.dart`
  (enum `Niveau`), prêt à être relié à un vrai choix utilisateur.

## Ce qu'il reste à brancher pour une vraie mise en production

1. **Backend** (comptes, cours, quiz, statut d'abonnement) — Node.js/Express,
   Laravel ou Firebase. Les écrans actuels utilisent des données statiques
   (`_chapitres`, `_plans`) à remplacer par des appels API.
2. **Paiement Mobile Money réel** — chaque opérateur a son propre SDK/API :
   - M'vola : API Telma (nécessite un compte marchand Telma)
   - Orange Money : Orange Money Web Payment API
   - Airtel Money : Airtel Money Open API
   Le bouton "Payer" dans `subscription_screen.dart` (méthode `_payer`)
   est le point d'intégration : remplacer le `Future.delayed` de démonstration
   par l'appel réel, puis vérifier le statut de la transaction côté serveur
   avant d'appeler `activerAbonnement()`.
3. **Authentification** — remplacer la connexion locale de `login_screen.dart`
   par Firebase Auth (ou équivalent) avec vérification par SMS/OTP.
4. **Téléchargement offline des fiches**, **notifications push** de rappel,
   **classement entre utilisateurs** : à ajouter en modules séparés une fois
   le cœur fonctionnel validé.

## Notes de design

- Police d'affichage : **Oswald** (titres, condensé/autoritaire).
- Police de texte : **Source Sans 3**.
- Le motif "chevrons dorés" (`rank_chevrons.dart`) sert de fil conducteur
  visuel pour la progression — à réutiliser sur d'éventuels futurs écrans
  (profil, certificat de fin de niveau, classement).
