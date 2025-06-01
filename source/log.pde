class log
{
  String text;
  PVector shape;
  PVector position;
  float originalHeight;
  
  log(String text, PVector position)
  {
    this.text = text;
    this.shape = new PVector(250,100);
    this.position = position;
    originalHeight = position.y;
  }
  
  void render(color COLOR_0, color COLOR_1, color COLOR_2, color COLOR_3)
  {
    rectMode(CENTER);
    stroke(COLOR_0);
    fill(COLOR_2);
    rect(position.x, position.y, shape.x, shape.y);
    
    fill(COLOR_0);
    textSize(20);
    text(text, position.x, position.y, shape.x - 25, shape.y - 10);
  }
  
}
