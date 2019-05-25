class Query {
    id;
    type_text;
    condition;
    time;
    action;
    full_text;
    constructor(id, type_text, condition, time, action, full_text){
        this.id=id;
        this.type_text=type_text;
        this.condition=condition;
        this.time=time;
        this.action=action;
        this.full_text=full_text;
    }
    getQueryFullText(){return this.full_text}
}
const query_collection = {
    1: {id: 1, type_text: 'Necessarily executable scenario Sc'},
    2: {id: 2, type_text: 'Possibly executable scenario Sc'},
    3: {id: 3, type_text: 'Necessarily accessible γ at t when Sc'},
    4: {id: 4, type_text: 'Possibly accessible γ at t when Sc'},
    5: {id: 5, type_text: 'Necessarily executable A at t when Sc'},
    6: {id: 6, type_text: 'Possibly executable A at t when Sc'},
  }
var QuerySectionEventHandlers = {
shouldTimeBeHidden: function(query, prop_name){
    if (!(query.type_text == 'Necessarily executable scenario Sc' || query.type_text == 'Possibly executable scenario Sc' || query.type_text == ``))
        return true;
},
shouldActionBeHidden: function(query, prop_name){
    if (query.type_text == 'Necessarily executable A at t when Sc' || query.type_text == 'Possibly executable A at t when Sc')
        return true;
},
shouldCondBeHidden: function(query, prop_name){
    if (query.type_text == 'Possibly accessible γ at t when Sc' || query.type_text == 'Necessarily accessible γ at t when Sc')
        return true;
},
rebuildQueryText: function(query){
    if (query.type_text == 'Necessarily executable scenario Sc' || query.type_text == 'Possibly executable scenario Sc')
        query.full_text = query.type_text;
    if (query.type_text == 'Necessarily accessible γ at t when Sc')
        query.full_text = 'Necessarily accessible ' + query.condition + ' at ' + query.time + ' when Sc';
    if (query.type_text == 'Possibly accessible γ at t when Sc')
        query.full_text = 'Possibly accessible ' + query.condition + ' at ' + query.time + ' when Sc';
    if (query.type_text == 'Necessarily executable A at t when Sc')
        query.full_text = 'Necessarily executable ' + query.action + ' at ' + query.time + ' when Sc';
    if (query.type_text == 'Possibly executable A at t when Sc')
        query.full_text = 'Possibly executable ' + query.action + ' at ' + query.time + ' when Sc';
},
changedProperty(event, query){
    this.rebuildQueryText(query)
},
getQueryString: function(query) {
    return query.getQueryFullText();
}
}