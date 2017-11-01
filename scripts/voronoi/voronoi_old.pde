/** 
 *
 * Interactive Voronoi Diagram
 *
 * This is a program that makes an interactive Voronoi diagram.
 *
 * Add points by clicking anywhere on the display. Press the 'n' key to change
 * metrics. Press the 'r' key to clear the plane of points. Alternatively, 
 * you can use the following keys to change metrics:
 *      3   Chebyshev distance
 *      1   Manhattan distance
 *      2   Euclidean distance
 *
 * @see Point
 *
 * @author Sarah Greer
 * www.sygreer.com
 *
 */

ArrayList<Point> points; // store points in array list
int n;                   // metric flag

// initialize for display
void setup(){
  size(600,300);
  background(#ffffff);
  points = new ArrayList<Point>();
  initializeBoard();
  noLoop();
  // starting metric is Euclidean
  n = 0;
}

// add point to start
void initializeBoard(){
  points.add(new Point(width/2, height/2, n));
}

// display points
void draw(){
  background(#ffffff);
  fillBoard();
  for (int i = points.size()-1; i >= 0; i--) { 
    Point p = points.get(i);
    p.display();
  }
  drawInformation();
}

// add points to board
void fillBoard(){
  for (int w=0; w<width; w++){
    for (int h=0; h<height; h++){
      set(w,h,nearestNeighbor(w,h));
    }
  }
}

// returns the color of the nearest neighbor point
color nearestNeighbor(int x, int y){
  float mindist = points.get(0).getMetric(x,y);
  color c = points.get(0).c;
  for (int i = points.size()-1; i >= 0; i--) { 
    Point p = points.get(i);
    if ( p.getMetric(x,y) < mindist ){
      c = p.c;
      mindist = p.getMetric(x,y);
    }
  }
  return c;
}

// add new point on mouse click
void mouseClicked() {
  points.add(new Point(mouseX, mouseY, n));
  redraw();
}

// remove all elements from board
void clearBoard(){
    for (int i = points.size()-1; i >= 0; i--) { 
      points.remove(i);
    }
    initializeBoard();
    redraw();
}

// add information to the box (top left corner)
void drawInformation(){
  String nrm;
  if(n == 0){
    nrm = "Euclidean";
  } else if (n == 1){ 
    nrm = "Manhattan";
  } else nrm = "Chebyshev";
  fill(255,255,255,100);
  stroke(#000000);
  strokeWeight(2);
  rect(-2,-2,140,64);
  fill(#000000);
  textAlign(LEFT,TOP);
  textSize(14);
  text(nrm + " distance",10,10);
  if(points.size() == 1){
    text(points.size() + " point",10,35);
  } else{
    text(points.size() + " points",10,35);
  }
}

// update points on the plane
void updatePoints(int n){
    for (int i = points.size()-1; i >= 0; i--) { 
        Point p = points.get(i);
        p.changeMetric(n);
    }
    redraw();
}

void keyPressed() {
  // clear board
  if (key == 'r'){
    clearBoard();

  // toggle through metrics
  } else if (key == 'n'){
    n = (n+1)%3;
    updatePoints(n);

  // Euclidean distance
  } else if (key == '2'){
    n = 0;
    updatePoints(n);
  // Manhattan distance
  } else if (key == '1'){
    n = 1;
    updatePoints(n);

  // Chebyshev distance
  } else if (key =='3'){
    n = 2;
    updatePoints(n);
  }
}


class Point{
  int x, y;     // x and y coordinate
  color c;      // color
  int n;        // metric flag
  Point(int x, int y, int n){
    this.x = x;
    this.y = y;
    // choose a random color
    c = color(random(0,255),random(0,255),random(0,255));
    this.n = n;
  }

  // display the point
  void display(){
    fill(#000000);
    stroke(#000000);
    noStroke();
    ellipse(x,y,8,8);
  }

  // Euclidean distance
  float getEuclidean(int a, int b){
    return (x-a)*(x-a)+(y-b)*(y-b);
    // omit square root to decrease computation (it's monotonic function)
  }

  // Chebyshev distance
  float getChebyshev(int a, int b){
    if(abs(x-a)>abs(y-b)){
        return abs(x-a);
    } else return abs(y-b);
  }

  // Manhattan distance
  float getManhattan(int a, int b){
    return abs(x - a) + abs(y - b);
  }

  // choose metric calculation
  float getMetric(int a, int b){
    if (n == 0){
      return getEuclidean(a,b);
    } else if (n == 1) {
      return getManhattan(a,b);
    } else if (n == 2) {
      return getChebyshev(a,b);
    } else { return 0; }
  }

  // change the metric value
  void changeMetric(int n){
    this.n = n;
  }
}
