:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

simplest_domain(Domain) :-
    %SHOOT causes not ALIVE +
    %impossible SHOOT at 0 +

    %SHOOT
    list_to_assoc(["causes"-(negate("ALIVE"), true), "impossible"-[0]], Shoot_Causes_List),

    %CREATING DOMAIN
    list_to_assoc(["SHOOT"-Shoot_Causes_List], Domain).

simplest_scenario(Sc) :-
    %OBS
    list_to_assoc([0-"ALIVE"], Observations),

    %ACS
    list_to_assoc([1-["SHOOT"]], Compound_Actions),
    Sc = (Observations, Compound_Actions).

%%%%%%%%%%
% SIMPLEST
%%%%%%%%%%

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE at 0'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE at 1'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE at 5'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE at 0'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE at 1'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible not ALIVE at 5'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 0'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 1'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible ALIVE at 5'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 0'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 1'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 2'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not ALIVE at 5'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable SHOOT at 0'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable SHOOT at 1'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable SHOOT at 5'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable SHOOT at 0'),
    not(run_scenario(Scenario, Domain, Query)).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable SHOOT at 1'),
    run_scenario(Scenario, Domain, Query).

:-  simplest_domain(Domain),
    simplest_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable SHOOT at 5'),
    run_scenario(Scenario, Domain, Query).
