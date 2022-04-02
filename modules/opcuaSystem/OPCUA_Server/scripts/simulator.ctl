void main()
{
  bool b;
  float value, offset, amplitude=100, periode=20, rate=3000, t;
  
  while(true)
  {
    //toggle bit
    dpSet("myDp.bool", b);
    b = !b;
    
    //sinus simulator
    value = offset + amplitude*sin(6.28318530*(1.0/periode)*t);
    t=t+(rate/1000);
    dpSet("myDp.int",value);
      
    delay(0,rate);
  }
 
}
