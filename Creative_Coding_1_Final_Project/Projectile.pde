class Projectile extends Entity
{
  int newHealth;
  
  Projectile (float _x, float _y)
  {
    x = _x;
    y = _y;
    h = 5;
    w = 10;
    speedMax = 6.5;
    setMovement (mouseX,mouseY);
  }
  
  void render ()
  {
    noStroke();
    pushMatrix();
    translate (x,y);
    rotate (rotateAngle);
    fill (#E1E828);
    // not 0,0 so it lines up with the rifle part of the player image
    ellipse (7,15.5,w,h);
    popMatrix();
  }
  
  void move ()
  {
    x += xSpeed;
    y += ySpeed;
  }
  
  void impact (ArrayList <Enemy> eList)
  {
    for (Enemy zombie : eList)
    {
      if (dist (x, y, zombie.getX(), zombie.getY()) < h + zombie.getW())
      {
        newHealth = zombie.getHealth();
        
        // Note to self: -- is before newHealth so that that operation is executed before it is passed into the function
        zombie.setHealth(--newHealth);
        isDead = true;
      }
    }
    if (x < 0 || y < 0 || x > width || y > height) { 
      isDead = true;
    }
  }
}
