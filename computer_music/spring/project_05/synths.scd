// ----------------------------------------------------------------- //
// -------------------------- Synths ------------------------------- //
// ----------------------------------------------------------------- //

(
var synths = IdentityDictionary();
synths[\list] = Set();
synths[\functions] = IdentityDictionary();

// From sccode.org
SynthDef(\sawpulse, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
  var sig, plfo, fcurve;
  plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
  freq = Lag.kr(freq, freqlag) * plfo;
  fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
  fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
  sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
  sig = RLPF.ar(sig, fcurve, rq)
  * EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction: Done.freeSelf)
  * amp;
  Out.ar(out, sig ! 2)
}).add;
synths[\list].add(\sawpulse);

~voices = 10;
~chord = { |range = 1.0|
    ~voices collect: { exprand(180 / range, 260 * range) }
};
SynthDef(\presence, {
  arg distort_ratio = 1.4,
      lo = 1,
      hi = 1;

  var env, snd, chord;

  env = EnvGen.kr(
    envelope: Env.adsr(15, \decay.kr(10), 1, 10, curve: \sine),
    gate: \gate.kr(1),
    doneAction: Done.freeSelf,
  );

  chord = \freq.kr(~chord.value, \lag.kr(10));

  snd = chord collect: { |f|
    f = f * LFNoise2.kr( rrand(0.3, 0.8) ).exprange(lo, hi);
    BLowPass.ar(SinOsc.ar(f), f, 0.6);
  };

  snd = (snd * distort_ratio).clip(-1, 1);

  snd = Splay.ar(snd, \splay.kr(0.8)) * env * \amp.kr(0.5);
  Out.ar(0, snd);
}).add;
synths[\list].add(\presence);

SynthDef(\LPF, { arg out=0, gate=1, freq=1000, rq=1.0, amp=0.5;
    var env, snd;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    snd = In.ar(out, 2);
    snd = RLPF.ar(snd, freq, rq);
    XOut.ar(out, env, snd*amp);
}, [\ir, 0, 1000, 1.0, 0.5]).add;
synths[\list].add(\LPF);

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
synths[\list].add(\limiter);

~limiter = {|pattern, limit=0.5|
    Pgroup(Pfx(pattern, \limiter, *[
      thresh: limit,
      slopeBelow: 2.0,
      slopeAbove: 1.0,
      clampTime: 1.01,
      relaxTime: 1.1,
    ]))
};

synths[\functions][\limiter] = ~limiter;

synths
)
