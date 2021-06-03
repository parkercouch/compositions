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

  ~socket = NetAddr.new("127.0.0.1",NetAddr.langPort);
  ~rustySocket = NetAddr("127.0.0.1", 8080);

  ~socket.sendMsg("/ding");
});
)

~rustySocket.sendMsg("/start", 2);

~socket.sendMsg("/blah", 1, 5);
~socket.sendMsg("/piercing", 3, 10);

~socket.sendMsg("/ding", 1);
~socket.sendMsg("/ding", 10);
~socket.sendMsg("/ding", 20);
~socket.sendMsg("/ding", 100);
~socket.sendMsg("/ding", 101);
~socket.sendMsg("/ding", 102);
~socket.sendMsg("/ding", 1000);
~socket.sendMsg("/ding", 1001);

(
~rustySocket = NetAddr("127.0.0.1", 8080);
)

~rustySocket.sendMsg("/dong", 100);
~rustySocket.sendMsg("/dong", 10);

// TODO: This does not run consistently... not sure why. Need to figure out how the Pipe actually works
// It's like it has trouble even starting the binary.
// Then after running I have to restart the server to get any osc message to work
(
~trigger = {|target="debug", wait=50, notes=50|
  var pipe = Pipe.argv([
    "/home/parker/compositions/rust/spring_final/target/%/final_composition".format(target),
    "--wait=%".format(wait),
    "--notes=%".format(notes),
    "--send_port=%".format(NetAddr.langPort),
  ], "r");
  pipe.close;
};
)

(
~trigger.(wait: 1000, notes:  10);
)

~trigger.(wait:  10, notes: 100);
~trigger.(wait:  50, notes:   5);

(
p = Pipe.argv([
  "/home/parker/code/rust/final_composition/target/debug/final_composition",
  "--wait=50",
  "--notes=50",
  "--port=%".format(NetAddr.langPort),
], "r");
p.close;
)
