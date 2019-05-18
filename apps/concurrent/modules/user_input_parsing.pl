:- module(user_input_parsing,
    [
        parse_domain/2
	]).

parse_cause_if([], EFFECT, EFFECT, IF) :-
    IF = [].
parse_cause_if(["if" | IF], EFFECT, EFFECT, IF).
parse_cause_if([H | T], EFFECT_SF, EFFECT, IF) :-
    H \= "if",
    append(EFFECT_SF, [H], EFFECT_SF_NEW),
    parse_cause_if(T, EFFECT_SF_NEW, EFFECT, IF).

get_action_and_val([ACTION, "causes"|REST], ACTION, VALUE) :-
    empty_assoc(ASSOC),
    parse_cause_if(REST, [], EFFECT_PARTS, IF_PARTS),
    !,
    atomic_list_concat(EFFECT_PARTS, ' ', ATOM_EF), 
    atom_string(ATOM_EF, EFFECT),
    atomic_list_concat(IF_PARTS, ' ', ATOM_IF), 
    atom_string(ATOM_IF, IF),
    put_assoc("causes", ASSOC, (EFFECT, IF), VALUE ).
get_action_and_val([ACTION, "releases"|REST], ACTION, VALUE) :-
    empty_assoc(ASSOC),
    parse_cause_if(REST, [], EFFECT_PARTS, IF_PARTS),
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
    get_assoc("impossible", ASSOC, VALUE_SF),
    append(VALUE_SF, [VALUE], NEW_VALUE),
    put_assoc("impossible", ASSOC, NEW_VALUE, NEW_ASSOC).
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
    ACTION_KEYS = [ACTION_KEY|_],
    get_assoc(ACTION_KEY, VALUE, VALUE_TO_ADD),
    add_to_assoc_list(ACTION_KEY, VALUE_TO_ADD, VALUE_SF, NEW_ASSOC),
    put_assoc(ACTION, ASSOC, NEW_ASSOC, DOMAIN).
    
add_to_domain(ACTION, VALUE, ASSOC, DOMAIN) :- 
    assoc_to_keys(ASSOC, KEYS),
    member(ACTION, KEYS) 
    -> add_if_correct(ACTION, VALUE, ASSOC, DOMAIN)
    ; put_assoc(ACTION, ASSOC, VALUE, DOMAIN).

parse_parts([], DOMAIN, DOMAIN).
parse_parts([H|T], ASSOC, DOMAIN) :-
    parse_sentence(H, ACTION, VALUE),
    add_to_domain(ACTION, VALUE, ASSOC, DOMAIN_TMP),
    parse_parts(T, DOMAIN_TMP, DOMAIN).

parse_domain(TEXT, DOMAIN) :-
    split_string(TEXT, "\n", "", PARTS),
    empty_assoc(ASSOC),
    parse_parts(PARTS, ASSOC, DOMAIN).