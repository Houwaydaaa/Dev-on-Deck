import { useState } from "react";
import styles from "./Inscription.module.css";
import PanneauMarque from "./PanneauMarque.jsx";
import gouvernorats from "../../Data/Gouvernorats.js";

// Regex qui vérifie le format d'un e-mail (texte@texte.texte, sans espace)
const FORMAT_EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// US-04-T03 : formulaire d'inscription organisation (validation côté client)
// Même logique que InscriptionDeveloppeur, avec des champs différents :
// nom de l'organisation + informations de la personne de contact.
// props.onChangerPage vient de App.jsx : elle sert à passer à l'onglet
// "Développeur".
function InscriptionOrganisation(props) {
  // ============================================================
  // 1. Déclaration des états (un par champ)
  // ============================================================
  const [nomOrganisation, setNomOrganisation] = useState("");
  const [prenomContact, setPrenomContact] = useState("");
  const [nomContact, setNomContact] = useState("");
  const [emailContact, setEmailContact] = useState("");
  const [adresse, setAdresse] = useState("");
  const [ville, setVille] = useState("");
  const [region, setRegion] = useState("");
  const [motDePasse, setMotDePasse] = useState("");
  const [confirmation, setConfirmation] = useState("");

  const [inscription, setInscription] = useState(null); // données validées
  const [erreurs, setErreurs] = useState({}); // messages d'erreur par champ
  const [showPopup, setShowPopup] = useState(false); // popup visible ou non

  // ============================================================
  // 2. Effacer l'erreur d'un champ quand l'utilisateur le modifie
  // ============================================================
  function effacerErreur(champ) {
    setErreurs((prev) => {
      const nouvellesErreurs = { ...prev }; // copie de l'objet
      delete nouvellesErreurs[champ]; // on retire l'erreur du champ
      return nouvellesErreurs;
    });
  }

  // ============================================================
  // 3. Validation du formulaire
  // ============================================================
  // Renvoie true si tout est correct, false sinon
  function valider() {
    const nouvellesErreurs = {};

    // trim() enlève les espaces : un champ rempli d'espaces = vide
    if (nomOrganisation.trim() === "") {
      nouvellesErreurs.nomOrganisation =
        "Veuillez saisir le nom de l'organisation !";
    }
    if (prenomContact.trim() === "") {
      nouvellesErreurs.prenomContact = "Veuillez saisir le prénom du contact !";
    }
    if (nomContact.trim() === "") {
      nouvellesErreurs.nomContact = "Veuillez saisir le nom du contact !";
    }

    // E-mail : non vide, puis format valide (regex)
    if (emailContact.trim() === "") {
      nouvellesErreurs.emailContact = "Veuillez saisir l'adresse e-mail !";
    } else if (!FORMAT_EMAIL.test(emailContact.trim())) {
      nouvellesErreurs.emailContact =
        "Le format de l'adresse e-mail est invalide !";
    }

    if (adresse.trim() === "") {
      nouvellesErreurs.adresse = "Veuillez saisir l'adresse de l'organisation !";
    }
    if (ville.trim() === "") {
      nouvellesErreurs.ville = "Veuillez saisir la ville !";
    }
    if (region === "") {
      nouvellesErreurs.region = "Veuillez choisir une région !";
    }

    // Mot de passe : non vide, puis au moins 8 caractères
    if (motDePasse === "") {
      nouvellesErreurs.motDePasse = "Veuillez saisir un mot de passe !";
    } else if (motDePasse.length < 8) {
      nouvellesErreurs.motDePasse =
        "Le mot de passe doit contenir au moins 8 caractères !";
    }

    // Confirmation : non vide, puis identique au mot de passe
    if (confirmation === "") {
      nouvellesErreurs.confirmation = "Veuillez confirmer le mot de passe !";
    } else if (confirmation !== motDePasse) {
      nouvellesErreurs.confirmation =
        "Les deux mots de passe ne sont pas identiques !";
    }

    setErreurs(nouvellesErreurs); // pour afficher les erreurs
    return Object.keys(nouvellesErreurs).length === 0; // true = aucune erreur
  }

  // ============================================================
  // 4. Soumission du formulaire
  // ============================================================
  async function handleSubmit(e) {
  e.preventDefault(); // évite le rechargement de la page

  if (!valider()) return; // erreurs : on s'arrête ici

  try {
    const response = await fetch("http://localhost:8080/inscription/organisation", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        nomOrganisation,
        prenomContact,
        nomContact,
        emailContact,
        adresse,
        ville,
        region,
        motDePasse,
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      // Affiche l'erreur renvoyée par Spring Boot (ex: e-mail déjà utilisé)
      setErreurs((prev) => ({ ...prev, emailContact: data.message }));
      return;
    }

    // Succès : affiche le popup de confirmation
    setInscription({
      nomOrganisation,
      prenomContact,
      nomContact,
      emailContact,
      adresse,
      ville,
      region,
    });
    setShowPopup(true);
  } catch (error) {
    alert("Impossible de contacter le serveur Spring Boot (port 8080).");
  }
}


  // ============================================================
  // 5. Réinitialisation : tout remettre à vide
  // ============================================================
  function handleReset() {
    setNomOrganisation("");
    setPrenomContact("");
    setNomContact("");
    setEmailContact("");
    setAdresse("");
    setVille("");
    setRegion("");
    setMotDePasse("");
    setConfirmation("");
    setInscription(null);
    setErreurs({});
  }

  // ============================================================
  // 6. Affichage (JSX)
  // ============================================================
  return (
    // .page = 2 colonnes : panneau violet à gauche, formulaire à droite
    <div className={styles.page}>
      <PanneauMarque />

      <section className={styles.container}>
        <div className={styles.contenu}>
          {/* ONGLETS : "Organisation" est actif, "Développeur" appelle
              la fonction reçue de App.jsx pour changer de formulaire */}
          <div className={styles.onglets}>
            <button
              type="button"
              className={styles.onglet}
              onClick={props.onChangerPage}
            >
              Développeur
            </button>
            <button
              type="button"
              className={`${styles.onglet} ${styles.actif}`}
            >
              Organisation
            </button>
          </div>

          <h2>Créer le compte de mon organisation</h2>
          <p className={styles.intro}>
            Quelques informations, puis vous publierez vos postes.
          </p>

          {/* noValidate : on utilise nos messages d'erreur, pas ceux du navigateur */}
          <form onSubmit={handleSubmit} noValidate>
            {/* NOM DE L'ORGANISATION
                Chaque champ suit le même modèle :
                value (valeur venant de l'état) + onChange (mise à jour de
                l'état et effacement de l'erreur) + bordure rouge + message. */}
            <div className={styles.formGroup}>
              <label>Nom de l'organisation</label>
              <input
                type="text"
                className={erreurs.nomOrganisation ? styles.inputError : ""}
                value={nomOrganisation}
                onChange={(e) => {
                  setNomOrganisation(e.target.value);
                  effacerErreur("nomOrganisation");
                }}
                placeholder="Entreprise, startup ou association"
              />
              {erreurs.nomOrganisation && (
                <span className={styles.errorMessage}>
                  {erreurs.nomOrganisation}
                </span>
              )}
            </div>

            {/* Prénom et nom du contact côte à côte */}
            <div className={styles.row}>
              <div className={styles.formGroup}>
                <label>Prénom du contact</label>
                <input
                  type="text"
                  className={erreurs.prenomContact ? styles.inputError : ""}
                  value={prenomContact}
                  onChange={(e) => {
                    setPrenomContact(e.target.value);
                    effacerErreur("prenomContact");
                  }}
                  placeholder="Prénom"
                />
                {erreurs.prenomContact && (
                  <span className={styles.errorMessage}>
                    {erreurs.prenomContact}
                  </span>
                )}
              </div>

              <div className={styles.formGroup}>
                <label>Nom du contact</label>
                <input
                  type="text"
                  className={erreurs.nomContact ? styles.inputError : ""}
                  value={nomContact}
                  onChange={(e) => {
                    setNomContact(e.target.value);
                    effacerErreur("nomContact");
                  }}
                  placeholder="Nom"
                />
                {erreurs.nomContact && (
                  <span className={styles.errorMessage}>
                    {erreurs.nomContact}
                  </span>
                )}
              </div>
            </div>

            {/* EMAIL DE CONTACT */}
            <div className={styles.formGroup}>
              <label>E-mail de contact</label>
              <input
                type="email"
                className={erreurs.emailContact ? styles.inputError : ""}
                value={emailContact}
                onChange={(e) => {
                  setEmailContact(e.target.value);
                  effacerErreur("emailContact");
                }}
                placeholder="contact@organisation.com"
              />
              {erreurs.emailContact && (
                <span className={styles.errorMessage}>
                  {erreurs.emailContact}
                </span>
              )}
            </div>

            {/* ADRESSE */}
            <div className={styles.formGroup}>
              <label>Adresse de l'organisation</label>
              <input
                type="text"
                className={erreurs.adresse ? styles.inputError : ""}
                value={adresse}
                onChange={(e) => {
                  setAdresse(e.target.value);
                  effacerErreur("adresse");
                }}
                placeholder="Rue, numéro"
              />
              {erreurs.adresse && (
                <span className={styles.errorMessage}>{erreurs.adresse}</span>
              )}
            </div>

            {/* Ville et région côte à côte */}
            <div className={styles.row}>
              <div className={styles.formGroup}>
                <label>Ville</label>
                <input
                  type="text"
                  className={erreurs.ville ? styles.inputError : ""}
                  value={ville}
                  onChange={(e) => {
                    setVille(e.target.value);
                    effacerErreur("ville");
                  }}
                  placeholder="Tunis"
                />
                {erreurs.ville && (
                  <span className={styles.errorMessage}>{erreurs.ville}</span>
                )}
              </div>

              <div className={styles.formGroup}>
                <label>État / Région</label>
                <select
                  className={erreurs.region ? styles.inputError : ""}
                  value={region}
                  onChange={(e) => {
                    setRegion(e.target.value);
                    effacerErreur("region");
                  }}
                >
                  <option value="">-- Choisir --</option>
                  {/* .map() crée une <option> par gouvernorat ;
                      key = identifiant unique demandé par React */}
                  {gouvernorats.map((gouvernorat) => (
                    <option key={gouvernorat} value={gouvernorat}>
                      {gouvernorat}
                    </option>
                  ))}
                </select>
                {erreurs.region && (
                  <span className={styles.errorMessage}>{erreurs.region}</span>
                )}
              </div>
            </div>

            {/* Mot de passe et confirmation côte à côte
                (type="password" cache les caractères) */}
            <div className={styles.row}>
              <div className={styles.formGroup}>
                <label>Mot de passe</label>
                <input
                  type="password"
                  className={erreurs.motDePasse ? styles.inputError : ""}
                  value={motDePasse}
                  onChange={(e) => {
                    setMotDePasse(e.target.value);
                    effacerErreur("motDePasse");
                  }}
                  placeholder="8 caractères minimum"
                />
                {erreurs.motDePasse && (
                  <span className={styles.errorMessage}>
                    {erreurs.motDePasse}
                  </span>
                )}
              </div>

              <div className={styles.formGroup}>
                <label>Confirmer le mot de passe</label>
                <input
                  type="password"
                  className={erreurs.confirmation ? styles.inputError : ""}
                  value={confirmation}
                  onChange={(e) => {
                    setConfirmation(e.target.value);
                    effacerErreur("confirmation");
                  }}
                  placeholder="Répétez le mot de passe"
                />
                {erreurs.confirmation && (
                  <span className={styles.errorMessage}>
                    {erreurs.confirmation}
                  </span>
                )}
              </div>
            </div>

            {/* BOUTONS
                submit = envoie le formulaire ; button = bouton simple */}
            <div className={styles.buttons}>
              <button type="submit" className={styles.submitButton}>
                S'inscrire
              </button>
              <button
                type="button"
                className={styles.resetButton}
                onClick={handleReset}
              >
                Réinitialiser
              </button>
            </div>
          </form>

          {/* LIEN "Se connecter" : il sera relié à la page de connexion
              quand elle existera */}
          <p className={styles.lien}>
            Déjà inscrit ? <button type="button">Se connecter</button>
          </p>
        </div>
      </section>

      {/* POPUP : visible seulement si showPopup vaut true */}
      {showPopup && (
        <div className={styles.overlay}>
          <div className={styles.popup}>
            <h3>Inscription enregistrée !</h3>
            <p>
              Merci {inscription?.prenomContact}, le compte de{" "}
              {inscription?.nomOrganisation} a bien été créé.
            </p>
            <button onClick={() => setShowPopup(false)}>Fermer</button>
          </div>
        </div>
      )}
    </div>
  );
}

export default InscriptionOrganisation;