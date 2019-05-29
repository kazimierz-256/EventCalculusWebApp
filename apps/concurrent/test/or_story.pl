:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

possibly_executable :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

necessarily_executable :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).

possibly_accessible_f_at_5 :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly accessible f at 5'),
    run_scenario(Scenario, Domain, Query).

possibly_accessible_not_f_at_5 :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly accessible not f at 5'),
    run_scenario(Scenario, Domain, Query).

necessarily_accessible_A_at_5 :-
    parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'necessarily accessible A at 5'),
    not(run_scenario(Scenario, Domain, Query)).

:- possibly_executable.
:- necessarily_executable.
:- possibly_accessible_f_at_5.
:- possibly_accessible_not_f_at_5.
:- necessarily_accessible_A_at_5.
