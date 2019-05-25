let prescribed_stories =
{
    'Warsaw Standoff': {
        action_domain: `SHOOT12 causes not ALIVE2 if ALIVE1 and not JAMMED1 and FACING12
SHOOT13 causes not ALIVE3 if ALIVE1 and not JAMMED1 and FACING13
SHOOT21 causes not ALIVE1 if ALIVE2 and not JAMMED2 and FACING21
SHOOT23 causes not ALIVE3 if ALIVE2 and not JAMMED2 and FACING23
SHOOT31 causes not ALIVE1 if ALIVE3 and not JAMMED3 and FACING31
SHOOT32 causes not ALIVE2 if ALIVE3 and not JAMMED3 and FACING32
impossible SHOOT31 at 0
impossible SHOOT32 at 0
impossible SHOOT31 at 1
impossible SHOOT32 at 1
ROTATE12 causes FACING12 if ALIVE1
ROTATE13 causes FACING13 if ALIVE1
ROTATE21 causes FACING21 if ALIVE2
ROTATE23 causes FACING23 if ALIVE2
ROTATE31 causes FACING31 if ALIVE3
ROTATE32 causes FACING32 if ALIVE3
LOAD1 releases JAMMED1 if ALIVE1
LOAD2 releases JAMMED2 if ALIVE2
LOAD3 causes not JAMMED3 if ALIVE3`,
        observations: [
            new Entry("ALIVE1 and ALIVE2 and ALIVE3 and not JAMMED1 and not JAMMED2 and not JAMMED3 and FACING12 and FACING23 and FACING31", 0),
            new Entry("not JAMMED1 or not JAMMED2", 1)
        ],
        actions: [
            new Entry("LOAD1,LOAD2,LOAD3", 0),
            new Entry("SHOOT12,SHOOT23", 1),
            new Entry("ROTATE13,ROTATE21,SHOOT31", 2),
            new Entry("SHOOT13,SHOOT21,ROTATE32", 3),
            new Entry("SHOOT32", 4)
        ],
        query: new Query(`5`, `Possibly accessible γ at t`, `ALIVE1 and not ALIVE2 and not ALIVE3`, `5`, ``, `Possibly accessible ALIVE1 and not ALIVE2 and not ALIVE3 at 5`)
    },
    'Ewakuacja budynku': {
        action_domain: `CFROM3TO2 causes not CON3 and CON2 if CON3 and not BON2
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
PANICAON1 causes AON3 if AON3`,
        observations: [
            new Entry("CON3 and BON2 and AON1 and not SAFEA and not SAFEB and not SAFEC", 0)
        ],
        actions: [
            new Entry("EVACUATEAFROM1,BFROM2TO1,CFROM3TO2", 0),
            new Entry("BFROM2TO1,CFROM3TO2,PANICBON2", 1),
            new Entry("BFROM2TO1,EVACUATEBFROM1,CFROM3TO2", 2),
            new Entry("EVACUATEBFROM1,CFROM3TO2,CFROM2TO1", 3),
            new Entry("EVACUATECFROM1,CFROM2TO1", 4),
            new Entry("EVACUATECFROM1", 5)
        ],
        query: new Query(`5`, `Possibly accessible γ at t`, `SAFEA and SAFEB and SAFEC`, `5`, ``, `possibly accessible SafeA and SafeB and SafeC 5`)
    },
    'Myślał indyk o niedzieli': {
        action_domain: `THINKABOUTSUNDAY causes not MOVING
ALARM causes MOVING if ALIVE
SHOOT causes not ALIVE and not MOVING`,
        observations: [
            new Entry("ALIVE and MOVING", 0)
        ],
        actions: [
            new Entry("SHOOT,THINKABOUTSUNDAY", 0),
            new Entry("SHOOT,THINKABOUTSUNDAY,ALARM", 1),
            new Entry("SHOOT", 2)
        ],
        query: new Query(`5`, `Possibly accessible γ at t`, `ALIVE`, `5`, ``, `Possibly accessible ALIVE at 5`)
    }
};