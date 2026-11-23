
import 'package:flutter/material.dart';
import '../widgets/additional_skills.dart';

// Houni na3mlou page profil mta3 el developpeur
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Informations initiales mta3 el developpeur
  String fullName = 'Ahmed Ben Ali';
  String email = 'ahmed@example.com';
  String profession = 'Développeur Full Stack';
  String location = 'Tunis, Tunisie';
  String description =
      'Développeur passionné par la création des applications web et mobiles.';

  // Controllers mta3 formulaire
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final professionController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Fonction bech n7ellou formulaire modification
  Future<void> modifierProfil() async {

    // N7ottou les anciennes informations fel formulaire
    nameController.text = fullName;
    emailController.text = email;
    professionController.text = profession;
    locationController.text = location;
    descriptionController.text = description;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Modifier le profil',
            style: TextStyle(
              color: Color(0xFF25345C),
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Champ esm el developpeur
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom complet',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le nom est obligatoire';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Champ email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email obligatoire';
                        }

                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(value.trim())) {
                          return 'Email invalide';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Champ profession
                    TextFormField(
                      controller: professionController,
                      decoration: const InputDecoration(
                        labelText: 'Profession',
                        prefixIcon: Icon(Icons.work_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Profession obligatoire';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Champ localisation
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Localisation',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Localisation obligatoire';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Champ description
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Boutons annuler et enregistrer
          actions: [

            // Nannulيو el modification
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),

            // Nverifiw les informations w nsajlouhom
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF536DFE),
                foregroundColor: Colors.white,
              ),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    // Ken el user 3mal enregistrer, n7addthou el profil
    if (result == true && mounted) {
      setState(() {
        fullName = nameController.text.trim();
        email = emailController.text.trim();
        profession = professionController.text.trim();
        location = locationController.text.trim();
        description = descriptionController.text.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil modifié avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Nfarrghou controllers ki el page tetna7a
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    professionController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // Barre principale
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DevOnDeck',
          style: TextStyle(
            color: Color(0xFF25345C),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      // Contenu mta3 page profil
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Carte informations personnelles
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [

                  // Avatar developpeur
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFFE8EDFF),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF536DFE),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Nom developpeur
                  Text(
                    fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25345C),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Profession
                  Text(
                    profession,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: Text(email)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Localisation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: Text(location)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Bouton modifier profil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: modifierProfil,
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier le profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF536DFE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Titre description
            const Text(
              'À propos de moi',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25345C),
              ),
            ),

            const SizedBox(height: 12),

            // Carte description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Compétences principales
            const Text(
              'Compétences principales',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25345C),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                'JavaScript',
                'React',
                'Node.js',
                'PostgreSQL',
              ].map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: const Color(0xFFE8EDFF),
                  labelStyle: const TextStyle(
                    color: Color(0xFF536DFE),
                    fontWeight: FontWeight.w500,
                  ),
                  side: BorderSide.none,
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // Compétences supplémentaires
            const Text(
              'Compétences supplémentaires',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25345C),
              ),
            ),

            const SizedBox(height: 12),

            // Widget ajout et suppression compétences
            const AdditionalSkills(),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
