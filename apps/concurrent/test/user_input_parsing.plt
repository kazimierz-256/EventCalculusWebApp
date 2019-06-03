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
    list_to_assoc(["causes"-(or("OWN_TV",negate("OWN_TV")),true)], Buy_Causes_List),
    writeln("\n"),
    writeln(Domain),
    list_to_assoc(["causes"-("HAPPY","OWN_TV")], Watch1_Causes_List),
    list_to_assoc(["causes"-(negate("HAPPY"),negate("OWN_TV"))], Watch2_Causes_List),
    list_to_assoc(["causes"-("OWN_TV",negate("OWN_TV"))], Steal_Causes_List),
    list_to_assoc(["WATCH1"-Watch1_Causes_List, "BUY"-Buy_Causes_List, "STEAL"-Steal_Causes_List, "WATCH2"-Watch2_Causes_List], D),
    writeln(D),
    Domain = D

.


% TODO       parse_acs/2,
% TODO       parse_obs/2

:- end_tests(user_input_parsing).