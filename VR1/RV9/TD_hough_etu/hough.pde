// calcul de l'accumulateur sur l'image im de contours binaires
int [][] compute_hough(PImage im, int pasTh){
  int rmax = int(sqrt(im.width*im.width + im.height*im.height));
  float r = 0;
  //int loc = 0;
  int [][] tab = new int[180][rmax*2];
  //tableaux de sauvegarde pour fluidifier le rendu
  float [] tabCos = new float[180];
  float [] tabSin = new float[180];
  for (int i = 0; i < 180; i++){
    tabCos[i] = cos((i-90)*PI/180);
    tabSin[i] = sin((i-90)*PI/180);
  }
  for (int y = 0; y < im.height; y++){
    for (int x = 0; x < im.width; x++){
      if (im.pixels[im.width*y + x] == color(255,255,255)){
          for (int theta = 0; theta < (180 / pasTh); theta++){
              //r = x*cos((theta*pasTh-90)*PI/180) + y*sin((theta*pasTh-90)*PI/180);
              r = x*tabCos[theta*pasTh] + y*tabSin[theta*pasTh];
              tab[theta][int(r) + rmax] += 1;
          }
      }
    }
  }
  return tab;
}


// Calcul des lignes principales (accumulateur supérieur au seuil)
Vector<droite> compute_hough_lines(int [][] tab, int seuil_hough){
  Vector<droite> lines = new Vector<droite>();
  for (int theta = 0; theta < tab.length; theta++){
    for(int r = 0; r < tab[theta].length; r++){
      if(tab[theta][r] > seuil_hough){
        droite d = new droite();
        d.r = r - tab[theta].length/2;
        d.theta = theta - tab.length/2;
        d.acc = tab[theta][r];
        lines.add(d);
      }
    }
  }  
  return lines;
}
