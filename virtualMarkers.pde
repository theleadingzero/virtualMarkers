/* virutalMarkers
 * by Becky Stewart
 * Anti-Alias Labs
 * 
 * December, 2012
 *
 * Click to create quads that are mapped onto
 * physical objects.  Events are then triggered
 * when a user touches that quad.
 */

import SimpleOpenNI.*;


// Kinect variables
SimpleOpenNI  context;

ClickedQuad[] hitAreas;
int numHitAreas = 6;
int currArea = 0;

//---------------------------------------------
// setup - called once at launch of sketch
//---------------------------------------------
void setup()
{
  context = new SimpleOpenNI(this);

  // enable depthMap generation 
  if (context.enableDepth() == false)
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // start scene analysis and user tracking
  context.enableScene();
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  context.enableRGB();

  size(context.sceneWidth(), context.sceneHeight());

  // set up hit areas data structure
  hitAreas = new ClickedQuad[ numHitAreas ];
  for ( int i=0; i<numHitAreas; i++)
  {
    hitAreas[i] = new ClickedQuad();
  }
}


//---------------------------------------------
// draw - called about 30 times a second
//---------------------------------------------
void draw()
{
  // update the cam
  context.update();
  // get scene map
  int[] sceneMap = context.sceneMap();

  // get depth map
  int[] depthMap = context.depthMap();

  // draw irImageMap
  
  image(context.rgbImage(), 0, 0);
  tint(255, 30);
  image(context.sceneImage(), 0, 0);

  fill(0, 200, 10, 100);

  // check if user is within a hit area
  // go through all values in the array
  boolean pointHit = false;
  int sw = context.sceneWidth();
  int sh = context.sceneHeight();

  // check if pixel value at point is occupied by a user
  for ( int i=0; i< ( sw * sh); i++) {
    // if pixel is of a user
    if (  sceneMap[i] > 0 ) {
      // check if pixel is within each hit area
      for (int j=0; j<numHitAreas; j++ ) {
        int pixX = i%sw;
        int pixY = i/sh;
        if ( hitAreas[j].withinQuad( pixX, pixY, depthMap[i] ) )
        {
          fill(255, 20, 20, 100);
        }
      }
    }
  }



  for (int i=0; i<numHitAreas; i++)
  {
    hitAreas[i].drawQuad();
  }
}

//---------------------------------------------
// mousePressed - called when mouse button
//                is pressed
//---------------------------------------------
void mousePressed() {

  // make sure not just clicking to activate window
  if ( mouseX != 0 && mouseY != 0) {
    // get depth map
    int[] depthMap = context.depthMap();

    // add mouse click data
    if ( !hitAreas[currArea].quadFilled() )
    {
      // add depth data  
      int pz = depthMap[int(mouseX + context.sceneWidth() * mouseY)];
      hitAreas[currArea].addCorner(mouseX, mouseY, pz);
    }

    // if current area is now filled with data, go on to next
    if ( hitAreas[currArea].quadFilled() && currArea < numHitAreas )
      currArea++;
  }
}

