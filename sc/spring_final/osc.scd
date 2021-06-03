// ----------------------------------------------------------------- //
// ---------------------------- Osc -------------------------------- //
// ----------------------------------------------------------------- //

(
var patterns = "./patterns.scd".loadRelative[0];

var osc = IdentityDictionary();
osc[\list] = Set();
osc[\functions] = IdentityDictionary();

OSCdef(\ding, {|msg, time, addr, recvPort|
  var scale;
  [msg, time, addr, recvPort].postln;

  // Extract optional scale parameter from message
  if (msg[1].isNumber) {scale = msg[1]} {scale = 1};

  {
    Pulse.ar(10 * scale, rrand(0.01,0.5), 0.3)
    * Env.perc.ar(doneAction:2)
    !2
  }.play
}, '/ding');

osc[\list].add(\ding);

OSCdef(\blah, {|msg, time, addr, recvPort|
  var scale, length;
  [msg, time, addr, recvPort].postln;

  // Extract optional parameters from message
  if (msg[1].isNumber) {scale = msg[1]} {scale = 1};
  if (msg[2].isNumber) {length = msg[2]} {length = 20};

  patterns[\blah].(scale, length).play(clock: TempoClock(120/60))
}, '/blah');

osc[\list].add(\blah);

OSCdef(\piercing, {|msg, time, addr, recvPort|
  var scale, length;
  [msg, time, addr, recvPort].postln;

  // Extract optional parameters from message
  if (msg[1].isNumber) {scale = msg[1]} {scale = 1};
  if (msg[2].isNumber) {length = msg[2]} {length = 20};

  patterns[\piercing].(scale, length).play(clock: TempoClock(120/60))
}, '/piercing');

osc[\list].add(\piercing);

osc
)
