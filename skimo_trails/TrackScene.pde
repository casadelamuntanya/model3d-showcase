import java.text.DecimalFormat;

class TrackScene implements Scene {
  
  private final PApplet PAPPLET;
  private final String ID;
  private final Feature TRAIL;
  private final Facade FEATURES;
  private final Dictionary DICTIONARY;
  private final PImage LOGO;
  
  private final String DURATION;
  private final String DISTANCE;
  private final String DROP;

  public TrackScene(PApplet papplet, String id, PImage logo, Dictionary dictionary, Feature trail) {
    this(papplet, id, logo, dictionary, trail, null);
  }
  
  public TrackScene(PApplet papplet, String id, PImage logo, Dictionary dictionary, Feature trail, Facade features) {
    PAPPLET = papplet;
    ID = id;
    TRAIL = trail;
    FEATURES = features;
    DICTIONARY = dictionary;
    LOGO = logo;
    
    DROP = TRAIL.getProperty("drop_up") + "m";
    DecimalFormat df = new DecimalFormat("0.#");
    DISTANCE = df.format(TRAIL.getProperty("distance")) + "km";
    int duration = (int) TRAIL.getProperty("duration");
    int hours = duration / 60;
    int mins = duration % 60;
    DURATION = hours + "h" + mins;
  }
  
  @Override
  public void draw(PGraphics renderer) {
    renderer.pushStyle();
    
    if (FEATURES != null) FEATURES.draw(renderer);
    TRAIL.draw(renderer);
    
    renderer.pushStyle();
    if (DICTIONARY != null) {
      renderer.textAlign(LEFT, TOP);
      renderer.fill(#ffffff);
      renderer.textLeading(14);
      renderer.text(DICTIONARY.get(ID), 400, 965, 450, 130);
    }
    renderer.popStyle();

    renderer.image(LOGO, 875, 955, 80, 80);

    drawInsight(renderer, 1000, 980, "INSIGHT_DISTANCE", DISTANCE);
    drawInsight(renderer, 1120, 980, "INSIGHT_DROP", DROP);
    drawInsight(renderer, 1260, 980, "INSIGHT_DURATION", DURATION);
    
    /* Workaround to draw pulse legend */
    renderer.fill(#ff0000);
    renderer.textSize(12);
    renderer.textAlign(CENTER, BOTTOM);
    renderer.text(DICTIONARY.get("LEGEND_PROVISIONING"), 1420, 980);
    drawPulse(renderer, 1420, 1000, 0);
    drawPulse(renderer, 1420, 1000, 16.6);
    renderer.fill(#ff0000);
    renderer.circle(1420, 1000, 10);
    
    renderer.popStyle();
  }
  
  private void drawPulse(PGraphics renderer, int x, int y, float offset) {
    float radius = (PAPPLET.millis() * 0.025f - offset) % (50 / 0.5f);
    float opacity = PApplet.map(radius, 0, 50, 255, 0);
    renderer.fill(#ff0000, opacity);
    renderer.circle(x, y, radius);
  }
  
  private void drawInsight(PGraphics renderer, int x, int y, String name, String value) {
    renderer.pushStyle();
    renderer.fill(#888888);
    renderer.textSize(16);
    renderer.text(DICTIONARY.get(name), x, y);
    renderer.fill(#ffffff);
    renderer.textSize(32);
    renderer.text(value, x, y + 40);
    renderer.popStyle();
  }

  @Override
  public void onEnter() {
    Drawer progress = new ProgressFeatureDrawer(PAPPLET, 50).head(10);
    TRAIL.setDrawer(new ColorDrawer(progress, #ff0000).strokeWeight(3));
  }
  
  @Override
  public void onLeave() {}
}
