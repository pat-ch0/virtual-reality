/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 17 : Creation d'un buffer PGraphics et extraction       */
/*                       de l'image correspondante au format PImage         */
/*                                                                          */
/* Exemple_17_Graphique.pde                            Processing 3.5.4     */
/****************************************************************************/
PGraphics Graphique;      // Buffer pour trace
PImage ImageEquivalente;  // Tableau de pixels pour prise de photo

void setup() {
  size(400, 400, P3D);
  Graphique = createGraphics(300, 300, P3D);
  ImageEquivalente = createImage(300, 300, RGB);
}

void draw() {
  // Modelisation de la scene
  Graphique.beginDraw();
  Graphique.background(120);
  Graphique.stroke(80);
  Graphique.translate(140,140);
  Graphique.rotateX(-mouseY/100.0);
  Graphique.rotateY(-mouseX/100.0);
  Graphique.box(80);
  Graphique.endDraw();
  
  // Affichage de la scene
  // image(Graphique, 50, 50); // Possible d'afficher directement
  // ou bien en recuperant le tableau de pixels (prise de photo)
  ImageEquivalente = Graphique.get();
  image(ImageEquivalente, 50, 50);
}
