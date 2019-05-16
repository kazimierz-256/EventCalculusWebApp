:- use_module("../concurrent").

:- list_to_assoc(["LOADED"-true, "DEAD"-false], LIST),
logic_formula_satisfied("LOADED", LIST),
logic_formula_satisfied(and("LOADED", negate("DEAD")), LIST),
logic_formula_satisfied(iff(negate("LOADED"), negate(negate(or("DEAD", "DEAD")))), LIST).