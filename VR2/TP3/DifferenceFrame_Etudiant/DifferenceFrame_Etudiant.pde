/****************************************************************************/
/*  MESNARD Emmanuel                                                ISIMA   */
/*                                                                          */
/*      Difference de Frame  avec Webcam via le mode "Sarxos"               */
/*                                                                          */
/* TD3_DifferenceFrame_Etudiant.pde                      Processing 3.5.4   */
/****************************************************************************/
// Importation des librairies
import com.github.sarxos.webcam.*;   // Bibliotheque SARXOS de gestion webcam
import java.awt.image.BufferedImage; // Biblio pour conversion BufferedImage
import java.awt.Dimension;           // en PImage, a la bonne taille

import java.util.List;    // Pour recuperer la liste des webcams disponibles

Webcam webCam;            // Declaration de la webCam
List<Webcam> cameras ;    // Liste des webCams disponibles
int nbCam;                // Nombre de cameras dans la liste
BufferedImage BImgWebCam; // Image fournie par la webCam
PImage PImgWebCam;        // Meme chose, convertie au format Processing PImage

// Parametres de la capture video
final int widthCapture = 640;  // Largeur capture
final int heightCapture = 480; // Hauteur capture
int numPixels;                 // NB de pixels webcam

// Variables pour comparaison des images
PImage precImg;       // Image Precedente sur flux camera
PImage diffFrameImg;  // Image "difference de frame" montrant le mouvement
int i; // index pour les boucles

color pixelCourant=0;
color pixelPrecedent=0;
// Difference des couleurs des deux pixels
int diffPixel=0;  // total
int diffPixelR=0; // par composante
int diffPixelG=0;
int diffPixelB=0; 
// Indicateur de mouvement (somme des differences)
int mouvementTotal=0;  

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(640, 480); //, P2D); // attention : P2D limite le redimensionnement fenetre

  surface.setTitle("Difference de Frame sur flux video - E. Mesnard / ISIMA");
  surface.setResizable(true); // avec fenetre re dimensionnable

  // Creation de l'image receptionnant le flux video
  colorMode(RGB, 255);
  PImgWebCam = createImage(widthCapture, heightCapture, ARGB);

  // Creation des images de travail
  precImg = createImage(widthCapture, heightCapture, RGB);
  diffFrameImg = createImage(widthCapture, heightCapture, RGB);

  // Intialisation des images de travail
  numPixels = widthCapture * heightCapture;
  for (i = 0; i < numPixels; i++) {
    precImg.pixels[i] = 0;
    diffFrameImg.pixels[i] = 0;
  }

  // Recherche des webCams disponibles, par interrogation du systeme d'exploitation
  cameras = Webcam.getWebcams();

  if (cameras.isEmpty()) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Affichage console de la liste des webcams disponibles
    println("Voici toutes les webcams disponibles : " + cameras);

    // Par exemple, avec deux cameras :
    //Voici toutes les webcams disponibles : [Webcam Integrated Webcam 0, Webcam Logitech HD Webcam C270 1]

    // Ou bien encore, avec plus de details :

    nbCam=0;
    for (Webcam Cam : cameras) { // Analyse de toutes les cameras
      // Affichage du nom de chaque camera
      println("Webcam["+nbCam+"] = " + Cam.getName());
      nbCam++;

      // Lecture des resolutions disponibles
      Dimension[] ResolutionsDispos = Cam.getViewSizes();   
      for (Dimension Resol : ResolutionsDispos) {
        println(Resol.getWidth()+" X "+Resol.getHeight());
      }
    } // A la fin du for, nbCam est le nombre de cameras disponibles sur la machine
    // NB : il est egalement possible de faire : nbCam = cameras.size();
    // ou encore, en choisissant explicitement la derniere de la liste :
    webCam = cameras.get(nbCam-1); // ou directement webCam = cameras.get(cameras.size()-1);

    // Choix de la resolution pour cette webCam
    webCam.setViewSize(new Dimension(widthCapture, heightCapture)); // en 640 x 480

    webCam.open(); // Mise en marche de la webCam (Ouverture effective du flux video)
  }
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {

 if (webCam.isImageNew() && webCam.isOpen()) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
    // par acquisition d'une image au format BufferedImage
    BImgWebCam = webCam.getImage();
    // Conversion de BufferedImage au format PImage
    PImgWebCam.loadPixels();
    BImgWebCam.getRGB(0, 0, 640, 480, PImgWebCam.pixels, 0, 640);
    PImgWebCam.updatePixels();

    precImg.loadPixels();
    diffFrameImg.loadPixels();
    PImgWebCam.loadPixels();
    mouvementTotal = 0;
    for (i = 0; i < numPixels; i++) {
      pixelCourant = PImgWebCam.pixels[i];
      pixelPrecedent = precImg.pixels[i];

      // Calcul des differences sur les 3 composantes couleur : R, G et B
      diffPixelR = abs(((pixelCourant >> 16) & 0xFF) - ((pixelPrecedent >> 16) & 0xFF));
      // A noter : equivalent a :  abs( red(pixelCourant) - red(pixelPrecedent) )
      diffPixelG = abs(((pixelCourant >> 8) & 0xFF) - ((pixelPrecedent >> 8) & 0xFF));
      diffPixelB = abs((pixelCourant & 0xFF) - (pixelPrecedent & 0xFF));

      diffPixel = diffPixelR + diffPixelG + diffPixelB;

      // Quantification du mouvement
      mouvementTotal += diffPixel;

      // Mise en evidence du mouvement par difference de Frame
      diffFrameImg.pixels[i] = color(diffPixel, diffPixel, diffPixel); // en niveaux de gris
      //mvtImg.pixels[i] = color(diffPixelR, diffPixelG, diffPixelB); // en couleur

      // Changement d'image : sauvegarde comme image precedente
      precImg.pixels[i] = pixelCourant;
      // Variante possible ici : ne faire cette mise a jour que de temps en temps
    }
    PImgWebCam.updatePixels();
    precImg.updatePixels();
    diffFrameImg.updatePixels();

    // println(mouvementTotal);

    image(diffFrameImg, 0, 0, width, height); // Affichage de l'image des differences en plein ecran
  }
} // Fin de draw

void keyPressed() {
  println(frameRate); // Affichage du nombre de "draw" a la seconde
  surface.setSize(640, 480); // Redimensionnement de la fenetre processing a 640x480
  surface.setLocation(100, 100); // avec positionnement en haut a gauche devf    l'ecran
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.close(); // Arret "propre" de la webcam
  super.exit();  // Re envoi de l'exit pour quitter reellement
}
