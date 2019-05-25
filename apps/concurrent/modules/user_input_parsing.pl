:- module(user_input_parsing,
    [
        parse_domain/2,
        parse_actions/2
	]).

split_list_by_keyword(_, [], L1, L1, L2) :-
    L2 = [].
split_list_by_keyword(KEYWORD, [KEYWORD | L2], L1, L1, L2).
split_list_by_keyword(KEYWORD, [H | T], L1_TEMP, L1, L2) :-
    H \= KEYWORD,
    append(L1_TEMP, [H], L1_TT),
    split_list_by_keyword(KEYWORD, T, L1_TT, L1, L2).

parse_cause_if(PARTS, L1, L2) :-
    split_list_by_keyword("if", PARTS, [], L1, L2).

get_action_and_val([ACTION, "causes"|REST], ACTION, VALUE) :-
    empty_assoc(ASSOC),
    parse_cause_if(REST, EFFECT_PARTS, IF_PARTS),
    !,
    atomic_list_concat(EFFECT_PARTS, ' ', ATOM_EF), 
    atom_string(ATOM_EF, EFFECT),
    atomic_list_concat(IF_PARTS, ' ', ATOM_IF), 
    atom_string(ATOM_IF, IF),
    put_assoc("causes", ASSOC, (EFFECT, IF), VALUE ).
get_action_and_val([ACTION, "releases"|REST], ACTION, VALUE) :-
    empty_assoc(ASSOC),
    parse_cause_if(REST, EFFECT_PARTS, IF_PARTS),
    !,
    atomic_list_concat(EFFECT_PARTS, ' ', ATOM_EF), 
    atom_string(ATOM_EF, EFFECT),
    atomic_list_concat(IF_PARTS, ' ', ATOM_IF), 
    atom_string(ATOM_IF, IF),
    put_assoc("releases", ASSOC, (EFFECT, IF), VALUE ).
get_action_and_val(["impossible", ACTION, "at", TIME], ACTION, VALUE) :-
    empty_assoc(ASSOC),
    put_assoc("impossible", ASSOC, TIME, VALUE ).

parse_sentence(TEXT, ACTION, VALUE) :-
    split_string(TEXT, " ", "", PARTS),
    get_action_and_val(PARTS, ACTION, VALUE).

add_to_assoc_list("impossible", VALUE, ASSOC, NEW_ASSOC) :-
    member("impossible", ASSOC)
    ->  get_assoc("impossible", ASSOC, VALUE_SF),
    	append(VALUE_SF, [VALUE], NEW_VALUE),
    	put_assoc("impossible", ASSOC, NEW_VALUE, NEW_ASSOC)
    ;   put_assoc("impossible", ASSOC, VALUE, NEW_ASSOC).
add_to_assoc_list("causes", VALUE, ASSOC, NEW_ASSOC) :-
    assoc_to_keys(ASSOC, KEYS),
    not(member("causes", KEYS)),
    not(member("releases", KEYS)),
    put_assoc("causes", ASSOC, VALUE, NEW_ASSOC).
add_to_assoc_list("releases", VALUE, ASSOC, NEW_ASSOC) :-
    assoc_to_keys(ASSOC, KEYS),
    not(member("causes", KEYS)),
    not(member("releases", KEYS)),
    put_assoc("causes", ASSOC, VALUE, NEW_ASSOC).

add_if_correct(ACTION, VALUE, ASSOC, DOMAIN) :-
    get_assoc(ACTION, ASSOC, VALUE_SF),
    assoc_to_keys(VALUE, ACTION_KEYS),
    ACTION_KEYS = [ACTION_KEY],
    get_assoc(ACTION_KEY, VALUE, VALUE_TO_ADD),
    add_to_assoc_list(ACTION_KEY, VALUE_TO_ADD, VALUE_SF, NEW_ASSOC),
    put_assoc(ACTION, ASSOC, NEW_ASSOC, DOMAIN).
    
add_to_domain(ACTION, VALUE, ASSOC, DOMAIN) :- 
    assoc_to_keys(ASSOC, KEYS),
    member(ACTION, KEYS) 
    ->  add_if_correct(ACTION, VALUE, ASSOC, DOMAIN)
    ;   put_assoc(ACTION, ASSOC, VALUE, DOMAIN).

parse_parts([], DOMAIN, DOMAIN).
parse_parts([H|T], ASSOC, DOMAIN) :-
    normalize_space(atom(LINE), H),
    parse_sentence(LINE, ACTION, VALUE),
    add_to_domain(ACTION, VALUE, ASSOC, DOMAIN_TMP),
    parse_parts(T, DOMAIN_TMP, DOMAIN).

parse_domain(TEXT, DOMAIN) :-
    split_string(TEXT, "\n", "", PARTS),
    empty_assoc(ASSOC),
    parse_parts(PARTS, ASSOC, DOMAIN).

%scenario
%scenario actions

add_to_actions(ACS, TIME, ASSOC, ACTIONS) :-
    split_string(ACS, ",", "", PARTS),
	put_assoc(TIME, ASSOC, PARTS, ACTIONS).

parse_actions_line(TEXT, ACS, TIME) :-
    split_string(TEXT, "|", "", [ACS, TIME]).

parse_parts_ac([], ACTIONS, ACTIONS).
parse_parts_ac([H|T], ASSOC, ACTIONS) :-
    normalize_space(atom(LINE), H),
    parse_actions_line(LINE, ACS, TIME),
   	add_to_actions(ACS, TIME, ASSOC, ACTIONS_TMP),
    parse_parts_ac(T, ACTIONS_TMP, ACTIONS).

parse_actions(TEXT, ACTIONS) :-
    split_string(TEXT, "\n", "", PARTS),
    empty_assoc(ASSOC),
    parse_parts_ac(PARTS, ASSOC, ACTIONS).

%scenario obserwations

%scenatio obs

parse_obs_line(TEXT, OBS, TIME) :-
    split_string(TEXT, "|", "", [OBS, TIME]).

parse_parts_obs([], OBSERVATIONS, OBSERVATIONS).
parse_parts_obs([H|T], ASSOC, OBSERVATIONS) :-
    normalize_space(atom(LINE), H),
    parse_obs_line(LINE, OBS, TIME),
   	put_assoc(TIME, ASSOC, OBS, OBSERVATIONS_TMP),
    parse_parts_obs(T, OBSERVATIONS_TMP, OBSERVATIONS).

parse_obs(TEXT, OBSERVATIONS) :-
    split_string(TEXT, "\n", "", PARTS),
    empty_assoc(ASSOC),
    parse_parts_obs(PARTS, ASSOC, OBSERVATIONS).


