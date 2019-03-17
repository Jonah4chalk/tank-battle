public class Tank {
  ArrayList<Weapon> bullets = new ArrayList();
  boolean isLeft, isRight, rotLeft, rotRight, powerUp, powerDown, isShooting;
  color c;
  PVector power, center, noz, nozVec;
  PShape t;
  PShape b;
  PShape n;
  int x, y;
  final int speed = 1, aChange = 1;
  final float powerChange = 0.02;
  float currentNozzleAngle = 0;
  int id;
  
  Tank(int Id, int xpos, int ypos) {
    id = Id;
    x = xpos;
    y = ypos;
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
    t = createShape(GROUP); // tank shape contains nozzle and body
    n = createShape(); // nozzle shape
    n.beginShape();
    n.vertex(center.x, noz.y - 1);
    n.vertex(center.x, noz.y + 1);
    n.vertex(noz.x, noz.y + 1);
    n.vertex(noz.x, noz.y - 1);
    n.endShape(CLOSE);
    n.setFill(c);
    b = createShape();
    b.beginShape(); // body shape
    b.vertex(x - 15, y - 6);
    b.vertex(x + 15, y - 6);
    b.vertex(x + 15, y + 6);
    b.vertex(x - 15, y + 6);
    b.endShape(CLOSE);
    b.setFill(c);
    t.addChild(n);
    t.addChild(b);
  }
  
  boolean setMove(int k, boolean b) {
    switch(k) {
      case 'A':
      case 'a':
        return isRight = b;
   
      case 'D':
      case 'd':
        return isLeft = b;
        
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
    x = constrain(x + speed*(int(isLeft) - int(isRight)), 6, width - 6);
    currentNozzleAngle += aChange*(int(rotRight) - int(rotLeft));
    power.x = constrain(power.x + (powerChange*(int(powerUp) - int(powerDown))), powerChange, 25);
    
    loadPixels();
    // uses color detection to keep the tank on top of the 'ground' which is black
    color black = color(0);
    while ((x + ((y + 6)*width) < pixels.length) && (pixels[(y+6)*width + x] == backgroundColor)) {
      y++;
    } 
    color above = get(x, y + 5);
    while ((x + (y*width) > 0) && (above == black)) {
      y--;
      above = get(x, y + 5);
    }
    updatePixels();
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
    // keeps the nozzle the same shape as it rotates
    if (id == tankTurn && bullets.size() == 0) {
      float p = mag(power.x, power.y);
      textFont(f, 16);
      textAlign(CENTER);
      fill(255);
      text(((currentNozzleAngle != 0) ? -currentNozzleAngle : currentNozzleAngle) + ", " + nfc(p, 1), center.x, center.y - 20);
    }
    strokeWeight(0);
    shape(t);
  }  
  
  // calls the function that updates any bullets that are in the air
  void wUpdate() {
    for (Weapon w: bullets) {
      w.update();
      strokeWeight(1);
      w.display();
    }
  }
  
  //pushes a new bullet into existence when a tank fires
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
    bullets.add(new Shot(nozVec, velocity));
  }
}
