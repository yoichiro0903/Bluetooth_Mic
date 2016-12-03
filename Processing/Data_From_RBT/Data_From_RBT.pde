import processing.serial.*;

final int BAUD = 9600;
//final String SERIALPORT = "/dev/cu.EasyBT-COM1";
final String SERIALPORT = "/dev/cu.usbmodem1421";

int y;

Serial myPort; 

void setup(){
  myPort = new Serial(this, SERIALPORT, BAUD);
}

void draw(){ 
  background(0);
  text(y,50,50); 
}

void serialEvent(Serial p){
  y = p.read(); //debug
  //print("count", y); //debug
}