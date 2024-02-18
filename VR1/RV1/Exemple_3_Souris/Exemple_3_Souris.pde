/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 3 : En route vers la Virtualite                         */
/*                      Creation d'une image virtuelle via la souris        */
/*                                                                          */
/* Exemple_3_Souris.pde                                Processing 3.5.1     */
/****************************************************************************/

// Declarations de constantes : Quelques couleurs...
final int rouge = color(255,0,0);  
final int vert  = color(0,255,0); 
final int bleu  = color(0,0,255);
final int noir  = color(0,0,0); 
final int blanc = color(255,255,255);

// Declaration d'une variable globale
int totalMolette; // Gestion de la roulette centrale

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480,P2D); // Avec acceleration graphique 2D
  surface.setTitle("Exemple 3 - La souris - E. Mesnard / ISIMA");
  colorMode(RGB, 255,255,255); // fixe format couleur R G B pour fill, stroke, etc...
  fill(bleu); // Remplissage bleu
  stroke(rouge); // couleur pourtour RGB - noStroke() si pas de pourtour
  background(blanc); // couleur fond fenetre
  smooth(); // Activation de l’anti-aliasing (smooth)
  
  totalMolette = 0;
} // Fin de Setup

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (mousePressed && (mouseButton == RIGHT)) { // Test clic droit de la souris...
    stroke(vert);     // ... pour trace un rond vert en plus des lignes
    ellipse(mouseX, mouseY, 5, 5);
  }
}

// Fonctions de gestion des evenements de la souris

void mousePressed() { // Fonction invoquee lors de l'appui sur un des deux boutons
  background(noir);   // Equivaut a effacer la fenetre et mettre tout en noir
}

void mouseReleased() { // Fonction invoquee lors du relachement d'un bouton
  background(blanc);   // Equivaut a effacer la fenetre et mettre tout en blanc
}

void mouseDragged() { // Fonction invoquee tant que le bouton est maintenu appuye 
  stroke(rouge);      // Trace d'une ligne rouge entre la nouvelle position de
  line(pmouseX, pmouseY, mouseX, mouseY); // la souris et l'ancienne
}

void mouseWheel(MouseEvent event) {
  totalMolette += event.getCount(); // Prise en compte de l'evenement
  println(totalMolette); // Affichage retour console pour debug
  background(blanc); // Effacement de la fenetre
  // Affichage des informations sur la fenetre de l'application
  text("Total du decalage molette centrale : ",10,20);
  text(str(totalMolette),222,20);
}