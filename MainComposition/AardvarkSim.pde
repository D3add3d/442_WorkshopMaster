class AardvarkSim {

  AE_AnimationEngineManager animation_manager;
  ArrayList breads;
  ArrayList bakery;
  int breadsCount = 150;
  int eatDistance = 125;

  void setup() {

    this.animation_manager = new AE_AnimationEngineManager("aardvark.png", 200, 200);

    this.breads = new ArrayList();
    this.bakery = new ArrayList();

    for (int i = 0; i < breadsCount; i++) {
      this.bakery.add(new AI("bread.png", (int) random(0, width), (int) random(height), (int) random(3, 6)));
    }
  }

  boolean bakeBread() {
    if (this.breads.size() < breadsCount) {
      AI bread = (AI)this.bakery.get(this.bakery.size()-1);
      bread.xPos = (int) random(0, width);
      bread.yPos = (int) random(height);
      this.breads.add( bread );
      this.bakery.remove(this.bakery.size()-1);
      //this.breads.add(new AI("bread.png", (int) random(0, width), (int) random(height), (int) random(3, 6)));
    } 
    else {
      return false;
    }

    return true;
  }

  void eatBread(int targetBread) {
    if (targetBread != -1) {
      this.bakery.add((AI)this.breads.get(targetBread));
      this.breads.remove(targetBread);
    }

    //    if(this.breads.size() > 0){
    //      this.breads.remove( (int)floor( random(0, this.breads.size() )));
    //    }
  }

  void eatBreadAroundPoint(PVector point) {    
    for (int i = 0; i < this.breads.size(); i++) {
      AI bread = (AI)this.breads.get(i);
      float distance = dist(bread.xPos, bread.yPos, point.x, point.y);
      
      if ( distance < eatDistance ) {
        eatBread(i);
      }
    }
  }

  void update() {
  }

  void draw() {
    for (int i = 0; i < this.breads.size(); i++) {
      AI bread = (AI) this.breads.get(i); 

      bread.animate((int) this.animation_manager.pos.x, (int) this.animation_manager.pos.y);
      if (random(0, 1) < 0.003) {
        bread.cState = (bread.cState == 1 ? 0 : 1);
      }
    }

    this.animation_manager.animate();
  }
}

