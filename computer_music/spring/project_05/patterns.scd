// ----------------------------------------------------------------- //
// ------------------------- Patterns ------------------------------ //
// ----------------------------------------------------------------- //

(
var synths = "./synths.scd".loadRelative[0];
var misc = "./misc.scd".loadRelative[0];

var patterns = IdentityDictionary();
patterns[\generators] = IdentityDictionary();

~phrase = {
  arg length      = 1,
      root        = 3,
      scale       = misc[\scales][\wcAlpha],
      amp         = 0.25,
      synth       = \sawpulse,
      octave      = [2,3],
      map_degrees = {|n| n},
      dur         = 1,
      legato      = 0.5,
      seq         = {[19,17,10,20,15,13,12,14,11,18,16]};

  Ppar([
    PmonoArtic(*[
      synth,
      octave: octave,
      root: root,
      scale: scale,
      legato: legato,
      degree: Pseq(seq.value collect: map_degrees, 1),
      dur: dur,
      amp: amp,
    ]),
  ], length)
};

patterns[\phrase] = ~phrase;
patterns[\generators][\phrase] = ~phrase;

patterns
)
