Tank[] players = new Tank[2];
Tank tester;
Tank opponent;
Terrain ground;
color backgroundColor = color(160, 231, 237);
PVector a = new PVector(0, 0);
int tankTurn;
PFont f;

void setup() {
  fullScreen();
  frameRate(60);
  background(backgroundColor);
  f = loadFont("Symbol-48.vlw");
  tester = new Tank(0, 100, 100);
  opponent = new Tank(1, 150, 100);
  ground = new Terrain();
  players[0] = tester;
  players[1] = opponent;
  tankTurn = 0;
}


void draw() {
  background(backgroundColor);
  ground.display();
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
