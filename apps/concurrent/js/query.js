class Query {
    constructor(id, type_text, condition, time, action, full_text) {
        this.id = id;
        this.type_text = type_text;
        this.condition = condition;
        this.time = time;
        this.action = action;
        this.full_text = full_text;
    }
    getQueryFullText() { return this.full_text }
}
const query_collection = {
    1: { id: 1, type_text: 'Necessarily executable scenario Sc' },
    2: { id: 2, type_text: 'Necessarily executable A at t when Sc' },
    3: { id: 3, type_text: 'Necessarily accessible γ at t when Sc' },
    4: { id: 4, type_text: 'Possibly executable scenario Sc' },
    5: { id: 5, type_text: 'Possibly executable A at t when Sc' },
    6: { id: 6, type_text: 'Possibly accessible γ at t when Sc' },
}
let changeSelection = function(selection, query) {
    document.getElementById('select').value = (selection);
    document.getElementById('select').dispatchEvent(new Event('change'));
    query.type_text = selection;
}
var QuerySectionEventHandlers = {
    rebuildQueryText: function (query) {
        if (query.type_text == 'Necessarily executable scenario Sc')
            query.full_text = 'necessarily executable'
        if (query.type_text == 'Possibly executable scenario Sc')
            query.full_text = 'possibly executable'
        if (query.type_text == 'Necessarily accessible γ at t when Sc')
            query.full_text = 'necessarily accessible ' + query.condition + ' at ' + query.time;
        if (query.type_text == 'Possibly accessible γ at t when Sc')
            query.full_text = 'possibly accessible ' + query.condition + ' at ' + query.time;
        if (query.type_text == 'Necessarily executable A at t when Sc')
            query.full_text = 'necessarily executable ' + query.action + ' at ' + query.time;
        if (query.type_text == 'Possibly executable A at t when Sc')
            query.full_text = 'possibly executable ' + query.action + ' at ' + query.time;
    },
    changedProperty(event, query) {
        this.rebuildQueryText(query);
        this.answer = undefined;
    },
    getQueryString: function (query) {
        return query.getQueryFullText();
    },
}