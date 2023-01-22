( // SYNTHS
var synths = "../../lib/synths.scd".load;

SynthDef(\sawpulseCopy, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
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
synths[\list].add(\sawpulseCopy);

SynthDef(\HPF, { arg out=0, gate=1, freq=100, rq=1.0, amp=0.5;
    var env, snd;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    snd = In.ar(out, 2);
    snd = GlitchHPF.ar(snd, freq, rq);
    XOut.ar(out, env, snd*amp);
}, [\ir, 0, 100, 1.0, 0.5]).add;
synths[\list].add(\HPF);

synths
)
