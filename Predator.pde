class Predator {
  
  boolean est3D = false;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;
  boolean ishungry = false;  //si il suit ou pas les oiseaux
  
  Predator(float x, float y) {
    acceleration = new PVector(0, 0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle), 0);

    position = new PVector(x, y,0);
    r = 4.0;
    maxspeed = 2;
    maxforce = 0.03;
  }
  
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);  
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector follow = followBoids(boids);
    follow.mult(2);
    applyForce(follow);
    if(follow.x==0 && follow.y==0){
      PVector randomforce = ramdomVector();
      randomforce.mult(1);
      applyForce(randomforce);
    }
  }
  
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    
    position.add(velocity);
    if(!est3D){
      position.z=0;
    }
    //System.out.println(position.x+" "+position.y);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
  
  
  void render() {
    fill(200, 100);
    stroke(255);
    pushMatrix();
    if(est3D){
      rotateY(0.5);
      translate(position.x, position.y, position.z);
      fill(0,235, 235); // set fill color to red
      sphere(r*3);
      rotateY(-0.5);
    }else{
      translate(position.x, position.y);
      fill( 0,235, 235); // set fill color to red
      ellipse(0, 0, r*2, r*2);
    }
    popMatrix();
  }

  // Wraparound
  void borders() {
    if(est3D){
      if(position.z < 0) position.z = limiteZ-(r*3);
      if(position.z > limiteZ) position.z = 0+(r*3);
      if (position.x < limiteBaseX) position.x = width+(r*3);
      if (position.y < limiteHaut3D) position.y = limiteBas3D-r;
      if (position.x > width+(r*3)) position.x = limiteBaseX;
      if (position.y > (limiteBas3D-r)) position.y = (r*3)+limiteHaut3D;
    }else{
      if (position.x < -r) position.x = width+r;
      if (position.y < limiteHaut) position.y = limiteBas-r;
      if (position.x > width+r) position.x = -r;
      if (position.y > (limiteBas-r)) position.y = r+limiteHaut;
    }
  }
  
  PVector ramdomVector(){
    float x = (float)(Math.random()*20-10);
    float y = (float)(Math.random()*20-10);
    if(est3D){
      float z = (float)(Math.random()*20-10);
      return new PVector(x*0.1, y*0.1, z*0.1);
    }
    
    return new PVector(x*0.1, y*0.1);
  }
  
  PVector followBoids(ArrayList<Boid> boids){
    float neighbordist = 100;
    PVector sum = new PVector(0, 0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0,0);
    }
  }
  
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  
   void setIsHungry(){
     this.ishungry=!this.ishungry;
   }
   
   void setMaxSpeed(float i){
     this.maxspeed = i;
   }
   
   void setEst3D(boolean i){
     this.est3D=i;
   }
  
}
