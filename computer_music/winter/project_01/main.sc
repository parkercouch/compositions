( // --- START
Server.default = s = Server.internal.boot;
)

( // --- FREE
s.freeAll;
)

( // --- TOOLS
s.meter;
s.scope;
FreqScope.new(522, 300, 0, server: s);
)

( // --- OPTIONS
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.options.memSize = 2.pow(20);
s.reboot;
)
