/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 16 : Creation basique d'une image anaglyphe pour        */
/*                       filtre Rouge/Cyan                                  */
/*                                                                          */
/* Exemple_16_Image_Anaglyphe.pde                      Processing 3.5.4     */
/****************************************************************************/

// Images de base et combinaison Anaglyphe
PImage photo_G;
PImage photo_D;
PImage Anaglyphe;

int i; // Indice des boucles
int x, y; // Indices de parcours
int yDebutLigne; 

color pixelImgG; 
color pixelImgD; 
int Rg, Gg, Bg; // Vue gauche
int Rd, Gd, Bd; // Vue droite
float Ra, Ga, Ba; // Anaglyphe

void setup () {
  size(500, 500);
  // Dans cet exemple, les images sont carrees, d'environ 500 pixels de cote
  photo_G = loadImage("photo_G.jpg");
  photo_D = loadImage("photo_D.jpg");
  photo_G.resize(500, 500); // Redimensionnement garantissant la taille finale
  photo_D.resize(500, 500);

  Anaglyphe = createImage(500, 500, RGB);

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

  image(Anaglyphe, 0, 0);
}

void draw () {
}
