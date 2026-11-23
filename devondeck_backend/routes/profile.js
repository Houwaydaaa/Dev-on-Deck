
const express = require("express");
const router = express.Router();
const pool = require("../config/db");

// Houni njibou profil mta3 utilisateur connecté
router.get("/", async (req, res) => {
  try {
    // Nakhthou ID mta3 utilisateur connecté mel authentification
    const userId = req.user.id;

    // Nlawjou 3la utilisateur fel base de données
    const result = await pool.query(
      `SELECT id, full_name, email, profession, location, description,
              created_at, updated_at
       FROM users
       WHERE id = $1`,
      [userId]
    );

    // Ken profil mouch mawjoud
    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Profil introuvable"
      });
    }

    // Nraj3ou les informations mta3 profil
    res.status(200).json({
      message: "Profil récupéré avec succès",
      user: result.rows[0]
    });

  } catch (error) {
    // Naffichiw el erreur fel terminal
    console.error(error.message);

    res.status(500).json({
      message: "Erreur lors de la récupération du profil"
    });
  }
});


// Houni nbadlou profil mta3 utilisateur connecté
router.put("/", async (req, res) => {
  try {
    // Nakhthou ID mta3 utilisateur connecté mel authentification
    const userId = req.user.id;

    // Nakhthou les informations jdod mel body
    const {
      full_name,
      email,
      profession,
      location,
      description
    } = req.body;

    // Nethabtou eli esm w email mahoumch ferghin
    if (!full_name || !email) {
      return res.status(400).json({
        message: "Le nom et l'email sont obligatoires"
      });
    }

    // Nupdateiw les informations mta3 utilisateur fel base
    const result = await pool.query(
      `UPDATE users
       SET full_name = $1,
           email = $2,
           profession = $3,
           location = $4,
           description = $5,
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $6
       RETURNING id, full_name, email, profession, location,
                 description, created_at, updated_at`,
      [
        full_name,
        email,
        profession || null,
        location || null,
        description || null,
        userId
      ]
    );

    // Ken profil mouch mawjoud
    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Profil introuvable"
      });
    }

    // Nraj3ou les informations ba3d el modification
    res.status(200).json({
      message: "Profil modifié avec succès",
      user: result.rows[0]
    });

  } catch (error) {
    // Naffichiw el erreur fel terminal
    console.error(error.message);

    // Ken el email deja mawjoud fel base
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

// Nexportiw router bech nesta3mlouh fi server.js
module.exports = router;
