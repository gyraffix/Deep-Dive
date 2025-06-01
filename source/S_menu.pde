class S_menu extends scene
{
  PImage background;
  clickableObject startGame;
  clickableObject exit;
  clickableObject options;

  S_menu(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, true);
    background = loadImage("main_menu.png");
    startGame = new clickableObject("startGame", new PVector(40, 40), new PVector(350, 720));
    exit = new clickableObject("exit", new PVector(40, 40), new PVector(610, 720));
    options = new clickableObject("options", new PVector(40, 40), new PVector(870, 720));
    
  }

  void renderScene()
  {
    image(background, position.x, position.y, 1200, 1200);
    textSize(210);
    textAlign(CENTER);
    fill(0);
    text("DEEP DIVE", 610, 310);
    fill(255);
    text("DEEP DIVE", 600, 300);
    textAlign(CORNER);
  }
  void updateScene(mouseAction action)
  {
    switch(action)
    {
    default:
      break;

    case RELEASED:
      if (options.checkClickIntersection(position))
      {
        globals.ui.options();
        break;
      }
      if (exit.checkClickIntersection(position))
        exit();
      if (!startGame.checkClickIntersection(position))
        break;
      globals.ui.switchScene(globals.scenes[2], new PVector(0,100));
      globals.paused = false;
      globals.alive = true;

      break;
    }
  }
}
