// ----------------------------------------------------------------- //
// ---------------------------- Osc -------------------------------- //
// ----------------------------------------------------------------- //

(
var patterns = "./patterns.scd".loadRelative[0];
var misc = "./misc.scd".loadRelative[0];

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

  // TODO: use global tempo or pass it in?
  patterns[\blah].(scale, length).play(clock: TempoClock(120/60))
}, '/blah');

osc[\list].add(\blah);

OSCdef(\piercing, {|msg, time, addr, recvPort|
  var scale, length;
  [msg, time, addr, recvPort].postln;

  // Extract optional parameters from message
  if (msg[1].isNumber) {scale = msg[1]} {scale = 1};
  if (msg[2].isNumber) {length = msg[2]} {length = 20};

  // TODO: use global tempo or pass it in?
  patterns[\piercing].(scale, length).play(clock: TempoClock(120/60))
}, '/piercing');

osc[\list].add(\piercing);

OSCdef(\continue, {|msg, time, addr, recvPort|
  var seed, other;
  [msg, time, addr, recvPort].postln;

  // Extract optional parameters from message
  if (msg[1].isNumber) {seed = msg[1]} {seed = 1};
  if (msg[2].isNumber) {other = msg[2]} {other = 20};

  "continue seeds: %, %".format(seed, other).postln;

  // TODO: this needs expanded. Possibly a place for a state machine or something
  //       similar. Could probably use envrionment vars(`~var`) to have a mutable 
  //       global object
  seed = seed + [-1, -2, -3, 0, 1, 4].choose;

  if (seed > 0) {
    misc[\etc][\rustySocket].sendMsg("/start", seed, other);
  } {
    misc[\etc][\socket].sendMsg("/ding", 202);
  };

}, '/continue');

osc[\list].add(\continue);

osc
)
