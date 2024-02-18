/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*           Gestion d'une Webcam via la bibliotheque Java Sarxos           */
/*                                                                          */
/* Exemple_4b_Webcam_Sarxos.pde                        Processing 3.5.4     */
/****************************************************************************/

// A NOTER : le code equivalent en mode standard "Capture" est fourni
// en commentaire dans le bas de ce fichier

import com.github.sarxos.webcam.*;   // Bibliotheque SARXOS de gestion webcam
import java.awt.image.BufferedImage; // Biblio pour conversion BufferedImage
import java.awt.Dimension;           // en PImage, a la bonne taille

import java.util.List;    // Pour recuperer la liste des webcams disponibles

Webcam webCam;            // Declaration de la webCam
List<Webcam> cameras ;    // Liste des webCams disponibles
BufferedImage BImgWebCam; // Image fournie par la webCam
PImage PImgWebCam;        // Meme chose, convertie au format Processing Image

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(640, 480);

  surface.setTitle("Exemple 4b - WebCam Sarxos - E. Mesnard / ISIMA");

  // Creation de l'image receptionnant le flux video
  colorMode(RGB, 255);
  PImgWebCam = createImage(640, 480, ARGB);

  // Recherche des webCams disponibles, par interrogation du systeme d'exploitation
  cameras = Webcam.getWebcams();

  if (cameras.isEmpty()) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Affichage console de la liste des webcams disponibles
    println("Voici toutes les webcams disponibles : " + cameras);
    
    // Ou bien encore, avec plus de details :
    int i=0;
    for (Webcam Cami : cameras) { // Analyse de toutes les cameras
      // Affichage du nom de chaque camera
      println("Webcam["+i+"] = " + Cami.getName());
      // Lecture des resolutions disponibles
      Dimension[] ResolutionsDispos = Cami.getViewSizes();   
      for (Dimension Resol : ResolutionsDispos) {
        println(Resol.getWidth()+" X "+Resol.getHeight());
      }
      i++;
    }

    // Initialisation de la webcam Video 
    webCam = Webcam.getDefault(); // Recuperation de la camera par defaut
    // ou bien  webCam = cameras.get(0); // recuperation de la webcam 0

    // Choix de la resolution pour cette webCam
    Dimension ResolWebCam = new Dimension(640, 480);
    webCam.setViewSize(ResolWebCam);

    webCam.open(); // Mise en marche de la webCam (Ouverture effective du flux video)
  }
}


void draw() {
  if (webCam.isImageNew() && webCam.isOpen()) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
    // par acquisition d'une image au format BufferedImage
    BImgWebCam = webCam.getImage();
    // Conversion de BufferedImage au format PImage
    BImgWebCam.getRGB(0, 0, 640, 480, PImgWebCam.pixels, 0, 640);
    PImgWebCam.updatePixels();

    image(PImgWebCam, 0, 0); // Restitution de l'image captee par la webCam
    // ou bien encore par l'ecriture de tous les pixels sur l'ecran
    //set(0, 0, PImgWebCam);
  }
}

// Affichage du taux de raffraichissement si appui sur une touche
void keyPressed() {
  println(frameRate);
  println(webCam.getFPS());
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.close(); // Arret "propre" de la webcam
  super.exit();
}


/****************************************************************************
 ****************************************************************************
 
 //         EQUIVALENCE AVEC LA BIBLIOTHEQUE STANDARD DE PROCESSING
 
 // Importation des librairies
 import processing.video.*; // Bibliotheque de controle camera
 
 Capture webCam;      // Declaration de la Capture par Camera
 PImage pImg ; // Image capturee sur la webCam
 
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
 pImg.copy( webCam, 0, 0, 640, 480, 0, 0, 640, 480 );
 image(pImg, 0, 0); // Restitution de l'image captee sur la webCam
 }
 }
 
 
 void keyPressed() {
 println(frameRate);
 }
 
 */
