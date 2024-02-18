import shapes3d.*; // Bibliotheque trace 3D

Box Cube_ISIMA;    // Variable shapes3D : un cube !
PImage Ma_Texture; // Texture associee

void setup() {
  size(400,400,P3D);
  // Creation du CUBE 3D en objet SHAPES 3D
  Ma_Texture = loadImage("ISIMA.jpg");
  Cube_ISIMA = new Box(120,120,120);
  Cube_ISIMA.texture(Ma_Texture);
  Cube_ISIMA.drawMode(Shape3D.TEXTURE);
}

void draw() {
  background(0);
  Cube_ISIMA.moveTo(width/2, height/2, 65);
  Cube_ISIMA.rotateBy(0.01,0.008,0); // on le fait tourner un peu...
  Cube_ISIMA.draw(getGraphics());    // dessin sur la fenêtre principale
}
