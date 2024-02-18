/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 15 : Illumination avec reflexion speculaire et mise en  */
/*                       evidence de l'impact de la brillance (Shininess)   */
/*                                                                          */
/* Exemple_15_Illumination.pde                         Processing 3.5.4     */
/****************************************************************************/

boolean ActivationSpecular = true;

void setup() {
  size(800, 400, P3D); // Mode 3D obligatoire ici...
  surface.setTitle("Exemple 15 - Illumination et Shininess - E. Mesnard / ISIMA");
  noStroke(); // ATTENTION : Faire le test en commentant cette ligne !!
  noCursor();
  fill(255, 255, 255); // objet en blanc
}

void draw() {
  background(0); // Effacement avec fond noir

  // Configuration des materiaux pour le trace des objets
  specular(255, 255, 255);   // reflet blanc

  // Dessin d'une petite boite blanche en remplacement du curseur de
  // la souris, et simulant la presence d'une source lumineuse
  pushMatrix(); 
  translate(mouseX, mouseY, 120);
  box(5);
  popMatrix();

  // Creation des sources lumineuses (attention, l'ordre a une importance)
  // lumiere speculaire bleu fonce, parametrable
  if (ActivationSpecular) lightSpecular(0, 55, 128); 
  // Source en lumiere ponctuelle, en blanc gris, pilotee a la souris
  pointLight(200, 200, 200, mouseX, mouseY, 120); 

  // Sphere a gauche avec faible shininess
  translate(width/3 , height/2, 0);
  shininess(1.0);
  sphere(height/4);  

  // sphere a droite avec fort shininess
  translate(width/3, 0, 0); 
  shininess(8.0); 
  sphere(height/4);
}

void keyPressed() {
  ActivationSpecular = !ActivationSpecular;
}
