:- begin_tests(simple_concurrent).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

get_domain(Domain) :-
    Domain_Text =
        'EatFruit causes not Fruit if not Pizza
        BuyFruit causes Fruit
        EatPizza causes not Pizza
        BuyPizza causes Pizza
        EatAnything causes not (Fruit and Pizza)
        MaybeEat releases not (Fruit and Pizza)
        BuySomething causes Pizza or Fruit',

    parse_domain(Domain_Text, Domain).

get_scenario(Scenario) :-
    parse_obs('not Fruit and not Pizza|0', Obs),
    Acs_Text = 'BuyFruit, BuyPizza|0
        EatPizza|1
        EatFruit|2
        BuyPizza, EatAnything|3',
    parse_acs(Acs_Text, Acs),
    Scenario = (Obs, Acs).

% for this Action Domain and Scenario there are two models:
%       |BuyFruit, BuyPizza | EatPizza  | EatFruit  | BuyPizza, EatAnything | BuyPizza, MaybeEat| MaybeEat  |
%       0                   1           2           3                       4                   5           6
% 1:
%   not Fruit           Fruit           Fruit   not Fruit               not Fruit           not Fruit   not Fruit
%   not Pizza           Pizza       not Pizza   not Pizza                   Pizza               Pizza       Pizza
%
% 2:                                                                                                    not Fruit
%                                                                                                       not Pizza


test('possibly executable') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly executable'),
    run_scenario(Scenario, Domain, Query).

test('necessarily executable') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily executable'),
    run_scenario(Scenario, Domain, Query).

test('not true that possibly accessible not Pizza at 5') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible not Pizza at 5'),
    \+ run_scenario(Scenario, Domain, Query).

test('necessarily accessible not Fruit at 5') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not Fruit at 5'),
    run_scenario(Scenario, Domain, Query).

test('necessarily accessible not Fruit at 6') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'necessarily accessible not Fruit at 6'),
    run_scenario(Scenario, Domain, Query).

test('possibly accessible not Pizza at 6') :-
    get_domain(Domain),
    get_scenario(Scenario),
    get_query_from_text(Query, 'possibly accessible not Pizza at 6'),
    \+ run_scenario(Scenario, Domain, Query).

:- end_tests(simple_concurrent).
