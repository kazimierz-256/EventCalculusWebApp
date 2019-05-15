:- module(expert, 
	[  getAdvisements/2,
	   addBlankAdvisement/1,
	   addUniversalQuestion/4,
	   removeAdvisement/1
	]).
:- use_module(library(persistency)).
:- persistent database(diagnosis:atom, questions:list).
:- db_attach(bazadanych_suplementacja, []).


% :- dynamic database/2.

databaseReset():-
	retractall_database(_,_),
	assert_database('You are vitamin A deficient', [yesno('Do you experience night blindness?','yes'), yesno('Is your skin dry?','yes'), yesno('Is bleh?','no')]),
	assert_database('You are vitamin C deficient', [yesno('Do you blah?','yes'), yesno('Is bleh?','no')]).

getAdvisements(Advisement, Questions):-
	database(Advisement, Questions).

addBlankAdvisement(Advisement) :-
	database(Advisement, _) -> throw('Diagnosis already exists')
	;
	assert_database(Advisement, []).

addUniversalQuestion(Advisement, Question, Answers, CorrectSubset) :-
	database(Advisement, Questions),
	not(member(universal(Question, _, _), Questions)),
	retract_database(Advisement, Questions),
	assert_database(Advisement, [universal(Question, Answers, CorrectSubset) | Questions]).

removeAdvisement(Advisement) :-
	retract_database(Advisement, _).