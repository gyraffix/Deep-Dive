class S_options extends scene
{
  PImage background;
  float ambientPos = 1000;
  float sfxPos = 1000;
  clickableObject ambientNode;
  clickableObject sfxNode;
  imageButton back;
  boolean ambientClicked;
  boolean sfxClicked;
  
  S_options(globalVariables globals, int leftScene, int rightScene, int current, PVector position)
  {
    super(globals, leftScene, rightScene, current, position, true);
    background = requestImage("options.png");
    ambientNode = new clickableObject("ambientNode", new PVector(25,25), new PVector(1000, 320));
    sfxNode = new clickableObject("sfxNode", new PVector(25,25), new PVector(1000, 520));
    back = new imageButton("back", new PVector(40, 40), new PVector(50, 50), requestImage("arrowLeft.png"));
  }
  
  void renderScene()
  {

    image(background, position.x, position.y, 1200, 1200);
    
    
    
    if (ambientClicked)
    {
      if (mouseX < 200)
      {
      ambientPos = 200;
      ambientNode.position.x = 200;
      }
      else if (mouseX > 1000)
      {
      ambientPos = 1000;
      ambientNode.position.x = 1000;
      }
      else
      {
      ambientPos = mouseX;
      ambientNode.position.x = mouseX;
      }
    }
    
    if (sfxClicked)
    {
      if (mouseX < 200)
      {
      sfxPos = 200;
      sfxNode.position.x = 200;
      }
      else if (mouseX > 1000)
      {
      sfxPos = 1000;
      sfxNode.position.x = 1000;
      }
      else
      {
      sfxPos = mouseX;
      sfxNode.position.x = mouseX;
      }
    }
    
    globals.ambientVolume = (ambientPos - 200) / 800;
    globals.sfxVolume = (sfxPos - 200) / 800;
    
    back.render(new PVector());
    
    rectMode(CORNER);
    fill(128);
    rect(200, 300, 800, 40);
    rect(200, 500, 800, 40);
    fill(80);
    ellipseMode(CENTER);
    ellipse(ambientPos, 320, 50, 50);
    ellipse(sfxPos, 520, 50, 50);
    fill(255);
    textSize(80);
    text("Ambient Volume", 300, 250);
    text("SFX Volume", 400, 450);
  }
  
  void updateScene(mouseAction action)
  {
    switch(action)
    {
      default:
      break;
      
      case RELEASED:
      //globals.ui.switchScene(globals.scenes[leftScene], new PVector());
      ambientClicked = false;
      sfxClicked = false;
      if (back.checkClickIntersection(new PVector()))
      {
      globals.ui.switchScene(globals.scenes[leftScene], new PVector());
      globals.options = false;
      }
      break;
      
      case PRESSED:
      if (ambientNode.checkClickIntersection(position))
      {
        ambientClicked = true;
      }
      
      if (sfxNode.checkClickIntersection(position))
      {
        sfxClicked = true;
      }
    }
  }
  
}
