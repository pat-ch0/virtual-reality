PShape Cube_Simple;  // Cube (shape) sans texture
PShape Cube_Light;
boolean teinteVariable;
float colorSource;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640, 360, P3D); // Ouverture en mode 3D
  surface.setTitle("Tah le cube éclairé");
  teinteVariable = false;
  
  // Creation d'un cube tout simple
  fill(#FFFFFF); // des couleur unies, plutot vert pale
  noStroke();
  Cube_Simple = createShape(BOX, width/3.5); // et de taille proportionnelle a la largeur
  // Shapes possibles : ELLIPSE, RECT, ARC, TRIANGLE, SPHERE, BOX, QUAD, LINE
  fill(#FFFFFF);
  Cube_Light = createShape(BOX, width/70);
  colorMode(HSB, 360, 1, 1);
  
  colorSource = 150;
}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Effacer la fenetre avant de dessiner
  background(0);
  noCursor();
  
  pushMatrix();
  translate(mouseX, mouseY, 0);
  shape(Cube_Light);
  popMatrix();
  
  if (teinteVariable){
    colorSource = (colorSource + 0.5) % 360;
  }
  
  lightSpecular(colorSource, 1, 1); //lumière blanche
  specular(150, 0, 0); //reflet
  pointLight(colorSource, 1, 1, mouseX, mouseY, 25); //ordre : après
  
  translate(width/2.0, height/2.0, -100);
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
