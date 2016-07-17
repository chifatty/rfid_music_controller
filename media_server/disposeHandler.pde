class Distructor {
  public void action() {}
}

public class DisposeHandler {

  Distructor distructor;
  
  DisposeHandler(PApplet pa, Distructor d) {
    pa.registerMethod("dispose", this);
    distructor = d;
  }
   
  public void dispose() {      
    println("Closing sketch");
    distructor.action();
    // Place here the code you want to execute on exit
  }
}