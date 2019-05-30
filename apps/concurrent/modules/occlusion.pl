:- module(occlusion, 
    [
        get_occlusion/3,
        get_total_occlusion/3,
        get_all_fluents_from_tree/2,
        get_sample_fluent_from_tree/2
    ]).

:- use_module(logic_formula_satisfiability).


get_sample_fluent_from_tree(Tree, Fluent) :-    
    search_clause(Tree, Fluent).

get_all_fluents_from_tree(Tree, Unique_Fluents) :-    
    findall(Fluent, search_clause(Tree, Fluent), Fluents),
    sort(Fluents, Unique_Fluents).

search_clause(and(T1, T2), Fluent) :-
    search_clause(T1, Fluent)
    ;
    search_clause(T2, Fluent).

search_clause(or(T1, T2), Fluent) :-
    search_clause(T1, Fluent)
    ;
    search_clause(T2, Fluent).

search_clause(iff(T1, T2), Fluent) :-
    search_clause(T1, Fluent)
    ;
    search_clause(T2, Fluent).

search_clause(if(T1, T2), Fluent) :-
    search_clause(T1, Fluent)
    ;
    search_clause(T2, Fluent).

search_clause(negate(T1), Fluent) :-
    search_clause(T1, Fluent).

search_clause(Fluent, Fluent) :- string(Fluent).

get_occlusion(Action, Action_Domain, Fluent) :-
    get_assoc(Action, Action_Domain, Action_Description),
    (
        get_assoc("causes", Action_Description, (Causes_Condition, _)),
        search_clause(Causes_Condition, Fluent)
        ;
        get_assoc("releases", Action_Description, (Fluent, _))
    ).



vary_fluents([], New_Assignment) :- empty_assoc(New_Assignment).
vary_fluents([OCL | Occlusion_List], New_Assignment) :-
    vary_fluents(Occlusion_List, Less_New_Assignment),
    (put_assoc(OCL, Less_New_Assignment, true, New_Assignment) ; put_assoc(OCL, Less_New_Assignment, false, New_Assignment)).

conjunct(Statement, [], Statement).
conjunct(Statement, Acc1, and(Statement, Acc1)).
flip_val(false, true).
flip_val(true, false).
get_total_occlusion(Compound_Action, Action_Domain, Fluent) :-
    findall(Flu, (
                    member(Action, Compound_Action),
                    get_assoc(Action, Action_Domain, Action_Description),
                    get_assoc("causes", Action_Description, (Causes_Condition, _)),
                    search_clause(Causes_Condition, Flu))
            ,Flus),
    findall(Causes_Condition, (
        member(Action, Compound_Action),
        get_assoc(Action, Action_Domain, Action_Description),
        get_assoc("causes", Action_Description, (Causes_Condition, _))),
        Causes_Conditions),
    foldl(conjunct, Causes_Conditions, true, Consequence),
    sort(Flus, Causes_Fluents),
    (
        (member(Fluent, Causes_Fluents),once(
                (
                    vary_fluents(Causes_Fluents, New_Assignment),
                    logic_formula_satisfied(Consequence, New_Assignment),
                    del_assoc(Fluent, New_Assignment, Value, Assignment_Without_Fluent),
                    flip_val(Value, Flipped),
                    put_assoc(Fluent, Assignment_Without_Fluent, Flipped, Changed_Assignment),
                    not(logic_formula_satisfied(Consequence, Changed_Assignment))
                )
                ))
        ;
        (get_assoc(Action, Action_Domain, Action_Description),get_assoc("releases", Action_Description, (Fluent, _)))
        ).
