

int getID(byte buff[]) {
  // static unsigned long read_time = 0;
  
  //if (millis() - read_time > 3000) {
  buff[0] = buff[1] = buff[2] = buff[3] = 0;
  //}
  
  // Look for new cards
  if ( !mfrc522.PICC_IsNewCardPresent() ) {
    return 0;
  }

  // Select one of the cards
  if ( !mfrc522.PICC_ReadCardSerial() ) {
    return 0;
  }

  // read_time = millis();

  Serial.println(F("Scanned PICC's UID:"));
  for (int i = 0; i < 4; i++) {  //
    buff[i] = mfrc522.uid.uidByte[i];
    Serial.print(buff[i], HEX);
  }
  
  Serial.println("");
  mfrc522.PICC_HaltA(); // Stop reading
  return 1;
}

