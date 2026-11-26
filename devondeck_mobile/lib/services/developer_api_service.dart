
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeveloperApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const int developerId = 1;

  // Recuperer les informations du developpeur
  static Future<Map<String, dynamic>> getDeveloper() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/developers/$developerId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Erreur chargement profil: ${response.statusCode}');
  }

  // Recuperer toutes les competences disponibles
  static Future<List<dynamic>> getCompetences() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/competences'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Erreur chargement competences: ${response.statusCode}');
  }

  // Recuperer les competences principales du developpeur
  static Future<List<dynamic>> getMainCompetences() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/developers/$developerId/competences'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Erreur chargement competences principales: ${response.statusCode}');
  }

  // Enregistrer la biographie et la description
  static Future<void> updateBiography({
    required String biographie,
    required String description,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/developers/$developerId/biography'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'biographie': biographie,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur sauvegarde profil: ${response.statusCode} - ${response.body}');
    }
  }

  // Enregistrer les competences principales (maximum 5)
  static Future<void> updateMainCompetences(
    List<int> competenceIds,
  ) async {
    if (competenceIds.length > 5) {
      throw Exception('Vous pouvez choisir 5 competences maximum.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/developers/$developerId/competences'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'competenceIds': competenceIds,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur sauvegarde competences: ${response.statusCode} - ${response.body}');
    }
  }
}
