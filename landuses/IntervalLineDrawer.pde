public class IntervalLineDrawer implements Drawer<IntervalSceneIterator> {
  
  protected final int ORIGIN_X;
  protected final int ORIGIN_Y;
  protected final int WIDTH;
  
  public IntervalLineDrawer(int x, int y, int width) {
    ORIGIN_X = x;
    ORIGIN_Y = y;
    WIDTH = width;
  }
  
  @Override
  public void draw(PGraphics renderer, IntervalSceneIterator iterator) {
    long ellapsed = iterator.ellapsed();
    float barWidth = map(ellapsed, 0, iterator.INTERVAL, WIDTH, 0);
    renderer.pushStyle();
    renderer.pushMatrix();
    renderer.translate(ORIGIN_X, ORIGIN_Y);
    renderer.textAlign(RIGHT, CENTER);
    if (iterator.isPaused()) renderer.text("PAUSED", -barWidth - 5, -1);
    renderer.rect(0, 0, -barWidth, 2);
    renderer.popMatrix();
    renderer.popStyle();
  }
}
