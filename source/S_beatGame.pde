class S_beatGame extends scene
{
  SoundFile subExplode;
  int frames = 0;
  PImage submarine;
  PImage submarineDiesd;
  S_beatGame(globalVariables globals, int left, int right, int current, PVector position)
  {
    super(globals, left, right, current, position, true);
    subExplode = new SoundFile(globals.game, "sub-explode.wav");
    submarine = requestImage("submarine.png");
    submarineDiesd = requestImage("submarineDiesd.png");
  }
  
  void renderScene()
  {
    fill(255);
    image(submarine, 0, 0, width, height);
    if(frames == 40)
    {
      subExplode.play();
    }
    if(frames >= 60)
    {
      tint((frames-20)*22.5);
      image(submarineDiesd, 0, 0, width, height);
      noTint();
    }
    frames++;
    textSize(100);
    textAlign(CENTER);
    if(frames >= 80)
    {
    text("YOU DIED", width/2, height/2);
    textSize(60);
    text("Measurements made: "+globals.tasks, width/2, height/2+100);
    }
    textAlign(CORNER);
  }
}
