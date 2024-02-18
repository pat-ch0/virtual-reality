/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 1 : ouverture d'une fenetre et trace d'une ligne        */
/*                                                                          */
/* Exemple_1_Les_Bases.pde                             Processing 3.5.1     */
/****************************************************************************/

// Declarations de constantes : Quelques couleurs...
final int rouge = color(255,0,0); 
final int vert  = color(0,255,0); 
final int bleu  = color(0,0,255);
final int noir  = color(0,0,0); 
final int blanc = color(255,255,255); 

// Fonction d'initialisation de l'application - executee une seule fois
void setup(){
  // Initialisation des parametres graphiques utilises
  size(400,200); // Fenetre de 400*200, sans appeler la carte graphique
  // ou bien : 
  //size(400,200,P2D); // Fenetre de 400*200 avec acceleration carte graphique, en 2D
  surface.setTitle("Exemple 1 - Les Bases - E. Mesnard / ISIMA");
  
  colorMode(RGB, 255,255,255); // fixe format couleur R G B pour fill, stroke, etc...
  fill(vert); // couleur remplissage RGB - noFill() si pas de remplissage
  stroke(rouge); // couleur pourtour RGB - noStroke() si pas de pourtour
  background(noir); // couleur fond fenetre
  
  line(80,120,270,5); // trace d'une ligne rouge : x=largeur; y=hauteur(vers le bas!)
  
  stroke(bleu); // changement de couleur pour trace un cercle bleu...
  ellipse(width/2,height/2,15,15); // au centre de la fenetre, de rayon 15
}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Ne rien faire de particulier !
}