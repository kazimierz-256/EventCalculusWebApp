:- module(compound_executable,
    [
        compound_executable_atomic_get_assignment/4
	]).


% NOT ORDERED
no_release_fluent_in_causes(Release_Fluents_Ordered, Condition) :-
    search_clause(Release_Fluents_Ordered, Condition).

search_clause(Release_Fluents_Ordered, and(T1, T2)) :-
    search_clause(Release_Fluents_Ordered, T1),
    search_clause(Release_Fluents_Ordered, T2).

search_clause(Release_Fluents_Ordered, or(T1, T2)) :-
    search_clause(Release_Fluents_Ordered, T1),
    search_clause(Release_Fluents_Ordered, T2).

search_clause(Release_Fluents_Ordered, iff(T1, T2)) :-
    search_clause(Release_Fluents_Ordered, T1),
    search_clause(Release_Fluents_Ordered, T2).

search_clause(Release_Fluents_Ordered, if(T1, T2)) :-
    search_clause(Release_Fluents_Ordered, T1),
    search_clause(Release_Fluents_Ordered, T2).

search_clause(Release_Fluents_Ordered, negate(T1)) :-
    search_clause(Release_Fluents_Ordered, T1).

% NOT ORDERED
search_clause(Release_Fluents_Ordered, T) :-
    string(T),
    not(member(T, Release_Fluents_Ordered)).

conjunct(Statement, [], Statement).
conjunct(Statement, Acc1, and(Statement, Acc1)).


compound_executable_atomic_get_assignment(Time, Action_Domain, Fluent_Assignments, Compound_Action) :-
    dif(Compound_Action, []),
    assoc_to_list(Action_Domain, Action_Domain_List),
    maplist(potentially_executable_atomic(Time, Action_Domain_List, Fluent_Assignments), Compound_Action),
    findall(Causes_Condition,
        (
            get_assoc(Action, Action_Domain, Action_Description),
            get_assoc("causes", Action_Description, (Causes_Condition, _))
        ),
        Causes_Conditions),
    findall(Release_Fluent,
        (
            get_assoc(Action, Action_Domain, Action_Description),
            get_assoc("releases", Action_Description, (Release_Fluent, _))
        ),
        Release_Fluents),
    % IF OK, try ordered for efficiency
    % list_to_ord_set(Release_Fluents, Release_Fluents_Ordered),
    (Causes_Conditions = []
        ->  true
        ;   foldl(conjunct, Causes_Conditions, Consequence),
            no_release_fluent_in_causes(Release_Fluents, Consequence),
            once(getAssociationThatSatisfiesFormula(Consequence, _))
    ).