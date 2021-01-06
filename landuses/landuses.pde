import obsa.ad.warp.*;
import ad.casadelamuntanya.model3d.*;
import ad.casadelamuntanya.model3d.locale.*;
import ad.casadelamuntanya.model3d.feature.*;
import ad.casadelamuntanya.model3d.surface.*;
import ad.casadelamuntanya.model3d.scene.*;
import com.vividsolutions.jts.geom.CoordinateSequenceFilter;

WarpSurface surface;
WarpCanvas canvas;

int interval = 40;
ScenesIterator scenes;

// Canvas bounds
private final LatLon[] bounds = new LatLon[] {
  new LatLon(42.691138, 1.369565),
  new LatLon(42.691138, 1.818963),
  new LatLon(42.398173, 1.818963),
  new LatLon(42.398173, 1.369565)
};
  
void setup() {
  fullScreen(P3D);

  surface = new WarpSurface(this, "../_commons/warpsurface_20x20.xml");
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
  
  Facade urbanFeatures = landuses.filter(Predicates.hasProperty("type", "TRANSPORT", "URBAN"));
  Facade forestFeatures = landuses.filter(Predicates.hasProperty("sub_type", "FOREST_DENSE", "FOREST_CLEAR"));
  Facade brushFeatures = landuses.filter(Predicates.hasProperty("sub_type", "BRUSH"));
  Facade grasslandFeatures = landuses.filter(Predicates.hasProperty("type", "GRASSLAND"));
  Facade rockFeatures = landuses.filter(Predicates.hasProperty("type", "ROCK", "BARE_SOIL"));
  Facade waterFeatures = landuses.filter(Predicates.hasProperty("type", "WATER"));
  
  SceneCollection scenesCollection = new SceneCollection();
  scenesCollection.add(new LanduseScene("WELCOME", dictionary, null));
  scenesCollection.add(new LanduseScene("OVERVIEW", dictionary, borders));
  scenesCollection.add(new LanduseScene("URBAN", dictionary, urbanFeatures));
  scenesCollection.add(new LanduseScene("FOREST", dictionary, forestFeatures));
  scenesCollection.add(new LanduseScene("BRUSH", dictionary, brushFeatures));
  scenesCollection.add(new LanduseScene("GRASSLAND", dictionary, grasslandFeatures));
  scenesCollection.add(new LanduseScene("ROCKS", dictionary, rockFeatures));
  scenesCollection.add(new LanduseScene("WATER", dictionary, waterFeatures));
  scenesCollection.add(new LanduseScene("SNOW", dictionary, snow));
  scenesCollection.add(new LanduseScene("CONCLUSION", dictionary, null));

  scenes = new ScenesIteratorInterval(this, interval, ' ', new ScenesIteratorKeyboard(this, LEFT, RIGHT, scenesCollection));
  scenes.init();
}

void draw() {
  background(0);
  surface.draw(canvas);
  scenes.draw(this.g);
}
