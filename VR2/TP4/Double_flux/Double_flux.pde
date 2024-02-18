import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect

PKinect kinect;   // Declaration de la Kinect

short[] depthMap;   // Carte des profondeurs = flux "DEPTH"
PImage  depthImage; // Image equivalente aux profondeurs, en niveaux de gris
int depthW = 0;     // Largeur de l'image Depth
int depthH = 0;     // Hauteur de l'image Depth

byte[] colorMap;    // Carte des valeurs des couleurs = Flux "COLOR"
PImage  colorImage; // Image RGB reconstruite equivalente
int colorW = 0;     // Largeur de l'image RGB
int colorH = 0;     // Hauteur de l'image RGB


void setup() {
  size(1280, 480);
  surface.setTitle("Kinect Depth et RGB");
  surface.setResizable(true);
  colorMode(RGB, 255, 255, 255);
  kinect = new PKinect(this);

  if (kinect.start(PKinect.DEPTH | PKinect.COLOR) == false) {
    println("Pas de kinect connectee !"); 
    exit(); return;
  } else if (kinect.isInitialized()) {
    print("Kinect de type : " + kinect.getDeviceType());
    println(" initialisee avec : ");
    depthW = kinect.getDepthWidth();
    depthH = kinect.getDepthHeight();
    println("  * Largeur image profondeur : " + depthW);
    println("  * Hauteur image profondeur : " + depthH);
    colorW = kinect.getColorWidth();
    colorH = kinect.getColorHeight();
    println("  * Largeur image couleur : " + colorW);
    println("  * Hauteur image couleur : " + colorH);
  } else { 
    println("Probleme d'initialisation de la kinect");
    exit(); return;
  }

  // Creation des objets Depth
  depthMap = new short[depthW*depthH];
  depthImage = createImage(depthW, depthH, RGB);
  // Creation des objets Color
  colorMap = new byte[colorW*colorH*4];
  colorImage = createImage(colorW, colorH, RGB);
}

void draw() { 
  int i, j; // Indices des boucles
  int ValZ; // Composante distance Z pour le point considere
  int mini, maxi; // Valeur Z mini non nulle et maximum

   depthMap = kinect.getDepthFrame();
   colorMap = kinect.getColorFrame();

  // Traitement du Flux "DEPTH"
  if (depthMap!=null && colorMap!=null) {
    // Recherche des profondeurs mini et maxi 
    maxi = 0; 
    mini = 100000;
    for (i=0; (i < depthH*depthW); i++) {
      if (mini>depthMap[i]) { 
        mini = depthMap[i];
      } else if (maxi < depthMap[i]) {
        maxi = depthMap[i];
      }
    }

    // Conversion du tableau en une image de profondeur
    depthImage.loadPixels();
    for (i = 0; i < depthH*depthW; i++) {
      if (depthMap[i] == 0) {
        // Point trop proche, traitement particulier 
        depthImage.pixels[i] = 0;  // en Noir !
        // ou bien, distance neutre : color(128, 128, 128);
      } else {
        // Valeur proportionnelle, variant de 0 a 255
        ValZ = (int) map((float)depthMap[i], mini, maxi, 255, 0);
        depthImage.pixels[i] = color(ValZ, ValZ, ValZ); // En gris
      }
    }
    
    colorImage.loadPixels();
    j = 0;
    for (i = 0; i < colorMap.length; i+=4) {  
      //int BB = (int) (colorMap[i]&0x0000FF);
      //int GG = (int) (colorMap[i+1]&0x0000FF);
      //int RR = (int) (colorMap[i+2]&0x0000FF);
      //colorImage.pixels[j] = color(RR, GG, BB); 
      colorImage.pixels[j] = (colorMap[i+2]&0x0000FF)<<16 | (colorMap[i+1]&0x0000FF)<<8 | (colorMap[i]&0x0000FF);
      j++;
    }
    depthImage.updatePixels();
    colorImage.updatePixels();
  }

  // Affichage de l'image de profondeur
  // image(depthImage, 0, 0); // en taille "normale", donc 320*240
  image(depthImage, width/2, 0, width/2, height); // en plein ecran
  image(colorImage, 0, 0 , width/2, height);
}
