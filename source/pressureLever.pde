class pressureLever extends clickableObject
{
  
  int pressureValue;
  boolean on = false;
  float originalHeight;
  SoundFile leverOn;
  SoundFile leverOff;
  
  
  pressureLever(String _name, PVector _shape, PVector _position, int _pressureValue)
  {
    super(_name, _shape, _position);
    originalHeight = _position.y;
    pressureValue = _pressureValue;
    
    leverOn = new SoundFile(globals.game, "switch_on.wav");
    leverOff = new SoundFile(globals.game, "switch_off.wav");

    
  }
  
  void onLeftClickReleased(PVector offset)
  {
    if(checkClickIntersection(offset))
    {
      on = !on;
      if (on)
      leverOn.play();
      else
      leverOff.play();
    }
  }
  
  void render(PVector mousepos, PVector offset)
  {
    rectMode(CENTER);
    fill(255,133,0);
    if(!on)
    position.y = originalHeight;
    else
    position.y = originalHeight + 70;
    rect(position.x + offset.x,position.y + offset.y,shapeD.x,shapeD.y);
  }
  
  void setOff()
  {
    on = false;
  }
}
