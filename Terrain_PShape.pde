public class Terrain {

  PShape terrain;
  float yoff = 0;
  float xoff = 0;
  
  public Terrain() {
    terrain = createShape();
    terrain.setFill(0);
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
  
  void display() {
    shape(terrain);
  }
}
