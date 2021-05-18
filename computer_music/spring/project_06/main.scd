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

  ~clock = TempoClock(1);
  
  ~seq = Ppar([
    // LEFT
    Pseq([
      ~patterns[\spread].(seq: ~patterns[\left], time_diff:  0.5, scale_diff:   1, layers: 4),
      ~patterns[\spread].(seq: ~patterns[\left], time_diff: 0.25, scale_diff: 1.5, layers: 5),
      ~patterns[\spread].(seq: ~patterns[\left], time_diff:  1.5, scale_diff: 0.5, layers: 6),
    ], 1),
    // RIGHT
    Pseq([
      ~patterns[\spread].(seq: ~patterns[\right], time_diff:  0.5, scale_diff:   1, layers: 4),
      ~patterns[\spread].(seq: ~patterns[\right], time_diff: 0.25, scale_diff: 1.5, layers: 5),
      ~patterns[\spread].(seq: ~patterns[\right], time_diff:  1.5, scale_diff: 0.5, layers: 6),
    ], 1),
  ], 1);

  ~seq.trace.play(clock: ~clock);
});
)

~task.start;
