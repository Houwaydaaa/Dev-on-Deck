package com.devondeck.controller;

import com.devondeck.entity.Competence;
import com.devondeck.repository.CompetenceRepository;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/competences")
@CrossOrigin(origins = "*")
public class CompetenceController {

    private final CompetenceRepository competenceRepository;

    public CompetenceController(CompetenceRepository competenceRepository) {
        this.competenceRepository = competenceRepository;
    }

    @GetMapping
    public List<Competence> getAllCompetences() {
        return competenceRepository.findAll();
    }
}