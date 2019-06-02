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

conjunct(Statement, [], Statement).
conjunct(Statement, Acc1, and(Statement, Acc1)).
flip_val(false, true).
flip_val(true, false).
get_total_occlusion(Compound_Action, Action_Domain, Fluent) :-
    (
        findall(Flu,
            (
                member(Action, Compound_Action),
                get_assoc(Action, Action_Domain, Action_Description),
                get_assoc("causes", Action_Description, (Causes_Condition, _)),
                search_clause(Causes_Condition, Flu)
            ),
            Flus),
        findall(Causes_Condition, (
            member(Action, Compound_Action),
            get_assoc(Action, Action_Domain, Action_Description),
            get_assoc("causes", Action_Description, (Causes_Condition, _))),
            Causes_Conditions),
        foldl(conjunct, Causes_Conditions, true, Consequence),
        sort(Flus, Causes_Fluents),
        (   
            member(Fluent, Causes_Fluents),
            once((
                get_association_satisfying_formula_incomplete(Consequence, Incomplete_New_Assignment),
                % if there is no such fluent, the answer doesnt depend on it being flipped
                del_assoc(Fluent, Incomplete_New_Assignment, Value, Assignment_Without_Fluent),
                flip_val(Value, Flipped),
                put_assoc(Fluent, Assignment_Without_Fluent, Flipped, Changed_Assignment),
                get_association_satisfying_formula_incomplete([], Changed_Assignment, negate(Consequence), _)
            ))
        )
    )
    ;
    (
        member(Action, Compound_Action),
        get_assoc(Action, Action_Domain, Action_Description),
        get_assoc("releases", Action_Description, (Fluent, _))
    ).
