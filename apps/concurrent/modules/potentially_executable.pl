:- module(potentially_executable, 
    [
        potentially_executable_atomic/4
	]).

:- use_module(logic_formula_satisfiability).
    

% use the following predicate to filter a list of actions and retrieve a list of potentially executable actions
% include(potentially_executable_atomic, Compound_Action, Potentially_Executables)
    

% list_potentially_executable_atomic(Time, Action_Domain_List, Fluent_Assignments, Atomic_Action) :-
%     % no impossible statement with action in action domain
%     member(Atomic_Action-Action_Description, Action_Domain_List),
%     not(get_assoc("impossible", Action_Description, Invalid_Times), member(Time, Invalid_Times)),
%     not((get_assoc("causes", Action_Description, (_, Precondition)), not(logic_formula_satisfied(Precondition, Fluent_Assignments)))),
%     not((get_assoc("releases", Action_Description, (_, Precondition)), not(logic_formula_satisfied(Precondition, Fluent_Assignments)))).

potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments, Atomic_Action) :-
    % no impossible statement with action in action domain
    get_assoc(Atomic_Action, Action_Domain, Action_Description),
    not(once((get_assoc("impossible", Action_Description, Times), member(Time, Times)))),
    % write("D: "),writeln(Atomic_Action),
    % WARNING what if precondition refers to a fluent that is not assigned at Fluent_Assignments?
    not(once((get_assoc("causes", Action_Description, (_, Precondition)), not(logic_formula_satisfied(Precondition, Fluent_Assignments))))),
    not(once((get_assoc("releases", Action_Description, (_, Precondition)), not(logic_formula_satisfied(Precondition, Fluent_Assignments))))).