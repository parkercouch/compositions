// ----------------------------------------------------------------- //
// -------------------------- Final -------------------------------- //
// ----------------------------------------------------------------- //

A musical form favored by Charlie Mingus (among others) was called the
"rondo".

Mingus used this form in the following way:

    A1 B A2 C A3 D A4

So there is an "A" part, that changes while being recognizably the
same.  In between the repeats of "A", come other sections that are
distinct from A: B, C and D.

An example of Mingus' use of this form is in his piece "Fables of
Faubus"

The form was also popular with classical composers, such as Mozart
and Beethoven. Listen to the Beethoven Piano Concerto #4 (last
movement), or the Mozart Piano Concert in D minor (last movement).

Use the FM algorithm and granular synthesis for the sound sources.

Show the correct use of Envelopes, Filters, and Panning.

The piece should be no more than 3 minutes long.

It's due on Thursday afternoon, March 11 --- our last class meeting!

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
)

s.plotTree;

// ----------------------------------------------------------------- //
// -------------------------- Synths ------------------------------- //
// ----------------------------------------------------------------- //

( // Sound Source
SynthDef(\kicker, {
  arg sustain = 0.331,
      freq = 60,
      filter_freq = 800,
      filter_rq = 0.7,
      distort_ratio = 0.6;

  var snd, sweep, env;

  sweep = Env(
    levels: [1000, 50, freq],
    times:     [0.015,  0.1],
    curve: \exp,
  ).ar * [-0.5,-0.1,0,0.1,0.5].midiratio;

  env = Env(
    levels: [0, 1,  0.7,             0.7, 0.01],
    times: [0.001, 0.01, sustain - 0.031, 0.02],
  ).ar(doneAction: 2);

  snd = Mix(SinOsc.ar(sweep));
  snd = RLPF.ar(snd, filter_freq, filter_rq);
  snd = snd * env;
  snd = (snd * distort_ratio).clip(-1, 1);
  Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;

SynthDef(\fm, {
  arg freq=500,
      mRatio=1, cRatio=1,
      index=1, iScale=5,
      cAtk=4, cRel=(-4),
      amp=0.2,
      atk=0.01, rel=3;
  var car, mod, ampEnv, iEnv;
  
  iEnv = Env(
    [index, index*iScale, index],
    [atk, rel],
    [cAtk, cRel],
  ).kr();
  
  ampEnv = Env.perc(atk, rel, curve:[cAtk,cRel]).kr(doneAction:2);
  
  mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
  car = SinOsc.ar(freq * cRatio + mod) * ampEnv * amp;

  car = Pan2.ar(car, \pan.kr(0));
  Out.ar(\out.kr(0), car);
}).add;

SynthDef(\fm2, {
  arg freq = 440,
      modindex = 10,
      amp = 0.1,
      atk = 0.01,
      rel = 0.3;

  var car, mod, freqdev, env, modfreq;

  env = Env.asr(
    attackTime: atk,
    sustainLevel: amp/1.3,
    releaseTime: rel
  ).kr(doneAction: 2, gate: \gate.kr(1));

  modindex = Line.kr(modindex, 1, atk);
  modfreq = freq / 2;
  freqdev = modfreq * modindex;

  mod = SinOsc.ar(freq: modfreq, mul: freqdev);

  car = SinOsc.ar(
    freq: [freq + mod, freq * 1.01 + mod]
  ) + SinOsc.ar(
    freq: [freq + mod, freq * 1.01 + mod]/2
  );

  car = car + FreeVerb.ar(
    in: car,
    mix: 0.33,
    room: 0.75,
    damp: 0.25,
  );

  car = Pan2.ar(car, \pan.kr(0), env);
  Out.ar(\out.kr(0), car * 0.5);
}).add;

SynthDef(\FMGrain, {
  arg envbuf;
  var envelope, signal;

  envelope = EnvGen.kr(
    envelope: Env([0, 1, 0], [1, 1], \lin, 1),
    gate: \gate.kr(1),
    levelScale: \amp.kr(1),
    doneAction: Done.freeSelf
  );

  signal = GrainFM.ar(
    numChannels: 2,
    trigger: Impulse.kr(\rate.kr(10)),
    dur: \grain_length.kr(0.1),
    carfreq: \carfreq.kr(440) + (\freqdev.kr(100) / 2),
    modfreq: \modfreq.kr(200),
    index: LFNoise1.kr.range(1, 10),
    pan: \pan.kr(0),
    envbufnum: envbuf,
  );

  signal = signal * envelope;

  Out.ar(\out.kr(0), signal)
}).add;
)

( // Effects
SynthDef(\LPF, { arg out=0, gate=1, freq=1000, rq=1.0, amp=0.5;
    var env, snd;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    snd = In.ar(out, 2);
    snd = RLPF.ar(snd, freq, rq);
    XOut.ar(out, env, snd*amp);
}, [\ir, 0, 1000, 1.0, 0.5]).add;

SynthDef(\echo, { arg out=0, maxdtime=0.2, dtime=0.2, decay=2, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, CombL.ar(in * env, maxdtime, dtime, decay, 1, in));
}, [\ir, \ir, 0.1, 0.1, 0]).add;

SynthDef(\distort, { arg out=0, pregain=40, amp=0.2, gate=1;
    var env;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    XOut.ar(out, env, (In.ar(out, 2) * pregain).distort * amp);
}, [\ir, 0.1, 0.1, 0]).add;

SynthDef(\wah, { arg out=0, gate=1, amp=0.5;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, RLPF.ar(in, LinExp.kr(LFNoise1.kr(0.3), -1, 1, 200, 8000), 0.1).softclip * amp);
}, [\ir, 0]).add;

SynthDef(\limiter, { arg out=0, thresh=0.5, slopeBelow=1.0, slopeAbove=1.0, clampTime=0.01, relaxTime=0.1, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    in = Compander.ar(
      in: in,
      control: in,
      thresh: thresh,
      slopeBelow: slopeBelow,
      slopeAbove: slopeAbove,
      clampTime: clampTime,
      relaxTime: relaxTime,
    );
    XOut.ar(out, env, in);
}, [\ir, 0.5, 1.0, 1.0, 0.01, 0.1, 0]).add;

~limit = {
  arg thresh=0.5;

  [
    thresh: thresh,
    slopeBelow: 2.0,
    slopeAbove: 1.0,
    clampTime: 1.01,
    relaxTime: 1.1,
  ]
};

)

// ----------------------------------------------------------------- //
// ------------------------- Phrases ------------------------------- //
// ----------------------------------------------------------------- //

(

~melody = {
  arg repeats = 2,
      endOctave = 5,
      endChord = [1,4,9],
      start = [4,7];

  Pbind(*[
    instrument: \fm,
    scale: Scale.zhi,
    octave: Pseq([    5,   5,    5,    5,   5,      5, endOctave], inf),
    degree: Pseq([start,   5,    2,    3,   0,[1,4,8],  endChord], inf),
    rel:    Pseq([    2,   2,    2,    2,   2,      3,         4], inf),
    dur:    Pseq([    1, 0.5, 0.25, 0.25, 1.5,   1.25,         2], 2),
    mRatio: 1,
    cRatio: 1,
    index: 10,
    iScale: 2,
    atk: 0.1,
    amp: 0.8,
  ])
};

~snare = {
  arg rel = 2,
      repeats = 5, 
      dur = Pseq([Rest(1), 1], repeats);

  Pbind(*[
    instrument: \fm,
    freq: 1000,
    mRatio: 10,
    cRatio: 1000,
    index: 100,
    iScale: 2,
    cAtk: 4,
    cRel: -4,
    atk: 0.01,
    rel: rel,
    dur: dur,
    amp: 1,
  ])
};

~roll = {
  arg repeats = 1;

  Pbind(*[
    instrument: \fm,
    scale: Scale.zhi,
    degree: Pseq([1,2,3], inf),
    // freq: 1000,
    mRatio: 10,
    cRatio: 10,
    index: 1000,
    iScale: 2,
    cAtk: 4,
    cRel: -4,
    atk: 0.01,
    rel: 0.3,
    dur: Pn(0.05, 16 * repeats),
    amp: 1,
  ])
};

~assault = {
  arg repeats = 5;

  Pbind(*[
    instrument: \fm,
    scale: Scale.zhi,
    degree: Pseq([1,2,3,4,5,6,7], repeats),
    mRatio: Pseq([1, 10, 100], inf),
    cRatio: 1,
    index: [100, 10, 1],
    iScale: 20,
    cAtk: 4,
    cRel: -4,
    rel: 1,
    atk: Pfunc({[0.01, 0.1, 0.2].choose}),
    dur: Pfunc({[0.1, 0.25, 0.5].choose}),
    amp: 1,
  ])
};

~solo = {
  arg repeats = 100;

  Pmono(*[
    \fm,
    scale: Scale.zhi,
    octave: Pseq([5,6] collect: Pn(_, 15), inf),
    root: Pwrand(
      [ 0,1,2,[1,3]],
      [10,2,1,3].normalizeSum,
      inf,
    ),
    degree: Pwrand(
      [1,2,3,4,5,6,7,8,9],
      [5,2,10,4,3,3,10,2,2].normalizeSum,
      inf,
    ),
    mRatio: Pseq([1, 2], repeats),
    cRatio: Pseq([2, 1], repeats),
    index: 10,
    iScale: 2,
    atk: 0.1,
    rel: 100,
    dur: Pwrand(
      [0.1, 0.2, 0.05, 0.11, 0.12, 0.5],
      [ 10,   8,    3,   10,   10, 1].normalizeSum,
      inf
    ),
    amp: 1,
  ])
};

~what = Pfx(Pfx(~solo.(50), \echo, *[
  dtime: Pwrand(
    [0.2, 0.3, 1.4],
    [ 10,   5,   1].normalizeSum,
  ),
  decay: Pwrand(
    [ 2, 4, 6],
    [10, 5, 2].normalizeSum,
  ),
]), \limiter, *~limit.(0.2));

~waah = {
  var panningEnv = Env.pairs(
    pairs: #[
      [0, -1],
      [2, 0],
      [4, 1],
      [6, 0],
      [8, -1],
      [10, 0],
    ],
    curve: \lin,
  );

  Pbind(*[
    instrument: \FMGrain,
    envbuf: -1,
    carfreq: Pseq([100, 200, 400, 800, 1600].reverse /2, 5),
    modfreq: Pkey(\carfreq) / 4,
    rate: Pkey(\carfreq) / 10,
    grain_length: 0.51,
    dur: Pn(Pkey(\grain_length), 100),
    pan: panningEnv,
    amp: 0.5,
  ])
};

~panningKick = {
  arg panningEnv = Env.pairs(
        pairs: #[
          [ 0,  0],
          [ 2,  1],
          [ 4,  0],
          [ 6, -1],
          [ 8,  0],
          [10,  1],
          [12,  0],
        ],
        curve: \lin,
      ),
      freq = [100, 99];


  var pattern = Pbind(*[
    instrument: \kicker,
    dur: Pseq([Pn(0.25, 4), 0.5, 0.5, 1], 5),
    freq: freq,
    pan: panningEnv,
    amp: 0.25,
  ]);

  pattern = Pfx(pattern, \echo, *[
    dtime: 1.05,
    decay: 3,
  ]);

  Pgroup(pattern)
};

~kick = {
  arg repeats = 5;

  Pbind(*[
    instrument: \kicker,
    dur: Pseq([1, Rest(1), 1, Rest(1)], repeats),
    freq: [100, 50],
    amp: 0.5,
  ])
};

~longkick = {
  arg repeats = 5,
      dur = 3.9;

  Pbind(*[
    instrument: \kicker,
    dur: Pn(dur, repeats),
    sustain: dur,
    freq: [100, 50],
    amp: 0.5,
  ])
};

~static = Pbind(*[
  instrument: \fm2,
  scale: Scale.zhi,
  degree: Pseq([1,2,3,4,5,6,7]),
  modindex: 1000,
  atk: 1,
  rel: 2,
  dur: 3,
]);

)

// ----------------------------------------------------------------- //
// ------------------------- Sections ------------------------------ //
// ----------------------------------------------------------------- //

(
// INTRO
~snareIntro = Pgroup(Pfx(~snare.(
  rel: 1,
  dur: Pseq([Rest(1.5), 0.5, 1], 3),
), \wah));

~introMelody = Pgroup(Pfx(~melody.(
  repeats: 2,
  start: 7,
  endChord: [2,4,6]
), \distort, *[
    pregain: 50,
    amp: 0.25,
]));

~intro = Ptpar([
  0, ~static,
  4.5, ~panningKick.(),
  10, ~snareIntro,
  15, ~introMelody,
  28, ~roll.(),
]);

// SECTION A
~sectionA = {
  arg offset = false,
      endOctave,
      endChord;
  var t1 = 0, t2 = 1;

  if (offset) {
    t1 = 1;
    t2 = 0;
  };

  Ptpar([
    t1, ~kick.(4),
    t1, ~snare2,
    t2, ~melody.(endChord: endChord, endOctave: endOctave),
  ])
};

~a1 = ~sectionA.();
~a2 = ~sectionA.(endChord: [2,4,11], endOctave: [3,4]);
~a3 = ~sectionA.(endChord: [1,4,11], endOctave: [4,5], offset: true);
~a4 = ~sectionA.(endChord: [2,4,11], endOctave: [2,4]);

// SECTION B
~b = Ppar([
  Pfx(~waah.(), \LPF, \freq, 1500, \amp, 0.5),
  ~kick.(3),
]);

// SECTION C
~c = Ppar([
  ~assault.(6),
  ~kick.(3),
]);

// SECTION D
~d = Pseq([
  Ptpar([
    0, Pgroup(Pfx(Pfx(Pfx(~solo.(50), \echo, *[
      dtime: 0.1,
      decay: 2,
    ]), \limiter, *~limit.(2))),
        \LPF, \freq, 1500),
    0, Pgroup(Pfx(Pfx(Pfx(~solo.(50), \echo, *[
      dtime: 0.2,
      decay: 3,
    ]), \limiter, *~limit.(2))),
        \LPF, \freq, 1500),
    1, ~longkick.(1, 10),
  ]),
  Ptpar([
    0, ~what,
    1, ~longkick.(1, 10),
  ]),
]);

)

// ----------------------------------------------------------------- //
// ------------------------- Sequence ------------------------------ //
// ----------------------------------------------------------------- //

(
~sequence = Pseq([
  ~intro,
  ~a1,
  ~b,
  ~roll.(),
  ~a2,
  ~roll.(2),
  ~c,
  ~roll.(),
  ~a3,
  ~kick.(1),
  ~d,
  ~roll.(),
  ~a4,
]);
// ~sequence = Pfx(~sequence, \limiter, *~limit.(0.5));
~sequence.trace.play;
)




//// EXTRAZ

// (
// ~fm = Pbind(*[
//   instrument: \FM2,
//   scale: Scale.zhi,
//   degree: Pseq([1,2,3,4,5,6,7]),
//   modindex: 1000,
//   att: 1,
//   rel: 2,
//   dur: 3,
// ]);
// ~fm.trace.play;
// )

// (
// ~fmm = Pbind(*[
//   // instrument: \FM2,
//   instrument: \fm,
//   scale: Scale.zhi,
//   degree: Pseq([1,2,3,4,5,6,7]),
//   modindex: 1000,
//   att: 1,
//   atk: 1,
//   rel: 2,
//   dur: 3,
//   mRatio: 1,
//   cRatio: 10,
//   index: 10,
//   iScale: 10,
// ]);
// ~fmm.trace.play;
// )


( // TODO: add this?
~melody3 = {
  arg repeats = 3;

  Pbind(*[
    instrument: \fm,
    scale: Scale.zhi,
    // degree: Pseq([7,5,2,3,0,[1,4,8],[0,3,7]], inf),
    octave: 4,
    root: Pseq([2, 5, 1] collect: Pn(_, 7), inf),
    degree: Pseq([7,5,2,3,0,[1,4,8],[2,4,6]], inf),
    // degree: Pseq([2,2,2,2,0,[2,4,8],[2,4,6]], inf),
    mRatio: 1,
    cRatio: 1,
    index: 1,
    iScale: 1,
    cAtk: 100,
    cRel: 10,
    atk: 0.1,
    rel: Pseq([2, 2, 2, 2, 2, 3, 4], inf),
    dur: Pseq([1, 0.5, 0.25, 0.25, 1.5, 1.25, 4], repeats),
    amp: 0.8,
  ])
};
// ~melody3.().trace.play;
a = ~melody3.();

b = Pfx(c, \limiter, *[
  thresh: 0.8,
  slopeBelow: 2.0,
  slopeAbove: 1.0,
  clampTime: 1.01,
  relaxTime: 1.1,
]);
c = Pfx(a, \LPF, \freq, 1000, \amp, 0.5);
// a.trace.play;
b.trace.play;
// c.trace.play;
)
