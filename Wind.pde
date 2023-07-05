class Wind {
  boolean est3D = false;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float h;
  float w;
  float maxforce;    // Maximum steering force
  float maxspeed;
  
  
  Wind(float x, float y) {
    acceleration = new PVector(0, 0,0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    position = new PVector(x, y);
    h = 3.0;
    w = 0.5;
    maxspeed = 3;
    maxforce = 0.03;
  } 
  
  
   void run(ArrayList<Wind> winds) {
    flock(winds);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Wind> winds) {
    PVector ali = align(winds);      // Alignment
    ali.mult(1.5);
    applyForce(ali);
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

  void render() {
    fill(150);
    stroke(150);
    if(est3D){
      translate(position.x, position.y, position.z); 
      rotateY(0.5);
      noFill();
      box(w*3, h*3, 5);
      stroke(255);
      rotateY(-0.5);
    }else{
      rect(position.x, position.y, w, h);
      stroke(255);
    }
    
}

  // Wraparound
  void borders() {
    if(est3D){
      if(position.z < 0) position.z = limiteZ;
      if(position.z > limiteZ) position.z = 0;
      if (position.x < limiteBaseX) position.x = width;
      if (position.y < limiteHaut3D) position.y = limiteBas3D;
      if (position.x > width) position.x = limiteBaseX;
      if (position.y > (limiteBas3D)) position.y = limiteHaut3D;
    }else{
      if (position.x < 0) position.x = width;
      if (position.y < limiteHaut) position.y = limiteBas;
      if (position.x > width) position.x = 0;
      if (position.y > (limiteBas)) position.y = limiteHaut;
    }
  }
  

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Wind> winds) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0, 0);
    int count = 0;
    for (Wind other : winds) {
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
  
  void setEst3D(boolean i){
     this.est3D=i;
   }
  
}
