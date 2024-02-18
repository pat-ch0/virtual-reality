/****************************************************************************/
/*  MESNARD Emmanuel                                                ISIMA   */
/*                                                                          */
/*          Exemple 7 : Recherche d'un POI - Version webcam Sarxos          */
/*                      Mise en evidence du point le plus vert sur l'image  */
/*                      Analyse naive basee sur un unique point             */
/*                                                                          */
/* Exemple_7_POI_Point_Vert_Sarxos.pde                     Processing 4.2   */
/****************************************************************************/

// Importation des librairies
import com.github.sarxos.webcam.*;   // Bibliotheque SARXOS de gestion webcam
import java.awt.image.BufferedImage; // Biblio pour conversion BufferedImage
import java.awt.Dimension;           // en PImage, a la bonne taille

import java.util.List;    // Pour recuperer la liste des webcams disponibles

Webcam webCam;            // Declaration de la webCam
List<Webcam> cameras ;    // Liste des webCams disponibles
BufferedImage BImgWebCam; // Image fournie par la webCam
PImage PImgWebCam;        // Meme chose, convertie au format Processing PImage

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

final int Teinte_Verte = 120; // En HSB, le vert vaut 120°


// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480); // Ouverture en mode normal 640 * 480
  surface.setTitle("Exemple 7 - POI Point Vert - E. Mesnard / ISIMA");

  // Creation de l'image receptionnant le flux video
  colorMode(RGB, 255);
  PImgWebCam = createImage(widthCapture, heightCapture, ARGB);

  noFill(); // pas de remplissage
  stroke(#FF0000); // couleur Rouge pourtour
  
  colorMode(HSB, 360, 100, 100); // Passage en mode HSB pour Couleur avec teinte
  // Pour faciliter la recherche d'une teinte particuliere
  
  // Recherche d'une webcam 
  cameras = Webcam.getWebcams();
  if (cameras.isEmpty()) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Initialisation de la webcam Video : la derniere de la liste
    webCam = cameras.get(cameras.size()-1);

    // Choix de la resolution pour cette webCam
    webCam.setViewSize(new Dimension(widthCapture, heightCapture)); 
    webCam.open(); // Mise en marche de la webCam
  }
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  int i; // Index du vecteur image...
  int xx, yy; // ... equivalent aux coordonnees matriciels xx et yy
  int yPos; // Decalage offset de la composante y
  
  color currColor; // Couleur du pixel courant...
  float teinte; // Teinte (hue) dans cette couleur
  
  int xPOI, yPOI; // Coordonnees du Point d'interet  : Point Of Interest
  float poids, poidsPOI; // Ecart entre les differences teinte (et le vert pur)
  
  if (webCam.isImageNew() && webCam.isOpen()) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
    // par acquisition d'une image au format BufferedImage
    BImgWebCam = webCam.getImage();
    // Conversion de BufferedImage au format PImage
    PImgWebCam.loadPixels();
    BImgWebCam.getRGB(0, 0, widthCapture, heightCapture, PImgWebCam.pixels, 0, widthCapture);
    PImgWebCam.updatePixels();
    
    // Recherche du point le plus proche de la couleur de reference
    poidsPOI = 360; // Valeur la plus grande possible
    xPOI = 0; yPOI = 0;   // Par defaut, le POI est en (0,0)

    // Analyse de l'image
    PImgWebCam.loadPixels();
    for (yy = 0; yy < heightCapture; yy++) { // abscisse yy
      yPos = yy * widthCapture; 
      for (xx = 0; xx < widthCapture; xx++) { // ordonnees xx
      i = xx + yPos;
        currColor = PImgWebCam.pixels[i]; // recuperation couleur
        teinte = hue(currColor); // et de la teinte
        // Calcul de l'ecart de teinte par rapport au vert pur
        poids = abs(Teinte_Verte-teinte);
        if (poids < poidsPOI) {  // Le POI est le point qui a le moins de difference...
          poidsPOI = poids; // Mise a jour des informations et coordonnees
          xPOI = xx;
          yPOI = yy;
        }
      }
    }
    PImgWebCam.updatePixels();
    // A la sortie de cette boucle, le POI est (xPOI,yPOI)
    // et son ecart a la couleur de reference "vert pur" vaut : poidsPOI

    image(PImgWebCam, 0, 0); // Restitution de l'image captee sur la webCam
    ellipse(xPOI,yPOI,20,20); // Trace d'un cercle rouge autour du POI
  }
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.close(); // Arret "propre" de la webcam
  super.exit();
}
