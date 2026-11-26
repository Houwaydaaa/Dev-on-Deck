
package com.devondeck.service;

import com.devondeck.entity.Developer;
import com.devondeck.repository.DeveloperRepository;
import org.springframework.stereotype.Service;

@Service
public class DeveloperService {

    private final DeveloperRepository developerRepository;

    public DeveloperService(DeveloperRepository developerRepository) {
        this.developerRepository = developerRepository;
    }

    /**
     * Met à jour la biographie et la description.
     * La biographie ne doit pas dépasser 300 caractères.
     */
    public Developer getDeveloper(Long id) {
    return developerRepository.findById(id)
        .orElseThrow(() -> new RuntimeException(
            "Développeur introuvable avec l'identifiant : " + id
        ));
}
    public Developer updateProfile(Long id, String biographie, String description) {

        if (biographie != null && biographie.length() > 300) {
            throw new IllegalArgumentException(
                "La biographie ne doit pas dépasser 300 caractères."
            );
        }

        Developer developer = developerRepository.findById(id)
            .orElseThrow(() -> new RuntimeException(
                "Développeur introuvable avec l'identifiant : " + id
            ));

        developer.setBiographie(biographie);
        developer.setDescription(description);

        return developerRepository.save(developer);
    }
}
