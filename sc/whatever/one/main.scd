// Copy of poem project to get boilerplate out of the way
// TODO: name and describe project

( // --- START
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;

s.waitForBoot({
  ~synths = "synths.scd".load;
  ~patterns = "patterns.scd".load;
  ~misc = "misc.scd".load;

  ~seq = ~patterns[\generators][\poem].(
    [["i am here" ,  1,   [3], Pseq([40,1,2,3,10,1,1,2,3]),inf]]++
    [["here i am" ,  3, [5,7], Pseq([1,10,2,1,1,1]),inf]]++
    [["am i here?",  5, [1,8], Pseq([2,3,4,10]),inf]]++
    [["debatable" ,  7, [0,5], Pseq([Pn(2, 8), 50]),inf]]++

    [["i am here" ,  2,   [3], Pseq([4,1,2,3,10,1,1,2,3]),inf]]++
    [["here i am" ,  4, [5,7], Pseq([1,10,2,1,1,10]),inf]]++
    [["am i here?",  6, [1,8], Pseq([2,3,4,10]),inf]]++
    [["hardly"    ,  8, [0,5], Pseq([50, Pn(2, 3)]),inf]]++

    [["i am here" ,  3,   [3], Pseq([4,1,2,3,10,1,1,2,3]),inf]]++
    [["here i am" ,  5, [5,7], Pseq([1,10,2,1,1,1]),inf]]++
    [["am i here?",  7, [1,8], Pseq([2,3,4,10]),inf]]++
    [["no"        ,  9, [0,5], Pseq([1, 100]),inf]]++

    [["i am here" ,  4,   [3], Pseq([4,1,2,3,10,1,1,2,3]),inf]]++
    [["here i am" ,  6, [5,7], Pseq([1,10,2,1,1,1]),inf]]++
    [["am i here?",  8, [1,8], Pseq([2,3,4,10]),inf]]++
    [["ha!"       , 10, [0,5], Pseq([10, 10, 250]),inf]]++
    [["!"         ,  0,   [0], Pseq([Rest(10)]),inf]],
  );

  ~seq = ~synths[\functions][\limiter].(~seq, 0.5);
  // ~seq.play(clock: TempoClock(90/6));
});
)

~seq.play(clock: TempoClock(90/6));
