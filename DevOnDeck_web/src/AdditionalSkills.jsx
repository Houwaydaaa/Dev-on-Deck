import { useState } from "react";

// Houni importiw fichier CSS bech nesta3mlou el design
import "./AdditionalSkills.css";

function AdditionalSkills() {
  // Tableau bech نخزّنوا فيه les compétences mta3 el développeur
  const [skills, setSkills] = useState([]);

  // Variable bech نخزّنوا فيها compétence elli user yektebha
  const [newSkill, setNewSkill] = useState("");

  // Fonction tetnaffedh ki user yenzel 3al bouton Ajouter
  const handleAddSkill = () => {
    // Nethabtou elli el input moch feragh
    if (newSkill.trim() === "") {
      return;
    }

    // Nethabtou elli el compétence mawjoudach deja fi tableau
    const skillExists = skills.some(
      (skill) => skill.toLowerCase() === newSkill.trim().toLowerCase()
    );

    // Ken el compétence deja mawjoud, ma nzidouhech mara o5ra
    if (skillExists) {
      alert("Hedhi el compétence mawjoudha deja !");
      return;
    }

    // Nzidou el compétence jdida lel tableau
    setSkills([...skills, newSkill.trim()]);

    // Nfarghou el input bech user ynajem yzid compétence o5ra
    setNewSkill("");
  };

  // Fonction bech nna7iw compétence mel tableau
  const handleDeleteSkill = (indexToDelete) => {
    // Na3mlou tableau jdid fih ken les compétences elli ma nhebouch nna7iw
    const updatedSkills = skills.filter(
      (skill, index) => index !== indexToDelete
    );

    // Nbadlou el tableau el 9dim bel tableau el jdid
    setSkills(updatedSkills);
  };

  return (
    <div className="additional-skills">

      {/* Titre mta3 partie compétences supplémentaires */}
      <h2>Mes compétences supplémentaires</h2>

      {/* Formulaire bech user yzid compétence */}
      <div className="skill-input">

        {/* Input win user yekteb esm el compétence */}
        <input
          type="text"
          placeholder="Exemple : Python, Java, SQL..."
          value={newSkill}
          onChange={(e) => setNewSkill(e.target.value)}
        />

        {/* Bouton elli yzid el compétence */}
        <button onClick={handleAddSkill}>
          Ajouter
        </button>

      </div>

      {/* Liste mta3 les compétences */}
      <ul>
        {skills.map((skill, index) => (
          // Kol compétence bech تظهر fi ligne wa7adha
          <li key={index}>

            {/* Affichage esm el compétence */}
            <span>{skill}</span>

            {/* Bouton bech user ynajem yfasakh compétence */}
            <button onClick={() => handleDeleteSkill(index)}>
              Supprimer
            </button>

          </li>
        ))}
      </ul>

      {/* Message ki ma fama hata compétence */}
      {skills.length === 0 && (
        <p>Aucune compétence ajoutée pour le moment.</p>
      )}

    </div>
  );
}

// Nexportiw el composant bech nesta3mlouh fi App.jsx
export default AdditionalSkills;

