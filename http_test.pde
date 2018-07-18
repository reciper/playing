import http.requests.*;
import controlP5.*;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
JSONObject PlaData;
Toggle move1Toggle;
ControlP5 CP5;
boolean Scan_B = false, Connect_B = false;
int ScanFlag = 0;
int v;
final int PRPort = 0;
public void setup() 
{
  colorMode(HSB,360,100,100);
  rectMode(CORNER);
  size(600, 700);
  smooth();
  //arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
  ControlFont cf1 = new ControlFont(createFont("Arial", 20));
  CP5 = new ControlP5(this);
  CP5.addToggle("Scan_B")
    .setFont(cf1)
    .setLabel("    SCAN")
    .setPosition(50, 40)
    .setSize(100, 40)
    .setColorCaptionLabel(color(0, 0, 0));
  CP5 = new ControlP5(this);
  CP5.addToggle("Connect1_B")
    .setFont(cf1)
    .setLabel("CONNECT1")
    .setPosition(250, 40)
    .setSize(100, 40)
    .setColorCaptionLabel(color(0, 0, 0));
    
    CP5 = new ControlP5(this);
  CP5.addToggle("Connect2_B")
    .setFont(cf1)
    .setLabel("CONNECT2")
    .setPosition(250, 140)
    .setSize(100, 40)
    .setColorCaptionLabel(color(0, 0, 0));
    
  CP5 = new ControlP5(this);
  move1Toggle = CP5.addToggle("PWM1_B")
    .setFont(cf1)
    .setLabel("    MOVE1")
    .setPosition(450, 40)
    .setSize(100, 40)
    .setColorCaptionLabel(color(0, 0, 0));
    
  CP5 = new ControlP5(this);
  CP5.addToggle("PWM2_B")
    .setFont(cf1)
    .setLabel("    MOVE2")
    .setPosition(450, 140)
    .setSize(100, 40)
    .setColorCaptionLabel(color(0, 0, 0));
  PlaData = new JSONObject();
  String pwm = "";
  pwm = "/set?pwm_duty=0";
  //println(GetStatus(1, "state"));
}
void draw() {
  background(122,1,84);
  fill(0);
  rect(25, 290, 550, 350);
  
  //v = arduino.analogRead(PRPort);
  println(v);
  fill(122, 90, 99);
  if (ScanFlag == 0) {
    GetRequest get = new GetRequest("http://localhost:11111/");
    get.send();
    PlaData = parseJSONObject(get.getContent());
    
    text("state:"+PlaData.getString("state") + "  scan:"+PlaData.getBoolean("scan"), 30, 300);
    text("state:"+PlaData.getJSONArray("devices"), 30, 315);
    
  }
  
  if((ScanFlag & 1) == 1) {
    GetRequest get = new GetRequest("http://localhost:11111/devices/1");
    get.send();
    PlaData = parseJSONObject(get.getContent());
    
    //text(get.getContent(), 30, 300);
    text("id:"+PlaData.getInt("id"), 30, 315);
    text("pwm_duty:"+PlaData.getInt("pwm_duty"), 30, 330);
    text("state:"+PlaData.getString("state"), 30, 345);
  }
  
  if((ScanFlag & 2) == 2) {
    GetRequest get = new GetRequest("http://localhost:11111/devices/2");
    get.send();
    PlaData = parseJSONObject(get.getContent());
    
    text("id:"+PlaData.getInt("id"), 30, 375);
    text("pwm_duty:"+PlaData.getInt("pwm_duty"), 30, 390);
    text("state:"+PlaData.getString("state"), 30, 405);
  }
}
// ButtounOperate
void Scan_B(boolean theFlag) {
  if (theFlag==true) {
    GetRequest get = new GetRequest("http://localhost:11111/scan/start");
    get.send();
  } else {
    GetRequest get = new GetRequest("http://localhost:11111/scan/stop");
    get.send();
  }
}
void Connect1_B(boolean theFlag) {
  if (theFlag==true) {
    ScanFlag = ScanFlag | 1;
    GetRequest get = new GetRequest("http://localhost:11111/devices/1/connect");
    get.send();
    println("dadf");
  } else {
    ScanFlag = ScanFlag & 254;
    GetRequest get = new GetRequest("http://localhost:11111/devices/1/disconnect");
    get.send();
  }
}
void Connect2_B(boolean theFlag) {
  if (theFlag==true) {
    ScanFlag = ScanFlag | 2;
    GetRequest get = new GetRequest("http://localhost:11111/devices/2/connect");
    get.send();
    println("dadf");
  } else {
    ScanFlag = ScanFlag & 253;
    GetRequest get = new GetRequest("http://localhost:11111/devices/2/disconnect");
    get.send();
  }
}
void PWM1_B(boolean theFlag) {
  if (theFlag==true) {
    GetRequest get = new GetRequest("http://localhost:11111/devices/1/set?pwm_duty=100");
    get.send();
    move1Toggle.setLabel("    Moving");
  } else {
    GetRequest get = new GetRequest("http://localhost:11111/devices/1/set?pwm_duty=0");
    get.send();
    move1Toggle.setLabel("    Move");
  }
}
void PWM2_B(boolean theFlag) {
  if (theFlag==true) {
    GetRequest get = new GetRequest("http://localhost:11111/devices/2/set?pwm_duty=100");
    get.send();
  } else {
    GetRequest get = new GetRequest("http://localhost:11111/devices/2/set?pwm_duty=0");
    get.send();
  }
}


1 件のコメント折りたたむ