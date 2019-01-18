class Enemy extends Entity
{
  int killCount;
  
  Enemy (float _x, float _y)
  {
    x = _x;
    y = _y;
    h = enemy.height;
    w = enemy.width;
    health = 2;
    speedMax = 2;
  }
  
  void render ()
  {
    pushMatrix();
    translate (x,y);
    rotate(rotateAngle);
    image (enemy, 0, 0);
    popMatrix();
  }
  
  void move ()
  {
    // to follow the player
    setMovement (survivor.getX(), survivor.getY());
    x += xSpeed;
    y += ySpeed;
    collisions (survivor.getX(), survivor.getY(), w/2, survivor.getH()/2);
  }
}
