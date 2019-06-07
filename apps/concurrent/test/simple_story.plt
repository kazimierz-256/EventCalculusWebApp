:- begin_tests(simple_story).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

get_domain_scenario(Domain, Scenario) :-
    parse_domain('SHOOT causes not ALIVE
                  impossible SHOOT at 0', Domain),
    parse_obs('ALIVE|0', Obs),
    parse_acs('SHOOT|1', Acs),
    Scenario = (Obs, Acs).

%%%%%%%%%%
% SIMPLEST
%%%%%%%%%%

test(possibly_executable) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).


test(necessarily_executable) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).

test(possibly_accessible_ALIVE_at_0) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE at 0'),
    run_scenario(Scenario, Domain, Query).

test(possibly_accessible_ALIVE_at_1) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE at 1'),
    run_scenario(Scenario, Domain, Query).

test('not possibly accessible ALIVE at 5') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE at 5'),
    \+ run_scenario(Scenario, Domain, Query).

test('not possibly accessible not ALIVE at 0') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE at 0'),
    \+ run_scenario(Scenario, Domain, Query).

test('not possibly accessible not ALIVE at 1') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE at 1'),
    \+ run_scenario(Scenario, Domain, Query).

test(possibly_accessible_not_ALIVE_at_5) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE at 5'),
    run_scenario(Scenario, Domain, Query).

test(necessarily_accessible_ALIVE_at_0) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 0'),
    run_scenario(Scenario, Domain, Query).

test(necessarily_accessible_ALIVE_at_1) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 1'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily accessible ALIVE at 5') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 5'),
    \+ run_scenario(Scenario, Domain, Query).

test('not necessarily accessible not ALIVE at 0') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 0'),
    \+ run_scenario(Scenario, Domain, Query).

test('not necessarily accessible not ALIVE at 1') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 1'),
    \+ run_scenario(Scenario, Domain, Query).

test(necessarily_accessible_not_ALIVE_at_2) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 2'),
    run_scenario(Scenario, Domain, Query).

test(necessarily_accessible_not_ALIVE_at_5) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 5'),
    run_scenario(Scenario, Domain, Query).

test(possibly_executable_SHOOT_at_0) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly executable SHOOT at 0'),
    not(run_scenario(Scenario, Domain, Query)).

test(possibly_executable_SHOOT_at_1) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly executable SHOOT at 1'),
    run_scenario(Scenario, Domain, Query).

test(possibly_executable_SHOOT_at_5) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly executable SHOOT at 5'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily executable SHOOT at 0') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily executable SHOOT at 0'),
    \+ run_scenario(Scenario, Domain, Query).

test(necessarily_executable_SHOOT_at_1) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily executable SHOOT at 1'),
    run_scenario(Scenario, Domain, Query).

test(necessarily_executable_SHOOT_at_5) :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily executable SHOOT at 5'),
    run_scenario(Scenario, Domain, Query).

:- end_tests(simple_story).
