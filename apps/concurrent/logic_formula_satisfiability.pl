:- module(logic_formula_satisfiability, 
    [
        logic_formula_satisfied/2
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
    get_assoc(FLUENT, FluentAssociationList, VALUE),
    VALUE.