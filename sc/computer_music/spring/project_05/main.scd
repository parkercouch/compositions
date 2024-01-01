// ----------------------------------------------------------------- //
// -------------------------- Project ? ---------------------------- //
// ----------------------------------------------------------------- //

Multi tempo composition

// ----------------------------------------------------------------- //
// -------------------------- Setup -------------------------------- //
// ----------------------------------------------------------------- //

( // --- START
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.reboot;

s.waitForBoot({
  ~synths = "./synths.scd".loadRelative[0];
  ~patterns = "./patterns.scd".loadRelative[0];
  ~misc = "./misc.scd".loadRelative[0];

  ~tempoA = TempoClock(122.5/60);
  ~tempoB = TempoClock(33/60);
  ~tempoC = TempoClock(205.23/60);
  ~tempoD = TempoClock(1003.1/60);

  ~task = Task({
    ~patterns[\phrase].(octave: 3, length: 1, amp: 0.3, seq: [17, 20, 10, 12, 13], legato: 0.2).play(~tempoA);

    2.wait;

    ~patterns[\phrase].(octave:     1, length: 2, amp:  0.3, legato: 0.8).play(~tempoA);
    ~patterns[\phrase].(octave: [4,5], length: 3, amp:  0.2, legato: 0.5).play(~tempoB);
    ~patterns[\phrase].(octave: [7,9], length: 3, amp: 0.05, legato: 0.2, synth: \fm2, modindex: [1000, 1]).play(~tempoA);

    4.wait;

    ~patterns[\phrase].(octave: 1, length: 2, amp:  0.3, legato: 0.8).play(~tempoB);
    ~patterns[\phrase].(octave: 5, length: 3, amp:  0.2, legato: 0.5).play(~tempoA);
    ~patterns[\phrase].(octave: 8, length: 3, amp: 0.01, legato: 0.8, synth: \fm2, modindex: 5).play(~tempoB);

    4.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp:  0.3, legato: 0.2).play(~tempoA);
    ~patterns[\phrase].(octave: 5, length: 3, amp: 0.01, legato: 0.5, synth: \fm2).play(~tempoC);
    ~patterns[\phrase].(octave: 8, length: 3, amp:  0.5, legato: 0.8).play(~tempoC);

    4.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.1, legato: 0.2, synth: \fm2).play(~tempoB);
    ~patterns[\phrase].(octave: 5, length: 3, amp: 0.2, legato: 0.5).play(~tempoB);
    ~patterns[\phrase].(octave: 8, length: 3, amp: 0.5, legato: 0.8).play(~tempoD);

    15.wait;

    ~patterns[\phrase].(octave: 2, length: 1, amp: 0.3, legato: 0.8).play(~tempoA);
    ~patterns[\phrase].(octave: 5, length: 1, amp: 0.2, legato: 0.5).play(~tempoA);
    ~patterns[\phrase].(octave: 8, length: 1, amp: 0.5, legato: 0.2).play(~tempoA);

    4.wait;

    ~patterns[\phrase].(octave: 2, length: 10, amp: 0.1, legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 5, length: 10, amp: 0.1, legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 8, length: 10, amp: 0.2, legato: 0.5).play(~tempoD);

    8.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [1,2,3], legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [1,2,3], legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.2, seq: [1,2,3], legato: 0.5, synth: \fm2).play(~tempoD);

    2.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [1,5,4,3,2], legato: 0.3).play(~tempoC);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [1,5,4,3,2], legato: 0.3).play(~tempoC);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.2, seq: [1,5,4,3,2], legato: 0.3, synth: \fm2).play(~tempoC);

    2.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [1,2,3], legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [1,2,3], legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.2, seq: [1,2,3], legato: 0.5, synth: \fm2, modindex: 100).play(~tempoD);

    2.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [6,6,6], root: 2, legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [6,6,6], root: 2, legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.2, seq: [6,6,6], root: 2, legato: 0.5, synth: \fm2).play(~tempoD);

    1.1.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.5).play(~tempoD);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.1, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.5, synth: \fm2).play(~tempoD);

    1.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.3).play(~tempoD);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.3).play(~tempoC);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.3, synth: \fm2).play(~tempoA);

    2.6.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [1,2,3], legato: 0.5).play(~tempoC);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [1,2,3], legato: 0.5).play(~tempoC);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.1, seq: [1,2,3], legato: 0.5, synth: \fm2, modindex: 1000).play(~tempoC);

    3.wait;

    ~patterns[\phrase].(octave: 2, length: 2, amp: 0.3, seq: [6,6,6,7,7,8,9], root: 3, legato: 0.5).play(~tempoA);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 4, legato: 0.5).play(~tempoA);
    ~patterns[\phrase].(octave: 8, length: 2, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.5, synth: \fm2).play(~tempoA);

    3.wait;

    ~patterns[\phrase].(octave: 2, length: 1, amp: 0.3, seq: [6,6,6,7,7,8,9], root: 3, legato: 0.5).play(~tempoB);
    ~patterns[\phrase].(octave: 5, length: 2, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 4, legato: 0.5).play(~tempoC);
    ~patterns[\phrase].(octave: 8, length: 5, amp: 0.2, seq: [6,6,6,7,7,8,9], root: 5, legato: 0.5, synth: \fm2, modindex: 1000).play(~tempoD);

    14.wait;

    ~patterns[\phrase].(octave: Pseq([Pn(3,5),2]), length: 1, amp:  0.3, seq: [17,20,10,12,13,0], legato: 0.3, root: 1).play(~tempoA);
    ~patterns[\phrase].(octave: Pseq([Pn(3,5),2]), length: 1, amp: 0.05, seq: [17,20,10,12,13,0], legato: 0.3, root: 1, synth: \fm2).play(~tempoA);
  });

  ~task.start;

  });
)

~task.start;
