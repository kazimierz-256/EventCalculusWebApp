:- module(mns, 
    [
        mns/5
	]).

:- use_module(compound_executable).


% returns some valid mns use findall to find them all
mns(PotentiallyExecutablesList, Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS) :-
    check_whether_compound_is_valid([], PotentiallyExecutablesList, Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS).
    % is the program still valid when there is no dif?

% check_whether_compound_is_valid(IncludedActions, ConsideredActions, Time, Action_Domain, Fluent_Assignments, CompoundAction) :-
%     append(IncludedActions, ConsideredActions, CompoundAction),
%     compound_executable(Time, Action_Domain, Fluent_Assignments, CompoundAction).

check_whether_compound_is_valid(IncludedActions, ConsideredActions, Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS) :-
    append(IncludedActions, ConsideredActions, CompoundAction),
    (compound_executable(Time, Action_Domain, Fluent_Assignments, CompoundAction) ->
        Some_Valid_MNS = CompoundAction
    ;
        check_without_first_considering(IncludedActions, ConsideredActions, Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS)
    ).

check_without_first_considering(IncludedActions, [Action|Rest], Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS) :-
    append(IncludedActions, Action, ExtendedActions),
    (check_without_first_considering(ExtendedActions, Rest, Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS)
    ; check_whether_compound_is_valid(IncludedActions, Rest, Time, Action_Domain, Fluent_Assignments, Some_Valid_MNS)).