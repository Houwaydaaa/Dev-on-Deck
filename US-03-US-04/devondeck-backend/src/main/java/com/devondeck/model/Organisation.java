package com.devondeck.model;

import jakarta.persistence.*;

@Entity
@Table(name = "organisation")
public class Organisation extends Utilisateur {

    @Column(name = "nom_organisation", nullable = false)
    private String nomOrganisation;

    @Column(name = "prenom_contact", nullable = false)
    private String prenomContact;

    @Column(name = "nom_contact", nullable = false)
    private String nomContact;

    @Column(nullable = false)
    private String adresse;

    @Column(nullable = false)
    private String ville;

    @ManyToOne
    @JoinColumn(name = "gouvernorat_id", nullable = false)
    private Gouvernorat gouvernorat;

    public String getNomOrganisation() { return nomOrganisation; }
    public void setNomOrganisation(String nomOrganisation) { this.nomOrganisation = nomOrganisation; }
    public String getPrenomContact() { return prenomContact; }
    public void setPrenomContact(String prenomContact) { this.prenomContact = prenomContact; }
    public String getNomContact() { return nomContact; }
    public void setNomContact(String nomContact) { this.nomContact = nomContact; }
    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }
    public Gouvernorat getGouvernorat() { return gouvernorat; }
    public void setGouvernorat(Gouvernorat gouvernorat) { this.gouvernorat = gouvernorat; }
}

