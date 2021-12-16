Population test;
Tiles tile;

PVector goal  = new PVector(900, 250);
float circleX = 50;
int gen = 1;
int smallx = 400;
int smally = 400;
int newSmallx;
boolean run = true;


PFont f;

void setup() {
  //Wait 5 seconds to begin (for recording); comment this out when not in use
  /*try
  {
    Thread.sleep(5000);
  }
  catch(InterruptedException ex)
  {
    Thread.currentThread().interrupt();
  }*/
  
  size(1200, 700); //size of the window
  frameRate(100); //increase this to make the squares go faster
  test = new Population(1000); //create a new population with 1000 members
  tile = new Tiles();
  
  f = createFont("Arial",125,true);
  
}

void draw() { 
  background(169, 193, 239);
  
  stroke(0);
  rectMode(CORNER);
  fill(175, 239, 169); //green
  strokeWeight(3);
  rect(150, 250, 150, 300);       //startzone
  rect(goal.x, goal.y, 150, 300); //finish zone

  fill(0);
  text("Generation "+ gen, 30, 50);
  if(test.minStep < 1000)
    text("Steps " + test.minStep, 30, 70);
  //text("Fitness ", 10, 75);
  
  fill(250, 250, 250); //off-white
  rect(350, 300, 500, 200); //middle area
  rect(300, 500, 100, 50);
  rect(800, 250, 100, 50);
 // rect(800, 300, 1000, 3);
  fill(255,0,0);
  noStroke();

  fill(0);

  //rect(302.5, 452.5, 46, 46);
//rect(852.5, 302.5, 46, 46);
  tile.draw();
  if (test.allDotsDead()) {
    //genetic algorithm
    test.calculateFitness();
    test.naturalSelection();
    test.mutateBabies();
    
    gen++;
  } else {
    //if any of the squares are still alive then update and then show them

    test.update();
    test.show();
  }
}
