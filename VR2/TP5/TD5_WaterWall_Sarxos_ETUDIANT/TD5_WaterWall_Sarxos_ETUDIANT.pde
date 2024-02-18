/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*            T D  5   d e   R e a l i t e   V i r t u e l l e              */
/*                                                                          */
/*        "WaterWall" - ajout d'ondulations sur une image issu du           */
/*                      flux video de la webcam en mode "Sarxos"            */
/*                      par clic et drag de la souris                       */
/*                                                                          */
/*        Base sur : "gesture_baseFile2a_motionPixels", Daniel Shiffman     */
/*                   "Water Simulation", Rodrigo Amaya                      */
/*                                                                          */
/* TD5_WaterWall_Sarxos_ETUDIANT.pde                   Processing 3.5.4     */
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

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int fpsCapture=30;     // taux d’images/secondes

// Constante et Variables pour la creation des ondulations 
final int IncrementOndulation = 100; // Increment sur l'ondulation (100)
final int DiaOndulations = 3; // Diametre des ondulations autour du point d'impact (3)

// Declaration des variables globales
int TableauOndulations[]; // Tableau des ondulations, avec taille double de l'image a traiter
PImage ImageOndulee;  // Image en sortie, modifiee avec ajout des ondulations

// Indices pour le traitement des ondulations
int OldIndex, NewIndex, MapIndex;


void setup() {
  size(600, 480); // Ouverture a la taille de la webcam : widthCapture x heightCapture
  surface.setTitle("TD 5 - WaterWall - E. Mesnard / ISIMA");

  // Creation de l'image receptionnant le flux video
  colorMode(RGB, 255);
  PImgWebCam = createImage(640, 480, ARGB);
  
  // Recherche d'une webcam 
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
  // Initialisation des variables pour generer les ondulations
  // avec traitements sur des images de taille : widthCapture x heightCapture
  TableauOndulations = new int[widthCapture * (heightCapture+2) * 2];
  ImageOndulee = createImage(widthCapture, heightCapture, ARGB);

  OldIndex = widthCapture; 
  NewIndex = widthCapture * (heightCapture+3);
}


void draw() {
  // Verification de presence d'une nouvelle frame
  if (webCam.isImageNew() && webCam.isOpen()) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
    // par acquisition d'une image au format BufferedImage
    BImgWebCam = webCam.getImage();
    // Conversion de BufferedImage au format PImage
    PImgWebCam.loadPixels();
    BImgWebCam.getRGB(0, 0, 640, 480, PImgWebCam.pixels, 0, 640);
    PImgWebCam.updatePixels();
  }

  // Generation des ondulations, a chaque cycle, meme si pas de nouvelle frame de webcam
  // pour faire correctement evoluer les ronds dans l'eau
  GenererOndulations(PImgWebCam);

  // Restitution de l'image resultante a l'ecran
  image(ImageOndulee, 0, 0);
}

// Fonction d'evolution des ondulations
void GenererOndulations(PImage ImageOrigine) {
  int i; // indice dans la boucle de generation des ondulations 
  int a, b; // Offset du traitement
  int Tmp; // variable temporaire

  // Changement de Map a chaque nouvelle frame : permutation des indices
  Tmp=OldIndex;
  OldIndex=NewIndex;
  NewIndex=Tmp;

  // Utilisation de l'image passee en parametre et de l'image a creer
  ImageOrigine.loadPixels();
  ImageOndulee.loadPixels();

  // Generation des ondulations sur toute l'image
  i=0;
  MapIndex=OldIndex;
  for (int y=0; y<heightCapture; y++) {
    for (int x=0; x<widthCapture; x++) {

      // Algorithme de calcul des ondulations
      short data = (short)((TableauOndulations[MapIndex-widthCapture]
        +TableauOndulations[MapIndex+widthCapture]
        +TableauOndulations[MapIndex-1]
        +TableauOndulations[MapIndex+1])>>1);
      data -= TableauOndulations[NewIndex+i];
      data -= data >> 5;
      TableauOndulations[NewIndex+i]=data;

      // Maintien si data=0; ondulationi si data>0
      data = (short)(1024-data);

      // Calcul des offsets
      a=((x)*data/1024);
      b=((y)*data/1024);

      // Gestion des cas limites, en bordure de l'image
      if (a>=widthCapture) a=widthCapture-1;
      else if (a<0) a=0;
      if (b>=heightCapture) b=heightCapture-1;
      else if (b<0) b=0;
      
      // Creation de l'image ondulee
      ImageOndulee.pixels[i]=ImageOrigine.pixels[a+(b*widthCapture)];
      
      // Traitement du pixel suivant
      MapIndex++;
      i++;
    }
  }
  // Rafraichissement du tableau avant de sortir
  ImageOndulee.updatePixels();
}


// Ajout d'Ondulation autour du point d'impact indique
public void AjoutOndulation(int XX, int YY) {
  for (int j=YY-DiaOndulations; j<YY+DiaOndulations; j++) {
    for (int k=XX-DiaOndulations; k<XX+DiaOndulations; k++) {
      if (j>=0 && j<heightCapture && k>=0 && k<widthCapture) {
        // Le point concerne est dans l'image, donc, il est modifiable
        TableauOndulations[OldIndex+(j*widthCapture)+k] += IncrementOndulation;
      }
    }
  }
}

// Ajout d'ondulations par la souris uniquement 
void mousePressed() {
  AjoutOndulation(mouseX, mouseY);
}

void mouseDragged() {
  AjoutOndulation(mouseX, mouseY);
}
