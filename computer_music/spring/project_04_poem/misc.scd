// ----------------------------------------------------------------- //
// --------------------------- Misc -------------------------------- //
// ----------------------------------------------------------------- //

(
var misc = IdentityDictionary();
misc[\scales] = IdentityDictionary();

misc[\scales][\et12] = Scale.chromatic;
misc[\scales][\et19] = Scale.chromatic(Tuning.et19);
misc[\scales][\et22] = Scale.chromatic(Tuning.et22);
misc[\scales][\et24] = Scale.chromatic(Tuning.et24);
misc[\scales][\et31] = Scale.chromatic(Tuning.et31);
misc[\scales][\et41] = Scale.chromatic(Tuning.et41);
misc[\scales][\et53] = Scale.chromatic(Tuning.et53);
misc[\scales][\wcAlpha] = Scale.chromatic(Tuning.wcAlpha);
misc[\scales][\wcBeta] = Scale.chromatic(Tuning.wcBeta);
misc[\scales][\wcGamma] = Scale.chromatic(Tuning.wcGamma);

misc
)
