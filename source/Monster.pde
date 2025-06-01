class Monster
{
  PVector position;
  PVector scale;
  PImage sprite;
  int spot;
  boolean left;
  int startFrame;
  globalVariables globals;
  
  Monster(PVector scale, int spot, PImage sprite, globalVariables globals)
  {
    this.scale = scale;
    this.spot = spot;
    this.sprite = sprite;
    this.globals = globals;
    if (spot % 2 == 1)
    left = true;
    
    switch(spot)
    {
      default:
      break;
      
      case 1:
      this.position = new PVector(600,650);
      break;
      
      case 2:
      this.position = new PVector(1050,650);
      break;
      
      case 3:
      this.position = new PVector(600,250);
      break;
      
      case 4:
      this.position = new PVector(1050,650);
      break;
      
      case 5:
      this.position = new PVector(600,650);
      break;
    }
    int startFrame = globals.framesPlaying;
  }
  
  void render(PVector _position)
  {
    _position = new PVector();
    if (globals.framesPlaying > startFrame + 15)
    {
      if (left)
      {
        pushMatrix();
        scale(-1, 1);
        translate( -position.x - _position.x, position.y + _position.y);
        image(sprite, 0, 0, scale.x, scale.y);
        popMatrix();
        position.x -= 10;
      }
      else
      {
        image(sprite, position.x + _position.x, position.y + _position.y, scale.x, scale.y);
        position.x += 10;
      }
    }
    
    
  }
  
}
