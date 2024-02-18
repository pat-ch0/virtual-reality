/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 12 : Realite Augmentee par ARtoolkit et Webcam          */
/*                       avec marqueur de type Pattern                      */
/*                       Un appui sur une touche passe de la Realite        */
/*                       Enrichie 2D a la Realite Augmentee spatiale 3D     */         
/*                                                                          */
/*                       Webcam via le mode "Capture" basee sur GStreamer   */
/*                                                                          */
/* Exemple_12_Realite_Augmentee.pde                    Processing 3.5.4     */
/****************************************************************************/

// Importation des librairies
import jp.nyatla.nyar4psg.*;   // ARToolKit (version 3.0.7)

import processing.video.*;     // Bibliotheque de controle camera

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
Capture webCam;      // Declaration de la Capture par Camera
String[] cameras;    // Liste textuelle des webCams disponibles

MultiMarker sceneMM; // Scene de recherche de "multi-marqueur"
boolean RE2D_RA3D;   // Choix du mode : Realite Enrichie 2D, ou Realite Augmentee 3D

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640, 480, P3D); // ouverture en mode 3D (ou 2D, car selection du mode par RE2D_RA3D)
  surface.setTitle("Exemple 12 - Realite Augmentee - E. Mesnard / ISIMA");
  noFill();
  stroke(#E802B7); // Couleur violacee
  strokeWeight(1);

  // Recherche des webCams disponibles, par interrogation du systeme d'exploitation
  cameras = Capture.list(); 
  if (cameras==null) {
    // Le systeme d'exploitation n'a pas repondu
    // Tentative d'ouverture d'une webcam par defaut
    webCam= new Capture(this, 640, 480);
    webCam.start(); // Mise en marche de la webCam
  } else if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Choix explicite de la derniere camera de la liste :
    webCam = new Capture(this, cameras[cameras.length-1]);
    webCam.start(); // Mise en marche de la webCam
  }

  // Declaration de la scene de recherche avec parametres par defaut :
  // calibration de camera et systeme de coordonnees
  sceneMM = new MultiMarker(this, widthCapture, heightCapture, 
    "camera_para.dat", 
    NyAR4PsgConfig.CONFIG_PSG);

  // Declaration du marqueur a rechercher, avec sa dimension en mm
  sceneMM.addARMarker("Marqueur_Kanji.patt", 80); // Marqueur numero 0
  println(MultiMarker.VERSION); // Affichage numero version en console
  
  RE2D_RA3D = true; // Mode RE par defaut
  println("Mode Réalité Enrichie, avec informations en coordonnées Image");
  println("    Appuyer sur une touche pour changer de mode");
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame

    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame

    sceneMM.detect(webCam);   // Recherche du marqueur dans la scene
    webCam.updatePixels();    // Mise a jour des pixels

    image(webCam, 0, 0);  // Affiche l'image prise par la webCam

    // Incrustation de l'image virtuelle si marqueur trouve
    if (sceneMM.isExist(0)) { 
      // Le marqueur 0 est effectivement detecte dans le flux video
      if (RE2D_RA3D) {
        // Version 1 : trace d'informations basiques a l'ecran
        V1_RE_en_Coordonnees_Image();
      } else {
        // Version 2 : trace d'un cube 3D
        V2_RA_en_Coordonnees_Marqueur();
      }
    }
  }
}


void V1_RE_en_Coordonnees_Image() {
  PVector[] pos2d; // Position 2D du marqueur dans le repere Image
  String s; // Chaine de caracteres a afficher
  int i; // Indice de boucle pour traitement sur les 4 coins

  // Lecture du vecteur position
  pos2d = sceneMM.getMarkerVertex2D(0);

  // Trace du pourtour du marqueur
  stroke(#E802B7); // Couleur violacee
  strokeWeight(2);
  line(pos2d[0].x, pos2d[0].y, pos2d[1].x, pos2d[1].y);
  line(pos2d[2].x, pos2d[2].y, pos2d[1].x, pos2d[1].y);
  line(pos2d[2].x, pos2d[2].y, pos2d[3].x, pos2d[3].y);
  line(pos2d[0].x, pos2d[0].y, pos2d[3].x, pos2d[3].y);

  for (i=0; i<pos2d.length; i++) { // Pour les 4 coins..., car pos2d.length doit etre egal a 4
    // Trace des 4 points 2D, aux 4 coins du marqueur
    fill(#F70A36); // Couleur rouge assez vif
    noStroke();
    ellipse(pos2d[i].x, pos2d[i].y, 20, 20);

    // Trace des 4 étiquettes
    // Creation de la chaine, et ecriture en noir sur fond azur
    s = "(" + int(pos2d[i].x) + "," + int(pos2d[i].y) + ")";
    strokeWeight(1);
    stroke(#0B7CAF); 
    fill(#0B7CAF); // Couleur bleutee
    rect(pos2d[i].x, pos2d[i].y, textWidth(s)+6, textAscent()+textDescent()+3);
    fill(0);
    text(s, pos2d[i].x + 5, pos2d[i].y + textAscent()+2); // Ecriture effective sur l’image
  }
}

void V2_RA_en_Coordonnees_Marqueur() {
  // Changement de repere pour tracer en coordonnees "Marqueur"
  sceneMM.beginTransform(0); // Modification graphique sur marqueur 0
  // Ce beginTransform provoque le changement de repere dans Processing
  // Toutes les commandes de traces se feront
  // par rapport au nouveau système de coordonnees

  strokeWeight(2); // Trait epais
  stroke(#E802B7); // Couleur violacee
  noFill(); // Sans remplissage
  // Dessin en mode 3D : ici, un cube de 80mm
  translate(0, 0, 40); // Placement du cube au dessus
  // du marqueur, donc Z=40mm
  box(80, 80, 80);     // Cube de 8 cm de cote
  sceneMM.endTransform();
}

void keyPressed() {
  println(frameRate); // Affichage du nombre de "draw" a la seconde
  RE2D_RA3D = !RE2D_RA3D; // Changement de mode
  if (RE2D_RA3D) { 
    println("Mode Réalité Enrichie, avec informations en coordonnées Image");
  } else {
    println("Mode Réalité Augmentée, avec cube 3D en coordonnées Marqueur");
  }
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  if (0 != cameras.length) webCam.stop(); // Arret "propre" de la webcam
  super.exit();  // Re envoi de l'exit pour quitter reellement
}
