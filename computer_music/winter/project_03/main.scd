// ----------------------------------------------------------------- //
// -------------------------- Project 3 ---------------------------- //
// ----------------------------------------------------------------- //

Pick 3 riddles

Make a musical analogy for each riddle: one for the question, the other for the answer

The whole piece should not be more than 2 minutes long.

// ----------------------------------------------------------------- //
// -------------------------- Setup -------------------------------- //
// ----------------------------------------------------------------- //

( // --- SETUP
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;

// credit to Nathan Ho - https://sccode.org/1-5dX
SynthDef(\FMRhodes1, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1, lfoSpeed = 4.8, inputLevel = 0.2,
    // all of these range from 0 to 1
    modIndex = 0.2, mix = 0.2, lfoDepth = 0.1;

    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * 30) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
  	snd = snd * (SinOsc.ar(lfoSpeed).range((1 - lfoDepth), 1));

    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;
)

( // SEQUENCE
~baseOptions = P3Options.new
  .amp_(1)
  .pan_(0.8)
  .instrument_(\FMRhodes1);

~sequence = Pseq([
  P3CallAndResponse(options: ~baseOptions.copy
      .scale_(Scale.minorPentatonic)
      .melody_(Pseq([  1,5,   3,   2,  7,8,1]))
      .rhythm_(Pseq([0.5,1,0.25,0.25,0.5,1,2]))
  ),
  RestFor(1),
  P3CallAndResponse(options: ~baseOptions.copy
      .octave_([2,3])
      .scale_(Scale.partch_u1)
      .melody_(Pseq([10,8,7,4], 4))
      .rhythm_(Pseq([Pn(0.25, 4)], 4))
  ),
  RestFor(1),
  P3CallAndResponse(options: ~baseOptions.copy
      .octave_(2)
      .scale_(Scale.superLocrian)
      .melody_(Pseq([9,5,3,1], 3))
      .rhythm_(Pseq([Pn(0.1, 4)], 3))
  ),
  RestFor(1),
  P3CallAndResponse(options: ~baseOptions.copy
      .octave_([2,3])
      .scale_(Scale.partch_u2)
      .melody_(Pseq([10,11,12,[13,14]], 4))
      .rhythm_(Pseq([Pn(0.3, 4)], 4))
  ),
  RestFor(1),
  P3CallAndResponse(options: ~baseOptions.copy
      .scale_(Scale.partch_o2)
      .melody_(Pseq([  1,5,   3,   2,  7,8,1]))
      .rhythm_(Pseq([0.5,1,0.25,0.25,0.5,1,2]))
  ),
]);

~sequence.trace.play;
)

