
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
            let answer = prescribed_stories[story_id];
            form.$data.action_domain = answer.action_domain;
            form.$data.scenario = answer.scenario;
            form.$data.query = answer.query;
        }
    },
    mounted() {
        materialize_init();
    }
});

let form = new Vue({
    el: '#form',
    data: {
        action_domain: ``,
        scenario: ``,
        query: ``
    },
    methods: {
        retrieve_answer: function () {
            verbose_command("test(9,Y).");
            let cleanse = str => str.replace(/(?:\r\n|\r|\n)/g, ' ');
            verbose_command(`rw(
'${cleanse(this.$data.action_domain)}',
'${cleanse(this.$data.scenario)}',
'${cleanse(this.$data.query)}'
).`.replace(/\n/gm, "")
            );
        }
    },
    mounted() {
        materialize_init();
    },
    updated() {
        M.updateTextFields();
        M.textareaAutoResize($('#action_domain'));
        M.textareaAutoResize($('#scenario'));
        M.textareaAutoResize($('#query'));
    }
});

// PROLOG
let verbose_command = (command, result_method) => {
    console.log(command);
    getAllSolutions('concurrent', command, undefined, results => {
        console.log(results);
        if (result_method)
            result_method(results);
    }, undefined, undefined, undefined, (par) => {
        M.toast({ html: par.data, classes: 'rounded' });
        console.error(par);
    }
    );
}