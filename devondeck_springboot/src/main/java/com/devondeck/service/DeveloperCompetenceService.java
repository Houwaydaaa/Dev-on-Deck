
package com.devondeck.service;

import com.devondeck.entity.DeveloperCompetence;
import com.devondeck.entity.DeveloperCompetenceId;
import com.devondeck.repository.DeveloperCompetenceRepository;
import com.devondeck.repository.DeveloperRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.devondeck.entity.Competence;
import com.devondeck.repository.CompetenceRepository;
import java.util.HashSet;
import java.util.Set;

import java.util.List;

@Service
public class DeveloperCompetenceService {

    private final DeveloperCompetenceRepository developerCompetenceRepository;
    private final DeveloperRepository developerRepository;
    private final CompetenceRepository competenceRepository;

    public DeveloperCompetenceService(
        DeveloperCompetenceRepository developerCompetenceRepository,
        DeveloperRepository developerRepository,
        CompetenceRepository competenceRepository) {

    this.developerCompetenceRepository = developerCompetenceRepository;
    this.developerRepository = developerRepository;
    this.competenceRepository = competenceRepository;
}

    /**
     * Récupère les compétences principales d'un développeur.
     */
    public List<DeveloperCompetence> getMainCompetences(Long developerId) {

        if (!developerRepository.existsById(developerId)) {
            throw new RuntimeException("Développeur introuvable.");
        }

        return developerCompetenceRepository
                .findByIdDeveloperId(developerId)
                .stream()
                .filter(competence -> Boolean.TRUE.equals(
                        competence.getIsPrincipale()))
                .toList();
    }

    /**
     * Remplace les compétences principales d'un développeur.
     * Maximum : 5 compétences.
     */
    
@Transactional
public List<DeveloperCompetence> updateMainCompetences(
        Long developerId, List<Long> competenceIds) {

    if (!developerRepository.existsById(developerId)) {
        throw new RuntimeException("Développeur introuvable.");
    }

    if (competenceIds == null || competenceIds.size() > 5) {
        throw new IllegalArgumentException(
                "Vous devez sélectionner au maximum 5 compétences."
        );
    }

    if (competenceIds.contains(null)
            || competenceIds.stream().distinct().count() != competenceIds.size()) {
        throw new IllegalArgumentException(
                "Sélection invalide : compétences nulles ou en double."
        );
    }

    // Vérifier que toutes les compétences existent.
    Set<Long> selectedIds = new HashSet<>(competenceIds);

    List<Competence> existingCompetences =
            competenceRepository.findAllById(selectedIds);

    if (existingCompetences.size() != selectedIds.size()) {
        throw new IllegalArgumentException(
                "Une ou plusieurs compétences n'existent pas."
        );
    }

    // Récupérer les associations déjà enregistrées.
    List<DeveloperCompetence> current =
            developerCompetenceRepository.findByIdDeveloperId(developerId);

    Set<Long> existingIds = new HashSet<>();

    // Mettre à jour les associations existantes.
    for (DeveloperCompetence association : current) {
        Long competenceId = association.getId().getCompetenceId();

        existingIds.add(competenceId);

        association.setIsPrincipale(selectedIds.contains(competenceId));
    }

    // Créer uniquement les associations qui n'existent pas.
    for (Long competenceId : selectedIds) {
        if (!existingIds.contains(competenceId)) {

            DeveloperCompetence association = new DeveloperCompetence();

            association.setId(
                    new DeveloperCompetenceId(developerId, competenceId)
            );

            association.setIsPrincipale(true);

            current.add(association);
        }
    }

    // Enregistrer les modifications sans supprimer les anciennes associations.
    developerCompetenceRepository.saveAll(current);

    return current.stream()
            .filter(c -> Boolean.TRUE.equals(c.getIsPrincipale()))
            .toList();
}
}