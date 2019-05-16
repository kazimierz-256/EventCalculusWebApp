:- module(concurrent, 
	[  test/2,
		rw/3,
		put_into_domain/4,
		get_from_domain/3,
		run_scenario/3
	]).

:- use_module(library(pengines)).
:- use_module(library(assoc)).

test(X, Y) :-
    pengine_output('ok?'), X=Y.

rw(ACTION_DOMAIN, SCENARIO, QUERY):-
    ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.


domain(LIST, DOMAIN) :-
    list_to_assoc(LIST, DOMAIN).

put_into_domain(KEY, VALUE, DOMAIN, NEW_DOMAIN) :-
   	put_assoc(KEY, DOMAIN, VALUE, NEW_DOMAIN).

get_from_domain(KEY, DOMAIN, VALUE) :-
    get_assoc(KEY, DOMAIN, VALUE).

print_all_values(DOMAIN) :-
    assoc_to_keys(DOMAIN, KEYS),
    print_vals(DOMAIN, KEYS).

print_vals(_, [], _).
print_vals(DOMAIN, [H|T]) :-
    get_from_domain(H, DOMAIN, VALUE),
    print_vals(DOMAIN, T).

run_scenario([], _, Time).
run_scenario([(_, Action)|T], DOMAIN, Time) :-
    get_from_domain(Action, DOMAIN, VALUE),
    run_scenario(T, DOMAIN, Time+1).
