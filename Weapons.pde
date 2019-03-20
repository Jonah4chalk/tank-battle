public abstract class Weapon {
  PVector loc;
  PVector vel;
  PVector acc;
  boolean inFlight, exploding = false;
  float explOpacity = 255;
  color explColor;
  float explSize;
  float weapSize;
  int damage;
  
  public Weapon(PVector location, PVector velocity) {
    loc = location;
    vel = velocity;
    acc = new PVector(0, 0.1); //gravity
    inFlight = true;
  }
  
  abstract void display();
  abstract void update(ArrayList<Tank> players);
  abstract void explode(ArrayList<Tank> players);
}

class Shot extends Weapon {
  
  Shot(PVector loc, PVector vel) {
    super(loc, vel);
    explColor = color(255);
    explSize = 10;
    weapSize = 5;
    damage = 10;
  }
  
  void display() {
    ellipseMode(CENTER);
    fill(255);
    if (exploding && explOpacity == 255) {
      l.update(explColor);
    }
    if (exploding) {
      fill(explColor, explOpacity);
      ellipse(loc.x, loc.y, explSize, explSize);
    } else {
      strokeWeight(1);
      stroke(0);
      ellipse(loc.x, loc.y, weapSize, weapSize);
    }
    //println(loc.x, loc.y);
  }
  
  void update(ArrayList<Tank> players) {
    if (exploding) {
      if (explOpacity <= 0) {
        inFlight = false;
      } else {
        explOpacity -= 2;
      }
    } else {
      loc.add(vel);
      vel.add(acc);
      //println(int(loc.x + (loc.y*width)));
      loadPixels();
      color detector = get(int(loc.x), int(loc.y));
      if (loc.x < 0 || loc.x > width || loc.y > height) {
        inFlight = false;
      } 
      else if (loc.y < 0) { // prevents detector from trying to check colors offscreen
        inFlight = true;
      }
      else {
        for (Tank t: players) {
          if ((loc.x + weapSize/2 > t.b.getVertex(0).x) && (loc.x - weapSize/2 < t.b.getVertex(2).x) 
          && (loc.y + weapSize/2 > t.b.getVertex(0).y) && (loc.y - weapSize/2 < t.b.getVertex(2).y)) {
            explode(players);
            break;
          }
        }
        if (exploding == false) {
          if (detector == terrColor) {
            explode(players);
          }
        }
      }
    }
  }

  void explode(ArrayList<Tank> players) {
    fill(explColor, explOpacity);
    noStroke();
    ellipse(loc.x, loc.y, explSize, explSize);
    for (Tank tank: players) {
      if (loc.x + explSize/2 >= tank.b.getVertex(0).x && loc.x - explSize/2 <= tank.b.getVertex(2).x && loc.y + explSize/2 >= tank.b.getVertex(0).y && loc.y - explSize/2 <= tank.b.getVertex(2).y) {
        tank.health -= 10;
      }
    }
    exploding = true;
  }
}
