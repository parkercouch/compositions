( // --- START
Server.default = s = Server.internal.boot;
)

( // --- FREE
s.freeAll;
)

( // --- TOOLS
s.meter;
s.scope;
FreqScope.new(522, 300, 0, server: s);
)

( // --- OPTIONS
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;
)


(
~composition = Ppar([
  Pseq([
    ~phraseIntro,
    ~phrase1,
    ~phrase3,
    ~phrase2,
  ]),
], 1).play
)

~composition.stop;

// ------------------------------------------------------- //
// ---------------------- PHRASES ------------------------ //
// ------------------------------------------------------- //

(
~phraseIntro = Ppar([
  Pbind(*[
    instrument: \pulsar,
    // fund: Pseq([40, 30, 50, 20, 100], inf),
    fund: Pseq([40, 30]),
    randSeed: 150,
    maxPartial: 10,
    ampHz: 2,
    width: 0.5,
    dur: 4.00,
  ]),
], 1);
)

(
~phrase1 = Ppar([
  Pbind(*[
    instrument: \pulsar,
    // fund: Pseq([40, 30, 50, 20, 100], inf),
    fund: Pseq([50, 20]),
    randSeed: 150,
    maxPartial: 10,
    ampHz: 2,
    width: 0.5,
    dur: 4.00,
  ]),
  Pbind(*[
    instrument: \kicker,
    dur: Pseq([
      4.0,
      4.0,
      // 2.0,
      // 2.0,
      // 1.0,
      // 1.0,
      // 1.0,
    ]),
    amp: 0.15,
    // sustain: 1.5,
    sustain: Pseq([
      4.5,
      4.5,
      1.5,
      1.5,
      1.5,
      1.5,
      1.5,
    ]),
    // tones: #[-5.0, 100, 500],
    tones: [-5.0, 100, 500],
    // tones: [-800, 1000, 500],
  ]),
], 1);
)

(
~phrase2 = Ppar([
  Pbind(*[
    instrument: \pulsar,
    fund: Pseq([35, 20, 50], inf),
    // fund: Pseq([15, 5, 12], inf),
    randSeed: 150,
    maxPartial: Pfunc {|n| n * 0.9} <> Pkey(\fund),
    ampHz: Pfunc {|n| n * 1000} <> Pkey(\fund),
    width: 0.2,
    dur: 8.00,
  ]),
  Pbind(*[
    instrument: \technokick,
    spread: Pseq([0.9,0.8,0.6,0], inf),
    click: Pwhite(0.006, 0.008, inf),
    dur: 2,
    legato: 1,
    // midinote: Pseq([Pseq([32], 4), Pseq([28], 4)]);
    midinote: Pseq([Pseq([32], 4), Pseq([28], 4)]);
  ]),
], 1);
)

(
~phrase3 = Ppar([
  Pbind(*[
    instrument: \pulsar,
    fund: Pseq([35, 20, 48]),
    // fund: Pseq([25, 20, 19], inf),
    randSeed: 150,
    maxPartial: 10,
    ampHz: 20000,
    width: 0.5,
    dur: 4,
  ]),
  Pbind(*[
    instrument: \technokick,
    spread: Pseq([0.9,0.8,0.6,0], inf),
    click: Pwhite(0.006, 0.008, inf),
    dur: 2,
    legato: 1,
    // midinote: Pseq([Pseq([32], 4), Pseq([28], 4)]);
    midinote: Pseq([Pseq([32], 3), Pseq([28], 3)]);
  ]),
]);
)


// ------------------------------------------------------- //
// ----------------------- SYNTHS ------------------------ //
// ------------------------------------------------------- //

( // KICKER
SynthDef(\kicker, {
  arg sustain = 0.331,
      tones = #[-0.1, 0, 0.1];
  var snd;
  snd = SinOsc.ar(Env([1000, 69, 60], [0.015, 0.1], \exp).ar * tones.midiratio);
  snd = Mix(snd);
  snd = (snd * 10).tanh;
  snd = (snd * 5.1).atan;
  snd = BPeakEQ.ar(snd, XLine.kr(2000, 100, 0.3), 2.0, 8);
  snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(4).range(0.0, 0.001));
  snd = RLPF.ar(snd, 8000, 0.7);
  snd = snd * Env([0, 1, 0.7, 0.7, 0], [0.001, 0.01, sustain - 0.031, 0.02]).ar(2);
  snd = (snd * 0.6).clip(-1, 1);
  Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

( // PULSAR
SynthDef(\pulsar, {
  arg ampHz = 4,
  fund = 40,
  maxPartial = 4,
  width = 0.5,
  randSeed,
  id = 1,
  gate = 1,
  dur = 1,
  attack = 0.8,
  decay = (dur - 0.9),
  release = 0.1;

  var amp1, amp2, sig1, sig2, freq1, freq2, out1, out2;
  var freq3, freq4, out3, out4, sig3, sig4, amp3, amp4;
  var fundamental, noteWidth;
  var phraseEnv;

  RandID.ir(id);
  RandSeed.ir(1, randSeed);

  fundamental = fund.value;
  noteWidth = width.value;

  phraseEnv = EnvGen.kr(
    envelope: Env.new(
      levels: [0]++[1.0, 0.8, 0.0],
      times:       [0.8, dur - 0.9, 0.1],
      // times:       [0.8, dur, 0.1],
      curve:  [-5, 0, 5],
    ),
    gate: gate,
    doneAction: Done.freeSelf,
  );

  // TODO: remove duplication
  amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
  amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
  amp3 = LFPulse.kr(ampHz, 0.25, 0.12) * 0.75;
  amp4 = LFPulse.kr(ampHz, 0.125, 0.12) * 0.75;
  freq1 = LFNoise0.kr(4).exprange(fundamental, fundamental * maxPartial).round(fundamental);
  freq2 = LFNoise0.kr(4).exprange(fundamental, fundamental * maxPartial).round(fundamental);
  freq3 = LFNoise0.kr(4).exprange(fundamental, fundamental * maxPartial).round(fundamental);
  freq4 = LFNoise0.kr(4).exprange(fundamental, fundamental * maxPartial).round(fundamental);
  freq1 = freq1 * (LFPulse.kr(8)+1);
  freq2 = freq2 * (LFPulse.kr(6)+1);
  freq3 = freq3 * (LFPulse.kr(4)+1);
  freq4 = freq4 * (LFPulse.kr(2)+1);

  sig1 = Pulse.ar(freq1, noteWidth, amp1);
  sig2 = Pulse.ar(freq2, noteWidth, amp2);
  sig3 = Pulse.ar(freq3, noteWidth, amp3);
  sig4 = Pulse.ar(freq4, noteWidth, amp4);
  sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
  sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
  sig3 = FreeVerb.ar(sig3, 0.7, 0.8, 0.25);
  sig4 = FreeVerb.ar(sig4, 0.7, 0.8, 0.25);

  sig1 = Pan2.ar(sig1, SinOsc.kr(SinOsc.kr(0.1, 0).range(1, 2), pi), phraseEnv);
  out2 = Pan2.ar(sig2, SinOsc.kr(SinOsc.kr(0.1, pi).range(1, 2), 0), phraseEnv);
  out3 = Pan2.ar(sig3, SinOsc.kr(SinOsc.kr(0.01, 0).range(0.1, 0.3), pi),phraseEnv);
  out4 = Pan2.ar(sig4, SinOsc.kr(SinOsc.kr(0.01, pi).range(0.1, 0.3), 0), phraseEnv);

  Out.ar(0, sig1);
  Out.ar(0, out2);
  Out.ar(0, out3);
  Out.ar(0, out4);
}).add;
)

// ------------------------------------------------------- //
// ---------------------EXPERIMENT------------------------ //
// ------------------------------------------------------- //

Pdef(\pulse).play;
Pdef(\pulse).stop;

(
Pdef(\pulse, Pbind(*[
  instrument: \pulsar,
  fund: Pseq([40, 30, 50, 20, 100], inf),
  randSeed: 150,
  maxPartial: 10,
  ampHz: 2,
  width: 0.5,
  dur: 5.00,
]));
)

(
Pdef(\pulse, Pbind(*[
  instrument: \pulsar,
  fund: Pseq([35, 20, 25], inf),
  randSeed: 150,
  maxPartial: 20,
  // ampHz: 2,
  ampHz: 20,
  width: 0.5,
  dur: 4.00,
]));
)

(
Pdef(\pulse, Pbind(*[
  instrument: \pulsar,
  fund: Pseq([35, 20, 48], inf),
  // fund: Pseq([25, 20, 19], inf),
  randSeed: 150,
  maxPartial: 10,
  ampHz: 20000,
  width: 0.5,
  dur: 4.2125,
]));
)

(
Pdef(\pulse, Pbind(*[
  instrument: \pulsar,
  fund: Pseq([35, 20, 48], inf),
  randSeed: 150,
  maxPartial: Pfunc {|n| n * 1.25} <> Pkey(\fund),
  ampHz: Pfunc {|n| n * 10} <> Pkey(\fund),
  width: 0.5,
  dur: 4.00,
]));
)

(
Pdef(\pulse, Pbind(*[
  instrument: \pulsar,
  fund: Pseq([35, 20, 50], inf),
  randSeed: 150,
  maxPartial: Pfunc {|n| n * 1.1} <> Pkey(\fund),
  ampHz: Pfunc {|n| n * 100} <> Pkey(\fund),
  width: 0.5,
  dur: 4.00,
]));
)

(
Pdef(\pulse, Pbind(*[
  instrument: \pulsar,
  // fund: Pseq([35, 20, 50], inf),
  fund: Pseq([15, 5, 12], inf),
  randSeed: 150,
  maxPartial: Pfunc {|n| n * 0.9} <> Pkey(\fund),
  ampHz: Pfunc {|n| n * 1000} <> Pkey(\fund),
  width: 0.2,
  dur: 8.00,
]));
)

Pdef(\pulse).play;
Pdef(\pulse).stop;
