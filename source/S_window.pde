class S_window extends scene
{
  clickableObject typeWriter;
  public boolean taskDone;
  PImage background;
  PImage bigFish;
  SoundFile typing;

  float fishX;
  boolean fishSpawn;
  float fishTime;
  float fishSpeed = 0.5;


  S_window(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, false);
    background = requestImage("window.png");
    bigFish = requestImage("big_fish.png");
    typing = new SoundFile(globals.game, "typewriter.wav");


    fishX = 550;
    typeWriter = new imageButton("typewriter", new PVector(75, 60), new PVector(680, 540), loadImage("typeWriter.png"));
  }

  void renderScene()
  {
    typing.amp(globals.sfxVolume);

    fill(0, 0, 255);
    rect(2000, 2000, 0, 0);

    if (globals.gameProgression > 2 && fishSpawn)
    {
      
      image(bigFish, fishX + position.x, 190 + position.y, 5000, 600);
      if (millis() > fishTime + 1000 && !globals.paused)
      {
        fishX -= fishSpeed;
        if (fishSpeed < 15)
          fishSpeed += 0.15;
      }
    }
    image(background, position.x, position.y, 1200, 1200);
    typeWriter.render(position);
  }

  void updateScene(mouseAction action)
  {
    {
      if (action == mouseAction.RELEASED && globals.p_Done && globals.t_Done && globals.w_Done && typeWriter.checkClickIntersection(position) && !globals.paused && !globals.logged)
      {
        globals.ui.log("all tasks done, results logged");
        typing.play();
        globals.tasks++;
        globals.start = false;
        globals.radio = true;
        globals.p_Done = false;
        globals.p_Start = false;
        globals.t_Done = false;
        globals.w_Done = false;
        globals.puzzleSet = false;
        
        
      }
    }
  }
  
  void onSwitchScene()
  {
    if (globals.gameProgression > 2 && !fishSpawn)
    {
      fishTime = millis();
      fishSpawn = true;
    }
  }
  
}
