:- module(logic_formula_satisfiability, 
    [
        logic_formula_satisfied/2,
        get_association_satisfying_formula/2,
        get_association_satisfying_formula/4,
        get_association_satisfying_formula_incomplete/2,
        get_association_satisfying_formula_incomplete/4
	]).

:- use_module(occlusion).


logic_formula_satisfied(Formula_Logic_Tree, Fluent_Association_List) :-
    truth(Formula_Logic_Tree, Fluent_Association_List, Fluent_Association_List).

remove_ocl([], Pre_Assigned_Fluents, Pre_Assigned_Fluents).
remove_ocl([Ocl | Occlusion_List], Pre_Assigned_Fluents, Initial_Assignment) :-
    remove_ocl(Occlusion_List, Pre_Assigned_Fluents, Pre_Init),
    (get_assoc(Ocl, Pre_Init, _)
    -> del_assoc(Ocl, Pre_Init, _, Initial_Assignment)
    ; Initial_Assignment = Pre_Init
    ).

flipped_no_get_assoc(Assoc_List, Element) :- not(get_assoc(Element, Assoc_List, _)).

get_association_satisfying_formula_incomplete(Occlusion_List, Pre_Assigned_Fluents, Formula_Logic_Tree, Final_Association) :-
    remove_ocl(Occlusion_List, Pre_Assigned_Fluents, Initial_Assignment),
    truth(Formula_Logic_Tree, Initial_Assignment, Final_Association).

get_association_satisfying_formula(Occlusion_List, Pre_Assigned_Fluents, Formula_Logic_Tree, Final_Association) :-
    get_association_satisfying_formula_incomplete(Occlusion_List, Pre_Assigned_Fluents, Formula_Logic_Tree, Enriched_Fluent_Association_List),
    include(flipped_no_get_assoc(Enriched_Fluent_Association_List), Occlusion_List, Missing_Fluents),
    added_missing_fluents(Enriched_Fluent_Association_List, Missing_Fluents, Final_Association).

added_missing_fluents(Assoc_List, [], Assoc_List).
added_missing_fluents(Assoc_List, [M | Missing], Final_Assoc) :-
    added_missing_fluents(Assoc_List, Missing, Pre_Fin_Assoc),
    (
        put_assoc(M, Pre_Fin_Assoc, true, Final_Assoc)
        ; put_assoc(M, Pre_Fin_Assoc, false, Final_Assoc)
    ).

get_association_satisfying_formula(Formula_Logic_Tree, Final_Association):-
    empty_assoc(List),
    get_all_fluents_from_tree(Formula_Logic_Tree, Unique_Fluents),
    get_association_satisfying_formula(Unique_Fluents, List, Formula_Logic_Tree, Final_Association).

get_association_satisfying_formula_incomplete(Formula_Logic_Tree, Final_Association):-
    empty_assoc(List),
    get_all_fluents_from_tree(Formula_Logic_Tree, Unique_Fluents),
    get_association_satisfying_formula_incomplete(Unique_Fluents, List, Formula_Logic_Tree, Final_Association).

% TODO Kazimierz
% Sometime think about iterative assigning and each time check for reassignment for the tree...?
% 1. Get next variable to define
% 2. Reduce tree
% 3. Check if tree is empty, if it is, end defining
% 4. Repeat step 1.
truth(and(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    truth(T1, Fluent_Association_List, Enriched_Fluent_Association_List1), truth(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List).

truth(or(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    truth(T1, Fluent_Association_List, Enriched_Fluent_Association_List); truth(T2, Fluent_Association_List, Enriched_Fluent_Association_List).

truth(implies(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    falsehood(T1, Fluent_Association_List, Enriched_Fluent_Association_List); truth(T2, Fluent_Association_List, Enriched_Fluent_Association_List).

truth(iff(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    truth(T1, Fluent_Association_List, Enriched_Fluent_Association_List1) , truth(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List)
    ; falsehood(T2, Fluent_Association_List, Enriched_Fluent_Association_List1), falsehood(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List).

truth(negate(T), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    falsehood(T, Fluent_Association_List, Enriched_Fluent_Association_List).

truth(true, Fluent_Association_List, Fluent_Association_List).

truth(FLUENT, Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    string(FLUENT),
    (get_assoc(FLUENT, Fluent_Association_List, VALUE) -> (VALUE = true, Enriched_Fluent_Association_List = Fluent_Association_List)
    ; put_assoc(FLUENT, Fluent_Association_List, true, Enriched_Fluent_Association_List)).

falsehood(and(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    falsehood(T1, Fluent_Association_List, Enriched_Fluent_Association_List); falsehood(T2, Fluent_Association_List, Enriched_Fluent_Association_List).
falsehood(or(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    falsehood(T1, Fluent_Association_List, Enriched_Fluent_Association_List1), falsehood(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List).
falsehood(implies(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    truth(T1, Fluent_Association_List, Enriched_Fluent_Association_List1), falsehood(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List).
falsehood(iff(T1, T2), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
truth(T1, Fluent_Association_List, Enriched_Fluent_Association_List1) , falsehood(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List)
; falsehood(T2, Fluent_Association_List, Enriched_Fluent_Association_List1), truth(T2, Enriched_Fluent_Association_List1, Enriched_Fluent_Association_List).
falsehood(negate(T), Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    truth(T, Fluent_Association_List, Enriched_Fluent_Association_List).
falsehood(false, Fluent_Association_List, Fluent_Association_List).
falsehood(FLUENT, Fluent_Association_List, Enriched_Fluent_Association_List) :- 
    string(FLUENT),
    (get_assoc(FLUENT, Fluent_Association_List, VALUE) -> (VALUE = false, Enriched_Fluent_Association_List = Fluent_Association_List)
    ; put_assoc(FLUENT, Fluent_Association_List, false, Enriched_Fluent_Association_List)).
