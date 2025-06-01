class postProcessor
{
  int pixelSize;
  int spread;
  int spreadCompensation;
  color COLOR_0;
  color COLOR_1;
  color COLOR_2;
  color COLOR_3;
  
  void render()
  {
    loadPixels();
    rectMode(CORNER);
    int hw = height*width;
    int yp = 0;
    int hop = (int)(height/(float)pixelSize);
    int wop = (int)(width/(float)pixelSize);
    for(int y = hop; y>-1; y--)
    {
      ++yp;
      int xp = 0;
      int yxw = y*width; //computing this multiplication only once y changes saves a few
      for(int x = wop; x>-1; x--)
      {
        ++xp;
        color col = pixels[x+yxw];
        int b = (int)(red(col)*0.2126 + green(col)*0.7152 + blue(col)*0.0722); //faster and probably also more accurate than brightness()
        switch( (b + bayerThreshold4x(xp,yp)*spread - spreadCompensation)>>6 )
        {
          case -1: col = COLOR_0; break;
          case 0: col = COLOR_0; break;
          case 1: col = COLOR_1; break;
          case 2: col = COLOR_2; break;
          default: col = COLOR_3; break; 
          //the code allows brightness to 
          //be >1 due to the bayer pattern 
          //simply adding to the actual 
          //brightness. as such, having 
          //the brightest gradient color as
          //the default is mandatory
          
          //its also possible to go under
          //-1 but i am assuming were all 
          //gonna be responsible with our 
          //spreadcompensation selection.
          //we dont want the image to get 
          //too dark anyways
        }
        //if(bayerThreshold4x(xp,yp)*16<b)
        //col = #FFFFCCAA; else col = #FF003344;
        int xd = x*pixelSize;
        int yd = y*pixelSize;
        for(int px = 0; px<pixelSize; px++)
        for(int py = 0; py<pixelSize; py++)
        {
          int d = xd+px + (yd+py)*width;
          if(d<hw)
          pixels[d] = col;
        }
      }
    }
    updatePixels();
  }
  
  int bayerThreshold2x(int xp, int yp)
  {
    switch((xp&1) + ((yp&1)<<1)) //p sure this is as effecient as it gets
    {
      default:return 0;
      //case 0:return 0;
      case 1:return 2;
      
      case 2:return 3;
      case 3:return 1;
    }
  }
  
  int bayerThreshold4x(int xp, int yp)
  {
    switch((xp&3) + ((yp&3)<<2)) //p sure this is as effecient as it gets (again)
    {
      default:return 0;
      //case 0:return 0;
      case 1:return 8;
      case 2:return 2;
      case 3:return 10;
      
      case 4:return 12;
      case 5:return 4;
      case 6:return 14;
      case 7:return 6;
      
      case 8:return 3;
      case 9:return 11;
      case 10:return 1;
      case 11:return 9;
      
      case 12:return 15;
      case 13:return 7;
      case 14:return 13;
      case 15:return 5;
      //utterly incomprehensible thank you very much
      //its uh. called ordered dithering using threshold maps
      //wikipedia is your problem now
      //https://en.wikipedia.org/wiki/Ordered_dithering
      
      //is an array faster actually?
      //fml if so but im not gonna try
    }
  }
}
