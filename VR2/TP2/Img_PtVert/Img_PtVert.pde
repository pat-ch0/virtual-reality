import com.github.sarxos.webcam.*;   // Bibliotheque SARXOS de gestion webcam
import java.awt.image.BufferedImage; // Biblio pour conversion BufferedImage
import java.awt.Dimension;           // en PImage, a la bonne taille

import java.util.List;    // Pour recuperer la liste des webcams disponibles

Webcam webCam;            // Declaration de la webCam
List<Webcam> cameras ;    // Liste des webCams disponibles
BufferedImage BImgWebCam; // Image fournie par la webCam
PImage img, ImLact;

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes
int xPrec = 0;
int yPrec = 0;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(640, 480);
  surface.setTitle("C'est vert wallah");

  // Creation de l'image receptionnant le flux video
  noFill(); // pas de remplissage
  stroke(#FF0000); // couleur Rouge pourtour - noStroke() si pas de pourtour
  colorMode(HSB, 360, 100, 100); // Passage en mode HSB pour Couleur avec teinte
  img = createImage(640, 480, ARGB);
  ImLact = loadImage("theCow.jpg");
  ImLact.resize(0, 180);

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
  int i; // Index du vecteur image...
  int xx, yy; // ... equivalent aux coordonnees matriciels xx et yy
  int yPos; // Decalage offset de la composante y
  int a, b;
  color currColor;
  float teinte; // Teinte (hue) dans cette couleur

  int xPOI, yPOI; // Coordonnees du Point d'interet  : Point Of Interest
  float poids, poidsPOI; // Ecart entre les differences teinte (et le vert pur)

  if (webCam.isImageNew() && webCam.isOpen()) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
    // par acquisition d'une image au format BufferedImage
    BImgWebCam = webCam.getImage();
    // Conversion de BufferedImage au format PImage
    BImgWebCam.getRGB(0, 0, 640, 480, img.pixels, 0, 640);
    img.updatePixels();

    poidsPOI = 360; // Valeur la plus grande possible, en distance Euclidienne
    xPOI = 0;
    yPOI = 0;   // Par defaut, le POI est en (0,0)

    // Analyse de l'image
    for (yy = 0; yy < heightCapture; yy++) { // abscisse yy
      yPos = yy * widthCapture;
      for (xx = 0; xx < widthCapture; xx++) { // ordonnees xx
        i = xx + yPos;
        teinte = 0;
        for (int zy = -2; zy < 3; zy++) {
          for (int zx = -2; zx < 3; zx++) {
            if (i + zy*img.width >= 0 && i+zy*img.width < img.width*img.height) {
              a=zy*img.width;
            } else {
              a=0;
            }
            if (xx + zx >= 0 && xx+zx < img.width) {
              b=zx;
            } else {
              b=0;
            }
            teinte += hue(img.pixels[i+a+b]);
          }
        }

        currColor = img.pixels[i]; // recuperation couleur
        teinte = teinte/9; // et de la teinte
        // Calcul de l'ecart de teinte par rapport au vert pur
        poids = abs(120-teinte); // car vert pur = 120 degre
        if (poids < poidsPOI){  // Le POI est le point qui a le moins de difference...
          poidsPOI = poids; // Mise a jour des informations et coordonnees
          xPOI = xx;
          yPOI = yy;
        }
      }
    }
    
    image(img, 0, 0); // Restitution de l'image captee par la webCam
    // ou bien encore par l'ecriture de tous les pixels sur l'ecran
    //set(0, 0, PImgWebCam);
    image(ImLact, xPOI, yPOI);
  }
}

// Affichage du taux de raffraichissement si appui sur une touche
void keyPressed() {
  println("frame rate : " + frameRate);
  println("webcam fps : " + webCam.getFPS());
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.close(); // Arret "propre" de la webcam
  super.exit();
}
