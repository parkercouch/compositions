// ----------------------------------------------------------------- //
// -------------------------- Project 6 ---------------------------- //
// ----------------------------------------------------------------- //

Timbre, or Yawning Cats

Using the models of SynthDefs() we've discussed in the class (available
  in Modules for week 7, Monday and Thursday.)

    1. chord3cents()
    2. chord7cents()
    3. chord7range()
    4. chord7env()
    and
    5. bands2()

build TWO sequences of events, one for the left the other for the right
channels.

Use "longer" durations than you've probably used for projects in the
past: not for "notes" but for "yawning cats".  Imagine cats that yawn
--- the fastest might be 5 seconds, the slowest might be 20 seconds.

Let each sequence be different in number of parts and durations from one
another:

  seq 1 : 5 + 10 + 5 + 20 + 5 + 30 + 5 + 20 + 5 + 10 (sum: 90 seconds, 10 parts)
  seq 2 : 11 + 10 + 13 + 10 + 15 + 10 + 17 + 10 (sum: 96 seconds, 8 parts)

Decide on 
    1. the sequence of SynthDefs for each
    2. the fundamental frequency for each (or 2 frequencies for bands)

If you can, build SynthDefs with three and four bands.  Suggestion for
those who were in the class winter quarter: use frequency modulation
instead of additive synthesis to create the different bands.

Have fun!

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
      ~patterns[\spread].(seq: ~patterns[\left], time_diff:  1.5, scale_diff: 0.5, layers: 6),
      ~patterns[\spread].(seq: ~patterns[\left], time_diff: 0.25, scale_diff:   7, layers: 5),
    ], 1),
    // RIGHT
    Pseq([
      ~patterns[\spread].(seq: ~patterns[\right], time_diff:  0.5, scale_diff:   1, layers: 4),
      ~patterns[\spread].(seq: ~patterns[\right], time_diff:  1.5, scale_diff: 0.5, layers: 8),
      ~patterns[\spread].(seq: ~patterns[\right], time_diff: 0.25, scale_diff:  13, layers: 13),
    ], 1),
  ], 1);

  ~seq = ~synths[\functions][\limiter].(~seq, 0.05);

  ~seq.trace.play(clock: ~clock);
});
)

~seq.start;
