/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*         Exemple pour la bibliotheque MD2Importer developpee par          */
/*         Peter Lager ("Quarks")  :  http://www.lagers.org.uk/             */
/*         MD2 : fichier objet texture contenant des animations             */
/*                                                                          */
/* Exemple_11_Import_MD2.pde                           Processing 3.5.2     */
/****************************************************************************/

// Importation des librairies
import MD2Importer.*; // Librairie d'acces aux fichiers MD2

// Declaration des variables globales
PImage fondEcran;           // Un ciel comme fond d'ecran !
MD2_Loader chargeurOiseau;  // Espace memoire pour charger/decoder le fichier
MD2_Model Oiseau;           // Objet MD2 lu
MD2_ModelState[] animation; // Animations disponibles pour ce modele
float pourcentAnimation = 0.4; // Vitesse sur le rendu de l'animation  
float rotX, rotZ;           // Rotation de l'objet

// Fonction d'initialisation de l'application 
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480, P3D);
  surface.setTitle("Exemple 11 - Import fichier MD2 - E. Mesnard / ISIMA");
  
  noStroke();
  fondEcran = loadImage("Ciel.jpg");
  
  // Creation du chargeur pour acceder au fichier MD2
  chargeurOiseau = new MD2_Loader(this);
  
  // Chargement effectif du modele texture
  Oiseau = chargeurOiseau.loadModel("Oiseau.md2", "Oiseau.jpg");
  
  if (Oiseau == null) {
    println("Probleme de chargement de ce fichier MD2");
    exit();
  } else {
  
    // Affichage (eventuel) de diverses informations pour le DEBUG
  
    // chargeurOiseau.displayHeader(); // Informations sur le modele charge
    // chargeurOiseau.displayGLcommands(); // Affichage des commandes OPENGL
                                         // correspondantes
    // chargeurOiseau.displayModelStates(); // Affiche le nom des animations
                                          // et les frames associees
    // chargeurOiseau.displayFrameNames(); // Affiche le nom des frames 
                       
    chargeurOiseau = null; // Liberation de l'espace memoire

    // Recuperation de toutes les animations disponibles
    animation = Oiseau.getModelStates();
    
    // Affichage d'informations pour le DEBUG
    // for(int i = 0; i < animation.length; i++){
    //  println("Animation["+i+"]= "+ animation[i].name);
    // }
    //println("Espace memoire utilise (sans texture)"+Oiseau.memUsage());
    
    // Recentrage de l'objet pour avoir un repere en (0,0,0)
    // Vector3 Decalage = new Vector3();
    // Decalage = Oiseau.getModOffset();
    // println("Decalage d'origine = " +Decalage);
    Oiseau.centreModel();
    // Decalage = Oiseau.getModOffset();
    // println("Decalage corrige (normalement =[0,0,0]) = " +Decalage);
    
    
    // Mise a l'echelle souhaitee de l'objet MD2
    Vector3 dimensionOiseau = new Vector3();
    dimensionOiseau = Oiseau.getModSize();
    // println("Taille de l'oiseau : " + dimensionOiseau);
    Oiseau.scaleModel((0.8*height)/dimensionOiseau.y);
    // ou bien, mise a l'echelle manuelle : Oiseau.scaleModel(0.1);
    // dimensionOiseau = Oiseau.getModSize();
    // println("Taille reduite : " + dimensionOiseau);

    // Selection de l'animation (par exemple, la derniere !)
    Oiseau.setState(animation.length-1); // Une seule pour cet exemple = 0

    // Calcul (eventuel) d'une vitesse d'evolution dans les animations
    pourcentAnimation = constrain(4/(frameRate + 0.01), 0.01, 1);
    
    // Initialisation des variables globales
    rotX=radians(70); rotZ=radians(15);
  }
}

// Fonction de re-tracage de la fenetre
void draw() {
  background(fondEcran); // Effacement ecran avec dessin du ciel
  lights(); // Lumiere pour un meilleur rendu
  
  // Positionnement et orientation de l'objet dans la scene
  translate(width/2,height/2); // Posionnement au centre
  rotateX(rotX);
  rotateZ(rotZ);
  // Trace de l'objet en faisant evoluer son animation
  Oiseau.update(pourcentAnimation);
  Oiseau.render();
  
  // Affiche la position courante dans l'animation
  // println("Frame "+frameCount+" Indice = "+Oiseau.getPosition());
}

void mouseDragged() { // fonction de gestion de deplacement de la souris
  rotZ -= (mouseX - pmouseX) * 0.01; // Inversion X et Z
  rotX -= (mouseY - pmouseY) * 0.01; // plus naturelle !
}
