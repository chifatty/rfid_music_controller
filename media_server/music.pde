import processing.sound.*;

final int STATE_IDLE = 0;
final int STATE_PLAYING = 1;
final int STATE_STOPING = 2;

int state = STATE_IDLE;
int start_time = 0;
float duration = 0;

String this_music = "";
String next_music = "";

SoundFile sound;

void music() {
  switch(state) {
    case STATE_IDLE:
      idle_state();
      break;
    case STATE_PLAYING:
      playing_state();
      break;
    case STATE_STOPING:
      stoping_state();
      break;
  }
}

void idle_state() {
  if (this_music.equals(""))
    return;
  sound = new SoundFile(this, this_music);
  start_time = millis();
  duration = sound.duration();
  sound.play();
  state = STATE_PLAYING;
}

void playing_state() {
  if ((millis() - start_time) / 1000 > duration) {
    this_music = "";
    sound.stop();
    state = STATE_IDLE;
    oocsi.channel(Channel_Command).data("cmd", "idle").send();
    return;
  }
  if (!next_music.equals("")) {
    start_time = millis();
    state = STATE_STOPING;
  }
  int left = int((duration - ((millis() - start_time) / 1000 ))/duration * 255);
  oocsi.channel(Channel_Command).data("cmd", "remain").data("arg", left).send();
}

void stoping_state() {
  if ((millis() - start_time) > 2000) {
    if (!next_music.equals("")) {
      this_music = next_music;
      next_music = "";
    }
    else {
      this_music = "";
    }
    sound.stop();
    state = STATE_IDLE;
  }
  else {
    float time_left = 2000 - (millis() - start_time);
    float volume = time_left/2000;
    if (volume > 1)
      volume = 0;
    sound.amp(volume);
  }
}

void playNext(String filename) {
  if (this_music.equals("")) {
    this_music = filename;
  }
  else if (!this_music.equals(filename)) {
    next_music = filename;
  }
}