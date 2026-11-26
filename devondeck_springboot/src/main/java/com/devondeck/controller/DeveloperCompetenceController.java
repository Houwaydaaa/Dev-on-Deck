
package com.devondeck.controller;
import com.devondeck.entity.DeveloperCompetence;
import com.devondeck.service.DeveloperCompetenceService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/developers")
@CrossOrigin(origins = "*")
public class DeveloperCompetenceController {

    private final DeveloperCompetenceService competenceService;

    public DeveloperCompetenceController(
            DeveloperCompetenceService competenceService) {
        this.competenceService = competenceService;
    }

    /**
     * Récupérer les compétences principales d'un développeur.
     * GET /api/developers/1/competences
     */
    @GetMapping("/{id}/competences")
    public ResponseEntity<List<DeveloperCompetence>> getMainCompetences(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                competenceService.getMainCompetences(id)
        );
    }

    /**
     * Mettre à jour les compétences principales.
     * PUT /api/developers/1/competences
     */
    @PutMapping("/{id}/competences")
    public ResponseEntity<List<DeveloperCompetence>> updateMainCompetences(
            @PathVariable Long id,
            @RequestBody CompetencesRequest request) {

        return ResponseEntity.ok(
                competenceService.updateMainCompetences(
                        id, request.getCompetenceIds())
        );
    }

    /**
     * Retourner HTTP 400 si la sélection est invalide.
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleInvalidCompetences(
            IllegalArgumentException exception) {

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(exception.getMessage());
    }

    public static class CompetencesRequest {

        private List<Long> competenceIds;

        public List<Long> getCompetenceIds() {
            return competenceIds;
        }

        public void setCompetenceIds(List<Long> competenceIds) {
            this.competenceIds = competenceIds;
        }
    }
}
