:- module(next_state, 
    [
	]).
:- use_module(mns).
:- use_module(compound_executable).

%compound_executable_atomic(Compound_Action, Time, Action_Domain, Fluent_Assignments)

get_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, Action_Decomposition) :-
    mns(Compound_Action, compound_executable_atomic(Time, Action_Domain, Fluent_Assignments), Action_Decomposition).
    % get MNS sample using compound executable

generate_new_state(Assignment, Fluent_Assignments, Occlusion_List, New_Assignment) :-
    % for each visible fluent
    % if it is in Assignment, there is no ambiguity
    % otherwise if it is in Occluesion List, there is ambiguity
    % otherwise keep Fluent_Assignments value
    findall(Fluent-Value, (
        get_assoc(Fluent, Assignment, Value)
        ;
        (
            not(get_assoc(Fluent, Assignment, _)),
            (
                member(Fluent, Occlusion_List),
                (Value = true ; Value = false)
                ;
                not(member(Fluent, Occlusion_List)),
                get_assoc(Fluent, Fluent_Assignments, Value),
                )
            )
        ), Assignments),
    list_to_assoc(Assignments, New_Assignment).
    


get_next_state(Time, Fluent_Assignments, Observations, Action_Domain, New_Assignment) :-
    (
        not(get_assoc(Time, Observations, _))
        ;
        (get_assoc(Time, Observations, Observation), logic_formula_satisfied(Observation, Fluent_Assignments))
    ),
    % get compound action
    assoc_to_list(Action_Domain, Action_Domain_List),
    findall(Action, list_potentially_executable_atomic(Time, Action_Domain_List, Fluent_Assignments, Action), Compound_Action),
    dif(Compound_Action, []),
    findall(Fluent, (member(Action, Compound_Action), get_occlusion(Action, Action_Domain, Fluent)), Occlusion_List),
    % get some MNS decomposition
    get_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, Sample_MNS_Decomposition),
    compound_executable_atomic_get_assignment(Time, Action_Domain, Fluent_Assignments, Sample_MNS_Decomposition, Assignment),
    % from assignment generate new state
    generate_new_state(Assignment, Fluent_Assignments, Occlusion_List, New_Assignment).
    