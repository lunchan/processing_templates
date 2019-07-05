ArrayList<Fireworks> fireworks=new ArrayList<Fireworks>();  
//https://qiita.com/mikittt/items/776e6f2a114866386b54

Heartfireworks heart;
float R=0;

void setup () {
  fullScreen(P2D);
  blendMode(ADD);
  imageMode(CENTER);
  heart=new Heartfireworks();
}

void draw () {
  background(0, 0, 65);
  for (int i=0; i<fireworks.size(); i++) {
    Fireworks art=fireworks.get(i);
    if (art.centerPosition.y-art.radius>height) {
      fireworks.remove(i);
    }

    //Heart(width/2, height/2, R);
    //R+=0.5;
    heart.Heart(width/2, height/2);
    heart.reset();


    art.display ();
    art.update();
  }
}


void mousePressed() {
  fireworks.add(new Fireworks(60));
}

PImage createLight(float rPower, float gPower, float bPower) {
  int side=64;
  float center=side/2.0;

  PImage img=createImage(side, side, RGB);

  for (int y=0; y<side; y++) {
    for (int x=0; x<side; x++) {
      float distance=(sq(center-x)+sq(center-y))/10.0;
      int r=int((255*rPower)/distance);
      int g=int((255*gPower)/distance);
      int b=int((255*bPower)/distance);
      img.pixels[x+y*side]=color(r, g, b);
    }
  }
  return img;
}

class Heartfireworks {
  float r;
  Heartfireworks() {
    r=0;
  }
  void Heart (float cx, float cy) {
    for (int i=5; i<200; i+=20) {
      stroke(255, 0, 100);
    }

    //heart
    pushMatrix();
    translate(cx, cy);
    strokeWeight(10);
    for (int theta = 0; theta < 360; theta+=10) {

      float x = r * (16 * sin(radians(theta)) * sin(radians(theta)) * sin(radians(theta)));
      float y = (-1) * r * (13 * cos(radians(theta)) - 5 * cos(radians(2 * theta)) 
        - 2 * cos(radians(3 * theta)) - cos(radians(4 * theta)));
      point(x, y);
    }
    popMatrix();
    r+=0.5;
  }
  void reset() {
    if (mousePressed==true) {
      r=0;
    }
  }
}

class Fireworks {

  int num=500;

  PVector centerPosition=new PVector(random(width/8, width*7/8), random(height/2, height*4/5), random(-100, 100));

  PVector velocity=new PVector(0, -22, 0);

  PVector accel=new PVector(0, 0.4, 0);
  PImage img;

  float radius;

  PVector[] firePosition=new PVector[num];


  Fireworks(float r) {
    float cosTheta;
    float sinTheta;
    float phi;
    float colorchange=random(0, 8);

    radius=r;
    for (int i=0; i<num; i++) {
      cosTheta = random(0, 1) * 2 - 1;
      sinTheta = sqrt(1- cosTheta*cosTheta);
      phi = random(0, 1) * 2 * PI;
      firePosition[i]=new PVector(radius * sinTheta * cos(phi), radius * sinTheta * sin(phi), radius * cosTheta);
      firePosition[i]=PVector.mult(firePosition[i], 1.10);
    }

    if (colorchange>=3.8) {
      img=createLight(0.9, random(0.2, 0.5), random(0.2, 0.5));
    } else if (colorchange>3.2) {
      img=createLight(random(0.2, 0.5), 0.9, random(0.2, 0.5));
    } else if (colorchange>2) {
      img=createLight(random(0.2, 0.5), random(0.2, 0.5), 0.9);
    } else {
      img=createLight(random(0.5, 0.8), random(0.5, 0.8), random(0.5, 0.8));
    }
  }

  void display() {
    for (int i=0; i<num; i++) {
      pushMatrix();
      translate(centerPosition.x, centerPosition.y);
      translate(firePosition[i].x, firePosition[i].y);
      image(img, 0, 0);
      popMatrix();

      firePosition[i]=PVector.mult(firePosition[i], 1.015);
    }
  }

  void update() {
    radius=dist(0, 0, 0, firePosition[0].x, firePosition[0].y, firePosition[0].z);
    centerPosition.add(velocity);
    velocity.add(accel);
  }
}
