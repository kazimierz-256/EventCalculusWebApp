:- module(next_state, 
    [
        get_next_state/7
	]).
:- use_module(mns).
:- use_module(compound_executable).
:- use_module(occlusion).
:- use_module(potentially_executable).
:- use_module(logic_formula_satisfiability).

%compound_executable_atomic(Compound_Action, Time, Action_Domain, Fluent_Assignments)

get_nonempty_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, Action_Decomposition) :-
    mns(Compound_Action, Time, Action_Domain, Fluent_Assignments, Action_Decomposition),
    dif(Action_Decomposition, []).
    % get MNS sample using compound executable


conjunct(Statement, [], Statement).
conjunct(Statement, Acc1, and(Statement, Acc1)).

get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, MNS_Executed_Action, New_Assignment) :-
    get_assoc(Time, Actions, ACS_Compound_Action)
    ->  (
            findall(
                Action,
                (
                    member(Action, ACS_Compound_Action),
                    potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments, Action)
                ),
                Potentailly_Executable_Subset),
            dif(Potentailly_Executable_Subset, []),
            get_nonempty_action_decomposition(Potentailly_Executable_Subset, Time, Action_Domain, Fluent_Assignments, MNS_Executed_Action),
            findall(
                Fluent,
                get_total_occlusion(MNS_Executed_Action, Action_Domain, Fluent),
                Occlusion_List
            ),
            sort(Occlusion_List, Unique_Occlusion_List),
            Next_Time is Time + 1,
            findall(
                Causes_Condition,
                (
                    member(Action, MNS_Executed_Action),
                    get_assoc(Action, Action_Domain, Action_Description),
                    get_assoc("causes", Action_Description, (Causes_Condition, _))
                ),
                Causes_Conditions
            ),
            foldl(conjunct, Causes_Conditions, true, Consequence),
            (
                get_assoc(Next_Time, Observations, Next_Observation)
                ->  get_association_satisfying_formula(Unique_Occlusion_List, Fluent_Assignments, and(Consequence, Next_Observation), New_Assignment)
                ;   get_association_satisfying_formula(Unique_Occlusion_List, Fluent_Assignments, Consequence, New_Assignment)
            )
        )
    ;   (
            MNS_Executed_Action = [],
            Next_Time is Time + 1,
            (
                get_assoc(Next_Time, Observations, Next_Observation)
                ->  logic_formula_satisfied(Next_Observation, Fluent_Assignments),
                    New_Assignment = Fluent_Assignments
                ;   New_Assignment = Fluent_Assignments
            )
        ).