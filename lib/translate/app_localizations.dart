class AppLocalizations{
  static final Map<String, Map<String, String>> translations = {
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

  static String translate(String lang, String key) {
    return translations[lang]?[key] ?? key;
  }

}