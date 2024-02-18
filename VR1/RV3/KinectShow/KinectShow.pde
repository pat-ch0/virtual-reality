import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect

PKinect kinect;
Skeleton[] s;
int sMax;

PImage[] ImIncr;
int currIm = 0, modif = 0;

byte[] colorMap;    // Carte des valeurs des couleurs = Flux "COLOR"
PImage  colorImage; // Image RGB reconstruite equivalente
int colorW = 0;     // Largeur de l'image RGB
int colorH = 0;     // Hauteur de l'image RGB


// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480);
  surface.setTitle("KINECT SHOW !!! - Remrem et Anthotho");
  colorMode(RGB, 255, 255, 255); // fixe format couleur R G B
  
  ImIncr = new PImage[5];
  ImIncr[0] = loadImage("Obamaa.jpg");
  ImIncr[0].resize(0, 180);
  ImIncr[1] = loadImage("shy.jpg");
  ImIncr[1].resize(0, 180);
  ImIncr[2] = loadImage("chad.jpg");
  ImIncr[2].resize(0, 180);
  ImIncr[3] = loadImage("brain.jpg");
  ImIncr[3].resize(0, 180);
  ImIncr[4] = loadImage("angry.jpg");
  ImIncr[4].resize(0, 180);
 
  // Initialisation Objet Kinect
  kinect = new PKinect(this);

  // Ouverture du flux "COLOR" 
  if (kinect.start(PKinect.COLOR | PKinect.SKELETON) == false) {
    println("Pas de kinect connectee !"); 
    exit();
    return;
  } else if (kinect.isInitialized()) {
    println("Kinect de type : "+kinect.getDeviceType());
    println("Kinect initialisee avec : ");
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
}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() { 
  int i, j;
  s = kinect.getSkeletons();

  colorMap = kinect.getColorFrame();

  // Traitement du Flux "COLOR"
  if (colorMap!=null) { // Des donnees couleur sont disponibles

    // Conversion du tableau en une image en couleur
    colorImage.loadPixels();
    j = 0;
    for (i = 0; i < colorMap.length; i+=4) {  
      //int BB = (int) (colorMap[i]&0x0000FF);
      //int GG = (int) (colorMap[i+1]&0x0000FF);
      //int RR = (int) (colorMap[i+2]&0x0000FF);
      //colorImage.pixels[j] = color(RR, GG, BB); 
      colorImage.pixels[j] = (colorMap[i+2]&0x0000FF)<<16 |
        (colorMap[i+1]&0x0000FF)<<8  |
        (colorMap[i]&0x0000FF);
      j++;
    }
    colorImage.updatePixels();
  }
  image(colorImage, 0, 0);
  
    for (i=0; i<sMax; i++) {
    if (s[i]!=null) { // Des donnees sont disponibles
      if (s[i].isTracked()==true && handAvail(i)==true) {
        imDraw(i);
      }
    }
  }
}
  
  boolean handAvail(int userID){
    if (s[userID].isJointTracked(Skeleton.HAND_RIGHT) == true && s[userID].isJointTracked(Skeleton.HAND_LEFT) == true){
      return true;
    }
    else{
      return false;
    }
  }
  
  void imDraw(int userID){
    int[] lHand, rHand;
    lHand = s[userID].get2DJoint(Skeleton.HAND_LEFT, width, height);
    rHand = s[userID].get2DJoint(Skeleton.HAND_RIGHT, width, height);
    int hauteur = rHand[1] - lHand[1];
    int largeur = abs(rHand[0] - lHand[0]);
    if (hauteur > 100 || largeur > 100){
      if (lHand[0] < rHand[0]){
        image(ImIncr[currIm], lHand[0], lHand[1], largeur, hauteur);
      }
      else if (lHand[1] > rHand[1]){
        image(ImIncr[currIm], rHand[0], rHand[1], largeur, hauteur);
      }else{
         image(ImIncr[currIm], rHand[0], lHand[1], largeur, hauteur);
      }
      modif = 0;
    }
    else if (modif == 0){
      currIm = (currIm + 1) % 4;
      modif = 1;
    }
  }
