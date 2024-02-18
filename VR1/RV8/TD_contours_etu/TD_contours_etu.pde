// Importation des librairies
import processing.video.*; // Bibliotheque de controle camera

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Quelques couleurs...
final int noir  = color(0,0,0); 
final int blanc = color(255,255,255);

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Declaration de la Capture par Camera

PImage contours; //image seuillée des contours


//**********************************************************************
// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480); // Ouverture en mode normal 640 * 480
  surface.setTitle("Exemple extraction de contours");
  colorMode(RGB, 255,255,255); 
  noFill(); // pas de remplissage
  background(noir); // couleur fond fenetre
  
  // Recherche d'une webcam 
  //webcam = 
  
  // Initialisation des images

  
} // Fin de Setup



//************************************************************************
// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
    image(webCam, 0, 0); // Restitution de l'image captee sur la webCam   
    
    // Calcul des gradients et contours
    //compute_contours(webCam, contours); // Calcul des contours 
    
    if (mousePressed && (mouseButton == LEFT)){// Test clic gauche de la souris...
      // Affichage de l'image des contours
      //image(contours,0,0);
    }
    else{
     // Affichage de l'image de la Webcam
      image(webCam,0,0);
    }
  } 
}
