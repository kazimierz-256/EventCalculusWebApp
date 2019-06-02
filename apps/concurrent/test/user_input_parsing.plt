:- begin_tests(user_input_parsing).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/logic_tree_parsing.pl").

test('domain multiple lines') :-
    parse_domain(
        'BUY causes OWN_TV or not OWN_TV
             WATCH1 causes HAPPY if OWN_TV
             WATCH2 causes not HAPPY if not OWN_TV
             STEAL causes OWN_TV if not OWN_TV',
        Domain),
    list_to_assoc(["causes"-(or("OWN_TV",negate("OWN_TV")),true)], Causes_List),

    get_assoc("BUY", Domain, Causes_List).


% TODO       parse_acs/2,
% TODO       parse_obs/2

:- end_tests(user_input_parsing).