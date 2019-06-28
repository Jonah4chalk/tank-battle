// this would all go in one state of a state machine eventually
import java.util.Collections;

ArrayList<Tank> players = new ArrayList<Tank>();
Tank tester;
Tank opponent;
Terrain l;
color backgroundColor = color(0);
color terrColor = color(200);
int tankTurn;
PFont f;
int state;

void setup() {
  state = 1;
  fullScreen();
  frameRate(60);
  f = loadFont("Symbol-48.vlw");
  tester = new Tank(0, 100, height - 10);
  opponent = new Tank(1, 150, height - 10);
  l = new Terrain();                                // l is defined as the terrain shape
  players.add(tester);
  players.add(opponent);
  Collections.shuffle(players);
  tankTurn = 0;
}


void draw() {
  if (state == 0) {  // the home screen state
    strokeWeight(1);
    stroke(0);
    rectMode(CENTER);
    background(250);
    fill(255, 0, 0, 150);
    rect(width/2, height/5 + height/6, width/5, height/10);
    rect(width/2, height/5 + height/3, width/5, height/10);
    rect(width/2, height/5 + height/2, width/5, height/10);
    rect(width/2, height/5 + height/1.5, width/5, height/10);
    fill(0);
    textAlign(CENTER, CENTER);
    textFont(f, 30);
    text("Play", width/2, height/5 + height/6);
    text("How to Play", width/2, height/5 + height/3);
    text("Credits", width/2, height/5 + height/2);
    text("Quit", width/2, height/5 + height/1.5);
    textFont(f, 64);
    text("Insert Game Title Here", width/2, height/5);
  }
  else if (state == 1) {  // the game state
    background(backgroundColor);
    l.display();
    players.get(tankTurn).update();
    float p = mag(players.get(tankTurn).power.x, players.get(tankTurn).power.y);
    textFont(f, 16);
    textAlign(CENTER);
    fill(255);
    if (players.get(tankTurn).bullets.size() == 0 && players.get(tankTurn).projectiles.size() == 0) {
      text(((players.get(tankTurn).currentNozzleAngle != 0) 
      ? -players.get(tankTurn).currentNozzleAngle : players.get(tankTurn).currentNozzleAngle) 
      + ", " + nfc(p, 1), players.get(tankTurn).center.x, players.get(tankTurn).center.y - 20);
    }
    for (int t = 0; t < players.size(); t++) {
      if (t != tankTurn) {
        players.get(t).update();
      }
    }
    for (Tank t: players) {
      t.wUpdate();
    }
    
    if (players.get(tankTurn).projectiles.size() > 0 && !players.get(tankTurn).projectiles.get(0).inFlight) {
      players.get(tankTurn).projectiles.remove(0);
    }
      
    else if (players.get(tankTurn).bullets.size() > 0 && !players.get(tankTurn).bullets.get(0).inFlight) {
      players.get(tankTurn).bullets.remove(0);
      int remaining = players.size();
      for (Tank t: players) {
        if (!t.isAlive) {
          remaining--;
        }
      }
      if (remaining <= 1) {
        state = 2;
      }
      tankTurn++;
      if (tankTurn >= players.size()) {
          tankTurn = 0;
      }
      while (!players.get(tankTurn).isAlive) {
        tankTurn++;
        if (tankTurn >= players.size()) {
          tankTurn = 0;
        }
      }
        players.get(tankTurn).fuel = players.get(tankTurn).maxFuel;
    }
  }
    
  else if (state == 2) {
    background(255);
    textFont(f, 64);
    int i;
    for (i = 0; !players.get(i).isAlive; i++) {
      continue;
    }
    fill(0, 255, 0);
    text("Player " + (players.get(i).id + 1) + " wins!", width/2, height/3);
    fill(255, 0, 0, 150);
    //rectMode(CENTER);
    //rect(width/2, height/5 + height/2, width/5, height/10);
  }
}
  
  void keyPressed() {
    if (state == 1) {
      if (players.get(tankTurn).bullets.size() == 0 && players.get(tankTurn).projectiles.size() == 0) {
        players.get(tankTurn).setMove(keyCode, true);
        if (key == 's' || key == 'S') {
          players.get(tankTurn).setMove('d', false);
          players.get(tankTurn).setMove('a', false);
          players.get(tankTurn).setMove(LEFT, false);
          players.get(tankTurn).setMove(RIGHT, false);
          players.get(tankTurn).setMove(UP, false);
          players.get(tankTurn).setMove(DOWN, false);
          players.get(tankTurn).setMove('q', false);
          players.get(tankTurn).setMove('e', false);
          players.get(tankTurn).shoot();
        }
      }
    }
  }

void keyReleased() {
  if (state == 1) {
    players.get(tankTurn).setMove(keyCode, false);
  }
}
