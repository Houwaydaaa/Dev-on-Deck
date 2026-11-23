
import 'package:flutter/material.dart';

// Houni na3mlou widget mta3 competences supplementaires
class AdditionalSkills extends StatefulWidget {
  const AdditionalSkills({super.key});

  @override
  State<AdditionalSkills> createState() => _AdditionalSkillsState();
}

class _AdditionalSkillsState extends State<AdditionalSkills> {

  // Hethi liste mta3 competences elli 3and el developpeur
  final List<String> skills = [
    'Python',
    'Java',
  ];

  // Houni ncontroliw chnowa yekteb el user
  final TextEditingController skillController = TextEditingController();

  // Fonction bech nzidou competence jdida
  void addSkill() {
    String newSkill = skillController.text.trim();

    // Ma nzidouch champ feragh
    if (newSkill.isEmpty) {
      return;
    }

    // Nthabtou ken el competence mawjouda deja
    bool exists = skills.any(
      (skill) => skill.toLowerCase() == newSkill.toLowerCase(),
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cette compétence existe déjà !'),
        ),
      );
      return;
    }

    // Nzidou el competence lel liste
    setState(() {
      skills.add(newSkill);
      skillController.clear();
    });
  }

  // Fonction bech nna7iw competence
  void deleteSkill(int index) {
    setState(() {
      skills.removeAt(index);
    });
  }

  @override
  void dispose() {
    // Nsakrou el controller ki el widget tetna7a
    skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Champ bech el user yekteb competence jdida
        TextField(
          controller: skillController,
          decoration: InputDecoration(
            hintText: 'Ex: Python, Flutter...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              onPressed: addSkill,
              icon: const Icon(
                Icons.add_circle,
                color: Color(0xFF536DFE),
              ),
            ),
          ),
          onSubmitted: (_) => addSkill(),
        ),

        const SizedBox(height: 15),

        // Ken el liste feragha nwarriw message
        if (skills.isEmpty)
          const Text('Aucune compétence supplémentaire.'),

        // Naffichiw les competences wa7da wa7da
        ...skills.asMap().entries.map((entry) {
          int index = entry.key;
          String skill = entry.value;

          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(
                Icons.code,
                color: Color(0xFF536DFE),
              ),
              title: Text(skill),
              trailing: IconButton(
                onPressed: () => deleteSkill(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
