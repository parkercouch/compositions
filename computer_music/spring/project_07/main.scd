// ----------------------------------------------------------------- //
// -------------------------- Project 7 ---------------------------- //
// ----------------------------------------------------------------- //

Using 16-bit samples, the maximum dB is

    db = 20 * log10( linear )
    db = 20 * log10( 2**16 )
    96.3296 = 20 * log10( 2**16 )

Assume that the softest sound is at 60 dB

That gives a dynamic range of about 36 dB (96 - 60 = 36)

Here's a conversion chart between decibels and their equivalent linear
values, and their (somewhat arbitrary) musical names:

  1: ppppp   60.00 db   a = 0.015849
  2:  pppp   63.27 db   a = 0.023101
  3:   ppp   66.55 db   a = 0.033672
  4:    pp   69.82 db   a = 0.049081
  5:     p   73.09 db   a = 0.071539
  6:    mp   76.36 db   a = 0.104275
  7:    mf   79.64 db   a = 0.151991
  8:     f   82.91 db   a = 0.221541
  9:    ff   86.18 db   a = 0.322917
 10:   fff   89.45 db   a = 0.470682
 11:  ffff   92.73 db   a = 0.686062
 12: fffff   96.00 db   a = 1.000000

The difference between the levels above is about 3dB.

Remember that the doubling of the intensity of a sound is about 6dB:
if sound B is 6dB greater than sound A, it will appear to be about
twice as loud.

Create a project of about 1-2 minutes in duration, in which EACH of
the above 12 levels of amplitude are used.

// ----------------------------------------------------------------- //
// -------------------------- Setup -------------------------------- //
// ----------------------------------------------------------------- //

( // --- START
Server.default = s = Server.internal.boot;
TempoClock.default.tempo = 1;
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;

s.waitForBoot({
  var p5;

  ~synths = "./synths.scd".loadRelative[0];
  ~patterns = "./patterns.scd".loadRelative[0];
  ~misc = "./misc.scd".loadRelative[0];

  ~clock = TempoClock(240/60);

  ~seq = Pseq([
    Ptpar([
       0.0, ~patterns[\phrase].(length: 1, scale: 7, sync: 19, legato: 0.9, octave: 1, amp: ~misc[\dynamics][\ppppp]),
       1.1, ~patterns[\phrase].(length: 1, scale: 3, sync: 31, legato: 0.9, octave: 2, amp: ~misc[\dynamics][\pppp]),
       2.2, ~patterns[\phrase].(length: 3, scale: 1, sync:  5, legato: 0.9, octave: 3, amp: ~misc[\dynamics][\ppp]),
       3.3, ~patterns[\phrase].(length: 3, scale:  7, sync:  7, legato: 0.9, octave: 3, amp: ~misc[\dynamics][\pp]),
       4.4, ~patterns[\phrase].(length: 3, scale:  5, sync: 11, legato: 0.8, octave: 3, amp: ~misc[\dynamics][\p]),
       5.5, ~patterns[\phrase].(length: 2, scale:  3, sync: 13, legato: 0.7, octave: 5, amp: ~misc[\dynamics][\mp]),
       6.6, ~patterns[\phrase].(length: 2, scale:  1, sync: 13, legato: 0.6, octave: 5, amp: ~misc[\dynamics][\mf]),
       7.7, ~patterns[\phrase].(length: 2, scale:  3, sync: 11, legato: 0.5, octave: 3, amp: ~misc[\dynamics][\f]),
       8.8, ~patterns[\phrase].(length: 3, scale:  5, sync:  7, legato: 0.4, octave: 3, amp: ~misc[\dynamics][\ff]),
       9.9, ~patterns[\phrase].(length: 3, scale:  7, sync:  5, legato: 0.3, octave: 7, amp: ~misc[\dynamics][\fff]),
      10.0, ~patterns[\phrase].(length: 3, scale: 1, sync:  3, legato: 0.2, octave: 8, amp: ~misc[\dynamics][\ffff]),
      11.1, ~patterns[\phrase].(length: 3, scale: 3, sync:  1, legato: 0.2, octave: 8, amp: ~misc[\dynamics][\fffff]),
    ], 1),
    Ptpar([
      0.0, ~patterns[\phrase].(length: 1, scale: 7, sync:  9, legato: 0.3, octave: 5, amp: ~misc[\dynamics][\fffff]),
      1.1, ~patterns[\phrase].(length: 1, scale: 3, sync:  3, legato: 0.2, octave: 3, amp: ~misc[\dynamics][\f]),
      10.0, ~patterns[\phrase].(length: 19, scale: 1, sync: 0.5, legato: 1, octave: 2, amp: ~misc[\dynamics][\ppppp]),
    ], 1),
    Ptpar([
      0.0, ~patterns[\phrase].(length: 19, scale: 1, sync: 0.5, legato: 1, octave: 2, amp: ~misc[\dynamics][\f]),
      10.0, ~patterns[\phrase].(length: 1, scale: 7, sync:  9, legato: 0.3, octave: 4, amp: ~misc[\dynamics][\ppp]),
      // 1.1, ~patterns[\phrase].(length: 1, scale: 3, sync:  3, legato: 0.2, octave: 3, amp: ~misc[\dynamics][\f]),
    ], 1),
  ], 1);

  ~seq = ~synths[\functions][\limiter].(~seq, 0.05);

  ~seq.trace.play(clock: ~clock);
});
)

~seq.start;
