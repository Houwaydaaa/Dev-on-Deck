// On importe useState pour mémoriser quel formulaire est affiché
import { useState } from "react";
// On importe les deux formulaires (ce sont des composants)
import InscriptionDeveloppeur from "./componants/Inscription/InscriptionDeveloppeur";
import InscriptionOrganisation from "./componants/Inscription/InscriptionOrganisation";

import "./App.css";

function App() {
  // État : "developpeur" ou "organisation"
  // Il indique quel formulaire doit être affiché à l'écran.
  // Au départ, on affiche le formulaire développeur.
  const [page, setPage] = useState("developpeur");

  // Fonction qui bascule d'un formulaire à l'autre.
  // Si on est sur "developpeur" on passe à "organisation", et inversement.
  function changerPage() {
    setPage(page === "developpeur" ? "organisation" : "developpeur");
  }

  return (
    <div className="App">
      <main>
                {/* Affichage conditionnel : selon la valeur de "page",
            on affiche l'un ou l'autre formulaire.
            On envoie la fonction changerPage à l'enfant avec la prop
            "onChangerPage" : l'onglet non sélectionné l'appellera. */}
        {page === "developpeur" ? (
          <InscriptionDeveloppeur onChangerPage={changerPage} />
        ) : (
          <InscriptionOrganisation onChangerPage={changerPage} />
        )}
      </main>
    </div>
  );
}
export default App;