package com.devondeck.dto;

import jakarta.validation.constraints.*;

public class InscriptionOrganisationRequest {

    @NotBlank(message = "Le nom de l'organisation est obligatoire")
    private String nomOrganisation;

    @NotBlank(message = "Le prénom du contact est obligatoire")
    private String prenomContact;

    @NotBlank(message = "Le nom du contact est obligatoire")
    private String nomContact;

    @NotBlank(message = "L'email est obligatoire")
    @Email(message = "Format d'email invalide")
    private String emailContact;

    @NotBlank(message = "L'adresse est obligatoire")
    private String adresse;

    @NotBlank(message = "La ville est obligatoire")
    private String ville;

    @NotBlank(message = "La région est obligatoire")
    private String region;

    @NotBlank(message = "Le mot de passe est obligatoire")
    @Size(min = 8, message = "Le mot de passe doit contenir au moins 8 caractères")
    private String motDePasse;

    public String getNomOrganisation() { return nomOrganisation; }
    public void setNomOrganisation(String nomOrganisation) { this.nomOrganisation = nomOrganisation; }
    public String getPrenomContact() { return prenomContact; }
    public void setPrenomContact(String prenomContact) { this.prenomContact = prenomContact; }
    public String getNomContact() { return nomContact; }
    public void setNomContact(String nomContact) { this.nomContact = nomContact; }
    public String getEmailContact() { return emailContact; }
    public void setEmailContact(String emailContact) { this.emailContact = emailContact; }
    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }
    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
}

