/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 10 : Dessin d'un objet OBJ texture par P3D              */
/*                       avec calcul du recentrage de l'objet               */
/*                                                                          */
/* Exemple_10_Dessin_OBJ.pde                            Processing 3.5.4    */
/****************************************************************************/

// Declaration des variables globales
PShape objetOBJ;        // Objet a charger
PShape boundingBoxOBJ;  // Boite englobante
float dimOBJ_X, dimOBJ_Y, dimOBJ_Z; // Dimensions de l'objet

boolean traceBB_OBJ; // Flag pour le trace de la bounding box

// Analyse complementaire pour determiner la position du repere dans l'objet
// -------------------------------------------------------------------------
PShape partieObj; // Analyse de l'objet par morceaux (enfants dans un objet)
int nombreEnfant;
int nombreVertex, nombreVertexTotal; // Nombres de Vertex
// Amplitudes de l'objet, initialisees aux extremes opposes
float minX = 3.40282347E+38; // min et max sur les 3 dimensions
float minY = 3.40282347E+38;
float minZ = 3.40282347E+38;
float maxX = -3.40282347E+38;
float maxY = -3.40282347E+38;
float maxZ = -3.40282347E+38;
// Coordonnees du vertex en cours de traitement
float vX, vY, vZ;
// Decalage a appliquer pour positionner correctement l'objet
float decX, decY, decZ;

// Indices des boucles
int i, j;


// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  float facteurEchelle; // Mise a l'echelle pour un meilleur rendu

  // Initialisation des parametres graphiques utilises
  size(640, 480, P3D); // P3D obligatoire pour le rendu des OBJ
  surface.setTitle("Exemple 10 - Dessin d'objets OBJ - E. Mesnard / ISIMA");

  // Chargement de l'objet utilise
  //objetOBJ = loadShape("dragon.obj"); // Avec materiaux simples
  //objetOBJ = loadShape("rocket.obj"); // Avec image de texture
  objetOBJ = loadShape("Dog_Isima.obj"); // Avec image de texture, repere decale
  //objetOBJ = loadShape("moon.obj"); // Avec image de texture, bump, repere decale

  // Analyse de l'objet pour determiner la position du repere
  nombreVertex = objetOBJ.getVertexCount();
  nombreVertexTotal = nombreVertex;
  if (nombreVertex>0) {
    for (i=0; i<nombreVertex; i++) {
      vX = objetOBJ.getVertexX(i);
      vY = objetOBJ.getVertexY(i);
      vZ = objetOBJ.getVertexZ(i);
      if (vX<minX) minX=vX; 
      else if (vX>maxX) maxX=vX; 
      if (vY<minY) minY=vY; 
      else if (vY>maxY) maxY=vY; 
      if (vZ<minZ) minZ=vZ; 
      else if (vZ>maxZ) maxZ=vZ;
    }
  } 

  nombreEnfant = objetOBJ.getChildCount();
  //println("Nombre d'enfants : "+nombreEnfant);
  if (nombreEnfant>0) {
    for (i=0; i<nombreEnfant; i++) {
      // Analyse pour chaque enfant
      partieObj = objetOBJ.getChild(i);
      nombreVertex = partieObj.getVertexCount();
      nombreVertexTotal +=nombreVertex;
      if (nombreVertex>0) {
        for (j=0; j<nombreVertex; j++) {
          vX = partieObj.getVertexX(j);
          vY = partieObj.getVertexY(j);
          vZ = partieObj.getVertexZ(j);
          if (vX<minX) minX=vX; 
          else if (vX>maxX) maxX=vX; 
          if (vY<minY) minY=vY; 
          else if (vY>maxY) maxY=vY; 
          if (vZ<minZ) minZ=vZ; 
          else if (vZ>maxZ) maxZ=vZ;
        }
      }
    }
  }
  
  println("Nombre total de vertex dans l'objet : " + nombreVertexTotal);
  println("Coordonnees min : " + minX + "  " + minY + "  " + minZ);
  println("Coordonnees MAX : " + maxX + "  " + maxY + "  " + maxZ);
  
  // Determination de la taille effective de l'objet
  dimOBJ_X = maxX-minX;  // dimOBJ_X = objetOBJ.getWidth();
  dimOBJ_Y = maxY-minY;  // dimOBJ_Y = objetOBJ.getHeight();
  dimOBJ_Z = maxZ-minZ;  // dimOBJ_Z = objetOBJ.getDepth();
  println("Taille Objet : " + dimOBJ_X + ", " + dimOBJ_Y + ", " + dimOBJ_Z);

  decX = -minX - dimOBJ_X/2.0f;
  decY = -minY - dimOBJ_Y/2.0f;
  decZ = -minZ - dimOBJ_Z/2.0f;
  println("Translations a appliquer pour centrer l'objet : " + decX + "  " + decY + "  " + decZ);


  // Calcul du facteur d'echelle pour affichage "correct" a l'ecran
  facteurEchelle = min(width/(1.6*dimOBJ_X), height/(1.6*dimOBJ_Y), width/(1.6*dimOBJ_Z));
  objetOBJ.scale(facteurEchelle);

  println("Facteur d'Echelle pour rendu 640x480 : " + facteurEchelle);

  // Mise a jour des dimensions de l'objet et des decalages associes
  dimOBJ_X *= facteurEchelle;
  dimOBJ_Y *= facteurEchelle;
  dimOBJ_Z *= facteurEchelle;

  decX*= facteurEchelle;
  decY*= facteurEchelle;
  decZ*= facteurEchelle;
  println("Nouvelle taille Objet : " + dimOBJ_X + ", " + dimOBJ_Y + ", " + dimOBJ_Z);

  // Application des translations ainsi calculees pour recentrage
  // A noter, si l'origine de l'objet est en bas a droite au fond, alors
  // equivalent a : objetOBJ.translate(dimOBJ_X/2, -dimOBJ_Y/2, -dimOBJ_Z/2);
  objetOBJ.translate(decX, decY, decZ);

  // Creation d'une boite englobante
  noFill();
  stroke(200);
  boundingBoxOBJ = createShape(BOX, dimOBJ_X, dimOBJ_Y, dimOBJ_Z);

  // Trace de cette boite par defaut
  traceBB_OBJ = true;
} // fin de setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Effacer la fenetre avant de dessiner
  background(0);

  // Positionnement au centre de la fenetre
  translate(width/2, height/2, 0);

  // Affichage des objets
  lights(); // avec un peu de lumiere !
  shape(objetOBJ);
  if (traceBB_OBJ) shape(boundingBoxOBJ);
  // A noter que les objets sont souvent translates...
  // et orientes etrangement !
}

// Fonctions de gestion des evenements de la souris et du clavier
void mouseDragged() { // Fonction invoquee tant que le bouton est maintenu appuye 
  // Ajout d'une rotation en X et en Y selon le deplacement de la souris
  objetOBJ.rotateX((pmouseY-mouseY) /100.0);
  objetOBJ.rotateY((mouseX-pmouseX) /100.0);
  boundingBoxOBJ.rotateX((pmouseY-mouseY) /100.0);
  boundingBoxOBJ.rotateY((mouseX-pmouseX) /100.0);
}

void keyPressed() { // Fonction invoquee lors de l'appui sur une touche
  traceBB_OBJ = !traceBB_OBJ;
}
