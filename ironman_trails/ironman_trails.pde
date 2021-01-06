import obsa.ad.warp.*;
import ad.casadelamuntanya.model3d.*;
import ad.casadelamuntanya.model3d.locale.*;
import ad.casadelamuntanya.model3d.feature.*;
import ad.casadelamuntanya.model3d.surface.*;
import ad.casadelamuntanya.model3d.scene.*;
import com.vividsolutions.jts.geom.CoordinateSequenceFilter;
import com.vividsolutions.jts.geom.Geometry;
import java.util.function.Predicate;

WarpSurface surface;
WarpCanvas canvas;

int interval = 75;
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

  // Load a big text size to allow multiple sizes with good quality
  textSize(128);
  textSize(16);

  Dictionary dictionary = new Dictionary(new DictionaryFactoryTxt(this));
  dictionary.load("ca", "ca.txt");

  surface = new WarpSurface(this, "../_commons/warpsurface_20x20.xml");
  canvas = new WarpCanvas(this, "../_commons/orto.png", bounds);
  
  SurfaceMapper mapper = new SurfaceMapper(surface);
  Factory factory = new FeatureFactoryGeoJSON(this, mapper);

  // Drawer will be (re)set in TrackScene onEnter hook
  Facade<Feature> tracks = factory.load("ironman.geojson");

  Facade<Feature> provisionings = factory.load("provisionings.geojson");
  provisionings.setDrawer(new PulseFeatureDrawer(this, 10, 50, #ff0000));

  SceneCollection scenesCollection = new SceneCollection();

  PImage logo = loadImage("logo.png");
  String[] trackIDs = new String[] { "7k5", "25k", "55k", "125k" };
  for (String id : trackIDs) {
    Feature track = tracks.find(Predicates.hasProperty("id", id));
    Facade<Feature> features = provisionings.filter(Predicates.hasProperty("track", id));
    Scene scene = new TrackScene(this, id, logo, dictionary, track, features);
    scenesCollection.add(scene);
  }
  
  scenes = new ScenesIteratorKeyboard(this, LEFT, RIGHT, new ScenesIteratorInterval(this, interval, ' ', scenesCollection));
  scenes.init();
}

void draw() {
  background(0);
  surface.draw(canvas);
  scenes.draw(this.g);
}
