:- begin_tests(tas).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

get_domain_scenario(Domain, Scenario) :-
    parse_domain('THINKABOUTSUNDAY causes not MOVING
                    ALARM causes MOVING if ALIVE
                    SHOOT causes not ALIVE and not MOVING if not MOVING', Domain),
    parse_acs('SHOOT,THINKABOUTSUNDAY|0
                    SHOOT,THINKABOUTSUNDAY,ALARM|1
                    SHOOT|2', Acs),
    parse_obs('ALIVE and MOVING|0', Obs),
    Scenario = (Obs, Acs).

test('possibly executable') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily executable') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    \+ run_scenario(Scenario, Domain, Query).

test('necessarily accessible ALIVE and MOVING at 0') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE and MOVING at 0'),
    run_scenario(Scenario, Domain, Query).

test('necessarily accessible ALIVE and not MOVING at 1') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE and not MOVING at 1'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily accessible ALIVE at 2') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 2'),
    \+ run_scenario(Scenario, Domain, Query).

test('possibly accessible ALIVE and MOVING at 2') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE and MOVING at 2'),
    run_scenario(Scenario, Domain, Query).

test('possibly accessible not ALIVE and not MOVING at 2') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE and not MOVING at 2'),
    run_scenario(Scenario, Domain, Query).

test('possibly accessible not ALIVE and not MOVING at 3') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE and not MOVING at 3'),
    run_scenario(Scenario, Domain, Query).

test('not possibly accessible MOVING at 3') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible MOVING at 3'),
    \+ run_scenario(Scenario, Domain, Query).

:- end_tests(tas).
