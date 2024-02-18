/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 12 : gestion des Gestures de Ketai sur une image        */
/*                                                                          */
/* Exemple_12_Android_Gestures.pde           Processing 3.5.4 - ANDROID     */
/****************************************************************************/

// Import de la gestion des Gestures
import ketai.ui.*;

// Declaration du gestionnaire de gesture
KetaiGesture gesture;

// Variable gerant une image a afficher
PImage Image;
float PositionX;
float PositionY;
float Orientation;
float Taille;
final int TailleMini = 50;
final int TailleMaxi = 15000;

// Gestion de la fermeture de l'application
// (appui long pour faire apparaitre le bouton, puis click dessus)
boolean AfficherBoutonQuitter;
PImage ImageExit;
int TailleBouton;

void setup() {
  fullScreen();
  orientation(LANDSCAPE);

  // Mise en place de la gestion des mouvements sur ecran
  gesture = new KetaiGesture(this);

  // Initialisation de l'image
  Image = loadImage("ISIMA.jpg");
  // Positionnement de l'image, au demarrage, centree
  PositionX = width/2;
  PositionY = height/2;
  
  Taille = 100;
  Orientation = 0;
  
  imageMode(CENTER);
  
  ImageExit = loadImage("Exit.png");
  AfficherBoutonQuitter = false;
  TailleBouton = width/4;
}

void draw() {
  background(0);
  
  // Positionnement et orientation correcte de l'image
  pushMatrix();
  translate(PositionX, PositionY);
  rotate(Orientation);
  image(Image, 0, 0, Taille, Taille);
  popMatrix();
  if (AfficherBoutonQuitter) { // Au centre
    image(ImageExit, width/2, height/2, TailleBouton, TailleBouton);
  }
}

void onDoubleTap(float x, float y) {
  // Deplacement de l'image a cet endroit
  PositionX = x;
  PositionY = y;
}

void onTap(float x, float y) {
  // On quitte si le bouton est affiche et que clic dessus
  if (AfficherBoutonQuitter) {
    if ((x>(width/2)-TailleBouton/2) && (x<(width/2)+TailleBouton/2) 
    && (y>(height/2)-TailleBouton/2) && (y<(height/2)+TailleBouton/2)) {
      exit();
    }
  }
}

void onLongPress(float x, float y) {
  AfficherBoutonQuitter = !AfficherBoutonQuitter;
}


void onFlick( float x, float y, float px, float py, float v) {
  // Coordonnees du debut, de fin et vitesse en pixels/sec
}

void onPinch(float x, float y, float d) {
  // Zoom sur l'image, dans une limite raisonnable
  Taille = constrain(Taille+d, TailleMini, TailleMaxi);
}

void onRotate(float x, float y, float angle) {
  // Rotation de l'image
  Orientation += angle;
}
