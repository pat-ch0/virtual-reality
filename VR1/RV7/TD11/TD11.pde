import processing.vr.*;

// create a container for the 3D file to be loaded into
PShape model,room,ceiling,robot,sun,table,globeStand;
PShape Cube_ISIMA;
PImage Texture_Cube, Vitality;


// The Setup script is only run 1 time at the initialization of the program
void setup() {
  
  // Set the screen to STEREO whihc means the side by side view used in the google cardboard
  fullScreen(STEREO);
  colorMode(RGB, 255,255,255);
  fill(#4C1989);
  PFont font = createFont("SansSerif", 8 * displayDensity);
  textFont(font);
  textAlign(CENTER, CENTER);
  Vitality = loadImage("vita.png");
  Vitality.resize(50,50);
  Texture_Cube = loadImage("ISIMA.jpg"); // Chargement de la texture
  textureMode(NORMAL); // Les coordonnees de la texture sont normalisees de 0 a 1 en U et en V
  Cube_ISIMA = CreerCubeTexture(Texture_Cube,width/3.5);
}

// The draw script is ran every time it finishes. So it continuously repeats as long as the program is running.
// The script runs from top to bottom and in this case refreshes the screen every time and displays the 3D model.
void draw() {
  
  // Draw a new background with the value 0 (black) to refresh all the pixels on the screen and turn them black
  background(200,200,200);
  
  // Include lights in the scene
 
 pointLight(180, 180, 180, 0, 600, 0);
 directionalLight(100, 100, 100, -1, 0, 0);
 
 translate(0, 0, 0); // Attention : les deplacements sont cumulatifs
 shape(Cube_ISIMA); // Trace effectif de ce cube
 
 Cube_ISIMA.rotateX(0.008);
 Cube_ISIMA.rotateY(0.008);
 
 pushMatrix();
 eye();
 translate(0, 0, 100);
 noLights();
 image(Vitality,-90,-150);
 text("Let's go to the EZ-MA", 0, 50);
 popMatrix();
}

PShape CreerCubeTexture(PImage tex, float taille) {
PShape formeCube;  
  
  formeCube = createShape();
  formeCube.beginShape(QUADS);
  // Les geometries possibles sont : POINTS, LINES, TRIANGLES, TRIANGLE_FAN,
  //                                 TRIANGLE_STRIP, QUADS, QUAD_STRIP
  
  formeCube.noFill();
  formeCube.noStroke();
  
  formeCube.texture(tex); // A definir des le depart
  
  // Declaration des listes de points pour les faces
  
  // vertex(x, y, z, u, v) : (x,y,z) = coordonnees du point
  //                         (u,v) = coordonnees de la texture
  
  // Face +Z = Avant
  formeCube.vertex(-1,-1, 1, 0, 0);
  formeCube.vertex( 1,-1, 1, 1, 0);
  formeCube.vertex( 1, 1, 1, 1, 1);
  formeCube.vertex(-1, 1, 1, 0, 1);
  
  // Face -Z = Arriere
  formeCube.vertex( 1,-1,-1, 0, 0);
  formeCube.vertex(-1,-1,-1, 1, 0);
  formeCube.vertex(-1, 1,-1, 1, 1);
  formeCube.vertex( 1, 1,-1, 0, 1);
  
  // Face +Y = Dessous
  formeCube.vertex(-1, 1, 1, 0, 0);
  formeCube.vertex( 1, 1, 1, 1, 0);
  formeCube.vertex( 1, 1,-1, 1, 1);
  formeCube.vertex(-1, 1,-1, 0, 1);

  // Face -Y = Dessus
  formeCube.vertex(-1,-1,-1, 0, 0);
  formeCube.vertex( 1,-1,-1, 1, 0);
  formeCube.vertex( 1,-1, 1, 1, 1);
  formeCube.vertex(-1,-1, 1, 0, 1);
  
   // Face +X = Droite
  formeCube.vertex( 1,-1, 1, 0, 0);
  formeCube.vertex( 1,-1,-1, 1, 0);
  formeCube.vertex( 1, 1,-1, 1, 1);
  formeCube.vertex( 1, 1, 1, 0, 1);

  // Face -X = Gauche
  formeCube.vertex(-1,-1,-1, 0, 0);
  formeCube.vertex(-1,-1, 1, 1, 0);
  formeCube.vertex(-1, 1, 1, 1, 1);
  formeCube.vertex(-1, 1,-1, 0, 1);
  
  formeCube.endShape();
  
  // Mise a l'echelle
  formeCube.scale(taille/2.0); // taille proportionnelle
  
  // Orientation initiale possible
  // formeCube.rotateX(PI/6);  
  // formeCube.rotateY(PI/4);
  return formeCube;
}
