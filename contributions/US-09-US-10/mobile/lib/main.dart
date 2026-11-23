
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DevOnDeckApp());
}

class DevOnDeckApp extends StatelessWidget {
  const DevOnDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dev On Deck',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilPage(),
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController biographieController =
      TextEditingController();

  final int limite = 300;
  final int maxCompetences = 5;

  final String baseUrl = 'http://10.0.2.2:3000';

  String description = '';

  List<dynamic> competences = [];
  List<int> competencesSelectionnees = [];

  bool chargement = true;
  bool enregistrement = false;
  bool enregistrementCompetences = false;

  @override
  void initState() {
    super.initState();
    initialiserProfil();
  }

  Future<void> initialiserProfil() async {
    await recupererProfil();
    await recupererCompetences();
  }

  // Recuperer le profil
  Future<void> recupererProfil() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/developers'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final developers = data['developers'];

        final developer = developers.firstWhere(
          (dev) => dev['id'].toString() == '1',
        );

        biographieController.text =
            developer['biographie'] ?? '';

        description = developer['description'] ?? '';
      } else {
        throw Exception('Erreur de récupération du profil');
      }
    } catch (e) {
      afficherMessage('Erreur de récupération du profil : $e');
    }
  }

  // Recuperer les competences et les choix existants
  Future<void> recupererCompetences() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/competences'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        competences = data['competences'];

        final developerResponse = await http.get(
          Uri.parse('$baseUrl/api/developers'),
        );

        if (developerResponse.statusCode == 200) {
          final developerData =
              jsonDecode(developerResponse.body);

          final developers = developerData['developers'];

          final developer = developers.firstWhere(
            (dev) => dev['id'].toString() == '1',
          );

          final savedCompetences =
              developer['competencesPrincipales'] ?? [];

          competencesSelectionnees = savedCompetences
              .map<int>((c) => int.parse(c['id'].toString()))
              .toList();
        }
      } else {
        throw Exception('Erreur de récupération des compétences');
      }
    } catch (e) {
      afficherMessage('Erreur de récupération des compétences : $e');
    } finally {
      if (mounted) {
        setState(() {
          chargement = false;
        });
      }
    }
  }

  // Enregistrer la biographie
  Future<void> enregistrerProfil() async {
    setState(() {
      enregistrement = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/developers/1/profile'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'biographie': biographieController.text,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        afficherMessage('Biographie enregistrée avec succès !');
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      afficherMessage('Erreur lors de l’enregistrement : $e');
    } finally {
      if (mounted) {
        setState(() {
          enregistrement = false;
        });
      }
    }
  }

  // Gerer la selection des competences
  void modifierSelection(int id, bool? selected) {
    setState(() {
      if (selected == true) {
        if (competencesSelectionnees.length < maxCompetences) {
          competencesSelectionnees.add(id);
        } else {
          afficherMessage(
            'Vous ne pouvez sélectionner que 5 langages maximum.',
          );
        }
      } else {
        competencesSelectionnees.remove(id);
      }
    });
  }

  // Enregistrer les competences
  Future<void> enregistrerCompetences() async {
    setState(() {
      enregistrementCompetences = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/developers/1/competences'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'competenceIds': competencesSelectionnees,
        }),
      );

      if (response.statusCode == 200) {
        afficherMessage(
          'Compétences principales enregistrées avec succès !',
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      afficherMessage('Erreur lors de l’enregistrement : $e');
    } finally {
      if (mounted) {
        setState(() {
          enregistrementCompetences = false;
        });
      }
    }
  }

  void afficherMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    biographieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil développeur'),
      ),
      body: chargement
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biographie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: biographieController,
                    maxLength: limite,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Présentez-vous en quelques mots...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed:
                        enregistrement ? null : enregistrerProfil,
                    child: Text(
                      enregistrement
                          ? 'Enregistrement...'
                          : 'Enregistrer la biographie',
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Mes langages de programmation principaux',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Sélectionnez jusqu’à 5 langages '
                    '(${competencesSelectionnees.length}/5)',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...competences.map((competence) {
                    final int id =
                        int.parse(competence['id'].toString());

                    final String nom = competence['nom'];

                    return CheckboxListTile(
                      title: Text(nom),
                      value: competencesSelectionnees.contains(id),
                      onChanged: (selected) {
                        modifierSelection(id, selected);
                      },
                      controlAffinity:
                          ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: enregistrementCompetences
                          ? null
                          : enregistrerCompetences,
                      child: Text(
                        enregistrementCompetences
                            ? 'Enregistrement...'
                            : 'Enregistrer mes langages',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
