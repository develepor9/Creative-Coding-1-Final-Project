class Player extends Entity 
{
  private int frameNum;
  private int frameMax;
  private int renderMode;
  private int ammoCount;
  private int timeSurvived;
  private int enemiesKilled;
  private int score;
  private int reloadBuffer;
  private boolean isReloading;
  ArrayList <Projectile> magazine = new ArrayList <Projectile>();

  Player ()
  {
    x = 700;
    y = 400;
    h = playerRifleIdle[0].height;
    w = playerRifleIdle[0].width;
    frameMax = 20;
    renderMode = 0;
    speedMax = 3.25;
    health = 100;
    ammoCount = 10;
    buffer = 0;
    reloadBuffer = 100;
  }

  void render ()
  {
    imageMode (CENTER);
    
    if (frameNum == frameMax)
    {
      frameNum = 0;
    }
    
    // idle animation
    if (renderMode == 0)
    {
      pushMatrix ();
      translate (x, y);
      rotate (rotateAngle);
      image (playerRifleIdle[frameNum], 0, 0);
      popMatrix();
    }
    
    // forawrd movement animation
    if (renderMode == 1)
    {
      pushMatrix();
      translate (x, y);
      rotate (rotateAngle);
      image (playerLegs[frameNum], -15, 10);
      image (playerMoveRifle[frameNum], 0, 0);
      popMatrix();
    }
    
    // side movement animation
    if (renderMode == 2)
    {
      pushMatrix();
      translate (x, y);
      rotate (PI/2 + rotateAngle);
      image (playerLegs[frameNum], 8, 15);
      rotate (-PI/2);
      image (playerMoveRifle[frameNum], 0, 0);
      popMatrix();
    }

    frameNum++;
    
    image (crosshair, mouseX, mouseY);
  }
  
  void display ()
  {
    rectMode (CORNER);
    textAlign (LEFT);
    
    // Displaying health
    stroke(2);
    fill (150);
    rect (15, 5, 200, 10);
    fill (255,50,50);
    rect (15, 5, health*2, 10);
    fill (0);
    textSize (15);
    text ("Health: "+ health + " / 100", 15, 30);
    
    // Displaying score, time survived etc
    rectMode (CENTER);
    textAlign (CENTER, CENTER);
    
    timeSurvived = (millis() - startTime) / 1000; 
    score = timeSurvived + 10 * enemiesKilled;
    
    text ("Score: " +score, width -700, 15);
    text ("Time survived: " +timeSurvived+ " s", width - 500, 15);
    text ("Enemies killed: " +enemiesKilled, width - 300, 15);
    text ("Ammo left: " +ammoCount+ "/10", width - 100, 15);
    
    if (isReloading)
    {
      if (reloadBuffer > 0)
        {
          noStroke();
          fill (150);
          rect (width - 100, 15, 150,20);
          fill (0);
          text ("Reloading", width - 100, 15);
          reloadBuffer --;
        }
        else 
        {
          ammoCount = 10;
          isReloading = false;
          reloadBuffer = 100;
        }
    }
  }

  void move ()
  {
    setMovement (mouseX, mouseY);
    
    if (contact)
    {
      health --;
    }
    
    if (keyPressed)
    {
      if (key == 'w' || key == 'W')
      {
        renderMode = 1;
        x += xSpeed;
        y += ySpeed; 
      }
      if (key == 's' || key == 'S')
      {
        renderMode = 1;
        x -= xSpeed;
        y -= ySpeed;
      }
      if (key == 'a' || key == 'A')
      {
        renderMode = 2;
        x -= ySpeed;
        y -= xSpeed;
      }
      if (key == 'd' || key == 'D')
      {
        renderMode = 2;
        x -= ySpeed;
        y += xSpeed;
      }
    } else
    {
      renderMode = 0;
    }
  }
  
  void actions ()
  {
    for (int i = 0; i < magazine.size(); i ++)
    {
      Projectile bullet = magazine.get(i);
      
      // deletes the bullet if it hit something
      if (bullet.getState())
      {
        magazine.remove(i);
      }
      else
      {
        bullet.move();
        bullet.render();
        bullet.impact(zombies);
      }
    }
 
    if (mousePressed)
    {
      if (ammoCount > 0)
      {
        if (buffer == 0)
        {
          ammoCount --;
          buffer = 10;
          shotSound.play();
          
          // prevents the player from firing more than 10 bullets without reloading
          if (magazine.size() < 10)
          {
            magazine.add(new Projectile(x,y));
          }
        }
        else
        {
          buffer--;
        }
      }
    }
    
    if (keyPressed)
    {
      if (key == 'r' || key == 'R')
      {
        isReloading = true;
      }
    }
    
    // adds to kill count if zombie died
    for (Enemy zombie : zombies)
    {
      if (zombie.getState())
      {
        enemiesKilled ++;
      }
    }
  }
  
  public int getScore () { return score;}
  public int getEnemiesKilled () { return enemiesKilled;}
}
