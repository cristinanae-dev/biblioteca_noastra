import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, Clipboard, ClipboardData;
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

// ============================================================
// ADRESA DE EMAIL PENTRU SCRIITORI CARE VOR SĂ-ȘI PUBLICE CARTEA
// ============================================================
const String kEmailContact = 'cristinanae.dev@gmail.com';

// ============================================================
// ENDPOINT FORMSPREE
// ============================================================
const String kFormspreeEndpoint = 'https://formspree.io/f/mnjbarwp';

// Paletă de culori
const Color kFundal = Color(0xFF090E1A);
const Color kFundalCard = Color(0xFF141B2E);
const Color kFundalCard2 = Color(0xFF1C2438);
const Color kAccentCyan = Color(0xFF22D3EE);
const Color kAccentViolet = Color(0xFF8B5CF6);
const Color kTextSecundar = Color(0xFF94A3B8);

void main() {
  runApp(const BibliotecaAgathaChristie());
}

class BibliotecaAgathaChristie extends StatelessWidget {
  const BibliotecaAgathaChristie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Noastră',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kFundal,
        fontFamily: 'Georgia',
        colorScheme: const ColorScheme.dark(
          primary: kAccentCyan,
          secondary: kAccentViolet,
        ),
      ),
      home: const EcranPrincipal(),
    );
  }
}

class EcranPrincipal extends StatefulWidget {
  const EcranPrincipal({super.key});

  @override
  State<EcranPrincipal> createState() => _EcranPrincipalState();
}

class _EcranPrincipalState extends State<EcranPrincipal> {
  String _categoriaSelectata = 'Toate';
  String _cautare = '';
  bool _seTrimiteFormular = false;
  final GlobalKey _cheieColectie = GlobalKey();
  final GlobalKey _cheieContact = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _toateCartile = [
    {
      'titlu': 'Crimă și Pedeapsă',
      'an': '(1866)',
      'autor': 'Feodor Dostoievski',
      'categorie': 'Mister / Crime',
      'descriere': 'Romanul urmărește frământările interioare ale lui Rodion Raskolnikov, un tânăr sărac din Sankt Petersburg, după ce comite o crimă atroce, explorând teme de vinovăție, ispășire și moralitate.',
      'folderAssets': 'crima_pedeapsa',
      'coperta': 'assets/carti/crima_pedeapsa/coperta.jpg',
      'totalCapitole': 22,
      'totalPartiAudio': 5,
      'insigna': 'Clasic',
    },
    {
      'titlu': 'Semizeul – Povești din Prima Lume',
      'an': '(2025)',
      'autor': 'Nicolae Luca',
      'categorie': 'Fantasy/SF',
      'descriere': 'O călătorie fascinantă în vremurile de dinainte de Marele Potop, explorând mituri pierdute și civilizații uitate.',
      'folderAssets': 'semizeul',
      'coperta': 'assets/carti/semizeul/semizeul.jpg',
      'totalCapitole': 22,
      'totalPartiAudio': 22,
      'insigna': 'Nou',
    },
    {
      'titlu': 'Moș Goriot',
      'an': '(1835)',
      'autor': 'Honoré de Balzac',
      'categorie': 'Clasic',
      'descriere': 'Unul dintre cele mai celebre romane ale lui Balzac. O analiză profundă a societății pariziene, ambiției, banilor și decadenței umane, centrată în jurul tragicului personaj Moș Goriot.',
      'folderAssets': 'mos_goriot',
      'coperta': 'assets/carti/mos_goriot/coperta.jpg',
      'totalCapitole': 22,
      'totalPartiAudio': 5,
      'insigna': 'Clasic',
    },
  ];

  final List<String> _categorii = const [
    'Toate',
    'Fantasy/SF',
    'Mister / Crime',
    'Clasic',
  ];

  // Alege numărul de coloane din grid în funcție de lățimea reală a ecranului,
  // ca aplicația să arate bine pe orice telefon (mic, mediu, mare) sau tabletă.
  int _numarColoane(double largime) {
    if (largime < 480) return 1;
    if (largime < 900) return 2;
    return 3;
  }

  void _deruleazaLa(GlobalKey cheie) {
    final ctx = cheie.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartiFiltrate = _toateCartile.where((carte) {
      final meciuriCategorie = _categoriaSelectata == 'Toate' || carte['categorie'] == _categoriaSelectata;
      final meciuriCautare = carte['titlu']!.toLowerCase().contains(_cautare.toLowerCase()) ||
          carte['autor']!.toLowerCase().contains(_cautare.toLowerCase());
      return meciuriCategorie && meciuriCautare;
    }).toList();

    final ecranIngust = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      body: SafeArea(
        top: false, // Lăsăm AppBar-ul să se ducă până sus de tot
        bottom: true, // Protejează automat zona cu butoanele de navigare Android/iOS
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ==================== NAVBAR ====================
            SliverAppBar(
              backgroundColor: kFundal.withOpacity(0.92),
              elevation: 0,
              pinned: true,
              floating: true,
              toolbarHeight: 76,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [kAccentCyan, kAccentViolet]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  if (!ecranIngust)
                    const Text('Biblioteca Noastră', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 24),
                  if (!ecranIngust)
                    Expanded(
                      child: Container(
                        height: 42,
                        constraints: const BoxConstraints(maxWidth: 420),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: kFundalCard,
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: TextField(
                          onChanged: (v) => setState(() => _cautare = v),
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto'),
                          decoration: const InputDecoration(
                            hintText: 'Caută titlu sau autor...',
                            hintStyle: TextStyle(color: kTextSecundar, fontSize: 13),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, size: 18, color: kTextSecundar),
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => _deruleazaLa(_cheieContact),
                  child: const Text('Contact', style: TextStyle(color: kTextSecundar, fontFamily: 'Roboto')),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => _deschideDialogTrimiteCarte(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentCyan,
                      foregroundColor: kFundal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(ecranIngust ? 'Adaugă' : 'Adaugă cartea ta', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 12)),
                  ),
                ),
              ],
            ),

            // ==================== HERO ====================
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Positioned(
                    top: -80,
                    right: -60,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [kAccentViolet.withOpacity(0.35), Colors.transparent]),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: -80,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [kAccentCyan.withOpacity(0.25), Colors.transparent]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: kAccentCyan.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kAccentCyan.withOpacity(0.4)),
                          ),
                          child: const Text('100% gratuit • text și audio', style: TextStyle(color: kAccentCyan, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 22),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, kAccentCyan]).createShader(bounds),
                          child: const Text(
                            'Biblioteca Noastră Gratuită',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold, height: 1.1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Un spațiu digital dedicat culturii. Citește pe capitole sau ascultă audio — toate operele sunt oferite gratuit, pentru toată lumea.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextSecundar, fontSize: 15, fontFamily: 'Roboto', height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _deruleazaLa(_cheieColectie),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccentCyan,
                                foregroundColor: kFundal,
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              icon: const Icon(Icons.auto_stories_rounded),
                              label: const Text('Explorează colecția', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _deschideDialogTrimiteCarte(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              icon: const Icon(Icons.mail_outline_rounded),
                              label: const Text('Publică gratuit cartea ta', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==================== CATEGORII ====================
            SliverToBoxAdapter(
              key: _cheieColectie,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: _categorii.map((cat) {
                    final esteSelectat = _categoriaSelectata == cat;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        gradient: esteSelectat ? const LinearGradient(colors: [kAccentCyan, kAccentViolet]) : null,
                        color: esteSelectat ? null : kFundalCard,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: esteSelectat ? Colors.transparent : Colors.white12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => setState(() => _categoriaSelectata = cat),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                            child: Text(
                                cat,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    color: esteSelectat ? kFundal : Colors.white70
                                )
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ==================== COLECȚIE (TEXT INFO) ====================
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Text(
                    '${cartiFiltrate.length} ${cartiFiltrate.length == 1 ? "carte disponibilă" : "cărți disponibile"}',
                    style: const TextStyle(color: kTextSecundar, fontFamily: 'Roboto', fontSize: 13)
                ),
              ),
            ),

            // ==================== COLECȚIE (GRID CĂRȚI) ====================
            SliverPadding(
              // Schimbat padding-ul de jos la 40.0 ca să respire mai bine gridul pe mobil
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 40.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // Adaptiv pe toate dimensiunile de telefon:
                  // < 480px  -> 1 coloană (telefoane mici/medii, portret) — cardul ia
                  //             toată lățimea, așa că butoanele Citește/Detalii au loc
                  //             berechet unul lângă altul, exact ca în varianta de Chrome.
                  // 480-899  -> 2 coloane (telefoane mari / tabletă portret)
                  // >= 900   -> 3 coloane (tabletă landscape / desktop)
                  crossAxisCount: _numarColoane(MediaQuery.of(context).size.width),
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final carte = cartiFiltrate[index];
                    return _CardCarte(
                      carte: carte,
                      onCiteste: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EcranLecturaLectie(
                              titluCarte: carte['titlu'],
                              folderAssets: carte['folderAssets'],
                              totalCapitole: carte['totalCapitole'],
                              totalPartiAudio: carte['totalPartiAudio'],
                            ),
                          ),
                        );
                      },
                      onDetalii: () => _afiseazaDetaliiCarte(context, carte),
                    );
                  },
                  childCount: cartiFiltrate.length,
                ),
              ),
            ),

            // ==================== SECȚIUNE CONTACT / SCRIITORI ====================
            SliverToBoxAdapter(
              key: _cheieContact,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 44),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kAccentViolet.withOpacity(0.20), kAccentCyan.withOpacity(0.10), kFundalCard],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white12),
                    boxShadow: [
                      BoxShadow(color: kAccentViolet.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 20)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Badge superior protejat cu Flexible
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: kAccentCyan.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kAccentCyan.withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: 14, color: kAccentCyan),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Deschis pentru colaborări cu autori',
                                style: TextStyle(color: kAccentCyan, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, kAccentCyan]).createShader(bounds),
                        child: const Text('Ești scriitor? Hai să publicăm cartea ta.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.25)),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Trimite-mi manuscrisul tău și îl public gratuit în Biblioteca Noastră — text și audio — pentru ca oricine, oriunde, să îl poată citi sau asculta fără costuri.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kTextSecundar, fontFamily: 'Roboto', fontSize: 14.5, height: 1.6),
                      ),
                      const SizedBox(height: 28),
                      // Rând de beneficii (chips)
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          _ChipBeneficiu(icon: Icons.bolt_rounded, text: 'Publicare rapidă'),
                          _ChipBeneficiu(icon: Icons.public_rounded, text: 'Acces global, gratuit'),
                          _ChipBeneficiu(icon: Icons.headphones_rounded, text: 'Versiune audio inclusă'),
                          _ChipBeneficiu(icon: Icons.verified_user_rounded, text: 'Fără costuri ascunse'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _deschideDialogTrimiteCarte(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentCyan,
                              foregroundColor: kFundal,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 6,
                              shadowColor: kAccentCyan.withOpacity(0.5),
                            ),
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: const Text('Trimite-ne cartea ta', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: kEmailContact));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: kFundalCard2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  content: const Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded, color: kAccentCyan, size: 18),
                                      SizedBox(width: 10),
                                      Text('Adresa de email a fost copiată!', style: TextStyle(fontFamily: 'Roboto')),
                                    ],
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white24),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text(kEmailContact, style: TextStyle(fontFamily: 'Roboto')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text('Răspund de obicei în 24–48 de ore.', style: TextStyle(color: kTextSecundar, fontSize: 11.5, fontFamily: 'Roboto')),
                    ],
                  ),
                ),
              ),
            ),

            // ==================== FOOTER ====================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF060A14),
                padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 40), // Adăugat bottom padding suplimentar
                child: Column(
                  children: [
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_library, color: kAccentCyan.withOpacity(0.8), size: 18),
                        const SizedBox(width: 8),
                        const Text('Biblioteca Noastră Gratuită', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('© 2026 Proiect Cultural Independent. Creat cu dragoste în Flutter.', style: TextStyle(fontSize: 10, color: Colors.white24, fontFamily: 'Roboto')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _afiseazaDetaliiCarte(BuildContext context, Map<String, dynamic> carte) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: kFundalCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${carte['titlu']} ${carte['an']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text('de ${carte['autor']}', style: const TextStyle(color: kAccentCyan, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Roboto')),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: kFundalCard2, borderRadius: BorderRadius.circular(8)),
                child: Text(carte['categorie'], style: const TextStyle(color: kTextSecundar, fontSize: 11, fontFamily: 'Roboto')),
              ),
              const SizedBox(height: 16),
              Text(carte['descriere'], style: const TextStyle(fontSize: 13.5, height: 1.5, color: Colors.white70, fontFamily: 'Roboto')),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Închide', style: TextStyle(color: Colors.white70, fontFamily: 'Roboto')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EcranLecturaLectie(
                              titluCarte: carte['titlu'],
                              folderAssets: carte['folderAssets'],
                              totalCapitole: carte['totalCapitole'],
                              totalPartiAudio: carte['totalPartiAudio'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: kAccentCyan, foregroundColor: kFundal, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Citește acum', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog de trimitere carte
  void _deschideDialogTrimiteCarte(BuildContext context) {
    final numeCtrl = TextEditingController();
    final titluCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final mesajCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            backgroundColor: kFundalCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Trimite-ne cartea ta', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: _seTrimiteFormular ? null : () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Completează câmpurile — mesajul ajunge direct la noi, fără să fie nevoie să deschizi propriul tău email.',
                      style: TextStyle(color: kTextSecundar, fontSize: 12.5, fontFamily: 'Roboto', height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    _campFormular(controller: numeCtrl, eticheta: 'Numele tău'),
                    const SizedBox(height: 12),
                    _campFormular(controller: titluCtrl, eticheta: 'Titlul cărții'),
                    const SizedBox(height: 12),
                    _campFormular(controller: emailCtrl, eticheta: 'Email-ul tău de contact'),
                    const SizedBox(height: 12),
                    _campFormular(controller: mesajCtrl, eticheta: 'Mesaj (opțional)', linii: 3),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentCyan,
                          foregroundColor: kFundal,
                          disabledBackgroundColor: kAccentCyan.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: _seTrimiteFormular
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: kFundal))
                            : const Icon(Icons.send_rounded, size: 18),
                        label: Text(_seTrimiteFormular ? 'Se trimite...' : 'Trimite mesajul', style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                        onPressed: _seTrimiteFormular
                            ? null
                            : () async {
                          final numeFinal = numeCtrl.text.trim();
                          final titluFinal = titluCtrl.text.trim();
                          final emailFinal = emailCtrl.text.trim();

                          if (numeFinal.isEmpty || titluFinal.isEmpty || emailFinal.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: kFundalCard2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                content: const Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded, color: kAccentCyan, size: 18),
                                    SizedBox(width: 10),
                                    Expanded(child: Text('Completează numele, titlul cărții și email-ul tău.', style: TextStyle(fontFamily: 'Roboto'))),
                                  ],
                                ),
                              ),
                            );
                            return;
                          }

                          setStateDialog(() => _seTrimiteFormular = true);

                          final succes = await _trimiteMesajCatreFormspree(
                            nume: numeFinal,
                            titlu: titluFinal,
                            emailAutor: emailFinal,
                            mesaj: mesajCtrl.text.trim(),
                          );

                          setStateDialog(() => _seTrimiteFormular = false);

                          if (!context.mounted) return;

                          if (succes) {
                            Navigator.pop(context);
                            _afiseazaConfirmareTrimitere(context, numeFinal, titluFinal);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: kFundalCard2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                content: const Row(
                                  children: [
                                    Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Nu am putut trimite mesajul. Încearcă din nou sau scrie-ne direct la email.',
                                        style: TextStyle(fontFamily: 'Roboto', fontSize: 12.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: kEmailContact));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Adresa de email a fost copiată!')),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 14, color: kTextSecundar),
                        label: const Text(kEmailContact, style: TextStyle(color: kTextSecundar, fontSize: 12, fontFamily: 'Roboto')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _afiseazaConfirmareTrimitere(BuildContext context, String nume, String titluCarte) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: kFundalCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [kAccentCyan, kAccentViolet]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 20),
              Text('Mulțumim, $nume!', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              const SizedBox(height: 10),
              Text(
                'Am pregătit mesajul pentru „$titluCarte”. Mai trebuie doar să aștepți confirmarea noastră.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kTextSecundar, fontSize: 13.5, fontFamily: 'Roboto', height: 1.55),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: kFundalCard2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.schedule_rounded, color: kAccentCyan, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Vei primi un răspuns în 24–48 de ore, direct pe email.',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5, fontFamily: 'Roboto', height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentCyan,
                    foregroundColor: kFundal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Am înțeles', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campFormular({required TextEditingController controller, required String eticheta, int linii = 1}) {
    return TextField(
      controller: controller,
      maxLines: linii,
      style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 13),
      decoration: InputDecoration(
        labelText: eticheta,
        labelStyle: const TextStyle(color: kTextSecundar, fontFamily: 'Roboto', fontSize: 13),
        filled: true,
        fillColor: kFundalCard2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Future<bool> _trimiteMesajCatreFormspree({
    required String nume,
    required String titlu,
    required String emailAutor,
    required String mesaj,
  }) async {
    try {
      final raspuns = await http.post(
        Uri.parse(kFormspreeEndpoint),
        headers: {'Accept': 'application/json'},
        body: {
          'name': nume,
          'email': emailAutor,
          'subject': 'Vreau să public cartea "$titlu" în Biblioteca Noastră',
          'message': 'Titlul cărții: $titlu\n\nMesaj:\n$mesaj',
        },
      );
      return raspuns.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

class _ChipBeneficiu extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ChipBeneficiu({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: kFundalCard2,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: kAccentCyan),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ==================== CARD CARTE ====================
class _CardCarte extends StatefulWidget {
  final Map<String, dynamic> carte;
  final VoidCallback onCiteste;
  final VoidCallback onDetalii;

  const _CardCarte({required this.carte, required this.onCiteste, required this.onDetalii});

  @override
  State<_CardCarte> createState() => _CardCarteState();
}

class _CardCarteState extends State<_CardCarte> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final carte = widget.carte;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: kFundalCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hover ? kAccentCyan.withOpacity(0.6) : Colors.white12),
            boxShadow: _hover ? [BoxShadow(color: kAccentCyan.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 10))] : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: carte['coperta'] != null
                          ? Image.asset(carte['coperta'], fit: BoxFit.cover)
                          : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [kAccentViolet.withOpacity(0.5), kFundalCard2],
                          ),
                        ),
                        child: const Center(child: Icon(Icons.menu_book_rounded, size: 44, color: Colors.white38)),
                      ),
                    ),
                    if (carte['insigna'] != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [kAccentCyan, kAccentViolet]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(carte['insigna'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${carte['titlu']} ${carte['an']}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(carte['autor'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kTextSecundar, fontSize: 11.5, fontFamily: 'Roboto')),
                    const SizedBox(height: 12),
                    // Citește / Detalii unul lângă altul, ca în varianta de Chrome.
                    // Fix-ul real pentru "textul care se rupea pe două rânduri":
                    // Text cu maxLines:1 + overflow:ellipsis (nu mai folosim FittedBox,
                    // care era cauza ruperii). Grid-ul adaptiv de mai sus asigură că
                    // fiecare card are destulă lățime pe orice telefon.
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccentCyan,
                                foregroundColor: kFundal,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: widget.onCiteste,
                              child: const Text(
                                'Citește',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(fontSize: 13, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: widget.onDetalii,
                              child: const Text(
                                'Detalii',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Roboto', fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ECRAN DE LECTURĂ ====================
class EcranLecturaLectie extends StatefulWidget {
  final String titluCarte;
  final String folderAssets;
  final int totalCapitole;
  final int totalPartiAudio;

  const EcranLecturaLectie({
    super.key,
    required this.titluCarte,
    required this.folderAssets,
    required this.totalCapitole,
    required this.totalPartiAudio,
  });

  @override
  State<EcranLecturaLectie> createState() => _EcranLecturaLectieState();
}

class _EcranLecturaLectieState extends State<EcranLecturaLectie> {
  int _capitolCurentIndex = 1;
  String _textIncarcat = "Se încarcă capitolul...";
  double _dimensiuneFont = 17.0;
  bool _esteDarkMode = false;
  final AudioPlayer _audioPlayerGlobal = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _incarcaTextCapitol();
  }

  @override
  void dispose() {
    _audioPlayerGlobal.dispose();
    super.dispose();
  }

  Future<void> _incarcaTextCapitol() async {
    setState(() {
      _textIncarcat = "Se încarcă textul...";
    });
    try {
      String text;
      try {
        text = await rootBundle.loadString('assets/carti/${widget.folderAssets}/capitol$_capitolCurentIndex.txt');
      } catch (_) {
        text = await rootBundle.loadString('assets/carti/${widget.folderAssets}/capitol_$_capitolCurentIndex.txt');
      }
      setState(() {
        _textIncarcat = text;
      });
    } catch (e) {
      setState(() {
        _textIncarcat = "Nu am găsit fișierul text pentru acest capitol.\n\nVerifică structura folderelor assets.";
      });
    }
  }

  void _capitolAnterior() {
    if (_capitolCurentIndex > 1) {
      setState(() => _capitolCurentIndex -= 1);
      _incarcaTextCapitol();
    }
  }

  void _capitolUrmator() {
    if (_capitolCurentIndex < widget.totalCapitole) {
      setState(() => _capitolCurentIndex += 1);
      _incarcaTextCapitol();
    }
  }

  void _deschideModalAudioBook(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kFundalCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Audio Carte', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
            IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
          ],
        ),
        content: SizedBox(
          width: 550,
          height: 500,
          child: ListView.builder(
            itemCount: widget.totalPartiAudio,
            itemBuilder: (context, index) {
              return ItemPlayerAudio(
                numarParte: index + 1,
                folderAssets: widget.folderAssets,
                audioPlayerGlobal: _audioPlayerGlobal,
              );
            },
          ),
        ),
      ),
    );
  }

  void _deschideSelectorCapitole(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kFundalCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Capitole', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Roboto')),
            IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
          ],
        ),
        content: SizedBox(
          width: 320,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: widget.totalCapitole,
            itemBuilder: (context, index) {
              final numarCapitol = index + 1;
              final esteSelectat = _capitolCurentIndex == numarCapitol;
              return InkWell(
                onTap: () async {
                  setState(() => _capitolCurentIndex = numarCapitol);
                  Navigator.pop(context);
                  await _incarcaTextCapitol();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: esteSelectat ? const LinearGradient(colors: [kAccentCyan, kAccentViolet]) : null,
                    color: esteSelectat ? null : kFundalCard2,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('$numarCapitol', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fundalEcran = _esteDarkMode ? kFundal : Colors.white;
    final fundalBara = _esteDarkMode ? kFundalCard : const Color(0xFFF8FAFC);
    final culoareText = _esteDarkMode ? const Color(0xFFE2E8F0) : Colors.black87;
    final progres = _capitolCurentIndex / widget.totalCapitole;
    final ecranIngust = MediaQuery.of(context).size.width < 600;

    return Theme(
      data: ThemeData(brightness: _esteDarkMode ? Brightness.dark : Brightness.light, scaffoldBackgroundColor: fundalEcran),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Column(
            children: [
              AppBar(
                backgroundColor: fundalBara,
                elevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 12,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [kAccentCyan, kAccentViolet]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    if (!ecranIngust)
                      Expanded(child: Text(widget.titluCarte, style: TextStyle(color: culoareText, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                // Toată zona de acțiuni este acum într-un rând derulabil orizontal
                // (SingleChildScrollView), pornit derulat spre dreapta (reverse: true).
                // Astfel, indiferent de lățimea telefonului, butonul "Capitole" este
                // ÎNTOTDEAUNA vizibil complet — nu mai este niciodată tăiat.
                actions: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            icon: Icon(Icons.music_note, color: _esteDarkMode ? kAccentCyan : Colors.blue, size: 22),
                            tooltip: 'Deschide Audio Carte',
                            onPressed: () => _deschideModalAudioBook(context),
                          ),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            icon: const Icon(Icons.text_fields, size: 17),
                            tooltip: 'Micșorează scrisul',
                            onPressed: () {
                              if (_dimensiuneFont > 12) setState(() => _dimensiuneFont -= 1.5);
                            },
                          ),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            icon: const Icon(Icons.text_fields, size: 23),
                            tooltip: 'Mărește scrisul',
                            onPressed: () {
                              if (_dimensiuneFont < 32) setState(() => _dimensiuneFont += 1.5);
                            },
                          ),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            icon: Icon(_esteDarkMode ? Icons.wb_sunny : Icons.wb_sunny_outlined, color: _esteDarkMode ? Colors.orangeAccent : Colors.black54, size: 20),
                            tooltip: _esteDarkMode ? 'Mod Luminos' : 'Mod Întunecat',
                            onPressed: () => setState(() => _esteDarkMode = !_esteDarkMode),
                          ),
                          const SizedBox(width: 6),
                          // Buton "Înapoi" — formă de pilulă, compact
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _esteDarkMode ? kFundalCard2 : const Color(0xFFEFF2F6),
                              foregroundColor: culoareText,
                              elevation: 0,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async {
                              await _audioPlayerGlobal.stop();
                              if (context.mounted) Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, size: 15, color: culoareText),
                            label: Text('Înapoi', style: TextStyle(color: culoareText, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          // Buton "Capitole" — aceeași formă de pilulă, cu contur subțire
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: culoareText,
                              side: BorderSide(color: _esteDarkMode ? Colors.white24 : Colors.black12),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () => _deschideSelectorCapitole(context),
                            icon: Icon(Icons.menu, size: 15, color: culoareText),
                            label: Text('Capitole', style: TextStyle(color: culoareText, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(value: progres, minHeight: 3, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(kAccentCyan)),
            ],
          ),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Capitolul $_capitolCurentIndex / ${widget.totalCapitole}', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: culoareText, height: 1.3)),
                  const SizedBox(height: 28),
                  Text(_textIncarcat, textAlign: TextAlign.left, style: TextStyle(fontSize: _dimensiuneFont, color: culoareText, height: 1.7)),
                  const SizedBox(height: 36),
                  // Butoanele de navigare între capitole — pe telefon (ecran îngust)
                  // sunt așezate unul sub altul, pe toată lățimea, ca să nu dea
                  // niciodată overflow indiferent de dimensiunea textului sau a ecranului.
                  ecranIngust
                      ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _capitolCurentIndex < widget.totalCapitole ? _capitolUrmator : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentCyan,
                            foregroundColor: kFundal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          label: const Text('Capitolul următor', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 13)),
                          icon: const Icon(Icons.chevron_right, size: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _capitolCurentIndex > 1 ? _capitolAnterior : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _esteDarkMode ? Colors.white24 : Colors.black12),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.chevron_left, size: 18),
                          label: const Text('Capitolul anterior', style: TextStyle(fontFamily: 'Roboto', fontSize: 13)),
                        ),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _capitolCurentIndex > 1 ? _capitolAnterior : null,
                        style: OutlinedButton.styleFrom(side: BorderSide(color: _esteDarkMode ? Colors.white24 : Colors.black12)),
                        icon: const Icon(Icons.chevron_left, size: 18),
                        label: const Text('Capitolul anterior', style: TextStyle(fontFamily: 'Roboto', fontSize: 12)),
                      ),
                      ElevatedButton.icon(
                        onPressed: _capitolCurentIndex < widget.totalCapitole ? _capitolUrmator : null,
                        style: ElevatedButton.styleFrom(backgroundColor: kAccentCyan, foregroundColor: kFundal),
                        label: const Text('Capitolul următor', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 12)),
                        icon: const Icon(Icons.chevron_right, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== PLAYER AUDIO ====================
class ItemPlayerAudio extends StatefulWidget {
  final int numarParte;
  final String folderAssets;
  final AudioPlayer audioPlayerGlobal;

  const ItemPlayerAudio({super.key, required this.numarParte, required this.folderAssets, required this.audioPlayerGlobal});

  @override
  State<ItemPlayerAudio> createState() => _ItemPlayerAudioState();
}

class _ItemPlayerAudioState extends State<ItemPlayerAudio> {
  bool _estePornit = false;
  bool _seDeruleazaAcum = false;
  bool _seIncarcaSursa = false;
  Duration _pozitie = Duration.zero;
  Duration _durata = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ascultaSchimbariPlayer();
  }

  void _ascultaSchimbariPlayer() {
    widget.audioPlayerGlobal.onDurationChanged.listen((d) {
      if (mounted) setState(() => _durata = d);
    });
    widget.audioPlayerGlobal.onPositionChanged.listen((p) {
      if (mounted && !_seDeruleazaAcum) setState(() => _pozitie = p);
    });
  }

  Future<String> _obtineSursaAudioCale() async {
    setState(() => _seIncarcaSursa = true);

    final candidatiCaleAsset = [
      'carti/${widget.folderAssets}/audio_${widget.numarParte}.mp3',
      'carti/${widget.folderAssets}/audio_${widget.numarParte}.MP3',
      'carti/${widget.folderAssets}/audio_part_${widget.numarParte}.mp4',
      'carti/${widget.folderAssets}/audio_${widget.numarParte}.mp4',
      'carti/${widget.folderAssets}/audio_part_${widget.numarParte}.mp3',
    ];

    String? assetPathGasit;
    for (final cale in candidatiCaleAsset) {
      try {
        await rootBundle.load('assets/$cale');
        assetPathGasit = cale;
        break;
      } catch (_) {
        continue;
      }
    }

    setState(() => _seIncarcaSursa = false);

    if (assetPathGasit == null) {
      throw Exception('Nu am găsit fișierul audio pentru partea ${widget.numarParte} în ${widget.folderAssets}.');
    }

    return assetPathGasit;
  }

  @override
  Widget build(BuildContext context) {
    double maxSliderValue = _durata.inMilliseconds > 0 ? _durata.inMilliseconds.toDouble() : const Duration(minutes: 30).inMilliseconds.toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kFundalCard2, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Partea ${widget.numarParte}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Roboto')),
              if (_seIncarcaSursa) const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: kAccentCyan)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [kAccentCyan, kAccentViolet]), shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(_estePornit ? Icons.pause : Icons.play_arrow, color: kFundal, size: 22),
                  onPressed: () async {
                    if (_seIncarcaSursa) return;
                    if (_estePornit) {
                      await widget.audioPlayerGlobal.pause();
                      setState(() => _estePornit = false);
                    } else {
                      await widget.audioPlayerGlobal.stop();
                      try {
                        String caleaAsset = await _obtineSursaAudioCale();
                        // IMPORTANT: pe web, Flutter pune fișierele din folderul "assets/"
                        // dublat ("assets/assets/...") în build-ul final — de-asta pe web
                        // trebuie construit manual URL-ul. Pe nativ (telefon/desktop),
                        // AssetSource merge direct, fără nimic special.
                        if (kIsWeb) {
                          await widget.audioPlayerGlobal.setSource(UrlSource('assets/$caleaAsset'));
                        } else {
                          await widget.audioPlayerGlobal.setSource(AssetSource(caleaAsset));
                        }
                        await widget.audioPlayerGlobal.resume();
                        setState(() => _estePornit = true);
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('${_formatTimp(_pozitie)} / ${_formatTimp(_durata)}', style: const TextStyle(color: kTextSecundar, fontSize: 11, fontFamily: 'monospace')),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(thumbColor: kAccentCyan, activeTrackColor: kAccentCyan, inactiveTrackColor: Colors.white12),
                  child: Slider(
                    min: 0.0,
                    max: maxSliderValue,
                    value: _pozitie.inMilliseconds.toDouble().clamp(0.0, maxSliderValue),
                    onChangeStart: (v) => setState(() => _seDeruleazaAcum = true),
                    onChanged: (v) => setState(() => _pozitie = Duration(milliseconds: v.toInt())),
                    onChangeEnd: (v) async {
                      final nP = Duration(milliseconds: v.toInt());
                      try {
                        String caleaAsset = await _obtineSursaAudioCale();
                        if (kIsWeb) {
                          await widget.audioPlayerGlobal.setSource(UrlSource('assets/$caleaAsset'));
                        } else {
                          await widget.audioPlayerGlobal.setSource(AssetSource(caleaAsset));
                        }
                        await widget.audioPlayerGlobal.seek(nP);
                        if (!_estePornit) {
                          await widget.audioPlayerGlobal.setVolume(0.0);
                          await widget.audioPlayerGlobal.resume();
                          await Future.delayed(const Duration(milliseconds: 30));
                          await widget.audioPlayerGlobal.pause();
                          await widget.audioPlayerGlobal.setVolume(1.0);
                        }
                      } catch (_) {}
                      setState(() => _seDeruleazaAcum = false);
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatTimp(Duration d) {
    String douaCifre(int n) => n.toString().padLeft(2, "0");
    return "${douaCifre(d.inMinutes.remainder(60))}:${douaCifre(d.inSeconds.remainder(60))}";
  }
}