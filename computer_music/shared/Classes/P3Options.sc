P3Options {
  var <>instrument,
      <>length,
      <>scale,
      <>octave,
      <>melody,
      <>rhythm,
      <>amp,
      <>pan;

  *new {
    ^super.newCopyArgs(
      \default,
      10,
      Scale.minor,
      3,
      Pseq([1,3,5,7]),
      Pseq([0.5, 0.5, 0.5, 1], inf),
      0.5,
      0,
    )
  }
} 
