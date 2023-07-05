// The Boid class

class Boid{
  boolean est3D = false;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float multiSeq=1;
  float multiCoh=1;
  float multiAli=1;
  float multisur=1;
  float multiWind=11;

    Boid(float x, float y) {
    if(est3D){
      acceleration = new PVector(0,0,0);
    }else{
      acceleration = new PVector(0, 0);
    }
    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    if(est3D){
      velocity = new PVector(cos(angle), sin(angle), 0);
      position = new PVector(x, y, random(10));
    }else{
      velocity = new PVector(cos(angle), sin(angle));
      position = new PVector(x, y);
    }
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }
  Boid(float x, float y, float z){
    this.est3D=true;
    acceleration = new PVector(0,0,0);
    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
      velocity = new PVector(cos(angle), sin(angle), 50);
      position = new PVector(x, y, random(10));
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }
  

  void run(ArrayList<Boid> boids,ArrayList<Predator> predators, ArrayList<Wind> winds) {
    flock(boids, predators, winds);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, ArrayList<Predator> predators, ArrayList<Wind> winds) {
    PVector fwi = forceWinds(winds);
    if(fwi.x==0 && fwi.y==0){
      PVector sep = separate(boids);   // Separation
      PVector ali = align(boids);      // Alignment
      PVector coh = cohesion(boids);   // Cohesion
      PVector sur = survive(predators);
      sep.mult(multiSeq);
      ali.mult(multiAli);
      coh.mult(multiCoh);
      sur.mult(multisur);
      applyForce(sep);
      applyForce(ali);
      applyForce(coh);
      applyForce(sur);
    }
    fwi.mult(multiWind);
    // Add the force vectors to acceleration
    applyForce(fwi);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    if(!est3D){
      position.z=0;
    }
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
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

  void render() {
    fill(200, 100);
    stroke(255);
    pushMatrix();
    if(est3D){
      rotateY(0.5);
      translate(position.x, position.y, position.z);
      fill(255, 0, 0); // set fill color to red
      sphere(r*1.5);
      rotateY(-0.5);
    }else{
      translate(position.x, position.y);
      fill(255, 0, 0); // set fill color to red
      ellipse(0, 0, r*2, r*2);
    }
    popMatrix();
  }

  // Wraparound
  void borders() {
    if(est3D){
      if(position.z < 0) position.z = limiteZ-(r*1.5);
      if(position.z > limiteZ) position.z = 0+(r*1.5);
      if (position.x < limiteBaseX) position.x = width+(r*1.5);
      if (position.y < limiteHaut3D) position.y = limiteBas3D-(r*1.5);
      if (position.x > width+(r*1.5)) position.x = limiteBaseX;
      if (position.y > (limiteBas3D-(r*1.5))) position.y = (r*1.5)+limiteHaut3D;
    }else{
      if (position.x < -r) position.x = width+r;
      if (position.y < limiteHaut) position.y = limiteBas-r;
      if (position.x > width+r) position.x = -r;
      if (position.y > (limiteBas-r)) position.y = r+limiteHaut;
    }
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0,0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0, 0);   // Start with empty vector to accumulate all positions
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
      return new PVector(0, 0, 0);
    }
  }
  
  PVector survive (ArrayList <Predator> predators){
    float neighbordist = 50;
    PVector sum = new PVector(0, 0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Predator predator : predators) {
      float d = PVector.dist(position, predator.position);
      if ((d > 0) && (d < neighbordist)) {
        PVector diff = PVector.sub(position, predator.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);   
        count++;
      }
    }
     if (count > 0) {
      sum.div((float)count);
    }

    // As long as the vector is greater than 0
    if (sum.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    
    return sum;
  }
  
  PVector forceWinds(ArrayList<Wind> winds){
    float neighbordist = 10;
    PVector sum = new PVector(0, 0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Wind other : winds) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
   if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0, 0);
    }
  
  }
  
  //Méthode Set pour changer les valeurs 
  void setSeq(float i){
     this.multiSeq=i; 
  }
  
  void setCoh(float i){
     this.multiCoh=i; 
  }
  
  void setAli(float i){
     this.multiAli=i; 
  }
  
  void setMaxSpeed(float i){
     this.maxspeed=i; 
  }
  
  void setSurvive(float i){
     this.multisur=i; 
  }
  
  void setWind(float i){
     this.multiWind=i; 
  }
  
  void setEst3D(boolean i){
    this.est3D=i;
  }
  
}
