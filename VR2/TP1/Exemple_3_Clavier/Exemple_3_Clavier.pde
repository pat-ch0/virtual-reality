/****************************************************************************/
/*  MESNARD Emmanuel                                                ISIMA   */
/*                                                                          */
/*          Exemple 3 : Recuperation des informations "clavier"             */
/*                                                                          */
/* Exemple_3_Clavier.pde                                   Processing 4.2   */
/****************************************************************************/

// Declarations de constantes : Quelques couleurs...
final int rouge = color(255,0,0);  
final int vert  = color(0,255,0); 
final int bleu  = color(0,0,255);
final int noir  = color(0,0,0); 
final int blanc = color(255,255,255);

// Declarations des variables
int X,Y;   // Coordonnees des points a tracer
int Delta; // Le "pas" d'incrementation
boolean flagDebug = true; // Booleen pour afficher ou non les infos de debug

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(400,200); // Fenetre de 400*200
  surface.setTitle("Exemple 3 - Le Clavier - E. Mesnard / ISIMA");
  colorMode(RGB, 255,255,255); // fixe format couleur R G B pour fill, stroke, etc...
  noFill(); // pas de remplissage
  stroke(rouge); // couleur pourtour RGB - noStroke() si pas de pourtour
  background(blanc); // couleur fond fenetre
  smooth(); // Activation de l’anti-aliasing (smooth)
  
  // Initialisation des variables
  X=0; Y=0; Delta=1;
} // Fin de Setup

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
 // Rien de particulier !
}

// Fonction de gestion des evenements du clavier
void keyPressed() {
  // Analyse des caracteres "classiques" 
  switch (key) {    
    case 'd' : flagDebug = !flagDebug; // Debug on/off
               break;                  
    case ' ' : background(blanc); // Appui sur la Barre d'espace
               break;             // pour effacer la fenetre

    // Appui sur les touches plus et moins ...
    case '+' : Delta = (Delta<15) ? (Delta+1) : 15; // ... pour incrementer le pas
               break;             
    case '-' : Delta = (Delta>1) ? (Delta-1) : 1;// ... pour decrementer le pas
               break;
  } 
  // Analyse des caracteres "etendus"
  switch (keyCode) {
    // Fleches : LEFT, RIGHT, UP, DOWN
    case LEFT    : X-=Delta;
                   X = (X<0) ? 0 : X;
                   break;
    case RIGHT   : X+=Delta;
                   X = (X>width) ? width : X;
                   break;
    case UP      : Y-=Delta;
                   Y = (Y<0) ? 0 : Y;
                   break;
    case DOWN    : Y+=Delta;
                   Y = (Y>height) ? height : Y;
                   break;
    // Autres Touches speciales : CONTROL, ALT et SHIFT
  }
  
  if (flagDebug) {  // information en fenetre de console
    println("Touche " + key + " avec le code " + keyCode);
  }

  // Trace d'un point a l'endroit indique
  point(X,Y);
}
