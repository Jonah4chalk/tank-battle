// this would all go in one state of a state machine eventually
import java.util.Collections;

ArrayList<Tank> players = new ArrayList<Tank>();
Tank tester;
Tank opponent;
Terrain l;
color backgroundColor = color(0);
color terrColor = color(240);
int tankTurn;
PFont f;

void setup() {
  fullScreen();
  frameRate(60);
  f = loadFont("Symbol-48.vlw");
  tester = new Tank(0, 100, height - 10);
  opponent = new Tank(1, 150, height - 10);
  l = new Terrain();
  players.add(tester);
  players.add(opponent);
  Collections.shuffle(players);
  tankTurn = 0;
}


void draw() {
  background(backgroundColor);
  l.display();
  players.get(tankTurn).update();
  float p = mag(players.get(tankTurn).power.x, players.get(tankTurn).power.y);
  textFont(f, 16);
  textAlign(CENTER);
  fill(255);
  if (players.get(tankTurn).bullets.size() == 0) {
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
  if (players.get(tankTurn).bullets.size() > 0) {
    if (!players.get(tankTurn).bullets.get(0).inFlight) {
      players.get(tankTurn).bullets.remove(0);
      tankTurn++;
      if (tankTurn >= players.size()) {
        tankTurn = 0;
      }
      players.get(tankTurn).fuel = 30;
    }
  }
}

void keyPressed() {
  if (players.get(tankTurn).bullets.size() == 0) {
    players.get(tankTurn).setMove(keyCode, true);
    if (key == 's' || key == 'S') {
      players.get(tankTurn).setMove('d', false);
      players.get(tankTurn).setMove('a', false);
      players.get(tankTurn).setMove(LEFT, false);
      players.get(tankTurn).setMove(RIGHT, false);
      players.get(tankTurn).setMove(UP, false);
      players.get(tankTurn).setMove(DOWN, false);
      players.get(tankTurn).shoot();
    }
  }
}

void keyReleased() {
  players.get(tankTurn).setMove(keyCode, false);
}
