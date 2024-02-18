// Images de base et combinaison Anaglyphe
PImage photo;
PImage photo_G;
PImage photo_D;
PImage Anaglyphe;

int i; // Indice des boucles
int x, y; // Indices de parcours
int yDebutLigne;
int ligne;
boolean inverse = false;
boolean cercle = false;
boolean ana = false;
int photoW, photoH;

color pixelImgG; 
color pixelImgD; 
int Rg, Gg, Bg; // Vue gauche
int Rd, Gd, Bd; // Vue droite
float Ra, Ga, Ba; // Anaglyphe

void setup () {
  size(1900, 1900);
  photo = loadImage("building.jpg");
  photoW = photo.width;
  photoH = photo.height;
  photo_G = createImage(photoW/2, photoH, RGB);
  photo_D = createImage(photoW/2, photoH, RGB);

  //Vision libre
  ligne = -1;
  photo_G.loadPixels();
  photo_D.loadPixels();
  for (y = 0; y < photoH; y++) {
    yDebutLigne = y * photoW;
    ligne += 1;
    for (x = 0; x < photoW; x++) {
      i = yDebutLigne + x;
      if (x < photoW/2) {
        photo_G.pixels[i - photoW/2 * ligne] = photo.pixels[i];
      } else {
        photo_D.pixels[i - (photoW/2) * (ligne+1)] = photo.pixels[i];
      }
    }
  }
  photo_G.updatePixels();
  photo_D.updatePixels();

  //Anaglyphe
  Anaglyphe = createImage(photoW/2, photoH, RGB);
  photo_D.loadPixels();
  photo_G.loadPixels();
  Anaglyphe.loadPixels();
  for (y = 0; y < Anaglyphe.height; y++) { // lignes y
    yDebutLigne = y * Anaglyphe.width;
    for (x = 0; x < Anaglyphe.width; x++) { // colonnes x
      i = yDebutLigne + x;
      pixelImgG = photo_G.pixels[i];
      pixelImgD = photo_D.pixels[i];

      // Extractions des 3 composantes couleur : R, G et B pour les deux images
      Rg = (pixelImgG >> 16) & 0xFF; // ou red(pixelImgG)
      Gg = (pixelImgG >> 8) & 0xFF; // inutile
      Bg = pixelImgG & 0xFF; // inutile

      Rd = (pixelImgD >> 16) & 0xFF; // inutile
      Gd = (pixelImgD >> 8) & 0xFF;
      Bd = pixelImgD & 0xFF;

      Ra = Rg;
      Ga = Gd;
      Ba = Bd;

      Anaglyphe.pixels[i] = color(Ra, Ga, Ba);
    }
  }
  photo_D.updatePixels();
  photo_G.updatePixels();
  Anaglyphe.updatePixels();
}

void draw () {
  background(0);
  if (inverse) {
    image(photo_D, 0, 0);
    image(photo_G, width/2, 0);
  } else {
    if (ana) {
      background(0);
      image(Anaglyphe, width/4, 0);
    } else {
      image(photo_G, 0, 0);
      image(photo_D, width/2, 0);
    }
  }

  if (cercle) {
    fill(0, 0, 255);
    ellipse(photoW/2, photoH/2, 20, 20);
    ellipse(photoW/2 + width/2, photoH/2, 20, 20);
  }
}

void keyPressed() {
  if (key == 'i') {
    inverse = !inverse;
  } else if (key == 'c') {
    cercle = !cercle;
  } else if (key == 'a') {
    ana = !ana;
    inverse = false;
  }
}
