TestP3Options : UnitTest {
  test_should_use_default_instrument {
    var options = P3Options.new;
    this.assertEquals(\default, options.instrument)
  }

  test_set_instrument {
    var options = P3Options.new.instrument_(\synth);
    this.assertEquals(\synth, options.instrument)
  }

  test_should_set_length {
    var options = P3Options.new.length_(100);
    this.assertEquals(100, options.length)
  }

  test_should_have_basic_default_melody {
    var expected, actual, melody;

    melody = P3Options.new.melody.asStream;
    expected = [1,3,5,7,nil];
    actual = [
      melody.next(Event.default),
      melody.next(Event.default),
      melody.next(Event.default),
      melody.next(Event.default),
      melody.next(Event.default),
    ];

    this.assertEquals(actual, expected);
  }
}
