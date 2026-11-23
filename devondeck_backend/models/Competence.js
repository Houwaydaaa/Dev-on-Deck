
// Importer la connexion PostgreSQL principale
const pool = require('../config/db');

// RÃ©cupÃ©rer toutes les compÃ©tences
const getAllCompetences = async () => {
    const result = await pool.query(
        'SELECT * FROM competences ORDER BY id'
    );

    return result.rows;
};

// Ajouter une compÃ©tence
const addCompetence = async (nom, categorie) => {
    const result = await pool.query(
        `INSERT INTO competences (nom, categorie)
         VALUES ($1, $2)
         ON CONFLICT (nom) DO NOTHING
         RETURNING *`,
        [nom, categorie]
    );

    return result.rows[0];
};

// Rechercher plusieurs compÃ©tences par leurs noms
const getCompetencesByNames = async (noms) => {
    const result = await pool.query(
        `SELECT id, nom, categorie
         FROM competences
         WHERE nom = ANY($1)`,
        [noms]
    );

    return result.rows;
};

// Exporter les fonctions
module.exports = {
    getAllCompetences,
    addCompetence,
    getCompetencesByNames
};


