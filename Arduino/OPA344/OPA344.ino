//OPA344マイクの動作確認用
//http://nixeneko.hatenablog.com/entry/2016/09/14/150506
#define BAUD 115200 //シリアル通信の転送速度。受信側と合わせる
#define PIN 0
int d;

void setup() {
  // put your setup code here, to run once:
  pinMode(PIN, INPUT);
  Serial.begin(BAUD);
}

void loop() {
  // put your main code here, to run repeatedly:
  d = analogRead(PIN);
  //Serial.printlnだと雑音がでる。多分、マイナス値がでないから。
  Serial.write(d >> 2);
}
