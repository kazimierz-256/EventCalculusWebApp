:- begin_tests(concurrent_test).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

get_domain(Domain) :-
    Domain_Text =
        'A causes a
        B causes b
        C causes c
        An causes not a
        Bn causes not b
        Cn causes not c
        Ar releases a
        Br releases b
        Cr releases c
        D causes a if b and c
        E causes not a if not c or b and not a
        impossible A at 1',

    parse_domain(Domain_Text, Domain).

get_scenario(Scenario) :-
    parse_obs('not a and not b and not c|0', Obs),
    Acs_Text = 'A, B, C|0
        An|1
        D, E|2
        Ar, Br, Cr|3
        E|4',
    parse_acs(Acs_Text, Acs),
    Scenario = (Obs, Acs).

test('possibly executable') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily executable') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    not(run_scenario(Scenario, Domain, Query)).

test('necessarily executable E at 2') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable E at 2'),
    run_scenario(Scenario, Domain, Query).

test('possibly executable E at 4') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable E at 4'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily executable D at 4') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable D at 4'),
    not(run_scenario(Scenario, Domain, Query)).

test('necessarily accessible not a and b at 2') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not a and b at 2'),
    run_scenario(Scenario, Domain, Query).

test('possibly accessible a at 3') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible not a and b at 2'),
    run_scenario(Scenario, Domain, Query).

test('not necessarily accessible a at 3') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible a at 3'),
    not(run_scenario(Scenario, Domain, Query)).

test('not possibly executable A at 1') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable A at 1'),
    not(run_scenario(Scenario, Domain, Query)).

:- end_tests(concurrent_test).
