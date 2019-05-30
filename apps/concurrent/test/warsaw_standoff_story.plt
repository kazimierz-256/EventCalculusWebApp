:- begin_tests(warsaw_standoff).

:- use_module("../modules/warsaw_standoff.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

test(necessarily_executable_warsaw_stanoff) :-
    warsaw_standoff_domain(Domain),
    warsaw_standoff_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).


test(possibly_accessiblt_alive1_and_noe_alive2_and_not_alive3_at_5) :-
    warsaw_standoff_domain(Domain),
    warsaw_standoff_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE1 and not ALIVE2 and not ALIVE3 at 5'),
    run_scenario(Scenario, Domain, Query).

test(possibly_accessible_jammed1_and_jammed2_at_1) :-
    warsaw_standoff_domain(Domain),
    warsaw_standoff_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible JAMMED1 and JAMMED2 at 1'),
    not(run_scenario(Scenario, Domain, Query)).

test(possibly_accessible_alive2_at_5) :-
    warsaw_standoff_domain(Domain),
    warsaw_standoff_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE2 at 5'),
    run_scenario(Scenario, Domain, Query).


test(possibly_accessible_alive3_and_jammed1_at_5) :-
    warsaw_standoff_domain(Domain),
    warsaw_standoff_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible ALIVE3 and JAMMED1 at 5'),
    not(run_scenario(Scenario, Domain, Query)).

:- end_tests(warsaw_standoff).
