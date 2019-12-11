import java.util.Collections;

ArrayList<Tank> players = new ArrayList<Tank>();
Tank player1;
Tank player2;
Terrain l;
color backgroundColor = color(0);
color terrColor = color(200);
int tankTurn;
PFont f;
int state;

void setup() {
  state = 0;
  fullScreen();
  frameRate(60);
  f = loadFont("Symbol-48.vlw");
  player1 = new Tank(0, 100, height - 10);
  player2 = new Tank(1, 150, height - 10);
  l = new Terrain(); // l is defined as the terrain shape
  players.add(player1);
  players.add(player2);
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
    HUD(players);
    float p = mag(players.get(tankTurn).power.x, players.get(tankTurn).power.y);
    textFont(f, 16);
    textAlign(CENTER);
    rectMode(CORNER);
    fill(255);
    if (players.get(tankTurn).bullets.size() == 0 && players.get(tankTurn).bullets_from_bullets.size() == 0 && players.get(tankTurn).projectiles.size() == 0) {
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
      t.wUpdate(); //update weapons for that Tank
    }
    
    if (players.get(tankTurn).bullets.size() > 0) { // a player's turn can only be completed if their final bullet is consumed so this check is necessary
      for (int i = 0; i < players.get(tankTurn).bullets.size(); i++) {
        if (!players.get(tankTurn).bullets.get(0).inFlight) {
          players.get(tankTurn).bullets.remove(i);
        }
      }
      if (players.get(tankTurn).bullets.size() + players.get(tankTurn).bullets_from_bullets.size() == 0) {
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
    
    if (players.get(tankTurn).bullets_from_bullets.size() > 0) { // a player's turn can only be completed if their final bullet is consumed so this check is necessary
      for (int i = 0; i < players.get(tankTurn).bullets_from_bullets.size(); i++) {
        if (!players.get(tankTurn).bullets_from_bullets.get(0).inFlight) {
          players.get(tankTurn).bullets_from_bullets.remove(i);
        }
      }
      if (players.get(tankTurn).bullets.size() + players.get(tankTurn).bullets_from_bullets.size() == 0) {
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
    
  }
    
  else if (state == 2) { // The game over state
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
    Tank player = players.get(tankTurn);
    player.setMove(keyCode, false);
    if (keyCode == 'Q' || keyCode == 'q' || keyCode == 'E' || keyCode == 'e' ) {
      int inventorySize = player.weapons.size();
      if (keyCode == 'Q' || keyCode == 'q') {
        player.selection++;
      } else {
        player.selection--;
      }
      if (player.selection < 0) {
        player.selection = inventorySize - 1;
      }
      if (player.selection >= inventorySize) {
        player.selection = 0;
        println("SELECTION REVERSED");
      }
      if (inventorySize <= 5) {
        player.fillInventory();
      }
    }
  }
}

//q: Why does this cause the status bars to glitch? update: glitch should be fixed now
void mouseClicked() {
  switch(state) {
    case 0:
      if (mouseX < 7*width/10 && mouseX > 3*width/10) {
        if (mouseY < 14*height/30 && mouseY > 8*height/30) {
          state = 1;
          break;
        }
      }
  }
}

void HUD(ArrayList<Tank> players) {
  Tank player = players.get(tankTurn);
  rectMode(CORNERS);
  fill(175);
  rect(0, 7*height/10, width, height);
  
  // Status bars
  stroke(0);
  strokeWeight(1);
  rect(width/15, 23*height/30, 9*width/30, 12*height/15);
  rect(width/15, 27*height/30, 9*width/30, 14*height/15);
  fill(0, 255, 0);
  rect(width/15, 23*height/30, map(player.health, 0, player.maxHealth, width/15, 9*width/30), 12*height/15);
  fill(0, 0, 255);
  rect(width/15, 27*height/30, map(player.fuel, 0, player.maxFuel, width/15, 9*width/30), 14*height/15);
  fill(0);
  textAlign(CENTER, CENTER);
  textFont(f, 30);
  String hpMessage = "Health: " + str(player.health) + "/" + str(player.maxHealth);
  String fuelMessage = "Fuel: " + str(player.fuel) + "/" + str(player.maxFuel);
  text(hpMessage, 11*width/60, 11*height/15);
  text(fuelMessage, 11*width/60, 13*height/15);
  
  // Fire button
  fill(player.c);
  rect(11*width/30, 8*height/10, 19*width/30, 9*height/10);
  textAlign(CENTER, CENTER);
  textFont(f, 60);
  fill(0);
  text("F I R E", width/2, 17*height/20);
  
  // Weapon select
  fill(0);
  rect(21*width/30, 8*height/10, 14*width/15, 9*height/10);
  fill(255);
  text(player.weapons.get(player.selection).name, 49*width/60, 17*height/20);
}
