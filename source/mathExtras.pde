static class mathExtras
{
  static float radianDifference(float a, float b)
  {
    return (PI - abs(abs( (a%TAU) - (b%TAU) ) - PI)) * sign(a-b);
  }
  
  static float sign(float a)
  {
    return a < 0 ? -1 : 1;
  }
}
