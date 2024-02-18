PShape Cube_Simple;  // Cube (shape) sans texture
PShape Cube_Light;
boolean teinteVariable; //couleur changeante ?
float colorSource;

void setup() {
  size(640, 360, P3D); // Ouverture en mode 3D
  surface.setTitle("Tah le cube éclairé");
  teinteVariable = false;
  
  // Creation d'un cube tout simple
  fill(#FFFFFF); // des couleur unies, plutot vert pale
  noStroke();
  Cube_Simple = createShape(BOX, width/8); // et de taille proportionnelle a la largeur
  // Shapes possibles : ELLIPSE, RECT, ARC, TRIANGLE, SPHERE, BOX, QUAD, LINE
  Cube_Light = createShape(BOX, width/80);
  colorMode(HSB, 360, 1, 1);
  colorSource = 150;
}

void draw() {
  background(0);
  noCursor();
  
  pushMatrix();
  translate(mouseX, mouseY, 120);
  shape(Cube_Light);
  popMatrix();
  
  if (teinteVariable){
    colorSource = (colorSource + 0.3) % 360;
  }
  
  lightSpecular(colorSource, 1, 1); //lumière blanche
  pointLight(colorSource, 1, 1, mouseX, mouseY, 120); //ordre : après
  
  translate(width/2.0, height/2.0, 120);
  specular(150, 0, 0); //reflet
  shape(Cube_Simple);
  
  Cube_Simple.rotateX(0.01);
  //Cube_Simple.rotateZ(0.01);
  Cube_Simple.rotateY(0.005);
}

void keyPressed(){
  if (key == ' '){
    teinteVariable = !teinteVariable;
  }
} 
