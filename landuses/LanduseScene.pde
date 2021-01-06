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
    pushStyle();
    if(FEATURES != null) FEATURES.draw(renderer);
    if (DICTIONARY != null) {
      textAlign(LEFT, TOP);
      fill(#ffffff);
      textLeading(14);
      text(DICTIONARY.get(NAME, "ca"), 400, 965, 450, 130);
      fill(#888888);
      text(DICTIONARY.get(NAME, "en"), 1000, 965, 450, 130);
    }

    popStyle();
  }
  
  @Override
  public void onEnter() {}
  
  @Override
  public void onLeave() {}
}
