:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").


possibly_executable :-
    parse_domain(
        'KUP causes MAM or not MAM
OGLADAJ1 causes HAPPY if MAM
OGLADAJ2 causes not HAPPY if not MAM'
UKRADNIJ causes MAM if not MAM,
         Domain),
    parse_acs(
        'KUP|0
OGLADAJ1, OGLADAJ2|1
UKRADNIJ|2
OGLADAJ1, OGLADAJ2|3',
        Acs),
    parse_obs('not MAM and not HAPPY|0', Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

possibly_executable_KUP_at_0 :-
    parse_domain(
        'KUP causes MAM or not MAM
OGLADAJ1 causes HAPPY if MAM
OGLADAJ2 causes not HAPPY if not MAM'
UKRADNIJ causes MAM if not MAM,
         Domain),
    parse_acs(
        'KUP|0
OGLADAJ1, OGLADAJ2|1
UKRADNIJ|2
OGLADAJ1, OGLADAJ2|3',
        Acs),
    parse_obs('not MAM and not HAPPY|0', Obs),
    Scenario = (Obs, Acs),
    get_query_from_text(Query, 'possibly executable KUP at 0'),
    run_scenario(Scenario, Domain, Query).


:- possibly_executable.
:- possibly_executable_KUP_at_0.
