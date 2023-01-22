P3CallAndResponse : Pattern {
  var call, response, options;

  *new {
    arg call = P3Call,
        response = P3Response,
        options = P3Options.new;
    ^super.newCopyArgs(call, response, options)
  }

  storeArgs { ^[call,response,options] }

  embedInStream {|inevent|
    ^Pseq([
      call.new(options),
      RestFor(0.5),
      response.new(options),
    ]).embedInStream(inevent)
  }
} 
