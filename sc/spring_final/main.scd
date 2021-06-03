// ----------------------------------------------------------------- //
// ---------------------------- Final ------------------------------ //
// ----------------------------------------------------------------- //

What am I even doing?

I want to set up a bunch of 'nodes' that talk to each other.
As that happens they trigger various synths/parameters as well as
possibly messages that tells 'nodes' to update their internal processes

This can maybe be used to create a 'generative' composition that still
has interesting transitions and narrative without knowing the exact moment
when those transitions happen.

The aesthetic qualities I want is an otherwordly feel.
I don't want a strong beat.
Flowing between consonance/dissonance

How to not be random:
Have a character come back

// ----------------------------------------------------------------- //
// -------------------------- Setup -------------------------------- //
// ----------------------------------------------------------------- //

(
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;

s.waitForBoot({
  ~synths = "./synths.scd".loadRelative[0];
  ~patterns = "./patterns.scd".loadRelative[0];
  ~osc = "./osc.scd".loadRelative[0];
  ~misc = "./misc.scd".loadRelative[0];

  ~clock = TempoClock(1);

  ~misc[\etc][\rustySocket].sendMsg("/start", 20, 5);
  5.wait;
  ~misc[\etc][\rustySocket].sendMsg("/start", 33, 13);
});
)

// TODO: This does not run consistently... not sure why. Need to figure out how the Pipe actually works
// It's like it has trouble even starting the binary.
// Then after running I have to restart the server to get any osc message to work
// Another idea: have the rust app start SC instead of the other way around?
//                all the sc code needs to do is boot up, load synths, then wait for osc messages
(
~startApp = {|target="debug", wait=50, notes=50|
  var pipe = Pipe.argv([
    // TODO: use relative path
    "/home/parker/compositions/rust/spring_final/target/%/final_composition".format(target),
    "--wait=%".format(wait),
    "--notes=%".format(notes),
    "--send_port=%".format(NetAddr.langPort),
  ], "r");
  pipe.close;
};
)
