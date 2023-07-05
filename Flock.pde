// The Flock (a list of Boid objects)

class Flock {
  boolean est3D=false;
  float multiSeq;
  float multiCoh;
  float multiAli;
  float maxspeed;
  float multisurvive;
  float multiWind;

  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<Predator> predators;
  ArrayList<Wind> winds;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    predators = new ArrayList<Predator>();
    winds = new ArrayList<Wind>();
  }

  void run() {
    for (Boid b : boids) {
      verifBoid(b);
      b.run(boids, predators, winds);  // Passing the entire list of boids to each boid individually
    }
    for(Predator p : predators){
      verifPredator(p);
      p.run(boids); 
    }
    for(Wind w : winds){
      verifWind(w);
      w.run(winds); 
    }
  }

  void addBoid(Boid b) {
    b.setSeq(multiSeq);
    b.setCoh(multiCoh);
    b.setAli(multiAli);
    b.setMaxSpeed(maxspeed);
    b.setEst3D(est3D);
    boids.add(b);
  }
  
  void addPredator(Predator p){
    p.setMaxSpeed(maxspeed);
    p.setEst3D(est3D);
    predators.add(p);
  }
  
  void addWind(Wind w){
    w.setEst3D(est3D);
    winds.add(w);
  }
  
  void verifBoid(Boid b){
      if(this.multiSeq!=b.multiSeq){
        b.setSeq(multiSeq);
      }
      if(this.multiCoh!=b.multiCoh){
        b.setCoh(multiCoh);
      }
      if(this.multiAli!=b.multiAli){
        b.setAli(multiAli);
      }
      if(this.maxspeed!=b.maxspeed){
        b.setMaxSpeed(maxspeed);
      }
      if(this.multisurvive!=b.maxspeed){
        b.setSurvive(multisurvive);
      }
      if(this.multiWind!=b.multiWind){
        b.setWind(multiWind);
      }
      if(this.est3D!=b.est3D){
       b.setEst3D(est3D);
     }
  }
  
  void verifPredator(Predator p){
    if(this.maxspeed!=p.maxspeed){
        p.setMaxSpeed(maxspeed);
      }
     if(this.est3D!=p.est3D){
       p.setEst3D(est3D);
     }
  }
  
  void verifWind(Wind w){
    if(this.est3D!=w.est3D){
       w.setEst3D(est3D);
     }
  }
  
  void suppWinds(){
      this.winds.clear();
  }
  
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
     this.multisurvive=i; 
  }
  
  void setWind(float i){
     this.multiWind=i; 
  }
  
  void setEst3D(boolean i){
     this.est3D=i;
  }

}
