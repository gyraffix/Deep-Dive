 import processing.sound.*;
 
 
 PFont font;
 globalVariables globals;
 postProcessor post;

 SoundFile ambient; 
 
 mission_control_dialogue MCD;

void setup()
{
  size(1200,900);
  frameRate(30);
  
  font = loadFont("gameFont.vlw");
  textFont(font);
  post = new postProcessor();
  post.pixelSize = 3;
  post.spread = 4;
  post.spreadCompensation = 0;
  post.COLOR_0 = #FF003344;
  post.COLOR_1 = #FF664466;
  post.COLOR_2 = #FFEECCAA;
  post.COLOR_3 = #FFFFEEDD;
  
  globals = new globalVariables();
  
  globals.game = this;
  

  
  globals.oxygenCount = 100;
  
  globals.ui = new UI(post);
  
  globals.start = true;
  globals.paused = true;
  
  ambient = new SoundFile(this, "sub_ambient.wav");
  
  MCD = new mission_control_dialogue(globals);
  
  ambient.loop();
   
  globals.scenes[0] = new S_maintenance(globals, 3, 1, 0, new PVector(160, -170));
  globals.scenes[1] = new S_window(globals, 0, 2, 1, new PVector(160, -170));
  globals.scenes[2] = new S_radio(globals, 1, 3, 2, new PVector(100, -170));
  globals.scenes[3] = new S_measurements(globals, 2, 0, 3, new PVector(160, -170));
  
  globals.scenes[4] = new S_menu(globals, -1, 2, 4, new PVector(0,-100));
  globals.scenes[5] = new S_options(globals, 4, -1, 5, new PVector(0,0));
  
  globals.scenes[6] = new S_sea(globals, 9,7,6, new PVector(150,0), requestImage("sea1.png"));
  globals.scenes[7] = new S_sea(globals, 6,8,7, new PVector(150,0), requestImage("sea2.png"));
  globals.scenes[8] = new S_sea(globals, 7,9,8, new PVector(150,0), requestImage("sea3.png"));
  globals.scenes[9] = new S_sea(globals, 8,6,9, new PVector(150,0), requestImage("sea4.png"));
  
  globals.scenes[10] = new S_diedByOxygenLoss(globals, -1,-1,10, new PVector() );
  globals.scenes[11] = new S_beatGame(globals, -1,-1, 11, new PVector() );
  
  globals.activeScene = globals.scenes[4];
  globals.activeScene.soundVolume = 1;
  
    
}

void draw()
{
  ambient.amp(globals.ambientVolume);
  

  background(0);
  
  pushMatrix();
  scale(1.0/post.pixelSize);
  if (!globals.paused && globals.alive)
  {
    globals.oxygenCount = max(globals.oxygenCount-globals.oxygenLostPerFrame,0);
    handleGameProgression();
    globals.framesPlaying ++;
    globals.gameProgression = globals.framesPlaying/1200.0; //1.0 = 60s so youd want to divide by 60k
    
    if(globals.oxygenCount < 0.01 )
    {
      globals.activeScene = globals.scenes[10];
      globals.alive = false;
      globals.paused = true;
      globals.ui.switchingScene = false;
    }
  }
  MCD.update();
  globals.activeScene.renderScene();
  globals.ui.renderProcessedUI();
  
  post.render();
  popMatrix();
  
  

  globals.ui.renderUI();
  

}

void handleGameProgression()
{
  switch(floor(globals.gameProgression))
  {
    case 0:
    globals.oxygenLostPerFrame = globals.gameProgression*.1;
    //does the mission control talkie code go here?
    break;
    case 1:
    //1.0 : oxygen loss is .05
    globals.oxygenLostPerFrame = .1;
    break;
    case 2:
    //2.0 : color palette fade (R) starts, mission control contact lost
    postProcessingPaletteFade((globals.gameProgression-2)/1.5, #FF003344, #FF664466, #FFEECCAA, #FFFFEEDD,   #FF000011, #FF220603, #FF551003, #FF881800);
    
    //2.5 : oxygen loss rises
    globals.oxygenLostPerFrame = max(.05, (globals.gameProgression-2.5)*.1 + .05 );
    break;
    case 3:
    //3.0 : oxygen loss death is no longer possible
    globals.oxygenCount = max(globals.oxygenCount, (globals.gameProgression-3)*100);
    
    if(globals.gameProgression <3.5)
    {
      // this continues from case 2
      postProcessingPaletteFade((globals.gameProgression-2)/1.5, #FF003344, #FF664466, #FFEECCAA, #FFFFEEDD,   #FF000011, #FF220603, #FF551003, #FF881800);
      globals.oxygenLostPerFrame = max(.1, (globals.gameProgression-2.5)*.4 + .1 );
    }
    else if(globals.gameProgression <3.7)
    //3.5+ : oxygen loss is .15, color palette fade (R) ends
    {
      postProcessingPaletteFade(1, 0,0,0,0,  #FF000011, #FF220603, #FF551003, #FF881800);
      globals.oxygenLostPerFrame = .5;
    }    
    else
    //3.7+ : fade to black, color palette fade (B) starts 
    {
      globals.oxygenLostPerFrame = 0;
      postProcessingPaletteFade(max(0,(globals.gameProgression-3.8)/.2), #FF000011, #FF220603, #FF551003, #FF881800,   #FF112255, #FF554466, #FFEEAA77, #FFFFEEDD);
      globals.ui.vignettePlus = (globals.gameProgression-3.7)/.1;
    }
    break;
    case 4:
    //4.0 : fade to beach scene, color palette fade (B) is complete
    if(!globals.ui.switchingScene && globals.gameProgression <4.1 && globals.activeScene.thisScene != 6 && globals.activeScene.thisScene != 7 && globals.activeScene.thisScene != 8 && globals.activeScene.thisScene != 9) //aneurysm code
    {
      globals.ui.switchScene(globals.scenes[6],new PVector());
      globals.ui.log("The water is warm. The waves are calm. It's all okay.");
    }
    postProcessingPaletteFade(1, 0,0,0,0,  #FF112255, #FF554466, #FFEEAA77, #FFFFEEDD);
    globals.ui.vignettePlus = max(0,1-(globals.gameProgression-4.0)/.2);
    //4.3 : cut to black, you diesd
    if(globals.activeScene != globals.scenes[11] && globals.gameProgression>4.5)
    {
      globals.activeScene = globals.scenes[11];
      globals.ui.nextScene = globals.scenes[11];
      globals.ui.framesSwitchingScene = globals.ui.switchSceneTimeFrame/2;
      globals.activeScene.onSwitchScene();
    }
    //TODO: death
    //actually thats S_beatGame's problem now
    break;
    
  }
}

void postProcessingPaletteFade(float lerp, color COLOR_10, color COLOR_11, color COLOR_12, color COLOR_13, color COLOR_00, color COLOR_01, color COLOR_02, color COLOR_03)
{
  post.COLOR_0 = lerpColor(COLOR_10,COLOR_00,lerp);
  post.COLOR_1 = lerpColor(COLOR_11,COLOR_01,lerp);
  post.COLOR_2 = lerpColor(COLOR_12,COLOR_02,lerp);
  post.COLOR_3 = lerpColor(COLOR_13,COLOR_03,lerp);
}

void mousePressed()
{
  if(!globals.ui.switchingScene)
  {
    globals.activeScene.updateScene(mouseAction.PRESSED);
    globals.ui.mouseAction(mouseAction.PRESSED);
  }
}

void mouseReleased()
{
  if(!globals.ui.switchingScene)
  {
    globals.activeScene.updateScene(mouseAction.RELEASED);  
    globals.ui.mouseAction(mouseAction.RELEASED);
  }
}

void mouseWheel(MouseEvent event)
{
 globals.ui.mouseAction(event.getCount());
}
