RestFor : Pattern {
  var beats;

  *new {|beats|
    ^super.newCopyArgs(beats)
  }

  storeArgs { ^[beats] }

  embedInStream {|inevent|
    ^Pbind(*[dur: Pn(Rest(beats), 1)]).embedInStream(inevent)
  }
} 
