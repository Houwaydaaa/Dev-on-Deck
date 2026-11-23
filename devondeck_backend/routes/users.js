
const express = require("express");
const router = express.Router();
const pool = require("../config/db");

// Houni n'affichiw les utilisateurs lkol mel base de données
router.get("/", async (req, res) => {
  try {
    // Nطلبو les utilisateurs lkol men table users
    const result = await pool.query(
      "SELECT * FROM users ORDER BY id ASC"
    );

    // Nرجعو les données en format JSON
    res.status(200).json(result.rows);

  } catch (error) {
    // Ken صار erreur, n'affichiwha fel terminal
    console.error(error.message);

    res.status(500).json({
      message: "Erreur lors de la récupération des utilisateurs"
    });
  }
});

// Houni nzidou utilisateur jdid fel base de données
router.post("/", async (req, res) => {
  try {
    // Nakhthou les informations eli b3athhom el utilisateur
    const { full_name, email, profession, location, description } = req.body;

    // Nethabtou eli esm w email mahoumch ferghin
    if (!full_name || !email) {
      return res.status(400).json({
        message: "Le nom et l'email sont obligatoires"
      });
    }

    // Ninsirtiw les données fel table users
    const result = await pool.query(
      `INSERT INTO users
       (full_name, email, profession, location, description)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [
        full_name,
        email,
        profession || null,
        location || null,
        description || null
      ]
    );

    // Nرجعو utilisateur eli tzad bel succès
    res.status(201).json({
      message: "Utilisateur ajouté avec succès",
      user: result.rows[0]
    });

  } catch (error) {
    // N'affichiw el erreur fel terminal
    console.error(error.message);

    // Ken el email mawjoud deja, n'affichiw message
    if (error.code === "23505") {
      return res.status(409).json({
        message: "Cet email existe déjà"
      });
    }

    // Ken fama erreur o5ra
    res.status(500).json({
      message: "Erreur lors de l'ajout de l'utilisateur"
    });
  }
});

// Houni nbadlou les informations mta3 utilisateur
router.put("/:id", async (req, res) => {
  try {
    // Nakhthou el id mel URL w les nouvelles informations
    const { id } = req.params;
    const { full_name, email, profession, location, description } = req.body;

    // Nethabtou eli esm w email mahoumch ferghin
    if (!full_name || !email) {
      return res.status(400).json({
        message: "Le nom et l'email sont obligatoires"
      });
    }

    // Nupdateiw les informations fel base de données
    const result = await pool.query(
      `UPDATE users
       SET full_name = $1,
           email = $2,
           profession = $3,
           location = $4,
           description = $5,
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $6
       RETURNING *`,
      [
        full_name,
        email,
        profession || null,
        location || null,
        description || null,
        id
      ]
    );

    // Ken utilisateur mawjoudch
    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Utilisateur introuvable"
      });
    }

    // Nرجعو les informations ba3d el modification
    res.status(200).json({
      message: "Profil modifié avec succès",
      user: result.rows[0]
    });

  } catch (error) {
    // Naffichiw el erreur fel terminal
    console.error(error.message);

    // Ken el email deja utilisé
    if (error.code === "23505") {
      return res.status(409).json({
        message: "Cet email existe déjà"
      });
    }

    res.status(500).json({
      message: "Erreur lors de la modification du profil"
    });
  }
});

// US-11-T02 : API d'ajout d'une compétence supplémentaire
router.post("/:id/skills", async (req, res) => {
  try {
    // Nakhthou id mta3 utilisateur mel URL
    const { id } = req.params;

    // Nakhthou esm el compétence mel body
    const { skill_name } = req.body;

    // Nethabtou eli esm el compétence mahouch feragh
    if (!skill_name || !skill_name.trim()) {
      return res.status(400).json({
        message: "Le nom de la compétence est obligatoire"
      });
    }

    // Nzidou el compétence ken el utilisateur mawjoud
    const result = await pool.query(
      `INSERT INTO additional_skills (user_id, skill_name)
       SELECT id, $2 FROM users WHERE id = $1
       RETURNING *`,
      [id, skill_name.trim()]
    );

    // Ken el utilisateur mawjoudch
    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Utilisateur introuvable"
      });
    }

    res.status(201).json({
      message: "Compétence ajoutée avec succès",
      skill: result.rows[0]
    });

  } catch (error) {
    console.error(error.message);

    // Ken el compétence deja mawjoud
    if (error.code === "23505") {
      return res.status(409).json({
        message: "Cette compétence existe déjà"
      });
    }

    res.status(500).json({
      message: "Erreur lors de l'ajout de la compétence"
    });
  }
});


// US-11-T02 : API de suppression d'une compétence
router.delete("/:id/skills/:skillId", async (req, res) => {
  try {
    // Nakhthou id mta3 utilisateur w compétence
    const { id, skillId } = req.params;

    // Nfas5ou el compétence mta3 utilisateur hedha bark
    const result = await pool.query(
      `DELETE FROM additional_skills
       WHERE id = $1 AND user_id = $2
       RETURNING *`,
      [skillId, id]
    );

    // Ken el compétence mawjoudch
    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Compétence introuvable"
      });
    }

    res.status(200).json({
      message: "Compétence supprimée avec succès",
      skill: result.rows[0]
    });

  } catch (error) {
    console.error(error.message);

    res.status(500).json({
      message: "Erreur lors de la suppression de la compétence"
    });
  }
});


// Nexportiw router bech nesta3mlouh fi server.js
module.exports = router;
