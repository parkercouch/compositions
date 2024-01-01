(
s.waitForBoot({
  ~synths = "./synths.scd".loadRelative[0];
  ~patterns = "./patterns.scd".loadRelative[0];
  ~osc = "./osc.scd".loadRelative[0];
  ~misc = "./misc.scd".loadRelative[0];

  ~clock = TempoClock(1);

  "STARTING COMPOSITION IN".postln;
  3.postln;
  1.wait;
  2.postln;
  1.wait;
  1.postln;
  1.wait;
  ~misc[\etc][\rustySocket].sendMsg("/start", 20, 5);
  5.wait;
  ~misc[\etc][\rustySocket].sendMsg("/start", 33, 13);
});
)
