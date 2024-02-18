/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*        "WaterWall" - ajout d'ondulations sur une image issu du           */
/*                      flux video de la webcam en mode "Capture"           */
/*                      par clic et drag de la souris                       */
/*                                                                          */
/*        Base sur : "gesture_baseFile2a_motionPixels", Daniel Shiffman     */
/*                   "Water Simulation", Rodrigo Amaya                      */
/*                                                                          */
/* TD5_WaterWall_Capture_ETUDIANT.pde                  Processing 3.5.4     */
/****************************************************************************/

// Importation des librairies
import processing.video.*;     // Bibliotheque de controle camera

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Camera 

// Constante et Variables pour la creation des ondulations 
final int IncrementOndulation = 100; // Increment sur l'ondulation (100)
final int DiaOndulations = 3; // Diametre des ondulations autour du point d'impact (3)
int TableauOndulations[]; // Tableau des ondulations, avec taille double de l'image a traiter
PImage ImageATraiter; // Image d'entree sur laquelle il faut calculer les ondulations
PImage ImageOndulee;  // Image en sortie, modifiee avec ajout des ondulations

// Indices pour le traitement des ondulations
int OldIndex, NewIndex, MapIndex;


void setup() {
  size(600, 480); // Ouverture a la taille de la webcam : widthCapture x heightCapture
  surface.setTitle("TD 5 - WaterWall - E. Mesnard / ISIMA");

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

  // Initialisation des variables pour generer les ondulations
  // avec traitements sur des images de taille : widthCapture x heightCapture
  TableauOndulations = new int[widthCapture * (heightCapture+2) * 2];
  ImageATraiter = createImage(widthCapture, heightCapture, ARGB);
  ImageOndulee = createImage(widthCapture, heightCapture, ARGB);

  OldIndex = widthCapture; 
  NewIndex = widthCapture * (heightCapture+3);
}


void draw() {
  // Verification de presence d'une nouvelle frame
  if (webCam.available() == true) { 
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame

    // Sauvegarde de cette image pour mise a jour de l'image a traiter
    ImageATraiter.copy(webCam, 0, 0, widthCapture, heightCapture, 0, 0, widthCapture, heightCapture);
  }

  // Generation des ondulations, a chaque cycle, meme si pas de nouvelle frame de webcam
  // pour faire correctement evoluer les ronds dans l'eau
  GenererOndulations(ImageATraiter);

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
