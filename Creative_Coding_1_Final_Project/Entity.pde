class Entity
{
  protected float x;
  protected float y;
  protected float speedMax;
  protected float xSpeed;
  protected float ySpeed;
  protected float h;
  protected float w;
  protected float rotateAngle;
  protected int health;
  protected int buffer;
  protected boolean contact;
  protected boolean isDead;

  void setMovement (float _x, float _y)
  {
    rotateAngle = atan2 (_y-y, _x-x);
    
    // calculating x and y speed so that the object travels towards the _x _y point if the 
    // x and y speed are added to the x and y pos
    ySpeed = speedMax*(sin(rotateAngle));
    xSpeed = sqrt(sq(speedMax)-sq(ySpeed));
    
    // makes xSpeed negative if angle is in the 2nd or 3rd quadrant so the object will still move
    // in the direction of the point _x _y if both x and y speed are just added to the x and y pos
    if (PI/2 < rotateAngle && rotateAngle < PI || rotateAngle < -PI/2 && rotateAngle > -PI)
    {
      xSpeed *= -1;
    }
    
    //println (rotateAngle);
  }

  void collisions (float _x, float _y, float radius, float _radius)
  {
    if ( dist (x,y,_x,_y) < radius + _radius)
    {
      contact = true;  
      if ((x - _x) > 0) 
      {
        x += speedMax;
      } else if ((x - _x) < 0)
      {
        x -= speedMax;
      }
        if ((y - _y) > 0)
      {
        y += speedMax;
      } else if ((y - _y) < 0)
      {
        y -= speedMax;
      }
    }
    else 
    {
      contact = false;
    }
    
    // keeps the object on screen
    if (x < 0) { 
      x += speedMax;
    }
    if (y < 0) { 
      y += speedMax;
    }
    if (x > width) {
      x -= speedMax;
    }
    if (y > height) { 
      y -= speedMax;
    }
    
    // if health is less than zero the object is dead
    if (health < 1)
    {
      isDead = true;
    }
  }

  // Getters and setters
  public float getX () { return x;}
  public float getY () { return y;}
  public float getH () { return h;}
  public float getW () { return w;}
  public int getHealth () { return health;}
  public boolean getState () { return isDead;}
  public void setHealth (int _health) {health = _health;}
}
