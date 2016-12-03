import processing.serial.*;

final int BAUD = 115200;            //シリアル通信の転送速度。送信側と合わせる
final int ARYSIZE = 100000;        //サンプル数-44。100000で20秒弱になった
//final String SERIALPORT = "/dev/cu.EasyBT-COM1";  //シリアルポート。環境に合わせる
final String SERIALPORT = "/dev/cu.usbmodem1421";  //シリアルポート。環境に合わせる
final String OUTFILE = "/Users/yoichirowatanabe/Desktop/115200ser4.wav"; //出力WAVファイル名

Serial myPort; 
byte x;
int y;
int cnt;
byte[] data;  //受信データ保存用配列

int time_start; //サンプリング周波数計算用
int time_end;   //同上

boolean outputflag;
boolean initflag;

void setup(){
  myPort = new Serial(this, SERIALPORT, BAUD);  //シリアルポート初期化
  data = new byte[ARYSIZE];  //受信データ保存用配列
  cnt = 0;                   //カウンタ初期化
  time_start = millis();
  outputflag = true;
  initflag = true;
}

void draw(){
  
}

//Waveヘッダ書込用。4バイト整数をbyte型4つ分書き出し
void set4bytes(byte[] ary, int idx, int val){
  ary[idx  ] = (byte)(val % 256);
  ary[idx+1] = (byte)(val / 0x100 % 256);
  ary[idx+2] = (byte)(val / 0x10000 % 256);
  ary[idx+3] = (byte)(val / 0x1000000);
}

//Waveヘッダ書込用。2バイト整数をbyte型2つ分書き出し
void set2bytes(byte[] ary, int idx, int val){
  ary[idx  ] = (byte)(val % 256);
  ary[idx+1] = (byte)(val / 0x100 % 256);
}

//Waveファイルに書き出し
void writeWav(){
  //WAVEヘッダの書き込み

  data[0] = 'R';
  data[1] = 'I';
  data[2] = 'F';
  data[3] = 'F';
  
  int fsizemin8 = ARYSIZE - 8;
  set4bytes(data, 4, fsizemin8);
  
  data[8]  = 'W';
  data[9]  = 'A';
  data[10] = 'V';
  data[11] = 'E';
  
  data[12] = 'f';
  data[13] = 'm';
  data[14] = 't';
  data[15] = ' ';
  
  int fmtsize = 16;
  set4bytes(data, 16, fmtsize);
  
  int fmtcode = 1;
  set2bytes(data, 20, fmtcode);
  
  int numch = 1;                //モノラル
  set2bytes(data, 22, numch);
  
  //サンプリング周波数
  int samprate = int(ARYSIZE / ((time_end - time_start) / 1000.0));
  //int samprate = 8928;
  //int samprate = 961;
  //int samprate = 480;
  set4bytes(data, 24, samprate);
  
  int bytepersec = samprate;    //秒あたりバイト数
  set4bytes(data, 28, bytepersec);
  
  int blockboundary = 1;
  set2bytes(data, 32, blockboundary);
  
  int bitpersample = 8;         //8bit
  set2bytes(data, 34, bitpersample);
  
  data[36] = 'd';
  data[37] = 'a';
  data[38] = 't';
  data[39] = 'a';
  
  int sizeremained = ARYSIZE - 126;
  set4bytes(data, 40, sizeremained);
  
  //出力
  saveBytes(OUTFILE, data);
  println("start:", time_start, "end:", time_end, "samprate:", samprate);
  exit();
}

//シリアル通信で受信すると呼び出される
void serialEvent(Serial p){
  if(initflag && cnt > 1000){ //受信が安定した頃に一回だけ実行
    time_start = millis();  //開始時間の計測
    println("time!");
    initflag = false;
    cnt = 0;  //カウンタの初期化→今までの受信データは上書きして捨てられる
  }
  x = (byte) p.read(); //受信データ
  //y = (int) p.read();
  println(cnt,x);
  println(p);
  //if (cnt % 100 == 1) println(cnt, x); //見づらいのでコンソール出力を間引いた
  if (cnt < ARYSIZE){
    data[cnt] = x;
    cnt++;
  }else{
    if (outputflag) { //複数回実行されないように
      time_end = millis();
      outputflag = false;
      writeWav();
    }
  }
}