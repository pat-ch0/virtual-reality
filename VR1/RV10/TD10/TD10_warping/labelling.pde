import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

//**********************************************************************
//Ajout d'une équivalence dans la map
//eqm : equivalence map
//on suppose ici label0> label1
//on stocke toujours du label le plus grand vers le plus petit
void storeEquivalence(int label0, int label1, Map<Integer, Integer> eqm) {
  if ((eqm.containsKey(label0))&& !eqm.containsKey(label1)) {
    if (eqm.get(label0)<label1) {eqm.put(label1, eqm.get(label0));}
    else if (eqm.get(label0)>label1) {eqm.put(eqm.get(label0),label1);}
  }
  else if ((eqm.containsKey(label0))&& eqm.containsKey(label1)){
    if (eqm.get(label0)<eqm.get(label1)) {eqm.put(eqm.get(label1), eqm.get(label0));}
    else if (eqm.get(label0)>eqm.get(label1)) {eqm.put(eqm.get(label0),eqm.get(label1));}
  }
  else {
    eqm.put(label0, label1);
  }
}

//**********************************************************************
//find root recursively in the equivalence map
int get_root_label(int label, Map<Integer, Integer> eqm) {
  int root = 0;
  if (eqm.containsKey(label)) {
    root = get_root_label(eqm.get(label),eqm);
  }
  else root = label;
  
  return root;
}


//**********************************************************************
//**********************************************************************
// Segmentation en composantes connexes (régions)
// bImg : image binaire à segmenter en régions connexes
// labels : image résultante avec une teinte par région connexe de points blancs
// min_size : nb de pixel minimum d'une région
// maxsize : nb de pixels maximum d'une région
//**********************************************************************
//**********************************************************************
void labelling(PImage bImg, PImage labels, int min_size, int max_size){
  // Initialisation
  HashMap<Integer,Integer> eqm = new HashMap<Integer,Integer>();  
  int[][] labtab = new int[bImg.width][bImg.height];
  int current_label = 1;
  int toplabel = 0;
  int leftlabel = 0;
  
  //Parcours des pixels de l'image
  for (int y = 1; y < bImg.height-1; y++ ){
    for (int x = 1; x < bImg.width-1; x++) {      
      int loc = x + y*bImg.width;
      //Check neighbors
      if (bImg.pixels[loc] == color(255)){//point à classer
        toplabel = labtab[x][y-1];
        leftlabel = labtab[x-1][y];
        // nouveau label :
        if ((toplabel==0)&&(leftlabel==0)){          
          labtab[x][y] = current_label;
          current_label++;          
        }
        else if ((toplabel!=0)&&(leftlabel==0)){
          labtab[x][y] = toplabel;
        }
        else if ((toplabel==0)&&(leftlabel!=0)){
          labtab[x][y] = leftlabel;
        }
        else if ((toplabel!=0)&&(leftlabel!=0)&&(toplabel==leftlabel)){
          labtab[x][y] = toplabel;
        }
        // Sinon on mémorise l'équivalence :
        else if ((toplabel!=0)&&(leftlabel!=0)&&(toplabel!=leftlabel)){
          if (toplabel<leftlabel){
            storeEquivalence(leftlabel,toplabel,eqm);
            labtab[x][y] = toplabel;
          }
          else{
            storeEquivalence(toplabel,leftlabel,eqm);
            labtab[x][y] = leftlabel;
          }
        }
      }//Fin du traitement du pixel blanc
    }
  }
 //***************************************************
 //********** Reorganize equivalence map
   HashMap<Integer,Integer> eqm_clean = new HashMap<Integer,Integer>();
   for (int i : eqm.keySet()) {
   //println(i, "->", eqm.get(i));
     int label = get_root_label(i,eqm);
     if (label!=i) storeEquivalence(i, label, eqm_clean);   
   }

 
//***************************************************
// Deuxième passe : compte des pixels par région
  int label=0;
  //sizecomp : stocke la taille de chaque composante 
  HashMap<Integer,Integer> sizecomp = new HashMap<Integer,Integer>();
  for (int y = 1; y < height-1; y++ ){
    for (int x = 1; x < width-1; x++) {
      int loc = x + y*bImg.width;
      if (bImg.pixels[loc] == color(255)){//point à classer
        if (eqm_clean.containsKey(labtab[x][y])){
          label = eqm_clean.get(labtab[x][y]);}
        else {label = labtab[x][y];} 
        if (sizecomp.containsKey(label)){
          sizecomp.put(label, sizecomp.get(label)+1);
        }
        else{
          sizecomp.put(label, 1);
        }
      }      
    }
  }
  
  //***************************************************
  // Filtrage des régions en fonction de leur taille
  // Numérotation des régions
  int n=0;
  HashMap<Integer,Integer> dico = new HashMap<Integer,Integer>();
  for (Map.Entry<Integer,Integer> element : sizecomp.entrySet()) {
    if ((element.getValue()>min_size)&&(element.getValue()<max_size)){
      n++;
      dico.put(element.getKey(),n);
    }
  }
  println("Nb de composants après filtrage : ", dico.size());
  
  ////*****************************************************
  // Troisème passe : remplissage de l'image des composantes
  for (int y = 1; y < height-1; y++ ){
    for (int x = 1; x < width-1; x++) {
      int loc = x + y*bImg.width;
      if (bImg.pixels[loc] == color(255)){//point à classer
        if (eqm_clean.containsKey(labtab[x][y])){
          label = eqm_clean.get(labtab[x][y]);}
        else {label = labtab[x][y];} 
        if (dico.containsKey(label)){
          labels.pixels[loc] = color(dico.get(label)*255/dico.size());  
        }
        else{
          labels.pixels[loc] = color(0);  
          bImg.pixels[loc] = color(0);
        }
      }
      else{labels.pixels[loc] = color(0);}
    }
  } 
}
