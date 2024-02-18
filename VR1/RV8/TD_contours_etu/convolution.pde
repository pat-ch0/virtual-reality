//************************************************************************
//***** Calcul de la combinaison linéaire avec les coefficient du masque *
//***** à la position x y dans l'image, sur la luminance uniquement ******
float apply_kernel_lum(int x, int y, float[][] kernel, PImage img)
{
  float lum = 0.0;
  int kernel_size = kernel.length;
  int m = kernel_size / 2;
  // Parcours du masque
  for (int i = 0; i < kernel_size; i++){
    for (int j= 0; j < kernel_size; j++){
      int xloc = x+i-m;
      int yloc = y+j-m;
      // Contraint la valeur dans les bornes de l'image
      xloc = constrain(xloc,0,img.width-1);
      yloc = constrain(yloc,0,img.height-1);
      //Calcul de l'indice linéaire du pixel
      int loc = xloc + img.width*yloc;
      // Calcul de la multiplication avec le masque 
      lum += (brightness(img.pixels[loc]) * kernel[i][j]);
    }
  }
  // Renvoie la valeur résultante
  return lum;
}
//**********************************************************************
// Convolution d'une image par un masque (kernel)
void image_convolution(PImage img, float[][] kernel, PImage resultat)
{  
  int kernel_size = kernel.length;
  int m = kernel_size/2;
  float lum = 0.0;
  // Parcours de l'image
  for (int y = 0; y < img.height; y++) { 
    for (int x = 0; x < img.width; x++) { 
      // Parcours du masque
      lum = 0;
      for (int i = 0; i < kernel_size; i++){
        for (int j= 0; j < kernel_size; j++){
          int xloc = x+i-m;
          int yloc = y+j-m;
          // Contraint la valeur dans les bornes de l'image
          xloc = constrain(xloc,0,img.width-1);
          yloc = constrain(yloc,0,img.height-1);
          int indice = xloc + img.width*yloc;
          lum += brightness(img.pixels[indice])*kernel[i][j];
          resultat.pixels[x + img.width*y]=color(lum);   
        }
      }
    }
  }
}
