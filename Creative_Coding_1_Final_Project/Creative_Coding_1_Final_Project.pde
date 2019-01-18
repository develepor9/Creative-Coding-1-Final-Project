// images
PImage [] playerMoveRifle = new PImage [20];
PImage [] playerLegs = new PImage [20];
PImage [] playerRifleIdle = new PImage [20];
PImage crosshair;
PImage enemy;

// sound
import processing.sound.*;
SoundFile backgroundMusic;
SoundFile shotSound;
String filenameMusic = "mii channel music but played on the violin.mp3";
String filenameShot = "rifleSound.mp3";
String path;
String path2;

// variables
int scene;
int startTime;
int spawnLocation;
int spawnTime;

// objects
Player survivor;
ArrayList <Enemy> zombies;

void setup ()
{
  size (1400, 800, P2D);

  for ( int i =0; i < 20; i ++)
  {
    playerMoveRifle[i] = loadImage ("survivor-move_rifle_"+i+".png");
    playerMoveRifle[i].resize(playerMoveRifle[i].width/3, playerMoveRifle[i].height/3);
    playerLegs[i] = loadImage ("survivor-run_"+i+".png");
    playerLegs[i].resize(playerLegs[i].width/3, playerLegs[i].height/3);
    playerRifleIdle[i] = loadImage ("survivor-idle_rifle_"+i+".png");
    playerRifleIdle[i].resize(playerRifleIdle[i].width/3, playerRifleIdle[i].height/3);
  }

  crosshair = loadImage ("crosshair.png");
  crosshair.resize(25, 25);
  enemy = loadImage ("enemy.png");

  path = sketchPath(filenameMusic);
  backgroundMusic = new SoundFile(this, path);
  path2 = sketchPath(filenameShot);
  shotSound = new SoundFile(this, path2);

  survivor = new Player();
  zombies = new ArrayList <Enemy>();

  imageMode (CENTER);
  rectMode (CENTER);
  textAlign (CENTER, CENTER);
  noCursor();
  scene = 1;
}

void draw ()
{
  if (scene == 1)
  {
    sceneOne();
  }
  if (scene == 2)
  {
    sceneTwo();
  }
  if (scene == 3)
  {
    sceneThree();
  }
}

void sceneOne ()
{
  background (150);
  fill (0);
  textSize (22);
  text ("Use wasd to move and left click to shoot." 
    +" You get 10 points for killing an enemy and 1 "+
    "point for every second you stay alive. Press"+
    " 'r' to reload. Try not to die. Press enter to continue.", 
    width/2, height/2, 800, 400);

  if (keyPressed)
  {
    if (key == '\n')
    {
      startTime = millis();
      scene =2;
      backgroundMusic.loop();
      spawnTime = millis()+2000;
    }
  }
}

void sceneTwo ()
{
  background (150);

  // Enemy spawn circles
  fill(150, 50, 50);
  ellipse (300, height/2, 100, 100);
  ellipse (width-300, height/2, 100, 100);
  fill (0);
  text ("Enemy Spawn", 300, height/2);
  text ("Enemy Spawn", width-300, height/2);

  // spawns a new enemy in one of two locations every two seconds
  if (millis() - spawnTime > 2000)
  {
    spawnTime = millis();
    spawnLocation = (int)(random(2));
    if (spawnLocation > 0)
    {
      zombies.add(new Enemy(300, 400));
    } else
    {
      zombies.add(new Enemy(1100, 400));
    }
  } 
  
  // deletes the zombie if it is dead
  for (int i =0; i < zombies.size(); i++)
  {
    Enemy zombie = zombies.get(i);

    if (zombie.getState())
    {
      zombies.remove(zombie);
    }
    
    // zombie collisions with other zombies (doesn't work)
    if (i < zombies.size()-2)
    {
      Enemy nextZombie = zombies.get(i+1);
      zombie.collisions(nextZombie.getX(), nextZombie.getH(), zombie.getH()/2, zombie.getH()/2);
    }
    
    // zombie functions
    zombie.render();
    zombie.move();
  }
  
  // player functions
  for (Enemy zombie : zombies)
  {
    survivor.collisions (zombie.getX(), zombie.getY(), zombie.getH()/3, survivor.getW()/3);
  }
  survivor.move();
  survivor.actions();
  survivor.render();
  survivor.display();

  // ends the game if the player's health is less than zero
  if (survivor.getState())
  {
    scene =3;
  }
}

void sceneThree ()
{
  background (150);
  fill (0);
  textSize (22);
  text ("You died!", width/2, height/2);
  text ("You scored " + survivor.getScore() + " points", width/2, height/2+20);
}
