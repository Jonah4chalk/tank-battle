public abstract class Weapon {
  PVector loc;
  PVector vel;
  PVector acc;
  boolean inFlight;
  
  public Weapon(PVector location, PVector velocity) {
    loc = location;
    vel = velocity;
    acc = new PVector(0, 0.1); //gravity
    inFlight = true;
  }
  
  abstract void display();
  abstract void update();
  abstract void explode();
  
}

class Shot extends Weapon {
  
  Shot(PVector loc, PVector vel) {
    super(loc, vel);
  }
  
  void display() {
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(1);
    fill(255);
    ellipse(loc.x, loc.y, 5, 5);
    //println(loc.x, loc.y);
  }
  
  void update() {
    loc.add(vel);
    vel.add(acc);
    //println(int(loc.x + (loc.y*width)));
    loadPixels();
    color detector = get(int(loc.x), int(loc.y));
    if (loc.x < 0 || loc.x > width || loc.y > height) {
      inFlight = false;
    } 
    else if (loc.y < 0) {
      inFlight = true;
    }
    else if (detector != backgroundColor) {
      explode();
    }
  }
  
  void explode() {
    fill(255, 0, 0);
    ellipse(loc.x, loc.y, 20, 20);
    delay(500);
    inFlight = false;
  }
}
