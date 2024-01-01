// ----------------------------------------------------------------- //
// ------------------------- Patterns ------------------------------ //
// ----------------------------------------------------------------- //

(
var synths = "./synths.scd".loadRelative[0];
var misc = "./misc.scd".loadRelative[0];

var patterns = IdentityDictionary();
patterns[\generators] = IdentityDictionary();

~spread = {|seq=(~left), time_diff=0.5, scale_diff=1, layers=4|
  var pairs = (0..layers) collect: {|i|
    [i*time_diff, seq.(i*scale_diff)] 
  };
  // Ptpar expects a flat array instead of array of arrays
  var flattened = pairs.reshape(layers*2);

  Ptpar(flattened, 1)
};
patterns[\spread] = ~spread;

~blah = {
  arg scale = 2.9,
      length = inf;

  Pbind(*[
    instrument: \bands2,
    f1:     Pseq([  20,  ]*scale, inf),
    range1: Pseq([1000, ], inf),
    f2:     Pseq([ 280, ]*scale, inf),
    range2: Pseq([[3000, 2000, 1000], ], inf),
    dur:    Pseq([ 0.1, 0.1, 0.1, 0.2, 0.5, 1], inf),
    amp1: 0.8,
    amp2: 0.8,
    length: Pseq([0], length),
  ])
};
patterns[\blah] = ~blah;

~piercing = {
  arg scale  = 2.9,
      length = inf;

  Pbind(*[
    instrument: \bands2,
    f1:     Pseq([  500, 402 ]*scale, inf),
    range1: Pseq([10000, ], inf),
    f2:     Pseq([ 2800, 200 ]*scale, inf),
    range2: Pseq([[3000, 2000, 1000, 500], [10000, 303]], inf),
    dur:    Pseq([ Pn(0.1,4), 0.1, 2.1, 0.2, 0.5, 1].reverse, inf),
    amp1:   Pseq([ Pn(0.2,4), 0.05, 0.8, 0.3, 0.5, 1], inf),
    amp2:   Pseq([ Pn(0.2,4), 0.05, 0.8, 0.3, 0.5, 1].reverse, inf),
    length: Pseq([0], length),
  ])
};

~basic = {
  arg scale = 2.9,
      length = inf;

  Pbind(*[
    instrument: \default,
    freq: Pseq([100, 150], inf),
    dur:  Pseq([ 0.1, 0.1, 0.1, 0.2, 0.5, 1], inf),
    amp: 0.8,
    length: Pseq([0], length),
  ])
};

patterns[\piercing] = ~piercing;

patterns
)
