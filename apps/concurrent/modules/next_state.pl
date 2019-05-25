:- module(next_state, 
    [
	]).
:- use_module(mns).
:- use_module(compound_executable).

%compound_executable_atomic(Compound_Action, Time, Action_Domain, Fluent_Assignments)

get_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, Action_Decomposition) :-
    mns(Compound_Action, compound_executable_atomic(Time, Action_Domain, Fluent_Assignments), Action_Decomposition),
    dif(Action_Decomposition, []).
    % get MNS sample using compound executable

generate_new_assignment(Assignment, Fluent_Assignments, Occlusion_List, New_Assignment) :-
    % for each visible fluent
    % if it is in Assignment, there is no ambiguity
    % otherwise if it is in Occluesion List, there is ambiguity
    % otherwise keep Fluent_Assignments value
    findall(Fluent-Value, (
            get_assoc(Fluent, Assignment, Value) -> true
            ;
            (
                member(Fluent, Occlusion_List) ->
                    (Value = true ; Value = false)
                    ; get_assoc(Fluent, Fluent_Assignments, Value)
            )
        ), Assignments),
    list_to_assoc(Assignments, New_Assignment).
    
get_next_state(Time, Fluent_Assignments, Observations, ACS, Action_Domain, New_Assignment) :-

get_next_state(Time, Fluent_Assignments, Observations, ACS, Action_Domain, New_Assignment) :-
    get_assoc(Time, ACS, ACS_Compound_Action) -> 
    (
        (get_assoc(Time, Observations, Observation) -> logic_formula_satisfied(Observation, Fluent_Assignments) ; true),
        % assoc_to_list(Action_Domain, Action_Domain_List),
        findall(Action, 
            (member(Action, ACS_Compound_Action), potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments, Action))
            , Compound_Action),
        dif(Compound_Action, []),
        % could have duplicates
        findall(Fluent, (member(Action, Compound_Action), get_occlusion(Action, Action_Domain, Fluent)), Occlusion_List),
        sort(Occlusion_List, Unique_Occlusion_List),
        % get some MNS decomposition
        get_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, Sample_MNS_Decomposition),
        compound_executable_atomic_get_assignment(Time, Action_Domain, Fluent_Assignments, Sample_MNS_Decomposition, Assignment),
        % from assignment generate new state
        generate_new_assignment(Assignment, Fluent_Assignments, Unique_Occlusion_List, New_Assignment)
    
    )
    ; New_Assignment = Fluent_Assignments.
    