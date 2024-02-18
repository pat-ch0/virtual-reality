/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 7: Exploitation du flux squelette de la Kinect          */
/*                                                                          */
/* Exemple_7_Kinect_Skeleton.pde                       Processing 3.5.2     */
/****************************************************************************/

// Importation des librairies
import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect

// Declaration des variables globales
PKinect kinect;   // Declaration de la Kinect
Skeleton[] s;     // Tableau des Squelettes des personnes detectees
int sMax;         // Limite de personnes pouvant etre detectees

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640, 480);
  surface.setTitle("Exemple 7 - La Kinect en mode Squelette - E. Mesnard / ISIMA");
  stroke(#1ED315); // Trace en vert flashy
  strokeWeight(3); // plutot epais !
  // Initialisation Objet Kinect
  kinect = new PKinect(this);

  // Ouverture du flux "SKELETON"
  if (kinect.start(PKinect.SKELETON) == false) {
    println("Pas de kinect connectee !"); 
    exit();
    return;
  } else if (kinect.isInitialized()) {
    println("Kinect de type : "+kinect.getDeviceType());
    println("Kinect initialisee avec : ");
    sMax = kinect.getSkeletonCountLimit();
    println("  * Limite de personnes trackées : " + sMax);
  } else { 
    println("Probleme d'initialisation de la kinect");
    exit();
    return;
  }
}

// Fonction de re-tracage de la fenetre - executee en boucle
// ---------------------------------------------------------
void draw() { 
  int i ; // indice des boucles

  background(0); // Effacement de la fenetre, en noir

  // Recuperation d'eventuelles donnees sur la kinect...
  s = kinect.getSkeletons();

  // Traitement du Flux "Skeletons"
  for (i=0; i<sMax; i++) {
    if (s[i]!=null) { // Des donnees sont disponibles
      if (s[i].isTracked()==true) { // Cet humain est actuellement visible
        traceSquelette(i); // Dessin effectif du squelette
      }
    }
  }
}

// Trace du squelette du personnage
void traceSquelette(int userId) {
  // Tete
  dessinMembre(userId, Skeleton.HEAD, Skeleton.NECK);

  // Bras Gauche
  dessinMembre(userId, Skeleton.NECK, Skeleton.SHOULDER_LEFT);
  dessinMembre(userId, Skeleton.SHOULDER_LEFT, Skeleton.ELBOW_LEFT);
  dessinMembre(userId, Skeleton.ELBOW_LEFT, Skeleton.WRIST_LEFT);
  dessinMembre(userId, Skeleton.WRIST_LEFT, Skeleton.HAND_LEFT);

  // Bras droit
  dessinMembre(userId, Skeleton.NECK, Skeleton.SHOULDER_RIGHT);
  dessinMembre(userId, Skeleton.SHOULDER_RIGHT, Skeleton.ELBOW_RIGHT);
  dessinMembre(userId, Skeleton.ELBOW_RIGHT, Skeleton.WRIST_RIGHT);
  dessinMembre(userId, Skeleton.WRIST_RIGHT, Skeleton.HAND_RIGHT);

  // Torse
  dessinMembre(userId, Skeleton.SHOULDER_LEFT, Skeleton.SPINE_MID);
  dessinMembre(userId, Skeleton.SHOULDER_RIGHT, Skeleton.SPINE_MID);
  dessinMembre(userId, Skeleton.SPINE_BASE, Skeleton.SPINE_MID);

  // Jambe gauche
  dessinMembre(userId, Skeleton.SPINE_BASE, Skeleton.HIP_LEFT);
  dessinMembre(userId, Skeleton.HIP_LEFT, Skeleton.KNEE_LEFT);
  dessinMembre(userId, Skeleton.KNEE_LEFT, Skeleton.ANKLE_LEFT);
  dessinMembre(userId, Skeleton.ANKLE_LEFT, Skeleton.FOOT_LEFT);

  // Jambe droite
  dessinMembre(userId, Skeleton.SPINE_BASE, Skeleton.HIP_RIGHT);
  dessinMembre(userId, Skeleton.HIP_RIGHT, Skeleton.KNEE_RIGHT);
  dessinMembre(userId, Skeleton.KNEE_RIGHT, Skeleton.ANKLE_RIGHT);
  dessinMembre(userId, Skeleton.ANKLE_RIGHT, Skeleton.FOOT_RIGHT);
}

// Trace d'un seul membre du corps
void dessinMembre(int userId, int jointType1, int jointType2) {
  int[] jointPos1; // Coordonnees des membres
  int[] jointPos2;

  // Verification de la presence effective du membre
  if ( (s[userId].isJointTracked(jointType1)==true) &&
    (s[userId].isJointTracked(jointType2)==true) ) {

    // Recuperation des coordonnees 2D, proportionnelles a la taille de la fenetre
    jointPos1 = s[userId].get2DJoint(jointType1, width, height);
    jointPos2 = s[userId].get2DJoint(jointType2, width, height);

    // Trace du trait
    line(jointPos1[0], jointPos1[1], jointPos2[0], jointPos2[1]);
  }
}