:- module(mns, 
    [
        mns/3
	]).

% returns some valid mns use findall to find them all
mns(PotentiallyExecutablesList, IsCompoundExecutablePredicate, Some_Valid_MNS) :-
    dif(Some_Valid_MNS, []),
    check_whether_compound_is_valid([], PotentiallyExecutablesList, IsCompoundExecutablePredicate, Some_Valid_MNS).
    % is the program still valid when there is no dif?

check_whether_compound_is_valid(IncludedActions, ConsideredActions, IsCompoundExecutablePredicate, [CompoundAction]) :-
    append(IncludedActions, ConsideredActions, CompoundAction),
    call(IsCompoundExecutablePredicate, CompoundAction).

check_whether_compound_is_valid(IncludedActions, ConsideredActions, IsCompoundExecutablePredicate, Some_Valid_MNS) :-
    append(IncludedActions, ConsideredActions, CompoundAction),
    not(call(IsCompoundExecutablePredicate, CompoundAction)),
    check_without_first_considering(IncludedActions, ConsideredActions, IsCompoundExecutablePredicate, Some_Valid_MNS).

check_without_first_considering(IncludedActions, [], IsCompoundExecutablePredicate, [IncludedActions]) :-
    call(IsCompoundExecutablePredicate, IncludedActions).

check_without_first_considering(IncludedActions, [Action|Rest], IsCompoundExecutablePredicate, Some_Valid_MNS) :-
    append(IncludedActions, Action, ExtendedActions),
    (check_whether_compound_is_valid(ExtendedActions, Rest, IsCompoundExecutablePredicate, Some_Valid_MNS)
    ; check_without_first_considering(IncludedActions, Rest, IsCompoundExecutablePredicate, Some_Valid_MNS)).