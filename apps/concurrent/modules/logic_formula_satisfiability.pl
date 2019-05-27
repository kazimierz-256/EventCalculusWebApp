:- module(logic_formula_satisfiability, 
    [
        logic_formula_satisfied/2,
        getAssociationThatSatisfiesFormula/2
	]).

logic_formula_satisfied(FormulaLogicTree, FluentAssociationList) :-
    truth(FormulaLogicTree, FluentAssociationList, FluentAssociationList).

getAssociationThatSatisfiesFormula(FormulaLogicTree, EnrichedFluentAssociationList):-
    empty_assoc(LIST),
    truth(FormulaLogicTree, LIST, EnrichedFluentAssociationList).

% TODO Kazimierz
% Sometime think about iterative assigning and each time check for reassignment for the tree...?
% 1. Get next variable to define
% 2. Reduce tree
% 3. Check if tree is empty, if it is, end defining
% 4. Repeat step 1.
truth(and(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    truth(T1, FluentAssociationList, EnrichedFluentAssociationList1), truth(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList).

truth(or(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    truth(T1, FluentAssociationList, EnrichedFluentAssociationList); truth(T2, FluentAssociationList, EnrichedFluentAssociationList).

truth(implies(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    falsehood(T1, FluentAssociationList, EnrichedFluentAssociationList); truth(T2, FluentAssociationList, EnrichedFluentAssociationList).

truth(iff(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    truth(T1, FluentAssociationList, EnrichedFluentAssociationList1) , truth(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList)
    ; falsehood(T2, FluentAssociationList, EnrichedFluentAssociationList1), falsehood(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList).

truth(negate(T), FluentAssociationList, EnrichedFluentAssociationList) :- 
    falsehood(T, FluentAssociationList, EnrichedFluentAssociationList).

truth(true, FluentAssociationList, FluentAssociationList).

truth(FLUENT, FluentAssociationList, EnrichedFluentAssociationList) :- 
    string(FLUENT),
    (get_assoc(FLUENT, FluentAssociationList, VALUE) -> (VALUE = true, EnrichedFluentAssociationList = FluentAssociationList)
    ; put_assoc(FLUENT, FluentAssociationList, true, EnrichedFluentAssociationList)).

falsehood(and(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    falsehood(T1, FluentAssociationList, EnrichedFluentAssociationList); falsehood(T2, FluentAssociationList, EnrichedFluentAssociationList).
falsehood(or(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    falsehood(T1, FluentAssociationList, EnrichedFluentAssociationList1), falsehood(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList).
falsehood(implies(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
    truth(T1, FluentAssociationList, EnrichedFluentAssociationList1), falsehood(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList).
falsehood(iff(T1, T2), FluentAssociationList, EnrichedFluentAssociationList) :- 
truth(T1, FluentAssociationList, EnrichedFluentAssociationList1) , falsehood(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList)
; falsehood(T2, FluentAssociationList, EnrichedFluentAssociationList1), truth(T2, EnrichedFluentAssociationList1, EnrichedFluentAssociationList).
falsehood(negate(T), FluentAssociationList, EnrichedFluentAssociationList) :- 
    truth(T, FluentAssociationList, EnrichedFluentAssociationList).
falsehood(false, FluentAssociationList, FluentAssociationList).
falsehood(FLUENT, FluentAssociationList, EnrichedFluentAssociationList) :- 
    string(FLUENT),
    (get_assoc(FLUENT, FluentAssociationList, VALUE) -> (VALUE = false, EnrichedFluentAssociationList = FluentAssociationList)
    ; put_assoc(FLUENT, FluentAssociationList, false, EnrichedFluentAssociationList)).
