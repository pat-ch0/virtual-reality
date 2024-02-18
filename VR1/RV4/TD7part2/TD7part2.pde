import processing.video.*;     // Bibliotheque de controle camera
import jp.nyatla.nyar4psg.*;   // ARToolKit (version 3.0.7)

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Camera 
MultiNft sceneNft;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640, 480, P3D); // ouverture en mode 3D
  surface.setTitle("Exemple 8 - RA Cube - E. Mesnard / ISIMA");
  strokeWeight(3); // Epaisseur du trait
  stroke(#EA0C7B); // Couleur pourtour par defaut : rose violace
  noFill(); // Sans remplissage

  // Recherche d'une webcam 
  cameras = Capture.list();
  if (cameras.length == 0) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Initialisation de la webcam par defaut
    webCam = new Capture(this, widthCapture, heightCapture, cameras[0], fpsCapture);
    webCam.start(); // Mise en marche de la webCam
  }

  // Declaration de la scene de recherche avec parametres par defaut :
  // calibration de camera et systeme de coordonnees
  sceneNft= new MultiNft(this,
  widthCapture, heightCapture,
  "camera_para.dat",
  NyAR4PsgConfig.CONFIG_PSG);

  // Declaration du marqueur a rechercher, avec sa dimension en mm
  sceneNft.addNftTarget("NFTsega",80);
  println(MultiMarker.VERSION); // Affichage numero version en console
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame

    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame

    sceneNft.detect(webCam);   // Recherche du marqueur dans la scene
    webCam.updatePixels();    // Mise a jour des pixels
    
    // Effacer la fenetre avant de dessiner l'image video "reelle"
    background(0); 
    image(webCam, 0, 0);  // Affiche l'image prise par la webCam

    // Incrustation de l'image virtuelle si marqueur trouve
   if (sceneNft.isExist(0)) { // Marqueur ISIMA
      // Le marqueur est detecte dans le flux video
      // Changement de repere pour tracer en coordonnees "Marqueur"
      sceneNft.beginTransform(0); // Modification graphique sur marqueur 0
      // trace d'un rectangle 2D : rect(-40,-40,80,80);
      // ... ou mieux, trace d'un cube 3D :
      translate(0, 0, 40); // Placement du cube au dessus du marqueur (et pas a mi-distance)
      sceneNft.endTransform();
    }
  }
}
