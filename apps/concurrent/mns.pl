:- module(mns, 
    [
    
	]).

mns(ActionDomain, Time, PotentiallyExecutablesList, CompoundExecutablePredicate, Valid_mns) :-
    check_whether_compound_is_valid([], PotentiallyExecutablesList, CompoundExecutablePredicate, Result).

check_whether_compound_is_valid(IncludedActions, ConsideredActions, Pred, CompoundAction) :-
    append(IncludedActions, ConsideredActions, CompoundAction),
    (call(Pred, CompoundAction)
    ; check_smaller(IncludedActions, ConsideredActions, Pred, Result)).

check_smaller(IncludedActions, [Action|Rest], Pred, Result) :-
    append(IncludedActions, Action, ExtendedActions),
    check_whether_compound_is_valid(ExtendedActions, Rest, Pred, Result),
    check_whether_compound_is_valid(IncludedActions, Rest, Pred, Result),
    check_smaller(ExtendedActions, Rest, Pred, Result),
    check_smaller(IncludedActions, Rest, Pred, Result).