import crayolon.portamod.*;

AardvarkSim as;
ArrayList<PParticleSystem> antHells;
ArrayList<PVector> targets;

Explosion explosion;

//Music tracking vars
PortaMod tracker;
public NoteData incoming;
int lastTrackerPattern;
int speedIncrease = 3;

// Background systems
SS_StarscapeManager starscapeManager;

void setup() {

  size(1024, 768, P3D);
  smooth();

  as = new AardvarkSim();
  as.setup();

  setupTracker();

  setupAnts();

  // Setup background
  starscapeManager = new SS_StarscapeManager(width, height);
}

void setupTracker() {
  tracker = new PortaMod(this);
  tracker.doModLoad("sv_ttt.xm", true, 64);
}


void setupAnts()
{
  antHells = new ArrayList();
  targets = new ArrayList();

  PParticleSystem ants;
  PVector target;
  for (int i=0; i< as.breadsCount; ++i) {
    target = new PVector();
    targets.add(target);

    ants = new PParticleSystem();
    ants.addBehaviour(new ChaseTarget( target ));
    ants.addBehaviour(new Jitter());

    for (int j=0; j<15; ++j) {
      ants.addParticle(new PParticlePoint(new PVector(random(width), random(height), 0)));
    }
    antHells.add(ants);
  }

  //AI bread = ((AI)as.breads.get(0));
  makeExplosion( 0, 0, 150, 10, 35);
}

void makeExplosion(float x, float y, int d, float r, float e) {
  explosion = new Explosion(x, y, d, r, e);
  explosion.build();  // generates particles, only needed once
}

void runExplosion() {
  explosion.start(); // starts the very first explosion
}

void update() {
  as.update();
}


void draw() {
  // Draw background
  image(starscapeManager.getCanvas(), 0, 0);

  as.draw();

  AI bread;
  PParticleSystem ants;
  PVector target;
  for (int i=0; i< as.breads.size(); ++i) {
    bread = ((AI)as.breads.get(i));
    target = (PVector)targets.get(i);

    target.x = bread.xPos + bread.cSize*random(-0.5, 0.5);
    target.y = bread.yPos + bread.cHSize*random(-0.5, 0.5);

    ants = (PParticleSystem)antHells.get(i);
    ants.updateAndDraw();
  }


  runExplosion();
}

void mousePressed()
{
  if (!explosion.on) { 
    as.eatBreadAroundPoint(new PVector(mouseX, mouseY));
    explosion.reset(mouseX, mouseY);
  }

  explosion.on = true;
}


public void grabNewdata(PortaMod b) {        
  incoming = b.localnotes;
  /* Available from NoteData objects:
   channel, currentrealrow, currentrow, currentseq, effect,
   effparam, inst, note, seqlength, timestamp, vol
   */
  if (incoming.currentseq > lastTrackerPattern) {
    tracker.setTempo(tracker.bpmvalue+speedIncrease);
  }
  
  lastTrackerPattern = incoming.currentseq;
  
  if(incoming.currentseq > 0){
    if (incoming.channel == 1 || incoming.channel == 2) {
      String note = tracker.noteConvert(incoming.note);
      if(note != "- -"){
        println(incoming.currentrealrow + "   " + note);
        if(!as.bakeBread()){
          //Trigger Wormhole
        }
      }
    }
  }
}

void stop()
{
  tracker.stop();
  this.stop();
} 

