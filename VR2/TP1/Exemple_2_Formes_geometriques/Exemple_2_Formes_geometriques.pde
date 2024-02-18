/****************************************************************************/
/*  MESNARD Emmanuel                                                ISIMA   */
/*                                                                          */
/*          Exemple 2 : formes geometriques fixes et couleur dynamique      */
/*                                                                          */
/* Exemple_2_Formes_Geometriques.pde                       Processing 4.2   */
/****************************************************************************/

// Declarations de constantes : Quelques couleurs...
final int rouge = color(255,0,0); 
final int vert  = color(0,255,0); 
final int bleu  = color(0,0,255);
final int noir  = color(0,0,0); 
final int blanc = color(255,255,255); 

int PseudoTeinte; // Variable utile pour la gestion du dynamisme

// Fonction d'initialisation de l'application - executee une seule fois
void setup(){
  // Initialisation des parametres graphiques utilises
  size(600,300); // Fenetre de 600*300, sans appeler la carte graphique
  surface.setTitle("Exemple 2 - Formes Geometriques colorees - E. Mesnard / ISIMA");
  
  colorMode(RGB, 255,255,255); // fixe format couleur R G B pour fill, stroke, etc...
  fill(vert); // couleur remplissage RGB - noFill() si pas de remplissage
  stroke(rouge); // couleur pourtour RGB - noStroke() si pas de pourtour
  background(noir); // couleur fond fenetre
  
  line(80,280,270,5); // trace d'une ligne rouge
  
  stroke(bleu); // changement de couleur pour tracer un cercle bleu...
  strokeWeight(4); // avec pourtour epais
  circle(width/2,height/2,80); // au centre de la fenetre, de rayon 80
  
  colorMode(HSB, 360, 100, 100); // Changement de mode
  noStroke(); // sans pourtour
  PseudoTeinte = 0; // initialization de la variable globale en fin de setup
}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Trace d'un rectangle uni, mais de couleur (teinte) changeante
  fill(color(PseudoTeinte%360,100,100));
  rect(370,100,200,100);
  PseudoTeinte++;
}
