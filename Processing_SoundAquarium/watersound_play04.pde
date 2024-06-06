import ddf.minim.*;  //minimライブラリのインポート
import processing.serial.*;

Minim minim;  //Minim型変数であるminimの宣言
AudioPlayer player;  //サウンドデータ格納用の変数

Serial myPort;
int val;

int seAwa = 4;
int seDrop = 4;
int seNami = 4;
String[] awa = new String[seAwa];
String[] drop1 = new String[seDrop];
String[] nami1 = new String[seNami];
String[] drop2 = new String[seDrop];
String[] nami2 = new String[seNami];
int dropType = 0;
int namiType = 0;

boolean firstContact = false;
int[] s = new int[3];
int[] serialInArray = new int[3];
int[] sPast = new int[3];
int serialCount = 0;
int[] sTime = new int[3];

int waitTime = 5;

//仕様メモ
//0から1 になった瞬間鳴らす。
//音が鳴りやんで5秒後にまた別の音を鳴らす。

void setup() {
  frameRate(30);
  size(100, 100);
  minim = new Minim(this);  //初期化

  for (int i = 0; i < seAwa; i++) {
    awa[i] = "awa1_" + nf(i+1, 1)+".mp3";
  }
  for (int i = 0; i < seDrop; i++) {
    drop1[i] = "drop1_" + nf(i+1, 1) + ".mp3";
    drop2[i] = "drop2_" + nf(i+1, 1) + ".mp3";
  }
  for (int i = 0; i < seNami; i++) {
    nami1[i] = "nami1_" + nf(i+1, 1) + ".mp3";
    nami2[i] = "nami2_" + nf(i+1, 1) + ".mp3";
  }

  String portName = Serial.list()[0];
  println(Serial.list());
  myPort = new Serial(this, "/dev/cu.usbmodem145101", 9600);
}

void draw() {

  background(0);
}

void serialEvent(Serial myPort) {

  //インポート
  int inByte = myPort.read();

  if (firstContact == false) {

    if (inByte == 'T') {
      myPort.clear();
      firstContact = true;
      myPort.write('T');       // send "T"
    }
  } else {

    serialInArray[serialCount] = inByte;
    serialCount++;

    // Checking 3 Bytes
    if (serialCount > 2 ) {

      for (int i = 0; i < 3; i++) {
        if (serialInArray[i] >= 100) {
          s[i] = 1;
          sTime[i] ++;
        } else {
          s[i] = 0;
          sTime[i] = 0;
        }
        
        //前時間との違いをチェックし、音を鳴らす
        if (sPast[i] != s[i] && s[i]==1) {
          if (i == 0) sTime[i]= (waitTime-1) * 30 +15;//playAwa();
          if (i == 1) {
            dropType = int(random(2));
            sTime[i]= (waitTime-1) * 30 +15;
            //playDrop();
          }
          if (i == 2) {
            namiType = int(random(2));
            sTime[i]= (waitTime-1) * 30 +15;
            //playNami();
          }
        } else if (sTime[i] > waitTime * 30) {//持たれてから5秒経過しても鳴らす
          sTime[i] = 0;
          if (i == 0) playAwa();
          if (i == 1) playDrop();
          if (i == 2) playNami();
        }
        sPast[i] = s[i];
      }

      // for debugging 
      println(serialInArray[0] + "\t" + serialInArray[1] + "\t" + serialInArray[2]);

      // Send a capital T to request new sensor readings:
      myPort.write('T');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}


void stop() {

  player.close();  //サウンドデータを終了
  minim.stop();
  super.stop();
}

void keyPressed() {

  if (key=='q') playAwa();
  if (key=='w') playDrop();
  if (key=='e') playNami();
}

void playAwa() {

  int rnd = int(random(seAwa));
  player = minim.loadFile(awa[rnd]);
  player.play();
  println(rnd);
}

void playDrop() {

  int rnd = int(random(seDrop));
  if (dropType == 0) {
    player = minim.loadFile(drop1[rnd]);
  } else {
    player = minim.loadFile(drop2[rnd]);
  }
  player.play();
  println(rnd);
}

void playNami() {

  int rnd = int(random(seNami));
  if (namiType == 0) {
    player = minim.loadFile(nami1[rnd]);
  } else {
    player = minim.loadFile(nami2[rnd]);
  }
  player.setGain(-15);
  player.play();
  println(rnd);
}