import java.util.Collections;

ArrayList<Tank> players = new ArrayList<Tank>();
Tank player1;
Tank player2;
Terrain l;
color backgroundColor = color(0);
color terrColor = color(200);
int tankTurn;
PFont symbol, constantia, stencil, sans;
int state;
PImage screenshot, right_pointer, left_pointer;


void setup() {
  state = 0;
  fullScreen();
  frameRate(60);
  symbol = loadFont("Symbol-48.vlw");
  constantia = loadFont("Constantia-48.vlw");
  stencil = loadFont("Stencil-48.vlw");
  sans = loadFont("LucidaSans-12.vlw");
  player1 = new Tank(0, 100, height - 10);
  player2 = new Tank(1, width - 100, height - 10);
  l = new Terrain(); // l is defined as the terrain shape
  players.add(player1);
  players.add(player2);
  Collections.shuffle(players);
  tankTurn = 0;
  screenshot = loadImage("tutorial_screen.png");
  right_pointer = loadImage("right_point.png");
  right_pointer.resize(50, 50);
  left_pointer = loadImage("left_point.png");
  left_pointer.resize(50, 50);
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
    textFont(constantia, 30);
    text("Play", width/2, height/5 + height/6);
    text("How to Play", width/2, height/5 + height/3);
    text("Credits", width/2, height/5 + height/2);
    text("Quit", width/2, height/5 + height/1.5);
    textFont(stencil, 64);
    text("TANK BATTLE", width/2, height/5);
  }
  
  else if (state == 1) {  // the game state
    background(backgroundColor);
    l.display();
    players.get(tankTurn).update();
    HUD(players);
    float p = mag(players.get(tankTurn).power.x, players.get(tankTurn).power.y);
    textFont(symbol, 16);
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

    if (players.get(tankTurn).bullets.size() > 0) {
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
    
    if (players.get(tankTurn).bullets_from_bullets.size() > 0) {
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
    textFont(stencil, 64);
    int i;
    for (i = 0; !players.get(i).isAlive; i++) {
      continue;
    }
    fill(0, 255, 0);
    text("Player " + (players.get(i).id + 1) + " wins!", width/2, height/3);
    fill(255, 0, 0, 150);
    rectMode(CENTER);
    rect(width/2, height/5 + height/2, width/5, height/10);
    textFont(symbol, 30);
  }
  
  else if (state == 3) { //How to Play menu (Page 1)
    textAlign(CENTER, CENTER);
    background(250);
    fill(0);
    textFont(stencil, 50);
    text("OBJECTIVE", width/2, height/10);
    textFont(stencil, 30);
    text("The goal of the game is to be the last tank standing! Everyone around you is your enemy.", width/2, height/5);
    text("Tough the rugged terrain and attack your opponents to reduce their health total to 0!", width/2, height/4);
    textLeading(40);
    text("Controls:\nA: Move to the left\nD: Move to the right\nQ: Select the previous weapon in your inventory\nE: Select the next weapon in your inventory\nUP/DOWN arrow keys: Rotate your tank nozzle\nLEFT/RIGHT arrow keys: Change how fast your shot is fired from the nozzle", width/2, height/2);
    text("NEXT PAGE", width*9/10, height*19/20); 
    text("BACK TO MAIN MENU", width/2, height*19/20);
    image(right_pointer, 1525, 830);
}
  
  else if (state == 4) { //How to Play menu (Page 2)
    textAlign(LEFT, TOP);
    background(250);
    image(screenshot, 400, 225);
    stroke(255,0,0);
    strokeWeight(2);
    noFill();
    ellipseMode(CORNERS);
    ellipse(430, 540, 660, 600);
    line(330, 570, 430, 570);
    ellipse(430, 600, 660, 660);
    line(330, 630, 430, 630);
    ellipse(935, 577, 1170, 637);
    line(1170, 607, 1270, 607);
    ellipse(670, 563, 930, 653);
    line(800, 653, 800, 753);
    fill(0);
    textFont(sans, 12);
    text("Health: This is your current health total.\nDon't let it go down to 0!", 178, 560);
    text("Fuel: You lose fuel as you move and once it reaches\n0, you're stuck! It refills every turn, though.", 90, 620);
    text("This displays the name of the weapon\nyou currently have equipped.", 1275, 607);
    text("Click here to fire your weapon against your opponent! Doing so ends your turn.", 600, 770);
    textFont(stencil, 30);
    text("PREVIOUS PAGE", 60, 845);
    textAlign(CENTER, CENTER);
    text("BACK TO MAIN MENU", width/2, height*19/20);
    textAlign(LEFT, TOP);
    textFont(sans, 18);
    fill(255);
    text("The map is where all tanks travel. You will always move along the terrain.", 530, 300);
    image(left_pointer, 10, 830);
  } 
  
  else if (state == 5) {
    background(250);
    fill(0);
    textFont(symbol, 48);
    textAlign(CENTER, CENTER);
    textLeading(150);
    text("Developed by: Jonah Fourchalk\nWith inspiration from: ShellShock Live by KChamp Games", width/2, 200);
    textLeading(50);
    textFont(symbol, 36);
    text("Thank you to my brother, Patrick, for helping me out with this project\nand my family for supporting me from across the country.", width/2, 550);
    textFont(stencil, 30);
    text("BACK TO MAIN MENU", width/2, height*19/20);
  }
}
    
void keyPressed() {  
  if (state == 1) {  
    if (players.get(tankTurn).bullets.size() == 0 && players.get(tankTurn).projectiles.size() == 0 && players.get(tankTurn).bullets_from_bullets.size() == 0) {  
      players.get(tankTurn).setMove(keyCode, true);
      /*if (key == 's' || key == 'S') {  
        players.get(tankTurn).setMove('d', false);  
        players.get(tankTurn).setMove('a', false);  
        players.get(tankTurn).setMove(LEFT, false);  
        players.get(tankTurn).setMove(RIGHT, false);  
        players.get(tankTurn).setMove(UP, false);  
        players.get(tankTurn).setMove(DOWN, false);  
        players.get(tankTurn).setMove('q', false);  
        players.get(tankTurn).setMove('e', false);  
        players.get(tankTurn).shoot();  
      }*/
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
      }
      if (inventorySize <= 5) {
        player.fillInventory();
      }
    }
  }
}

//Why does this cause the status bars to glitch? update: glitch should be fixed now
void mouseClicked() {
  switch(state) {
    case 0:
      if (mouseX < 7*width/10 && mouseX > 3*width/10) {
        if (mouseY < 7*height/15 && mouseY > 4*height/15) {
          state = 1;
          break;
        }
        else if (mouseY < 7*height/12 && mouseY > 29*height/60) {
          state = 3;
        }
        else if (mouseY < 3*height/4 && mouseY > 13*height/20) {
          state = 5;
        }
        else if (mouseY < 11*height/12 && mouseY > 49*height/60) {
          exit();
        }
      }
    case 1:
      if (players.get(tankTurn).bullets.size() == 0 && players.get(tankTurn).projectiles.size() == 0 && players.get(tankTurn).bullets_from_bullets.size() == 0) {
        //allows the FIRE button to shoot your tank's weapon
        if (mouseX >= 11*width/30 && mouseY >= 8*height/10 && mouseX <= 19*width/30 && mouseY <= 9*height/10) { 
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
    case 3:
      if (mouseX >= width*17/20 && mouseY >= 780) {
        state = 4;
      }
      if (mouseX <= width*3/5 && mouseX >= width*2/5 && mouseY >= 780) {
        state = 0;
      }
    case 4:
      if (mouseX <= 300 && mouseY >= 780) {
        state = 3;
      }
      if (mouseX <= width*3/5 && mouseX >= width*2/5 && mouseY >= 780) {
        state = 0;
      }
    case 5:
      if (mouseX <= width*3/5 && mouseX >= width*2/5 && mouseY >= 780) {
        state = 0;
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
  textFont(symbol, 30);
  String hpMessage = "Health: " + str(player.health) + "/" + str(player.maxHealth);
  String fuelMessage = "Fuel: " + str(player.fuel) + "/" + str(player.maxFuel);
  text(hpMessage, 11*width/60, 11*height/15);
  text(fuelMessage, 11*width/60, 13*height/15);
  
  // Fire button
  fill(player.c);
  rect(11*width/30, 8*height/10, 19*width/30, 9*height/10);
  textAlign(CENTER, CENTER);
  textFont(stencil, 60);
  fill(0);
  text("F I R E", width/2, 17*height/20);
  
  // Weapon select
  fill(0);
  rect(21*width/30, 8*height/10, 14*width/15, 9*height/10);
  fill(255);
  textFont(stencil, 45);
  text(player.weapons.get(player.selection).name, 49*width/60, 17*height/20);
}
