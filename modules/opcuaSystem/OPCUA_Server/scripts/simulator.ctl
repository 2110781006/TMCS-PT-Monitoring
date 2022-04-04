void main()
{
  bool b;
  float value, offset, amplitude, periode=40, rate=3000, t;

  while ( !(amplitude > 50 && amplitude < 500) )//random amplitude
    amplitude = rand();

  while ( !(periode > 20 && periode < 300) )//random periode
    periode = rand();
  
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
