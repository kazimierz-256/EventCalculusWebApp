:- begin_tests(or_story).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

test('possibly executable') :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly executable'),
    \+ run_scenario(Scenario, Domain, Query).

test('necessarily executable') :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).

test('possibly accessible f at 5') :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly accessible not f at 5'),
    run_scenario(Scenario, Domain, Query).

test('possibly accessible not f at 5') :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly executable'),
    \+ run_scenario(Scenario, Domain, Query).

test('necessarily accessible A at 5') :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'necessarily executable A at 5'),
    run_scenario(Scenario, Domain, Query).

:- end_tests(or_story).
