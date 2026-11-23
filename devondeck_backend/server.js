
const express = require("express");
const cors = require("cors");
require("dotenv").config();

const pool = require("./config/db");
const usersRoutes = require("./routes/users");
const profileRoutes = require("./routes/profile");

const app = express();

// Houni nactiviw les middlewares
app.use(cors());
app.use(express.json());

// Route principale mta3 application
app.get("/", (req, res) => {
  res.send("DevOnDeck Backend is running!");
});

// Route bech ntestiw connexion PostgreSQL
app.get("/test-db", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");

    res.status(200).json({
      success: true,
      message: "PostgreSQL connected successfully!",
      time: result.rows[0].now
    });

  } catch (error) {
    console.error("Database error:", error.message);

    res.status(500).json({
      success: false,
      message: "Database connection failed",
      error: error.message
    });
  }
});

// Houni nربطو routes mta3 utilisateurs
app.use("/api/users", usersRoutes);

// Houni nربطو routes mta3 profil
app.use("/api/profil", profileRoutes);

// Lancement du serveur
const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
  console.log(`Serveur lancé sur le port ${PORT}`);
});
