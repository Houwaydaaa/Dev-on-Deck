
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

  // Charger les données depuis Spring Boot
  useEffect(() => {
    const chargerDonnees = async () => {
      try {
        const [responseDeveloper, responseCompetences, responsePrincipales] =
          await Promise.all([
            fetch('http://localhost:8080/api/developers/1'),
            fetch('http://localhost:8080/api/competences'),
            fetch('http://localhost:8080/api/developers/1/competences')
          ])

        if (!responseDeveloper.ok || !responseCompetences.ok || !responsePrincipales.ok) {
          throw new Error('Erreur lors du chargement des données')
        }

        const developer = await responseDeveloper.json()
        const dataCompetences = await responseCompetences.json()
        const dataPrincipales = await responsePrincipales.json()

        setBiographie(developer.biographie || '')
        setDescription(developer.description || '')

        setCompetences(dataCompetences)

        setCompetencesSelectionnees(
          dataPrincipales
            .filter((item) => item.isPrincipale)
            .map((item) => String(item.id.competenceId))
        )

      } catch (error) {
        console.error('Erreur de chargement :', error)
        alert('Impossible de charger les données : ' + error.message)
      }
    }

    chargerDonnees()
  }, [])

  // US-09 : Enregistrer le profil
  const enregistrerProfil = async () => {
    try {
      const response = await fetch(
        'http://localhost:8080/api/developers/1/biography',
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
        throw new Error(typeof data === 'string' ? data : data.message)
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
        'http://localhost:8080/api/developers/1/competences',
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
        throw new Error(typeof data === 'string' ? data : data.message)
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
