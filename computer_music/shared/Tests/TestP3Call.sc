TestP3Call : UnitTest {

  test_should_use_default_instrument_if_none_provided {
    var nextEvent = P3Call().asStream.next(Event.default);

    this.assertEquals(\default, nextEvent.at(\instrument))
  }
}
