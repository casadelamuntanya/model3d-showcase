import ad.casadelamuntanya.model3d.scene.Scene;

class LanduseScene implements Scene {
  
  private final String NAME;
  private final Facade FEATURES;
  private final Dictionary DICTIONARY;
  
  public LanduseScene(String name, Dictionary dictionary, Facade features) {
    NAME = name;
    FEATURES = features;
    DICTIONARY = dictionary;
  }
  
  @Override
  public void draw(PGraphics renderer) {
    renderer.pushStyle();
    if(FEATURES != null) FEATURES.draw(renderer);
    if (DICTIONARY != null) {
      renderer.textAlign(LEFT, TOP);
      renderer.fill(#ffffff);
      renderer.textSize(10);
      renderer.textLeading(12);
      renderer.text(DICTIONARY.get(NAME, "ca"), 230, 635, 310, 80);
      renderer.fill(#999999);
      renderer.text(DICTIONARY.get(NAME, "en"), 625, 635, 310, 80);
    }
    renderer.popStyle();
  }
  
  @Override
  public void onEnter() {}
  
  @Override
  public void onLeave() {}
}
