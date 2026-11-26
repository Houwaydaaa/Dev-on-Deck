// ============================================================
// Données : liste des gouvernorats de la Tunisie
// ============================================================
// C'est un simple tableau de textes. Il sert à remplir le menu
// déroulant "État / Région" des formulaires d'inscription.
// On le met dans un fichier à part (comme DestinationList.js)
// pour séparer les DONNÉES des COMPOSANTS.
const gouvernorats = [
  "Ariana", "Béja", "Ben Arous", "Bizerte", "Gabès", "Gafsa",
  "Jendouba", "Kairouan", "Kasserine", "Kébili", "Le Kef", "Mahdia",
  "La Manouba", "Médenine", "Monastir", "Nabeul", "Sfax", "Sidi Bouzid",
  "Siliana", "Sousse", "Tataouine", "Tozeur", "Tunis", "Zaghouan",
];

// "export default" permet d'importer ce tableau dans un autre fichier :
// import gouvernorats from "../../Data/Gouvernorats.js";
export default gouvernorats;