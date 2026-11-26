
import 'package:flutter/material.dart';
import '../services/developer_api_service.dart';

class DeveloperFeatures extends StatefulWidget {
  const DeveloperFeatures({super.key});

  @override
  State<DeveloperFeatures> createState() => _DeveloperFeaturesState();
}

class _DeveloperFeaturesState extends State<DeveloperFeatures> {
  final biographyController = TextEditingController();
  final descriptionController = TextEditingController();

  List<dynamic> competences = [];
  List<int> selectedIds = [];

  bool loading = true;
  bool savingBiography = false;
  bool savingCompetences = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        DeveloperApiService.getDeveloper(),
        DeveloperApiService.getCompetences(),
        DeveloperApiService.getMainCompetences(),
      ]);

      final developer = results[0] as Map<String, dynamic>;
      final allCompetences = results[1] as List<dynamic>;
      final mainCompetences = results[2] as List<dynamic>;

      final ids = <int>[];

      for (final item in mainCompetences) {
        if (item is Map && item['isPrincipale'] == true) {
          final idData = item['id'];

          if (idData is Map && idData['competenceId'] != null) {
            ids.add((idData['competenceId'] as num).toInt());
          }
        }
      }

      if (!mounted) return;

      biographyController.text =
          (developer['biographie'] ?? '').toString();

      descriptionController.text =
          (developer['description'] ?? '').toString();

      setState(() {
        competences = allCompetences;
        selectedIds = ids.toSet().toList();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = 'Impossible de charger les données : $e';
      });
    }
  }

  Future<void> saveBiography() async {
    if (biographyController.text.length > 300) return;

    setState(() => savingBiography = true);

    try {
      await DeveloperApiService.updateBiography(
        biographie: biographyController.text.trim(),
        description: descriptionController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biographie et description enregistrées !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => savingBiography = false);
      }
    }
  }

  void toggleCompetence(int id, bool checked) {
    setState(() {
      if (checked) {
        if (selectedIds.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('5 compétences principales maximum.'),
            ),
          );
          return;
        }

        if (!selectedIds.contains(id)) {
          selectedIds.add(id);
        }
      } else {
        selectedIds.remove(id);
      }
    });
  }

  Future<void> saveCompetences() async {
    setState(() => savingCompetences = true);

    try {
      await DeveloperApiService.updateMainCompetences(selectedIds);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compétences principales enregistrées !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => savingCompetences = false);
      }
    }
  }

  @override
  void dispose() {
    biographyController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF25345C);
    const accentColor = Color(0xFF536DFE);

    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(errorMessage!),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: loadData,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // US-09 : Biographie et description
        const Text(
          'Biographie',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: biographyController,
                maxLength: 300,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ma biographie',
                  hintText: 'Présentez-vous en quelques mots...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivez votre profil...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: savingBiography ? null : saveBiography,
                  icon: savingBiography
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Enregistrer la biographie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // US-10 : Compétences principales
        const Text(
          'Compétences principales',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 6),

        Text(
          '${selectedIds.length}/5 compétences sélectionnées',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              if (competences.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Aucune compétence disponible.'),
                )
              else
                ...competences.map((item) {
                  final competence = item as Map<String, dynamic>;
                  final id = (competence['id'] as num).toInt();
                  final nom = competence['nom']?.toString() ?? '';
                  final categorie =
                      competence['categorie']?.toString() ?? '';

                  return CheckboxListTile(
                    value: selectedIds.contains(id),
                    activeColor: accentColor,
                    title: Text(nom),
                    subtitle: categorie.isEmpty ? null : Text(categorie),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: savingCompetences
                        ? null
                        : (checked) {
                            toggleCompetence(id, checked ?? false);
                          },
                  );
                }),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      savingCompetences ? null : saveCompetences,
                  icon: savingCompetences
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Enregistrer les compétences'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
