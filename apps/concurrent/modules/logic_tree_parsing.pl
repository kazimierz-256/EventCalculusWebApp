:- module(logic_tree_parsing, 
    [
        logic_tree_from_text/2,
        logictree/3,
        parse_string/3,
        fluent/3
	]).

optional_whitespace() --> [L], {char_type(L, white)}.
optional_whitespace() --> [].

parse_string(String) --> {string_chars(String, List)}, List.

fluentConsecutive([])     --> [].
fluentConsecutive([L|Ls]) --> [L], {(char_type(L, csym))}, fluentConsecutive(Ls).
fluent([L|Ls]) --> [L], { char_type(L, alpha) }, fluentConsecutive(Ls).

one_or_more_space() --> [' '], one_or_more_space().
one_or_more_space() --> [].

% cleanWhiteSpace(Ls) --> removeLeadingSpaces(Ls).
% removeLeadingSpaces(Ls) --> [' '], removeLeadingSpaces(Ls).
% removeLeadingSpaces(Ls) --> removeTooMuchWhiteSpace(Ls).
% removeTooMuchWhiteSpace([]) --> removeTrailingSpaces().
% removeTooMuchWhiteSpace([' '|Ls])--> [' '], one_or_more_space(), removeTooMuchWhiteSpace(Ls).
% removeTooMuchWhiteSpace([L|Ls])--> [L], removeTooMuchWhiteSpace(Ls).
% removeTrailingSpaces() --> [' '], removeTrailingSpaces().
% removeTrailingSpaces() --> [].

%LOGICTREE
logic_tree_from_text(String, true) :-
    normalize_space(string(String_Cleaned), String),
    string_lower(String_Cleaned, Lower),
    member(Lower, ["wait", ";"]).
logic_tree_from_text(String, true) :-
    normalize_space(string(String_Cleaned), String),
    string_chars(String_Cleaned, []).
logic_tree_from_text(String, T) :-
    normalize_space(string(String_Cleaned), String),
    string_chars(String_Cleaned, CHARS),
    phrase(logictree(T), CHARS).

valid_fluent(Fluent) :- not(member(Fluent, ["true", "false","not","and","or",";","implies","iff","wait"])).

logictree(T) --> optional_whitespace(),logictreeor(T),optional_whitespace().

logictreeor(or(A,B)) --> logictreeand(A),parse_string(" or "),logictreeor(B).
logictreeor(A) --> logictreeand(A).

logictreeand(and(A,B)) --> logictreeimplies(A),parse_string(" and "),logictreeand(B).
logictreeand(A) --> logictreeimplies(A).

logictreeimplies(implies(A,B)) --> logictreeiff(A),parse_string(" implies "),logictreeimplies(B).
logictreeimplies(A) --> logictreeiff(A).

logictreeiff(iff(A,B)) --> logictreeterm(A),parse_string(" iff "),logictreeiff(B).
logictreeiff(A) --> logictreeterm(A).

logictreeterm(negate(T)) --> parse_string("not "),logictreeterm(T).
logictreeterm(negate(T)) --> parse_string("not("),optional_whitespace(),logictree(T),optional_whitespace(),[')'].
logictreeterm(T) --> optional_whitespace(),['('],optional_whitespace(),logictree(T),optional_whitespace(),[')'],optional_whitespace().
logictreeterm(S) --> fluent(F),{string_chars(S, F),string_lower(S, Fluent), valid_fluent(Fluent)}.
logictreeterm(true) --> fluent(F),{string_chars(S, F),string_lower(S, "true")}.
logictreeterm(false) --> fluent(F),{string_chars(S, F),string_lower(S, "false")}.