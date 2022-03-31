void main()
{
  dyn_string oaServers = strsplit(getenv("OPCUA_Servers"), "_");
//   dyn_string oaServers = strsplit("1.1.1.1_1.1.1.2", "_");

  for ( int i = 1; i <= dynlen(oaServers); i++ )
  {
    int error;

    if ( !dpExists("_myData"+i) )
      dpCopy("_myData", "_myData"+i, error);//create connection

    dpCopyOriginal("_myData", "_myData"+i, error);


      if ( !dpExists("_myConn"+i) )
      dpCopy("_myConn", "_myConn"+i, error);//create connection

    dpCopyOriginal("_myConn", "_myConn"+i, error);
    delay(1);
    dyn_string dsUaServers;
      dpGet("_OPCUA1.Config.Servers", dsUaServers);
      if(!dynContains(dsUaServers, "myConn"+i))
      {
        dynAppend(dsUaServers, "myConn"+i);
        dpSet("_OPCUA1.Config.Servers", dsUaServers,
              "_OPCUA1.Command.AddServer", "myConn"+i
              );
      }



    dpSet("_myConn"+i+".Config.ConnInfo", "opc.tcp://"+oaServers[i],
          "_myConn"+i+".Config.Subscriptions", makeDynString("_myData"+i));


    if ( !dpExists("myDp"+i) )
      dpCopy("myDp", "myDp"+i, error);//create dps

    dpCopyConfig("myDp", "myDp"+i, makeDynString("_address"), error,1);



    delay(1);
    dpSet("_myConn"+i+".Config.Active", true);

    string r = "myConn"+i+"$myData"+i+"$1$1$ns=2;s=myType.myDp.int";
    dpSet("myDp"+i+".int:_address.._reference", r);
    dpSet("myDp"+i+".int:_address.._active", true);
  }

  dpQueryConnectSingle("work", false, "userdata", "SELECT '_original.._stime','_original.._value' FROM 'myDp*'");
}

void work(string s, dyn_dyn_anytype dda)
{
  for ( int i = 2; i <= dynlen(dda); i++ )
  {
    DebugN(dda[i][1]+" : "+(string)dda[i][2]+" : "+dda[i][3]);
  }
}
