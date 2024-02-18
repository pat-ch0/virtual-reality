import java.util.*;

// Images 
PImage source;    // Source image
PImage warpedmarker;
PImage img_lissee;  // image lissée
PImage contours; //image seuillée des contours
PImage gradient;  // image de la norme du gradient
PImage gradnms;  // image du gradient après nms

// Paramètres hysteresis
int seuil_haut = 100;
int seuil_bas = 60;
// Paramètres hough
int thresholdHough=80;
int stept = 1;
int stepr = 1;
// précalcul des sinus et cosinus pour gagner du temps :
int nt = int(180/stept);
float[] costab = new float[nt];
float[] sintab = new float[nt];

//Taille marqueur
int markerWidth = 302;
int markerHeight = 302;

boolean clic = false;


void setup() {
  size(640, 480);
  source = loadImage("../marqueur.jpg"); 
  img_lissee = createImage(source.width, source.height, RGB);
  gradient = createImage(source.width, source.height, RGB);
  contours = createImage(source.width, source.height, RGB);
  gradnms = createImage(source.width, source.height, RGB);
  opencv = new OpenCV(this, source);
  warpedmarker = createImage(markerWidth, markerHeight, ARGB);
  
  //précalcul des sinus et cosinus pour gagner du temps
  float theta=0;
  for (int idt = 0; idt<nt;idt++){
    theta = radians(-90+idt*stept);
    costab[idt] = cos(theta);
    sintab[idt] = sin(theta);
  }
}

void draw() {
  int k, i, l;
  image(source,0,0);
  compute_contours(source, img_lissee, gradient, gradnms, contours); 
    
  // Transformée de Hough
  int [][] tab = compute_hough(contours,1,1);
  //Parcours de l'accumulateur pour récupérer les principales lignes
  Vector<droite> lines = compute_hough_lines(tab, thresholdHough);
  
  //Get the four contour lines
  droite[] markerLines = new droite[4];
  for (k=0; k<4; k++){
    //look for best line
    Iterator itr = lines.iterator(); 
    droite my_line = lines.get(0);

    while(itr.hasNext()){
      my_line = (droite)itr.next();
      if (markerLines[k] == null || markerLines[k].acc < my_line.acc){
        boolean dSimi = true;
        for (i=0; i<k; i++){
          if (abs(markerLines[i].theta - my_line.theta) < 10 && abs(markerLines[i].r - my_line.r) < 5){
            dSimi = false;
          }
        }
        if (dSimi){
          markerLines[k] = my_line;
        }
      }
    }
  }

  //Compute intersections to get corners
  ArrayList<PVector> points = new ArrayList<PVector>();
  PVector[] corners = new PVector[4];
  int count = 0;
  for (k=0; k<4; k++){    
    for (l = k; l<4; l++){
      //compute intersection between line k and line l if relevant
      PVector inter = markerLines[k].intersection(markerLines[l]);
      if (inter != null && !points.contains(inter)){
        if (abs(inter.x) <= 640 && abs(inter.y) <= 480){
          points.add(inter);
          corners[count] = inter;
          count++;
        }
      }
    }
  }

  // Calcul du warping :
  PVector[] arranged_corners = new PVector[4]; 
  float xc = (corners[0].x + corners[1].x + corners[2].x + corners[3].x) / 4;
  float yc = (corners[0].y + corners[1].y + corners[2].y + corners[3].y) / 4;
  for (k=0; k<4; k++){
    if (corners[k].x > xc && corners[k].y < yc){
      arranged_corners[0] = corners[k];
    }
    else if (corners[k].x < xc && corners[k].y < yc){
      arranged_corners[1] = corners[k]; 
    }
    else if (corners[k].x < xc && corners[k].y > yc){
      arranged_corners[2] = corners[k];
    }
    else{
      arranged_corners[3] = corners[k];
    }
  }
  opencv.toPImage(warpPerspective(arranged_corners, markerWidth, markerHeight), warpedmarker);
  
  // Affichage
  // We changed the pixels in destination
  gradient.updatePixels();
  contours.updatePixels();
  if (clic) {
    // Affiche les contours, les 4 droites principales et les coins
    image(contours,0,0);
  }
  for (k=0; k<4; k++){
    markerLines[k].display(color(175,25,175),640,480);
  }
  for (k=0; k<points.size(); k++){
    ellipse(points.get(k).x, points.get(k).y, 8, 8);
  }
  if (mousePressed && (mouseButton == RIGHT)) {
    // Affiche le marqueur redressé
    image(warpedmarker,0,0);
  }
}


void mouseClicked(){
  if (mouseButton == LEFT){
    clic = !clic;
  }
}
