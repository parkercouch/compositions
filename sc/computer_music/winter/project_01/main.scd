// ------------------------------------------------------- //
// ---------------------- SETUP -------------------------- //
// ------------------------------------------------------- //
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

// ------------------------------------------------------- //
// -------------------- COMPOSITION ----------------------- //
// ------------------------------------------------------- //

( // COMPOSITION
TempoClock.default.tempo = 1;
~composition = Ppar([
  Pseq([
    ~pulsar.intro,
    Ppar([
      ~pulsar.intro2,
      ~hihat.minimal,
      ~kick.intro,
    ]),
    Ppar([
      ~pulsar.smooth,
      ~kick.even,
      ~hihat.slash,
    ]),
    Ppar([
      ~pulsar.main,
      ~kick.main,
      ~hihat.main,
      ~snare.main,
    ]),
    Ppar([
      ~pulsar.outro,
      ~kick.outro,
    ]),
    ~kick.single,
  ]),
// ], 1).play;
], 1);
)

s.prepareForRecord;

( // RECORD
TempoClock.default.tempo = 1;
s.bind({
  ~composition.play;
  s.record;
})
)

s.stopRecording;

~composition.play;
~composition.stop;

// ------------------------------------------------------- //
// ---------------------- PHRASES ------------------------ //
// ------------------------------------------------------- //

( // PULSAR PHRASES
~pulsar = (
  intro: Pbind(*[
    instrument: \pulsar,
    fund: Pseq([41, 30.5]),
    randSeed: 150,
    maxPartial: 10,
    ampHz: 2,
    width: 0.5,
    dur: 4.00,
  ]),
  intro2: Pbind(*[
    instrument: \pulsar,
    fund: Pseq([50, 20]),
    randSeed: 150,
    maxPartial: 10,
    ampHz: 2,
    width: 0.5,
    dur: 4.00,
  ]),
  outro: Pbind(*[
    instrument: \pulsar,
    fund: Pseq([30.5, 41, 41.5, 42]),
    randSeed: 175,
    maxPartial: 10,
    ampHz: 2,
    width: 0.5,
    dur: 4.00,
  ]),
  main: Pbind(*[
    instrument: \pulsar,
    fund: Pseq([35, 20, 50, 41, 32, 33, 34, 35, 36]),
    randSeed: 150,
    maxPartial: Pfunc {|n| n * 0.7} <> Pkey(\fund),
    ampHz: Pfunc {|n| n * 10000} <> Pkey(\fund),
    width: 0.5,
    dur: 4.00,
  ]),
  smooth: Pbind(*[
    instrument: \pulsar,
    fund: Pseq([33, 21, 47]),
    randSeed: 150,
    maxPartial: 10,
    ampHz: 20000,
    width: 0.5,
    dur: 8.0,
  ]),
);
)

( // KICK PHRASES
~kick = (
  intro: Pbind(*[
    instrument: \kick,
    dur: Pseq([
      Rest(1),
      3,
      Rest(1),
      3,
    ]),
    amp: 0.85,
  ]),
  main: Pbind(*[
    instrument: \kick,
    dur: Pseq([
      1/4,       Rest(1/8), Rest(1/8), Rest(1/8), Rest(1/8), 1/4,     
      Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), 1/4,       Rest(1/8),
      Rest(1/8), Rest(1/8), 1/4,       1/4,       Rest(1/8), Rest(1/8),
      Rest(1/8), Rest(1/8), Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), Rest(1/8),
      Rest(1/8), Rest(1/8), 1/4,       1/4,       Rest(1/8), Rest(1/8),
      Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), 1/4,       Rest(1/8),
      1/4,       Rest(1/8), Rest(1/8), Rest(1/8), Rest(1/8), Rest(10/8),
    ], 5),
    amp: 0.8,
  ]),
  single: Pbind(*[
    instrument: \kick,
    dur: Pseq([ 4.0 ]),
    amp: 0.8,
    fundamental: 240,
  ]),
  even: Pbind(*[
    instrument: \kick,
    dur: Pseq([
      4.0,
      4.0,
      2.0, 2.0,
      4.0,
      2.0, 2.0,
    ]),
    amp: 0.75,
  ]),
  outro: Pbind(*[
    instrument: \kick,
    dur: Pseq([
      1/4,       Rest(1/8), Rest(1/8), Rest(1/8), Rest(1/8), 1/4,     
      Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), 1/4,       Rest(1/8),
      Rest(1/8), Rest(1/8), 1/4,       1/4,       Rest(1/8), Rest(1/8),
      Rest(1/8), Rest(1/8), 1/8, 1/4,  Rest(1/8), Rest(1/8), Rest(1/8),
      Rest(1/8), Rest(1/8), 1/4,       1/4,       Rest(1/8), Rest(1/8),
      Rest(1/8), 1/4,       Rest(1/8), 1/8, 1/4,  Rest(1/8),
      1/4,       Rest(1/8), Rest(1/8), Rest(1/8), Rest(1/8), Rest(10/8),
    ], 3),
    amp: 0.85,
  ]),
);
)

( // SNARE PHRASES
~snare = (
  main: Pbind(*[
    instrument: \neurosnare,
    dur: Pseq([
      1/4,       Rest(1/8), Rest(1/8), Rest(1/8), Rest(1/8), 1/4,     
      Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), 1/4,       Rest(1/8),
      Rest(1/8), Rest(1/8), 1/4,       1/4,       1/4,       Rest(1/8),
      Rest(1/8), Rest(1/8), Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), Rest(1/8),
      Rest(1/8), Rest(1/8), 1/4,       1/4,       Rest(1/8), Rest(1/8),
      Rest(1/8), 1/4,       Rest(1/8), Rest(1/8), 1/4,       Rest(1/8),
      1/4,       Rest(1/8), Rest(1/8), Rest(1/8), Rest(1/8), Rest(10/8),
    ], 5),
    att: 0.01,
    rel: 0.3,
    sinfreq: 42,
    ffreq: 20,
    amp: 0.35,
  ]),
);
)

( // HIHAT PHRASES
~hihat = (
  main: Pbind(*[
    instrument: \hihat,
    dur: Pseq([
      1/4,      1/8, 1/8, 1/8, 1/8, 1/4,     
      1/8, 1/4,      1/8, 1/8, 1/4,      1/8,
      1/8, 1/8, 1/4,      1/4,      1/8, 1/8,
      1/8, 1/8, 1/8, 1/4,      1/8, 1/8, 1/8,
      1/8, 1/8, 1/4,      1/4,      1/8, 1/8,
      1/8, 1/4,      1/8, 1/8, 1/4,      1/8,
      1/4,      1/8, 1/8, 1/8, 1/8, Rest(10/8),
    ], 5),
    att: 0.01,
    rel: 0.35,
    ffreq: 5100,
    amp: 0.4,
  ]),
  minimal: Pbind(*[
    instrument: \hihat,
    dur: Pseq([
      1/4, Rest(3/4),
      1/4, Rest(3/4),
      1/4, Rest(3/4),
      1/4, Rest(3/4),
    ], 2),
    att: 0.01,
    rel: 0.35,
    ffreq: 5100,
    amp: 0.4,
  ]),
  slash: Pbind(*[
    instrument: \hihat,
    dur: Pseq([
      1/4,      1/8, 1/8, 1/8, 1/8, 1/8, 1/8,
      1/8, 1/4,      1/8, 1/8, 1/8, 1/8, 1/8,
      1/8, 1/8, 1/4,      1/8, 1/8, 1/8, 1/8,
      1/8, 1/8, 1/8, 1/4,      1/8, 1/8, 1/8,
      1/8, 1/8, 1/8, 1/8, 1/4,      1/8, 1/8,
      1/8, 1/8, 1/8, 1/8, 1/8, 1/4,      1/8,
      1/8, 1/8, 1/8, 1/8, 1/8, 1/8, Rest(10/8),
    ], 3),
    att: 0.01,
    rel: 0.35,
    ffreq: 5100,
    amp: 0.4,
  ]),
);
)

// ------------------------------------------------------- //
// ----------------------- SYNTHS ------------------------ //
// ------------------------------------------------------- //

( // KICK
SynthDef(\kick, {
  arg fundamental = 240,
      click_attack = 0.0001,
      click_release = 0.03,
      click_dur = 0.01,
      click_amp = 0.3,
      click_start_ratio = 3,
      click_end_ratio = 2,
      bass_attack = 0.0001,
      bass_release = 0.8,
      bass_dur = 0.045,
      bass_amp = 0.8,
      bass_start_ratio = 1,
      bass_end_ratio = 0.125;

  var click, clickEnv, bass, bassEnv, signal;
  var ratio_calc, hi, lo, freq_i_want, frequency, start, end, ratio_thing;
  var bass_freq, ratio_modifier, start_freq, end_freq;

  frequency = fundamental / (bass_start_ratio - bass_end_ratio);
  ratio_modifier = (bass_start_ratio + bass_end_ratio) * 2;
  start_freq = frequency * bass_start_ratio * ratio_modifier;
  end_freq = frequency * bass_end_ratio * ratio_modifier;

  clickEnv = Env.perc(
    attackTime: click_attack,
    releaseTime: click_release,
    curve: \lin
  ).ar;

  click = SinOsc.ar(
    freq: XLine.ar(
      start: fundamental * click_start_ratio,
      end: fundamental * click_end_ratio,
      dur: click_dur,
      mul: click_amp,
    ),
    mul: click_amp,
  );

  bassEnv = Env.perc(
    attackTime: bass_attack,
    releaseTime: bass_release,
    curve: \lin
  ).delay(0.005).ar(2);

  bass = SinOsc.ar(
    freq: XLine.ar(
      start: start_freq,
      end: end_freq,
      dur: bass_dur,
      mul: bass_amp,
    ),
    mul: bass_amp,
  );

  signal = (click * clickEnv) + (bass * bassEnv);
  signal = Pan2.ar(
    in: signal,
    pos: \pan.kr(0),
    level: \amp.kr(0.1)
  );

  Out.ar(\out.kr(0), signal);
}).add;
)

( // HIHAT
SynthDef(\hihat, {
  arg attack = 0.01,
      release = 0.2,
      ffreq = 6000;

  var envelope, signal;
  envelope = Env.perc(attack, release).kr(doneAction: Done.freeSelf);
  signal = HPF.ar(
    in: WhiteNoise.ar,
    freq: ffreq,
    mul: envelope,
  );
  signal = Pan2.ar(signal, \pan.kr(0), \amp.kr(0.5));

  Out.ar(\out.kr(0), signal);
}).add;
)

( // SNARE
// credit: https://sccode.org/1-57f
SynthDef(\neurosnare, {
    var snd;
    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    snd = snd + (SinOsc.ar(Env([400, 196, 160], [0.04, 0.2], \exp).ar) * Env.perc(0.04, 0.2).ar * 6.dbamp).tanh;
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3), 300) * Env.perc(0.05, 0.4).delay(0.01).ar(2) * -3.dbamp);
    snd = snd + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
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
  dur = 1;

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
      times:       [0.8, (dur - 0.9), 0.1],
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
  // sig1 = Pulse.ar(freq1, noteWidth, amp1 * phraseEnv);
  // sig2 = Pulse.ar(freq2, noteWidth, amp2 * phraseEnv);
  // sig3 = Pulse.ar(freq3, noteWidth, amp3 * phraseEnv);
  // sig4 = Pulse.ar(freq4, noteWidth, amp4 * phraseEnv);
  sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
  sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
  sig3 = FreeVerb.ar(sig3, 0.7, 0.8, 0.25);
  sig4 = FreeVerb.ar(sig4, 0.7, 0.8, 0.25);

  sig1 = Pan2.ar(sig1, SinOsc.kr(SinOsc.kr(0.1, 0).range(1, 2), pi), phraseEnv);
  out2 = Pan2.ar(sig2, SinOsc.kr(SinOsc.kr(0.1, pi).range(1, 2), 0), phraseEnv);
  out3 = Pan2.ar(sig3, SinOsc.kr(SinOsc.kr(0.01, 0).range(0.1, 0.3), pi),phraseEnv);
  out4 = Pan2.ar(sig4, SinOsc.kr(SinOsc.kr(0.01, pi).range(0.1, 0.3), 0), phraseEnv);

  // sig1 = Pan2.ar(sig1, SinOsc.kr(SinOsc.kr(0.1, 0).range(1, 2), pi));
  // out2 = Pan2.ar(sig2, SinOsc.kr(SinOsc.kr(0.1, pi).range(1, 2), 0));
  // out3 = Pan2.ar(sig3, SinOsc.kr(SinOsc.kr(0.01, 0).range(0.1, 0.3), pi));
  // out4 = Pan2.ar(sig4, SinOsc.kr(SinOsc.kr(0.01, pi).range(0.1, 0.3), 0));

  Out.ar(0, sig1);
  Out.ar(0, out2);
  Out.ar(0, out3);
  Out.ar(0, out4);
}).add;
)
