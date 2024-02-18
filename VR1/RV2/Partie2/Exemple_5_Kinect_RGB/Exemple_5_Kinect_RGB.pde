/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 5 : Utilisation de la Kinect en mode RGB                */
/*                                                                          */
/* Exemple_5_Kinect_RGB.pde                            Processing 3.5.2     */
/****************************************************************************/

// Importation des librairies
import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect

// Declaration des variables globales
PKinect kinect;   // Declaration de la Kinect

byte[] colorMap;    // Carte des valeurs des couleurs = Flux "COLOR"
PImage  colorImage; // Image RGB reconstruite equivalente
int colorW = 0;     // Largeur de l'image RGB
int colorH = 0;     // Hauteur de l'image RGB


// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480);
  surface.setTitle("Exemple 5 - La Kinect en RGB - E. Mesnard / ISIMA");
  colorMode(RGB, 255, 255, 255); // fixe format couleur R G B
 
  // Initialisation Objet Kinect
  kinect = new PKinect(this);

  // Ouverture du flux "COLOR" 
  if (kinect.start(PKinect.COLOR) == false) {
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
  int i, j; // Indices des boucles

  // Recuperation d'eventuelles donnees sur la kinect...
  colorMap = kinect.getColorFrame();

  // Traitement du Flux "COLOR"
  // **************************
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

  // Effacement de la fenetre (optionnel)
  // background(0);

  // Affichage de l'image RGB
  image(colorImage, 0, 0);
}