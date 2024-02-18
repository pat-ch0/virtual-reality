/****************************************************************************/
/*  MESNARD Emmanuel                                                ISIMA   */
/*                                                                          */
/*      Gestion d'une Webcam via le mode "Capture" de la bibliotheque       */
/*      standard de Processing  "processing.video.*" basee sur GStreamer    */
/*                                                                          */
/* Exemple_5_Webcam_Capture.pde                            Processing 4.2   */
/****************************************************************************/
// Importation des librairies
import processing.video.*; // Bibliotheque de controle camera

Capture webCam;      // Declaration de la Capture par Camera
String[] cameras;    // Liste textuelle des webCams disponibles

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(640, 480); //, P2D); // attention : P2D limite le redimensionnement fenetre

  surface.setTitle("Exemple 5 - WebCam Capture Standard - E. Mesnard / ISIMA");
  surface.setResizable(true); // avec fenetre re dimensionnable

  // Recherche des webCams disponibles, par interrogation du systeme d'exploitation
  cameras = Capture.list(); 

  if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Affichage console de la liste des webcams disponibles
    printArray(cameras); 
    // Par exemple, deux cameras :
    // [0] "Integrated Webcam"
    // [1] "Logitech HD Webcam C310"

    // Initialisation de la webcam Video
    
    // Prendre par defaut : la premiere
    // webCam = new Capture(this, 640, 480); // Webcam par defaut
    // ou encore, en choisissant explicitement la premiere de la liste :
    //    webCam = new Capture(this, cameras[0]);
    
    // ou encore, en choisissant explicitement la derniere de la liste :
    webCam = new Capture(this, cameras[cameras.length-1]);
    
    // ou en precisant la resolution :
    //    webCam = new Capture(this, 640, 480, cameras[0], 30);
    
    // ou bien encore, en choisissant la camera par son nom
    //    webCam = new Capture(this, 640, 480, "Logitech HD Webcam C310", 30);

    webCam.start(); // Mise en marche de la webCam
  }
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
    // image(webCam, 0, 0); // Restitution de l'image ...
    image(webCam, 0, 0, width, height); // image etiree a la taille fenetre
  }
} // Fin de draw

void keyPressed() {
  println(frameRate); // Affichage du nombre de "draw" a la seconde
  surface.setSize(640,480); // Redimensionnement de la fenetre processing a 640x480
  surface.setLocation(100,100); // avec positionnement en haut a gauche de l'ecran
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.stop(); // Arret "propre" de la webcam
  super.exit();  // Re envoi de l'exit pour quitter reellement
}


/******************************************************************
 
 // Meme chose, avec recopie de chaque image du flux dans 
 // une variable temporaire globale "pImg"
 
 
 // Importation des librairies
 import processing.video.*; // Bibliotheque de controle camera
 
 Capture webCam;  // Declaration de la Capture par Camera
 PImage pImg ;    // Image capturee sur la webCam
 
 // Fonction d'initialisation de l'application - executee une seule fois
 void setup() {
 size(640, 480);
 pImg = createImage(640, 480, ARGB);
 
 webCam = new Capture(this, 640, 480, 30);
 webCam.start(); // Mise en marche de la webCam
 } // Fin de Setup
 
 
 // Fonction de re-tracage de la fenetre - executee en boucle
 void draw() {
 if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
 webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
 pImg.copy( webCam, 0, 0, 640, 480, 0, 0, 640, 480 ); // Copie en memoire de l'image lue
 image(pImg, 0, 0); // Restitution de l'image captee sur la webCam
 }
 }
 
 ***********************************************************************/
