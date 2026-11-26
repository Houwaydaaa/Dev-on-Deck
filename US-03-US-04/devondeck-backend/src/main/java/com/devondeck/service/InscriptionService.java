package com.devondeck.service;

import com.devondeck.dto.InscriptionDeveloppeurRequest;
import com.devondeck.dto.InscriptionOrganisationRequest;
import com.devondeck.model.*;
import com.devondeck.repository.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class InscriptionService {

    private final UtilisateurRepository utilisateurRepo;
    private final DeveloppeurRepository developpeurRepo;
    private final OrganisationRepository organisationRepo;
    private final GouvernoratRepository gouvernoratRepo;
    private final PasswordEncoder passwordEncoder;

    public InscriptionService(UtilisateurRepository utilisateurRepo,
                              DeveloppeurRepository developpeurRepo,
                              OrganisationRepository organisationRepo,
                              GouvernoratRepository gouvernoratRepo,
                              PasswordEncoder passwordEncoder) {
        this.utilisateurRepo = utilisateurRepo;
        this.developpeurRepo = developpeurRepo;
        this.organisationRepo = organisationRepo;
        this.gouvernoratRepo = gouvernoratRepo;
        this.passwordEncoder = passwordEncoder;
    }

    public void inscrireDeveloppeur(InscriptionDeveloppeurRequest req) {
        if (utilisateurRepo.existsByEmail(req.getEmail().trim())) {
            throw new IllegalArgumentException("Cette adresse e-mail est déjà utilisée !");
        }
        Gouvernorat gouv = gouvernoratRepo.findByNom(req.getRegion())
                .orElseThrow(() -> new IllegalArgumentException("Gouvernorat introuvable : " + req.getRegion()));

        Developpeur dev = new Developpeur();
        dev.setPrenom(req.getPrenom().trim());
        dev.setNom(req.getNom().trim());
        dev.setEmail(req.getEmail().trim());
        dev.setAdresse(req.getAdresse().trim());
        dev.setVille(req.getVille().trim());
        dev.setGouvernorat(gouv);
        dev.setMotDePasseHache(passwordEncoder.encode(req.getMotDePasse()));
        developpeurRepo.save(dev);
    }

    public void inscrireOrganisation(InscriptionOrganisationRequest req) {
        if (utilisateurRepo.existsByEmail(req.getEmailContact().trim())) {
            throw new IllegalArgumentException("Cette adresse e-mail est déjà utilisée !");
        }
        Gouvernorat gouv = gouvernoratRepo.findByNom(req.getRegion())
                .orElseThrow(() -> new IllegalArgumentException("Gouvernorat introuvable : " + req.getRegion()));

        Organisation org = new Organisation();
        org.setNomOrganisation(req.getNomOrganisation().trim());
        org.setPrenomContact(req.getPrenomContact().trim());
        org.setNomContact(req.getNomContact().trim());
        org.setEmail(req.getEmailContact().trim());
        org.setAdresse(req.getAdresse().trim());
        org.setVille(req.getVille().trim());
        org.setGouvernorat(gouv);
        org.setMotDePasseHache(passwordEncoder.encode(req.getMotDePasse()));
        organisationRepo.save(org);
    }
}
