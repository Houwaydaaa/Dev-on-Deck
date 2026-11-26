
package com.devondeck.controller;

import com.devondeck.entity.Developer;
import com.devondeck.service.DeveloperService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/developers")
@CrossOrigin(origins = "*")
public class DeveloperController {

    private final DeveloperService developerService;

    public DeveloperController(DeveloperService developerService) {
        this.developerService = developerService;
    }
    @GetMapping("/{id}")
    public ResponseEntity<Developer> getDeveloper(@PathVariable Long id) {
         Developer developer = developerService.getDeveloper(id);
         return ResponseEntity.ok(developer);
    }
    @PutMapping("/{id}/biography")
    public ResponseEntity<Developer> updateProfile(
            @PathVariable Long id,
            @RequestBody ProfileRequest request) {

        Developer developer = developerService.updateProfile(
            id,
            request.getBiographie(),
            request.getDescription()
        );

        return ResponseEntity.ok(developer);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleIllegalArgument(
            IllegalArgumentException exception) {
        return ResponseEntity.badRequest().body(exception.getMessage());
    }

    public static class ProfileRequest {

        private String biographie;
        private String description;

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
}
