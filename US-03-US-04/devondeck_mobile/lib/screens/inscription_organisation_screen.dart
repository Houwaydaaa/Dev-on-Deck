
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InscriptionOrganisationScreen extends StatefulWidget {
  const InscriptionOrganisationScreen({super.key});

  @override
  State<InscriptionOrganisationScreen> createState() =>
      _InscriptionOrganisationScreenState();
}

class _InscriptionOrganisationScreenState
    extends State<InscriptionOrganisationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _orgCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _mdpCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String? _region;
  String? _emailError;

  bool _loading = false;
  bool _obscure = true;

  final List<String> _gouvernorats = const [
    'Ariana',
    'Béja',
    'Ben Arous',
    'Bizerte',
    'Gabès',
    'Gafsa',
    'Jendouba',
    'Kairouan',
    'Kasserine',
    'Kébili',
    'Le Kef',
    'Mahdia',
    'La Manouba',
    'Médenine',
    'Monastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan',
  ];

  // Chrome / Windows :
  // http://localhost:8080/inscription/organisation
  //
  // Émulateur Android :
  // http://10.0.2.2:8080/inscription/organisation

  static const String _apiUrl =
      'http://localhost:8080/inscription/organisation';

  @override
  void dispose() {
    _orgCtrl.dispose();
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _adresseCtrl.dispose();
    _villeCtrl.dispose();
    _mdpCtrl.dispose();
    _confirmCtrl.dispose();

    super.dispose();
  }

  // Réinitialiser le formulaire
  void _reset() {
    _formKey.currentState?.reset();

    _orgCtrl.clear();
    _prenomCtrl.clear();
    _nomCtrl.clear();
    _emailCtrl.clear();
    _adresseCtrl.clear();
    _villeCtrl.clear();
    _mdpCtrl.clear();
    _confirmCtrl.clear();

    setState(() {
      _region = null;
      _emailError = null;
    });
  }

  // Envoyer les données au serveur Spring Boot
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nomOrganisation': _orgCtrl.text.trim(),
          'prenomContact': _prenomCtrl.text.trim(),
          'nomContact': _nomCtrl.text.trim(),
          'emailContact': _emailCtrl.text.trim(),
          'adresse': _adresseCtrl.text.trim(),
          'ville': _villeCtrl.text.trim(),
          'region': _region,
          'motDePasse': _mdpCtrl.text,
        }),
      );

      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: const Text('Inscription enregistrée !'),
            content: Text(
              'Merci ${_prenomCtrl.text.trim()}, '
              'le compte de ${_orgCtrl.text.trim()} '
              'a bien été créé.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _reset();
                },
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _emailError = data['message'] ?? 'Erreur inscription';
        });

        _formKey.currentState!.validate();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Serveur Spring Boot inaccessible (8080)',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Style des champs
  InputDecoration _dec(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9A93A8),
        fontSize: 14,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD9D0E8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD9D0E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF7B2D8E),
          width: 1.5,
        ),
      ),
    );
  }

  // Création d'un champ de formulaire
  Widget _field(
    String label,
    TextEditingController ctrl,
    String hint, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? val,
    void Function(String)? onChanged,
    bool last = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1B2E),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: type,
            obscureText: obscure,
            textInputAction:
                last ? TextInputAction.done : TextInputAction.next,
            onFieldSubmitted: last ? (_) => _submit() : null,
            onChanged: onChanged,
            decoration: _dec(hint, suffix: suffix),
            validator: val,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête DevOnDeck
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2A1450),
                    Color(0xFF4A1F7A),
                    Color(0xFF7B2D8E),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/logo.png', width: 42, height: 42),
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'DevOn'),
                            TextSpan(
                              text: 'Deck',
                              style: TextStyle(
                                color: Color(0xFFFF9E8A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect • Build • Launch',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Trouvez le bon profil.\nLancez votre projet.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),

            // Contenu du formulaire
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Navigation entre les profils
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E3F1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/developpeur',
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Développeur',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5B4A78),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Organisation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5B2D8E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Créer le compte de mon organisation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B2E),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Quelques informations, puis vous publierez vos postes.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF6B6280),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _field(
                          "Nom de l'organisation",
                          _orgCtrl,
                          'Entreprise, startup ou association',
                          val: (v) => v!.trim().isEmpty
                              ? "Nom d'organisation obligatoire"
                              : null,
                        ),

                        _field(
                          'Prénom du contact',
                          _prenomCtrl,
                          'Prénom',
                          val: (v) => v!.trim().isEmpty
                              ? 'Prénom obligatoire'
                              : null,
                        ),

                        _field(
                          'Nom du contact',
                          _nomCtrl,
                          'Nom',
                          val: (v) => v!.trim().isEmpty
                              ? 'Nom obligatoire'
                              : null,
                        ),

                        _field(
                          'E-mail de contact',
                          _emailCtrl,
                          'contact@organisation.com',
                          type: TextInputType.emailAddress,
                          onChanged: (_) {
                            setState(() {
                              _emailError = null;
                            });
                          },
                          val: (v) {
                            if (v!.trim().isEmpty) {
                              return 'E-mail obligatoire';
                            }

                            if (!RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            ).hasMatch(v.trim())) {
                              return 'E-mail invalide';
                            }

                            return _emailError;
                          },
                        ),

                        _field(
                          "Adresse de l'organisation",
                          _adresseCtrl,
                          'Rue, numéro',
                          val: (v) => v!.trim().isEmpty
                              ? 'Adresse obligatoire'
                              : null,
                        ),

                        _field(
                          'Ville',
                          _villeCtrl,
                          'Tunis',
                          val: (v) => v!.trim().isEmpty
                              ? 'Ville obligatoire'
                              : null,
                        ),

                        const Text(
                          'État / Région',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1B2E),
                          ),
                        ),

                        const SizedBox(height: 6),

                        DropdownButtonFormField<String>(
                          value: _region,
                          decoration: _dec('-- Choisir --'),
                          items: _gouvernorats.map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              _region = v;
                            });
                          },
                          validator: (v) => v == null
                              ? 'Choisissez une région'
                              : null,
                        ),

                        const SizedBox(height: 14),

                        _field(
                          'Mot de passe',
                          _mdpCtrl,
                          '8 caractères minimum',
                          obscure: _obscure,
                          suffix: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          val: (v) => v!.length < 8
                              ? 'Minimum 8 caractères'
                              : null,
                        ),

                        _field(
                          'Confirmer le mot de passe',
                          _confirmCtrl,
                          'Répétez le mot de passe',
                          obscure: _obscure,
                          last: true,
                          val: (v) => v != _mdpCtrl.text
                              ? 'Les mots de passe diffèrent'
                              : null,
                        ),

                        const SizedBox(height: 8),

                        // Bouton d'inscription
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF5B2D8E),
                                Color(0xFFC0394F),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),

                        // Réinitialiser le formulaire
                        Center(
                          child: TextButton(
                            onPressed: _loading ? null : _reset,
                            child: const Text(
                              'Réinitialiser',
                              style: TextStyle(
                                color: Color(0xFF6B6280),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Lien de connexion
                        Center(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6280),
                              ),
                              children: [
                                TextSpan(text: 'Déjà inscrit ? '),
                                TextSpan(
                                  text: 'Se connecter',
                                  style: TextStyle(
                                    color: Color(0xFF5B2D8E),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
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
    );
  }
}

