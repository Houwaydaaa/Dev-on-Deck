import styles from "./Inscription.module.css";

// Panneau violet de gauche : logo, slogan et description.
// Il est identique pour les deux formulaires, donc on en fait un
// composant réutilisable (pas de props nécessaires).
function PanneauMarque() {
  return (
    <aside className={styles.panneau}>
      {/* Logo dessiné en SVG : un "D" en dégradé, une orbite pêche et </>.
          Pour mettre le vrai logo : remplacer ce <svg> par
          <img src={logo} alt="DevOnDeck" /> (logo en PNG transparent). */}
      <div className={styles.logo}>
        <svg width="48" height="48" viewBox="0 0 46 46" aria-hidden="true">
          <defs>
            <linearGradient id="degradeLogo" x1="0" y1="0" x2="1" y2="1">
              <stop offset="0" stopColor="#8E3AA8" />
              <stop offset="1" stopColor="#E0566A" />
            </linearGradient>
          </defs>
          <path d="M8 6 H24 A17 17 0 0 1 24 40 H8 Z" fill="url(#degradeLogo)" />
          <ellipse
            cx="23"
            cy="23"
            rx="21"
            ry="9"
            transform="rotate(-25 23 23)"
            fill="none"
            stroke="#F7A98B"
            strokeWidth="2"
          />
          <text x="14" y="28" fontSize="13" fontWeight="700" fill="white">
            &lt;/&gt;
          </text>
        </svg>
        <span className={styles.logoTexte}>
          DevOn<span>Deck</span>
        </span>
      </div>

      {/* Devise avec un trait de chaque côté (les traits sont en CSS) */}
      <p className={styles.devise}>Connect • Build • Launch</p>

      <h1 className={styles.slogan}>
        Trouvez le bon profil.
        <br />
        Lancez votre projet.
      </h1>

      <p className={styles.description}>
        Les développeurs présentent leurs compétences, les organisations
        publient leurs postes, et le matching fait le reste.
      </p>
    </aside>
  );
}

export default PanneauMarque;