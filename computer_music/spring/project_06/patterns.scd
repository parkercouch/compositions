// ----------------------------------------------------------------- //
// ------------------------- Patterns ------------------------------ //
// ----------------------------------------------------------------- //

(
var synths = "./synths.scd".loadRelative[0];
var misc = "./misc.scd".loadRelative[0];

var patterns = IdentityDictionary();
patterns[\generators] = IdentityDictionary();

~left = {|scale = 1|
  Pbind(*[
    instrument: \chord7env,
    freq:  Pseq([430,  210, 100,  30,   40, 20]*scale, 1),
    range: Pseq([100, 1000,  50, 100, 1000, 50], 1),
    dur:   Pseq([ 11,    5,  40,  12,   17,  5], 1),
    delta: 3.34,
    pan: -1,
    amp: 0.5,
  ])
};
patterns[\left] = ~left;

~right = {|scale=1|
  Pbind(*[
    instrument: \bands2,
    f1:     Pseq([440,  220, 110,  40,   20, 10]*scale, 1),
    range1: Pseq([100, 1000,  50, 100, 1000, 50], 1),
    f2:     Pseq([540,  320, 210,  70,   40, 15]*scale, 1),
    range2: Pseq([100, 1000,  50, 100, 1000, 50], 1),
    dur:    Pseq([ 10,   20,  10,  20,   10, 22], 1),
    delta: 2.23,
    pan: 1,
    amp: 0.2,
  ])
};
patterns[\right] = ~right;

~spread = {|seq=(~left), time_diff=0.5, scale_diff=1, layers=4|
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
