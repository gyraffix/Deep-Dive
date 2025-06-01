class globalVariables
{
  
  Deep_Dive game;
  
  boolean paused;
  boolean options;
  boolean start;
  boolean alive;
  
  int tasks = 0;
  
  boolean puzzleSet;
  boolean p_Done;
  boolean t_Done;
  boolean w_Done;
  
  boolean logged;
  boolean radio=true;
  
  boolean p_Start;
  //float temp;
  
  float ambientVolume = 1;
  float sfxVolume = 1;
  
  float oxygenCount;
  float oxygenLostPerFrame = .05;
  
  
  scene activeScene;
  scene scenes[] = new scene[12];
  
  UI ui;
  
  int framesPlaying = 0;
  float gameProgression = 0;
  //1.0 : oxygen loss is .05
  //2.0 : color palette fade (R) starts, mission control contact lost
  //2.5 : oxygen loss rises
  //3.0 : oxygen loss death is no longer possible
  //3.5 : oxygen loss is .15, color palette fade (R) ends
  //3.7 : fade to black, color palette fade (B) starts 
  //4.0 : fade to beach scene, color palette fade (B) is complete
  //4.3 : cut to black, you diesd
  
}
