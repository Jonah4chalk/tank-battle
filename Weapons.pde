public abstract class Weapon {
  private PVector loc;
  private PVector vel;
  private PVector acc;
  boolean inFlight, exploding = false, damaging = false;
  float explOpacity = 255;
  color explColor;
  float explSize;
  float weapSize;
  int damage;
  PGraphics dmgNum;
  ArrayList<Tank> hit = new ArrayList<Tank>(0);
  
  public Weapon(PVector location, PVector velocity) {
    this.loc = location;
    this.vel = velocity;
    this.acc = new PVector(0, 0.1); //gravity
    inFlight = true;
  }
  
  abstract void display();
  abstract void update(ArrayList<Tank> players);
  abstract void explode(ArrayList<Tank> players);
  
  public PVector getVelocity() {
    return this.vel;
  }
  
  public PVector getLocation() {
    return this.loc;
  }
  
  public PVector getAcceleration() {
    return this.acc;
  }
  
  public void setVelocity(PVector newVel) {
    this.vel = newVel;
  }
  
  public void setLocation(PVector newLoc) {
    this.loc = newLoc;
  }
  
  public void setAcceleration(PVector newAcc) {
    this.acc = newAcc;
  }
}

//************************************************************//
//*************************** SHOT ***************************//
//************************************************************//

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
      damaging = true;
    }
    
    if (exploding) {
      fill(explColor, explOpacity);
      ellipse(getLocation().x, getLocation().y, explSize, explSize);
      if (damaging) {
        for (Tank tank: players) {
          if (getLocation().x + explSize/2 >= tank.b.getVertex(0).x &&
          getLocation().x - explSize/2 <= tank.b.getVertex(2).x &&
          getLocation().y + explSize/2 >= tank.b.getVertex(0).y &&
          getLocation().y - explSize/2 <= tank.b.getVertex(2).y) { // standard collision physics - very copypasteable
            tank.health -= damage;
            hit.add(tank);
            damaging = false;
            dmgNum = createGraphics(20, 20);
            dmgNum.beginDraw();
            dmgNum.stroke(0);
            dmgNum.fill(255);
            dmgNum.textFont(f, 14);
            dmgNum.textAlign(CENTER, CENTER);
            dmgNum.text(damage, 10, 10);
            dmgNum.endDraw();
          }
        }
      } else {
        dmgNum.beginDraw();
        dmgNum.fill(0, 6);
        dmgNum.textFont(f, 14);
        dmgNum.text(damage, 10, 10);
        dmgNum.endDraw();
        for (Tank tank: hit) { 
          image(dmgNum, tank.x - 10, 
          tank.y - 50);
        }
      }
    } else {
      strokeWeight(1);
      stroke(0);
      ellipse(getLocation().x, getLocation().y, weapSize, weapSize);
    }
    //println(getLocation().x, getLocation().y);
  }
  
  void update(ArrayList<Tank> players) {
    if (exploding) {
      if (explOpacity <= 0) {
        inFlight = false;
      } else {
        explOpacity -= 2;
      }
    } else {
      getLocation().add(getVelocity());
      getVelocity().add(getAcceleration());
      //println(int(loc.x + (loc.y*width)));
      loadPixels();
      PVector NormVelocity = new PVector();
      NormVelocity = getVelocity().normalize(null);
      NormVelocity.setMag(weapSize/2);
      color detector = get(int(getLocation().x + NormVelocity.x), int(getLocation().y + NormVelocity.y));
      /* stroke(123, 254, 39);
      ellipse(int(getLocation().x + NormVelocity.x), int(getLocation().y + NormVelocity.y), 5, 5);
      stroke(0); */
      if (getLocation().x < 0 || getLocation().x > width || getLocation().y > height) {
        inFlight = false;
      }
      else if (getLocation().y < 0) { // prevents detector from trying to check colors offscreen
        inFlight = true;
      }
      else {
        for (Tank t: players) {
          if ((getLocation().x + weapSize/2 > t.b.getVertex(0).x) 
          && (getLocation().x - weapSize/2 < t.b.getVertex(2).x) 
          && (getLocation().y + weapSize/2 > t.b.getVertex(0).y) 
          && (getLocation().y - weapSize/2 < t.b.getVertex(2).y)) { 
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
    ellipse(getLocation().x, getLocation().y, explSize, explSize);
    l.update(explColor);
    exploding = true;
  }
}

class BigShot extends Shot {
  
  BigShot(PVector loc, PVector vel) {
    super(loc, vel);
    explColor = color(255);
    explSize = 18;
    weapSize = 9;
    damage = 15;
  }
}

class HeavyShot extends Shot {
  
  HeavyShot(PVector loc, PVector vel) {
    super(loc, vel);
    explColor = color(255);
    explSize = 25;
    weapSize = 13;
    damage = 20;
  }
}

class MassiveShot extends Shot {
  
  MassiveShot(PVector loc, PVector vel) {
    super(loc, vel);
    explColor = color(255);
    explSize = 35;
    weapSize = 20;
    damage = 30;
  }
}

//************************************************************//
//****************************FLARE***************************//
//************************************************************//
/*
class Flare extends Weapon {
  
  Flare(PVector loc, PVector vel) {
    super(loc, vel);
    explColor = color(255);
    explSize = 0;
    weapSize = 8;
    damage = 0;
  }
  
  void display() {
    ellipseMode(CENTER);
    fill(255);
    
  }
  
  void update(ArrayList<Tank> players) {
    if (exploding) {
      if (explOpacity <= 0) {
        inFlight = false;
      } else {
        explOpacity -= 2;
      }
    } 
    else {
      getLocation().add(getVelocity());
      getVelocity().add(getAcceleration());
      //println(int(loc.x + (loc.y*width)));
      loadPixels();
      color detector = get(int(getLocation().x), int(getLocation().y));
      if (getLocation().x < 0 || getLocation().x > width || getLocation().y > height) {
        inFlight = false;
      }
      else if (getLocation().y < 0) { // prevents detector from trying to check colors offscreen
        inFlight = true;
      }
      else {
          if (exploding == false) {
            if (detector == terrColor) {
              
          }
        }
      }
    }
  }
  
  void explode(ArrayList<Tank> players) {
    
  }
} */
