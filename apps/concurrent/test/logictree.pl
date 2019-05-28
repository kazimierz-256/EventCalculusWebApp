:- use_module("../modules/logic_tree_parsing.pl").

:- logic_tree_from_text("LOADED", T),
T="LOADED".

:- logic_tree_from_text("not LOADED", T),
T=negate("LOADED").

:- logic_tree_from_text("LOADED or DEAD", T),
T=or("LOADED","DEAD").

:- logic_tree_from_text("    LOADED  or     JAMMED  and     DEAD     ", T),
T=or("LOADED",and("JAMMED","DEAD")).

:- logic_tree_from_text("LOADED or JAMMED and (not DEAD)", T),
T=or("LOADED",and("JAMMED",negate("DEAD"))).

:- logic_tree_from_text("", T),
T=true.