// import/include the android vr libraies which have been downloaded when the SDK was installed
// This library handels all the movement, stereoscopic 3D etc needed to view vr on an android phone
import processing.vr.*;

// create a container for the 3D file to be loaded into
PShape model,room,ceiling,robot,sun,table,globeStand;


// The Setup script is only run 1 time at the initialization of the program
void setup() {
  
  // Set the screen to STEREO whihc means the side by side view used in the google cardboard
  fullScreen(STEREO);
  
  // Load the .obj 3d model file + the .mtl texture file which have been put in the data folder of the processing sketch
  // File location /sketch_name/data/cube.obj
  // File location /sketch_name/data/cube.mtl
  // File location /sketch_name/data/images_which_are_used_in_the_mtl_texture_file.png/jpg/bmp etc.
  model = loadShape("globe.obj");
  room = loadShape("room.obj");
  robot = loadShape("robot.obj");
  ceiling = loadShape("ceiling.obj");
  sun = loadShape("sun.obj");
  table = loadShape("table.obj");
  globeStand = loadShape("globeStand.obj");
  
  // This scales the 3D model to the required size in order to be viewed. 
  //This depends on the size of the 3D model when it was exported from the 3D program you used (in this case Blender) 
  room.scale(200);
  robot.scale(200);
  ceiling.scale(200);
  model.scale(40);
  sun.scale(160);
  table.scale(200);
  globeStand.scale(200);
}

// The draw script is ran every time it finishes. So it continuously repeats as long as the program is running.
// The script runs from top to bottom and in this case refreshes the screen every time and displays the 3D model.
void draw() {
  
  // Draw a new background with the value 0 (black) to refresh all the pixels on the screen and turn them black
  background(0);
  
  // Include lights in the scene
 pointLight(180, 180, 180, 0, 600, 0);
 directionalLight(100, 100, 100, -1, 0, 0);
 
  //Push Matrix is used to create a new x,y,z grid which does not affect the position of the other objects in the scene
  //This new grid is closed with the popMatrix statement
  pushMatrix();
    // translate the 0 point by following amounts
    translate(800,800,0);
    // rotate the grid by following amount
    // The frameCount is used to rotate the object around its axis. This value changes as the program runs
    rotateY((2*PI*frameCount)/500);
    //Draw the Pshape object on screen. Moved by the translated amount stated in the previous line
    shape(sun);
    
    translate(200,-100,0);
    rotateY(((PI/100)*frameCount));
    shape(model);
  popMatrix();
  
  pushMatrix();
    translate(0,1300,0);
    shape(room); 
    shape(ceiling);
  popMatrix();
  
  pushMatrix();
    rotateY(PI/4);
    // Use a sin function to move an object in an oscilating motion
    translate(map(sin(float(frameCount)/200),-1f,1f,-600f,450f),1250,0); 
    shape(robot);
  popMatrix();
  
  pushMatrix();
    translate(800,1200,0);
    shape(table);
  popMatrix();
  
  pushMatrix();
    translate(800,1200,0);
    shape(globeStand);
  popMatrix();
}