//**********************************************************************
// Calcul du gradient
void compute_gradient(PImage img, PImage gradient, PImage gradnms) {
   // A COMPLETER !
  float[][] filtreSobelH = { { -1, 0, 1 }, 
    { -2, 0, 2 }, 
    { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 }, 
    { 0, 0, 0 }, 
    { -1, -2, -1 } }; 
  float grad = 0;
  float angle = 0;
  float[] gradmag = new float[img.width*img.height];
  float[] gradangle = new float[img.width*img.height];
  float maxgrad = 0; 
  int loc = 0;
  
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
      angle = atan2(gradV,gradH);    
      loc = x + y*img.width;      
      gradmag[loc] = grad;
      gradangle[loc] = angle;     
    }
  }
  
  //NMS
  //Parcours des pixels de l'image
  float pix1 = 0;
  float pix2 = 0;
  float curr_angle = 0;
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      curr_angle = gradangle[loc]; 
      grad = gradmag[loc];
      gradient.pixels[loc]=color(int(255*grad/maxgrad));
      if ((-0.393<=curr_angle & curr_angle<0.393)||(-3.1416<=curr_angle&curr_angle<-2.749)||(2.749<=curr_angle&curr_angle<=3.1416)){
        pix1 = gradmag[x+(y+1)*img.width];
        pix2 = gradmag[x+(y-1)*img.width];
      }
      //else if(   ){
      //  pix1 = gradmag[x-1+y*img.width;
      //  pix2 = gradmag[x+1+y*img.width;
      //}else if(    ){
      //  pix1 = gradmag[x-1+(y-1)*img.width;
      //  pix2 = gradmag[x+1+(y+1)*img.width;        
      //}else {
      //  pix1 = gradmag[x-1+(y+1)*img.width;
      //  pix2 = gradmag[x+1+(y-1)*img.width;     
      //}    
      // suppression des non max
      if ((grad>=pix1)&(grad>=pix2)){
        gradnms.pixels[loc]=color(int(255*grad/maxgrad));        
      }else {
        gradnms.pixels[loc]=color(0);}   
      
    }
  }
  
  
    
    
}


//**********************************************************************
// Seuillage simple
void seuillage(PImage img, PImage imgSeuillee, int seuil) {
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
// Calcul des contours 
void compute_contours(PImage img, PImage img_lissee, PImage gradient, PImage gradnms, PImage contours) {
float[][]  masque_lissage = { { 1./9., 1./9., 1./9. }, 
    { 1./9., 1./9., 1./9. }, 
    { 1./9., 1./9., 1/9. } };
   
image_convolution(img, masque_lissage, img_lissee); 
//img_lissee.updatePixels();
//compute_gradient(img_lissee, gradient);
//gradient.updatePixels();
//compute_nms(gradient, gradnms);
//gradnms.updatePixels();
//seuillage(gradnms, contours, seuil); 
//contours.updatePixels();
}
