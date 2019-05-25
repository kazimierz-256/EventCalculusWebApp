:- module(user_input_parsing,
    [
        parse_domain/2,
        parse_actions/2
	]).

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
    put_assoc("causes", Assoc, (Effect, If), Value ).
get_action_and_val([Action, "releases"|Rest], Action, Value) :-
    empty_assoc(Assoc),
    parse_cause_if(Rest, Effect_Parts, If_Parts),
    !,
    atomic_list_concat(Effect_Parts, ' ', Atom_Ef), 
    atom_string(Atom_Ef, Effect),
    atomic_list_concat(If_Parts, ' ', Atom_If), 
    atom_string(Atom_If, If),
    put_assoc("releases", Assoc, (Effect, If), Value ).
get_action_and_val(["impossible", Action, "at", Time], Action, Value) :-
    empty_assoc(Assoc),
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

add_to_actions(ACS, Time, Assoc, ActionS) :-
    split_string(ACS, ",", "", Parts),
	put_assoc(Time, Assoc, Parts, ActionS).

parse_actions_line(Text, ACS, Time) :-
    split_string(Text, "|", "", [ACS, Time]).

parse_parts_ac([], ActionS, ActionS).
parse_parts_ac([H|T], Assoc, ActionS) :-
    normalize_space(atom(Line), H),
    parse_actions_line(Line, ACS, Time),
   	add_to_actions(ACS, Time, Assoc, ActionS_Tmp),
    parse_parts_ac(T, ActionS_Tmp, ActionS).

parse_actions(Text, ActionS) :-
    split_string(Text, "\n", "", Parts),
    empty_assoc(Assoc),
    parse_parts_ac(Parts, Assoc, ActionS).

%scenario observations

parse_obs_line(Text, Obs, Time) :-
    split_string(Text, "|", "", [Obs, Time]).

parse_parts_obs([], Observations, Observations).
parse_parts_obs([H|T], Assoc, Observations) :-
    normalize_space(atom(Line), H),
    parse_obs_line(Line, Obs, Time),
   	put_assoc(Time, Assoc, Obs, Observations_Tmp),
    parse_parts_obs(T, Observations_Tmp, Observations).

parse_obs(Text, Observations) :-
    split_string(Text, "\n", "", Parts),
    empty_assoc(Assoc),
    parse_parts_obs(Parts, Assoc, Observations).


