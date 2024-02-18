//**********************************************************************
// Calcul du gradient simple (Roberts)
void compute_gradient_simple(PImage img, PImage gradient) {
  int loc = 0, topLoc = 0, leftLoc = 0;
  float gradH = 0, gradV = 0, grad = 0;
  // Parcours de l'image en ignorant le bord
  for (int x = 1; x < img.width; x++) {
    for (int y = 1; y < img.height; y++ ) {
      // Pixel courant
      loc = x + y*img.width;
      color pix = img.pixels[loc];  
      // Pixel de gauche
      leftLoc = (x-1) + y*img.width;
      color leftPix = img.pixels[leftLoc];
      // Pixel du haut
      topLoc = x + (y-1)*img.width;
      color topPix = img.pixels[topLoc];

      // Calcul du gradient
      gradH = abs(brightness(pix) - brightness(leftPix));
      gradV = abs(brightness(pix) - brightness(topPix));
      grad = sqrt(gradH*gradH+gradV*gradV);
      gradient.pixels[loc] = color(grad);
    }
  }
}

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

//**********************************************************************
// Calcul du gradient et de l'orientation
void compute_gradient_Sobel_or(PImage img, PImage gradient, PImage orientation) {
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
  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      float gradV = 0, gradH=0; 
      //Calcul du résultat de la convolution par les 2 masques :
      gradH = apply_kernel_lum(x, y, filtreSobelH, img);
      gradV = apply_kernel_lum(x, y, filtreSobelV, img);
      //Calcul de la norme du gradient :
      grad = sqrt(gradH*gradH+gradV*gradV); 
      gradmag[x+y*img.width] = grad;
      if (grad>maxgrad) {
        maxgrad = grad;
      } 
      theta = atan2(gradV, gradH);      
      loc = x + y*img.width;
      orientation.pixels[loc] = color(theta*255./(float)Math.PI);//scaled to 0 255           
      gradient.pixels[loc] = color(grad);
    }
  }
  
  //Rescale entre 0 et 255
  for (int k = 0; k < gradmag.length; k++)
  {
    gradmag[k] = 255*gradmag[k]/maxgrad; 
    gradient.pixels[k] = color(int(gradmag[k]));
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
        avant = gradmag[x-1+(y-1)*img.width];
        apres = gradmag[x+1+(y+1)*img.width]; 
      }else {//if ((-1.1781<=curr_angle & curr_angle<-0.3927)||(1.9636<=curr_angle&curr_angle<2.7488)){
        avant = gradmag[x-1+(y+1)*img.width];
        apres = gradmag[x+1+(y-1)*img.width]; 
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
