Pulsar {
  var fundamental = 50, seed, playing;

  *new {|fundamental, seed|
    // If we don't care about a seed then randomly generate one
    // to keep each play random
    if (seed == nil) {seed = rrand(1, 1000)}
    ^super.newCopyArgs(fundamental, seed)
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
