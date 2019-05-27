:- module(concurrent, 
    [
        logic_tree_from_text/2,
        logic_formula_satisfied/2
	]).


:- use_module("modules/debug_module.pl").
:- use_module("modules/logic_tree_parsing.pl").
:- use_module("modules/logic_formula_satisfiability.pl").
:- use_module("modules/mns.pl").
:- use_module("modules/potentially_executable.pl").
:- use_module("modules/user_input_parsing.pl").
:- use_module("modules/query_parsing.pl").
:- use_module("modules/next_state.pl").
:- use_module("modules/warsaw_standoff.pl").
:- use_module("modules/occlusion.pl").

exists_valid_state_at_time(Maxtime, Maxtime, _, _, _, _).

exists_valid_state_at_time(Maxtime, Time, Fluent_Assignments, Observations, Actions, Action_Domain) :- 
    Time < Maxtime,
    get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
    Next_Time = Time + 1,
    exists_valid_state_at_time(Maxtime, Next_Time, New_Assignment, Observations, Actions, Action_Domain).

exists_state_without_future(Maxtime, Time, Initial_State, Observations, Actions, Action_Domain) :-
    Time < Maxtime,
    (
        not(get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, _))
        ;
        (
            get_next_state(Time, Fluent_Assignments, Observations, Actions, Action_Domain, _, New_Assignment),
            Next_Time = Time + 1,
            exists_state_without_future(Maxtime, Next_Time, New_Assignment, Observations, Actions, Action_Domain)
        )
    ).
    

get_sample_fluent_assignment([], Assoc) :- empty_assoc(Assoc).
get_sample_fluent_assignment([F|Fluents], Assoc_Including_F) :-
    get_sample_fluent_assignment(Fluents, Assoc),
    (F_Value = true ; F_Value = false),
    put_assoc(F, Assoc, F_Value, Assoc_Including_F).

prepare_initial_state_time_0(Observations, Initial_State) :-
    %generate all valid assignments
    get_assoc(0, Observations, Initial_Observation)
     ->
        get_all_fluents_from_tree(Initial_Observation, Fluents),
        get_sample_fluent_assignment(Fluents, Initial_State),
        % getAssociationThatSatisfiesFormula(Initial_Observation, Initial_State),
        logic_formula_satisfied(Initial_Observation, Initial_State)
    ;   empty_assoc(Initial_State).

% outputs nothing, succeeds iff the scenario is possibly executable
run_scenario((Observations, Actions), Domain, possibly_executable) :-
    writeln("possibly executable scenario"),
    %TODO should we care about observations later than (1+last planned action moment)
    max_assoc(Actions, Last_Action_Time, _),
    Maxtime_ACS = Last_Action_Time + 1,
    max_assoc(Observations, Last_Observaiotn_Time, _),
    Maxtime_OBS = Last_Observaiotn_Time,
    Maxtime = max(Maxtime_ACS, Maxtime_OBS),
    once(
        (
            prepare_initial_state_time_0(Observations, Initial_State),
            exists_valid_state_at_time(Maxtime, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    ).

% outputs nothing, succeeds iff the scenario is necessarily executable
run_scenario((Observations, Actions), Domain, necessarily_executable) :-
    writeln("necessarily executable scenario"),
    %TODO should we care about observations later than (1+last planned action moment)
    max_assoc(Actions, Last_Action_Time, _),
    Maxtime_ACS = Last_Action_Time + 1,
    max_assoc(Observations, Last_Observaiotn_Time, _),
    Maxtime_OBS = Last_Observaiotn_Time,
    Maxtime = max(Maxtime_ACS, Maxtime_OBS),
    once(prepare_initial_state_time_0(Observations, _)),
    writeln("udalo sie"),
    not(once(
        (
            prepare_initial_state_time_0(Observations, Initial_State),
            exists_state_without_future(Maxtime, 0, Initial_State, Observations, Actions, Action_Domain)
        )
    )).

% not yet ready, thought out
% run_scenario((Observations, Actions), Domain, necessarily_executable(Query_Actions, Time)) :-
%     writeln("necessarily executable A at t when scenario"),
%     %TODO should we care about observations later than (1+last planned action moment)
%     max_assoc(Actions, Last_Action_Time, _),
%     Maxtime = Last_Action_Time + 1,
%     once(prepare_initial_state_time_0(Observations, _)),
%     not((
%         once(
%             prepare_initial_state_time_0(Observations, Initial_State),
%             exists_state_without_future(Maxtime, 0, Initial_State, Observations, Actions, Action_Domain)
%         )
%     )).



run_query(possibly_executable()) :-
    writeln("possibly executable scenario").

run_query(necessarily_accessible(Tree, Time)) :-
    writeln("possibly accessible gamma at t").

run_query(necessarily_executable(List, Time)) :-
    writeln("possibly accessible gamma at t").

run_query(possibly_executable(List, Time)) :-
    writeln("possibly accessible gamma at t").


:-  warsaw_standoff_domain(Domain),
    warsaw_standoff_scenario(Scenario),
%    get_query_from_text(Query, "necessarily executable SHOOT12, SHOOT31, SHOOT51 at 5"),
    get_query_from_text(Query, "necessarily executable"),
    run_scenario(Scenario, Domain, Query).