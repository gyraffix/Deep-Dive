class S_maintenance extends scene
{
  ArrayList<pressureLever> levers;
  int pressureValue = 0;
  PImage background;
  PImage background_t;
  int puzzle[] = new int[9];

  int puzzle1[] = {13, 6, 9, 3, 10, -3, 7, -4, 24};
  int puzzle2[] = {3, -6, 5, 1, 7, -2, 8, 10, 30};
  int puzzle3[] = {1, 3, 5, 7, 9, -2, -4, -6, 16};
  int puzzle4[] = {4, 6, 2, -3, 9, -1, 7, -4, 12};
  int puzzle5[] = {6, 1, -9, -3, 2, 8, 3, -4, 5};


  PImage wheel;
  PImage arrowCircle;
  float arrowCircleTint = 0;
  float targetRotationSpeed = 0.03;
  float oxygenBarRotationInRadians = 0;
  int wheeloffx = 260;
  int wheeloffy = 550; //coordinates of the oxygen wheel
  int wheelboxoff = 0; //placement of the oxygen wheel mouse target box
  int wheelSize = 200;
  float mouseRotationInRadians = 0;
  float mouseRotationInRadiansP = 0;
  boolean mouseHeldOnWheel = false;
  float wheelRotationInRadians = 0;
  float mouseVel[] = new float[60];
  int mouseVelSel = 0;
  int currentPuzzle;

  SoundFile valveTurning;

  S_maintenance(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, false);

    levers = new ArrayList<pressureLever>();

    currentPuzzle = floor(random(1, 6));

    switch(currentPuzzle)
    {
    default:
      break;
      case (1):
      for (int i = 0; i < 9; i++)
      {
        puzzle[i] = puzzle1[i];
      }
      break;
      case (2):
      for (int i = 0; i < 9; i++)
      {
        puzzle[i] = puzzle2[i];
      }
      break;
      case (3):
      for (int i = 0; i < 9; i++)
      {
        puzzle[i] = puzzle3[i];
      }
      break;
      case (4):
      for (int i = 0; i < 9; i++)
      {
        puzzle[i] = puzzle4[i];
      }
      break;
      case (5):
      for (int i = 0; i < 9; i++)
      {
        puzzle[i] = puzzle5[i];
      }
      break;
    }
    globals.puzzleSet = true;
    int currentValue = 0;
    for (int i = 0; i < 4; i++)
    {
      levers.add(new pressureLever("toplever" + (i+1), new PVector(30, 20), new PVector((580 + 120 * i), 470), puzzle[currentValue]));
      currentValue++;
    }
    for (int i = 0; i < 4; i++)
    {
      levers.add(new pressureLever("toplever" + (i+1), new PVector(30, 20), new PVector((580 + 120 * i), 710), puzzle[currentValue]));
      currentValue++;
    }
    background = requestImage("maintenance.png");
    background_t = requestImage("maintenance_t.png");

    wheel = requestImage("maintenanceWheel.png");
    arrowCircle = requestImage("arrowsCircle.png");

    valveTurning = new SoundFile(globals.game, "valve_turning.wav");
  }

  void renderScene()
  {
    image(background, position.x, position.y, 1200, 1200);
    if (globals.radio)
    {

      if (!globals.p_Start)
      {
        for (pressureLever lever : levers)
        {
          lever.setOff();
        }
        currentPuzzle = floor(random(1, 6));
        if (!globals.puzzleSet)
        {
          switch(currentPuzzle)
          {
          default:
            break;
            case (1):
            for (int i = 0; i < 9; i++)
            {
              puzzle[i] = puzzle1[i];
            }
            break;
            case (2):
            for (int i = 0; i < 9; i++)
            {
              puzzle[i] = puzzle2[i];
            }
            break;
            case (3):
            for (int i = 0; i < 9; i++)
            {
              puzzle[i] = puzzle3[i];
            }
            break;
            case (4):
            for (int i = 0; i < 9; i++)
            {
              puzzle[i] = puzzle4[i];
            }
            break;
            case (5):
            for (int i = 0; i < 9; i++)
            {
              puzzle[i] = puzzle5[i];
            }
            break;
          }
        }
        globals.puzzleSet = true;
      }
    }

    fill(120);
    rectMode(CORNER);
    rect(215 + position.x, 830 + position.y, 75, -120 * (globals.oxygenCount * 0.01));


    rect(450 + position.x, 830 + position.y, 40, -((pressureValue + 20) * 5));

    image(background_t, position.x, position.y, 1200, 1200);

    pressureValue = 0;
    for (pressureLever lever : levers)
    {
      lever.render(new PVector(mouseX, mouseY), position);
      if (lever.on)
      {
        pressureValue += lever.pressureValue;
      }
    }
    //textSize(40);
    fill(0);

    triangle(450 + position.x, position.y + 830 - (5 * (puzzle[8] + 20)), position.x + 420, position.y + 830 - (5 * (puzzle[8] + 20))+20, position.x + 420, position.y + 830 - (5 * (puzzle[8] + 20))-20);

    stroke(0);
    strokeWeight(2);
    if (pressureValue > puzzle[8] -2 && pressureValue < puzzle[8] + 2  && !globals.p_Done)
    {
      globals.p_Done = true;
      globals.ui.log("Pressure resolved");
    }


    mouseVelSel++;
    mouseVelSel%=mouseVel.length;
    mouseVel[mouseVelSel] = 0;

    mouseRotationInRadiansP = mouseRotationInRadians;
    PVector mousePos = new PVector(mouseX, mouseY);
    mousePos.sub(new PVector(wheeloffx+position.x, wheeloffy+position.y));
    mouseRotationInRadians = PVector.angleBetween(mousePos, new PVector(1, 0));
    if (PVector.angleBetween(mousePos, new PVector(0, 1)) > HALF_PI)
      mouseRotationInRadians = -mouseRotationInRadians;

    if (mouseHeldOnWheel)
    {
      mouseVel[mouseVelSel] = mathExtras.radianDifference(mouseRotationInRadians, mouseRotationInRadiansP);
      wheelRotationInRadians += mouseVel[mouseVelSel];
    }
    oxygenWheelUpdate();
  }

  void oxygenWheelUpdate()
  {
    oxygenBarRotationInRadians += targetRotationSpeed;
    PVector mousePos = new PVector(mouseX, mouseY);
    mousePos.sub(wheeloffx+position.x, wheeloffy+position.y);
    mousePos.rotate(-oxygenBarRotationInRadians);
    mousePos.sub(wheelboxoff, 0);

    pushMatrix();
    //the mouse controlled code
    translate(wheeloffx+position.x, wheeloffy+position.y);
    rotate(wheelRotationInRadians);
    rectMode(CENTER);
    image(wheel, wheelSize*-.5, wheelSize*-.5, wheelSize, wheelSize);
    popMatrix();

    pushMatrix();
    //the guides for rotating
    translate(wheeloffx+position.x, wheeloffy+position.y);
    rotate(oxygenBarRotationInRadians);
    if (abs(mousePos.x) < 125 && abs(mousePos.y) < 125)
      arrowCircleTint += 3.5;
    arrowCircleTint *= .98;
    tint(255, arrowCircleTint);
    image(arrowCircle, -125, -125, 250, 250);
    noTint();
    popMatrix();

    //fill(255);
    //textSize(50);
    //text(mouseRotationInRadians - mouseRotationInRadiansP, 1000, 50);

    float avgVel = getAvgVel();
    //text(avgVel, 1000, 100);

    float scoreplus = max(0, 1-40*abs(avgVel-targetRotationSpeed));
    globals.oxygenCount = min(100, globals.oxygenCount+scoreplus*.2);

    if (scoreplus > 0 && !valveTurning.isPlaying())
      valveTurning.loop();

    if (valveTurning.isPlaying())
      valveTurning.amp(scoreplus);

    if (scoreplus <= 0)
      valveTurning.stop();
    //text(globals.oxygenCount, wheeloffx+position.x, wheeloffy+position.y+100);
  }

  float getAvgVel()
  {
    float d = 0;
    for (int a = 0; a<mouseVel.length; a++)
    {
      d+=mouseVel[a];
    }
    return d/mouseVel.length;
  }

  void updateScene(mouseAction action)
  {
    if (!globals.paused)
    {
      switch(action)
      {
      default:
        break;

      case RELEASED:
        mouseHeldOnWheel = false;
        if (!globals.p_Done && globals.radio)
          for (pressureLever lever : levers)
          {
            lever.onLeftClickReleased(position);
            if (!globals.p_Start)
            {
              globals.p_Start = true;
            }
          }

        break;

      case PRESSED:
        PVector mousePos = new PVector(mouseX, mouseY);
        mousePos.sub(new PVector(wheeloffx+position.x, wheeloffy+position.y));
        mouseHeldOnWheel = mousePos.magSq() < wheelSize*wheelSize*.25;
        break;
      }
    }
  }
}
