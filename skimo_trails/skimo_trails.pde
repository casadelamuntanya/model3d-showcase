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
  fullScreen(P3D);
  frameRate(60);

  // Load a big text size to allow multiple sizes with good quality
  textSize(128);
  textSize(16);

  Dictionary dictionary = new Dictionary(new DictionaryFactoryTxt(this));
  dictionary.load("ca", "ca.txt");

  surface = new WarpSurface(this, "../_commons/warpsurface_20x20.xml");
  canvas = new WarpCanvas(this, "../_commons/orto.png", bounds);
  
  SurfaceMapper mapper = new SurfaceMapper(surface);
  Factory factory = new FeatureFactoryGeoJSON(this, mapper);

  Facade<Feature> snow = factory.load("snow.geojson");
  snow.setDrawer(new ColorDrawer(new FeatureDrawer(), color(#ffffff, 200)).strokeWeight(0));

  // Drawer will be (re)set in TrackScene onEnter hook
  Facade<Feature> tracks = factory.load("tracks.geojson");

  Facade<Feature> provisionings = factory.load("provisionings.geojson");
  provisionings.setDrawer(new PulseFeatureDrawer(this, 10, 50, #ff0000));

  scenes = new SceneCollection();
  String[] trackIDs = new String[] { "skimo10", "skimo2", "skimo4", "skimo6" };
  for (String id : trackIDs) {
    PImage logo = loadImage("logos/" + id + ".png");
    Feature track = tracks.find(Predicates.hasProperty("id", id));
    Facade<Feature> features = new Facade()
      .add(snow)
      .add(provisionings.filter(isClose(track, 10)));
    Scene scene = new TrackScene(this, id, logo, dictionary, track, features);
    scenes.add(scene);
  }
  
  // Switch scenes at a regular time interval
  SceneIterator intervalIterator = new IntervalSceneIterator(this, SCENE_INTERVAL, ' ');
  Drawer intervalDrawer = new IntervalLineDrawer(1500, 1056, 1157);
  intervalIterator.setDrawer(intervalDrawer);
  scenes.addIterator(intervalIterator);
  
  // Switch scenes on LEFT and RIGHT arrow key press
  SceneIterator keyIterator = new KeySceneIterator(this, LEFT, RIGHT);
  scenes.addIterator(keyIterator);
}

void draw() {
  background(0);
  surface.draw(canvas);
  scenes.draw(this.g);
}

Predicate<Feature> isClose(final Feature target, final int distance) {
  return new Predicate<Feature>() {
    @Override
    public boolean test(Feature feature) {
      return feature.GEOMETRY.isWithinDistance(target.GEOMETRY, distance);
    }
  };
}
