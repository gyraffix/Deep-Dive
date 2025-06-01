class S_sea extends scene
{
  PImage background; 
  S_sea(globalVariables globals, int left, int right, int current, PVector position, PImage backgr)
  {
    super(globals, left, right, current, position, false);
    background = backgr;
  }
  
  void renderScene()
  {
    image(background,position.x, position.y, 1200,900);
  }
}
