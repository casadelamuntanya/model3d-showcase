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

final int SCENE_INTERVAL = 75;
SceneCollection scenes;

PFont roboto;
PFont robotoBold;

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
  
  roboto = createFont("Roboto", 11, true);
  robotoBold = createFont("Roboto", 20, true);
  textFont(roboto);

  Dictionary dictionary = new Dictionary(new DictionaryFactoryTxt(this));
  dictionary.load("ca", "ca.txt");

  surface = new WarpSurface(this, "../_commons/warpsurface_10x10.xml");
  canvas = new WarpCanvas(this, "../_commons/orto.png", bounds);
  
  SurfaceMapper mapper = new SurfaceMapper(surface);
  Factory factory = new FeatureFactoryGeoJSON(this, mapper);

  // Drawer will be (re)set in TrackScene onEnter hook
  Facade<Feature> tracks = factory.load("ironman.geojson");

  Facade<Feature> provisionings = factory.load("provisionings.geojson");
  provisionings.setDrawer(new PulseFeatureDrawer(this, 15, 50, #ff0000));

  scenes = new SceneCollection();

  PImage logo = loadImage("logo.png");
  String[] trackIDs = new String[] { "7k5", "25k", "55k", "125k" };
  for (String id : trackIDs) {
    Feature track = tracks.find(Predicates.hasProperty("id", id));
    Facade<Feature> features = provisionings.filter(Predicates.hasProperty("track", id));
    Scene scene = new TrackScene(this, id, logo, dictionary, track, features);
    scenes.add(scene);
  }
  
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
