:- module(mns, 
    [
        mns/3
	]).

mns(PotentiallyExecutablesList, IsCompoundExecutablePredicate, AllValidMNS) :-
    check_whether_compound_is_valid([], PotentiallyExecutablesList, IsCompoundExecutablePredicate, AllValidMNS).

check_whether_compound_is_valid(IncludedActions, ConsideredActions, IsCompoundExecutablePredicate, ValidMNS) :-
    append(IncludedActions, ConsideredActions, CompoundAction),
    (call(IsCompoundExecutablePredicate, CompoundAction) -> ValidMNS = [CompoundAction]
     ; check_without_first_considering(IncludedActions, ConsideredActions, IsCompoundExecutablePredicate, ValidMNS)).

check_without_first_considering(IncludedActions, [], IsCompoundExecutablePredicate, ValidMNS) :-
    call(IsCompoundExecutablePredicate, IncludedActions) -> ValidMNS = [IncludedActions] ; ValidMNS = [].

check_without_first_considering(IncludedActions, [Action|Rest], IsCompoundExecutablePredicate, ValidMNS) :-
    append(IncludedActions, Action, ExtendedActions),
    check_whether_compound_is_valid(ExtendedActions, Rest, IsCompoundExecutablePredicate, ValidMNS1),
    check_without_first_considering(IncludedActions, Rest, IsCompoundExecutablePredicate, ValidMNS2),
    append(ValidMNS1, ValidMNS2, ValidMNS).