public class Terrain {

  PShape terrain;
  float yoff = 0;
  float xoff = 0;
  
  Terrain() {
    terrain = createShape();
    terrain.setFill(terrColor);
    terrain.beginShape();
    // Iterate over horizontal pixels
    for (float x = 0; x <= width; x++) {
      // Calculate a y value according to noise, map to 
      float y = map((noise(xoff, yoff)*height), 0, height, 10, height - 30);
      
      // Set the vertex
      terrain.vertex(x, y);
      // Increment x dimension for noise (this increases/decreases the "roughness" of the map
      xoff += 0.004;
    }
    // increment y dimension for noise
    yoff += 0.01;
    terrain.vertex(width, height);
    terrain.vertex(0, height);
    terrain.endShape(CLOSE);
  }
  
    void update(color explosion) {
    loadPixels();
    for (int w = 0; w <= width; w++) {
      int shift = 0;
      for (int i = int(terrain.getVertex(w).y); i < height - 1; i++) {
        if (pixels[(i*width) + w] == explosion) {
          shift++;
        }
        if (pixels[(i*width) + w] == terrColor && shift != 0) {
          break;
        }
      }
      terrain.setVertex(w, w, terrain.getVertex(w).y + shift);
    }
    updatePixels();
  }
  
  void display() {
    shape(terrain);
  }
}
