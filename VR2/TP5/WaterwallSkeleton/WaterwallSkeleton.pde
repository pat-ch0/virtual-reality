import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect

PKinect kinect;   // Declaration de la Kinect

byte[] colorMap;    // Carte des valeurs des couleurs = Flux "COLOR"
PImage  colorImage; // Image RGB reconstruite equivalente
int colorW = 0;     // Largeur de l'image RGB
int colorH = 0;     // Hauteur de l'image RGB

// Constante et Variables pour la creation des ondulations 
final int IncrementOndulation = 100; // Increment sur l'ondulation (100)
final int DiaOndulations = 3; // Diametre des ondulations autour du point d'impact (3)
int TableauOndulations[]; // Tableau des ondulations, avec taille double de l'image a traiter
PImage ImageATraiter; // Image d'entree sur laquelle il faut calculer les ondulations
PImage ImageOndulee;  // Image en sortie, modifiee avec ajout des ondulations
// Indices pour le traitement des ondulations
int OldIndex, NewIndex, MapIndex;
Skeleton[] s;
int sMax;

void setup() {
  size(640, 480);
  surface.setTitle("Waterwall skeleton");
  colorMode(RGB, 255, 255, 255);
  kinect = new PKinect(this);
  stroke(#1ED315);
  strokeWeight(3);

  if (kinect.start(PKinect.SKELETON | PKinect.COLOR) == false) {
    println("Pas de kinect connectee !"); 
    exit(); 
    return;
  } else if (kinect.isInitialized()) {
    print("Kinect de type : " + kinect.getDeviceType());
    println(" initialisee avec : ");
    colorW = kinect.getColorWidth();
    colorH = kinect.getColorHeight();
    println("  * Largeur image couleur : " + colorW);
    println("  * Hauteur image couleur : " + colorH);
    sMax = kinect.getSkeletonCountLimit();
  } else { 
    println("Probleme d'initialisation de la kinect");
    exit(); 
    return;
  }

  // Creation des objets Color
  colorMap = new byte[colorW*colorH*4];
  colorImage = createImage(colorW, colorH, RGB);

  // Initialisation des variables pour generer les ondulations
  // avec traitements sur des images de taille : widthCapture x heightCapture
  TableauOndulations = new int[width * (height+2) * 2];
  ImageATraiter = createImage(width, height, RGB);
  ImageOndulee = createImage(width, height, RGB);
  OldIndex = width; 
  NewIndex = width * (height+3);
}

void draw() { 
  int i, j;
  int x, y;

  s = kinect.getSkeletons();
  colorMap = kinect.getColorFrame();

  if (colorMap != null) {
    //Ondulation main droite
    for (i=0; i<sMax; i++) {
      if (s[i]!=null) { // Des donnees sont disponibles
        if (s[i].isJointTracked(Skeleton.HAND_RIGHT)) {
          x = (int) s[i].get3DJointX(Skeleton.HAND_RIGHT);
          println(x);
          y = (int) s[i].get3DJointY(Skeleton.HAND_RIGHT);
          AjoutOndulation(x, y);
        }
      }
    }

    colorImage.loadPixels();
    j = 0;
    for (i = 0; i < colorMap.length; i+=4) {
      colorImage.pixels[j] = (colorMap[i+2]&0x0000FF)<<16 | (colorMap[i+1]&0x0000FF)<<8 | (colorMap[i]&0x0000FF);
      j++;
    }
    colorImage.updatePixels();
    // Sauvegarde de l'image pour mise a jour de l'image a traiter
    ImageATraiter.copy(colorImage, 0, 0, width, height, 0, 0, width, height);
  }
  // Generation des ondulations, a chaque cycle, meme si pas de nouvelle frame de webcam
  GenererOndulations(ImageATraiter);
  // Restitution de l'image resultante a l'ecran
  image(ImageOndulee, 0, 0, width, height);
  for (i=0; i<sMax; i++) {
    if (s[i]!=null) { // Des donnees sont disponibles
      if (s[i].isTracked()) {
        traceSquelette(i);
      }
    }
  }
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
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {

      // Algorithme de calcul des ondulations
      short data = (short)((TableauOndulations[MapIndex-width]
        +TableauOndulations[MapIndex+width]
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
      if (a>=width) a=width-1;
      else if (a<0) a=0;
      if (b>=height) b=height-1;
      else if (b<0) b=0;

      // Creation de l'image ondulee
      ImageOndulee.pixels[i]=ImageOrigine.pixels[a+(b*width)];
      // Traitement du pixel suivant
      MapIndex++;
      i++;
    }
  }
  // Rafraichissement du tableau avant de sortir
  ImageOndulee.updatePixels();
  ImageOrigine.updatePixels();
}

// Ajout d'Ondulation autour du point d'impact indique
public void AjoutOndulation(int XX, int YY) {
  for (int j=YY-DiaOndulations; j<YY+DiaOndulations; j++) {
    for (int k=XX-DiaOndulations; k<XX+DiaOndulations; k++) {
      if (j>=0 && j<height && k>=0 && k<width) {
        // Le point concerne est dans l'image, donc, il est modifiable
        TableauOndulations[OldIndex+(j*width)+k] += IncrementOndulation;
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

// Trace du squelette du personnage
void traceSquelette(int userId) {
  // Tete
  dessinMembre(userId, Skeleton.HEAD, Skeleton.NECK);

  // Bras Gauche
  dessinMembre(userId, Skeleton.NECK, Skeleton.SHOULDER_LEFT);
  dessinMembre(userId, Skeleton.SHOULDER_LEFT, Skeleton.ELBOW_LEFT);
  dessinMembre(userId, Skeleton.ELBOW_LEFT, Skeleton.WRIST_LEFT);
  dessinMembre(userId, Skeleton.WRIST_LEFT, Skeleton.HAND_LEFT);

  // Bras droit
  dessinMembre(userId, Skeleton.NECK, Skeleton.SHOULDER_RIGHT);
  dessinMembre(userId, Skeleton.SHOULDER_RIGHT, Skeleton.ELBOW_RIGHT);
  dessinMembre(userId, Skeleton.ELBOW_RIGHT, Skeleton.WRIST_RIGHT);
  dessinMembre(userId, Skeleton.WRIST_RIGHT, Skeleton.HAND_RIGHT);

  // Torse
  dessinMembre(userId, Skeleton.SHOULDER_LEFT, Skeleton.SPINE_MID);
  dessinMembre(userId, Skeleton.SHOULDER_RIGHT, Skeleton.SPINE_MID);
  dessinMembre(userId, Skeleton.SPINE_BASE, Skeleton.SPINE_MID);

  // Jambe gauche
  dessinMembre(userId, Skeleton.SPINE_BASE, Skeleton.HIP_LEFT);
  dessinMembre(userId, Skeleton.HIP_LEFT, Skeleton.KNEE_LEFT);
  dessinMembre(userId, Skeleton.KNEE_LEFT, Skeleton.ANKLE_LEFT);
  dessinMembre(userId, Skeleton.ANKLE_LEFT, Skeleton.FOOT_LEFT);

  // Jambe droite
  dessinMembre(userId, Skeleton.SPINE_BASE, Skeleton.HIP_RIGHT);
  dessinMembre(userId, Skeleton.HIP_RIGHT, Skeleton.KNEE_RIGHT);
  dessinMembre(userId, Skeleton.KNEE_RIGHT, Skeleton.ANKLE_RIGHT);
  dessinMembre(userId, Skeleton.ANKLE_RIGHT, Skeleton.FOOT_RIGHT);
}

// Trace d'un seul membre du corps
void dessinMembre(int userId, int jointType1, int jointType2) {
  int[] jointPos1; // Coordonnees des membres
  int[] jointPos2;

  // Verification de la presence effective du membre
  if ( (s[userId].isJointTracked(jointType1)==true) &&
    (s[userId].isJointTracked(jointType2)==true) ) {

    // Recuperation des coordonnees 2D, proportionnelles a la taille de la fenetre
    jointPos1 = s[userId].get2DJoint(jointType1, width, height);
    jointPos2 = s[userId].get2DJoint(jointType2, width, height);

    // Trace du trait
    line(jointPos1[0], jointPos1[1], jointPos2[0], jointPos2[1]);
  }
}
