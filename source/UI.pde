class UI
{
  imageButton leftArrow;
  imageButton rightArrow;
  imageButton pauseButton;
  
  clickableObject resume;
  clickableObject options;
  clickableObject exit;
  
  scrollBox logBox;
  int logs;
  ArrayList<log> logList;
  postProcessor post;
  PImage vignette0;
  PImage vignette1;
  float vignetteAmount = 0;
  FloatList logBoxAddHeight = new FloatList();

  float vignettePlus = 0;

  PImage pauseMenu;
  
  ArrayList<Monster> monsters;
  

  UI(postProcessor _post)
  {
    leftArrow = new imageButton("leftArrow", new PVector(40, 40), new PVector(350, 805), requestImage("arrowLeft.png"));
    rightArrow = new imageButton("rightArrow", new PVector(40, 40), new PVector(1150, 805), requestImage("arrowRight.png"));
    pauseButton = new imageButton("pauseButton", new PVector(40, 40), new PVector(1150, 50), requestImage("pause_button.png"));
    
    resume = new clickableObject("resume", new PVector(250, 50), new PVector(765, 340));
    options = new clickableObject("options", new PVector(250, 50), new PVector(765, 505));
    exit = new clickableObject("exit", new PVector(250, 50), new PVector(765, 685));
    
    logBox = new scrollBox("logBox", new PVector(150, 450), new PVector(150, 450), 50, 0);
    logList = new ArrayList<log>();
    post = _post;
    vignette0 = requestImage("vignette0.png");
    vignette1 = requestImage("vignette1.png");
    pauseMenu = requestImage("pause.png");
    
    monsters = new ArrayList<Monster>();
  }



  void renderUI()
  {
    if (!globals.activeScene.fullScreenScene)
    {
      if (!globals.paused)
      {
      tint(post.COLOR_2);
      leftArrow.render(new PVector(0, 0));
      rightArrow.render(new PVector(0, 0));
      pauseButton.render(new PVector());
      noTint();
      }
      
      
      
      for (int i = 0; i<logBoxAddHeight.size(); i++)
      {
        float GET = logBoxAddHeight.get(i)*.1;
        logBoxAddHeight.sub(i, GET);
        logBox.scrollHeight += GET;
        if (GET>.01) continue;
        logBoxAddHeight.remove(i);
        i--;
      }
      logBox.rescaleContentLength((logs-7) * 120);

      logBox.render(new PVector(mouseX, mouseY), post.COLOR_0, post.COLOR_1, post.COLOR_2, post.COLOR_3);
      for (log log : logList)
      {
        log.position.y = log.originalHeight - logBox.scrollHeight;
        log.render(post.COLOR_0, post.COLOR_1, post.COLOR_2, post.COLOR_3);
      }
      
      
      if (globals.paused)
      {
        tint(post.COLOR_2);
        rectMode(CORNER);
        image(pauseMenu, 300, 0, 900, 900);
        noTint();
      }
    }
  }

  void renderProcessedUI()
  {
    
    for (Monster monster : monsters)
      {
        monster.render(globals.activeScene.position);
      }
    
    if(globals.alive)vignetteAmount = 1.0-globals.oxygenCount*0.01; else vignetteAmount = 0;
    vignetteAmount += vignettePlus;
    if (switchingScene)switchSceneUpdate();

    tint(255, .5*vignetteAmount*255);
    if (!globals.activeScene.fullScreenScene) image(vignette0, 300, 0, 900, 900);
    else image(vignette0, 0, 0, 1200, 900);
    tint(255, vignetteAmount*255);
    if (!globals.activeScene.fullScreenScene) image(vignette1, 300, 0, 900, 900);
    else image(vignette1, 0, 0, 1200, 900);
    fill(0, pow(vignetteAmount, 6)*255);
    rectMode(CORNER);
    rect(0, 0, width, height);
    noTint();
    
    
  }

  void log(String text)
  {
    logList.add(new log(text, new PVector(140, 80 + (logs * 120))));
    logs++;
    if (logs > 7)
    {
      logBox.rescaleContentLength((logs-7) * 120);
      logBoxAddHeight.append(120);
    }
  }

  void mouseAction(mouseAction action)
  {
    if (action == mouseAction.RELEASED)
    {
      if (!globals.paused)
      {
      if (leftArrow.checkClickIntersection(new PVector(0, 0)))
        leftScene();
      if (rightArrow.checkClickIntersection(new PVector(0, 0)))
        rightScene();
      if (pauseButton.checkClickIntersection(new PVector(0, 0)))
        globals.paused = true;
      logBox.onLeftClickRelease();
      }
      else if (!globals.options && !globals.activeScene.fullScreenScene)
      {
        if (resume.checkClickIntersection(new PVector()))
        globals.paused = false;
        if (options.checkClickIntersection(new PVector()))
        options();
        if (exit.checkClickIntersection(new PVector()))
        exit();
      }
    }
    if (action == mouseAction.PRESSED)
    {
      logBox.onLeftClick(new PVector(mouseX, mouseY));
    }
  }

  void mouseAction(float e)
  {
    logBox.onScroll(e, new PVector(mouseX, mouseY));
  }

  boolean switchingScene = false;
  int framesSwitchingScene;
  int switchSceneTimeFrame = 40;
  PVector sceneMoveDirection;
  scene nextScene;

  void switchScene(scene next, PVector direction)
  {
    sceneMoveDirection = direction;
    nextScene = next;
    framesSwitchingScene = -switchSceneTimeFrame/2;
    switchingScene = true;
  }

  void switchSceneUpdate()
  {
    framesSwitchingScene++;
    if (framesSwitchingScene == 0) 
    {
      globals.activeScene = nextScene;
     globals.activeScene.onSwitchScene(); 
    }
    switchingScene = framesSwitchingScene < switchSceneTimeFrame*.5;
    float d = framesSwitchingScene/(switchSceneTimeFrame*.5);
    vignetteAmount += 1.0-abs(d);

    if (framesSwitchingScene<0)
      globals.activeScene.position = PVector.add(globals.activeScene.startPosition, new PVector((-d*d-2*d-1)*sceneMoveDirection.x, (-d*d-2*d-1)*sceneMoveDirection.y));
    else
      globals.activeScene.position = PVector.add(globals.activeScene.startPosition, new PVector((d*d-2*d+1)*sceneMoveDirection.x, (d*d-2*d+1)*sceneMoveDirection.y));
  }


  void leftScene()
  {
    switchScene(globals.scenes[globals.activeScene.leftScene], new PVector(-100, 0));
  }

  void rightScene()
  {
    switchScene(globals.scenes[globals.activeScene.rightScene], new PVector(100, 0));
  }

  void options()
  {
    globals.scenes[5].leftScene = globals.activeScene.thisScene;
    switchScene(globals.scenes[5], new PVector());
    globals.options = true;
  }
}
