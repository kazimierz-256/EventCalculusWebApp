:- module(concurrent, 
    [   rw/3,
    logictreefromtext/2
	]).

:- use_module(debug_module).

% Kazik

rw(ACTION_DOMAIN, SCENARIO, QUERY):-
    ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.

optional_whitespace([]) --> [].
optional_whitespace([L]) --> [L], {char_type(L, white)}.

string(STRING) --> {string_chars(STRING, LIST)},LIST.

fluentConsecutive([])     --> [].
fluentConsecutive([L|Ls]) --> [L], {(char_type(L, upper) ; char_type(L, digit)),not(char_type(L, white))}, fluentConsecutive(Ls).
fluent([L|Ls]) --> [L], { char_type(L, upper),not(char_type(L, white))}, fluentConsecutive(Ls).

%LOGICTREE
logictreefromtext(STRING, T) :-
    string_chars(STRING, CHARS),
    phrase(logictree(T), CHARS).

logictree(T) --> logictreeor(T).

logictreeor(or(A,B)) --> logictreeand(A),string(" or "),logictreeor(B).
logictreeor(A) --> logictreeand(A).

logictreeand(and(A,B)) --> logictreeimplies(A),string(" and "),logictreeand(B).
logictreeand(A) --> logictreeimplies(A).

logictreeimplies(implies(A,B)) --> logictreeiff(A),string(" implies "),logictreeimplies(B).
logictreeimplies(A) --> logictreeiff(A).

logictreeiff(iff(A,B)) --> logictreeterm(A),string(" iff "),logictreeiff(B).
logictreeiff(A) --> logictreeterm(A).

logictreeterm(negate(T)) --> string("not "),logictree(T).
logictreeterm(negate(T)) --> string("not("),optional_whitespace(_),logictree(T),optional_whitespace(_),[')'].
logictreeterm(T) --> optional_whitespace(_),['('],optional_whitespace(_),logictree(T),optional_whitespace(_),[')'],optional_whitespace(_).
logictreeterm(S) --> fluent(F),{string_chars(S, F)}.

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

run_scenario([], _, Time).
run_scenario([(_, Action)|T], DOMAIN, Time) :-
    get_from_domain(Action, DOMAIN, VALUE),
    % TODO: make sure state changes are allowed when causes/releases action is executed
    run_scenario(T, DOMAIN, Time+1).
