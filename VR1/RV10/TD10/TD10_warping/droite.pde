public class droite {
  public float r;
  public float theta;
  public int acc; // valeur de l'accumulateur
  
  //  constructor
  droite() {
    this.r = 0;
    this.theta = 0;
    this.acc = 0;
  }
    // Copy constructor
  public droite(droite line) {
    this.r = line.r;
    this.theta = line.theta;
    this.acc = line.acc;
  }
  
  droite copyline (droite line){
    droite l = new droite();
    //for all properties in FOo
    l.r = line.r;
    l.theta = line.theta;
    l.acc = line.acc;
    return l;
  }
  
  // Display the line in current image, from x = 0 (needs to be adapted if the frame is not at 0 position)
  // h : image height; w = image width
  void display(color c, int w, int h){
    float x1,y1,x2,y2;   
    stroke(c);
    if (sin(radians(this.theta))!=0){
      x1 = 0;
      x2 = w-1;
      y1 = (this.r-x1*cos(radians(this.theta)))/sin(radians(this.theta));
      y2 = (this.r-x2*cos(radians(this.theta)))/sin(radians(this.theta));        
      line(x1,y1,x2,y2);
    }
    else{      
      line(this.r,0,this.r,h-1);
    }
  }
  
  PVector intersection(droite line){
    PVector point = new PVector();
    if (this.theta == line.theta){
      println("Warning : droites paralleles !");
      return null;
    }
    else{      
      float c1 = cos(radians(this.theta));
      float c2 = cos(radians(line.theta));
      float s1 = sin(radians(this.theta));
      float s2 = sin(radians(line.theta));      
      
      if((s1!=0)&&(s2!=0)){
        point.x = (line.r/s2-this.r/s1)/(c2/s2-c1/s1);
        point.y = (this.r-point.x*c1)/s1;
      }
      else if(s1==0){//droite 1 verticale
        point.x = this.r;
        point.y = (line.r-point.x*c2)/s2;
      }
      else{//droite 2 verticale
        point.x = line.r;
        point.y = (this.r-point.x*c1)/s1;
      }        
    }    
    return point;
  }
}
