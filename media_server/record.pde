
public class Record {
  int serial;
  String cardID;
  String musicFile;
  boolean clicked;
  
  public Record(int s, String[] pieces) {
    serial = s;
    cardID = pieces[0];
    musicFile = pieces[1];
    clicked = false;
  }
  
  public String toString() {
    return cardID + '\t' + musicFile;
  }
  
  public void update() {
    if (overRect(210, 5 + serial*25, 20, 20) && mousePressed && !clicked) {
      clicked = true;
      selectInput("Select a file to process:", "fileSelected", null, this);
    }
    else if (!mousePressed && clicked) {
      clicked = false;
    }
  }
  
  public void fileSelected(File selection) {
    if (selection == null) {
      // println("Window was closed or the user hit cancel.");
    } else {
      musicFile = selection.getAbsolutePath();
    }
  }
  
  public void display() {
    fill(0);
    noStroke();
    rect(20, 5 + serial*25, 30, 20);
    rect(55, 5 + serial*25, 150, 20);
    rect(235, 5 + serial*25, 550, 20);
    rect(210, 5 + serial*25, 20, 20);
    fill(0, 100, 0);
    if (overRect(210, 5 + serial*25, 20, 20)) {
      fill(0, 150, 0);
    }
    triangle(212, 9 + serial*25, 228, 9 + serial*25, 220, 20 + serial*25);
    fill(255);
    text(serial, 25, 20 + serial * 25);
    text(cardID, 60, 20 + serial * 25);
    text(musicFile, 240, 20 + serial * 25);
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

Record[] loadRecords(String filename) {
  int recordCount = 0;
  String[] lines = loadStrings(filename);
  Record[] records = new Record[slot];
  if (lines == null)
    return records;
  for (int i = 0; i < min(lines.length, slot); i++) {
    String[] pieces = split(lines[i], TAB);
    if (pieces.length == 2) {
      records[recordCount] = new Record(recordCount, pieces);
      recordCount++;
    }
  }
  return records;
}

void saveRecords(String filename, Record[] records) {
  String[] lines = new String[records.length];
  for (int i = 0; i < slot; i++) {
    if (records[i] == null)
      break;
    lines[i] = records[i].toString();
  }
  saveStrings(filename, lines);
}

Record findMatch(String cardID) {
  for (int i = 0; i < slot; i++) {
    if (records[i] == null)
      break;
    if (records[i].cardID.equals(cardID)) {
      return records[i];
    }
  }
  return null;
}

Boolean addRecord(String cardID) {
  for (int i = 0; i < slot; i++) {
    if (records[i] == null) {
      String[] pieces = {cardID, ""};
      records[i] = new Record(i, pieces);
      return true;
    }
  }
  return false;
}