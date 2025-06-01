class mission_control_dialogue
{
  globalVariables globals;
  boolean audioPaused;
  missionControlMessage dialogue[] =
    {
    null,
    new missionControlMessage("So, the goal of today's mission is to analyze water samples", 120, null),
    new missionControlMessage("and take temperature measurements at different depths.", 230, null),
    new missionControlMessage("Each time after you are done with that, document the results.", 320, null),
    new missionControlMessage("But this is not all, we had to rent an older submarine this time", 420, null),
    new missionControlMessage("so you will have to look after the life support systems.", 520, null),
    new missionControlMessage("That implies pumping the oxygen and leveling the pressure.", 600, null),
    new missionControlMessage("If an emergency with life support occurs, we will see it up here", 680, null),
    new missionControlMessage("and pull you back up.", 760, null),
    new missionControlMessage("End of the briefing and good luck out there.", 800, null),

    //this below message makes sure nothing gets spammed - make 100% sure its the last one (and is there)!!!
    new missionControlMessage("seriously? youve been playing for 27 months. the game is not THAT fun", 0x7FFFFFFF, null)
  };
  int currentDialogueIndex = 0;

  mission_control_dialogue(globalVariables _globals)
  {
    globals = _globals;
    dialogue[0] = new missionControlMessage("Okay, let's get to work", 60, new SoundFile(globals.game, "briefing.wav"));
  }

  void update()
  {
    dialogue[0].audio.amp(globals.sfxVolume);
    
    if (globals.paused && dialogue[0].audio.isPlaying())
    {
      println("buh");
      dialogue[0].audio.pause();
      audioPaused = true;
    }


    if (!globals.paused)
    {
      
      if (audioPaused)
      {
        dialogue[0].audio.play();
        audioPaused = false;
      }
      
      if (globals.framesPlaying <= dialogue[currentDialogueIndex].frameToPlayAt)
        return;




      
      globals.ui.log(dialogue[currentDialogueIndex].text);
      if (dialogue[currentDialogueIndex].audio != null)
        dialogue[currentDialogueIndex].audio.play();
      if (currentDialogueIndex < dialogue.length-1)
        currentDialogueIndex++;
    }
  }
}

class missionControlMessage
{
  String text;
  SoundFile audio;
  int frameToPlayAt;

  
  missionControlMessage(String _text, int _frameToPlayAt, SoundFile _audio)
  {
    text = _text;
    frameToPlayAt = _frameToPlayAt;
    if (_audio != null)
      audio = _audio;
  }
}
