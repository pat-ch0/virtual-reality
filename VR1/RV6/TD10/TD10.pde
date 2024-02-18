import ketai.camera.*;
import ketai.sensors.*;
import jp.nyatla.nyar4psg.*;

// Declaration des variables globales
KetaiCamera cam; // Camera
int nbCamera;
Boolean plusieursCamera;
KetaiSensor sensor;
PImage ImageCourante;
PShape objetOBJ;        // Objet a charger
float dimOBJ_X, dimOBJ_Y, dimOBJ_Z; // Dimensions de l'objet
boolean refreshCam ;
MultiMarker sceneMM;
float accelerometerX, accelerometerY, accelerometerZ;

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
int i, j;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  fullScreen(P3D);
  orientation(LANDSCAPE); // Forcage du mode
  objetOBJ = loadShape("Dog_Isima.obj");
  float facteurEchelle;
  sensor = new KetaiSensor(this);
  sensor.start();

  // Gestion du mode d'affichage
  imageMode(CENTER); // Mode centre pour garantir que l’image sera visible
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 25); // Parametrage de la police pour etre lisible

  // Ouverture du systeme de gestion des cameras a 24 fps 
  cam = new KetaiCamera(this, 1280, 720, 60);
  if (cam != null) {
    nbCamera = cam.getNumberOfCameras();
    plusieursCamera = (nbCamera>1);
  }
  
  sceneMM = new MultiMarker(this,1280, 720,
  "camera_para.dat",
  NyAR4PsgConfig.CONFIG_PSG);
  sceneMM.addARMarker("Marqueur_ISIMA.patt", 80);
  
  
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
}

void draw() {
  if (cam != null && cam.isStarted()) {
    if(refreshCam){
      // La camera fonctionne correctement
      sceneMM.detect(cam);
      image(cam, width/2, height/2, width, height); // restitution en plein ecran, centree
    
      if (sceneMM.isExist(0)) {
        sceneMM.beginTransform(0);
        translate(0, 0, 40); // Placement du cube au dessus du marqueur (et pas a mi-distance)
        lights(); // avec un peu de lumiere !
        shape(objetOBJ);
        sceneMM.endTransform();
      }
      refreshCam =false;
    }
  } else {
    // Elle est eteinte (ou absente...)
    background(#D16363);
    text("!! Camera eteinte !!", width/2, height/2);
  }
  // Ajout des boutons
  affichageBoutons();
}

void onAccelerometerEvent(float x, float y, float z) {
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

void onCameraPreviewEvent() {
  cam.read(); // Lecture d'une image
  refreshCam = true;
}

void mousePressed() {
  // Analyse des boutons appuyes

  if (mouseY < 100) {
    // On ne regarde que dans le bandeau Haut
    
    if (mouseX < width/3) {
      // Premier tiers : Camera on/off
      if (cam.isStarted()) {
        cam.stop();
      } else {
        cam.start();
      }
      
    } else if (plusieursCamera && (mouseX > width/3) && (mouseX < 2*width/3)) {
      // Second tiers : changement de camera
      cam.setCameraID((cam.getCameraID() + 1 ) % nbCamera);
      
    } else if (mouseX > 2*width/3) {
      // Dernier tiers :  Flash Camera on/off
      if (cam.isFlashEnabled()) {
        cam.disableFlash();
      } else {
        cam.enableFlash();
      }
    }
  }
}

void mouseDragged() {
  objetOBJ.rotateX((pmouseY-mouseY) /100.0);
  objetOBJ.rotateY((mouseX-pmouseX) /100.0);
}

void affichageBoutons() { // Affichage de l'interface utilisateur
  pushStyle(); // Conservation du style d'ecriture
  textAlign(LEFT);
  fill(0);
  stroke(255);

  // Dessin des boutons
  rect(0, 0, width/3, 100);
  if (plusieursCamera) {
    rect(width/3, 0, width/3, 100);
  }
  rect((width/3)*2, 0, width/3, 100);

  // Affichage des textes sur les boutons
  fill(255);
  if (cam.isStarted()) {
    text("Camera Off", 5, 80);
  } else {
    text("Camera On", 5, 80);
  }

  if (plusieursCamera) {
    text("Switch Camera", width/3 + 5, 80);
  }

  if (cam.isFlashEnabled()) {
    text("Flash Off", width/3*2 + 5, 80);
  } else {
    text("Flash On", width/3*2 + 5, 80);
  }
  popStyle();
  text("X : " + accelerometerX, 10, height - (displayDensity * 25+20)*2 + displayDensity * 25);
}
