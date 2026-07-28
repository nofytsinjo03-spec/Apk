import 'package:flutter/material.dart';

// ============================================================
// VONONA — version DartPad (fichier unique, sans package externe)
// Copie-colle TOUT ce fichier dans l'éditeur DartPad (mode Flutter),
// puis appuie sur "Run".
// ============================================================

void main() => runApp(const VononaApp());

// ---- Couleurs ----
class C {
  static const greenDeep = Color(0xFF122A22);
  static const greenMid = Color(0xFF1F4636);
  static const ivory = Color(0xFFF4EFE4);
  static const redFlag = Color(0xFFC8102E);
  static const gold = Color(0xFFB8923F);
  static const goldSoft = Color(0xFFD8BE85);
  static const slate = Color(0xFF6E7871);
  static const line = Color(0xFFEAE3D0);
  static const freeGreen = Color(0xFF1F7A4C);
}

class VononaApp extends StatefulWidget {
  const VononaApp({super.key});
  @override
  State<VononaApp> createState() => _VononaAppState();
}

class _VononaAppState extends State<VononaApp> {
  // --- état global très simple, sans package "provider" ---
  String? userName;
  bool abonnementActif = false;
  int screen = 0; // 0=login, 1=dashboard, 2=cours, 3=abonnement

  void goTo(int i) => setState(() => screen = i);
  void connecter(String nom) => setState(() {
        userName = nom.isEmpty ? 'Candidat' : nom;
        screen = 1;
      });
  void activerAbonnement() => setState(() => abonnementActif = true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: C.ivory,
        colorScheme: ColorScheme.fromSeed(seedColor: C.greenDeep),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: C.redFlag,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: switch (screen) {
            1 => DashboardScreen(
                userName: userName,
                abonnementActif: abonnementActif,
                onOuvrirCours: () => goTo(2),
                onOuvrirAbonnement: () => goTo(3),
              ),
            2 => CoursesScreen(
                abonnementActif: abonnementActif,
                onOuvrirAbonnement: () => goTo(3),
                onRetour: () => goTo(1),
              ),
            3 => SubscriptionScreen(
                onPaiementConfirme: () {
                  activerAbonnement();
                  goTo(1);
                },
                onRetour: () => goTo(1),
              ),
            _ => LoginScreen(onValider: connecter),
          },
        ),
      ),
    );
  }
}

// ============================================================
// ÉCRAN 1 — Connexion / Inscription
// ============================================================
class LoginScreen extends StatefulWidget {
  final void Function(String nom) onValider;
  const LoginScreen({super.key, required this.onValider});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool inscription = true;
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [C.greenMid, C.greenDeep]),
                  border: Border.all(color: C.gold, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text('V',
                    style: TextStyle(
                        color: C.goldSoft, fontWeight: FontWeight.w700, fontSize: 22)),
              ),
              const SizedBox(height: 10),
              const Text('VONONA',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 22, color: C.greenDeep)),
              const SizedBox(height: 2),
              const Text('CONCOURS POLICE · MADAGASIKARA',
                  style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.6,
                      color: C.slate,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(3),
            decoration:
                BoxDecoration(color: const Color(0xFFE6DFCC), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              _tab('Connexion', !inscription, () => setState(() => inscription = false)),
              _tab('Créer un compte', inscription, () => setState(() => inscription = true)),
            ]),
          ),
          const SizedBox(height: 20),
          if (inscription) ...[
            const Text('Nom complet',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.slate)),
            const SizedBox(height: 6),
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Rakoto Andriamampianina')),
            const SizedBox(height: 14),
          ],
          const Text('Numéro de téléphone',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.slate)),
          const SizedBox(height: 6),
          const TextField(decoration: InputDecoration(hintText: '034 XX XXX XX')),
          const SizedBox(height: 14),
          const Text('Mot de passe',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.slate)),
          const SizedBox(height: 6),
          const TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••')),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => widget.onValider(nameCtrl.text.trim()),
            child: Text(inscription ? 'Créer mon compte' : 'Se connecter'),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
                color: active ? C.greenDeep : Colors.transparent,
                borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    color: active ? C.ivory : C.slate, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ),
      );
}

// ============================================================
// ÉCRAN 2 — Tableau de bord
// ============================================================
class DashboardScreen extends StatelessWidget {
  final String? userName;
  final bool abonnementActif;
  final VoidCallback onOuvrirCours;
  final VoidCallback onOuvrirAbonnement;
  const DashboardScreen({
    super.key,
    required this.userName,
    required this.abonnementActif,
    required this.onOuvrirCours,
    required this.onOuvrirAbonnement,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [C.greenMid, C.greenDeep]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(TextSpan(children: [
                      const TextSpan(text: 'Bonjour, ', style: TextStyle(color: Color(0xB3F4EFE4), fontSize: 13)),
                      TextSpan(
                          text: userName ?? 'Candidat',
                          style: const TextStyle(color: C.ivory, fontWeight: FontWeight.w700, fontSize: 13)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: C.gold.withOpacity(0.22),
                          border: Border.all(color: C.gold),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('NIVEAU EOP',
                          style: TextStyle(color: C.goldSoft, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(children: List.generate(4, (i) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ClipPath(
                    clipper: _Chevron(),
                    child: Container(width: 26, height: 7, color: C.gold.withOpacity(i < 2 ? 1 : 0.3)),
                  ),
                ))),
                const SizedBox(height: 8),
                const Text("Progression globale — 42% avant l'examen",
                    style: TextStyle(fontSize: 10.5, color: Color(0xA6F4EFE4))),
              ],
            ),
          ),
          _title('Matières du jour'),
          _subject('Culture générale', 'Gratuit', true, 0.70),
          _subject('Droit & procédure pénale', '🔒 Premium', false, 0.15),
          _subject('Condition physique', '🔒 Premium', false, 0.05),
          _title('Cette semaine'),
          _subject('Quiz blanc chronométré', '3 essais', true, 0.30),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: ElevatedButton(onPressed: onOuvrirCours, child: const Text('Voir les cours')),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [C.greenDeep, C.greenMid]),
                  borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('Débloquez les 4 niveaux',
                    style: TextStyle(color: C.ivory, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                const Text('Accès illimité à tous les cours, quiz et corrections détaillées.',
                    style: TextStyle(color: Color(0xBFF4EFE4), fontSize: 11.5)),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: onOuvrirAbonnement, child: const Text('Voir les abonnements')),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
        child: Text(t.toUpperCase(),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: C.greenDeep, letterSpacing: 0.5)),
      );

  Widget _subject(String title, String tag, bool free, double p) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
              Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: free ? C.freeGreen : C.slate)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: p, minHeight: 6, backgroundColor: const Color(0xFFEFE9DA), color: free ? C.greenMid : C.gold),
            ),
          ]),
        ),
      );
}

class _Chevron extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.15, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.85, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

// ============================================================
// ÉCRAN 3 — Cours / Chapitres
// ============================================================
class CoursesScreen extends StatelessWidget {
  final bool abonnementActif;
  final VoidCallback onOuvrirAbonnement;
  final VoidCallback onRetour;
  const CoursesScreen({super.key, required this.abonnementActif, required this.onOuvrirAbonnement, required this.onRetour});

  static const chapitres = [
    ['Ch. 1 — Introduction au droit pénal', '12 min · Fiche + Quiz', true],
    ['Ch. 2 — La garde à vue', '18 min · Fiche + Quiz', true],
    ['Ch. 3 — Le flagrant délit', '15 min · Fiche + Quiz', false],
    ['Ch. 4 — Instruction judiciaire', '20 min · Fiche + Quiz', false],
    ['Ch. 5 — Examen blanc complet', '45 min · 40 questions', false],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
          child: Row(children: [
            IconButton(onPressed: onRetour, icon: const Icon(Icons.arrow_back)),
            const Expanded(
              child: Text('Droit & procédure pénale · EOP',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4),
            children: [
              for (final c in chapitres)
                _chapitre(context, c[0] as String, c[1] as String, c[2] as bool),
              if (!abonnementActif)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [C.greenDeep, C.greenMid]),
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Text('Il vous reste 3 chapitres',
                          style: TextStyle(color: C.ivory, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 4),
                      const Text('Abonnez-vous pour continuer ce module et débloquer les 3 autres niveaux.',
                          style: TextStyle(color: Color(0xBFF4EFE4), fontSize: 11.5)),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: onOuvrirAbonnement, child: const Text("S'abonner maintenant")),
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chapitre(BuildContext context, String titre, String sousTitre, bool free) {
    final deverrouille = free || abonnementActif;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!deverrouille) onOuvrirAbonnement();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: deverrouille ? Colors.white : const Color(0xFFF0ECE0),
            border: Border.all(color: C.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titre, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(sousTitre, style: const TextStyle(fontSize: 10.5, color: C.slate)),
              ]),
            ),
            if (deverrouille && free)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: C.freeGreen, borderRadius: BorderRadius.circular(20)),
                child: const Text('Gratuit', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w600)),
              )
            else if (!deverrouille)
              const Icon(Icons.lock, size: 18, color: C.gold)
            else
              const Icon(Icons.check_circle, size: 18, color: C.freeGreen),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
// ÉCRAN 4 — Abonnement / Mobile Money
// ============================================================
class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onPaiementConfirme;
  final VoidCallback onRetour;
  const SubscriptionScreen({super.key, required this.onPaiementConfirme, required this.onRetour});
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int planIndex = 1;
  int provider = 0; // 0=M'vola 1=Orange 2=Airtel
  bool enCours = false;

  static const plans = [
    ['1 mois', 9900, 'Accès à 1 niveau au choix', false],
    ['3 mois', 22500, 'Tous les niveaux EAP à ECP + examens blancs', true],
    ['12 mois', 69000, 'Accès complet + certificat de suivi', false],
  ];
  static const providers = ['M\'VOLA', 'ORANGE MONEY', 'AIRTEL MONEY'];
  static const providerColors = [Color(0xFFFFC700), Color(0xFFFF7900), Color(0xFFE4022D)];

  Future<void> payer() async {
    setState(() => enCours = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => enCours = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paiement confirmé ✅')));
    widget.onPaiementConfirme();
  }

  @override
  Widget build(BuildContext context) {
    final plan = plans[planIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
          child: Row(children: [
            IconButton(onPressed: widget.onRetour, icon: const Icon(Icons.arrow_back)),
            const Text('Abonnement', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4),
            children: [
              _sectionTitle('Choisissez votre formule'),
              for (int i = 0; i < plans.length; i++) _planCard(i, i == planIndex),
              _sectionTitle('Mode de paiement', top: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: List.generate(3, (i) {
                  final sel = provider == i;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => provider = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              color: sel ? const Color(0xFFF4F1E8) : Colors.white,
                              border: Border.all(color: sel ? C.greenDeep : C.line, width: sel ? 1.6 : 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [
                            Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: providerColors[i])),
                            const SizedBox(height: 6),
                            Text(providers[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ),
                    ),
                  );
                })),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Numéro Mobile Money', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.slate)),
                  const SizedBox(height: 6),
                  const TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: '034 XX XXX XX')),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: ElevatedButton(
                  onPressed: enCours ? null : payer,
                  child: enCours
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Payer ${plan[1]} Ar'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String t, {double top = 4}) => Padding(
        padding: EdgeInsets.fromLTRB(20, top, 20, 10),
        child: Text(t, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: C.slate)),
      );

  Widget _planCard(int i, bool selected) {
    final p = plans[i];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => planIndex = i),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: selected ? C.gold : C.line, width: selected ? 1.6 : 1),
                borderRadius: BorderRadius.circular(14)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(p[0] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                Text('${p[1]} Ar', style: const TextStyle(color: C.redFlag, fontWeight: FontWeight.w600, fontSize: 17)),
              ]),
              const SizedBox(height: 5),
              Text(p[2] as String, style: const TextStyle(fontSize: 11, color: C.slate)),
            ]),
          ),
          if (p[3] as bool)
            Positioned(
              top: -9,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(20)),
                child: const Text('RECOMMANDÉ',
                    style: TextStyle(fontSize: 8.5, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: C.greenDeep)),
              ),
            ),
        ]),
      ),
    );
  }
}
