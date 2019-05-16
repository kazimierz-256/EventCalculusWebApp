:- module(concurrent, 
	[  test/2,
		rw/3
	]).

:- use_module(library(pengines)).

test(X, Y) :- pengine_output('ok?'), X=Y.

rw(ACTION_DOMAIN, SCENARIO, QUERY):- ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.