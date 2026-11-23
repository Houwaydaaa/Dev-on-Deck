
const pool = require('../config/db');

// RÃ©cupÃ©rer les dÃ©veloppeurs avec leurs compÃ©tences principales
const getAllDevelopers = async () => {
    const result = await pool.query(`
        SELECT
            d.*,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id', c.id,
                        'nom', c.nom,
                        'categorie', c.categorie
                    )
                ) FILTER (WHERE c.id IS NOT NULL),
                '[]'
            ) AS "competencesPrincipales"
        FROM developers d
        LEFT JOIN developer_competences dc
            ON d.id = dc.developer_id
            AND dc.is_principale = TRUE
        LEFT JOIN competences c
            ON dc.competence_id = c.id
        GROUP BY d.id
        ORDER BY d.id
    `);

    return result.rows;
};

// RÃ©cupÃ©rer un dÃ©veloppeur par son ID
const getDeveloperById = async (id) => {
    const result = await pool.query(`
        SELECT
            d.*,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id', c.id,
                        'nom', c.nom,
                        'categorie', c.categorie
                    )
                ) FILTER (WHERE c.id IS NOT NULL),
                '[]'
            ) AS "competencesPrincipales"
        FROM developers d
        LEFT JOIN developer_competences dc
            ON d.id = dc.developer_id
            AND dc.is_principale = TRUE
        LEFT JOIN competences c
            ON dc.competence_id = c.id
        WHERE d.id = $1
        GROUP BY d.id
    `, [id]);

    return result.rows[0];
};

// Ajouter un dÃ©veloppeur
const addDeveloper = async (nom, email, biographie, description) => {
    const result = await pool.query(
        `INSERT INTO developers (nom, email, biographie, description)
         VALUES ($1, $2, $3, $4)
         RETURNING *`,
        [nom, email, biographie, description]
    );

    return result.rows[0];
};

// Modifier la biographie et la description
const updateDeveloperProfile = async (id, biographie, description) => {
    const result = await pool.query(
        `UPDATE developers
         SET biographie = COALESCE($2, biographie),
             description = COALESCE($3, description)
         WHERE id = $1
         RETURNING *`,
        [id, biographie, description]
    );

    return result.rows[0];
};

// Ajouter un dÃ©veloppeur avec ses compÃ©tences
const addDeveloperWithCompetences = async (
    nom,
    email,
    biographie,
    description,
    competenceIds
) => {
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        const developerResult = await client.query(
            `INSERT INTO developers (nom, email, biographie, description)
             VALUES ($1, $2, $3, $4)
             RETURNING *`,
            [nom, email, biographie, description]
        );

        const developer = developerResult.rows[0];

        for (const competenceId of competenceIds) {
            await client.query(
                `INSERT INTO developer_competences
                 (developer_id, competence_id, is_principale)
                 VALUES ($1, $2, TRUE)`,
                [developer.id, competenceId]
            );
        }

        await client.query('COMMIT');

        return await getDeveloperById(developer.id);

    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
};

// Modifier les compÃ©tences principales d'un dÃ©veloppeur
const updateDeveloperCompetences = async (developerId, competenceIds) => {
    if (!Array.isArray(competenceIds)) {
        throw new Error('La liste des compÃ©tences doit Ãªtre un tableau.');
    }

    if (competenceIds.length > 5) {
        throw new Error(
            'Vous ne pouvez sÃ©lectionner que 5 compÃ©tences principales maximum.'
        );
    }

    const ids = competenceIds.map(Number);

    if (
        ids.some(id => !Number.isSafeInteger(id) || id <= 0) ||
        new Set(ids).size !== ids.length
    ) {
        throw new Error('Les identifiants des compÃ©tences sont invalides.');
    }

    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        // VÃ©rifier l'existence du dÃ©veloppeur
        const developerResult = await client.query(
            'SELECT id FROM developers WHERE id = $1',
            [developerId]
        );

        if (developerResult.rows.length === 0) {
            await client.query('ROLLBACK');
            return null;
        }

        // VÃ©rifier l'existence de toutes les compÃ©tences
        if (ids.length > 0) {
            const competenceResult = await client.query(
                `SELECT id FROM competences WHERE id = ANY($1::bigint[])`,
                [ids]
            );

            if (competenceResult.rows.length !== ids.length) {
                throw new Error(
                    'Une ou plusieurs compÃ©tences sÃ©lectionnÃ©es nâ€™existent pas.'
                );
            }
        }

        // Supprimer les anciennes compÃ©tences principales
        await client.query(
            `DELETE FROM developer_competences
             WHERE developer_id = $1`,
            [developerId]
        );

        // Ajouter les nouvelles compÃ©tences principales
        for (const competenceId of ids) {
            await client.query(
                `INSERT INTO developer_competences
                 (developer_id, competence_id, is_principale)
                 VALUES ($1, $2, TRUE)`,
                [developerId, competenceId]
            );
        }

        await client.query('COMMIT');

        return await getDeveloperById(developerId);

    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
};

// Exporter les fonctions
module.exports = {
    getAllDevelopers,
    getDeveloperById,
    addDeveloper,
    updateDeveloperProfile,
    addDeveloperWithCompetences,
    updateDeveloperCompetences
};

