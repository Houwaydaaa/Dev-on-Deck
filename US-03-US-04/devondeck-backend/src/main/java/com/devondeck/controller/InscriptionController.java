package com.devondeck.controller;

import com.devondeck.dto.InscriptionDeveloppeurRequest;
import com.devondeck.dto.InscriptionOrganisationRequest;
import com.devondeck.service.InscriptionService;
import jakarta.validation.Valid;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/inscription")
@CrossOrigin(origins = "*")
public class InscriptionController {

    private final InscriptionService inscriptionService;

    public InscriptionController(InscriptionService inscriptionService) {
        this.inscriptionService = inscriptionService;
    }

    @PostMapping("/developpeur")
    public ResponseEntity<?> inscrireDeveloppeur(@Valid @RequestBody InscriptionDeveloppeurRequest req) {
        try {
            inscriptionService.inscrireDeveloppeur(req);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of("message", "Inscription développeur réussie !"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("message", e.getMessage()));
        }
    }

    @PostMapping("/organisation")
    public ResponseEntity<?> inscrireOrganisation(@Valid @RequestBody InscriptionOrganisationRequest req) {
        try {
            inscriptionService.inscrireOrganisation(req);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of("message", "Inscription organisation réussie !"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("message", e.getMessage()));
        }
    }
}

