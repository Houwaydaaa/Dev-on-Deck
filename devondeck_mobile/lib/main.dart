
import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';

// Hethi el fonction elli tebda menha el application
void main() {
  runApp(const DevOnDeckApp());
}

// Houni na3mlou el classe principale mta3 el application
class DevOnDeckApp extends StatelessWidget {
  const DevOnDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nna7iw el bande DEBUG elli تظهر fou9
      debugShowCheckedModeBanner: false,

      // Esm el application
      title: 'DevOnDeck',

      // Houni na3mlou configuration mta3 el design
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      // Hethi awel page bech tet7al ki n7ellou el application
      home: const ProfileScreen(),
    );
  }
}
