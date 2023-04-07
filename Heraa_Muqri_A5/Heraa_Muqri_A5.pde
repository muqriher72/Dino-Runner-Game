/**************************
 * Heraa Muqri             *
 *                         *
 * Heraa_Muqri_A5.pde      *
 *                         *
 * ICS 3U1 - Assignment 5  *
 *                         *
 *    Runaway Dino Game    *
 * A program that runs a   *
 * running game            *
 * using various methods,  *
 * loops, if statements,   *
 * and different arrays.   *
 *                         *
 * January 25, 2020        *
 **************************/

//General Variables
int gameState = 1; // 1 - Welcome Screen, 2 - Instructions Screen, 3 - Select a Level Screen, 4 - Game Screen and 5 - Game Over Screen.
int score = 0;
int level = 0; // Variable to control the level of the game, 1 - easy mode and 2 - hard mode.
boolean gameOver = false;
PImage [] backgroundImages = new PImage [3];
PFont font, font1, font2;

//Dinosaur Variables
PImage [] dinosaurImages = new PImage [10]; // array used to store the different dinosaur images used to animate the dinosaur.
PVector DinosaurPosition = new PVector (155, 340);
PVector DinosaurVelocity = new PVector (0, -4); 
PVector DinosaurGravity = new PVector (0, 0.5);
float dinosaurAirResistance = 0.99; //
boolean dinosaurDuck = false;
boolean dinosaurJump = false;
boolean dinosaurRun = false;
boolean dinosaurStartMoving = false; // controls when the dinosaur starts animating which in turn allows other obstacles to start moving and officially starts the game.
int dinosaurEasyLevelLives = 3;
int dinosaurHardLevelLives = 1;
int stopwatchDinosaur = 0; // variable used to make the score increase by 1 every half a second once the dinosaur starts moving.
int dinosaurState = 0; // controls the state of the dinosaur.  
int imageState = 0; // controls which image of the dinosaur is displayed.
boolean dinosaurOnScreen = true; 
boolean dinosaurRockOrBirdCollision = false;
int dinosaurEasyLevelSpeed = 3, dinosaurHardLevelSpeed = 5;

//Rock Variables
PImage rock;
int [] rockXPositions = {325, 965}; // controls the x positions of 2 rock obstacles on the screen.
int rockYPosition = 375; // controls the y position of 2 rock obstacles on the screen.

//Bird Variables
PImage bird;
int [] birdXPositions = {645, 1285}; // controls the x positions of 2 bird obstacles on the screen.
int birdYPosition = 245;

void setup () {
  size (700, 500);
  imageMode (CENTER);

  // The following code loads 3 different fonts and stores them in their appropriate font variables.
  font = loadFont ("Impact-48.vlw");
  font1 = loadFont ("Calibri-BoldItalic-48.vlw");
  font2 = loadFont ("LucidaConsole-48.vlw");

  // The following code loads 3 background images and stores them in their appropriate variables.
  backgroundImages [0] = loadImage ("background1.png"); // game screen background
  backgroundImages [1] = loadImage ("background2.png"); // welcome screen background
  backgroundImages [2] = loadImage ("background3.png"); // level, instructions and game over screen background

  // The following code loads 8 different pictures of the dinosaur RUNNING and stores them in their appropriate variables.
  dinosaurImages [0] = loadImage ("dinosaurSprites/Run (1).png");
  dinosaurImages [1] = loadImage ("dinosaurSprites/Run (2).png");
  dinosaurImages [2] = loadImage ("dinosaurSprites/Run (3).png");
  dinosaurImages [3] = loadImage ("dinosaurSprites/Run (4).png");
  dinosaurImages [4] = loadImage ("dinosaurSprites/Run (5).png");
  dinosaurImages [5] = loadImage ("dinosaurSprites/Run (6).png");
  dinosaurImages [6] = loadImage ("dinosaurSprites/Run (7).png");
  dinosaurImages [7] = loadImage ("dinosaurSprites/Run (8).png");

  // The following code loads 2 different pictures of the dinosaur DUCKING and stores them in their appropriate variables.
  dinosaurImages [8] = loadImage ("dinosaurSprites/Jump (2).png");
  dinosaurImages [9] = loadImage ("dinosaurSprites/Jump (3).png");

  // The following code loads 2 different pictures of the 2 OBSTACLES and stores them in their appropriate variables.  
  bird = loadImage ("bird.png");
  rock = loadImage ("rock.png");
}

void draw () {
  if (gameState == 1) { // WELCOME SCREEN
    welcomeScreen ();
  } else if (gameState == 2) { // INSTRUCTIONS SCREEN
    instructionsScreen ();
  } else if (gameState == 3) { // GAME LEVEL SELECTION SCREEN
    gameLevelSelectionScreen ();
  } else if (gameState == 4) { // GAME SCREEN
    drawDinosaur ();
    duckDinosaur ();
    dinosaurGravity ();
    increaseScore ();
    drawAndMoveRocks ();
    checkIfRockHitScreenEdges ();
    drawBird ();
    checkIfBirdHitScreenEdges ();
    checkGameOverConditionsMet ();
    displayDinosaurLives ();
    displayScore ();
    moveDinosaurAndCheckIfDinosaurHitScreenEdge ();
  } else if (gameState == 5) { // GAME OVER SCREEN
    gameOverScreen ();
    displayScore ();
    noLoop (); // stops the draw loop from executing the code inside of it.
  }
}

void setVariables () { // method that sets the variables/ boolean switches to their initial values or states.
  level = 0;
  score = 0;
  gameOver = false;
  dinosaurEasyLevelLives = 3;
  dinosaurHardLevelLives = 1;
  dinosaurOnScreen = true; // change to true
  dinosaurStartMoving = false;
  dinosaurRun = false;
  dinosaurDuck = false;
  dinosaurJump = false;
  stopwatchDinosaur = 0;
  dinosaurState = 0;
  imageState = 0;
  DinosaurPosition.y = 340;
  birdXPositions [0] = 600;
  birdXPositions [1] = 1150;
  rockXPositions [0] = 325;
  rockXPositions [1] = 875;
  dinosaurRockOrBirdCollision = false;
}

void welcomeScreen () { // method that displays the welcome screen image along with text.
  image (backgroundImages [1], 350, 250);
  textFont (font1, 90);
  text ("RUNAWAY", 160, 200); // callibri bold italic - runaway, dino -impact
  textFont (font, 85);
  text ("DINO", 285, 300);
  textFont (font2, 20);
  text ("Press the spacebar to load the instructions!", 85, 455); // lucida console
}

void instructionsScreen () { // method that displays the instruction screen image along with text.
  image (backgroundImages [2], 350, 250);
  textFont (font, 60);
  text ("HOW TO PLAY", 200, 75);
  textFont (font2, 20);
  text ("Use the up arrow key to make the dinosaur jump.", 75, 125);
  text ("Use the down arrow key to make the dinosaur duck.", 60, 180);
  text ("The dinosaur has 3 lives in easy mode and 1 life", 60, 235);
  text ("in hard mode.", 280, 265);
  text ("The dinosaur has to avoid 2 obstacles and everytime it", 20, 320);
  text ("hits an obstacle, the obstacles reset positions.", 65, 350);
  text ("Keep the dinosaur running as long as possible!", 70, 400);
  textSize (20);
  text ("Press the enter key to load the level selection screen!", 20, 465);
}

void gameLevelSelectionScreen () { // method that displays the game level selection screen image along with text.
  image (backgroundImages [2], 350, 250);
  textFont (font, 60);
  text ("CHOOSE A LEVEL", 160, 75);
  text ("EASY", 300, 185);
  text ("HARD", 290, 385);
  textFont (font2, 30);
  text ("Press the 1 key to play EASY mode!", 45, 250);
  text ("Press the 2 key to play HARD mode!", 45, 450);
}

void gameOverScreen () { // method that displays the game over screen image along with text.
  image (backgroundImages [2], 350, 250);
  textFont (font, 90);
  fill (#ffffff);
  text ("GAME OVER", 150, 250); 
  textFont (font2, 25);
  text ("Press the backspace key to restart the game!", 25, 455);
}


void drawDinosaur () { // method that draws the game screen image and the animated dinosaur RUNNING.
  image (backgroundImages [0], 350, 250);
  if (dinosaurOnScreen == true) {
    if (dinosaurStartMoving == true && dinosaurRun == true) { // animates the dinosaur to make it RUN IF it is on the screen, is moving and running.
      if (dinosaurState < 10) {
        imageState = 1;
      } else if (dinosaurState < 20) {
        imageState = 2;
      } else if (dinosaurState < 30) {
        imageState = 3;
      } else if (dinosaurState < 40) {
        imageState = 4;
      } else if (dinosaurState < 50) {
        imageState = 5;
      } else if (dinosaurState < 60) {
        imageState = 6;
      } else if (dinosaurState < 70) {
        imageState = 7;
      } else if (dinosaurState < 80) {
        imageState = 0;
        dinosaurState = 1;
      }
      dinosaurState++;
    }
    image (dinosaurImages [imageState], DinosaurPosition.x, DinosaurPosition.y);
  }
}

void moveDinosaurAndCheckIfDinosaurHitScreenEdge() { // method that moves and accelerates dinosaur realistically.
  //The following dummy variable represents the top side of the dinosaur for collision detection.
  float dinosaurTopSide = DinosaurPosition.y - 69;
  if (dinosaurStartMoving == false && dinosaurRockOrBirdCollision == false) { // text is displayed asking user to press the right arrow key to make dinosaur move.
    fill (#ffffff);
    text ("Press the right arrow key to start!", 30, 250);
  }
  if (dinosaurStartMoving == false && dinosaurRockOrBirdCollision == true) {
    fill (#ffffff);
    text ("You hit an obstacle!", 180, 200);
    text ("Press the right arrow key to continue!", 10, 250);
  }
  if (dinosaurStartMoving == true && dinosaurJump == true) { 
    DinosaurVelocity = DinosaurVelocity.add(DinosaurGravity);
    DinosaurVelocity = DinosaurVelocity.mult(dinosaurAirResistance);
    DinosaurPosition = DinosaurPosition.add(DinosaurVelocity);
    if (DinosaurPosition.y > 335) { // makes the dinosaur land on the ground once it jumps.
      DinosaurVelocity.y = 0;
      DinosaurPosition.y = 335;
      dinosaurJump = false;
    }
    if (dinosaurTopSide <= 5) { // ensures the dinosaur's y position increases when it touches the top edge of the screen to prevent it from going off the screen.
      DinosaurPosition.y += 69;
    }
  }
}

void duckDinosaur () { // method that draws the animated dinosaur DUCKING.
  if (dinosaurStartMoving == true && dinosaurDuck == true) { // animates the dinosaur to make it DUCK if the down key is pressed.
    dinosaurState = 0;
    if (dinosaurState < 10) {
      imageState = 8;
    } else if (dinosaurState < 20) {
      imageState = 9;
    } else {
      imageState = 8;
    }
    dinosaurState++;
  }
}

void dinosaurGravity () { // method that allows the dinosaur's velocity to be affected by gravity so it accelerates realistically.
  DinosaurVelocity = DinosaurVelocity.add(DinosaurGravity);
}

void increaseScore () { // method that increases the score by 1 every half a second ONCE the dinosaur starts moving.
  if (dinosaurOnScreen == true && dinosaurStartMoving == true) {
    if (millis() - stopwatchDinosaur > 500) {
      stopwatchDinosaur = millis();
      score++;
    }
  }
}

void drawBird () { // method that draws the bird obstacles on the screen if specific conditions are met.
  for (int counter = 0; counter < 2; counter++) {
    image (bird, birdXPositions [counter], birdYPosition);
    moveBird (counter); // method to move the bird horizontally at a specific speed.
    checkIfDinosaurHitBird (counter); // method to check if the dinosaur hit the birds.
  }
}

void moveBird (int counter) { // method that moves the bird obstacles horizontally at a specifc speed ONCE the dinosaur starts moving.
  if (dinosaurStartMoving == true) {
    if (level == 1) {
      birdXPositions [counter] -= dinosaurEasyLevelSpeed;
    }
    if (level == 2) {
      birdXPositions [counter] -= dinosaurHardLevelSpeed;
    }
  }
}

void checkIfBirdHitScreenEdges () { // method that checks if the bird obstacles hit the edge of the screen.
  if (birdXPositions [0] > 700 || birdXPositions [0] < 0) { // if the first bird is off the screen. 
    if (birdXPositions [1] < 350) { // and the second bird is in the middle of the screen.
      birdXPositions [0] = birdXPositions [1] + 640; // the first bird reappears from the right edge of the screen.
    }
  }
  if (birdXPositions [1] > 700 || birdXPositions [1] < 0) { // if the second bird is off the screen.
    if (birdXPositions [0] < 350) { // and the first bird is in the middle of the screen.
      birdXPositions [1] = birdXPositions [0] + 640; // the second bird reappears from the right edge of the screen.
    }
  }
}

void checkIfDinosaurHitBird (int counter) { // method that checks if the dinosaur hit the bird using dummy variables and decreases lives appropriately.
  if (dinosaurOnScreen == true && dinosaurStartMoving == true) {
    if (dinosaurDuck == true) {
      // The following are dummy variables to represent different sides of the birds and dinosaur.
      int birdLeftSide = birdXPositions [counter] - 65;
      int birdRightSide = birdXPositions [counter] + 65;
      int birdBottomSide = birdYPosition + 48;
      float dinosaurTopSide = DinosaurPosition.y - 32;
      float dinosaurRightSide = DinosaurPosition.x + 30;
      float dinosaurLeftSide = DinosaurPosition.x - 75;
      // LEFT SIDE COLLISION
      if (birdLeftSide < dinosaurRightSide && birdLeftSide > dinosaurLeftSide && dinosaurTopSide < birdBottomSide) {
        obstacleCollision ();
      }
      // RIGHT SIDE COLLISION
      if (birdRightSide > dinosaurLeftSide && birdLeftSide < dinosaurLeftSide && dinosaurTopSide < birdBottomSide) {
        obstacleCollision ();
      }
    }
    if (dinosaurDuck == false) {
      // The following are dummy variables to represent different sides of the birds and dinosaur.
      int birdLeftSide = birdXPositions [counter] - 65;
      int birdRightSide = birdXPositions [counter] + 65;
      int birdBottomSide = birdYPosition + 60;
      float dinosaurTopSide = DinosaurPosition.y - 49;
      float dinosaurRightSide = DinosaurPosition.x + 30;
      float dinosaurLeftSide = DinosaurPosition.x - 75;
      // LEFT SIDE COLLISION
      if (birdLeftSide < dinosaurRightSide && birdLeftSide > dinosaurLeftSide && dinosaurTopSide < birdBottomSide) {
        obstacleCollision ();
      }
      // RIGHT SIDE COLLISION
      if (birdRightSide > dinosaurLeftSide && birdLeftSide < dinosaurLeftSide && dinosaurTopSide < birdBottomSide) {
        obstacleCollision ();
      }
    }
  }
}

void drawAndMoveRocks () { // method that draws and moves the rock obstacles horizontally at a certain speed ONCE the dinosaur starts moving and checks if the dinosaur hit the rocks.
  for (int counter = 0; counter < 2; counter++) {
    image (rock, rockXPositions [counter], rockYPosition);
    if (dinosaurStartMoving == true) {
      if (level == 1) {
        rockXPositions [counter] -= dinosaurEasyLevelSpeed;
      }
      if (level == 2) {
        rockXPositions [counter] -= dinosaurHardLevelSpeed;
      }
      checkIfDinosaurHitRock (counter); // method that checks if the dinosaur hit the rocks.
    }
  }
}

void checkIfRockHitScreenEdges () { // method that checks if the rocks hit the edges of the screen.
  if (rockXPositions [0] > 700 || rockXPositions [0] < 0) { // if the first rock is off the screen.
    if (rockXPositions [1] < 350) { // and the second rock is in the middle of the screen.
      rockXPositions [0] = rockXPositions [1] + 640; // the first rock reappears from the right edge of the screen.
    }
  }
  if (rockXPositions [1] > 700 || rockXPositions [1] < 0) { // if the second rock is off the screen.
    if (rockXPositions [0] < 350) { // and the first rock is in the middle of the screen.
      rockXPositions [1] = rockXPositions [0] + 640; // the second rock reappears from the right edge of the screen.
    }
  }
}

void checkIfDinosaurHitRock (int counter) { // method that checks if the dinosaur hit the rocks and decreases lives appropriately.
  // The following are dummy variables that represent the different sides of the rocks and dinosaur for collision detection.
  int rockLeftSide = rockXPositions [counter] - 25;
  int rockRightSide = rockXPositions [counter] + 25;
  int rockTop = rockYPosition - 22;
  float dinosaurRightSide = DinosaurPosition.x + 15;
  float dinosaurLeftSide = DinosaurPosition.x - 80;
  float dinosaurBottom = DinosaurPosition.y + 59; // 
  if (dinosaurOnScreen == true && dinosaurStartMoving == true) {
    if (rockLeftSide < dinosaurRightSide && rockLeftSide > dinosaurLeftSide && dinosaurBottom > rockTop) { // Left Side Obstacle Collision
      obstacleCollision ();
    }
    if (rockRightSide > dinosaurLeftSide && rockLeftSide < dinosaurLeftSide && dinosaurBottom > rockTop) { // Right Side Obstacle Collision
      obstacleCollision ();
    }
  }
}

void obstacleCollision () { // method that decreases the lives of the player and resets variables in case of an obstacle collision.
  if (level == 1) {
    dinosaurEasyLevelLives-- ;
  } else if (level == 2) {
    dinosaurHardLevelLives-- ;
  }
  dinosaurStartMoving = false;
  dinosaurRockOrBirdCollision = true;
  // The following code resets the positions of the obstacles and the dinosaur after the player loses a life.
  birdXPositions [0] = 645;
  birdXPositions [1] = 1285;
  rockXPositions [0] = 325;
  rockXPositions [1] = 965;
  DinosaurPosition.y = 340;
  imageState = 0;
  dinosaurState = 0;
  dinosaurRun = false;
  dinosaurDuck = false;
  dinosaurJump = false;
}

void checkGameOverConditionsMet () { // method that checks if the game over conditions have been met.
  if (dinosaurEasyLevelLives == 0 || dinosaurHardLevelLives == 0) {
    dinosaurOnScreen = false;
    gameOver = true;
    gameState = 5;
  }
}

void displayDinosaurLives () { // method that displays the number of lives of the dinosaur.
  if (level == 1) { // EASY MODE
    fill (#000000);
    text ("DINOSAUR LIVES:" + dinosaurEasyLevelLives, 80, 55);
  } else if (level == 2) { // HARD MODE
    fill (#000000);
    text ("DINOSAUR LIVES:" + dinosaurHardLevelLives, 80, 55);
  }
}

void displayScore () { // method that displays the score of the user.
  if (gameOver == false) {
    text ("SCORE:" + score, 450, 55);
  }
  if (gameOver == true) {
    text ("YOUR FINAL SCORE: " + score, 185, 300);
  }
}


void keyPressed () { // runs code inside IF A SPECIFIC KEY IS PRESSED. 
  if (gameState == 1) { //WELCOME SCREEN
    if (keyCode == 32) { // SPACEBAR KEY launches instructions screen.
      gameState = 2;
    }
  } else if (gameState == 2) { //INSTRUCTIONS SCREEN
    if (keyCode == 10) { // ENTER KEY launches game level selection screen.
      gameState = 3;
    }
  } else if (gameState == 3) { // GAME LEVEL SCREEN
    if (keyCode == 49) { // KEY 1 launches game screen in EASY MODE.
      gameState = 4;
      level = 1;
    }
    if (keyCode == 50) { // KEY 2 launches game screen in HARD MODE.
      gameState = 4;
      level = 2;
    }
  } else if (gameState == 4) { // GAME SCREEN
    if (keyCode == 38) { // UP ARROW KEY makes dinosaur jump.
      dinosaurJump = true;
      DinosaurVelocity.y = -18;
    }
    if (keyCode == 40) { // DOWN ARROW KEY makes dinosaur duck.
      dinosaurDuck = true;
      dinosaurRun = false;
    }
    if (keyCode == 39) { //RIGHT ARROW KEY makes dinosaur start moving and run.
      dinosaurStartMoving = true;
      dinosaurRun = true;
      dinosaurRockOrBirdCollision = false;
    }
  } else if (gameState == 5) { // GAME OVER SCREEN
    if (gameOver == true && keyCode == 8) { // BACKSPACE KEY restarts the game.
      gameState = 2;
      setVariables ();
      gameOver = false;
      loop (); // allows draw to start executing the code inside of it again.
    }
  }
}

void keyReleased () { // runs code inside IF A SPECIFIC KEY IS RELEASED.
  if (gameState == 4) { // GAME SCREEN
    if (keyCode == 40) { //DOWN ARROW KEY makes dinosaur stop ducking and start running.
      dinosaurDuck = false;
      dinosaurRun = true;
    }
  }
}
