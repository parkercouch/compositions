Pulsar {
  var name = "dynPulsar", fundamental = 50, seed, playing;

  *new {|name, fundamental, seed|
    // If we don't care about a seed then randomly generate one
    // to keep each play random
    if (seed == nil) {seed = rrand(1, 1000)}
    ^super.newCopyArgs(name, fundamental, seed)
  }

  updateSynthDef {
    var nameSymbol = name.asSymbol;

    SynthDef(nameSymbol, {
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

      // inputs.do {|input|
      //   Out.ar(0, ~stuff.value(input));
      // };
    }).add;

    ^nameSymbol
  }

  updateSynthDefDRY {
    var nameSymbol = name.asSymbol;

    SynthDef(nameSymbol, {
      arg ampHz = 4,
      fund = 40,
      maxPartial = 4,
      width = 0.5,
      randSeed,
      id = 1,
      gate = 1,
      dur = 1,
      inputs = 10,
      attack = 0.8,
      decay = (dur - 0.9),
      release = 0.1;

      var amp1, amp2, sig1, sig2, freq1, freq2, out1, out2;
      var freq3, freq4, out3, out4, sig3, sig4, amp3, amp4;
      var fundamental, noteWidth;
      var phraseEnv;
      var signal;
      var allSignals;

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


      signal = {
        arg i;

        var x, y;
        var z, zz;
        var aa, bb, cc;
        var sig1, amp1, freq1;

        // Not sure what this is
        x = 0.5 * (1/i); 
        // Or this
        y = 8 - (i*2);

        z = (i%2) * pi;
        zz = (0.1) / (10 ** (i/2).round(1));

        aa = 1 / (10 ** (i/2).round(1));
        bb = 2 / (10 ** (i/2).round(1));
        cc = pi * (i%2);

        amp1 = LFPulse.kr(ampHz, x, 0.12) * 0.75;
        freq1 = LFNoise0.kr(4).exprange(fundamental, fundamental * maxPartial).round(fundamental);
        freq1 = freq1 * (LFPulse.kr(y)+1);

        sig1 = Pulse.ar(freq1, noteWidth, amp1);
        sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);

        sig1 = Pan2.ar(sig1, SinOsc.kr(SinOsc.kr(zz, z).range(aa, bb), cc), phraseEnv);
        // sig1
      };


      allSignals = Array.series(0, inputs).collect({|n, i|
        signal.value(i)
      });

      Out.ar(0, allSignals);

      // inputs.do {|input, index|
      //   Out.ar(0, signal.value(index));
      // };

      // Out.ar(0, (0..inputs) collect: {|n, i|
      //   signal.value(i)
      // })

      // inputs.do {|input, index|
      //   Out.ar(0, signal.value(
      //     // ampHz: ampHz,
      //     // fundamental: fundamental,
      //     // noteWidth: noteWidth,
      //     // n: input,
      //     i: index,
      //     // dur: dur,
      //     // gate: gate,
      //     // maxPartial: maxPartial,
      //   ));
      // };
    }).add;

    ^nameSymbol
  }

  createSignal {
    arg ampHz, fundamental, noteWidth,
        n, i,
        dur,
        maxPartial,
        gate = 1;

    var x, y;
    var z, zz;
    var aa, bb, cc;
    var phraseEnv;
    var sig1, amp1, freq1;

    // Not sure what this is
    x = 0.5 * (1/i); 
    // Or this
    y = 8 - (i*2);

    z = (i%2) * pi;
    zz = (0.1) / (10 ** (i/2).round(1));

    aa = 1 / (10 ** (i/2).round(1));
    bb = 2 / (10 ** (i/2).round(1));
    cc = pi * (i%2);

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

    amp1 = LFPulse.kr(ampHz, x, 0.12) * 0.75;
    freq1 = LFNoise0.kr(4).exprange(fundamental, fundamental * maxPartial).round(fundamental);
    freq1 = freq1 * (LFPulse.kr(y)+1);

    sig1 = Pulse.ar(freq1, noteWidth, amp1);
    sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);

    sig1 = Pan2.ar(sig1, SinOsc.kr(SinOsc.kr(zz, z).range(aa, bb), cc), phraseEnv);

    sig1
  }

  play {
    playing = {
      arg ampHz = 4,
      fund = 40,
      maxPartial = 4,
      width = 0.5,
      randSeed,
      id = 1;

      var amp1, amp2, sig1, sig2, freq1, freq2, out1, out2;
      var freq3, freq4, out3, out4, sig3, sig4, amp3, amp4;

      RandID.ir(id);
      RandSeed.ir(1, randSeed);

      amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
      amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
      amp3 = LFPulse.kr(ampHz, 0.25, 0.12) * 0.75;
      amp4 = LFPulse.kr(ampHz, 0.125, 0.12) * 0.75;
      freq1 = LFNoise0.kr(4).exprange(fund, fund * maxPartial).round(fund);
      freq2 = LFNoise0.kr(4).exprange(fund, fund * maxPartial).round(fund);
      freq3 = LFNoise0.kr(4).exprange(fund, fund * maxPartial).round(fund);
      freq4 = LFNoise0.kr(4).exprange(fund, fund * maxPartial).round(fund);
      freq1 = freq1 * (LFPulse.kr(8)+1);
      freq2 = freq2 * (LFPulse.kr(6)+1);
      freq3 = freq3 * (LFPulse.kr(4)+1);
      freq4 = freq4 * (LFPulse.kr(2)+1);

      sig1 = Pulse.ar(freq1, width, amp1);
      sig2 = Pulse.ar(freq2, width, amp2);
      sig3 = Pulse.ar(freq3, width, amp3);
      sig4 = Pulse.ar(freq4, width, amp4);
      sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
      sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
      sig3 = FreeVerb.ar(sig3, 0.7, 0.8, 0.25);
      sig4 = FreeVerb.ar(sig4, 0.7, 0.8, 0.25);

      out1 = Pan2.ar(sig1, SinOsc.kr(SinOsc.kr(0.1, 0).range(1, 2), pi));
      out2 = Pan2.ar(sig2, SinOsc.kr(SinOsc.kr(0.1, pi).range(1, 2), 0));
      out3 = Pan2.ar(sig3, SinOsc.kr(SinOsc.kr(0.01, 0).range(0.1, 0.3), pi));
      out4 = Pan2.ar(sig4, SinOsc.kr(SinOsc.kr(0.01, pi).range(0.1, 0.3), 0));

      Out.ar(0, out1);
      Out.ar(0, out2);
      Out.ar(0, out3);
      Out.ar(0, out4);

    }.play(args: [
      \fund, fundamental,
      \randSeed, seed,
      \maxPartial, 10,
      \ampHz, 2,
      \width, 0.5,
    ]);
  }

  set {|key, value|
    playing.set(key, value);
  }

  stop {
    playing.free;
  }
}
