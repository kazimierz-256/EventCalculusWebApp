:- use_module("../modules/logic_formula_satisfiability.pl").

:- list_to_assoc(["LOADED"-true, "DEAD"-false], LIST),
logic_formula_satisfied("LOADED", LIST),
logic_formula_satisfied(and("LOADED", negate("DEAD")), LIST),
logic_formula_satisfied(iff(negate("LOADED"), negate(negate(or("DEAD", "DEAD")))), LIST).

:- get_association_satisfying_formula(or("LOADED", "DEAD"), LIST),
    assoc_to_list(LIST, REALLIST),
    writeln(REALLIST).

:- findall(REALLIST, (get_association_satisfying_formula(or("LOADED", "DEAD"), LIST),
    assoc_to_list(LIST, REALLIST)), LISTS),
    writeln(LISTS).

:- list_to_assoc(["ALIVE1"-true, "JAMMED1"-false, "FACING12"-true], Sample_Fluent_Assignments),
logic_formula_satisfied(and("ALIVE1", and(negate("JAMMED1"), "FACING12")), Sample_Fluent_Assignments).

:- findall(REALLIST, (get_association_satisfying_formula(or(and("LOADED", and("DEAD", "ALIVE")), "LOADED"), LIST),
    assoc_to_list(LIST, REALLIST)), LISTS),
    writeln(LISTS).