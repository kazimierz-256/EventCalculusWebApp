:- module(warsaw_standoff, [
    warsaw_standoff_domain/1,
    warsaw_standoff_scenario/1
    ]).

%shoot12 causes not alive2 if alive1 and not jammed1 and facing12 +

%shoot13 causes not alive3 if alive1 and not jammed1 and facing13 +

%shoot21 causes not alive1 if alive2 and not jammed2 and facing21 +

%shoot23 causes not alive3 if alive2 and not jammed2 and facing23 +

%shoot31 causes not alive1 if alive3 and not jammed3 and facing31 +

%shoot32 causes not alive2 if alive3 and not jammed3 and facing32 +

%impossible shoot31 at 0 +
%impossible shoot32 at 0 +
%impossible shoot31 at 1 + 
%impossible shoot32 at 1 +

%rotate12 causes facing12 if alive1 +
%rotate13 causes facing13 if alive1 +
%rotate21 causes facing21 if alive2 +
%rotate23 causes facing23 if alive2 + 
%rotate31 causes facing31 if alive3 + 
%rotate32 causes facing32 if alive3 +

%LOAD1 releases jammed1 if alive1
%LOAD2 releases jammed2 if alive2
%LOAD3 causes not jammed3 if alive3

%alive1 and alive2 and alive3 and not jammed1 and not jammed2 and not jammed3 and facing12 and facing23 and facing31

warsaw_standoff_domain(Domain) :-
    %shoot12
    list_to_assoc(["causes"-(negate("alive2"), and("alive1", and(negate("jammed1"), "facing12")))], Shoot12_Causes_List),

    %shoot13
    list_to_assoc(["causes"-(negate("alive3"), and("alive1", and(negate("jammed1"), "facing13")))], Shoot13_Causes_List),

    %shoot21
    list_to_assoc(["causes"-(negate("alive1"), and("alive2", and(negate("jammed2"), "facing21")))], Shoot21_Causes_List),
    
    %shoot23
    list_to_assoc(["causes"-(negate("alive3"), and("alive2", and(negate("jammed2"), "facing23")))], Shoot23_Causes_List),

    %shoot31
    list_to_assoc(["causes"-(negate("alive1"), and("alive3", and(negate("jammed3"), "facing31"))), "impossible"-[0, 1]], Shoot31_Causes_List),

    %shoot32
    list_to_assoc(["causes"-(negate("alive2"), and("alive3", and(negate("jammed3"), "facing32"))), "impossible"-[0,1]], Shoot32_Causes_List),

    %************************************************

    %**************rotateS
    
    %rotate12
    list_to_assoc(["causes"-("facing12", "alive1")], Rotate12_Causes_List),

    %rotate13
    list_to_assoc(["causes"-("facing13", "alive1")], Rotate13_Causes_List),

    %rotate21
    list_to_assoc(["causes"-("facing21", "alive2")], Rotate21_Causes_List),

    %rotate23
    list_to_assoc(["causes"-("facing23", "alive2")], Rotate23_Causes_List),

    %rotate31
    list_to_assoc(["causes"-("facing31", "alive3")], Rotate31_Causes_List),

    %rotate32
    list_to_assoc(["causes"-("facing32", "alive3")], Rotate32_Causes_List),

    %*************LOADED

    %LOAD1
    list_to_assoc(["releases"-("jammed1", "alive1")], Load1_Releases_List), 

    %LOAD2
    list_to_assoc(["releases"-("jammed2", "alive2")], Load2_Releases_List), 

    %LOAD3
    list_to_assoc(["causes"-(negate("jammed3"), "alive3")], Load3_Causes_List), 
    list_to_assoc(["causes"-(true, true)], Idle_Causes_List), 


    %CREATING DOMAIN
    list_to_assoc(["shoot12"-Shoot12_Causes_List, "shoot13"-Shoot13_Causes_List,
                   "shoot21"-Shoot21_Causes_List, "shoot23"-Shoot23_Causes_List,
                   "shoot31"-Shoot31_Causes_List, "shoot32"-Shoot32_Causes_List,
                   "rotate12"-Rotate12_Causes_List, "rotate13"-Rotate13_Causes_List,
                   "rotate21"-Rotate21_Causes_List, "rotate23"-Rotate23_Causes_List,
                   "rotate31"-Rotate31_Causes_List, "rotate32"-Rotate32_Causes_List,
                   "LOAD1"-Load1_Releases_List, "LOAD2"-Load2_Releases_List,
                   "idle"-Idle_Causes_List,
                   "LOAD3"-Load3_Causes_List], Domain).

warsaw_standoff_scenario(Sc) :-
    %OBS
    list_to_assoc([0-and("alive1",
        and("alive2",
            and("alive3",
                and(negate("jammed1"),
                and(negate("jammed2"),
                and(negate("jammed3"),
                and("facing12",
                    and("facing23",
                        and("facing31", and(negate("facing13"),and(negate("facing21"), negate("facing32"))))
                            )))))))), 1-or(negate("jammed1"), negate("jammed2"))], Observations),

    %ACS
    list_to_assoc([
                    0-["LOAD1", "LOAD2", "LOAD3"],
                    1-["shoot12", "shoot23"],
                    2-["rotate13", "rotate21", "shoot31"],
                    3-["shoot13", "shoot21", "rotate32"],
                    4-["shoot32","idle"]], Compound_Actions),
    Sc = (Observations, Compound_Actions).
