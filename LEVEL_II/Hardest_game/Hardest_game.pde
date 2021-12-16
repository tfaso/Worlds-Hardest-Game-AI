Population test;
Tiles tile;

PVector goal  = new PVector(900, 250);
float circleX = 50;
int gen = 1;
int smallx = 400;
int smally = 400;
int newSmallx;
boolean run = true;
Population p = new Population();
int step;

PFont f;

void setup() {
  size(1200, 700); //size of the window
  frameRate(100);//increase this to make the squares go faster
  test = new Population(200);//create a new population with 1000 members
  tile = new Tiles();
  
   f = createFont("Arial",125,true);
  
}

void draw() { 
  background(169, 193, 239);
  
  stroke(0);
  rectMode(CORNER);
  fill(175, 239, 169); //green
  strokeWeight(3);
  rect(150, 250, 150, 200);       //startzone
  rect(goal.x, goal.y, 150, 200); //finish zone

  fill(0);
  text("Generation: "+ gen, 30, 50);
if(test.minStep < 1000)
    text("Steps: " + test.minStep, 30, 70);
 // text("Fitness " + step, 10, 75);
  
  fill(250, 250, 250); //off-white
  rect(300, 100, 600, 500); //middle area
  fill(255,0,0);
  noStroke();


  fill(0);
//  fill(169, 193, 239);
 // rect(252.5, 452.5, 46, 156);

 tile.draw();
  if (test.allDotsDead()) {
    //genetic algorithm
    test.calculateFitness();
    test.naturalSelection();
    test.mutateBabies();
    step = p.minStep;
    gen++;
  } else {
    //if any of the squares are still alive then update and then show them

    test.update();
    test.show();
  }
}
