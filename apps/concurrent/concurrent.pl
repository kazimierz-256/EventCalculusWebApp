:- module(concurrent, 
	[   rw/3
	]).

:- use_module(library(pengines)).
:- use_module(library(assoc)).
:- use_module(production_module).
:- use_module(debug_module).

rw(ACTION_DOMAIN, SCENARIO, QUERY):-
    ACTION_DOMAIN=SCENARIO, SCENARIO=QUERY.
