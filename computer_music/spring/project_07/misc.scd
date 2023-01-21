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

misc[\dynamics] = IdentityDictionary();
misc[\dynamics][\ppppp] = 0.015849;
misc[\dynamics][\pppp]  = 0.023101;
misc[\dynamics][\ppp]   = 0.033672;
misc[\dynamics][\pp]    = 0.049081;
misc[\dynamics][\p]     = 0.071539;
misc[\dynamics][\mp]    = 0.104275;
misc[\dynamics][\mf]    = 0.151991;
misc[\dynamics][\f]     = 0.221541;
misc[\dynamics][\ff]    = 0.322917;
misc[\dynamics][\fff]   = 0.470682;
misc[\dynamics][\ffff]  = 0.686062;
misc[\dynamics][\fffff] = 1.000000;

misc
)
