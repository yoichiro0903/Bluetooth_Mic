//RBT-001動作確認用
#include <SoftwareSerial.h>
#define BT_TX 11
#define BT_RX 10

SoftwareSerial btSerial(BT_RX, BT_TX);
int count = 0;

void setup(){
//  Serial.begin(9600);
  btSerial.begin(9600);
//  pinMode(13,OUTPUT);
}

void loop(){
//  delay(100);
  btSerial.write(count);
//  btSerial.write(count);
//  Serial.write(count);
  count++;
}


