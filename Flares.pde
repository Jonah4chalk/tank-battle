int y_speed = 0;
int x_speed = 10;
int gravity = 1;
int h = 200;
int w = width/2;

void setup() {
  fullScreen();
  frameRate(60);
  
}

void draw() {
  background(color(120));
  
  ellipse(w, h, 200, 200);
  y_speed = y_speed + gravity;
  h = h + y_speed;
  if (h >= height-100) {
    h = height-100;
    y_speed = -1 * y_speed;
  }
  
  w = w + x_speed;
  if (w <= 100 || w >= width-100) {
    if (w <= 100) {
      w = 100;
    }
    else {
      w = width-100;
    }
    x_speed = -1 * x_speed;
  }
  
  loop();
}
