(
~load = {
  s.waitForBoot({
    ~synths = "./synths.scd".loadRelative[0];
    ~patterns = "./patterns.scd".loadRelative[0];
    ~osc = "./osc.scd".loadRelative[0];
    ~misc = "./misc.scd".loadRelative[0];
    ~clock = TempoClock(1);
  });
};

~start = {|task|
  s.waitForBoot({
    ~clock = TempoClock(1);
    task.value;
  });
};

~example = {
  ~misc[\etc][\rustySocket].sendMsg("/start", 20, 5);
  5.wait;
  ~misc[\etc][\rustySocket].sendMsg("/start", 33, 13);
};

~control_panel = {
  var w, ding, stop, record, restart, example, output, pierce;

  ~load.();

  w = Window.new("control", Rect(200,200,320,320)).front;
  w.view.decorator = FlowLayout(w.view.bounds);
  ding = Button.new(w,Rect(10,0,80,30)).states_([["ding"]]);
  ding.action = {|button|
    "sent /start".postln;
    ~misc[\etc][\rustySocket].sendMsg("/start", 1, 1);
  };
  pierce = Button.new(w,Rect(10,0,80,30)).states_([["pierce"]]);
  pierce.action = {|button|
    "sent /pierce".postln;
    ~misc[\etc][\rustySocket].sendMsg("/pierce", 3, 7);
  };
  stop = Button.new(w,Rect(10,0,80,30)).states_([["stop"]]);
  stop.action = {|button|
    "goodbye".postln;
    s.freeAll;
  };
  record = Button.new(w,Rect(10,0,80,30)).states_([["record"]]);
  record.action = {|button|
    "record (todo)".postln;
  };
  restart = Button.new(w,Rect(10,0,80,30)).states_([["restart"]]);
  restart.action = {|button|
    ~control_panel.();
    // s.reboot;
    // ~load.();
    // ~start.();
  };
  example = Button.new(w,Rect(10,0,80,30)).states_([["example"]]);
  example.action = {|button|
    "example".postln;
    ~start.(~example);
  };
  output = StaticText.new(w,Rect(10,0,80,30)).string_("output:");
};

~control_panel.()
)
