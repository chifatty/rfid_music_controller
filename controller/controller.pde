import processing.io.*;
import nl.tue.id.oocsi.*;

// OOCSI server
final String Server = "disa.csie.ntu.edu.tw";
final String Channel_CardID = "channelCardID";
final String Channel_Command = "channelCommand";

// Others
final String NullCardID = "00000000";

// Glocal variables
I2C arduino;
OOCSI oocsi;

void setup() {
  arduino = new I2C(I2C.list()[0]);
  oocsi = new OOCSI(this, "card_reader", Server);
  oocsi.subscribe(Channel_Command);
}

void draw() {
  String cardID = readCard();
  if (!cardID.equals(NullCardID)) {
    oocsi.channel(Channel_CardID).data("cardID", cardID).send();
  }
  delay(500);
}


void channelCommand(OOCSIEvent event) {
  String cmd = event.getString("cmd", null);
  String arg = event.getString("arg", "0");
  if (cmd.equals("nomatch")) {
    alert();
  }
  else if (cmd.equals("idle")) {
    idle();
  }
  else if (cmd.equals("remain")) {
    echo(int(arg));
  }
}