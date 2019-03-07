public class Tank {
  ArrayList<Weapon> bullets = new ArrayList();
  boolean isLeft, isRight, rotLeft, rotRight, isShooting;
  color c;
  PVector power, center, noz, nozVec;
  PShape t;
  PShape b;
  PShape n;
  int x, y; //position
  final int speed = 1;
  final int aChange = 1;
  float currentNozzleAngle = 0;
  
  Tank(int Id, int xpos, int ypos) {
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
    power = new PVector();
    strokeWeight(0);
    t = createShape(GROUP);
    n = createShape();
    n.beginShape();
    n.vertex(center.x, center.y - 1);
    n.vertex(center.x, center.y + 1);
    n.vertex(noz.x, noz.y + 1);
    n.vertex(noz.x, noz.y - 1);
    n.endShape(CLOSE);
    n.setFill(c);
    b = createShape();
    b.beginShape();
    b.vertex(center.x - 15, center.y - 6);
    b.vertex(center.x + 15, center.y - 6);
    b.vertex(center.x + 15, center.y + 6);
    b.vertex(center.x - 15, center.y + 6);
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
        
      default:
        return b;
    }
  }
  
  void display() {
    strokeWeight(0);
    shape(t);
  }
  
  void update() {
    x = constrain(x + speed*(int(isLeft) - int(isRight)), 6, width - 6);
    currentNozzleAngle += aChange*(int(rotRight) - int(rotLeft));
    loadPixels();
    color black = color(0);
    color below = get(x, y + 6);
    while ((x + ((y + 6)*width) < pixels.length) && (below == backgroundColor || below == color(255, 255, 0) || below == color(0, 255, 0) || below == color(255, 0, 0) || below == color(0, 0, 255))) {
      y++;
      below = get(x, y + 6);
    } 
    color above = get(x, y);
    while ((x + (y*width) > 0) && (above == black || above == color(255, 255, 0) || above == color(0, 255, 0) || above == color(255, 0, 0) || above == color(0, 0, 255))) {
      y--;
      above = get(x, y);
    }
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
    updatePixels();
    for (Weapon w: bullets) {
      w.update();
      w.display();
    }
  }  
  
  void shoot() { //pos1 is the position of the nozzle end
    PVector power = new PVector(4, 0);
    float nx, ny;
    float sinAngle = sin(radians(currentNozzleAngle));
    float cosAngle = cos(radians(currentNozzleAngle));
    nx = power.x*cosAngle;
    ny = power.x*sinAngle;
    nozVec.x = nx;
    nozVec.y = ny;
    // println(power); power is the vector that the projectile initially travels
    bullets.add(new Shot(nozVec, power));
  }
}
