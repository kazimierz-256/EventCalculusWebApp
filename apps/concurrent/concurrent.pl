:- module(concurrent, 
    [   rw/3,
        logic_tree_from_text/2,
        logic_formula_satisfied/2
	]).


:- use_module("/modules/debug_module.pl").
:- use_module("/modules/logic_tree_parsing.pl").
:- use_module("/modules/logic_formula_satisfiability.pl").
:- use_module("/modules/mns.pl").
:- use_module("/modules/potentially_executable.pl").

% Kazik

rw(ACTION_DOMAIN, SCENARIO, QUERY):-
    ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.

% possiblyExecutableScenario(+ACTION_DOMAIN, +SCENARIO, -VALID_MODEL) :- 
% 	getMaximumDefinedTime(SCENARIO, MAXTIME),
% 	model(ACTION_DOMAIN, SCENARIO, MAXTIME, VALID_MODEL, false).

% model(+ACTION_DOMAIN, +SCENARIO, 0, -[INITIAL_STATE]) :- .

% model(+ACTION_DOMAIN, +SCENARIO, +T, +ONLY_EXECUTABLE_MODELS, -NEW_MODEL) :-
% 	model(ACTION_DOMAIN, SCENARIO, T-1, ONLY_EXECUTABLE_MODELS, PREVIOUS_MODEL),
% 	(ONLY_EXECUTABLE_MODELS = true ->
% 	nextValidModel(ACTION_DOMAIN, SCENARIO, T, NEW_MODEL, ONLY_EXECUTABLE_MODELS)
% 	; nextValidModel(ACTION_DOMAIN, SCENARIO, T, NEW_MODEL, ONLY_EXECUTABLE_MODELS) ; PREVIOUS_MODEL).

% nextValidModel(ACTION_DOMAIN, SCENARIO, T, NEW_MODEL, ONLY_EXECUTABLE_MODELS).

% assignementSatisfyingConstraint(CONSTRAINT_LOGIC_TREE, ASSIGNMENT) :-
% 	extractFluents(CONSTRAINT_LOGIC_TREE, FLUENTS),

% state(TIME, FLUENT_ASSIGNMENTS)

% Ola

domain(LIST, DOMAIN) :-
    list_to_assoc(LIST, DOMAIN).

put_into_domain(KEY, VALUE, DOMAIN, NEW_DOMAIN) :-
   	put_assoc(KEY, DOMAIN, VALUE, NEW_DOMAIN).

get_from_domain(KEY, DOMAIN, VALUE) :-
    get_assoc(KEY, DOMAIN, VALUE).

% TODO rewrite this at the very end
run_scenario([], _, Time).
run_scenario([(_, Action)|T], DOMAIN, Time) :-
    get_from_domain(Action, DOMAIN, VALUE),
    % TODO: make sure state changes are allowed when causes/releases action is executed
    run_scenario(T, DOMAIN, Time+1).

%Taras
%potentiallyExecutable(Action, Time, Action_Domain)
%   Action does not occur in impossible at Time
%   precondition holds
% 

% domain = {"SHOOT12" : {"causes": (not("ALIVE2"), and("ALIVE1", and(not("JAMMED1"), "FACING12")))}}
get_sample_domain(Sample_Domain) :- 
    list_to_assoc(["causes"-(negate("ALIVE2"), and("ALIVE1", and(negate("JAMMED1"), "FACING12")))], Causes_List),
    list_to_assoc(["SHOOT12"-Causes_List], Sample_Domain).


:- get_sample_domain(Domain),
    list_to_assoc(["ALIVE1"-true, "JAMMED1"-false, "FACING12"-true], Sample_Fluent_Assignments),
    potentially_executable_atomic(4, Domain, Sample_Fluent_Assignments, "SHOOT12").
