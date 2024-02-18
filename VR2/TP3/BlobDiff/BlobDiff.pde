PImage image1;
PImage image2;
PImage differenceImg; // Image difference  = image1 - image2
int nbPixels;         // Nombre de pixels dans l'image (1)

// Variables pour comparaison des pixels des images
color pixelImg1=0;
color pixelImg2=0;

// Difference des couleurs des deux pixels
int diffPixel=0;  // total
int diffPixelR=0; // par composante
int diffPixelG=0;
int diffPixelB=0;

int i; // index pour les boucles
int loc;
float seuil = 45;
float bary = 0;
int blanc = 0;
int x, y, baryX, baryY;
int yPos;

void setup() {
  size(298, 412);
  image1 = loadImage("Image1_Joconde.jpg");
  image2 = loadImage("Image2_Joconde.jpg");

  //println("Taille image 1 = " + image1.width + " x "+image1.height);
  //println("Taille image 2 = " + image2.width + " x "+image2.height);
  nbPixels = image1.width * image1.height;
  differenceImg = createImage(image1.width, image1.height, RGB);
}

void draw() {
  differenceImg.loadPixels();
  image1.loadPixels();
  image2.loadPixels();
  baryX = 0;
  baryY = 0;
  blanc = 0;

  for (y = 0; y < height; y++) { // traitement sur tous les pixels
    yPos = y * width;
    for (x = 0; x < width; x++){
      i = yPos + x;
      pixelImg1 = image1.pixels[i];
      pixelImg2 = image2.pixels[i];
  
      // Calcul des differences sur les 3 composantes couleur : R, G et B
      diffPixelR = abs(((pixelImg1 >> 16) & 0xFF) - ((pixelImg2 >> 16) & 0xFF));
      // Equivalent a :  abs( red(pixelImg1) - red(pixelImg2) )
      diffPixelG = abs(((pixelImg1 >> 8) & 0xFF) - ((pixelImg2 >> 8) & 0xFF));
      diffPixelB = abs((pixelImg1 & 0xFF) - (pixelImg2 & 0xFF));
      diffPixel = diffPixelR + diffPixelG + diffPixelB;
      //differenceImg.pixels[i] = color(diffPixel, diffPixel, diffPixel); // en niveaux de gris
      //differenceImg.pixels[i] = color(diffPixelR, diffPixelG, diffPixelB); // en couleur
      differenceImg.pixels[i] = (diffPixel > seuil) ? color(255) : color(0);
      if (color(255) == differenceImg.pixels[i]){
        baryX += x;
        baryY += y;
        blanc++;
      }
    }
  }
  x = baryX/blanc;
  y = baryY/blanc;
  fill(255, 0, 0);
  circle(x, y, 15);
  noFill();
  differenceImg.updatePixels();
  image1.updatePixels();
  image2.updatePixels();
  image(differenceImg, 0, 0);
}

  void mouseWheel(MouseEvent event) {
    seuil += 5*event.getCount();
    seuil = (seuil < 0) ? 0 : seuil;
    seuil = (seuil > 765) ? 765 : seuil;
  }
