// Importation des librairies
import processing.video.*; // Bibliotheque de controle camera
import java.util.*;

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

//Paramètres de filtrage
float[][] lissage = { { 1./9.,1./9.,1./9. },
                    { 1./9.,1./9.,1./9. },
                    { 1./9.,1./9.,1/9. } }; 
PImage img_lissee;  // image lissée
PImage contours; //image seuillée des contours
PImage gradient;  // image de la norme du gradient
PImage gradnms;  // image du gradient après nms

// Paramètres hysteresis
int seuil_haut = 50; //Changer ici
int seuil_bas = 10;

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
  cameras = Capture.list();
  if (cameras.length == 0) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Initialisation de la webcam Video par defaut
    webCam = new Capture(this, widthCapture, heightCapture, cameras[0], fpsCapture);
    webCam.start(); // Mise en marche de la webCam
  }
  
  // Initialisation des images
  img_lissee = createImage(webCam.width, webCam.height, RGB);
  gradient = createImage(webCam.width, webCam.height, RGB);
  contours = createImage(webCam.width, webCam.height, RGB);
  gradnms = createImage(webCam.width, webCam.height, RGB);
} // Fin de Setup


//************************************************************************
// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
    image(webCam, 0, 0); // Restitution de l'image captee sur la webCam   
    
    // Calcul des contours 
    compute_contours(webCam, img_lissee, gradient, gradnms, contours); 
    
    // Transformée de Hough
    int [][] tab = compute_hough(contours,1); 

    //Parcours de l'accumulateur pour récupérer les principales lignes
    Vector<droite> vecteur = compute_hough_lines(tab, 110);

    //Affichage
    image(webCam,0,0);

    if (mousePressed && (mouseButton == RIGHT)) { // Test clic droit de la souris...
      // Display the destination
      image(gradient,0,0);
    }
    else if (mousePressed && (mouseButton == LEFT)){
      image(contours,0,0);
    }
    for(int i=0;i<vecteur.size();i++){
      vecteur.get(i).display(color(150,25,150),webCam.width,webCam.height);
    }
  }
}
