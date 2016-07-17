
import nl.tue.id.oocsi.*;

// OOCSI server
final String Server = "disa.csie.ntu.edu.tw";
final String Channel_CardID = "channelCardID";
final String Channel_Command = "channelCommand";

// Others
final String NULLCardID = "00000000";

final int slot = 10;
final String filename = "cards.tsv";

OOCSI oocsi;
Record[] records;
DisposeHandler dh;

void setup() {
  size(800, 400);
  background(200);
  
  oocsi = new OOCSI(this, "media_server", Server);
  oocsi.subscribe(Channel_CardID);
  
  records = loadRecords(filename);
  dh = new DisposeHandler(this, new Distructor() {
    public void action() {
      println("action");
      saveRecords(filename, records);
    }
  });
}

void draw() {
  background(100);
  for (int i = 0; i < slot; i++) {
    if (records[i] != null) {
      records[i].update();
      records[i].display();
    }
  }
  music();
  delay(100);
}

void channelCardID(OOCSIEvent event) {
  
  String cardID = event.getString("cardID", NULLCardID);
  if (cardID.equals(NULLCardID))
    return;
  
  Record record = findMatch(cardID);
  if (record == null) {
    addRecord(cardID);
    oocsi.channel(Channel_Command).data("cmd", "nomatch").send();
  }
  else {
    if (record.musicFile.equals("")) {
      // no mucis file can be played
      oocsi.channel(Channel_Command).data("cmd", "nomatch").send();
    }
    else {
      // play music
      playNext(record.musicFile);
      oocsi.channel(Channel_Command).data("cmd", "match").send();
    }
  }
}