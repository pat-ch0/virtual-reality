import com.github.sarxos.webcam.*;   // Bibliotheque SARXOS de gestion webcam
import java.awt.image.BufferedImage; // Biblio pour conversion BufferedImage
import java.awt.Dimension;           // en PImage, a la bonne taille
import java.util.List;    // Pour recuperer la liste des webcams disponibles

Webcam webCam;            // Declaration de la webCam
List<Webcam> cameras ;    // Liste des webCams disponibles
BufferedImage BImgWebCam; // Image fournie par la webCam
PImage PImgWebCam, ImgSeuil;
int[][] SeuilVert={{-1}, {0}, {1}}, SeuilHori={{-1,0,1}};
float[] angle;

boolean seuilAffich = false;
int Seuil = 10;

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

void setup() {
  size(640, 480);
  surface.setTitle("j'suis seuillé");

  noFill(); // pas de remplissage
  stroke(#FF0000); // couleur Rouge pourtour - noStroke() si pas de pourtour
  colorMode(HSB, 360, 100, 100); // Passage en mode HSB pour Couleur avec teinte
  PImgWebCam = createImage(640, 480, RGB);
  cameras = Webcam.getWebcams();
  ImgSeuil = createImage(640, 480, HSB);
  angle = new float[widthCapture*heightCapture];

  if (cameras.isEmpty()) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Affichage console de la liste des webcams disponibles
    println("Voici toutes les webcams disponibles : " + cameras);
    
    int i=0;
    for (Webcam Cami : cameras) { // Analyse de toutes les cameras
      println("Webcam["+i+"] = " + Cami.getName());
      Dimension[] ResolutionsDispos = Cami.getViewSizes();   
      for (Dimension Resol : ResolutionsDispos) {
        println(Resol.getWidth()+" X "+Resol.getHeight());
      }
      i++;
    }

    webCam = Webcam.getDefault();
    Dimension ResolWebCam = new Dimension(640, 480);
    webCam.setViewSize(ResolWebCam);
    webCam.open(); // Mise en marche de la webCam (Ouverture effective du flux video)
  }
}


void draw() {
  if (webCam.isImageNew() && webCam.isOpen()) {
    BImgWebCam = webCam.getImage();
    BImgWebCam.getRGB(0, 0, 640, 480, PImgWebCam.pixels, 0, 640);
    PImgWebCam.updatePixels();
    
    if (seuilAffich){
      image(defContours(PImgWebCam, SeuilVert, SeuilHori, Seuil), 0, 0);
    }else{
      image(PImgWebCam, 0, 0);
    }
  }
}

void keyPressed() {
  println(frameRate);
  println(webCam.getFPS());
}

void mouseClicked(){
   seuilAffich = !seuilAffich; 
}

void exit() {
  println("ATTENTION : Le programme s'arrete, donc la webcam c'est ciao");
  webCam.close(); // Arret "propre" de la webcam
  super.exit();
}

PImage defContours(PImage PImgWebCam, int[][] SeuilVert, int[][] SeuilHori, int seuil){
  int xx, yy, yPos;
  PImgWebCam.updatePixels();
  ImgSeuil.updatePixels();
  for (yy = 1; yy < heightCapture-1; yy++) {
        yPos = yy * widthCapture; 
        for (xx = 1; xx < widthCapture-1; xx++) {
         int valV=0, valH=0, val = 0;
         for(int i=-1;i<2;i++){
           valV += int(brightness(PImgWebCam.pixels[(yy-i)*widthCapture+xx]) * SeuilVert[i+1][0]);
           valH += int(brightness(PImgWebCam.pixels[yPos+xx-i]) * SeuilHori[0][i+1]);
         }
         val = int(sqrt(valV*valV + valH*valH));
         ImgSeuil.pixels[yPos+xx] = color(0,0,val);
         angle[yy+xx] = atan2(valV,valH);
      }
    }
    return ImgSeuil;
}

PImage convolution(PImage ImgSeuil,float[] angle){
  int xx, yy, yPos;
  ImgSeuil.updatePixels();
  for (yy = 1; yy < heightCapture-1; yy++) {
        yPos = yy * widthCapture; 
        for (xx = 1; xx < widthCapture-1; xx++) {
          
          
        }
  }
  return ImgSeuil; 
}
