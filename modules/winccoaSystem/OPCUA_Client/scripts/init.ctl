
string jar="/opt/winccoa/TMCS-PT-Monitoring/modules/winccoaSystem/mySqlExecutor.jar";
string dbHost = getenv("DB_Host");
string dbUser = getenv("DB_User");
string dbPassword = getenv("DB_Password");

void main()
{
  delay(120);
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

    dpCopyConfig("myDp.int", "myDp"+i+".int", makeDynString("_address"), error,1);
    dpCopyConfig("myDp.bool", "myDp"+i+".bool", makeDynString("_address"), error,1);



    delay(1);
    dpSet("_myConn"+i+".Config.Active", true);

    string r = "myConn"+i+"$myData"+i+"$1$1$ns=2;s=myType.myDp.int";
    dpSet("myDp"+i+".int:_address.._reference", r);
    dpSet("myDp"+i+".int:_address.._active", true);

    r = "myConn"+i+"$myData"+i+"$1$1$ns=2;s=myType.myDp.bool";
    dpSet("myDp"+i+".bool:_address.._reference", r);
    dpSet("myDp"+i+".bool:_address.._active", true);
  }

  string out, err;

  system("java -jar "+jar+" jdbc:mysql://"+dbHost+"/my_db "+dbUser+" "+dbPassword+" \"CREATE TABLE my_table (host text NOT NULL,time datetime NOT NULL, value int(10) NOT NULL, PRIMARY KEY (host(40),time,value))\"" ,out,err);

  if ( err != "" )
      DebugN(err);

  if ( !dpExists("myCpu") )
    dpCreate("myCpu", "ExampleDP_Int");

  dpQueryConnectSingle("work", false, "userdata", "SELECT '_original.._stime','_original.._value' FROM '{myDp*,_MemoryCheck.FreePerc,myCpu}'", 2000);

  while ( true )
  {
  out = "";err="";
    system("mpstat | grep all", out, err);// | /usr/bin/grep \"Cpu\"

    strreplace(out, "all", "~");
    strreplace(out, " ", "");

    if ( dynlen(strsplit(out, "~")) > 1 )
      out = strsplit(out, "~")[2];
    if ( dynlen(strsplit(out, ".")) > 0 )
      out = strsplit(out, ".")[1];

    dpSet("myCpu.", (int)out);
    delay(3);
  }
}

void work(string s, dyn_dyn_anytype dda)
{
  string insert;
  for ( int i = 2; i <= dynlen(dda); i++ )
  {
    //DebugN(dda[i][1]+" : "+(string)dda[i][2]+" : "+dda[i][3]);
    insert+= "INSERT INTO my_table (host ,time, value) VALUES('"+dpSubStr(dda[i][1],DPSUB_DP_EL)+"', '"+formatTime("%Y-%m-%d %H:%M:%S", dda[i][2])+"', "+(int)dda[i][3]+");";
  }

  string out,err;
  system("java -jar "+jar+" jdbc:mysql://"+dbHost+"/my_db "+dbUser+" "+dbPassword+" \""+insert+"\"" ,out,err);

  if ( err != "" )
    DebugN(err);
}
