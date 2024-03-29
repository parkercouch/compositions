/*
Mitchell Sigman (2011) Steal this Sound. Milwaukee, WI: Hal Leonard Books
pp. 14-15

Adapted for SuperCollider and elaborated by Nick Collins
http://www.sussex.ac.uk/Users/nc81/index.html
under GNU GPL 3 as per SuperCollider license

Minor modifications by Bruno Ruviaro, June 2015.
*/
(
SynthDef("werkit2", {
	arg out = 0, freq = 440, amp = 0.1, gate = 1, cutoff = 100, rq = 0.1, att = 0.01, dec = 0, sus = 1, rel = 0.1;

	var source, filter, env, snd;
	source = LFSaw.ar(Array.fill(16, { Rand(100, 200) }));
	filter = BLowPass4.ar(source, freq, rq) * 0.1;
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	snd = (0.7 * filter + (0.3 * filter.distort)) * env;
	snd = HPF.ar(snd, 100);
	snd = Splay.ar(snd);
	Out.ar(out, snd);
}).writeDefFile;
)


loadRelative("utilities.scd");

~addSynthDemo.value("werkit2",
	Pbind(
		\instrument, "werkit2",
		\amp, Pwhite(0.05, 0.1),
		\note, Pseq([-1, 1, -1, 1, 3, 6, 9, 11, 12, 15, 17, 18, 19, 20, 23, 26], inf),
		\dur, 0.25,
		\att, Pn(Pgeom(0.01, 1.1, 16), inf),
		\rel, Pn(Pgeom(0.02, 1.35, 16), inf),
		\rq, Pwhite(0.005, 0.02)
	);
)
