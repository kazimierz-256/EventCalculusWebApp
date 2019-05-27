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
    put_assoc(F, Assoc, F_Value, Assoc_Including_F).

vary_fluents([], Fluent_Assignments, Fluent_Assignments).
vary_fluents([OCL, Occlusion_List], Fluent_Assignments, New_Assignment) :-
    get_assoc(OCL, Fluent_Assignments, _) ->
    (   del_assoc(OCL, Fluent_Assignments, _, Less_Fluent),
        vary_fluents(Occlusion_List, Less_Fluent, Less_New_Assignment),
        (put_assoc(OCL, Less_New_Assignment, true, New_Assignment) ; put_assoc(OCL, Less_New_Assignment, true, New_Assignment))
    )
    ;
    (
        vary_fluents(Occlusion_List, Fluent_Assignments, Less_New_Assignment),
        (put_assoc(OCL, Less_New_Assignment, true, New_Assignment) ; put_assoc(OCL, Less_New_Assignment, true, New_Assignment))
    )
    .


% THIS HERE IS TOTALLY NOT READY, shoud implement new assignment based on multiple conditions
% generate all possible assignments
% use the following predicate get_sample_fluent_assignment
% should determine all fluents taking part in: 
%   Fluent_Assignments
%   next time observation if any
%   occlusion list (already found)
% must satisfy:
%   the only variables that change in 2^n ways are those from Unique_Occlusion_List and those in upcoming observation
%       that are new, they're absent in Fluent assignments and occlusion
%   others must remain intact as in Fluent_Assignments
%   the conjunction of all consequences of MNS_Executed_Action (extract Consequence from compound_executable_atomic_get_assignment?)
%   Observation from next time must hold so if there are new fluents (they were smthing at the beginning but only now we know)

% input: Occlusion_List, Fluent_Assignments, Next_Observation
% output: New_Assignment
get_valid_assignment(Occlusion_List, Fluent_Assignments, Next_Observation, New_Assignment).
% use a similar technique like below but remember fluents from Next_Observation have the right to vary only if they do
%   exist neither in occlusion list nor in fluent assignments
% then check assignment using logic_formula_satisfied


% input: Occlusion_List, Fluent_Assignments
% output: New_Assignment
get_valid_assignment(Occlusion_List, Fluent_Assignments, New_Assignment) :-
    vary_fluents(Occlusion_List, Fluent_Assignments, New_Assignment).


get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, MNS_Executed_Action, New_Assignment) :-
    get_assoc(Time, Actions, ACS_Compound_Action) -> 
    (
        % assoc_to_list(Action_Domain, Action_Domain_List),
        findall(
            Action,
            (member(Action, ACS_Compound_Action), potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments, Action)),
            Compound_Action),
        dif(Compound_Action, []),
        get_nonempty_action_decomposition(Compound_Action, Time, Action_Domain, Fluent_Assignments, MNS_Executed_Action),
        findall(Fluent, (member(Action, Compound_Action), get_occlusion(Action, Action_Domain, Fluent)), Occlusion_List),
        sort(Occlusion_List, Unique_Occlusion_List),
        
        Next_Time = Time + 1,
        (get_assoc(Next_Time, Observations, Next_Observation) ->
            get_valid_assignment(Unique_Occlusion_List, Fluent_Assignments, Next_Observation, New_Assignment)
        ;
            get_valid_assignment(Unique_Occlusion_List, Fluent_Assignments, New_Assignment)
        )
    )
    ; 
    (
        MNS_Executed_Action = [],
        Next_Time = Time + 1,
        get_assoc(Next_Time, Observations, Next_Observation)
        ->  get_valid_assignment(Unique_Occlusion_List, Fluent_Assignments, Next_Observation, New_Assignment)
        ;   get_valid_assignment(Unique_Occlusion_List, Fluent_Assignments, New_Assignment)
        % WAIT, next condition must be satisfied!
    ;   Next_Time = Time + 1,
        (get_assoc(Next_Time, Observations, Next_Observation)
        ->  logic_formula_satisfied(Next_Observation, Fluent_Assignments),
            New_Assignment = Fluent_Assignments
        ;   New_Assignment = Fluent_Assignments
        )
    ).
    