
// MATERIALIZE
let toinitialize = 3;
let materialize_init = () => {
    if (toinitialize == 1) {
        M.AutoInit();
        M.Collapsible.init(document.querySelectorAll('.collapsible'), {});
        M.Modal.init(document.querySelectorAll('.modal'), {});
        M.Dropdown.init(document.querySelectorAll('.dropdown-trigger'), {});
    } else {
        toinitialize -= 1;
    }
}
document.addEventListener('DOMContentLoaded', () => materialize_init());

// VUE
let dropdown = new Vue({
    el: '#dropdown',
    data: {
        items: prescribed_stories
    },
    methods: {
        prefill: function (story_id) {
            console.log(story_id)
            let answer = prescribed_stories[story_id];
            form.action_domain = answer.action_domain;
            form.actions = answer.actions;
            form.observations = answer.observations;
            form.query = new Query(answer.query.id, answer.query.type_text, answer.query.condition, answer.query.time, answer.query.action, answer.query.full_text);
            changeSelection(answer.query.type_text, form.query);
            modelData.debug = "parse_domain(\'"+ answer.action_domain +"\', Domain).";
        }
    },
    mounted() {
        materialize_init();
    }
});
let general_update = () => {
    M.updateTextFields();
    $('textarea').each(function () { M.textareaAutoResize($(this)) });
}
let update_method = function () {
    this.answer = undefined;
    general_update();
};
let query_update_method = function () {
    console.log(this)
    update_method();
}
const debugText = "domain([], D),\n" +
    "put_into_domain('LOAD', ['LOADED'], D, D1),\n" +
    "put_into_domain('SHOOT', [and(not('LOADED'), not('ALIVE'))], D1, D2),\n" +
    "put_into_domain('REBIRTH', ['ALIVE'], D2, D3),\n" +
    "get_from_domain('LOAD', D3, VALUE),\n" +
    "run_scenario([], D3, 0),\n" +
    "run_scenario([(and(not('LOADED'), 'ALIVE'), 'SHOOT'), (true, 'REBIRTH')], D3, 0).";

//const debugText2 = "parse_domain(" + answer.action_domain + "), Domain)."
const debugText3 = "parse_domain('SHOOT12 causes not ALIVE2 if ALIVE1 and not JAMMED1 and FACING12', Domain).";

let getNewQuery = function () { return  new Query(``, ``, ``, ``, ``, ``); };
let modelData = {
    action_domain: ``,
    answer: undefined,
    query: getNewQuery(),
    debug: debugText,
    actions: [],
    observations: [],
    queries: query_collection
};


let mainMethodsObject = {
    debug_query: function () {
        // verbose_command("test(9,Y).");
        let cleanse = str => str.replace(/(?:\r\n|\r|\n)/g, ' ');
        let debug_query = cleanse(this.debug).replace(/\n/gm, "");
        verbose_command(debug_query,
            (result) => {
                console.log(`%cDebug query:%c ${debug_query}`, `font-weight:bold`, ``)
                console.log(`%cResult of query`, `font-weight:bold`);
                console.log(result);
                this.answer = true;
            }, () => {
                console.log(`%cDebug query:%c ${debug_query}`, `font-weight:bold`, ``)
                console.log(`%cResult failed`, `font-weight:bold`);
                this.answer = false;
            }
        );
    },
    retrieve_answer: function () {
        // verbose_command("test(9,Y).");
        let cleanse = str => str.replace(/(?:\r\n|\r|\n)/g, ' ');
        verbose_command(`rw(` +
            `'${cleanse(this.action_domain)}',` +
            `'${cleanse(this.getScenarioString())}',` +
            `'${cleanse(this.getQueryString(this.query))}').`
                .replace(/\n/gm, ""),
            () => {
                this.answer = true;
            }, () => {
                this.answer = false;
            }
        );
    },
    clear: function () {
        this.action_domain = ``;
        this.actions = [];
        this.observations = [];
        this.query = getNewQuery();
        changeSelection(``, this.query);
        this.answer = undefined;
    },
    clear_action_domain: function () {
        this.answer = undefined;
        this.action_domain = ``;
    },
    clear_observations: function () {
        this.answer = undefined;
        this.observations = [];
    },
    clear_actions: function () {
        this.answer = undefined;
        this.actions = [];
    },
    clear_query: function () {
        this.answer = undefined;
        this.query = getNewQuery();
        changeSelection(``, this.query);
    }
};
$.extend(mainMethodsObject, ScenarioSectionEventHandlers);
$.extend(mainMethodsObject, QuerySectionEventHandlers);
let form = new Vue({
    el: '#form',
    data: modelData,
    methods: mainMethodsObject,
    mounted() {
        materialize_init();
        this.adjustCollection(this.observations);
        this.adjustCollection(this.actions);
    },
    watch: {
        action_domain: update_method,
        actions: function () {
            this.adjustCollection(this.actions);
            update_method();
        },
        observations: function () {
            this.adjustCollection(this.observations);
            update_method();
        },
        query: update_method
    },
    updated: general_update
});

// PROLOG
let verbose_command = (command, result_method, onfailure) => {
    getAllSolutions('concurrent', command, undefined, results => {
        // console.log(command);
        // console.log(results);
        if (result_method)
            result_method(results);
    }, () => {
        // console.log(command);
        if (onfailure)
            onfailure();
    }, undefined, undefined, (par) => {
        M.toast({ html: par.data, classes: 'rounded' });
        console.error(par);
    }
    );
}
