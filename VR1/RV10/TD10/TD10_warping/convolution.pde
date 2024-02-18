//***************************************************************
//***** Convolution en x y, sur les trois canaux de couleur *****
color apply_kernel_rgb(int x, int y, float[][] kernel, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
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
      // Calcul de la multiplication avec le masque sur chaque canal
      rtotal += (red(img.pixels[loc]) * kernel[i][j]);
      gtotal += (green(img.pixels[loc]) * kernel[i][j]);
      btotal += (blue(img.pixels[loc]) * kernel[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Renvoie la couleur résultante
  return color(rtotal, gtotal, btotal);
}


//***********************************************************
//***** Convolution en x y, sur la luminance uniquement *****
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
  // Parcours de l'image
  for (int y = 0; y < img.height; y++) { 
    for (int x = 0; x < img.width; x++) { 
      float lum = apply_kernel_lum(x,y, kernel, img);
      resultat.pixels[x + img.width*y]=color(lum);
    }
  }
}
