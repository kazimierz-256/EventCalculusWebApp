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
    1: {id: 1, type_text: 'Necessarily executable'},
    2: {id: 2, type_text: 'Possibly executable'},
    3: {id: 3, type_text: 'Necessarily accessible γ at t'},
    4: {id: 4, type_text: 'Possibly accessible γ at t'},
    5: {id: 5, type_text: 'Necessarily executable A at t'},
    6: {id: 6, type_text: 'Possibly executable A at t'},
  }
var QuerySectionEventHandlers = {
shouldTimeBeHidden: function(query, prop_name){
    if (!(query.type_text == 'Necessarily executable' || query.type_text == 'Possibly executable' || query.type_text == ``))
        return true;
},
shouldActionBeHidden: function(query, prop_name){
    if (query.type_text == 'Necessarily executable A at t' || query.type_text == 'Possibly executable A at t')
        return true;
},
shouldCondBeHidden: function(query, prop_name){
    if (query.type_text == 'Possibly accessible γ at t' || query.type_text == 'Necessarily accessible γ at t')
        return true;
},
rebuildQueryText: function(query){
    if (query.type_text == 'Necessarily executable' || query.type_text == 'Possibly executable')
        query.full_text = query.type_text;
    if (query.type_text == 'Necessarily accessible γ at t')
        query.full_text = 'Necessarily accessible ' + query.condition + ' at ' + query.time;
    if (query.type_text == 'Possibly accessible γ at t')
        query.full_text = 'Possibly accessible ' + query.condition + ' at ' + query.time;
    if (query.type_text == 'Necessarily executable A at t')
        query.full_text = 'Necessarily executable ' + query.action + ' at ' + query.time;
    if (query.type_text == 'Possibly executable A at t')
        query.full_text = 'Possibly executable ' + query.action + ' at ' + query.time;
},
changedProperty(event, query){
    this.rebuildQueryText(query)
},
getQueryString: function() {
    return this.getQueryFullText();
}
}