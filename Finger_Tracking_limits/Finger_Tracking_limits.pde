//Weird Sounds

import intel.pcsdk.*;
import beads.*;

//Beads
AudioContext ac;
WavePlayer wp;
Envelope freqEnv;
Envelope gainEnv;
Gain g;


PXCUPipeline session;

//To display the Images
PImage rgbTexture, blobTexture;

//Track all the Fingers
ArrayList<PVector> fingerTips = new ArrayList<PVector>();

//Creates the Labes, but this is just a number of {1, 2}
int[] handLabels = {PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY, 
                    PXCMGesture.GeoNode.LABEL_BODY_HAND_SECONDARY};
//and {1, 2, 3, 4, 5}
int[] fingerLabels = {PXCMGesture.GeoNode.LABEL_FINGER_THUMB, 
                      PXCMGesture.GeoNode.LABEL_FINGER_INDEX, 
                      PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, 
                      PXCMGesture.GeoNode.LABEL_FINGER_RING, 
                      PXCMGesture.GeoNode.LABEL_FINGER_PINKY 
};

color touch = 255;

//Display Interface
ArrayList<PVector> fingersInside = new ArrayList<PVector>();

Box[] noteBoxes;
Box[] noteFrequency;

float windowSize = 3;
void setup() {
  size(int(320*windowSize), int(240*windowSize), P3D);
  setupBeads();
  //Initiate the Camera
  session = new PXCUPipeline(this);
  
  //Adds the things you want to enable (like enableSchene for kinect)
  session.Init(PXCUPipeline.COLOR_VGA|PXCUPipeline.GESTURE);
  
  rgbTexture = createImage(640, 480, RGB);
  blobTexture = createImage(320, 240, RGB);

  noteBoxes = new Box[6];
  for (int i = 0; i<noteBoxes.length; i++){
    noteBoxes[i] = new Box(new PVector(50*i+10, 30, 0.2), 50, 50, 0.1);
  }
  noteFrequency = new Box[1];
  for (int i = 0; i<noteFrequency.length; i++){
    noteFrequency[i] = new Box(new PVector(100*i+10, 130, 0.2), 300/2, 100, 0.1);
  }  
}

void draw() {
  background(0);
  translate(width, 0, 0);
  scale(windowSize);
  scale(-1, 1);


  //Checking if the frame is active and Acquires it
  if (session.AcquireFrame(true)) {
 
    //Gen the RGB and the blobImage
    session.QueryRGB(rgbTexture);
    session.QueryLabelMapAsImage(blobTexture);
    
    //Clear the Array of the PVectors
    fingerTips.clear();

    //Create an GeoNode Object (PVector Class?)
    PXCMGesture.GeoNode node = new PXCMGesture.GeoNode();
    
    //For loop between all the hands/fingers
    for(int hand = 0; hand < handLabels.length; hand++) {
      for(int finger = 0; finger<fingerLabels.length; finger++)  {
    
        //Request the GeoNode by making a query, arguments(int handLabel | int fingerLabel, GeoNode node)
        if(session.QueryGeoNode(handLabels[hand]|fingerLabels[finger], node)) {

          //Get the location on screen by the method .positionImage that returns a PVector
          //Alternative you can get the dimensions  by using the method .positonWorld, y is actually the depth
          fingerTips.add(new PVector(node.positionImage.x, node.positionImage.y, node.positionWorld.y));
        }
      }
    }

  //Like update() on kinect but it has to be in the end
  session.ReleaseFrame();
  }

  //Display the Images
  // image(rgbTexture, 320, 0, 320, 240);
  image(blobTexture, 0, 0, 320, 240);

  //Play notes if you Touch the Boxes
  //Display the Fingers
  for(int p = 0; p < fingerTips.size(); p++){

    //Finger Vector
    PVector fingerTip = (PVector)fingerTips.get(p);

    touch = color(0, 255, 0);
    for (int i = 0; i<noteBoxes.length; i++){
      noteBoxes[i].boxColor = color(0, 255, 0);
      if (noteBoxes[i].checkInside(fingerTip)) {
        noteBoxes[i].boxColor = color(255, 0, 0);
        touch = color(255, 0, 0);
        playNote(100 + 50*i*i);
      }
    }
    fill(touch);
    ellipse(fingerTip.x, fingerTip.y, 10, 10);
  }

  //Transform the note by using your fingers
  fingersInside.clear();
  int countFingers = 0;
  for (int j = 0; j<noteFrequency.length; j++){
    for (int i = 0; i<fingerTips.size(); i++){
      PVector fingerTip = (PVector)fingerTips.get(i);
      if (noteFrequency[j].checkInsideND(fingerTip)){
        fingersInside.add(fingerTip);
        mod[0] = map(fingerTip.x, 0, 150, 50, 500);
        mod[1] = map(fingerTip.y, 120, 240, 1, 700);
        println("mod[0]: "+mod[0]);
        println("mod[1]: "+mod[1]);
        // countFingers++;
      }
    }
  }
  // println(countFingers);
  if (countFingers >= 3){
    // playNote(300);
    for (int finger = 0; finger < mod.length; finger++){
      println(mod[finger]);
    }
    println("larger than 2");
  }

  for (int i = 0; i<noteBoxes.length; i++){
    noteBoxes[i].draw();
  }
  for (int i = 0; i<noteFrequency.length; i++){
    noteFrequency[i].draw();
  }
}


// //if on a certain range change color
// void touch(PVector a, float startX, float startY, float sizeX, float sizeY) {
//   fill(255, 20);
//   rect(50, 50, 100, 100);
//   if (a.x < 150  && a.x > 50 &&
//       a.y < 150  && a.y > 50 &&
//       a.z > 0.2  && a.z < 0.3){
//     touch = color(255, 0, 0);
//   } else {
//     touch = color(0, 255, 0);
//   }
// }




