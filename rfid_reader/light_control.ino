
#define STATE_ALERT 2
#define STATE_IDLE 3
#define STATE_ECHO 4

int state = STATE_IDLE;
int start_time = 0;

void light() {
  switch(state) {
    case STATE_ALERT:
      alert_state();
      break;
    case STATE_IDLE:
      idle_state();
      break;
    case STATE_ECHO:
      echo_state();
      break;
  }
}

void idle_state() {
  static int brightness = 0;
  static int fadeAmount = 5;

  if (state != STATE_IDLE) {
    brightness = 0;
    fadeAmount = 5;
    analogWrite(GREEN_PIN, 0);
    return;
  }

  brightness = brightness + fadeAmount;
  if (brightness == 0 || brightness == 255) {
    fadeAmount = -fadeAmount ;
  }
  analogWrite(GREEN_PIN, brightness);
}

void alert_state() {
  int time_past = millis() - start_time;
  if (time_past > 1000) {
    state = STATE_IDLE;
    return;
  }
  analogWrite(GREEN_PIN, 0);
  analogWrite(YELLOW_PIN, 0);
  if (time_past < 100) {
    digitalWrite(RED_PIN, LOW);
  }
  else if (time_past < 300) {
    digitalWrite(RED_PIN, HIGH);
  }
  else if (time_past < 600) {
    digitalWrite(RED_PIN, LOW);
  }
  else if (time_past < 800) {
    digitalWrite(RED_PIN, HIGH);
  }
  else {
    digitalWrite(RED_PIN, LOW);
  }
}

void echo_state() {
  int time_past = millis() - start_time;
  if (time_past > 1000) {
    state = STATE_IDLE;
    return;
  }
  analogWrite(GREEN_PIN, 0);
}

void alert() {
  start_time = millis();
  state = STATE_ALERT;
}

void echo(int value) {
  if (state == STATE_ALERT)
    return;
  start_time = millis();
  state = STATE_ECHO;
  analogWrite(YELLOW_PIN, value);
}

void idle() {
  if (state == STATE_ALERT)
    return;
  state = STATE_IDLE;
}

