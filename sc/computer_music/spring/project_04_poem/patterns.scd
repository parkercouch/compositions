// ----------------------------------------------------------------- //
// ------------------------- Patterns ------------------------------ //
// ----------------------------------------------------------------- //

(
var synths = "./synths.scd".loadRelative[0];
var misc = "./misc.scd".loadRelative[0];

var patterns = IdentityDictionary();
patterns[\generators] = IdentityDictionary();

~line = {
  arg length      = 1,
      root        = 3,
      scale       = misc[\scales][\et53],
      amp         = 0.5,
      synth       = \sawpulse,
      octave      = [2,3],
      map_degrees = {|n| n},
      dur         = 0.2,
      line        = "i am here";

  Ppar([
    Pbind(*[
      instrument: synth,
      octave: octave,
      root: root,
      scale: scale,
      legato: 5,
      degree: Pseq(line.ascii collect: map_degrees, 1),
      dur: dur,
      amp: amp,
    ]),
    Pbind(*[
      instrument: \presence,
      octave: 0,
      root: root,
      scale: misc[\scales][\et19],
      degree: line.ascii,
      dur: Pxrand([50,70,20], 1),
      amp: amp/2,
      print: Pfunc({line.postln}),
    ]),
  ], length)
};

~poem = {|poem, length=1|
  var lines = poem collect: {|n|
    var line, root, octave, dur;
    # line, root, octave, dur = n;
    ~line.(root: root, line: line, dur: dur, octave: octave)
  };

  Pseq(lines, length)
};

patterns[\generators][\poem] = ~poem;
patterns[\generators][\line] = ~line;

patterns
)
