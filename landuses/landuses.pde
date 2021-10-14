import obsa.ad.warp.*;
import ad.casadelamuntanya.model3d.*;
import ad.casadelamuntanya.model3d.locale.*;
import ad.casadelamuntanya.model3d.feature.*;
import ad.casadelamuntanya.model3d.surface.*;
import ad.casadelamuntanya.model3d.scene.*;
import com.vividsolutions.jts.geom.CoordinateSequenceFilter;

WarpSurface surface;
WarpCanvas canvas;

final int SCENE_INTERVAL = 40;
SceneCollection scenes;

// Canvas bounds
private final LatLon[] bounds = new LatLon[] {
  new LatLon(42.691138, 1.369565),
  new LatLon(42.691138, 1.818963),
  new LatLon(42.398173, 1.818963),
  new LatLon(42.398173, 1.369565)
};
  
void setup() {
  fullScreen(P3D, 2);
  frameRate(60);

  surface = new WarpSurface(this, "../_commons/warpsurface_10x10.xml");
  canvas = new WarpCanvas(this, "../_commons/orto.png", bounds);
  
  Dictionary dictionary = new Dictionary(new DictionaryFactoryTxt(this));
  dictionary.load("ca", "dictionary/ca.txt");
  dictionary.load("en", "dictionary/en.txt");
  
  SurfaceMapper mapper = new SurfaceMapper(surface);
  Factory factory = new FeatureFactoryGeoJSON(this, mapper);
  
  HashMap<String, Integer> colors = new HashMap();
  colors.put("BRUSH", #617B35);
  colors.put("BARE_SOIL", #bbbbbb);
  colors.put("CROP", #ddd771);
  colors.put("LAKE", #89cff0);
  colors.put("RIVER", #89cff0);
  colors.put("FOREST_CLEAR", #617B35);
  colors.put("FOREST_DENSE", #617B35);
  colors.put("MEADOW", #bdc07e);
  colors.put("ROAD_PRIMARY", color(#ff0000, 150));
  colors.put("ROAD_SECONDARY", color(#ff0000, 125));
  colors.put("ROAD_TERTIARY", color(#ff0000, 100));
  colors.put("URBAN", #ff0000);
  colors.put("ROCK", #999999);
  colors.put("SCREE", #999999);
  
  Facade landuses = factory.load("landuses.geojson");
  landuses.setDrawer(new CategoryDrawer(new FeatureDrawer(), "sub_type", colors));
  
  Facade snow = factory.load("snow.geojson");
  snow.setDrawer(new ColorDrawer(new FeatureDrawer(), #ffffff));
  
  Facade borders = factory.load("../_commons/border.geojson");
  borders.setDrawer(new ColorDrawer(new FeatureDrawer(), #ffffff).strokeWeight(2));

  scenes = new SceneCollection();
  scenes.add(new LanduseScene("WELCOME", dictionary, null));
  scenes.add(new LanduseScene("OVERVIEW", dictionary, borders));
  
  Facade urbanFeatures = landuses.filter(Predicates.hasProperty("type", "TRANSPORT", "URBAN"));
  scenes.add(new LanduseScene("URBAN", dictionary, urbanFeatures));
  
  Facade forestFeatures = landuses.filter(Predicates.hasProperty("sub_type", "FOREST_DENSE", "FOREST_CLEAR"));
  scenes.add(new LanduseScene("FOREST", dictionary, forestFeatures));
  
  Facade brushFeatures = landuses.filter(Predicates.hasProperty("sub_type", "BRUSH"));
  scenes.add(new LanduseScene("BRUSH", dictionary, brushFeatures));
  
  Facade grasslandFeatures = landuses.filter(Predicates.hasProperty("type", "GRASSLAND"));
  scenes.add(new LanduseScene("GRASSLAND", dictionary, grasslandFeatures));
  
  Facade rockFeatures = landuses.filter(Predicates.hasProperty("type", "ROCK", "BARE_SOIL"));
  scenes.add(new LanduseScene("ROCKS", dictionary, rockFeatures));
  
  Facade waterFeatures = landuses.filter(Predicates.hasProperty("type", "WATER"));
  scenes.add(new LanduseScene("WATER", dictionary, waterFeatures));
  
  scenes.add(new LanduseScene("SNOW", dictionary, snow));
  scenes.add(new LanduseScene("CONCLUSION", dictionary, null));

  // Switch scenes at a regular time interval
  IntervalSceneIterator intervalIterator = new IntervalSceneIterator(this, SCENE_INTERVAL, ' ');
  Drawer intervalDrawer = new IntervalLineDrawer(965, 713, 760);
  intervalIterator.setDrawer(intervalDrawer);
  scenes.addIterator(intervalIterator);
  intervalIterator.resume();
  
  // Switch scenes on LEFT and RIGHT arrow key press
  SceneIterator keyIterator = new KeySceneIterator(this, LEFT, RIGHT);
  scenes.addIterator(keyIterator);
}

void draw() {
  background(0);
  surface.draw(canvas);
  scenes.draw(this.g);
}
