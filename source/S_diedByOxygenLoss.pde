class S_diedByOxygenLoss extends scene
{
  int frames = 0;
  S_diedByOxygenLoss(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, true);
  }
  
  void renderScene()
  {
    globals.oxygenCount = 100;
    globals.ui.switchingScene = false;
    frames++;
    background(0);
    fill(min(255,frames*5));
    textSize(100);
    textAlign(CENTER);
    text("YOU DIED", width/2, height/2);
    textSize(60);
    text("Measurements made: "+globals.tasks, width/2, height/2+100);
    text("Time survived: "+(globals.framesPlaying/30)+" seconds", width/2, height/2+150);
    textAlign(CORNER);
  }
}
