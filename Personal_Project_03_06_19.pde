// this would all go in one state of a state machine eventually

Tank[] players = new Tank[2];
Tank tester;
Tank opponent;
Terrain l;
color backgroundColor = color(160, 231, 237);
int tankTurn;
PFont f;

void setup() {
  fullScreen();
  frameRate(60);
  f = loadFont("Symbol-48.vlw");
  tester = new Tank(0, 100, height - 10);
  opponent = new Tank(1, 200, height - 10);
  l = new Terrain();
  players[0] = tester;
  players[1] = opponent;
  tankTurn = 0;
}


void draw() {
  background(backgroundColor);
  l.display();
  players[tankTurn].update();
  for (int t = 0; t < players.length; t++) {
    if (t != tankTurn) {
      players[t].update();
    }
  }
  for (Tank t: players) {
    t.wUpdate();
  }
  if (players[tankTurn].bullets.size() > 0) {
    if (!players[tankTurn].bullets.get(0).inFlight) {
      players[tankTurn].bullets.remove(0);
      tankTurn++;
      if (tankTurn >= players.length) {
        tankTurn = 0;
      }
    }
  }
}

void keyPressed() {
  if (players[tankTurn].bullets.size() == 0) {
    players[tankTurn].setMove(keyCode, true);
    if (key == 's' || key == 'S') {
      players[tankTurn].setMove('d', false);
      players[tankTurn].setMove('a', false);
      players[tankTurn].setMove(LEFT, false);
      players[tankTurn].setMove(RIGHT, false);
      players[tankTurn].setMove(UP, false);
      players[tankTurn].setMove(DOWN, false);
      players[tankTurn].shoot();
    }
  }
}

void keyReleased() {
  players[tankTurn].setMove(keyCode, false);
}
