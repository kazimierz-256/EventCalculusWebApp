:- begin_tests(user_input_parsing).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/logic_tree_parsing.pl").

%%%%%%%%%%%%%%%%%%
% Helper functions
%%%%%%%%%%%%%%%%%%

check_two_lists_same([], []).
check_two_lists_same([K1-V1 | Pairs1], [K2-V2 | Pairs2]) :-
    K1 = K2,
    (is_assoc(V1)
    ->  check_assoc_lists_same(V1, V2)
    ;   (is_list(V1)
        ->  (sort(V1, Sorted1),
            sort(V2, Sorted2),
            Sorted1 = Sorted2)
        ;   (V1 = V2))),
    check_two_lists_same(Pairs1, Pairs2).

check_assoc_lists_same(Assoc1, Assoc2) :-
    assoc_to_list(Assoc1, Pairs1),
    assoc_to_list(Assoc2, Pairs2),
    check_two_lists_same(Pairs1, Pairs2).

%%%%%%%%%%%%%%
% Parse Domain
%%%%%%%%%%%%%%

test('domain multiple lines') :-
    parse_domain(
        'BUY causes OWN_TV or not OWN_TV
             WATCH1 causes HAPPY if OWN_TV
             WATCH2 causes not HAPPY if not OWN_TV
             STEAL causes OWN_TV if not OWN_TV
             impossible STEAL at 5
             LOL releases HAPPY
             impossible STEAL at 7',
        Domain),
    list_to_assoc(["causes"-(or("own_tv",negate("own_tv")),true)], Buy_Causes_List),
    list_to_assoc(["causes"-("happy","own_tv")], Watch1_Causes_List),
    list_to_assoc(["causes"-(negate("happy"),negate("own_tv"))], Watch2_Causes_List),
    list_to_assoc(["causes"-("own_tv",negate("own_tv")), "impossible"-[5,7]], Steal_Causes_List),
    list_to_assoc(["releases"-("happy",true)], Lol_Causes_List),
    list_to_assoc(
        ["watch1"-Watch1_Causes_List,
            "buy"-Buy_Causes_List,
            "steal"-Steal_Causes_List,
            "watch2"-Watch2_Causes_List,
            "lol"-Lol_Causes_List],
        D),
    check_assoc_lists_same(Domain, D).

test('domain multiple lines with unnecessary spaces') :-
    parse_domain(
        'buy    causes    OWN_TV    or    not    OWN_TV
             WATCH1    causes    HAPPY     if     OWN_TV
             WATCH2     causes     not     HAPPY     if     not     OWN_TV
             STEAL     causes     OWN_TV     if     not     OWN_TV
             impossible     STEAL     at     5
             lol     releases     HAPPY
             impossible     STEAL     at     7',
        Domain),
    list_to_assoc(["causes"-(or("own_tv",negate("own_tv")),true)], Buy_Causes_List),
    list_to_assoc(["causes"-("happy","own_tv")], Watch1_Causes_List),
    list_to_assoc(["causes"-(negate("happy"),negate("own_tv"))], Watch2_Causes_List),
    list_to_assoc(["causes"-("own_tv",negate("own_tv")), "impossible"-[5,7]], Steal_Causes_List),
    list_to_assoc(["releases"-("happy",true)], Lol_Causes_List),
    list_to_assoc(
        ["watch1"-Watch1_Causes_List,
            "buy"-Buy_Causes_List,
            "steal"-Steal_Causes_List,
            "watch2"-Watch2_Causes_List,
            "lol"-Lol_Causes_List],
        D),
    check_assoc_lists_same(Domain, D).

test('domain multiple lines additional nl character') :-
    parse_domain(
        '
             BUY causes OWN_TV or not OWN_TV
             WATCH1 causes HAPPY if OWN_TV


             WATCH2 causes not HAPPY if not OWN_TV
             STEAL causes OWN_TV if not OWN_TV
             impossible STEAL at 5

             LOL releases HAPPY
             impossible STEAL at 7
        ',
        Domain),
    list_to_assoc(["causes"-(or("own_tv",negate("own_tv")),true)], Buy_Causes_List),
    list_to_assoc(["causes"-("happy","own_tv")], Watch1_Causes_List),
    list_to_assoc(["causes"-(negate("happy"),negate("own_tv"))], Watch2_Causes_List),
    list_to_assoc(["causes"-("own_tv",negate("own_tv")), "impossible"-[5,7]], Steal_Causes_List),
    list_to_assoc(["releases"-("happy",true)], Lol_Causes_List),
    list_to_assoc(
        ["watch1"-Watch1_Causes_List,
            "buy"-Buy_Causes_List,
            "steal"-Steal_Causes_List,
            "watch2"-Watch2_Causes_List,
            "lol"-Lol_Causes_List],
        D),
    check_assoc_lists_same(Domain, D).

%%%%%%%%%%%
% Parse acs
%%%%%%%%%%%

test('acs one line') :-
    list_to_assoc([1-["shoot"]], Compound_Actions),
    parse_acs("SHOOT|1", Acs),
    check_assoc_lists_same(Compound_Actions, Acs).

test('acs multiple lines different order') :-
    list_to_assoc([1-["shoot", "hide", "run"], 4-["love", "eat","pray"]], Compound_Actions),
    parse_acs('SHOOT, HIDE,  RUN|1
    LOVE, PRAY, EAT|4', Acs),
    check_assoc_lists_same(Compound_Actions, Acs).

test('acs multiple different lines order') :-
    list_to_assoc([1-["shoot", "hide", "run"], 4-["love", "eat","pray"]], Compound_Actions),
    parse_acs('LOVE, PRAY, EAT|4
    SHOOT, HIDE,  RUN|1', Acs),
    check_assoc_lists_same(Compound_Actions, Acs).

test('acs multiple lines with new line characters in between') :-
    list_to_assoc([1-["shoot", "hide", "run"], 4-["love", "eat","pray"]], Compound_Actions),    parse_acs('
    SHOOT,HIDE, RUN|1


    LOVE,PRAY, EAT|4
    ', Acs),
    check_assoc_lists_same(Compound_Actions, Acs).

test('acs multiple lines with white characters') :-
    list_to_assoc([1-["shoot", "hide", "run"], 4-["love", "eat","pray"]], Compound_Actions),
    parse_acs('SHOOT,   HIDE,   RUN|1
    LOVE,   EAT,   PRAY|4', Acs),
    check_assoc_lists_same(Compound_Actions, Acs).

test('acs multiple lines with white characters at the end') :-
    list_to_assoc([1-["shoot", "hide", "run"], 4-["love", "eat","pray"]], Compound_Actions),
    parse_acs('shoot,   hide,   run   |1
    LOVE,   EAT,   PRAY   |4', Acs),
    check_assoc_lists_same(Compound_Actions, Acs).

%%%%%%%%%%%
% Parse obs
%%%%%%%%%%%

test('obs one line') :-
    list_to_assoc([0-"alive"], Observations),
    parse_obs("ALIVE|0", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs one line slightly more complex') :-
    list_to_assoc([0-and("alive", "well")], Observations),
    parse_obs("ALIVE and WELL|0", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs one line even more complex') :-
    list_to_assoc([0-or(and("alive", "well"), "dead")], Observations),
    parse_obs("ALIVE and WELL or DEAD|0", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs multiple lines') :-
    list_to_assoc([0-or(and("alive", "well"), "dead"), 1-implies("alive", negate("dead"))], Observations),
    parse_obs("ALIVE and WELL or DEAD|0
    ALIVE implies not DEAD|1", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs multiple lines wrong order') :-
    list_to_assoc([0-or(and("alive", "well"), "dead"), 1-implies("alive", negate("dead"))], Observations),
    parse_obs("ALIVE implies not DEAD|1
    ALIVE and WELL or DEAD|0", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs multiple lines with white characters') :-
    list_to_assoc([0-or(and("alive", "well"), "dead"), 1-implies("alive", negate("dead"))], Observations),
    parse_obs("alive  and    WELL  or  DEAD|0
    ALIVE  implies   not  dead|1", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs multiple lines with white characters at the end') :-
    list_to_assoc([0-or(and("alive", "well"), "dead"), 1-implies("alive", negate("dead"))], Observations),
    parse_obs("alive  and    WELL  or  DEAD   |0
    ALIVE  implies   not  dead   |1", Obs),
    check_assoc_lists_same(Observations, Obs).

test('obs multiple lines with new lines in between') :-
    list_to_assoc([0-or(and("alive", "well"), "dead"), 1-implies("alive", negate("dead"))], Observations),
    parse_obs("
    alive and WELL or DEAD|0


    ALIVE implies not DEAD|1
    ", Obs),
    check_assoc_lists_same(Observations, Obs).

:- end_tests(user_input_parsing).
