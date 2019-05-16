:- module(concurrent, 
	[   rw/3
	]).

:- use_module(debug_module).

% Kazik

rw(ACTION_DOMAIN, SCENARIO, QUERY):-
    ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.

possiblyExecutableScenario(+ACTION_DOMAIN, +SCENARIO, -VALID_MODEL) :- 
	getMaximumDefinedTime(SCENARIO, MAXTIME),
	model(ACTION_DOMAIN, SCENARIO, MAXTIME, VALID_MODEL, false).

model(+ACTION_DOMAIN, +SCENARIO, 0, -[INITIAL_STATE]) :- .

model(+ACTION_DOMAIN, +SCENARIO, +T, +ONLY_EXECUTABLE_MODELS, -NEW_MODEL) :-
	model(ACTION_DOMAIN, SCENARIO, T-1, PREVIOUS_MODEL),
	(ONLY_EXECUTABLE_MODELS = true ->
	nextValidModel(ACTION_DOMAIN, SCENARIO, T, NEW_MODEL, ONLY_EXECUTABLE_MODELS)
	; nextValidModel(ACTION_DOMAIN, SCENARIO, T, NEW_MODEL, ONLY_EXECUTABLE_MODELS) ; PREVIOUS_MODEL).

assignementSatisfyingConstraint(CONSTRAINT_LOGIC_TREE, ASSIGNMENT) :-
	extractFluents(CONSTRAINT_LOGIC_TREE, FLUENTS),
	

% Ola

domain(LIST, DOMAIN) :-
    list_to_assoc(LIST, DOMAIN).

put_into_domain(KEY, VALUE, DOMAIN, NEW_DOMAIN) :-
   	put_assoc(KEY, DOMAIN, VALUE, NEW_DOMAIN).

get_from_domain(KEY, DOMAIN, VALUE) :-
    get_assoc(KEY, DOMAIN, VALUE).

run_scenario([], _, Time).
run_scenario([(_, Action)|T], DOMAIN, Time) :-
    get_from_domain(Action, DOMAIN, VALUE),
    % TODO: make sure state changes are allowed when causes/releases action is executed
    run_scenario(T, DOMAIN, Time+1).
