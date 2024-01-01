(
Server.supernova;
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 8;
s.options.memSize = 2.pow(20);
s.reboot;

s.waitForBoot({
  ~synths = "./synths.scd".loadRelative[0];
  ~patterns = "./patterns.scd".loadRelative[0];
  ~osc = "./osc.scd".loadRelative[0];
  ~misc = "./misc.scd".loadRelative[0];

  ~clock = TempoClock(1);
});
)
