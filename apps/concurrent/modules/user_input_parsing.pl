:- module(user_input_parsing,
    [
        parse_domain/2,
        parse_acs/2,
        parse_obs/2
	]).

:- use_module("logic_tree_parsing.pl").

split_list_by_keyword(_, [], L1, L1, L2) :-
    L2 = [].
split_list_by_keyword(Keyword, [Keyword | L2], L1, L1, L2).
split_list_by_keyword(Keyword, [H | T], L1_Temp, L1, L2) :-
    H \= Keyword,
    append(L1_Temp, [H], L1_TT),
    split_list_by_keyword(Keyword, T, L1_TT, L1, L2).

parse_cause_if(Parts, L1, L2) :-
    split_list_by_keyword("if", Parts, [], L1, L2).

get_action_and_val([Action, "causes"|Rest], Action, Value) :-
    empty_assoc(Assoc),
    parse_cause_if(Rest, Effect_Parts, If_Parts),
    !,
    atomic_list_concat(Effect_Parts, ' ', Atom_Ef), 
    atom_string(Atom_Ef, Effect),
    atomic_list_concat(If_Parts, ' ', Atom_If), 
    atom_string(Atom_If, If),
    logic_tree_from_text(Effect, Effect_T),
    logic_tree_from_text(If, If_T),
    put_assoc("causes", Assoc, (Effect_T, If_T), Value ).

get_action_and_val([Action, "releases"|Rest], Action, Value) :-
    empty_assoc(Assoc),
    parse_cause_if(Rest, Effect_Parts, If_Parts),
    !,
    atomic_list_concat(Effect_Parts, ' ', Atom_Ef), 
    atom_string(Atom_Ef, Effect),
    atomic_list_concat(If_Parts, ' ', Atom_If), 
    atom_string(Atom_If, If),
    logic_tree_from_text(Effect, Effect_T),
    logic_tree_from_text(If, If_T),
    put_assoc("releases", Assoc, (Effect_T, If_T), Value ).

get_action_and_val(["impossible", Action, "at", Time_Str], Action, Value) :-
    empty_assoc(Assoc),
    number_string(Time, Time_Str),
    put_assoc("impossible", Assoc, Time, Value ).

parse_sentence(Text, Action, Value) :-
    split_string(Text, " ", "", Parts),
    get_action_and_val(Parts, Action, Value).

add_to_assoc_list("impossible", Value, Assoc, New_Assoc) :-
    member("impossible", Assoc)
    ->  get_assoc("impossible", Assoc, Value_Sf),
    	append(Value_Sf, [Value], New_Value),
    	put_assoc("impossible", Assoc, New_Value, New_Assoc)
    ;   put_assoc("impossible", Assoc, Value, New_Assoc).

add_to_assoc_list("causes", Value, Assoc, New_Assoc) :-
    assoc_to_keys(Assoc, Keys),
    not(member("causes", Keys)),
    not(member("releases", Keys)),
    put_assoc("causes", Assoc, Value, New_Assoc).

add_to_assoc_list("releases", Value, Assoc, New_Assoc) :-
    assoc_to_keys(Assoc, Keys),
    not(member("causes", Keys)),
    not(member("releases", Keys)),
    put_assoc("causes", Assoc, Value, New_Assoc).

add_if_correct(Action, Value, Assoc, Domain) :-
    get_assoc(Action, Assoc, Value_Sf),
    assoc_to_keys(Value, Action_Keys),
    Action_Keys = [Action_Key],
    get_assoc(Action_Key, Value, Value_TO_ADD),
    add_to_assoc_list(Action_Key, Value_TO_ADD, Value_Sf, New_Assoc),
    put_assoc(Action, Assoc, New_Assoc, Domain).
    
add_to_domain(Action, Value, Assoc, Domain) :- 
    assoc_to_keys(Assoc, Keys),
    member(Action, Keys) 
    ->  add_if_correct(Action, Value, Assoc, Domain)
    ;   put_assoc(Action, Assoc, Value, Domain).

parse_parts([], Domain, Domain).
parse_parts([H|T], Assoc, Domain) :-
    normalize_space(atom(Line), H),
    parse_sentence(Line, Action, Value),
    add_to_domain(Action, Value, Assoc, Domain_Tmp),
    parse_parts(T, Domain_Tmp, Domain).

parse_domain(Text, Domain) :-
    split_string(Text, "\n", "", Parts),
    empty_assoc(Assoc),
    parse_parts(Parts, Assoc, Domain).

%scenario
%scenario actions

add_to_acs(ACS, Time, Assoc, Actions) :-
    split_string(ACS, ",", "", Parts),
	put_assoc(Time, Assoc, Parts, Actions).

parse_acs_line(Text, ACS, Time) :-
    split_string(Text, "|", "", [ACS, Time_Str]),
    number_string(Time, Time_Str).

parse_parts_acs([], Actions, Actions).
parse_parts_acs([H|T], Assoc, Actions) :-
    normalize_space(atom(Line), H),
    parse_acs_line(Line, ACS, Time),
   	add_to_acs(ACS, Time, Assoc, Actions_Tmp),
    parse_parts_acs(T, Actions_Tmp, Actions).

parse_acs(Text, Actions) :-
    split_string(Text, "\n", "", Parts),
    empty_assoc(Assoc),
    parse_parts_acs(Parts, Assoc, Actions).

%scenario observations

parse_obs_line(Text, Obs, Time) :-
    split_string(Text, "|", "", [Obs, Time_Str]),
    number_string(Time, Time_Str).

parse_parts_obs([], Observations, Observations).
parse_parts_obs([H|T], Assoc, Observations) :-
    normalize_space(string(Line), H),
    parse_obs_line(Line, Obs, Time),
    logic_tree_from_text(Obs, Obs_T),
   	put_assoc(Time, Assoc, Obs_T, Observations_Tmp),
    parse_parts_obs(T, Observations_Tmp, Observations).

parse_obs(Text, Observations) :-
    split_string(Text, "\n", "", Parts),
    empty_assoc(Assoc),
    parse_parts_obs(Parts, Assoc, Observations).


