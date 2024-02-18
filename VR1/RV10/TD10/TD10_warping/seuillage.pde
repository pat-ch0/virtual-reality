//**********************************************************************
// Seuillage simple
void seuillage(PImage img, PImage imgSeuillee, int seuil){
  int loc = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Pixel courant
      loc = x + y*img.width;
      color pix = img.pixels[loc];
      if (brightness(pix) > seuil) {
        imgSeuillee.pixels[loc] = color(255);
      } else {
        imgSeuillee.pixels[loc] = color(0);
      }      
    }
  }
}


//**********************************************************************
// Seuillage hysteresis
void seuillage(PImage img, PImage imgSeuillee, int s_bas, int s_haut) {
  int loc = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Pixel courant
      loc = x + y*img.width;
      color pix = img.pixels[loc];
      imgSeuillee.pixels[loc] = color(0);
      if (brightness(pix) > s_haut) {
        imgSeuillee.pixels[loc] = color(255);
      } else if (brightness(pix) > s_bas) {
        imgSeuillee.pixels[loc] = color(127);
      }
    }
  }   
  // Iterations jusqu'à ne plus avoir de sélection parmi les pixels indécis
  boolean done = false;
  while (done == false) {
    done = true;
    for (int x = 1; x < img.width-1; x++) {
      for (int y = 1; y < img.height-1; y++ ) {
        // Pixel location and color
        loc = x + y*imgSeuillee.width;
        color pix = imgSeuillee.pixels[loc];
        if (pix ==  color(127)) {//contour possible
          imgSeuillee.pixels[loc] = color(0);
          for (int k = -1; k<2; k++) {
            for (int l = -1; l<1+1; l++) {
              if (imgSeuillee.pixels[x+k + (y+l)*imgSeuillee.width]==color(255)) {
                imgSeuillee.pixels[loc] = color(255);
                done = false;
              }
            }
          }
        }
      }
    }
  }
}
