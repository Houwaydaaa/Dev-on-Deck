
package com.devondeck.repository;

import com.devondeck.entity.Developer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Repository pour accéder aux données des développeurs.
 * Spring Data JPA fournit automatiquement les opérations CRUD.
 */
@Repository
public interface DeveloperRepository extends JpaRepository<Developer, Long> {
}
