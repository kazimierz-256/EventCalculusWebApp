:- module(query_parsing, 
    [
        query_parsing/2
	]).

:- use_module(library(dcg/basics)).
:- use_module(logic_tree_pasring).

csv_to_list([S]) --> fluent(F),{string_chars(S, F)}.
csv_to_list([S|Others]) --> fluent(F),{string_chars(S, F)},([',']|[',',' ']),csv_to_list(Others).


parse_query(necessarily_executable) --> parse_string("necessarily executable").
parse_query(possibly_executable) --> parse_string("possible executable").
parse_query(necessarily_accessible(Tree, Time)) -->
    parse_string("necessarily accessible "), logictree(Tree), parse_string(" at "), integer(Time).
parse_query(possibly_accessible(Tree, Time)) -->
    parse_string("possible accessible "), logictree(Tree), parse_string(" at "), integer(Time). 
parse_query(necessarily_executable(Action, Time)) -->
    parse_string("necessarily executable "), csv_to_list(Action), parse_string(" at "), integer(Time).
parse_query(possibly_executable(Action, Time)) -->
    parse_string("possibly executable "), csv_to_list(Action), parse_string(" at "), integer(Time).

get_query_from_text(Query, Text) :- 
    normalize_space(string(String_Cleaned), Text),
    phrase(parse_query(Query), String_Cleaned).
