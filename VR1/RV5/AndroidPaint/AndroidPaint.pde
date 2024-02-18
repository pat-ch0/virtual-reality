boolean Effacer;

int blanc = color(255,255,255);
int effaceCoul = color(255,0,0);
int afficheClav = color(75,0,255);
PImage Gomme,Palette;
int R=0,G=0,B=0;
String Text="";
int dimCarre = 100;

void setup(){
  //size(640,480,P2D); // Avec acceleration graphique 2D
  fullScreen(P2D);
  //surface.setTitle("Android_Paint");
  colorMode(RGB, 255,255,255); // fixe format couleur R G B pour fill, stroke, etc...
  smooth(); // Activation de l’anti-aliasing (smooth)
  orientation(PORTRAIT);
  Gomme = loadImage("gomme.png");
  Palette = loadImage("palette.png");
  background(blanc);
  Gomme.resize(dimCarre,dimCarre);
  Palette.resize(dimCarre,dimCarre);
  image(Gomme,0,0);
  image(Palette,width-dimCarre,0);
  Effacer = true;
}


void draw(){
   if(Effacer){
     background(blanc);
     Effacer = false;
     Text="";
   }
   image(Gomme,0,0);
   image(Palette,width-dimCarre,0);
}

void mousePressed(){
  if (mouseX < dimCarre+1 && mouseX > 0 && mouseY < dimCarre+1 && mouseY > 0){
     Effacer = true;
  }
  else if(mouseX < width && mouseX > width-dimCarre && mouseY < dimCarre+1 && mouseY > 0){
    openKeyboard();
  }else{
    closeKeyboard();
    Text="";
  }
}

void mouseDragged() {
  stroke(color(R,G,B));
  line(pmouseX, pmouseY, mouseX, mouseY);
}

void keyPressed(){
  textSize(128);
  //text(""+key,width/2,height/2);
  if (keyCode == BACKSPACE && Text.length() > 0){
    Text = Text.substring(0, Text.length() -1);
  }
  else if(keyCode == ENTER){
    closeKeyboard(); 
    textSize(128);
    fill(R,G,B);
    textAlign(CENTER);
    text(Text,width/2,height/2);
  }
  else if(((int) key<127 && (int) key > 31) || ((int) key < 255 && (int) key > 127)){
    Text += key;
  }
  println(Text);
}
