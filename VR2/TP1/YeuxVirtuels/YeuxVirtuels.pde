float Xg, Yg; // Positions "regard" de l'oeil gauche
float Xd, Yd; // Oeil droit
boolean lock;
float h;

void setup() {
  size(640, 480);
  surface.setTitle("Big bro is watching you");
  stroke(0);
  smooth();
  lock = false;
  // Intervalle oeil gauche : (X,Y)min = (190,200); (X,Y)max = (250,300)
  Xg = 220;
  Yg = 250;
  // Intervalle oeil droit : (X,Y)min = (366,180); (X,Y)max = (435,320)
  Xd = 400;
  Yd = 250;
  h = 180;
  background(h, 100, 200);
}

void draw() {
  if (!lock){
    // Deplacements en proportion des mouvements au sein de la fenetre
    Xg = map(mouseX, 0, width, 190, 250);
    Yg = map(mouseY, 0, height, 200, 300);
    Xd = map(mouseX, 0, width, 366, 435);
    Yd = map(mouseY, 0, height, 180, 320);
  }
    
  // Trace oeil gauche
  fill(#F7F3C8);
  ellipse(220, 250, 108, 240);
  fill(0);
  ellipse(Xg, Yg, 30, 90);
  fill(#EADF5A);
  ellipse(Xg, Yg+5, 12, 12);

  // Trace oeil droit
  fill (#F7F3C8);
  ellipse(400, 250, 108, 300);
  fill(0);
  ellipse(Xd, Yd, 30, 90);
  fill(#EADF5A);
  ellipse(Xd, Yd+5, 12, 12);
}

void mouseClicked(){
  if (mouseButton == RIGHT){
    lock = !lock;
  }
}

void mouseWheel(MouseEvent event){
  colorMode(HSB, 255);
  h += event.getCount();
  background(h, 100, 200);
}
