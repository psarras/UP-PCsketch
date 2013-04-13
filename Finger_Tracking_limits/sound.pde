void setupBeads() {
  ac = new AudioContext();

  // Glide carrierFrequency;

  freqEnv = new Envelope(ac, 200);
  gainEnv = new Envelope(ac, 0.5);
  wp = new WavePlayer(ac, freqEnv, Buffer.NOISE); //NOISE, SINE, SQUARE
  // Noise asd = new Noise(ac);
  g = new Gain(ac, 1, gainEnv);
  g.addInput(wp);
  ac.out.addInput(g);
  // ac.start();
  mod[0] = 1;
  mod[1] = 700;
  mod[2] = 300;
}
float[] mod = new float[3];

void playNote(float frequency) {
  if (millis() >= timePrv + range) {
    // freqEnv.addSegment(frequency, 0);

    wp.setFrequency(frequency); //for noise

    // freqEnv.addSegment(frequency + mod[0], mod[1]/6);
    // freqEnv.addSegment(frequency, 5*mod[1]/6);
    // freqEnv.addSegment(frequency - mod[0], mod[1]/6);

    gainEnv.addSegment(0.01, mod[1]/6);
    gainEnv.addSegment(0.1, 5*mod[1]/6);
    gainEnv.addSegment(0.0, mod[1]/6); 
    ac.start();
    timePrv = millis();
    range = (int)mod[1];
  }
}

//setup
int timePrv = 0;
int range = 700;
//draw


void mousePressed(){
  if (mouseButton==LEFT){
      playNote(100);
  } 
}
