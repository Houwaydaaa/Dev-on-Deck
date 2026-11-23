import { useState } from "react";
import AdditionalSkills from "./AdditionalSkills";
import "./ProfileView.css";

function ProfileView() {
  // Houni na3mlou données initiales mta3 développeur
  const initialDeveloper = {
    fullName: "Ahmed Ben Ali",
    email: "ahmed@example.com",
    profession: "Développeur Full Stack",
    location: "Tunis, Tunisie",
    description:
      "Développeur passionné par la création des applications web et les nouvelles technologies.",
    mainSkills: ["JavaScript", "React", "Node.js", "PostgreSQL"],
  };

  // State bech nstockiw les informations actuelles mta3 développeur
  const [developer, setDeveloper] = useState(initialDeveloper);

  // State bech na3rfou ken formulaire modification ma7loul
  const [isEditing, setIsEditing] = useState(false);

  // State bech n7ottou fih les données mta3 formulaire
  const [formData, setFormData] = useState(initialDeveloper);

  // Fonction bech nbadlou les valeurs mta3 formulaire
  const handleChange = (e) => {
    const { name, value } = e.target;

    setFormData((previousData) => ({
      ...previousData,
      [name]: value,
    }));
  };

  // Fonction bech nvalidiw w nsajlou les modifications
  const handleSave = (e) => {
    // Houni nman3ou formulaire bech ya3mel reload lel page
    e.preventDefault();

    // Houni nethabtou eli les champs obligatoires mouch ferghin
    if (
      !formData.fullName.trim() ||
      !formData.email.trim() ||
      !formData.profession.trim() ||
      !formData.location.trim()
    ) {
      alert("Veuillez remplir tous les champs obligatoires.");
      return;
    }

    // Houni nethabtou eli format mta3 email s7i7
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // Houni n'affichiw erreur ken format email ghalet
    if (!emailRegex.test(formData.email)) {
      alert("Veuillez saisir un email valide.");
      return;
    }

    // Houni nbadlou données anciennes bel nouvelles
    setDeveloper({ ...formData });

    // Houni nsakrou formulaire w narj3ou lel affichage profil
    setIsEditing(false);

    // Houni n'affichiw message de confirmation
    alert("Profil modifié avec succès !");
  };

  // Fonction bech n'annulيو les modifications
  const handleCancel = () => {
    // Houni nrak3ou les anciennes données
    setFormData({ ...developer });

    // Houni nsakrou formulaire
    setIsEditing(false);
  };

  return (
    <div className="profile-container">

      {/* Header mta3 page profil */}
      <div className="profile-header">
        <div>
          <h1>Mon profil développeur</h1>
          <p>Consultez vos informations professionnelles</p>
        </div>

        {/* Bouton bech n7ellou formulaire modification */}
        <button
          type="button"
          onClick={() => {
            setFormData({ ...developer });
            setIsEditing(true);
          }}
        >
          Modifier le profil
        </button>
      </div>

      {isEditing ? (
        // Formulaire modification mta3 profil
        <form onSubmit={handleSave}>
          <h2>Modifier mes informations</h2>

          {/* Champ nom complet */}
          <label>Nom complet</label>
          <input
            type="text"
            name="fullName"
            value={formData.fullName}
            onChange={handleChange}
            required
          />

          {/* Champ email */}
          <label>Email</label>
          <input
            type="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            required
          />

          {/* Champ profession */}
          <label>Profession</label>
          <input
            type="text"
            name="profession"
            value={formData.profession}
            onChange={handleChange}
            required
          />

          {/* Champ localisation */}
          <label>Localisation</label>
          <input
            type="text"
            name="location"
            value={formData.location}
            onChange={handleChange}
            required
          />

          {/* Champ description */}
          <label>Description</label>
          <textarea
            name="description"
            value={formData.description}
            onChange={handleChange}
          />

          {/* Bouton bech nsajlou les modifications */}
          <button type="submit">Enregistrer</button>

          {/* Bouton bech nannulيو les modifications */}
          <button type="button" onClick={handleCancel}>
            Annuler
          </button>
        </form>
      ) : (
        // Affichage normal mta3 profil
        <>
          {/* Section informations personnelles */}
          <section className="profile-section">
            <h2>Informations personnelles</h2>
            <p><strong>Nom complet :</strong> {developer.fullName}</p>
            <p><strong>Email :</strong> {developer.email}</p>
            <p><strong>Profession :</strong> {developer.profession}</p>
            <p><strong>Localisation :</strong> {developer.location}</p>
          </section>

          {/* Section description développeur */}
          <section className="profile-section">
            <h2>À propos de moi</h2>
            <p>{developer.description}</p>
          </section>

          {/* Section compétences principales */}
          <section className="profile-section">
            <h2>Compétences principales</h2>
            <div className="skills-list">
              {developer.mainSkills.map((skill, index) => (
                <span className="skill-badge" key={index}>
                  {skill}
                </span>
              ))}
            </div>
          </section>

          {/* Composant compétences supplémentaires */}
          <section className="profile-section">
            <AdditionalSkills />
          </section>
        </>
      )}
    </div>
  );
}

export default ProfileView;
