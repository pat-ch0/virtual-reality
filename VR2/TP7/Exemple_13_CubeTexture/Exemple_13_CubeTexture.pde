/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 13 : Dessin de deux cubes (simple et texture)           */
/*                                                                          */
/* Exemple_13_CubeTexture.pde                          Processing 3.5.4     */
/****************************************************************************/

// Declaration des variables globales
PShape Cube_Simple;  // Cube (shape) sans texture
PShape Cube_ISIMA;   // Le meme, avec une texture
PImage Texture_Cube; // Texture associee : une image JPG

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640, 360, P3D); // Ouverture en mode 3D
  surface.setTitle("Exemple 13 - Shape : Cubes avec et sans texture - E. Mesnard / ISIMA");
  
  // Creation d'un cube tout simple
  fill(#71CE6C); stroke(#94DEA9); // des couleur unies, plutot vert pale
  
  Cube_Simple = createShape(BOX,width/3.5); // et de taille proportionnelle a la largeur
  // Shapes possibles : ELLIPSE, RECT, ARC, TRIANGLE, SPHERE, BOX, QUAD, LINE
  
  // Creation d'un cube avec une texture
  Texture_Cube = loadImage("ISIMA.jpg"); // Chargement de la texture
  textureMode(NORMAL); // Les coordonnees de la texture sont normalisees de 0 a 1 en U et en V
  Cube_ISIMA = CreerCubeTexture(Texture_Cube,width/3.5);

}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Effacer la fenetre avant de dessiner
  background(0);
  
  // Positionnement des cubes et tracages...
  translate(width/4.0, height/2.0, -100);
  shape(Cube_Simple);
  translate(width/2.0, 0, 0); // Attention : les deplacements sont cumulatifs
  shape(Cube_ISIMA); // Trace effectif de ce cube
}

// Fonction de creation d'un cube, avec une taille et une texture
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

// Fonctions de gestion des evenements de la souris
void mouseDragged() { // Fonction invoquee tant que le bouton est maintenu appuye 
  // Ajout d'une rotation en X et en Y selon le deplacement de la souris
  Cube_ISIMA.rotateX((pmouseY-mouseY) /100.0);
  Cube_ISIMA.rotateY((mouseX-pmouseX) /100.0);
  Cube_Simple.rotateX((pmouseY-mouseY) /100.0);
  Cube_Simple.rotateY((mouseX-pmouseX) /100.0);
}
