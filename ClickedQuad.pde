class ClickedQuad 
{
  PVector[] corners;
  int currCorner;
  int maxZ;
  int minZ;

  ClickedQuad() 
  {
    // set up array of corner data
    corners = new PVector[4];
    for (int i=0; i<4; i++) 
    {
      corners[i] = new PVector(0, 0, 0);
    }

    currCorner = 0;
  }

  void addCorner(int newX, int newY, int newZ)
  {
    // if first corner, initialise z's
    if ( currCorner == 0 ) {
      minZ = newZ;
      maxZ = newZ;
    }

    // if we still have empty corners to fill
    if ( currCorner < 4 ) {
      // fill with corner data
      corners[ currCorner ].x = newX;
      corners[ currCorner ].y = newY;
      corners[ currCorner ].z = newZ;

      if ( newZ < minZ ) minZ = newZ;
      if ( newZ > maxZ ) maxZ = newZ;
    }
    // onto next corner
    currCorner++;
  }

  boolean quadFilled() 
  {
    if ( currCorner >= 4 )
    {
      return true;
    } 
    else 
    {
      return false;
    }
  }

  void drawQuad()
  {
    if ( currCorner < 4 ) {
      for ( int i=0; i<currCorner; i++ ) {
        ellipse(corners[i].x, corners[i].y, 10, 10);
      }
    } 
    else {
      quad( corners[0].x, corners[0].y, 
      corners[1].x, corners[1].y, 
      corners[2].x, corners[2].y, 
      corners[3].x, corners[3].y );
    }
  }

  boolean withinQuad(int px, int py, int pz)
  {
    // taken from:
    // http://hg.postspectacular.com/toxiclibs/src/tip/src.core/toxi/geom/Polygon2D.java
    int num = 4;
    int i, j = num - 1;
    boolean oddNodes = false;
    for (i = 0; i < num; i++) {
      PVector vi = corners[i];
      PVector vj = corners[j];
      if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
        if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }


    // check if point is within z range
    boolean within = false;
    if ( pz > (minZ-20) && pz < (maxZ+70)  && oddNodes) {
      within = true;
    }
    return within;
  }
}


// need to deal with depth not being easy and one value

