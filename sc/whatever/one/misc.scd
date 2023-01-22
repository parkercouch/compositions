( // MISC
var misc = "../../lib/misc.scd".load;
misc[\functions] = IdentityDictionary();

~boilerplate = {|n|
  n + 1
};

misc[\functions][\boilerplate] = ~boilerplate;

misc
)
