:- module(logic_formula_satisfiability, 
    [
        logic_formula_satisfied/2,
        getAssociationThatSatisfiesFormula/2
	]).

logic_formula_satisfied(FormulaLogicTree, FluentAssociationList) :-
    analyzeTree(FormulaLogicTree, FluentAssociationList).

analyzeTree(and(T1, T2), FluentAssociationList) :- 
    analyzeTree(T1, FluentAssociationList), analyzeTree(T2, FluentAssociationList).

analyzeTree(or(T1, T2), FluentAssociationList) :- 
    analyzeTree(T1, FluentAssociationList); analyzeTree(T2, FluentAssociationList).

analyzeTree(implies(T1, T2), FluentAssociationList) :- 
    not(analyzeTree(T1, FluentAssociationList)); analyzeTree(T2, FluentAssociationList).

analyzeTree(iff(T1, T2), FluentAssociationList) :- 
    analyzeTree(T1, FluentAssociationList) -> analyzeTree(T2, FluentAssociationList) ; not(analyzeTree(T2, FluentAssociationList)).

analyzeTree(negate(T), FluentAssociationList) :- 
    not(analyzeTree(T, FluentAssociationList)).

analyzeTree(FLUENT, FluentAssociationList) :- 
    string(FLUENT),
    get_assoc(FLUENT, FluentAssociationList, VALUE),
    VALUE.


getAssociationThatSatisfiesFormula(FormulaLogicTree, EnrichedFluentAssociationList):-
    empty_assoc(LIST),
    truth(FormulaLogicTree, LIST, EnrichedFluentAssociationList).

%TODO: remake so that truth/falsehood always return something but

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

truth(FLUENT, FluentAssociationList, EnrichedFluentAssociationList) :- 
    string(FLUENT),(
get_assoc(FLUENT, FluentAssociationList, VALUE) -> (VALUE, EnrichedFluentAssociationList = FluentAssociationList)
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

falsehood(FLUENT, FluentAssociationList, EnrichedFluentAssociationList) :- 
    string(FLUENT),(
    get_assoc(FLUENT, FluentAssociationList, VALUE) -> (not(VALUE), EnrichedFluentAssociationList = FluentAssociationList)
    ; put_assoc(FLUENT, FluentAssociationList, false, EnrichedFluentAssociationList)).
