class S_radio extends scene
{
  PImage background;
  imageButton radio;

  S_radio(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, false);
    background = requestImage("radio.png");
    radio = new imageButton("radio", new PVector(80, 140), new PVector(1010, 610), requestImage("radio_icon.png"));
  }

  void renderScene()
  {
    image(background, position.x, position.y, 1200, 1200);
    radio.render(position);
  }

  void updateScene(mouseAction action)
  {
    
  }
}
