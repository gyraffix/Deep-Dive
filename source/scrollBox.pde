class scrollBox extends clickableObject
{
  clickableObject scrollBar;
  
  scrollBox(String _name, PVector _size, PVector _position, float _scrollButtonSize, float _contentLength)
  {
    super(_name, _size, _position);
    contentLength = _contentLength;
    scrollButtonSize = _scrollButtonSize;
    scrollButtonSizeH = _scrollButtonSize*.5;
    scrollButtonSizeRatio = _size.y/(_size.y+scrollButtonSizeH);
    
    scrollBar = new clickableObject("scrollbar"+_name, new PVector(16,_size.y), new PVector(_position.x+shape.x-8, _position.y));
  }

  float contentLength;
  float scrollButtonSize;
  float scrollButtonSizeH;
  float scrollButtonSizeRatio;
  
  float normScrollHeight;  
  float scrollHeight = 0;
  
  boolean mouseHoldingScrollBar = false;
  
  void onScroll(float scroll, PVector mousepos)
  {
    if(!checkIntersection(mousepos, new PVector(0,0)))
    return;
    scrollHeight += scroll;
    scrollHeight = constrain(scrollHeight,0,contentLength);
    normScrollHeight = scrollHeight/contentLength;
  }
  
  void onLeftClick(PVector mousepos)
  {
    if(!scrollBar.checkIntersection(mousepos, new PVector(0,0)))
    return;
    mouseHoldingScrollBar = true;
  }
  
  void onLeftClickRelease()
  {
    mouseHoldingScrollBar = false;
  }
  
  void rescaleContentLength(float contentSize)
  {
    contentLength = contentSize;
    normScrollHeight = scrollHeight/contentLength;
  }
  
  void render(PVector mousepos, color COLOR_0, color COLOR_1, color COLOR_2, color COLOR_3)
  {
    if(mouseHoldingScrollBar)
    {
      normScrollHeight = (mousepos.y-scrollBar.position.y)/shapeD.y + .5;
      normScrollHeight = constrain(normScrollHeight,0,1);
      scrollHeight = normScrollHeight*contentLength;
    }
    stroke(COLOR_0);
    rectMode(CENTER);
    fill(COLOR_1);
    rect(position.x,position.y,shapeD.x,shapeD.y);
    fill(mouseHoldingScrollBar ? COLOR_2 : COLOR_1);
    rect(position.x+shape.x-8,position.y,-16,shapeD.y);
    fill(mouseHoldingScrollBar ? COLOR_3 : COLOR_2);
    rect(position.x+shape.x-8,position.y+shapeD.y*(normScrollHeight-.5)*scrollButtonSizeRatio,-16,scrollButtonSize);
  }
}
