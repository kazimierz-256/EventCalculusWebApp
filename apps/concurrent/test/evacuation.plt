:- begin_tests(evacuation).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

get_domain_scenario(Domain, Scenario) :-
    parse_domain('CFROM3TO2 causes not CON3 and CON2 if CON3 and not BON2
					CFROM2TO1 causes not CON2 and CON1 if CON2 and not BON1
					BFROM2TO1 causes not BON2 and BON1 if BON2 and not AON1
					EVACUATEAFROM1 causes not AON1 and SAFEA if AON1
					EVACUATEBFROM1 causes not BON1 and SAFEB if BON1
					EVACUATECFROM1 causes not CON1 and SAFEC if CON1
					PANICCON3 causes CON3 if CON3
					PANICCON2 causes CON2 if CON2
					PANICCON1 causes CON1 if CON1
					PANICBON2 causes BON2 if BON2
					PANICBON1 causes BON1 if BON1
					PANICAON1 causes AON3 if AON3', Domain),
    parse_acs('EVACUATEAFROM1,BFROM2TO1,CFROM3TO2|0
						BFROM2TO1,CFROM3TO2,PANICBON2|1
						BFROM2TO1,EVACUATEBFROM1,CFROM3TO2|2
						EVACUATEBFROM1,CFROM3TO2,CFROM2TO1|3
						EVACUATECFROM1,CFROM2TO1|4
						EVACUATECFROM1|5', Acs),
    parse_obs('CON3 and not CON2 and not CON1 and BON2 and not BON1 and AON1 and not SAFEA and not SAFEB and not SAFEC|0', Obs),
    Scenario = (Obs, Acs).

test('possibly accessible safe at 4') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible SAFEA and SAFEB and SAFEC at 4'),
    \+ run_scenario(Scenario, Domain, Query).

test('possibly accessible safe at 5') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'possibly accessible SAFEA and SAFEB and SAFEC at 5'),
    run_scenario(Scenario, Domain, Query).

test('necessarily accessible safe at 5') :-
    get_domain_scenario(Domain, Scenario),
    get_query_from_text(Query, 'necessarily accessible SAFEA and SAFEB and SAFEC at 5'),
    \+ run_scenario(Scenario, Domain, Query).


:- end_tests(evacuation).
