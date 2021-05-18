// ----------------------------------------------------------------- //
// -------------------------- Project 6 ---------------------------- //
// ----------------------------------------------------------------- //



// ----------------------------------------------------------------- //
// -------------------------- Setup -------------------------------- //
// ----------------------------------------------------------------- //

( // --- START
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;

s.waitForBoot({
  ~synths = "./synths.scd".loadRelative[0];
  ~patterns = "./patterns.scd".loadRelative[0];
  ~misc = "./misc.scd".loadRelative[0];

  ~clock = TempoClock(30/60);

  ~seq = Ppar([
    // LEFT
    Pseq([
      Pbind(*[
        instrument: \chord7env,
        freq:  Pseq([430,  210, 100], 1),
        range: Pseq([100, 1000,  50], 1),
        dur:   Pseq([ 10,    5,  15], 1),
        delta: Pseq([ 5,   2.5, 7.5], 1),
        pan: -1,
      ]),
      Pbind(*[
        instrument: \chord7env,
        freq:  Pseq([ 30,   40, 20], 1),
        range: Pseq([100, 1000, 50], 1),
        dur: 20,
        delta: 10,
        pan: -1,
      ]),
    ], 1),
    // RIGHT
    Pseq([
      Pbind(*[
        instrument: \bands2,
        f1:     Pseq([440,  220, 110], 1),
        range1: Pseq([100, 1000,  50], 1),
        f2:     Pseq([540,  320, 210], 1),
        range2: Pseq([100, 1000,  50], 1),
        dur: 10,
        delta: 5,
        pan: 1,
      ]),
      Pbind(*[
        instrument: \bands2,
        f1: Pseq([40, 20, 10], 1),
        range1: Pseq([100, 1000, 50], 1),
        f2: Pseq([40, 20, 10], 1),
        range2: Pseq([100, 1000, 50], 1),
        dur: 20,
        delta: 10,
        pan: 1,
      ]),
    ], 1),
  ], 1);

  ~seq.trace.play(clock: ~clock);
});
)

~task.start;
