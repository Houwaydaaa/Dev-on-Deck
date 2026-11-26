
import 'package:flutter/material.dart';
import 'screens/inscription_developpeur_screen.dart';
import 'screens/inscription_organisation_screen.dart';

void main() {
  runApp(const DevOnDeckApp());
}

class DevOnDeckApp extends StatelessWidget {
  const DevOnDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevOnDeck',
      debugShowCheckedModeBanner: false,
      initialRoute: '/developpeur',
      routes: {
        '/developpeur': (context) => const InscriptionDeveloppeurScreen(),
        '/organisation': (context) => const InscriptionOrganisationScreen(),
      },
    );
  }
}
