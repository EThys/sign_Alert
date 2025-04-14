import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedLanguage = 'Français'; // Langue par défaut

  final List<Map<String, String>> languages = [
    {'value': 'fr', 'display': 'Français'},
    {'value': 'ln', 'display': 'Lingala'},
    {'value': 'kg', 'display': 'Kikongo'},
  ];

  // Données traduisibles
  Map<String, Map<String, String>> translations = {
    'fr': {
      'appTitle': 'CivicLaw',
      'heroTitle': 'Connaissez vos droits',
      'heroSubtitle': 'Accédez simplement aux lois qui impactent votre quotidien',
      'searchHint': 'Rechercher une loi, un décret...',
      'featuredLaws': 'Lois à connaître',
      'seeAll': 'Tout voir',
      'quickAccess': 'Accès rapide',
      'reportProblem': 'Signaler un problème',
      'localCommittees': 'Comités locaux',
      'interactiveMap': 'Carte interactive',
      'ideasBox': 'Boîte à idées',
      'legalNews': 'Actualités juridiques',
      'didYouKnow': 'Le saviez-vous ?',
      'noiseDecree': "Depuis le décret du 06/12/2022, les nuisances sonores après 22h peuvent entraîner une amende allant jusqu'à 100.000 FC.",
      'learnMore': 'En savoir plus',
    },
    'ln': {
      'appTitle': 'CivicLaw',
      'heroTitle': 'Yeba mibeko na yo',
      'heroSubtitle': 'Kokuta mibeko eye ekosala na bomoi na yo',
      'searchHint': 'Sosa mibeko, makambo...',
      'featuredLaws': 'Mibeko ya kokoka',
      'seeAll': 'Komona nyonso',
      'quickAccess': 'Ndelo ya noki',
      'reportProblem': 'Kolobela problème',
      'localCommittees': 'Ba comité ya mboka',
      'interactiveMap': 'Karte ya kokoma',
      'ideasBox': 'Boîte ya makanisi',
      'legalNews': 'Sango ya mibeko',
      'didYouKnow': 'Oyebaki ete...',
      'noiseDecree': "Utango 06/12/2022, makelele na mpokwa ekoki kotia moto na amende ya 100.000 FC.",
      'learnMore': 'Koyeba mingi',
    },
    'kg': {
      'appTitle': 'CivicLaw',
      'heroTitle': 'Zaba mambu ya mibeko',
      'heroSubtitle': 'Monana mambu ya mibeko na mawa na nge',
      'searchHint': 'Sosa mibeko, bisambu...',
      'featuredLaws': 'Mibeko ya ntete',
      'seeAll': 'Monana yonso',
      'quickAccess': 'Ndelo ya mbala',
      'reportProblem': 'Sakola problème',
      'localCommittees': 'Ba comité ya zando',
      'interactiveMap': 'Karte ya kusala',
      'ideasBox': 'Boîte ya ndongisila',
      'legalNews': 'Nsangu ya mibeko',
      'didYouKnow': 'Nge ozabaki nde...',
      'noiseDecree': "Kutanga 06/12/2022, makelele na mpimpa ekoki kotula moto na amende ya 100.000 FC.",
      'learnMore': 'Kuzaba mingi',
    },
  };

  String _t(String key) {
    return translations[_selectedLanguage.substring(0, 2).toLowerCase()]?[key] ?? key;
  }

  final List<LawItem> featuredLaws = [
    LawItem(
      title: {
        'fr': "Décret sur les Nuisances Sonores",
        'ln': "Mibeko ya makelele",
        'kg': "Mibeko ya makelele"
      },
      summary: {
        'fr': "Nouvelles règles contre le tapage nocturne (06/12/2022)",
        'ln': "Mibeko ya sika ya makelele (06/12/2022)",
        'kg': "Mibeko ya sika ya makelele (06/12/2022)"
      },
      icon: Icons.volume_off,
      category: {
        'fr': "Vie Quotidienne",
        'ln': "Bomoi ya mokolo",
        'kg': "Bomoi ya mokolo"
      },
    ),
    LawItem(
      title: {
        'fr': "Loi sur la Salubrité Publique",
        'ln': "Mibeko ya propreté",
        'kg': "Mibeko ya kitoko"
      },
      summary: {
        'fr': "Obligations de propreté dans les espaces communs",
        'ln': "Kosala propreté na espace ya bato nyonso",
        'kg': "Kusala kitoko na espace ya bantu yonso"
      },
      icon: Icons.clean_hands,
      category: {
        'fr': "Environnement",
        'ln': "Environnement",
        'kg': "Environnement"
      },
    ),
    LawItem(
      title: {
        'fr': "Droits des Citoyens",
        'ln': "Mitunga ya moto",
        'kg': "Mitunga ya muntu"
      },
      summary: {
        'fr': "Vos droits face aux forces de l'ordre",
        'ln': "Mitunga na yo ntango ba policier bakosenga yo",
        'kg': "Mitunga na nge ntango ba policier bakosenga nge"
      },
      icon: Icons.gavel,
      category: {
        'fr': "Droits Fondamentaux",
        'ln': "Mitunga ya moto",
        'kg': "Mitunga ya muntu"
      },
    ),
  ];

  final List<NewsItem> newsItems = [
    NewsItem(
      title: {
        'fr': "Nouvelle Campagne de Sensibilisation",
        'ln': "Kampagne ya sika ya koyebisa",
        'kg': "Kampagne ya sika ya kuzabisa"
      },
      date: "15 Mars 2023",
      imageUrl: "assets/news1.jpg",
    ),
    NewsItem(
      title: {
        'fr': "Formation des Comités Locaux",
        'ln': "Kokoma ba comité ya mboka",
        'kg': "Kukoma ba comité ya zando"
      },
      date: "10 Mars 2023",
      imageUrl: "assets/news2.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.8; // 80% de la largeur de l'écran

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t('appTitle'),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2A5C99),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return languages.map((language) {
                return PopupMenuItem<String>(
                  value: language['display'],
                  child: Text(language['display']!),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    _selectedLanguage.substring(0, 2),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
        // Hero Section
        Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A5C99), Color(0xFF3A7BC8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('heroTitle'),
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _t('heroSubtitle'),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.balance,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: _t('searchHint'),
                  hintStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),

      // Featured Laws Section
      Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _t('featuredLaws'),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2A5C99),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    _t('seeAll'),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE6B33D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredLaws.length,
                itemBuilder: (context, index) {
                  return _buildLawCard(
                      context,
                      featuredLaws[index],
                      cardWidth,
                      _selectedLanguage.substring(0, 2).toLowerCase()
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Quick Access Section
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t('quickAccess'),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2A5C99),
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildQuickAccessCard(
                  context,
                  Icons.report_problem,
                  _t('reportProblem'),
                  const Color(0xFFD93E30),
                      () {},
                ),
                _buildQuickAccessCard(
                  context,
                  Icons.people,
                  _t('localCommittees'),
                  const Color(0xFF2A5C99),
                      () {},
                ),
                _buildQuickAccessCard(
                  context,
                  Icons.map,
                  _t('interactiveMap'),
                  const Color(0xFF4CAF50),
                      () {},
                ),
                _buildQuickAccessCard(
                  context,
                  Icons.lightbulb_outline,
                  _t('ideasBox'),
                  const Color(0xFFE6B33D),
                      () {},
                ),
              ],
            ),
          ],
        ),
      ),

      // News Section
      Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _t('legalNews'),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2A5C99),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    _t('seeAll'),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE6B33D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: newsItems
                  .map((news) => _buildNewsItem(
                  context,
                  news,
                  _selectedLanguage.substring(0, 2).toLowerCase()
              ))
                  .toList(),
            ),
          ],
        ),
      ),

      // Did You Know Section
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE6B33D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFE6B33D).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
        children: [
        Icon(Icons.lightbulb_outline, color: const Color(0xFFE6B33D)),
          const SizedBox(width: 10),
          Text(
            _t('didYouKnow'),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2A5C99),
            ),
          ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _t('noiseDecree'),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
        ),
        ],
      ),
    ),

    const SizedBox(height: 30),
    ],
    ),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {},
    backgroundColor: const Color(0xFFD93E30),
    child: const Icon(Icons.emergency),
    ),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (index) {
    setState(() {
    _currentIndex = index;
    });
    },
    selectedItemColor: const Color(0xFF2A5C99),
    unselectedItemColor: Colors.grey,
    items: [
    BottomNavigationBarItem(
    icon: const Icon(Icons.home),
    label: _t('quickAccess'),
    ),
    BottomNavigationBarItem(
    icon: const Icon(Icons.library_books),
    label: _t('featuredLaws'),
    ),
    BottomNavigationBarItem(
    icon: const Icon(Icons.new_releases),
    label: _t('legalNews'),
    ),
    BottomNavigationBarItem(
    icon: const Icon(Icons.person),
    label: _t('localCommittees'),
    ),
    ],
    ),
    );
  }

  Widget _buildLawCard(BuildContext context, LawItem law, double width, String lang) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2A5C99).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(
                law.icon,
                size: 40,
                color: const Color(0xFF2A5C99),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6B33D).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    law.category[lang] ?? law.category['fr']!,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE6B33D),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  law.title[lang] ?? law.title['fr']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A5C99),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  law.summary[lang] ?? law.summary['fr']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        _t('learnMore'),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A5C99),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF2A5C99),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(BuildContext context, IconData icon,
      String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(BuildContext context, NewsItem news, String lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.asset(
              news.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      news.date,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  news.title[lang] ?? news.title['fr']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A5C99),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _t('learnMore'),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE6B33D),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xFFE6B33D),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LawItem {
  final Map<String, String> title;
  final Map<String, String> summary;
  final IconData icon;
  final Map<String, String> category;

  LawItem({
    required this.title,
    required this.summary,
    required this.icon,
    required this.category,
  });
}

class NewsItem {
  final Map<String, String> title;
  final String date;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.date,
    required this.imageUrl,
  });
}