
package com.devondeck.repository;

import com.devondeck.entity.DeveloperCompetence;
import com.devondeck.entity.DeveloperCompetenceId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DeveloperCompetenceRepository
        extends JpaRepository<DeveloperCompetence, DeveloperCompetenceId> {

    List<DeveloperCompetence> findByIdDeveloperId(Long developerId);
}
