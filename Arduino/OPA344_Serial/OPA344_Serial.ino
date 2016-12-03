//OPA344データをArrayにためてから送る方式。有線Serialのみ。
//データ取得中はLEDが点灯、データ送信中はLEDが消える。
//#include <SoftwareSerial.h>
#define BAUD 115200
#define PIN 0

//int d;
int d[900];
int count;

void setup(){
  Serial.begin(BAUD);
  pinMode(PIN, INPUT);
  pinMode(13, OUTPUT);
}

void loop(){
//    d = analogRead(PIN);
//    Serial.write(d >> 2);
  
  if (count < 400){
    d[count] = analogRead(PIN);
    digitalWrite(13,HIGH);
//    Serial.println("input");
//    Serial.println(d[count]);
    count++;
//    delay(100);
  }

  if (count >= 400){
    digitalWrite(13,LOW);
    for (int i=0; i <= 400; i++){
//      Serial.println("output");
//      Serial.println(d[i]);
      Serial.write(d[i] >> 2);
      i++;
//      delay(100);
    }
  count = 0;    
  }
}
