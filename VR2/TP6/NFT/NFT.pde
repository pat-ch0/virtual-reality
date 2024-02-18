import processing.video.*;     // Bibliotheque de controle camera
import jp.nyatla.nyar4psg.*;   // ARToolKit (version 3.0.7)

final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes
boolean debug = false;

String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Camera 
MultiNft sceneNft; // Scene de recherche de "multi-marqueur"

void setup() {
  size(640, 480, P3D); // ouverture en mode 3D
  surface.setTitle("NFT");

  cameras = Capture.list(); 
  if (cameras==null) {
    webCam= new Capture(this, 640, 480);
    webCam.start();
  } else if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !"); 
    exit();
  } else {
    webCam = new Capture(this, cameras[cameras.length-1]);
    webCam.start();
  }

  // Declaration de la scene de recherche avec parametres par defaut :
  // calibration de camera et systeme de coordonnees
  sceneNft = new MultiNft(this, widthCapture, heightCapture, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);

  // Declaration du marqueur a rechercher, avec sa dimension en mm
  sceneNft.addNftTarget("pinball", 80); // Marqueur numero 0
  println(MultiMarker.VERSION); // Affichage numero version en console
}


void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
    sceneNft.detect(webCam);   // Recherche du marqueur dans la scene
    webCam.updatePixels();    // Mise a jour des pixels

    // Effacer la fenetre avant de dessiner l'image video "reelle"
    background(0); 
    image(webCam, 0, 0);  // Affiche l'image prise par la webCam

    // Incrustation de l'image virtuelle si marqueur trouve
    if (sceneNft.isExist(0)) {
      sceneNft.beginTransform(0); // Modification graphique sur marqueur 0
      if (debug) {
        stroke(#FF0000);
        line(0, 0, 0, 80, 0, 0); // Ligne rouge pour X
        stroke(#00FF00);
        line(0, 0, 0, 0, 80, 0); // Ligne verte pour Y
        stroke(#0000FF);
        line(0, 0, 0, 0, 0, 80); // Ligne bleu pour Z
      }
      else {
        strokeWeight(3); // Epaisseur du trait
        stroke(#EA0C7B); // Couleur pourtour par defaut : rose violace
        noFill(); // Sans remplissage
        // trace d'un rectangle 2D : rect(-40,-40,80,80);
        // ... ou mieux, trace d'un cube 3D :
        translate(-20, 50, 40); // Placement du cube au dessus du marqueur (et pas a mi-distance)
        box(80, 80, 80); // Cube de 8 cm de cote
        box(0, 80, -40);
        box(80, 0, -40);
      }
      sceneNft.endTransform();
    }
  }
}

void keyPressed() {
  if (key == 'd') {
    debug = !debug;
  }
}
