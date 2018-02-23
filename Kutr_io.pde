/**
*すべての世代の『情報学群生徒』へ贈る——— これは、単位を食べる狂乱だ！！
*<p>------------------------------------------------------------------
*<p>なんだかすみません。
*<p>マウスカーソルを動かして単位(に見立てた色円)を取りながらF(落単)から逃げてください。
*<p>単位を食べると円が大きくなり、移動速度が落ちます。自分より小さいFは捕食できます。
*<p>全ての落単が捕食できたら勝ちで、逆にFに捕食されてしまうと負けです。
*<p>情報学群大変ですが、あと数年生きのびましょうorz
*<p>------------------------------------------------------------------
*<p>参考ゲーム:Agar.io (ぜひ本家やってください。元は細胞分裂のゲームです)  
*<p>参考コード:情報科学2例題/演習課題,
*<p>          prorocessingでボードゲーム-Qiita[ http://qiita.com/fantm21/items/6b5f4f960fe3416671eb ]
*<p>          Simple Agario Game- OpenProcessing[ http://www.openprocessing.org/sketch/203464 ]
*<p>提供:高知工科大学情報学群HP, BM様
*<p>------------------------------------------------------------------
*/

PImage te; //背景画像

int count1 = 0, count2 = 0, Mode = 0, result = 0, startWordCount = 0; //カウント値
float x, y, Real, D, Dx, Dy, Vx, Vy, R; //グローバルパックマン
int n = 50, n2 = 5; //単位、敵の数
float e = 0.99; //自然対数
float ballR = 5; 
float[] ballx = new float[n]; //単位x座標
float[] bally = new float[n]; //単位y座標
float[] ballc = new float[n]; //単位色

float[] fx = new float[n2]; //落単x座標
float[] fy = new float[n2]; //落単y座標
float[] fvx = new float[n2]; //落単移動速度(x)
float[] fvy = new float[n2]; //落単移動速度(y)
float[] fd = new float[n2]; //落単直径
float[] fvx1 = new float[n2]; //落単反射計算(x)
float[] fvy1 = new float[n2]; //落単反射計算(y)
//スタート文章//
String[] startWord = {"","You can move Pacman!!","You can move Pacman!!","3","2","1","E a t !!",""};




void setup(){ 
  size(800, 800); //ウインドウサイズ
  colorMode(HSB); //HSBモード
  te = loadImage("teachers.png"); //背景画像の読み込み
  for ( int i = 0; i < n; i++ ) { //単位の初期値を入れる
    ballx[i] = random(width); 
    bally[i] = random(height);
    ballc[i] = random(255);
  }
} 


void draw(){ 
   if ( count1 == 0 ) { 
    frameRate(60);
    bg();
    startWindow();
  }
  if ( count1 == 1 ) {
    bg();
    standbyWindow();
    startWordCount++;
    if ( startWordCount > startWord.length - 1 ) {
      count1 = 2;
      gamebg();
      game();
  }
  }else if (count1 == 2){
    frameRate(60);
    gamebg();
    game();
  }
    
  if ( result == 1 ) {
    frameRate(60);
    bg();
    WIN();
  }else if ( result == 2 ) {
    frameRate(60);
    bg();
    LOSE();
  }
}


void mousePressed() { //マウスが押されたとき
  //Easyモード//
  if ( count1 == 0 && 180 <= mouseX && mouseX <= 620 && 375 <= mouseY && mouseY <= 455 ) { 
    Mode = 1;
    Configuration();
    for( int i = 0; i < n2; i++ ) {
      fvx[i] = 3;
      fvy[i] = random(-5,5);
    }
    count1 = 1;
    standbyWindow();
    
  //Nomalモード//  
  }else if ( count1 == 0 && 180 <= mouseX && mouseX <= 620 && 498 <= mouseY && mouseY <= 578 ) { 
    Mode = 2;
    Configuration();
    for( int i = 0; i < n2; i++ ) { 
      fvx[i] = 4;
      fvy[i] = random(-15,15);
    }
  count1 = 1;
  standbyWindow();
  
  //Hardモード//
  }else if ( count1 == 0 && 180 <= mouseX && mouseX <= 620 && 621 <= mouseY && mouseY <= 701 ) {
    Mode = 3;
    Configuration();
    for( int i = 0; i < n2; i++ ) { 
      fvx[i] = 6;
      fvy[i] = random(-10,10);
    }
  count1 = 1;
  standbyWindow();
  
  //Again or コンテ//
  }else if ( count1 == 3 && 240 <= mouseX && mouseX <= 560 && 422 <= mouseY && mouseY <= 502 ) {
    //Easy//
    if ( Mode == 1 ){
      Configuration();
      for( int i = 0; i < n2; i++ ) { 
        fvx[i] = 3;
        fvy[i] = random(-5,5);
    }
    count1 = 1;
    standbyWindow();
    //Nomal//
    } else if ( Mode == 2 ) {
      Configuration();
      for( int i = 0; i < n2; i++ ) { 
        fvx[i] = 4;
        fvy[i] = random(-5,5);
      }
      count1 = 1;
    //Hard//
    } else if ( Mode == 3 ) {
      Configuration();
      for( int i = 0; i < n2; i++ ) { 
        fvx[i] = 6;
        fvy[i] = random(-10,10);
      }
    count1 = 1;
    standbyWindow();
    }
  // モードの切り替え or タイトル//
  }else if ( count1 == 3 && 240 <= mouseX && mouseX <= 560 && 560 <= mouseY && mouseY <= 640 ) {
    Mode = 0;
    result = 0;
    count1 = 0;
    count2 = 0;
    startWindow();
  }
}


// 初期値関数 //
void Configuration() {
  frameRate(60);
  R = 10;
  result = 0;
  count2 = 0;
  startWordCount = 0;
  x = width/2; 
  y = height/2; 
  Real = 10;
  fd[0] = 20; fd[1] = 30; fd[2] = 40; fd[3] = 60; fd[4] = 85;
  for( int i = 0; i < n2; i++ ) { 
    fx[i] = random(width/5); 
    fy[i] = random(height);
  }
}


// ゲーム本体 //
void game(){
  frameRate(60);
  float V = 50/Real + 1; //パックマンの重さ
  float Dx = mouseX - x; //パックマンx座標
  float Dy = mouseY - y; //パックマンy座標
  float D = sqrt(sq(Dx)+sq(Dy)); //パックマン速度
  float Vx = (V/D) * Dx; //パックマン移動(x)
  float Vy = (V/D) * Dy; //パックマン移動(y)
  x += Vx; //パックマンを移動させる
  y += Vy; //パックマンを移動させる
  
  Pacman(x, y, R); //パックマンの描写
  Rup(); //パックマンの直径
  
  //落単の衝突判定//
  for( int i = n2 - 1; i >= 0; i-- ) {
    for (int j = i + 1; j < n2; j++) {
    if (dist(fx[i], fy[i], fx[j], fy[j]) < fd[i] &&
        (dist(fx[i] - fvx[i], fy[i] - fvy[i], fx[j] - fvx[j], fy[j] - fvy[j])
        > dist(fx[i], fy[i], fx[j], fy[j]))) {
     // 衝突後の速度に変更
      setVelocityAfterCollision(i, j);
    }
  }
  //Hardモードの場合追跡する//
  if ( Mode == 3 && i == n2 - 2 ){
    fx[i] += (mouseX - fx[i]) * 0.01;
    fy[i] += (mouseY - fy[i]) * 0.01;
  } else { 
    fx[i] += fvx[i];
    fy[i] += fvy[i];
  }
  
  //壁に衝突で逆向き
  if (fx[i] - fd[i] / 2 < 0 && fvx[i] < 0 || fx[i] + fd[i] / 2 > width && fvx[i] > 0) {
      fvx[i] = -fvx[i];
    }
    if (fy[i] - fd[i] / 2 < 0 && fvy[i] < 0 || fy[i] + fd[i] / 2 > height && fvy[i] > 0) {
      fvy[i] = -fvy[i];
    }
    Rakutan(fx[i], fy[i], fd[i]); //落単の描写
    if( dist( x, y, fx[i], fy[i] ) < fd[i]/2 && 2*R > fd[i] && fd[i] != 0 ) { 
      R += fd[i]/5;
      fd[i] = 0;
      count2++;
      Real = sqrt(sq(R)+sq(ballR));
    }else if ( dist( x, y, fx[i], fy[i] ) < R-5 + fd[i]/2 && 2*R < fd[i] && fd[i] != 0 ) { 
      LOSE(); //負け
    }
  }
 
  if ( count2 >= n2 ) {
    WIN(); //勝ち
  } 
}

// 衝突後の速度を変更する関数 //
void setVelocityAfterCollision(int i, int j) {
  fvx1[i] = (e * (fvx[j] - fvx[i]) + fvx[i] + fvx[j]) / 2;
  fvx1[j] = (e * (fvx[i] - fvx[j]) + fvx[i] + fvx[j]) / 2;
  fvy1[i] = (e * (fvy[j] - fvy[i]) + fvy[i] + fvy[j]) / 2;
  fvy1[j] = (e * (fvy[i] - fvy[j]) + fvy[i] + fvy[j]) / 2;
  fvx[i] = fvx1[i];
  fvx[j] = fvx1[j];
  fvy[i] = fvy1[i];
  fvy[j] = fvy1[j];
}

// 落単の描写をする関数 //  
void Rakutan (float ffx, float ffy, float ffd ) {
 noStroke();
 fill(0);
 ellipse(ffx, ffy, ffd, ffd);
 fill(255);
 if ( ffd == 0 ) {
 textSize(1);
 }else{
   textSize(ffd*0.9);
 }
 textAlign(CENTER,CENTER);
 text("F",ffx, ffy);
}

// パックマンの描写をする関数 //
void Pacman(float px, float py, float pr ) {
  noStroke();
  float a = 30 + 25 * sin(radians(px*10));
  fill(30,255,255);
  ellipse(px, py, 2*pr+3, 2*pr+3);
  fill(45, 255, 255);
  if ( mouseX >= px + 5 ) { //マウスカーソルの位置で開閉方向を決める
    arc(px, py, 2*pr, 2*pr, radians(a), radians(360-a));
  }else {
    arc(px, py, 2*pr, 2*pr, radians(180+a), radians(530-a));
  }
}

// パックマンの直径を決める関数 //
void Rup(){
  for ( int i = 0; i < n; i++ ) {
    fill(ballc[i], 255, 255); 
    ellipse(ballx[i], bally[i], 2*ballR, 2*ballR); 
    if( dist( x, y, ballx[i], bally[i] ) < R ) { 
      ballx[i] = random(0, width); 
      bally[i] = random(0, height); 
      R += 0.1;
      Real = sqrt(sq(R)+sq(ballR));
    }
  }
}

// ゲーム中の背景 //
void gamebg() {
  background(255);
  stroke(0);
  strokeWeight(0.1);
  noFill();
  for ( int i = 0; i < width /40; i++ ) { //罫線の描写
    line(i*40,    0,  i*40, height);
    line(   0, i*40, width,   i*40);
  }
}

// スタンバイ中の背景 //
void bg() {
  background(255);
  image(te,0,0,width,height); //画像の出力(フォトショで加工、イラレで合成ファイルあり)
  stroke(0);
  strokeWeight(0.1);
  noFill();
  for ( int i = 0; i < width /40; i++ ) { //罫線の描写
    line(i*40,    0,  i*40, height);
    line(   0, i*40, width,   i*40);
  }
}

//　スタート画面を描写する関数 //
void startWindow(){
  textAlign(CENTER);
  textSize(100);
  fill(0);
  text("Kutr.io",width/2,height/3); //タイトル:Kutr.io
  stroke(0);
  strokeWeight(2);
  line(100,300,700,300);
  textSize(50);
  text("Easy",width/2,height/2+30); //Easy
  text("Nomal",width/2,height/2+155); //Nomal
  text("Hard",width/2,height/2+280); //Hard
  noFill();
  rect(180, 375, 440, 80);
  rect(180, 498, 440, 80);
  rect(180, 621, 440, 80);
  // 長方形内にカーソルが入った場合 //
  if ( 180 <= mouseX && mouseX <= 620 && 375 <= mouseY && mouseY <= 455 ) { 
    fill(0);
    rect(180,375,440,80);
    fill(255);
    text("Speed:3",width/2,height/2+30);
  }else if ( 180 <= mouseX && mouseX <= 620 && 498 <= mouseY && mouseY <= 578 ){
    fill(0);
    rect(180,498,440,80);
    fill(255);
    text("Speed:4",width/2,height/2+155);
  }else if ( 180 <= mouseX && mouseX <= 620 && 621 <= mouseY && mouseY <= 701) {
    fill(0);
    rect(180,621,440,80);
    fill(255);
    text("Speed:6 & Chase",width/2,height/2+280);
  }
}

// カウント画面の表示 //
void standbyWindow() {
  noStroke();
  for( int i = 0; i < n; i++ ) { 
  fill(ballc[i],255,255);
    ellipse(ballx[i], bally[i], 2*ballR, 2*ballR);
  }
  frameRate(1); //フレームの速度を落とす
  if( startWordCount == 1 || startWordCount == 2 ) {
    textSize(50);
  }else {
    textSize(100);
  }
  textAlign(CENTER);
  fill(0);
  text(startWord[startWordCount], width/2, height/2); //カウントダウンの描写
}

// 勝利画面を呼び出す関数 //
void WIN() {
  result = 1;
  x = 0; 
  y = 0; 
  Real = 0;
  noStroke();
  for( int i = 0; i < n; i++ ) { 
    fill(ballc[i],255,255);
    ellipse(ballx[i], bally[i], 2*ballR, 2*ballR);
  }
  textAlign(CENTER);
  textSize(90);
  fill(0);
  text("Congratulation!!",width/2,height/2-80);
  stroke(0);
  textSize(50);
  text("Once Again",width/2,height/2+80);
  text("Mode Select",width/2,height/2+220);
  noFill();
  strokeWeight(2);
  rect(240,422,320,80);
  rect(240,560,320,80);
  count1 = 3;
  // 長方形内にマウスカーソルがおかれた場合 //
  if ( 240 <= mouseX && mouseX <= 560 && 422 <= mouseY && mouseY <= 502 ) { 
    fill(0);
    rect(240,422,320,80);
    fill(255);
    text("Get Tani",width/2,height/2+80);
  }else if ( 240 <= mouseX && mouseX <= 560 && 560 <= mouseY && mouseY <= 640 ){
    fill(0);
    rect(240,560,320,80);
    fill(255);
    text("Shinkyu",width/2,height/2+220);
  }
}

// 敗北画面を呼び出す関数 //
void LOSE() {
  result = 2;
  x = 0; 
  y = 0; 
  Real = 0;
  for( int i = 0; i < n2; i++ ) { 
    fx[i] = 0; 
    fy[i] = 0;
    fd[i] = 0;
  }
  noStroke();
  for( int i = 0; i < n; i++ ) { 
    fill(ballc[i],255,255);
    ellipse(ballx[i], bally[i], 2*ballR, 2*ballR);
  }
  textAlign(CENTER);
  textSize(90);
  fill(0);
  text("Eaten...",width/2,height/2-80);
  stroke(0);
  textSize(50);
  text("Continue",width/2,height/2+80);
  text("Title",width/2,height/2+220);
  noFill();
  strokeWeight(2);
  rect(240,422,320,80);
  rect(240,560,320,80);
  count1 = 3;
  // 長方形内にマウスカーソルがおかれた場合 //
  if ( 240 <= mouseX && mouseX <= 560 && 422 <= mouseY && mouseY <= 502 ) { 
    fill(0);
    rect(240,422,320,80);
    fill(255);
    text("Sairishu",width/2,height/2+80);
  }else if ( 240 <= mouseX && mouseX <= 560 && 560 <= mouseY && mouseY <= 640 ){
    fill(0);
    rect(240,560,320,80);
    fill(255);
    text("RAKUTAN",width/2,height/2+220);
  }
}
