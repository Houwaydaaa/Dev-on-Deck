package com.devondeck.repository;

import com.devondeck.model.Gouvernorat;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface GouvernoratRepository extends JpaRepository<Gouvernorat, Long> {
    Optional<Gouvernorat> findByNom(String nom);
}

