:- module(potentially_executable, 
    [
        potentially_executable_atomic/4
	]).

:- use_module(logic_formula_satisfiability).
    

% use the following predicate to filter a list of actions and retrieve a list of potentially executable actions
% include(potentially_executable_atomic, Compound_Action, Potentially_Executables)
    
potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments, Atomic_Action) :-
    % no impossible statement with action in action domain
    get_assoc(Atomic_Action, Action_Domain, Action_Description),
    not((
        get_assoc("impossible", Action_Description, Impossible_Time),
        Impossible_Time = Time
        )),
    (get_assoc("causes", Action_Description, (_, Precondition)) -> logic_formula_satisfied(Precondition, Fluent_Assignments)
    ; true),
    (get_assoc("releases", Action_Description, (_, Precondition)) -> logic_formula_satisfied(Precondition, Fluent_Assignments)
    ; true).