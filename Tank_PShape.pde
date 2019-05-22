public class Tank {
  ArrayList<Weapon> bullets = new ArrayList<Weapon>();
  ArrayList<Weapon> inventory = new ArrayList<Weapon>();
  int selection = 0;
  boolean isLeft, isRight, rotLeft, rotRight, powerUp, powerDown, isShooting, selectPrev, selectNext, isAlive;
  color c;
  PVector power, center, noz, nozVec;
  PShape t;
  PShape b;
  PShape n;
  int x, y;
  final float aChange = 1, powerChange = 0.03;
  final int speed = 1;
  float currentNozzleAngle = 0;
  int id;
  int maxHealth, health, maxFuel, fuel;
  
  Tank(int Id, int xpos, int ypos) {
    id = Id;
    x = xpos;
    y = ypos;
    health = 100;
    maxHealth = health;
    fuel = 150;
    maxFuel = fuel;
    switch(Id % 4) {
      case 0:
        c = color(255, 255, 0);
        break;
      case 1:
        c = color(255, 0, 0);
        break;
      case 2:
        c = color(0, 255, 0);
        break;
      case 3:
        c = color(0, 0, 255);
        break;
      default:
        c = color(0);
        break;
    }
    center = new PVector(x, y);
    noz = new PVector(x + 25, y);
    nozVec = PVector.sub(noz, center);
    power = new PVector(5, 0);
    strokeWeight(0);
    t = createShape(GROUP);
    n = createShape();
    n.beginShape();
    n.vertex(center.x, noz.y - 1);
    n.vertex(center.x, noz.y + 1);
    n.vertex(noz.x, noz.y + 1);
    n.vertex(noz.x, noz.y - 1);
    n.endShape(CLOSE);
    n.setFill(c);
    b = createShape();
    b.beginShape();
    b.vertex(x - 15, y - 6);
    b.vertex(x + 15, y - 6);
    b.vertex(x + 15, y + 6);
    b.vertex(x - 15, y + 6);
    b.endShape(CLOSE);
    b.setFill(c);
    t.addChild(n);
    t.addChild(b);
    fillInventory();
  }
  
  boolean setMove(int k, boolean b) {
    switch(k) {
      case 'A':
      case 'a':
        return isRight = b;
   
      case 'D':
      case 'd':
        return isLeft = b;
        
      case 'Q':
      case 'q':
        return selectPrev = b;
        
      case 'E':
      case 'e':
        return selectNext = b;
      
      case LEFT:
        return rotLeft = b;
   
      case RIGHT:
        return rotRight = b;
        
      case UP:
        return powerUp = b;
        
      case DOWN:
        return powerDown = b;
        
      default:
        return b;
    }
  }
  
  void update() {
    
    //************************* POSITION *************************//
    if (currentNozzleAngle >= 360 || currentNozzleAngle <= -360) {
      currentNozzleAngle = 0;
    }
    power.x = constrain(power.x + (powerChange*(int(powerUp) - int(powerDown))), 0.1, 10);
    if (isLeft != isRight) {
      if (fuel == 0) {
        isLeft = false;
        isRight = false;
      } else {
        fuel--;
      }
    }
    x = constrain(x + speed*(int(isLeft) - int(isRight)), 12, width - 12);
    currentNozzleAngle += aChange*(int(rotRight) - int(rotLeft));
    y = int(l.terrain.getVertex(x).y);
    center.set(x, y);
    noz.set(x + 25, y);
    nozVec = PVector.sub(noz, center);
    float nx, ny;
    float sinAngle = sin(radians(currentNozzleAngle));
    float cosAngle = cos(radians(currentNozzleAngle));
    nx = nozVec.x*cosAngle - nozVec.y*sinAngle;
    ny = nozVec.x*sinAngle + nozVec.y*cosAngle;
    nozVec.x = nx;
    nozVec.y = ny;
    nozVec.add(center);
    //println(nozVec);
    //noLoop();
    b.setVertex(0, center.x - 15, center.y - 6);
    b.setVertex(1, center.x + 15, center.y - 6);
    b.setVertex(2, center.x + 15, center.y + 6);
    b.setVertex(3, center.x - 15, center.y + 6);
    n.setVertex(0, center.x + sinAngle, y - cosAngle);
    n.setVertex(1, center.x - sinAngle, y + cosAngle);
    n.setVertex(2, nozVec.x - sinAngle , nozVec.y + cosAngle);
    n.setVertex(3, nozVec.x + sinAngle, nozVec.y - cosAngle);
    noStroke();
    shape(t);
    
    //************************** STATUS BARS **************************//
    colorMode(HSB, 255, 255, 255);
    fill(health, 255, 255);
    noStroke();
    rect(center.x - 15, center.y - 15, map(health, 0, maxHealth, 0, 30), 3);
    fill(150, 255, 255);
    rect(center.x - 15, center.y - 12, map(fuel, 0, maxFuel, 0, 30), 3);
    isAlive = boolean(health);
    if (health <= 0) {
      health = 0;
      fuel = 0;
      b.setFill(color(120));
      n.setFill(color(120));
    }
    colorMode(RGB, 255, 255, 255);
    
    //************************* INVENTORY *************************//
    
    selection += int(selectNext) - int(selectPrev);
    if (selection < 0) {
        selection = inventory.size() - 1;
      }
    if (selection >= inventory.size()) {
        selection = 0;
      }
    if (inventory.size() <= 5) {
      fillInventory();
    }
    //println(fuel);
    //println(center.x);
  }  
  
  void wUpdate() {
    for (Weapon w: bullets) {
      w.update(players);
      strokeWeight(1);
      w.display();
    }
  }
  
  void shoot() { 
    PVector velocity = new PVector();
    velocity.set(power);
    float nx, ny;
    float sinAngle = sin(radians(currentNozzleAngle));
    float cosAngle = cos(radians(currentNozzleAngle));
    nx = velocity.x*cosAngle;
    ny = velocity.x*sinAngle;
    velocity.x = nx;
    velocity.y = ny;
    //velocity is the vector that the projectile initially travels
    Weapon b = inventory.get(selection);
    b.setLocation(nozVec);
    b.setVelocity(velocity);
    bullets.add(b);
    inventory.remove(selection);
  }
  
  void fillInventory() {
    for (int i = 0; i < 20; i++) { //max number is final inventory size
      int rand = int(random(4)); // for now this has to be equal to the number of weapons available
      Weapon w = new Shot(nozVec, power);
      switch(rand) { // this switch needs to contain every weapon
        case 0:
          w = new Shot(nozVec, power);
          break;
        case 1:
          w = new BigShot(nozVec, power);
          break;
        case 2:
          w = new HeavyShot(nozVec, power);
          break;
        case 3:
          w = new MassiveShot(nozVec, power);
          break;
      }
      inventory.add(w);
    }
  }
}
