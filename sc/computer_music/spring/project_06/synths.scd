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
synths[\list].add(\fm2);


SynthDef.new(\chord3cents, {
  arg f1 = 440, cents = 100, dur = 1, amp = 1;
  var alist, tlist, envShape, env, signal, tones, k, f2, f3;

  k = 1200 / log10(2);  // constant to convert between cents and hertz
  m = 10.pow(cents/k);  // multiple to change frequency by cents
  f2 = f1 * m;  // calculate f2 from f1
  f3 = f2 * m;  // calculate f3 from f2

  alist = [0, 0.9, 0.75, 0.5, 0];  // create the envelope
  tlist = [0.01, 0.25, 0.7, 0.04].normalizeSum;
  envShape = Env.new(alist, tlist);
  env = EnvGen.ar(envShape, timeScale: dur, doneAction: 2);

  tones = [f1, f2, f3]; // list of frequencies to add together
  amp = amp / tones.size;  // all frequencies have the same amplitude
  signal = Mix.fill(tones.size, { |i|
    SinOsc.ar(tones[i], mul: amp);
  });

  signal = env * signal;
  signal = Pan2.ar(signal, \pan.kr(0));
  Out.ar(0, signal);
}).add;

// SynthDef.new(\chord3cents, {
//   arg f1 = 440, cents = 100, dur = 1, amp = 1 ;
//   var ntones = 3, alist, tlist, envShape, env, signal, tones, k ;

//   k = 1200 / log10(2) ;  // constant for conversion between cents and hertz
//   m = 10.pow(cents/k) ;  // multiple for distance between frequencies
//   // tones = ntones.collect({ arg i; f1 * m.pow(i) }) ; // make a list of the frequencies
//   tones = ntones collect: f1 * m.pow(_); // make a list of the frequencies

//   // create an envelope for the tones
//   alist = [0, 0.9, 0.75, 0.5, 0] ;
//   tlist = [0.01, 0.25, 0.7, 0.04].normalizeSum ;
//   envShape = Env.new(alist, tlist) ;
//   env = EnvGen.ar(envShape, timeScale: dur, doneAction: 2) ;

//   // create each frequency and sum them together
//   amp = amp / tones.size ;  // equal amplitude for all frequencies
//   signal = Mix.ar(tones collect: SinOsc.ar(_, mul: amp));

//   signal = env * signal ; // apply  the envelope
//   signal = Pan2.ar(signal, 0) ;  // set pan location
//   Out.ar(0, signal) ;
// }).add;

SynthDef.new(\chord7cents,
	{
		arg f1 = 440, cents = 100, dur = 1, amp = 1 ;
		var ntones = 7, alist, tlist, envShape, env, signal, tones, k ;
		var srate = 44100, nyquist = srate / 2 ;

		k = 1200 / log10(2) ;  // constant for conversion between cents and hertz
		m = 10.pow(cents/k) ;  // multiple for distance between frequencies
		tones = ntones.collect({ arg i; f1 * m.pow(i) }) ; // make a list of the frequencies

		// create an envelope for the tones
		alist = [0, 0.9, 0.75, 0.5, 0] ;
		tlist = [0.01, 0.25, 0.7, 0.04].normalizeSum ;
		envShape = Env.new(alist, tlist) ;
		env = EnvGen.ar(envShape, timeScale: dur, doneAction: 2) ;

		// create each frequency and sum them together
		amp = amp / tones.size ;  // equal amplitude for all frequencies
		signal = Mix.fill(tones.size, {  arg i ; SinOsc.ar(tones[i], mul: amp) ;});

		signal = env * signal ; // apply  the envelope
		signal = Pan2.ar(signal, 0) ;
		Out.ar(0, signal) ;
	}
).add ;

SynthDef.new(\chord7range,
	{
		arg f1 = 440,  dur = 1, amp = 1, span = 1200 ;
		var ntones = 7, cents, alist, tlist, envShape, env, signal, tones, k ;

		cents = span / (ntones - 1) ; // distance between each tone in cents

		k = 1200 / log10(2) ;  // constant for conversion between cents and hertz
		m = 10.pow(cents/k) ;  // multiple for distance between frequencies
		tones = ntones.collect({ arg i; f1 * m.pow(i) }) ; // make a list of the frequencies

		// create an envelope for the tones
		alist = [0, 0.9, 0.75, 0.5, 0] ;
		tlist = [0.01, 0.25, 0.8, 1.0].normalizeSum ;
		envShape = Env.new(alist, tlist) ;
		env = EnvGen.ar(envShape, timeScale: dur, doneAction: 2) ;

		// create each frequency and sum them together
		amp = amp / tones.size ;  // equal amplitude for all frequencies
		signal = Mix.fill(tones.size, {  arg i ; SinOsc.ar(tones[i], mul: amp) ;});

		signal = env * signal ; // apply  the envelope
		signal = Pan2.ar(signal, 0) ;
		Out.ar(0, signal) ;
	}
).add ;

SynthDef.new(\chord7env,
	{
		arg freq = 440,  dur = 1, amp = 1, range = 1200 ;
		var nFreqs = 7, cents, env, signal, flist, k, m ;
		var tinc ;

		cents = range / nFreqs ; // distance between each tone in cents

		k = 1200 / log10(2) ;  // constant for conversion between cents and hertz
		m = 10.pow(cents/k) ;  // multiple for distance between frequencies
		flist = nFreqs.collect({ arg i; freq * m.pow(i) }) ; // make a list of the frequencies

		// create each frequency and its envelope, and sum all together
		amp = amp / nFreqs ;  // equal amplitude for all frequencies
		tinc = 1.0 / ( nFreqs + 1 ) ;  // increment difference between peaks
		signal = Mix.fill(nFreqs,
			{
				arg i, peakT, env, eShape ;
				peakT = (i+1) * tinc ; // current peak time
				eShape = Env.new([0,1,0], [peakT, 1-peakT]) ;
				env = EnvGen.ar(eShape, timeScale: dur, doneAction: 2) ;
				env * SinOsc.ar(flist[i], mul: amp) ;
			}
		);

		signal = Pan2.ar(signal, \pan.kr(0)) ;
		Out.ar(0, signal) ;

	}
).add ;

SynthDef.new(\bands2,
	{
		arg f1 = 440,  f2 = 660, dur = 1, amp1 = 0.5, amp2 = 0.5, range1 = 1200, range2 = 600 ;
		var nFreqs = 7, nFreqs2 = 10, cents, env, band1, band2, flist1, k, m, flist2 ;
		var tlist, tinc, mix1, mix2, mixShape, signal, cents2, amp ;

		k = 1200 / log10(2) ;  // constant for conversion between cents and hertz

		// create frequency list for 1st band
		cents = range1 / nFreqs ; // distance between each tone in cents
		m = 10.pow(cents/k) ;  // multiple for distance between frequencies
		flist1 = nFreqs.collect({ arg i; f1 * m.pow(i) }) ; // make a list of the frequencies

		// create frequency list for 2nd band
		cents = range2 / nFreqs2 ;
		m = 10.pow(cents/k) ;
		flist2 = nFreqs2.collect({ arg i ; f2 * m.pow(i) }) ;

		// create the first band of frequencies
		amp = amp1 / nFreqs ;  // equal amplitude for all frequencies
		tinc = 1.0 / ( nFreqs + 1 ) ;  // increment difference between peaks
		band1 = Mix.fill(nFreqs,
			{
				arg i, peakT, env, eShape ;
				peakT = (i+1) * tinc ; // current peak time
				eShape = Env.new([0,1,0], [peakT, 1-peakT]) ;
				env = EnvGen.ar(eShape, timeScale: dur, doneAction: 2) ;
				env * SinOsc.ar(flist1[i], mul: amp) ;
			}
		);

		// create the second band of frequencies
		amp = amp2 / nFreqs2 ;  // equal amplitude for all frequencies
		tinc = 1.0 / ( nFreqs2 + 1 ) ;  // increment difference between peaks
		band2 = Mix.fill(nFreqs2,
			{
				arg i, peakT, env, eShape ;
				peakT = (i+1) * tinc ; // current peak time
				eShape = Env.new([0,1,0], [peakT, 1-peakT]) ;
				env = EnvGen.ar(eShape, timeScale: dur, doneAction: 2) ;
				env * SinOsc.ar(flist2[i], mul: amp) ;
			}
		);

		// create the envelope shapes for the final mix
		tlist = [1/5, 1/5, 1/5, 1/5, 1/5] ;
		mixShape = Env.new([0, 1, 0, 1, 0, 1], tlist) ;
		// mixShape = Env.new([0, 1, 0, 1, 0, 1], [1/5, 1/5, 1/5, 1/5, 1/5]) ;
		mix1 = EnvGen.ar(mixShape, timeScale: dur) ;
		mixShape = Env.new([1, 0, 1, 0, 1, 0], tlist) ;
		//mixShape = Env.new([1, 0, 1, 0, 1], [1/4, 1/4, 1/4, 1/4]) ;
		mix2 = EnvGen.ar(mixShape, timeScale: dur) ;

		// mix the two bands together and send to output
		signal = (mix1 * band1) + (mix2 * band2) ;
		signal = Pan2.ar(signal, \pan.kr(0)) ;
		Out.ar(0, signal) ;

	}
).add ;



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

SynthDef(\echo, { arg out=0, maxdtime=0.2, dtime=0.2, decay=2, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    in = CombL.ar(
      in: in * env,
      maxdelaytime: maxdtime,
      delaytime: dtime,
      decaytime: decay,
      mul: 1,
      add: in,
    );
    XOut.ar(out, env, in);
}, [\ir, \ir, 0.1, 0.1, 0]).add;

synths
)
