// calcul de l'accumulateur sur l'image im de contours binaires
// theta : -90:stept:90 -> idx = theta + 90 : 0 -> 180
// r : -r_max:stepr:r_max 
int [][] compute_hough(PImage im, float stept, float stepr){
  int rmax = (int) sqrt(im.height*im.height+im.width*im.width); 
  float r = 0; int loc = 0;
  int nt = int(180/stept);
  int nr = int(2*rmax/stepr);
  int [][] tab = new int[nt][nr];
  
  //précalcul des sinus et cosinus
  float[] costab = new float[nt];
  float[] sintab = new float[nt];
  float theta=0;
  for (int idt = 0; idt<nt;idt++){
    theta = radians(-90+idt*stept);
    costab[idt] = cos(theta);
    sintab[idt] = sin(theta);
  }  
  
  //Calcul de l'accumulateur
  for (int x = 0; x < im.width; x++) { //Parcours de colonnes
    for (int y = 0; y < im.height; y++ ) { //parcours des lignes
      // Pixel location
      loc = x + y*im.width;
      if (im.pixels[loc] ==  color(255)) {
        for (int idt = 0; idt<nt;idt++){ //Parcours des theta
          r = x*costab[idt]+y*sintab[idt]; //calcul de r
          tab[idt][round((r+rmax)/stepr)] = tab[idt][round((r+rmax)/stepr)] + 1;
        }
      }
    }
  }
  return tab;
}


// Calcul des lignes principales (accumulateur supérieur au seuil)
Vector<droite> compute_hough_lines(int [][] tab, int seuil_hough){
  Vector<droite> lines = new Vector<droite>();
  int nt=tab.length; 
  int nr=tab[0].length;  
  int rmax = (int)sqrt(height*height+width*width);
  float stept = 180/float(nt);
  float stepr = 2*rmax/float(nr);
  int count = 0;
  for (int idt = 0; idt<nt;idt++){ //Parcours des theta
    for (int idr = 0; idr<nr;idr++){
      if (tab[idt][idr] > seuil_hough){
        droite my_line = new droite();
        my_line.acc = tab[idt][idr];
        my_line.theta = -90+idt*stept;
        my_line.r = idr*stepr - rmax;           
        lines.addElement(my_line);
        count++;
      }
    }
  }
  println("lignes détectées : ", count);
  return lines;
}
