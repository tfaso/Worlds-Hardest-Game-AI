class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this square is the best square from the previous generation

  float fitness = 0;
  float user_rad = 25;
  float enemy_rad = 40;
  float dead_rad = 30;
  float deadx = 325;
  float deady = 475;
  float deadx2 = 875;
  float deady2 = 325;

  float xpos = width/2;
  float ypos = height/2;    // Starting position of shape    

  float xspeed = 4;  // Speed of the shape
  float yspeed = 4;  // Speed of the shape

  int xdirection = 1;  // Left or Right
  int ydirection = 1;  // Top to Bottom
  
  int instructions = 100;
  int maxInstr = 1100;
  int count = 0;
 
  Dot() {
    
    
    brain = new Brain(1000);//new brain with 1000 instructions

    //start the squares at the bottom of the window with a no velocity or acceleration
    pos = new PVector(215, height/2 );
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }


  //-----------------------------------------------------------------------------------------------------------------
  //draws the square on the screen
  void show() {
    rectMode(CENTER);
    //if this square is the best square from the previous generation then draw it as a big green square
    if (isBest) {
      fill(0, 255, 0);
      rect(pos.x, pos.y, 25, 25);
    } else {//all other squares
      fill(255, 0, 0);
      if(dead == false) 
      rect(pos.x, pos.y, user_rad, user_rad);
    }
    //enemy
    fill(0, 0, 255);
    ellipse(xpos, ypos, enemy_rad, enemy_rad);
  }

  void setup_enemy() {
    xpos = width/2;
    ypos = height/2;
  }
  
  void enemy() {
    
    // Update the position of the shape
    xpos = xpos + ( xspeed * xdirection );
    ypos = ypos + ( yspeed * ydirection );
  
    // Test to see if the shape exceeds the boundaries of the screen
    // If it does, reverse its direction by multiplying by -1
    if (xpos > 870- enemy_rad|| xpos < 405- enemy_rad) {
      xdirection *= -1;
    }
    if (ypos > 520-enemy_rad || ypos < 364-enemy_rad) {
      ydirection *= -1;
    }
    
  }
  
  //-----------------------------------------------------------------------------------------------------------------------
  //moves the square according to the brains directions
  void move() {

    if (brain.directions.length > brain.step) {//if there are still directions left then set the acceleration as the next PVector in the direcitons array
      acc = brain.directions[brain.step];
      brain.step++;
    } else {//if at the end of the directions array then the square is dead
      dead = true;
      
    }

    //apply the acceleration and move the square
    vel.add(acc);
    vel.limit(5);//not too fast
    pos.add(vel);
  }

  //-------------------------------------------------------------------------------------------------------------------
  //calls the move function and check for collisions and stuff
  void update() {
    enemy();
    if (!dead && !reachedGoal) {
     
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) {//if near the edges of the window then kill it 
        dead = true;
      } else if (pos.x< 1050 && pos.y < 550 && pos.x > 900 && pos.y > 250) {//if reached goal
 
        reachedGoal = true;
      }
        //borders
        if(pos.y < 264) //top of play area
          pos.y = 265;
        if(pos.x < 164) //left border of play area
          pos.x = 165;
        if(pos.y > 537) //bottom of play area
          pos.y = 536;
        if(pos.x > 354 && pos.x < 800 && pos.y < 314) //top of middle zone
          pos.y = 315;
        if(pos.x > 287 && pos.x < 299 && pos.y < 508 && pos.y > 250) //right border on start zone
          pos.x = 286;
        if(pos.x > 383 && pos.x < 399 && pos.y > 490 && pos.y < 550) //small verticle line on left
          pos.x = 387;
        if(pos.x > 286 && pos.x < 354 && pos.y < 512 && pos.y > 500) //small horizontal line on left
          pos.y = 513;
        if(pos.x > 800 && pos.x < 813 && pos.y > 250 && pos.y < 300) //small verticle line on right
          pos.x = 814;
        if(pos.x > 857 && pos.x < 903 && pos.y < 312 && pos.y > 288) //small horizontal line on right
          pos.y = 287;
        if(pos.x > 399 && pos.x < 850 && pos.y > 488) //bottom of middle zone
          pos.y = 487;
        if(pos.x > 350 && pos.x < 363 && pos.y < 508 && pos.y > 295) //left of middle
          pos.x = 364;
        if(pos.x > 835 && pos.x < 850 && pos.y < 500 && pos.y > 295) //right of middle zone
          pos.x = 836;
        if (dist(pos.x, pos.y, xpos, ypos) < enemy_rad - user_rad + 15)
          dead = true;
        /*if(dist(pos.x, pos.y, deadx, deady) < dead_rad)
          dead = true;
        if(dist(pos.x, pos.y, deadx2, deady2) < dead_rad)
          pos.y = 295;
        if(dist(pos.x, pos.y, deadx2, deady2) < dead_rad - user_rad)
          dead = true;
        */
    }
      
    
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  void calculateFitness() {
    if (reachedGoal) {//if the square reached the goal then the fitness is based on the amount of steps it took to get there
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);

    } else {//if the square didn't reach the goal then the fitness is based on how close it is to the goal
      
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);

      fitness = 1/(distanceToGoal * distanceToGoal);

     
    
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot child() {
    Dot baby = new Dot();
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
