//**********************************************************************
// Calcul du gradient de Sobel
void compute_gradient_sobel(PImage img, PImage gradient) {
  float[][] filtreSobelH = { { -1, 0, 1 }, 
    { -2, 0, 2 }, 
    { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 }, 
    { 0, 0, 0 }, 
    { -1, -2, -1 } }; 
  float grad = 0;
  float gradH = 0;
  float gradV = 0;
  int loc = 0;

  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      gradV = 0; gradH = 0;      
      //Calcul du résultat de la convolution par les 2 masques :
      gradH = apply_kernel_lum(x, y, filtreSobelH, img);
      gradV = apply_kernel_lum(x, y, filtreSobelV, img);
      //Calcul de la norme du gradient :
      grad = sqrt(gradH*gradH+gradV*gradV); 
      
      //Stockage dans une PImage (valeur entre 0 et 255)
      loc = x + y*img.width;
      gradient.pixels[loc] = color(grad);
    }
  }
}

//*****************************************************************
// **************** Non max suppression ***************************
void compute_grad_nms(PImage img, PImage gradient, PImage resultat) {
 float[][] filtreSobelH = { { -1, 0, 1 }, 
    { -2, 0, 2 }, 
    { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 }, 
    { 0, 0, 0 }, 
    { -1, -2, -1 } }; 
  float grad = 0, theta = 0;
  int loc = 0;

  float maxgrad = 0;  
  float[] gradmag = new float[img.width*img.height];
  float[] gradangle = new float[img.width*img.height];
  
  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      float gradV = 0, gradH=0; 
      //Calcul du résultat de la convolution par les 2 masques :
      gradH = apply_kernel_lum(x, y, filtreSobelH, img);
      gradV = apply_kernel_lum(x, y, filtreSobelV, img);
      //Calcul de la norme du gradient :
      grad = sqrt(gradH*gradH+gradV*gradV); 
      if (grad>maxgrad) {
        maxgrad = grad;
      } 
      theta = atan2(gradV, gradH);
      loc = x + y*img.width;        
 
      gradmag[loc] = grad;
      gradangle[loc] = theta;
      
    }
  }
  
  //NMS
  float curr_angle = 0;
  float avant = 0; float apres = 0;
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      loc = x + y*img.width; 
      curr_angle = gradangle[loc];
      grad = gradmag[loc];
      gradient.pixels[loc]=color(int(255*grad/maxgrad));      
      //calcul des voisins
      if ((-0.3927<=curr_angle & curr_angle<0.3927)||(-3.1415927<=curr_angle&curr_angle<-2.7488)||(2.7488<=curr_angle&curr_angle<=3.1415927)){
        avant = gradmag[x+(y+1)*img.width];
        apres = gradmag[x+(y-1)*img.width];        
      }else if ((1.1781<=curr_angle & curr_angle<1.9636)||(-1.9636<=curr_angle&curr_angle<-1.1781)){
        avant = gradmag[x-1+(y)*img.width];
        apres = gradmag[x+1+(y)*img.width];  
      }else if ((0.3927<=curr_angle & curr_angle<1.1781)||(-2.7488<=curr_angle&curr_angle<-1.9636)){
        avant = gradmag[x-1+(y+1)*img.width];
        apres = gradmag[x+1+(y-1)*img.width]; 
      }else {//if ((-1.1781<=curr_angle & curr_angle<-0.3927)||(1.9636<=curr_angle&curr_angle<2.7488)){
        avant = gradmag[x-1+(y-1)*img.width];
        apres = gradmag[x+1+(y+1)*img.width]; 
      }

      // suppression des non max
      if ((grad>=avant) & (grad>=apres)){
        resultat.pixels[loc]=color(int(255*grad/maxgrad));        
      }else {
        resultat.pixels[loc]=color(0);}     
    }
  }
}

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

//**********************************************************************
// Calcul des contours 
void compute_contours(PImage img, PImage img_lissee, PImage gradient, PImage gradnms, PImage contours) {
  float[][] lissage = { { 1./9., 1./9., 1./9. }, 
    { 1./9., 1./9., 1./9. }, 
    { 1./9., 1./9., 1/9. } };  
  image_convolution(img, lissage, img_lissee); 
  img_lissee.updatePixels();
  compute_grad_nms(img_lissee, gradient, gradnms);
  gradient.updatePixels();
  gradnms.updatePixels();
  //seuillage(gradnms, contours, seuil_haut); 
  seuillage(gradnms, contours, seuil_bas, seuil_haut); 
  contours.updatePixels();
}
