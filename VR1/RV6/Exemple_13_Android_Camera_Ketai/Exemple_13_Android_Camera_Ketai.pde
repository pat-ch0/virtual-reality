/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*        Utilisation d'une des cameras (avec Ketai) sous Android           */
/*  infos supplementaires : http://ketai.org/reference/camera/ketaicamera/  */
/*                                                                          */
/* Exemple_13_Android_Camera_Ketai.pde         Processing 3.5.4 - ANDROID   */
/****************************************************************************/

// Import bibliotheques
import ketai.camera.*;

// Declaration des variables globales
KetaiCamera cam; // Camera
int nbCamera;
Boolean plusieursCamera;
PImage ImageCourante;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  fullScreen(P2D);
  orientation(LANDSCAPE); // Forcage du mode

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
}

void draw() {
  if (cam != null && cam.isStarted()) {
    // La camera fonctionne correctement
    image(cam, width/2, height/2, width, height); // restitution en plein ecran, centree
  } else {
    // Elle est eteinte (ou absente...)
    background(#D16363);
    text("!! Camera eteinte !!", width/2, height/2);
  }
  // Ajout des boutons
  affichageBoutons();
}

void onCameraPreviewEvent() {
  cam.read(); // Lecture d'une image
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
}
