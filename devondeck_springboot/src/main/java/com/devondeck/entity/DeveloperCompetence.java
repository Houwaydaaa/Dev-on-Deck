
package com.devondeck.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

/**
 * Entité représentant l'association entre un développeur
 * et une compétence principale.
 */
@Entity
@Table(name = "developer_competences")
public class DeveloperCompetence {

    @EmbeddedId
    private DeveloperCompetenceId id;

    @Column(name = "is_principale")
    private Boolean isPrincipale = false;

    public DeveloperCompetence() {
    }

    public DeveloperCompetenceId getId() {
        return id;
    }

    public void setId(DeveloperCompetenceId id) {
        this.id = id;
    }

    public Boolean getIsPrincipale() {
        return isPrincipale;
    }

    public void setIsPrincipale(Boolean isPrincipale) {
        this.isPrincipale = isPrincipale;
    }
}
