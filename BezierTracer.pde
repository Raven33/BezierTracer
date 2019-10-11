class Point{
  float x;
  float y;
  float r = 5;
  boolean grabed = false;
  
  Point(float x,float y){
    this.x = x;
    this.y = y;
  }
  
  boolean contains(float a,float b){
    float res = (a-x)*(a-x)+(b-y)*(b-y);
    return res <= r*r;
  }
}

class Instruction{
  String type;
  Point[] points;
  
  Instruction(String t,Point[] ps){
    type = t;
    points = ps;
  }
  
  Instruction(String t){
    type = t;
  }
}

ArrayList<Point> globalplist = new ArrayList<Point>();
ArrayList<Instruction> globalinstructlist = new ArrayList<Instruction>();
int time = 0;

Instruction initBezier(){
  float angle = random(0,TWO_PI);
  float rad = random(8,25);
  int x = int(sin(angle)*rad);
  int y = int(cos(angle)*rad);
  Point[] ps = new Point[3];
  Instruction last = globalinstructlist.get(globalinstructlist.size()-1);
  if(last.type.equals("bezierVertex")){
    ps[0] = new Point(last.points[1].x+x,last.points[1].y+y);
  }else{
    ps[0] = new Point(last.points[0].x+x,last.points[0].y+y);
  }
  ps[1] = new Point(mouseX,mouseY);
  ps[2] = new Point(mouseX+x,mouseY+y);
  
  Instruction i = new Instruction("bezierVertex",ps);
  globalplist.add(i.points[0]);
  globalplist.add(i.points[1]);
  globalplist.add(i.points[2]);
  return i;
}

void dumpToFile(){
  PrintWriter dump = createWriter("output_code.txt");
  boolean start = true;
  int counter = 0;
  for(Instruction i: globalinstructlist){
    if(i.type.equals("beginShape")&&(start)){
      start = false;
      dump.println("beginShape()");
    }else if(i.type.equals("vertex")){
      dump.println("vertex("+int(i.points[0].x)+","+int(i.points[0].y)+")");
    }else if(i.type.equals("bezierVertex")){
      dump.println("bezierVertex("+int(i.points[0].x)+","+int(i.points[0].y)+","+int(i.points[1].x)+","+int(i.points[1].y)+","+int(i.points[2].x)+","+int(i.points[2].y)+")");
    }else if(i.type.equals("endShape")){
      dump.println("endShape()");
      if(counter!=globalinstructlist.size()-2){
        start = true;
      }
    }
    counter++;
  }
  dump.flush();
  dump.close();
}

void bezierTracer(){
  background(180);
  if(globalinstructlist.isEmpty()){
    globalinstructlist.add(new Instruction("beginShape"));
  }else if(globalinstructlist.get(globalinstructlist.size()-1).type == "endShape"){
    globalinstructlist.add(new Instruction("beginShape"));
  }else{
    if(keyPressed){
      if(key == 'n'){
        keyPressed = false;
        Point[] ps = new Point[1];
        ps[0] = new Point(mouseX,mouseY);
        globalplist.add(ps[0]);
        globalinstructlist.add(new Instruction("vertex",ps));
      }else if(key == 'b'){
        keyPressed = false;
        globalinstructlist.add(initBezier());
      }else if(key == 'e'){
        keyPressed = false;
        String last = globalinstructlist.get(globalinstructlist.size()-1).type;
        if(!last.equals("endShape")){
          globalinstructlist.add(new Instruction("endShape"));
        }
      }else if(key == 'r'){
        globalplist.clear();
        globalinstructlist.clear();
      }
    }else{
      Instruction last = null;
      for(Instruction i: globalinstructlist){
        if(i.type.equals("beginShape")){
          beginShape();
        }else if(i.type.equals("vertex")){
          vertex(i.points[0].x,i.points[0].y);
        }else if(i.type.equals("bezierVertex")){
          if(last.type.equals("bezierVertex")){
            line(last.points[2].x,last.points[2].y,i.points[0].x,i.points[0].y);
          }else{
            line(last.points[0].x,last.points[0].y,i.points[0].x,i.points[0].y);
          }
          line(i.points[1].x,i.points[1].y,i.points[2].x,i.points[2].y);
          bezierVertex(i.points[0].x,i.points[0].y,i.points[1].x,i.points[1].y,i.points[2].x,i.points[2].y);
        }else if(i.type.equals("endShape")){
          endShape();
        }
        last = i;
      }
    }
  }
  if(!globalplist.isEmpty()){
    for(Point p: globalplist){
      if(p.contains(mouseX,mouseY)){
        p.grabed = mousePressed;
        }else{
        fill(255);
      }
      if(p.grabed){
        p.x = mouseX;
        p.y = mouseY;
        fill(0,255,0);
      }
      circle(p.x,p.y,p.r*2);
      fill(255);
    }
  }
  if(millis()-time > 2000){
    time = millis();
    dumpToFile();
  }
} //<>//
