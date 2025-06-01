class S_measurements extends scene
{
  PImage background;
  int waterType;
  clickableObject thermometer;
  clickableObject tap;
  boolean tapped;
  PImage bottleFull;
  PImage bottleEmpty;
  PImage[] measureSticks;
  PImage sheet;
  clickableObject[] buttons;
  int currentID;
  boolean showStick;

  SoundFile therm_tap;

  S_measurements(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, false);
    background = requestImage("measurements.png");

    thermometer = new imageButton("thermometer", new PVector(90, 170), new PVector(900, 513), requestImage("thermometer.png"));

    tap = new clickableObject("tap", new PVector(30, 45), new PVector(575, 510));
    buttons = new clickableObject[5];
    measureSticks = new PImage[5];
    bottleFull = requestImage("bottle_full.png");
    bottleEmpty = requestImage("bottle_empty.png");
    sheet = requestImage("sheet.png");

    for (int i = 0; i < 5; i++)
    {
      buttons[i] = new clickableObject(String.valueOf(i), new PVector(30, 30), new PVector(900, 290 + i* 85));
      measureSticks[i] = requestImage("stick"+i+".png");
    }

    currentID = floor(random(0, 5));

    therm_tap = new SoundFile(globals.game, "tapping_thermometer.wav");
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
        if (thermometer.checkClickIntersection(position) && !globals.t_Done && globals.radio && !showStick)
        {
          globals.ui.log("Temperature logged");
          therm_tap.play();
          globals.t_Done = true;
        }
        if (!globals.w_Done && globals.radio)
        {
          if (tap.checkClickIntersection(position))
          {
            showStick = true;
            tapped = true;
            globals.ui.log("Took water sample");
          }
          for (clickableObject button : buttons)
          {
            if (button.checkClickIntersection(position) && showStick)
            {
              if (button.name.equals(String.valueOf(currentID)))
              {
                globals.ui.log("That seemed to be the correct answer, logging results");
                globals.w_Done = true;
                currentID = floor(random(0, 5));
                tapped = false;
                showStick = false;
              } else
              {
                globals.ui.log("That doesn't seem right");
              }
            }
          }
        }


        break;
      }
    }
  }

  void renderScene()
  {
    therm_tap.amp(globals.sfxVolume);

    image(background, position.x, position.y, 1200, 1200);

    rectMode(CENTER);
    fill(255, 0, 0);
    rect(thermometer.position.x + position.x, thermometer.position.y+ position.y +40, 20, 150);
    thermometer.render(position);
    //rect(thermometer.position.x + position.x,thermometer.position.y+ position.y,thermometer.shapeD.x,thermometer.shapeD.y);
    //rect(tap.position.x+ position.x, tap.position.y + position.y, tap.shapeD.x,tap.shapeD.y);

    if (tapped)
      image(bottleFull, 456 + position.x, 599 + position.y, 220, 250);
    else
      image(bottleEmpty, 456+position.x, 599+position.y, 220, 250);
    if (showStick)
    {
      image(measureSticks[currentID], 160+position.x, 220+position.y, 180, 550);
      image(sheet, 500 + position.x, 235 + position.y, 450, 450);
      for (clickableObject button : buttons)
      {
        rect(button.position.x + position.x, button.position.y + position.y, button.shapeD.x, button.shapeD.y);
      }
    }
  }
}
