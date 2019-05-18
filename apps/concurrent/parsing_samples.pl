% Action Domain
SHOOT12 causes not ALIVE2 if ALIVE1 and not JAMMED1 and FACING12
% causes("SHOOT12", "not ALIVE2", "ALIVE1 and not JAMMED1 and FACING12")
domain = {"SHOOT12" : {"causes": ("not ALIVE2", "ALIVE1 and not JAMMED1 and FACING12")}}
domain = {"SHOOT12" : {"causes": (not("ALIVE2"), and("ALIVE1", and(not("JAMMED1"), "FACING12")))}}

SHOOT12 causes not ALIVE2 and BLA
% causes("SHOOT12", "not ALIVE2 and BLA")

impossible SHOOT12 at 0
impossible("SHOOT12", 0)

domain = {"SHOOT12" : {"causes": ("not ALIVE2", "ALIVE1 and not JAMMED1 and FACING12"), "impossible": [0]}}
domain = {"SHOOT12" : {"causes": (not("ALIVE2"), and("ALIVE1", and(not("JAMMED1"), "FACING12"))), "impossible": [0]}}

LOAD1 releases JAMMED1 if ALIVE1 and ALIVE2 and not ALIVE3
% releases("LOAD", "JAMMED1", "ALIVE1 and ALIVE2 and not ALIVE3")

domain = {{
            "SHOOT12" : {"causes": ("not ALIVE2", "ALIVE1 and not JAMMED1 and FACING12"), "impossible": [0]},
            "LOAD1" : {"causes": (), "impossible": [] 
            }}}
domain = {{
            "SHOOT12" : {"causes": (not("ALIVE2"), and("ALIVE1", and(not("JAMMED1"), "FACING12"))), "impossible": [0]},
            "LOAD1" : {"causes": (), "impossible": []
            }}}

% Scenario Sc = (OBS, ACS)
({
    (ALIVE1 and ALIVE2 and ALIVE3 and not JAMMED1 and not JAMMED2 and not JAMMED3 and FACING12 and FACING23 and FACING31,0),
    (not JAMMED1 or not JAMMED2,1)
},
{
    ({LOAD1,LOAD2,LOAD3},0),
    ({SHOOT12,SHOOT23},1),
    ({ROTATE13,ROTATE21,SHOOT31},2),
    ({SHOOT13,SHOOT21,ROTATE32},3),
    ({SHOOT32},4)
})

scenario(
    [below is a representation of association list]
    0-"ALIVE1 and ALIVE2 and ALIVE3 and not JAMMED1 and not JAMMED2 and not JAMMED3 and FACING12 and FACING23 and FACING31"
    1-"not JAMMED1 or not JAMMED2"
    ,
    [association list]
    0-"LOAD1,LOAD2,LOAD3"
    1-"SHOOT12,SHOOT23"
    2-"ROTATE13,ROTATE21,SHOOT31"
    3-"SHOOT13,SHOOT21,ROTATE32"
    4-"SHOOT32"
)


scenario(
    [below is a representation of association list]
    0-and("ALIVE1", and("ALIVE2", and("ALIVE3", and(not("JAMMED1"), and(not("JAMMED2"), and(not("JAMMED3"), and("FACING23", "FACING31")))))))
    1-or(not("JAMMED1"),not("JAMMED2"))
    ,
    [association list]
    0-["LOAD1", "LOAD2", "LOAD3"]
    1-["SHOOT12", "SHOOT23"]
    2-["ROTATE13", "ROTATE21", "SHOOT31"]
    3-["SHOOT13", "SHOOT21", "ROTATE32"]
    4-["SHOOT32"]
)

% Query
possibly accessible ALIVE1 and not ALIVE2 and not ALIVE3 at 5

query(possibly, accessible, "ALIVE1 and not ALIVE2 and not ALIVE3", 5)
query(possibly, accessible, and("ALIVE1", and(not("ALIVE2"), not("ALIVE3"))), 5)