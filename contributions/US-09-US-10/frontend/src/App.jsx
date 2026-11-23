
import { useState, useEffect } from 'react'
import './App.css'

function App() {
  // US-09 : Biographie et description
  const [biographie, setBiographie] = useState('')
  const [description, setDescription] = useState('')
  const limite = 300

  // US-10 : Gestion des compétences
  const [competences, setCompetences] = useState([])
  const [competencesSelectionnees, setCompetencesSelectionnees] = useState([])

  // Récupérer le profil et les compétences depuis le backend
  useEffect(() => {
    const chargerDonnees = async () => {
      try {
        const [responseDevelopers, responseCompetences] = await Promise.all([
          fetch('http://127.0.0.1:3000/api/developers'),
          fetch('http://127.0.0.1:3000/api/competences')
        ])

        const dataDevelopers = await responseDevelopers.json()
        const dataCompetences = await responseCompetences.json()

        if (!responseDevelopers.ok || !responseCompetences.ok) {
          throw new Error('Erreur lors du chargement des données')
        }

        // Récupérer le développeur numéro 1
        const developer = dataDevelopers.developers.find(
          (dev) => String(dev.id) === '1'
        )

        if (developer) {
          setBiographie(developer.biographie || '')
          setDescription(developer.description || '')

          // Récupérer les compétences déjà sélectionnées
          setCompetencesSelectionnees(
            (developer.competencesPrincipales || []).map(
              (competence) => String(competence.id)
            )
          )
        }

        // Afficher les compétences disponibles
        setCompetences(dataCompetences.competences)

      } catch (error) {
        console.error('Erreur de chargement :', error)
      }
    }

    chargerDonnees()
  }, [])

  // US-09 : Enregistrer le profil
  const enregistrerProfil = async () => {
    try {
      const response = await fetch(
        'http://127.0.0.1:3000/api/developers/1/profile',
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            biographie,
            description
          })
        }
      )

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.message)
      }

      alert('Profil enregistré avec succès !')

    } catch (error) {
      alert('Erreur : ' + error.message)
    }
  }

  // US-10 : Sélectionner ou désélectionner un langage
  const gererSelection = (id) => {
    setCompetencesSelectionnees((anciennes) => {
      if (anciennes.includes(String(id))) {
        return anciennes.filter((competenceId) => competenceId !== String(id))
      }

      if (anciennes.length >= 5) {
        alert('Vous ne pouvez sélectionner que 5 langages maximum.')
        return anciennes
      }

      return [...anciennes, String(id)]
    })
  }

  // US-10 : Enregistrer les compétences
  const enregistrerCompetences = async () => {
    try {
      const response = await fetch(
        'http://127.0.0.1:3000/api/developers/1/competences',
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            competenceIds: competencesSelectionnees.map(Number)
          })
        }
      )

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.message)
      }

      alert('Compétences enregistrées avec succès !')

    } catch (error) {
      alert('Erreur : ' + error.message)
    }
  }

  return (
    <div className="container">
      <div className="profile-card">

        <h1>Mon profil développeur</h1>

        <p className="subtitle">
          Présentez-vous et partagez vos compétences.
        </p>

        {/* US-09 : Biographie */}
        <div className="form-group">
          <label htmlFor="biographie">Biographie</label>

          <textarea
            id="biographie"
            placeholder="Présentez-vous en quelques mots..."
            value={biographie}
            maxLength={limite}
            onChange={(e) => setBiographie(e.target.value)}
          />

          <div className="counter">
            {biographie.length} / {limite} caractères
          </div>
        </div>

        {/* US-09 : Description */}
        <div className="form-group">
          <label htmlFor="description">Description</label>

          <textarea
            id="description"
            placeholder="Décrivez votre parcours et vos objectifs..."
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
        </div>

        <button onClick={enregistrerProfil}>
          Enregistrer le profil
        </button>

        {/* US-10 : Sélection des langages */}
        <div className="form-group competences-section">
          <h2>Mes langages de programmation</h2>

          <p className="counter">
            {competencesSelectionnees.length} / 5 langages sélectionnés
          </p>

          <div className="competences-list">
            {competences.map((competence) => (
              <label className="competence-item" key={competence.id}>
                <input
                  type="checkbox"
                  checked={competencesSelectionnees.includes(
                    String(competence.id)
                  )}
                  onChange={() => gererSelection(competence.id)}
                />

                <span>{competence.nom}</span>
              </label>
            ))}
          </div>

          <button onClick={enregistrerCompetences}>
            Enregistrer mes compétences
          </button>
        </div>

      </div>
    </div>
  )
}

export default App
