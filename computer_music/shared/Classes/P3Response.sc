P3Response : Pattern {
  var pattern, options;

  *new {
    arg options = P3Options.new;
    var pattern;

    pattern = Pseq([
      Pbind(*[
        instrument: options.instrument,
        scale: options.scale,
        octave: options.octave + 1,
        degree: Pfunc({|n|
          [ n, [n-1,Rest(),n+1].choose ]
        }) <> options.melody,
        dur: Pfunc({|d|
          var skew = rrand(0.08, 0.12);
          [d-skew, d, d+skew].choose.max(0.05)
        }) <> options.rhythm,
        amp: options.amp,
        pan: -1*options.pan,
      ]),
    ]);

    ^super.newCopyArgs(pattern, options)
  }

  storeArgs { ^[pattern, options] }

  embedInStream {|inevent|
    ^pattern.embedInStream(inevent)
  }
} 
