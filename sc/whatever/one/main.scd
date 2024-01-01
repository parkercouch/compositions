// Copy of poem project to get boilerplate out of the way
// TODO: name and describe project

( // --- START
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
// s.options.numOutputBusChannels = 2;
// s.options.numInputBusChannels = 2;
// s.options.memSize = 2.pow(20);
// s.reboot;

s.waitForBoot({
  ~synths = "synths.scd".load;
  ~patterns = "patterns.scd".load;
  ~misc = "misc.scd".load;

  ~seq = ~patterns[\generators][\poem].(
    [["delux"       ,  1,   [3], Pseq([40,1,2,3,10,1,1,2,3]),inf]]++
    [["deluxington" ,  3, [5,7], Pseq([1,10,2,1,1,1]),inf]]++
    [["debatable"   ,  7, [0,5], Pseq([Pn(2, 8), 50]),inf]]++
    [["ha!"         , 10, [0,5], Pseq([10, 10, 50]),inf]]++
    [["!"           ,  0,   [0], Pseq([Rest(10)]),inf]],
  );

  ~seq = ~synths[\functions][\limiter].(~seq, 0.5);
  // ~seq.play(clock: TempoClock(90/6));
});
)

~seq.play(clock: TempoClock(120/6));
