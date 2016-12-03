//RBT-001でOPA344のデータを送信。Arrayにためてから送る方式も。
#include <SoftwareSerial.h>
#define BAUD 9600
#define BT_TX 11
#define BT_RX 10
#define PIN 0
//#define ARRAY_SIZE 800

SoftwareSerial btSerial(BT_RX, BT_TX);
int d;
//int d[ARRAY_SIZE];
//int count;

void setup(){
  btSerial.begin(BAUD);
//  Serial.begin(BAUD);
  pinMode(PIN, INPUT);
//  pinMode(13, OUTPUT);
}

void loop(){
//    d++;
    d = analogRead(PIN);
    btSerial.write(d >> 2);
//    Serial.write(d);
   // delay(1000);

  /*
  if (count < ARRAY_SIZE){
    d[count] = analogRead(PIN);
    digitalWrite(13,HIGH);
    count++;
  }

  if (count >= ARRAY_SIZE){
    digitalWrite(13,LOW);
    for (int i=0; i <= ARRAY_SIZE; i++){
      btSerial.write(d[count] >> 2); 
      i++;
    }
  count = 0;    
  }
  */
}
