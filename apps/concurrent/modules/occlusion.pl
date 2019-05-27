:- module(occlusion, 
    [
        get_occlusion/3,
        get_all_fluents_from_tree/2
	]).



%search_clause(or(T1, T2), Fluents) :-
%    search_clause(T1, Fluents)
%    ;
%    search_clause(T2, Fluents).
%
%search_clause(iff(T1, T2), Fluents) :-
%    search_clause(T1, Fluents)
%    ;
%    search_clause(T2, Fluents).
%
%search_clause(if(T1, T2), Fluents) :-
%    search_clause(T1, Fluents)
%    ;
%    search_clause(T2, Fluents).
%
%search_clause(negate(T1), Fluents) :-
%    search_clause(T1, Fluent).

search_clause(and(_), Fluents_SF, Fluents) :-
    writeln("COOO").

search_clause(and(T1, T2), Fluents_SF, Fluents) :-
    search_clause(T1, Fluents_SF, Fluents_SF2),
    writeln("1"),
    search_clause(T2, Fluents_SF2, Fluents),
    writeln("2"),
    writeln(T2).

search_clause(Fluent, Fluents_SF, Fluents) :-
    writeln("uwaga"),
    writeln(Fluent),
    subsumes_term(Fluent, and(_,_))
    ->  (writeln("fail"),
        fail)
    ;   (writeln("adding to list"),
        writeln(Fluent),
        append([string(Fluent)], Fluents_SF, Fluents)).


get_all_fluents_from_tree(Tree, Unique_Fluents) :-
    search_clause(Tree, [], Fluents),
    writeln("Fluents"),
    writeln(Fluents),
    sort(Fluents, Unique_Fluents).

get_occlusion(Action, Action_Domain, Fluent) :-
    get_assoc(Action, Action_Domain, Action_Description),
    (
        get_assoc("causes", Action_Description, (Causes_Condition, _)),
        search_clause(Causes_Condition, Fluent)
        ;
        get_assoc("releases", Action_Description, (Fluent, _))
    ).