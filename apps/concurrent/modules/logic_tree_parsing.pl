:- module(logic_tree_parsing, 
    [
        logic_tree_from_text/2,
        logictree/3,
        parse_string/3
	]).

optional_whitespace() --> [L], {char_type(L, white)}.
optional_whitespace() --> [].

parse_string(String) --> {string_chars(String, List)}, List.

fluentConsecutive([])     --> [].
fluentConsecutive([L|Ls]) --> [L], {(char_type(L, upper) ; char_type(L, digit)),not(char_type(L, white))}, fluentConsecutive(Ls).
fluent([L|Ls]) --> [L], { char_type(L, upper),not(char_type(L, white))}, fluentConsecutive(Ls).

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
logic_tree_from_text(STRING, T) :-
    normalize_space(string(String_Cleaned), STRING),
    string_chars(String_Cleaned, CHARS),
    % phrase(cleanWhiteSpace(CHARS2), CHARS),
    phrase(logictree(T), CHARS).

logictree(T) --> optional_whitespace(),logictreeor(T),optional_whitespace().

logictreeor(or(A,B)) --> logictreeand(A),parse_string(" or "),logictreeor(B).
logictreeor(A) --> logictreeand(A).

logictreeand(and(A,B)) --> logictreeimplies(A),parse_string(" and "),logictreeand(B).
logictreeand(A) --> logictreeimplies(A).

logictreeimplies(implies(A,B)) --> logictreeiff(A),parse_string(" implies "),logictreeimplies(B).
logictreeimplies(A) --> logictreeiff(A).

logictreeiff(iff(A,B)) --> logictreeterm(A),parse_string(" iff "),logictreeiff(B).
logictreeiff(A) --> logictreeterm(A).

logictreeterm(negate(T)) --> parse_string("not "),logictree(T).
logictreeterm(negate(T)) --> parse_string("not("),optional_whitespace(),logictree(T),optional_whitespace(),[')'].
logictreeterm(T) --> optional_whitespace(),['('],optional_whitespace(),logictree(T),optional_whitespace(),[')'],optional_whitespace().
logictreeterm(S) --> fluent(F),{string_chars(S, F)}.