
String byte2Hex(byte[] in) {
  final char map[] = {'0', '1', '2', '3', '4', '5', '6', '7', 
                      '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
  String result = "";
  for(int i = 0; i < in.length; i++) {
    result += map[int((in[i] >> 4) & 0xf)];
    result += map[int(in[i] & 0xf)];
  }
  return result;
}

String readCard() {
  String cardID = NullCardID;
  try {
    arduino.beginTransmission(0x8);
    arduino.write(0x1);
    arduino.write(0x0);
    cardID = byte2Hex(arduino.read(4));
    arduino.endTransmission();
  }
  catch (Exception e) {
    println("Card reader is not ready.");
  }
  return cardID;
}

void alert() {
  try {
    arduino.beginTransmission(0x8);
    arduino.write(0x3);
    arduino.write(0x0);
    arduino.endTransmission();
  }
  catch (Exception e) {
    println("Card reader is not ready.");
  }
}

void idle() {
  try {
    arduino.beginTransmission(0x8);
    arduino.write(0x4);
    arduino.write(0x0);
    arduino.endTransmission();
  }
  catch (Exception e) {
    println("Card reader is not ready.");
  }
}

void echo(int value) {
  try {
    arduino.beginTransmission(0x8);
    arduino.write(0x5);
    arduino.write(value);
    arduino.endTransmission();
  }
  catch (Exception e) {
    println("Card reader is not ready.");
  }
}