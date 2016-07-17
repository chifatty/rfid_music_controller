#include <MFRC522.h>
#include <SPI.h>
#include <Wire.h>

#define GREEN_PIN 3
#define RED_PIN 4 
#define YELLOW_PIN 5

#define SS_PIN 10
#define RST_PIN 9

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance.

int command;
int argument;
int reaction_brightness = 0;
byte cardID[4];


void setup() {
  command = 0;
  Serial.begin(9600);   // Initialize serial communications with the PC
  SPI.begin();          // Init SPI bus
  mfrc522.PCD_Init();   // Init MFRC522 card
  Wire.begin(8);                // join i2c bus with address #8
  Wire.onReceive(receiveEvent); // register event
  Wire.onRequest(sendData);
  cardID[0] = cardID[1] = cardID[2] = cardID[3] = 0;
  
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(YELLOW_PIN, OUTPUT);
  alert();
}

void loop() {
  light();
  delay(30);
}

void receiveEvent(int byteReceived) {
  if (byteReceived == 2) {
    command = Wire.read();
    argument = Wire.read();
    switch (command) {
      case 3:
        alert();
        Serial.println("alert");
        break;
      case 4:
        idle();
        break;
      case 5:
        echo(int(argument));
        break;
      default:
        break;
    }
  }
}

void sendData() {
  switch (command) {
    case 1:
      getID(cardID);
      Wire.write(cardID, 4);
      break;
    default:
      break;
  }
}
