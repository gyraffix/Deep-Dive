class clickableObject
{
  String name;
  PVector shape;
  PVector shapeD;
  PVector position;
  
  clickableObject(String _name, PVector _shape, PVector _position)
  {
    if(_shape.x < 1 || _shape.y < 1)
    println("WARNING - button smaller than 1 created!");
    name = _name;
    shape = _shape;
    shapeD = PVector.mult(_shape,2);
    position = _position;
  }
  
  void render(PVector _position)
  {
    //rectMode(CENTER);
    // rect(position.x + _position.x, position.y + _position.y, shapeD.x, shapeD.y);
  }
  
  void onLeftClick()
  {
  }
  
  boolean checkClickIntersection(PVector offset)
  {
    return checkIntersection(new PVector(mouseX, mouseY), offset);
  }
  
  boolean checkIntersection(PVector clickPosition, PVector offset)
  {
    PVector relativePos = PVector.sub(PVector.add(offset, position),clickPosition);
    if( abs(relativePos.x) > shape.x )
    return false;
    return abs(relativePos.y) < shape.y;
  }
}
