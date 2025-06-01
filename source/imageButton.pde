class imageButton extends clickableObject
{
  PImage icon;
  imageButton(String _name, PVector _shape, PVector _position, PImage _icon)
  {
    super(_name, _shape, _position);
    icon = _icon;
  }
  
  void render(PVector offset)
  {
    image(icon, position.x - shape.x + offset.x, position.y - shape.y + offset.y, shapeD.x, shapeD.y);
  }
  
}
