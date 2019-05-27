:- module(occlusion, 
    [
        get_occlusion/3,
        get_all_fluents_from_tree/2
	]).

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