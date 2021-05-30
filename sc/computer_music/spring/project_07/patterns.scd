// ----------------------------------------------------------------- //
// ------------------------- Patterns ------------------------------ //
// ----------------------------------------------------------------- //

(
var synths = "./synths.scd".loadRelative[0];
var misc = "./misc.scd".loadRelative[0];

var patterns = IdentityDictionary();
patterns[\generators] = IdentityDictionary();

~phrase = {|scale = 1, amp = (misc[\dynamics][\mf]), length = 1, sync=1, legato=0.5, octave=3|
  var s=0.1, m=0.7, l=1.3;

  Pbind(*[
    instrument: \sawpulse,
    // instrument: \default,
  // PmonoArtic(*[
    // \sawpulse,
    // \default,
    legato: legato,
    octave: octave,
    scale: misc[\scales][\et53],
    rq: 0.5,
    ffreq: 3000,
    freqlag: 0.1,
    degree: Pseq([ 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13]*scale, length),
    // degree: Pseq([20, 21, 22, 23,  5,  6,  7,  8,  9, 40, 41, 42, 43]*scale, length),
    dur:    Pseq([ s,  s,  m,  s,  l,  l,  m,  s,  l,  m,  m,  s,  l]*sync, length),
    amp: amp,
  ])
};
patterns[\phrase] = ~phrase;

~spread = {|seq=(~phrase), time_diff=0.5, scale_diff=1, layers=4|
  var pairs = (0..layers) collect: {|i|
    [i*time_diff, seq.(i*scale_diff)] 
  };
  // Ptpar expects a flat array instead of array of arrays
  var flattened = pairs.reshape(layers*2);

  Ptpar(flattened, 1)
};
patterns[\spread] = ~spread;

patterns
)
