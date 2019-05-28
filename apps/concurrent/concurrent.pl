:- module(concurrent, 
    [
        logic_tree_from_text/2,
        logic_formula_satisfied/2,
        run_scenario/3
	]).

:- use_module("modules/logic_tree_parsing.pl").
:- use_module("modules/logic_formula_satisfiability.pl").
:- use_module("modules/mns.pl").
:- use_module("modules/potentially_executable.pl").
:- use_module("modules/user_input_parsing.pl").
:- use_module("modules/query_parsing.pl").
:- use_module("modules/next_state.pl").
:- use_module("modules/warsaw_standoff.pl").
:- use_module("modules/occlusion.pl").
:- use_module("modules/compound_executable.pl").


exists_valid_state_at_time(Maxtime, Maxtime1, _, _, _, _) :- Maxtime =:= Maxtime1.

exists_valid_state_at_time(Maxtime, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :- 
    Time < Maxtime,
    get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
    Next_Time is Time + 1,
    exists_valid_state_at_time(Maxtime, Next_Time, New_Assignment, Observations, Actions, Action_Domain).


exists_state_without_future(Maxtime, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :-
    Time < Maxtime,
    (
        not(get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, _))
        ;
        (
            % write("exists_state"),
            get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
            Next_Time is Time + 1,
            exists_state_without_future(Maxtime, Next_Time, New_Assignment, Observations, Actions, Action_Domain)
        )
    ).


sublist([], _).
sublist([L|L1], [R,R1]) :- L=R, sublist(L1, R1).


exists_state_at_query_time_supporting_condition(Query_Condition, Query_Time, Time, Fluent_Assignments, _, _, _) :-
    Query_Time =:= Time,
    logic_formula_satisfied(Query_Condition, Fluent_Assignments).

exists_state_at_query_time_supporting_condition(Query_Condition, Query_Time, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :-
    Time < Query_Time,
    get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
    Next_Time is Time + 1,
    exists_state_at_query_time_supporting_condition(Query_Condition, Query_Time, Next_Time, New_Assignment, Observations, Actions, Action_Domain). 


exists_state_at_query_time_invalidating_condition(Query_Condition, Query_Time, Time, Fluent_Assignments, _, _, _) :-
    Query_Time =:= Time,
    not(logic_formula_satisfied(Query_Condition, Fluent_Assignments)).

exists_state_at_query_time_invalidating_condition(Query_Condition, Query_Time, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :-
    Time < Query_Time,
    get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
    write("time: "),
    writeln(Time),
    write("new assignment: "),
    writeln(New_Assignment),
    Next_Time is Time + 1,
    exists_state_at_query_time_invalidating_condition(Query_Condition, Query_Time, Next_Time, New_Assignment, Observations, Actions, Action_Domain). 


exists_state_at_query_time_that_could_not_execute_action(Query_Action, Query_Time, Time, Fluent_Assignments, _, _, Action_Domain) :-
    Query_Time =:= Time,
    maplist(potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments), Query_Action)
    ->  not(compound_executable_atomic(Time, Action_Domain, Fluent_Assignments, Query_Action))
    ;   true.

exists_state_at_query_time_that_could_not_execute_action(Query_Action, Query_Time, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :-
    Time < Query_Time,
    get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
    Next_Time is Time + 1,
    exists_state_at_query_time_that_could_not_execute_action(Query_Action, Query_Time, Next_Time, New_Assignment, Observations, Actions, Action_Domain).


exists_state_at_query_time_executing_action(Query_Action, Query_Time, Time, Fluent_Assignments, _, _, Action_Domain) :-
    Query_Time =:= Time,
    maplist(potentially_executable_atomic(Time, Action_Domain, Fluent_Assignments), Query_Action),
    compound_executable_atomic(Time, Action_Domain, Fluent_Assignments, Query_Action).

exists_state_at_query_time_executing_action(Query_Action, Query_Time, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :-
    Time < Query_Time,
    get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
    Next_Time is Time + 1,
    exists_state_at_query_time_executing_action(Query_Action, Query_Time, Next_Time, New_Assignment, Observations, Actions, Action_Domain).


get_sample_fluent_assignment([], Assoc) :- empty_assoc(Assoc).
get_sample_fluent_assignment([F|Fluents], Assoc_Including_F) :-
    get_sample_fluent_assignment(Fluents, Assoc),
    (F_Value = true ; F_Value = false),
    put_assoc(F, Assoc, F_Value, Assoc_Including_F).

prepare_initial_state_time_0(Observations, Action_Domain, Initial_State) :-
    findall(Fluent, (
            gen_assoc(_, Observations, Observation),
            get_sample_fluent_from_tree(Observation, Fluent)
        ;
            gen_assoc(_, Action_Domain, Action_Description),
            (
                get_assoc("causes", Action_Description, (Causes_Condition, Precondition)),
                (get_sample_fluent_from_tree(Causes_Condition, Fluent); get_sample_fluent_from_tree(Precondition, Fluent))
            ;
                get_assoc("releases", Action_Description, (Release_Fluent, Precondition)),
                (Fluent = Release_Fluent; get_sample_fluent_from_tree(Precondition, Fluent))
            
            )
        ), Fluents),
    sort(Fluents, Unique_Fluents),
    get_sample_fluent_assignment(Unique_Fluents, Initial_State),
    (get_assoc(0, Observations, Initial_Observation)
    ->
        logic_formula_satisfied(Initial_Observation, Initial_State)
    ; true).


% outputs nothing, succeeds iff the scenario is possibly executable
run_scenario((Observations, Actions), Action_Domain, possibly_executable) :-
    writeln("possibly executable scenario"),
    %TODO should we care about observations later than (1+last planned action moment)
    max_assoc(Actions, Last_Action_Time, _),
    Maxtime_ACS = Last_Action_Time + 1,
    max_assoc(Observations, Last_Observaiotn_Time, _),
    Maxtime_OBS = Last_Observaiotn_Time,
    Maxtime = max(Maxtime_ACS, Maxtime_OBS),
    once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_valid_state_at_time(Maxtime, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    ).

% outputs nothing, succeeds iff the scenario is necessarily executable
run_scenario((Observations, Actions), Action_Domain, necessarily_executable) :-
    writeln("necessarily executable scenario"),
    %TODO should we care about observations later than (1+last planned action moment)
    max_assoc(Actions, Last_Action_Time, _),
    Maxtime_ACS = Last_Action_Time + 1,
    max_assoc(Observations, Last_Observaiotn_Time, _),
    Maxtime_OBS = Last_Observaiotn_Time,
    Maxtime = max(Maxtime_ACS, Maxtime_OBS),
    once(prepare_initial_state_time_0(Observations, Action_Domain, _)),
    not(once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_without_future(Maxtime, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    )).

run_scenario((Observations, Actions), Action_Domain, necessarily_accessible(Query_Condition, Query_Time)) :-
    writeln("necessarily accessible gamma at t"),
    once(prepare_initial_state_time_0(Observations, Action_Domain, _)),
    not(once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_without_future(Query_Time, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    )),
    not(once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_at_query_time_invalidating_condition(Query_Condition, Query_Time, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    )).

run_scenario((Observations, Actions), Action_Domain, possibly_accessible(Query_Condition, Query_Time)) :-
    writeln("possibly accessible gamma at t"),
    once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_at_query_time_supporting_condition(Query_Condition, Query_Time, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    ).

run_scenario((Observations, Actions), Action_Domain, necessarily_executable(Query_Action, Query_Time)) :-
    writeln("necessarily executable A at t"),
    once(prepare_initial_state_time_0(Observations, Action_Domain, _)),
    not(once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_without_future(Query_Time, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    )),
    not(once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_at_query_time_that_could_not_execute_action(Query_Action, Query_Time, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    )).

run_scenario((Observations, Actions), Action_Domain, possibly_executable(Query_Action, Query_Time)) :-
    writeln("possibly executable A at t"),
    once(
        (
            prepare_initial_state_time_0(Observations, Action_Domain, Initial_State),
            exists_state_at_query_time_executing_action(Query_Action, Query_Time, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    ).
