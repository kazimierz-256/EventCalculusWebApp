:- begin_tests(semi_complex_test).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

get_domain(Domain) :-
    Domain_Text = 'BUY causes OwnTv or not OwnTv
        WATCH1 causes HAPPY if OwnTv
        WATCH2 causes not HAPPY if not OwnTv
        STEAL causes OwnTv if not OwnTv',
    parse_domain(Domain_Text, Domain).

get_scenario(Scenario) :-
    Acs_Text = 'BUY|0
        WATCH1, WATCH2|1
        STEAL|2
        WATCH1, WATCH2|3',
    parse_acs(Acs_Text, Acs),
    parse_obs('not OwnTv and not HAPPY|0', Obs),
    Scenario = (Obs, Acs).
        
% for this Action Domain and Scenario there are two models:
%       |       BUY         | WATCH1, WATCH2    | STEAL         | WATCH1, WATCH2    |
%       0                   1                   2               3                   4
% 1:
%   not OWN_TV          not OWN_TV          not OWN_TV         OWN_TV               OWN_TV
%   not HAPPY           not HAPPY           not HAPPY       not HAPPY               HAPPY
%
% 2:
%                       OWN_TV                  OWN_TV   X (STEAL is not executable, the scenario fails)
%                       not HAPPY               HAPPY    X
%

test('possibly executable') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

test('possibly executable BUY at 0') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable BUY at 0'),
    run_scenario(Scenario, Domain, Query).

test('necessarily executable BUY at 1') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable BUY at 1'),
    run_scenario(Scenario, Domain, Query).

test('not true that necessarily executable STEAL at 2') :-
   get_domain(Domain),
   get_scenario(Scenario),
   get_query_from_text(Query, 'necessarily executable STEAL at 2'),
   \+ run_scenario(Scenario, Domain, Query).

test('not true that necessarily executable BUY at 4') :-
   get_domain(Domain),
   get_scenario(Scenario),
   get_query_from_text(Query, 'necessarily executable BUY at 4'),
   \+ run_scenario(Scenario, Domain, Query).

test('possibly executable BUY at 5') :-
   get_domain(Domain),
   get_scenario(Scenario),
   get_query_from_text(Query, 'possibly executable BUY at 5'),
   run_scenario(Scenario, Domain, Query).

test('not true that necessarily executable') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    \+ run_scenario(Scenario, Domain, Query).

test('necessarily accessible not HAPPY at 1') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not HAPPY at 1'),
    run_scenario(Scenario, Domain, Query).

test('not true that necessarily accessible OwnTv at 1') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible OwnTv at 1'),
    \+ run_scenario(Scenario, Domain, Query).

test('not true that necessarily accessible OwnTv at 1') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible OwnTv at 4'),
    \+ run_scenario(Scenario, Domain, Query).

:- end_tests(semi_complex_test).
