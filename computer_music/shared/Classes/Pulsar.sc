Pulsar {
  var fundamental = 100, playing;

  *new {|fundamental|
    ^super.newCopyArgs(fundamental)
  }

  play {
    playing = {SinOsc.ar(fundamental!2, mul: 0.2)}.play;
  }

  stop {
    playing.free;
  }
}
