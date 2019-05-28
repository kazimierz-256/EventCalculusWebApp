:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

:-  parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

:-  parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).

% TODO this is not working -> A should be both true and false at 5 (2 models)
:-  parse_domain("A causes f or not f", Domain),
   parse_acs("A|0", Acs),
   parse_obs("not f|0", Obs),
   Scenario = (Obs, Acs),
   get_query_from_text(Query, 'possibly executable A at 5'),
   run_scenario(Scenario, Domain, Query),
   get_query_from_text(Query, 'possibly accessible f at 5'),
   run_scenario(Scenario, Domain, Query).

:-  parse_domain("A causes f or not f", Domain),
    parse_acs("A|0", Acs),
    parse_obs("not f|0", Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'necessarily accessible A at 5'),
    not(run_scenario(Scenario, Domain, Query)).

