import com.github.sarxos.webcam.*;
import com.github.sarxos.webcam.ds.buildin.*;
import com.github.sarxos.webcam.ds.buildin.natives.*;
import com.github.sarxos.webcam.ds.cgt.*;
import com.github.sarxos.webcam.ds.dummy.*;
import com.github.sarxos.webcam.log.*;
import com.github.sarxos.webcam.util.*;
import com.github.sarxos.webcam.util.jh.*;
import java.awt.image.BufferedImage; // Biblio pour conversion BufferedImage
import java.awt.Dimension;           // en PImage, a la bonne taille
import java.util.List;    // Pour recuperer la liste des webcams disponibles

Webcam webCam;            // Declaration de la webCam
List<Webcam> cameras ;    // Liste des webCams disponibles
int nbCam;                // Nombre de cameras dans la liste
BufferedImage BImgWebCam; // Image fournie par la webCam
PImage PImgWebCam;        // Meme chose, convertie au format Processing PImage


// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(640, 480);//, P2D); // attention : P2D limite le redimensionnement fenetre

  surface.setTitle("Exemple 6 - WebCam Sarxos - E. Mesnard / ISIMA");
  surface.setResizable(true); // avec fenetre re dimensionnable

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

    // Par exemple, avec deux cameras :
    // Webcam[0] = Integrated Webcam 0
    // 176.0 X 144.0
    // 320.0 X 240.0
    // 640.0 X 480.0
    // Webcam[1] = Logitech HD Webcam C270 1
    // 176.0 X 144.0
    // 320.0 X 240.0
    // 640.0 X 480.0


    // Initialisation de la webcam Video 
    // webCam = Webcam.getDefault(); // Recuperation de la camera par defaut
    
    // ou bien, en choisissant explicitement la premiere de la liste :
    // webCam = cameras.get(0); // recuperation de la webcam 0
    
    // ou bien encore, en choisissant la camera par son nom
    // webCam = cameras.getWebcamByName("Logitech HD Webcam C270 1");
    
    // ou encore, en choisissant explicitement la derniere de la liste :
    webCam = cameras.get(nbCam-1); // ou directement webCam = cameras.get(cameras.size()-1);

    // Choix de la resolution pour cette webCam
    webCam.setViewSize(new Dimension(640, 480)); 

    webCam.open(); // Mise en marche de la webCam (Ouverture effective du flux video)
  }
}


void draw() {
  if (webCam.isImageNew() && webCam.isOpen()) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
    // par acquisition d'une image au format BufferedImage
    BImgWebCam = webCam.getImage();
    // Conversion de BufferedImage au format PImage
    PImgWebCam.loadPixels();
    BImgWebCam.getRGB(0, 0, 640, 480, PImgWebCam.pixels, 0, 640);
    PImgWebCam.updatePixels();

    image(PImgWebCam, 0, 0, width, height); // Restitution de l'image etiree a la taille fenetre

  }
}

// Affichage du taux de raffraichissement si appui sur une touche
void keyPressed() {
  println("Processing FrameRate : " + frameRate); // Affichage du nombre de "draw" a la seconde
  println("WebCam FrameRate : " +webCam.getFPS()); // Affichage framerate de la camera
  surface.setSize(640,480); // Redimensionnement de la fenetre processing a 640x480
  surface.setLocation(100,100); // avec positionnement en haut a gauche de l'ecran
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.close(); // Arret "propre" de la webcam
  super.exit();
}
