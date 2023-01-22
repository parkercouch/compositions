P3Call : Pattern {
  var pattern, options;

  *new {
    arg options = P3Options.new;
    var pattern;

    pattern = Pseq([
      Pbind(*[
        instrument: options.instrument,
        scale: options.scale,
        octave: options.octave,
        degree: options.melody,
        dur: options.rhythm,
        amp: options.amp,
        pan: options.pan,
      ]),
    ]);

    ^super.newCopyArgs(pattern, options)
  }

  storeArgs { ^[pattern, options] }

  embedInStream {|inevent|
    ^pattern.embedInStream(inevent)
  }
} 
