Tank[] players = new Tank[2];
Tank tester;
Tank opponent;
Terrain ground;
color backgroundColor = color(230);
PVector a = new PVector(0, 0);
int tankTurn;

void setup() {
  fullScreen();
  frameRate(60);
  background(backgroundColor);
  tester = new Tank(1, 100, 100);
  opponent = new Tank(2, 150, 100);
  ground = new Terrain();
  players[0] = tester;
  players[1] = opponent;
  tankTurn = 0;
}


void draw() {
  background(backgroundColor);
  ground.display();
  for (Tank t: players) {
    t.update();
    t.display();
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
      players[tankTurn].shoot();
    }
  }
}

void keyReleased() {
  players[tankTurn].setMove(keyCode, false);
}
