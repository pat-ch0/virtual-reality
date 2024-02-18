import processing.vr.*;

void setup() {
  fullScreen(STEREO);
}

void draw() {
   // draw scene...
   background(200,200,200);
   

   pushMatrix();
   eye();
   translate(0, 0, 100);
   ellipse(0, 0, 50, 50);
   popMatrix();
}
