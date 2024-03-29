(SynthDef(\ping_mh,{arg freq=440,amp=0.2,dur=0.1,attack=0.001,pan=0,out=0;
    var sig,freq2;
    freq=freq*rrand(1,1.01);
    freq2=freq*rrand(1,1.01);
    e=EnvGen.ar(Env.perc(attack,dur,curve:-4),doneAction:2);
    sig=SinOsc.ar([freq,freq2],0,amp*e);
    sig=Pan2.ar(sig,pan);
    Out.ar(out,sig)
},
metadata: (
	credit: "Your basic percussive synth instrument, a good default sound for testing patterns, etc.",
	tags: [\percussive, \ping, \default, \simple, \stereo, \detuned, \tuned]
	)
).writeDefFile;
)



Synth(\ping_mh);
