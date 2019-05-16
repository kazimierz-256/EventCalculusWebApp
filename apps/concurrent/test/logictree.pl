:- use_module("../concurrent").

:- logictreefromtext("LOADED", T),
T="LOADED".

:- logictreefromtext("not LOADED", T),
T=negate("LOADED").

:- logictreefromtext("LOADED or DEAD", T),
T=or("LOADED","DEAD").

:- logictreefromtext("LOADED or JAMMED and DEAD", T),
T=or("LOADED",and("JAMMED","DEAD")).

:- logictreefromtext("LOADED or JAMMED and ( not DEAD )", T),
T=or("LOADED",and("JAMMED",negate("DEAD"))).