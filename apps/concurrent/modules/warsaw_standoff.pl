:- module(warsaw_standoff, [
    warsaw_standoff_domain/1,
    warsaw_standoff_scenario/1
    ]).

%SHOOT12 causes not ALIVE2 if ALIVE1 and not JAMMED1 and FACING12 +

%SHOOT13 causes not ALIVE3 if ALIVE1 and not JAMMED1 and FACING13 +

%SHOOT21 causes not ALIVE1 if ALIVE2 and not JAMMED2 and FACING21 +

%SHOOT23 causes not ALIVE3 if ALIVE2 and not JAMMED2 and FACING23 +

%SHOOT31 causes not ALIVE1 if ALIVE3 and not JAMMED3 and FACING31 +

%SHOOT32 causes not ALIVE2 if ALIVE3 and not JAMMED3 and FACING32 +

%impossible SHOOT31 at 0 +
%impossible SHOOT32 at 0 +
%impossible SHOOT31 at 1 + 
%impossible SHOOT32 at 1 +

%ROTATE12 causes FACING12 if ALIVE1 +
%ROTATE13 causes FACING13 if ALIVE1 +
%ROTATE21 causes FACING21 if ALIVE2 +
%ROTATE23 causes FACING23 if ALIVE2 + 
%ROTATE31 causes FACING31 if ALIVE3 + 
%ROTATE32 causes FACING32 if ALIVE3 +

%LOAD1 releases JAMMED1 if ALIVE1
%LOAD2 releases JAMMED2 if ALIVE2
%LOAD3 causes not JAMMED3 if ALIVE3

%ALIVE1 and ALIVE2 and ALIVE3 and not JAMMED1 and not JAMMED2 and not JAMMED3 and FACING12 and FACING23 and FACING31

warsaw_standoff_domain(Domain) :-
    %SHOOT12
    list_to_assoc(["causes"-(negate("ALIVE2"), and("ALIVE1", and(negate("JAMMED1"), "FACING12")))], Shoot12_Causes_List),
    
    %SHOOT13
    list_to_assoc(["causes"-(negate("ALIVE3"), and("ALIVE1", and(negate("JAMMED1"), "FACING13")))], Shoot13_Causes_List),

    %SHOOT21
    list_to_assoc(["causes"-(negate("ALIVE1"), and("ALIVE2", and(negate("JAMMED2"), "FACING21")))], Shoot21_Causes_List),
    
    %SHOOT23
    list_to_assoc(["causes"-(negate("ALIVE3"), and("ALIVE2", and(negate("JAMMED2"), "FACING23")))], Shoot23_Causes_List),

    %SHOOT31
    list_to_assoc(["causes"-(negate("ALIVE1"), and("ALIVE3", and(negate("JAMMED3"), "FACING31"))), "impossible"-[0, 1]], Shoot31_Causes_List),

    %SHOOT32
    list_to_assoc(["causes"-(negate("ALIVE2"), and("ALIVE3", and(negate("JAMMED3"), "FACING32"))), "impossible"-[0,1]], Shoot32_Causes_List),

    %************************************************

    %**************ROTATES
    
    %ROTATE12
    list_to_assoc(["causes"-("FACING12", "ALIVE1")], Rotate12_Causes_List),

    %ROTATE13
    list_to_assoc(["causes"-("FACING13", "ALIVE1")], Rotate13_Causes_List),

    %ROTATE21
    list_to_assoc(["causes"-("FACING21", "ALIVE2")], Rotate21_Causes_List),

    %ROTATE23
    list_to_assoc(["causes"-("FACING23", "ALIVE2")], Rotate23_Causes_List),

    %ROTATE31
    list_to_assoc(["causes"-("FACING31", "ALIVE3")], Rotate31_Causes_List),

    %ROTATE32
    list_to_assoc(["causes"-("FACING32", "ALIVE3")], Rotate32_Causes_List),

    %*************LOADED

    %LOAD1
    list_to_assoc(["releases"-("JAMMED1", "ALIVE1")], Load1_Releases_List), 

    %LOAD2
    list_to_assoc(["releases"-("JAMMED2", "ALIVE2")], Load2_Releases_List), 

    %LOAD3
    list_to_assoc(["causes"-(negate("JAMMED3"), "ALIVE3")], Load3_Causes_List), 


    %CREATING DOMAIN
    list_to_assoc(["SHOOT12"-Shoot12_Causes_List, "SHOOT13"-Shoot13_Causes_List,
                   "SHOOT21"-Shoot21_Causes_List, "SHOOT23"-Shoot23_Causes_List,
                   "SHOOT31"-Shoot31_Causes_List, "SHOOT32"-Shoot32_Causes_List,
                   "ROTATE12"-Rotate12_Causes_List, "ROTATE13"-Rotate13_Causes_List,
                   "ROTATE21"-Rotate21_Causes_List, "ROTATE23"-Rotate23_Causes_List,
                   "ROTATE31"-Rotate31_Causes_List, "ROTATE32"-Rotate32_Causes_List,
                   "LOAD1"-Load1_Releases_List, "LOAD2"-Load2_Releases_List,
                   "LOAD3"-Load3_Causes_List], Domain).

warsaw_standoff_scenario(Sc) :-
    %OBS
    list_to_assoc([0-and("ALIVE1", and("ALIVE2", and("ALIVE3", and(negate("JAMMED1"), and(negate("JAMMED2"), and(negate("JAMMED3"), and("FACING12", and("FACING23", and("FACING31")))))))))], Observations),

    %ACS
    list_to_assoc([
                    0-["LOAD1", "LOAD2", "LOAD3"],
                    1-["SHOOT12", "SHOOT23"],
                    2-["ROTATE13", "ROTATE21", "SHOOT31"],
                    3-["SHOOT13", "SHOOT21", "ROTATE32"],
                    4-["SHOOT32"]], Compound_Actions),
    Sc = (Observations, Compound_Actions).

% main_warsaw :-  
%     warsaw_standoff_domain(Domain),
%     warsaw_standoff_scenario(Scenario),
%     writeln(Domain),
%     writeln(Scenario).
