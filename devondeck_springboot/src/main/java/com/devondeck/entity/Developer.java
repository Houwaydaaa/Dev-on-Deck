
package com.devondeck.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;

/**
 * Entité représentant un développeur dans la base PostgreSQL.
 */
@Entity
@Table(name = "developers")
public class Developer {

    // Identifiant unique généré automatiquement par PostgreSQL
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Nom du développeur
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;

    // Adresse email unique du développeur
    @Column(name = "email", nullable = false, unique = true)
    private String email;

    // Biographie limitée à 300 caractères (US-09)
    @Size(max = 300, message = "La biographie ne doit pas dépasser 300 caractères")
    @Column(name = "biographie", length = 300)
    private String biographie;

    // Description complémentaire du développeur
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    // Constructeur vide nécessaire à JPA
    public Developer() {
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBiographie() {
        return biographie;
    }

    public void setBiographie(String biographie) {
        this.biographie = biographie;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
