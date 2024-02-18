import processing.video.*; // Bibliotheque de controle camera

Capture webCam;      // Declaration de la Capture par Camera
String[] cameras;    // Liste textuelle des webCams disponibles
PImage webCamMirror;

int Y,x,y;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(1280, 480);

  surface.setTitle("Miroir magique");

  // Recherche des webCams disponibles, par interrogation du systeme d'exploitation
  cameras = Capture.list(); 

  if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    printArray(cameras); 
    
    webCam = new Capture(this, 640, 480); // Webcam; valeurs par defaut
    webCamMirror = createImage(640,480,RGB);
    webCam.start(); // Mise en marche de la webCam
  }
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
    webCamMirror.loadPixels();
    
    for(y = 0; y < webCam.height; y++){
      Y = y*webCam.width;
      for(x = 0; x < webCam.width; x++){
        webCamMirror.pixels[Y + webCam.width - 1 - x] = webCam.pixels[Y + x];
      }  
    }
    webCamMirror.updatePixels();
    image(webCamMirror, 0, 0);
    image(webCam, 640, 0);
  }
}

void keyPressed() {
  println(frameRate);
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.stop(); // Arret "propre" de la webcam
  super.exit();
}
