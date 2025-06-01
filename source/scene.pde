class scene
{
  globalVariables globals;
  int leftScene;
  int rightScene;
  int thisScene;
  PVector startPosition;
  PVector position;
  boolean fullScreenScene;
 float soundVolume;
 
  scene(globalVariables globals, int leftScene, int rightScene, int thisScene, PVector position, boolean  fullScreenScene)
  {
    this.globals = globals;
    this.leftScene = leftScene;
    this.rightScene = rightScene;
    this.thisScene = thisScene;
    this.position = position;
    startPosition = position;
    this.fullScreenScene = fullScreenScene;
    soundVolume = 0;
  }
 
   void onSwitchScene()
   {
     for (int i = 0; i < min(5,5 - ceil(((globals.oxygenCount -10)/ 10))); i++)
     {
       globals.ui.monsters.add(new Monster(new PVector(300, 300), i+1, requestImage("monster" + floor(random(1,6)) + ".png"), globals));
     }
   }
 
  void updateScene(mouseAction action)
  {
  }
  
  void renderScene()
  {
  }
  
  void leftScene()
  {
  }
  
  void rightScene()
  {
  }
}
