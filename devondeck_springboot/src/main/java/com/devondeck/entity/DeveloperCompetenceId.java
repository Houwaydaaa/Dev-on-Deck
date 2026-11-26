
package com.devondeck.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

/**
 * Clé primaire composée de la table developer_competences.
 */
@Embeddable
public class DeveloperCompetenceId implements Serializable {

    @Column(name = "developer_id")
    private Long developerId;

    @Column(name = "competence_id")
    private Long competenceId;

    public DeveloperCompetenceId() {
    }

    public DeveloperCompetenceId(Long developerId, Long competenceId) {
        this.developerId = developerId;
        this.competenceId = competenceId;
    }

    public Long getDeveloperId() {
        return developerId;
    }

    public void setDeveloperId(Long developerId) {
        this.developerId = developerId;
    }

    public Long getCompetenceId() {
        return competenceId;
    }

    public void setCompetenceId(Long competenceId) {
        this.competenceId = competenceId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof DeveloperCompetenceId)) return false;
        DeveloperCompetenceId that = (DeveloperCompetenceId) o;
        return Objects.equals(developerId, that.developerId)
                && Objects.equals(competenceId, that.competenceId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(developerId, competenceId);
    }
}
