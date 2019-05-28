:- module(sunday_turkey, [
    sunday_turkey_domain/1,
    sunday_turkey_scenario/1
    ]).

%THINKABOUTSUNDAY causes not MOVING
%ALARM causes MOVING if ALIVE
%SHOOT causes not ALIVE and not MOVING

sunday_turkey_domain(Domain) :-
    %THINKABOUTSUNDAY
    list_to_assoc(["causes"-negate("MOVING")], Think_About_Sunday_Assoc),
    
    %ALARM
    list_to_assoc(["causes"-"MOVING"], Alarm_Assoc),

    %SHOOT
    list_to_assoc(["causes"-and(negate("ALIVE"), negate("MOVING"))], Shoot_Assoc),

    %DOMAIN
    list_to_assoc(["THINKABOUTSUNDAY"-Think_About_Sunday_Assoc, "ALARM"-Alarm_Assoc,
                   "SHOOT"-Shoot_Assoc], Domain). 

sunday_turkey_scenario(Scenario) :-
    %OBS
    list_to_assoc([0-and("ALIVE", "MOVING")], OBS),

    %ACS
    list_to_assoc([
                    0-["SHOOT", "THINKABOUTSUNDAY"],
                    1-["SHOOT", "THINKABOUTSUNDAY", "ALARM"],
                    2-["SHOOT"]], ACS), 
    Scenario = (OBS, ACS).
