Flock flock;
Slider slider1;
Slider slider2;
Slider slider3;
Slider slider4;
Slider slider5;
Slider slider6;
CheckBox check1;
CheckBox check2;
CheckBox check3;
CheckBox check4;
CheckBox check5;
public static final int limiteBas=620;
public static final int limiteHaut=40;
public static final int limiteBas3D=540;
public static final int limiteHaut3D=130;
public static final int limiteZ=310;
public static final int limiteBaseX=200;
float hue1;
float hue2;
float hue3;
float hue4;
float hue5;
float hue6;
boolean ajoutBoid = true;
boolean ajoutPredator = false;
boolean ajoutWind = false;
boolean est3D =false;
boolean ajoutRepere  = false;

void setup() {
  size(1100, 700, P3D);
  check1 = new CheckBox( 170, 10, 20, true, "Bird");
  check2 = new CheckBox( 350, 10, 20, false, "Predator");
  check3 = new CheckBox( 530, 10, 20, false, "Wind");
  check4 = new CheckBox( 710, 10, 20, false, "3D");
  check5 = new CheckBox( 910, 10, 20, false, "Repère");
  slider1 = new Slider( 20 ,645, 150, 30, 0, 10, "Hue1");
  slider2 = new Slider( 200 ,645, 150, 30, 0, 10, "Hue2");
  slider3 = new Slider( 380 ,645, 150, 30, 0, 10, "Hue3");
  slider4 = new Slider( 560 ,645, 150, 30, 0, 10, "Hue4");
  slider5 = new Slider( 740 ,645, 150, 30, 0, 10, "Hue5");
  slider6 = new Slider( 920 ,645, 150, 30, 10, 20, "Hue6", false);
  hue1 = slider1.sliderVal;
  hue2 = slider2.sliderVal;
  hue3 = slider3.sliderVal;
  hue4 = slider4.sliderVal;
  hue5 = slider5.sliderVal;
  hue6 = slider6.sliderVal;
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  flock.addPredator(new Predator(width/2,height/2));
  if(ajoutWind){
     for (int i = 0; i < 80; i++) {
      flock.addWind(new Wind(width/5,height/6));
    } 
  }
}


void draw(){
  background( 0);
  //Création de la limite basse
  fill(255,0,255);
  rect(0, 0, width,40);
  rect(0,limiteBas, width,80);
  if(est3D){
    fill(255,0,255); 
    rotateY(0.5);
    noFill();
    fill(255, 0, 0);
    line(limiteBaseX, limiteHaut3D, 0, limiteBaseX, limiteBas3D, 0);
    line(limiteBaseX, limiteHaut3D, 0, limiteBaseX, limiteHaut3D, limiteZ);
    line(limiteBaseX, limiteHaut3D, 0, width, limiteHaut3D, 0);
    fill(0, 255, 0);
    line(width, limiteHaut3D, limiteZ, limiteBaseX, limiteHaut3D, limiteZ);
    line(width, limiteHaut3D, limiteZ, width, limiteHaut3D, 0);
    line(width, limiteHaut3D, limiteZ, width, limiteBas3D, limiteZ);
    fill(0, 255, 0);
    line(limiteBaseX, limiteBas3D, limiteZ, limiteBaseX, limiteBas3D, 0);
    line(limiteBaseX, limiteBas3D, limiteZ, limiteBaseX, limiteHaut3D, limiteZ);
    line(limiteBaseX, limiteBas3D, limiteZ, width, limiteBas3D, limiteZ);
    fill(0, 255, 0);
    line(width, limiteBas3D, 0, width, limiteHaut3D, 0);
    line(width,limiteBas3D, 0, width, limiteBas3D, limiteZ);
    line(width, limiteBas3D, 0, limiteBaseX, limiteBas3D, 0);
    stroke(255); 
    if(ajoutRepere){
      fill(255, 0, 0);
      line(20, 50, 60, 50);
      triangle(60, 50, 55, 45, 55, 55);
      
      fill(255, 255, 0);
      line(20, 50, 20, 90);
      triangle(15, 85, 20, 90, 25, 85);
      
      fill(255, 255, 0);
      line(20, 50,0, 20, 50, 40);
      //triangle(15,45, 20,50, 25, 45);
    }
    rotateY(-0.5);
    
  }
  if(!est3D && ajoutRepere){
    fill(255, 0, 0);
    line(20, 50, 60, 50);
    triangle(60, 50, 55, 45, 55, 55);
    
    fill(255, 255, 0);
    line(20, 50, 20, 90);
    triangle(15, 85, 20, 90, 25, 85);
  
  }
  
   if( mousePressed){
     
    boolean isChanged1 = slider1.checkPressed( mouseX, mouseY);
    boolean isChanged2 = slider2.checkPressed( mouseX, mouseY);
    boolean isChanged3 = slider3.checkPressed( mouseX, mouseY);
    boolean isChanged4 = slider4.checkPressed( mouseX, mouseY);
    boolean isChanged5 = slider5.checkPressed( mouseX, mouseY);
    boolean isChanged6 = slider6.checkPressed( mouseX, mouseY) && ajoutWind;
    boolean isChanged7 = check1.checkPressed(mouseX, mouseY);
    boolean isChanged8 = check2.checkPressed(mouseX, mouseY);
    boolean isChanged9 = check3.checkPressed(mouseX, mouseY);
    boolean isChanged10 = check4.checkPressed(mouseX, mouseY);
    boolean isChanged11 = check5.checkPressed(mouseX, mouseY);
    
    if(isChanged1){
        hue1 = slider1.sliderVal; //update hue using updated sliderVal
    }
    if(isChanged2){
        hue2 = slider2.sliderVal; //update hue using updated sliderVal
    }
    if(isChanged3){
        hue3 = slider3.sliderVal; //update hue using updated sliderVal
    }
    if(isChanged4){
        hue4 = slider4.sliderVal; //update hue using updated sliderVal
    }
    if(isChanged5){
        hue5 = slider5.sliderVal; //update hue using updated sliderVal
    }
    if(isChanged6){
        hue6 = slider6.sliderVal; //update hue using updated sliderVal
    }
    if(isChanged7){
        check1.setEtat(!ajoutBoid);
        ajoutBoid = check1.getEtat();
        if(ajoutPredator){
          check2.setEtat(!ajoutPredator);
          ajoutPredator = check2.getEtat();
        }
    }
    if(isChanged8){
        ajoutPredator = check2.getEtat();
        if(ajoutBoid){
          check1.setEtat(!ajoutBoid);
          ajoutBoid = check1.getEtat();
        }
    }
    if(isChanged9){
       ajoutWind = check3.getEtat();
       slider6.setChange(ajoutWind);
       if(ajoutWind){
         for (int i = 0; i < 400; i++) {
            flock.addWind(new Wind(width/5,height/6));
          }
       }else{
           flock.suppWinds();
       }
    }
    if(isChanged10){
      est3D = check4.getEtat();
    }
    if(isChanged11){
      ajoutRepere = check5.getEtat();
    }
  }
  
  //Affichage des Scrollbar 
  slider1.display();
  slider2.display();
  slider3.display();
  slider4.display();
  slider5.display();
  slider6.display();
  
  //Affichage des CheckBox
  check1.display();
  check2.display();
  check3.display();
  check4.display();
  check5.display();
  
  //Valeur afficher
  fill( hue1*36, 100, 100); 
  textAlign(CENTER);
  text("Alignement : "+ hue1, 100 , 610);
  fill( hue2*36, 100, 100);
  textAlign(CENTER);
  text("Separation : "+ hue2, 280 , 610);
  fill( hue3*36, 100, 100);
  textAlign(CENTER);
  text("Cohesion : "+ hue3, 460 , 610);
  fill( hue4*36, 100, 100);
  textAlign(CENTER);
  text("Speed MAx : "+ hue4, 640, 610);
  fill( hue5*36, 100, 100);
  textAlign(CENTER);
  text("Survive : "+ hue5, 820 , 610);
  fill( (hue6-10)*36, 100, 100);
  textAlign(CENTER);
  text("Winds : "+ hue6, 1000 , 610);
  fill( 36, 100, 100);
  textAlign(CENTER);
  text("Rajouter "+ check1.getLabel()+ " : "+ check1.getEtat(), 100 , 25);
  textAlign(CENTER);
  text("Rajouter "+ check2.getLabel()+ " : "+ check2.getEtat(), 270 , 25);
  textAlign(CENTER);
  text("Rajouter "+ check3.getLabel()+ " : "+ check3.getEtat(), 450 , 25);
  textAlign(CENTER);
  text("Activer la "+ check4.getLabel()+ " : "+ check4.getEtat(), 640 , 25);
  textAlign(CENTER);
  text("Activer le "+ check5.getLabel()+ " : "+ check5.getEtat(), 820 , 25);
  
  
 if(hue1!=flock.multiAli){
   flock.setAli(hue1);
 }
 if(hue2!=flock.multiSeq){
   flock.setSeq(hue2);
 }
 if(hue3!=flock.multiCoh){
   flock.setCoh(hue3);
 }
 if(hue4!=flock.maxspeed){
   flock.setMaxSpeed(hue4);
 }
 if(hue5!=flock.multisurvive){
   flock.setSurvive(hue5);
 }
  
 if(hue6!=flock.multiWind && ajoutWind){
   flock.setWind(hue6); 
 }
 
 if(est3D!=flock.est3D){
   flock.setEst3D(est3D);
 }
  flock.run();
}


// Add a new boid into the System
void mousePressed() {
  if(est3D){
    if((mouseX< width && mouseX > 0) && (mouseY< limiteBas-2 && mouseY > limiteHaut) && !check1.checkPressed(mouseX, mouseY) && !check2.checkPressed(mouseX, mouseY)){
    if(ajoutBoid){
      for(int i=0; i<10; i++){
        
        flock.addBoid(new Boid(mouseX,mouseY,10));
      }
    }
    if(ajoutPredator){
      flock.addPredator(new Predator(mouseX,mouseY));
    }
  }
  }else{
      if((mouseX< width && mouseX > 0) && (mouseY< limiteBas-2 && mouseY > limiteHaut)  && !check1.checkPressed(mouseX, mouseY) && !check2.checkPressed(mouseX, mouseY)){
      if(ajoutBoid){
        for(int i=0; i<10; i++){
          
          flock.addBoid(new Boid(mouseX,mouseY));
        }
      }
      if(ajoutPredator){
        flock.addPredator(new Predator(mouseX,mouseY));
      }
    }
  }
}


//Class slider 
//creates a horizontal slider
//uses map function to match displayed slider rectangle and 
//indicatror rectangles with the min, max values provided as input parameters
class Slider {
  float x, y;
  float w, h;
  float min, max;
  float sliderX;
  float sliderVal;
  String label;
  boolean change = true;


  Slider( float x, float y, float w, float h, float min, float max, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.min = min;
    this.max = max;
    this.label = label; 

    sliderX = x + (w/10);
    sliderVal = map( sliderX, x, x+w, min, max);

  }
  
  Slider(float x, float y, float w, float h, float min, float max, String label, boolean change) {
    this(x, y, w, h, min, max, label);
    this.change=change;
  }
  //display split into 2 methods, the background layer displayes 
  void display() {
    backgroundLayer();

    fill(300);
    rect( x, y, w, h);   //slider rectangle  - this is changed in child classes 

    fill(360); //inidcator rectangle
    rect( sliderX-2, y-3, 4, h + 6);
    text( int(sliderVal), sliderX + 2, y-4);  //display the sliderValue
  }
  //display background rectangle that has text display 
  //for min, max, label
  void backgroundLayer() {
    pushStyle();
    fill( 100); 
    rect( x-10, y-20, w+20, h+40);  ////outer background rectangle
    fill( 360);  //fill for the text
    // Create text for min, max, label - displayed under slider rectangle
    textSize( 12);
    textAlign(LEFT);
    text( int(min), x, y+h+15);
    textAlign(RIGHT);
    text( int( max), x+w-10, y+h+15);
    textAlign(CENTER);
    textSize(14);
    text( label, x+(w/2), y+h +15);
    popStyle();
  }

  void setSliderVal( float sliderVal) {
    this.sliderVal = sliderVal;
    this.sliderX = map( sliderVal, min, max, x, x+w);
  }

  //test mouse coordinates to determine if within the slider rectangle
  //if not changed, return false
  //set sliderX to current mouseX position
  boolean checkPressed(int mx, int my) {
    boolean isChanged = false;
    if ( mx >= x && mx <= x+w && my> y && my< y +h && change) { //test for >= so endpoints are included
      isChanged = true;
      sliderX = mx;
      sliderVal = map( sliderX, x, x+w, min, max);
    }
    return isChanged;
  }
  
  void setChange(boolean change){
    this.change=change;
  }
} 

class CheckBox{
  float x, y;
  float w;
  boolean etat=false;
  String label="";
  
 CheckBox (float x, float y, float w){
   this.x=x; this.y=y; this.w=w; 
 }
 CheckBox (float x, float y, float w, boolean etat, String label){
   this(x, y, w); 
   this.etat=etat; this.label=label;
 }
  
  void display() {
    fill(300);
    rect( x, y, w, w);
    if(etat){
      fill(0,255,0);
      rect( x+1, y+1, w-2, w-2);
    }else{
      fill(255,0,0);
      rect( x+1, y+1, w-2, w-2);
    }
  }
 
  boolean checkPressed(int mx, int my) {
    boolean isChanged = false;
    if (mx >= x && mx <= x+w && my > y && my < y+w) {
        isChanged = true;
        etat = !etat; // inverse l'état de la case à cocher
    }
    return isChanged;
  }
  
  boolean getEtat(){
    return this.etat;  
  }
  
  void setEtat(Boolean etat){
    this.etat = etat;
  }
  String getLabel(){
    return this.label;
  }
}
