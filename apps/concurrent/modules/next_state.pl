:- module(next_state, 
    [
        get_next_state/7,
        get_sample_fluent_assignment/2
	]).
:- use_module(mns).
:- use_module(compound_executable).
:- use_module(occlusion).

%compound_executable_atomic(Compound_Action, Time, Action_Domain, Fluent_Assignments)

get_nonempty_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, Action_Decomposition) :-
    mns(Compound_Action, compound_executable_atomic(Time, Action_Domain, Fluent_Assignments), Action_Decomposition),
    dif(Action_Decomposition, []).
    % get MNS sample using compound executable

get_sample_fluent_assignment([], Assoc) :- empty_assoc(Assoc).
get_sample_fluent_assignment([F|Fluents], Assoc_Including_F) :-
    get_sample_fluent_assignment(Fluents, Assoc),
    (F_Value = true ; F_Value = false),
    put_assoc(F, A, F_Value, Assoc_Including_F).

% generate_new_assignment(Assignment, Fluent_Assignments, Occlusion_List, New_Assignment) :-
%     % for each visible fluent
%     % if it is in Assignment, there is no ambiguity
%     % otherwise if it is in Occluesion List, there is ambiguity
%     % otherwise keep Fluent_Assignments value
%     findall(Fluent-Value, (
%             get_assoc(Fluent, Assignment, Value) -> true
%             ;
%             (
%                 member(Fluent, Occlusion_List) ->
%                     (Value = true ; Value = false)
%                     ; get_assoc(Fluent, Fluent_Assignments, Value)
%             )
%         ), Assignments),
%     list_to_assoc(Assignments, New_Assignment).

% THIS HERE IS TOTALLY NOT READY, shoud implement new assignment based on multiple conditions
get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, MNS_Executed_Action, New_Assignment) :-
    % (get_assoc(Time, Observations, Observation) -> logic_formula_satisfied(Observation, Fluent_Assignments) ; true),
    (get_assoc(Time, Actions, ACS_Compound_Action) -> 
    (
        % assoc_to_list(Action_Domain, Action_Domain_List),
        findall(Action, 
            (member(Action, ACS_Compound_Action), potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments, Action))
            , Compound_Action),
        dif(Compound_Action, []),
        get_nonempty_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, MNS_Executed_Action),
        findall(Fluent, (member(Action, Compound_Action), get_occlusion(Action, Action_Domain, Fluent)), Occlusion_List),
        sort(Occlusion_List, Unique_Occlusion_List),
        
        % generate all possible assignments
        % use the following predicate get_sample_fluent_assignment
        % should determine all fluents taking part in: 
        %   Fluent_Assignments
        %   next time observation if any
        %   occlusion list (already found)
        % must satisfy:
        %  the only variables that change in 2^n ways are those from Unique_Occlusion_List and those in upcoming observation that are new, they're absent in Fluent assignments and occlusion
        %  others must remain intact as in Fluent_Assignments
        %  the conjunction of all consequences of MNS_Executed_Action (extract Consequence from compound_executable_atomic_get_assignment?)
        %  Observation from next time must hold so if there are new fluents (they were smthing at the beginning but only now we know)
        Next_Time = Time + 1,
        (get_assoc(Next_Time, Observations, Next_Observation) ->
            get_valid_assignment(Unique_Occlusion_List, Fluent_Assignments, Next_Observation, New_Assignment).
        ;
            empty_assoc(No_Observation),
            get_valid_assignment(Unique_Occlusion_List, Fluent_Assignments, No_Observation, New_Assignment).
        )
    )
    % WAIT, next condition must be satisfied!
    ; New_Assignment = Fluent_Assignments).
    