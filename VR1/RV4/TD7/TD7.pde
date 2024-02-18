import processing.video.*;     // Bibliotheque de controle camera
import jp.nyatla.nyar4psg.*;   // ARToolKit (version 3.0.7)

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Camera 
MultiNft sceneNft;

PShape objetOBJ;        // Objet a charger
PShape boundingBoxOBJ;  // Boite englobante
float dimOBJ_X, dimOBJ_Y, dimOBJ_Z; // Dimensions de l'objet

boolean traceBB_OBJ; // Flag pour le trace de la bounding box

// Analyse complementaire pour determiner la position du repere dans l'objet
PShape partieObj; // Analyse de l'objet par morceaux (enfants dans un objet)
int nombreEnfant;
int nombreVertex, nombreVertexTotal; // Nombres de Vertex
// Amplitudes de l'objet, initialisees aux extremes opposes
float minX = 3.40282347E+38; // min et max sur les 3 dimensions
float minY = 3.40282347E+38;
float minZ = 3.40282347E+38;
float maxX = -3.40282347E+38;
float maxY = -3.40282347E+38;
float maxZ = -3.40282347E+38;
// Coordonnees du vertex en cours de traitement
float vX, vY, vZ;
// Decalage a appliquer pour positionner correctement l'objet
float decX, decY, decZ;

// Indices des boucles
int i, j;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  float facteurEchelle; // Mise a l'echelle pour un meilleur rendu
  // Initialisation des parametres graphiques utilises
  size(640, 480, P3D); // ouverture en mode 3D
  surface.setTitle("Exemple 8 - RA Cube - E. Mesnard / ISIMA");
  objetOBJ = loadShape("Robik.obj");
  strokeWeight(3); // Epaisseur du trait
  stroke(#EA0C7B); // Couleur pourtour par defaut : rose violace
  noFill(); // Sans remplissage

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

  // Declaration de la scene de recherche avec parametres par defaut :
  // calibration de camera et systeme de coordonnees
  sceneNft= new MultiNft(this,
  widthCapture, heightCapture,
  "camera_para.dat",
  NyAR4PsgConfig.CONFIG_PSG);
  
  nombreVertex = objetOBJ.getVertexCount();
  nombreVertexTotal = nombreVertex;
  if (nombreVertex>0) {
    for (i=0; i<nombreVertex; i++) {
      vX = objetOBJ.getVertexX(i);
      vY = objetOBJ.getVertexY(i);
      vZ = objetOBJ.getVertexZ(i);
      if (vX<minX) minX=vX; 
      else if (vX>maxX) maxX=vX; 
      if (vY<minY) minY=vY; 
      else if (vY>maxY) maxY=vY; 
      if (vZ<minZ) minZ=vZ; 
      else if (vZ>maxZ) maxZ=vZ;
    }
  } 

  nombreEnfant = objetOBJ.getChildCount();
  //println("Nombre d'enfants : "+nombreEnfant);
  if (nombreEnfant>0) {
    for (i=0; i<nombreEnfant; i++) {
      // Analyse pour chaque enfant
      partieObj = objetOBJ.getChild(i);
      nombreVertex = partieObj.getVertexCount();
      nombreVertexTotal +=nombreVertex;
      if (nombreVertex>0) {
        for (j=0; j<nombreVertex; j++) {
          vX = partieObj.getVertexX(j);
          vY = partieObj.getVertexY(j);
          vZ = partieObj.getVertexZ(j);
          if (vX<minX) minX=vX; 
          else if (vX>maxX) maxX=vX; 
          if (vY<minY) minY=vY; 
          else if (vY>maxY) maxY=vY; 
          if (vZ<minZ) minZ=vZ; 
          else if (vZ>maxZ) maxZ=vZ;
        }
      }
    }
  }
  
  dimOBJ_X = maxX-minX;  // dimOBJ_X = objetOBJ.getWidth();
  dimOBJ_Y = maxY-minY;  // dimOBJ_Y = objetOBJ.getHeight();
  dimOBJ_Z = maxZ-minZ;  // dimOBJ_Z = objetOBJ.getDepth();
  decX = -minX - dimOBJ_X/2.0f;
  decY = -minY - dimOBJ_Y/2.0f;
  decZ = -minZ - dimOBJ_Z/2.0f;
  
  facteurEchelle = min(width/(10*dimOBJ_X), height/(10*dimOBJ_Y), width/(10*dimOBJ_Z));
  objetOBJ.scale(facteurEchelle);
  
  dimOBJ_X *= facteurEchelle;
  dimOBJ_Y *= facteurEchelle;
  dimOBJ_Z *= facteurEchelle;
  decX*= facteurEchelle;
  decY*= facteurEchelle;
  decZ*= facteurEchelle;
  
    objetOBJ.translate(decX, decY, decZ);

  // Declaration du marqueur a rechercher, avec sa dimension en mm
  sceneNft.addNftTarget("NFTsega",80);
  println(MultiMarker.VERSION); // Affichage numero version en console
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame

    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame

    sceneNft.detect(webCam);   // Recherche du marqueur dans la scene
    webCam.updatePixels();    // Mise a jour des pixels
    
    // Effacer la fenetre avant de dessiner l'image video "reelle"
    background(0); 
    image(webCam, 0, 0);  // Affiche l'image prise par la webCam

    // Incrustation de l'image virtuelle si marqueur trouve
   if (sceneNft.isExist(0)) { // Marqueur ISIMA
      // Le marqueur est detecte dans le flux video
      // Changement de repere pour tracer en coordonnees "Marqueur"
      sceneNft.beginTransform(0); // Modification graphique sur marqueur 0
      // trace d'un rectangle 2D : rect(-40,-40,80,80);
      // ... ou mieux, trace d'un cube 3D :
      translate(0, 0, 40); // Placement du cube au dessus du marqueur (et pas a mi-distance)
      lights(); // avec un peu de lumiere !
      shape(objetOBJ);
      sceneNft.endTransform();
    }
  }
}
