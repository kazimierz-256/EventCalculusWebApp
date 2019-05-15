:- module(concurrent, 
	[  test/2,
		rw/3
	]).


test(X, Y) :- X=Y.
rw(ACTION_DOMAIN, SCENARIO, QUERY):- ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.