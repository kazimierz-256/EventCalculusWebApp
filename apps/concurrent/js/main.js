
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

let update_method = function () {
    this.$data.answer = undefined;
    M.updateTextFields();
    M.textareaAutoResize($('#action_domain'));
    M.textareaAutoResize($('#scenario'));
    M.textareaAutoResize($('#query'));
};
let form = new Vue({
    el: '#form',
    data: {
        action_domain: ``,
        scenario: ``,
        query: ``,
        answer: undefined
    },
    methods: {
        retrieve_answer: function () {
            verbose_command("test(9,Y).");
            let cleanse = str => str.replace(/(?:\r\n|\r|\n)/g, ' ');
            verbose_command(`rw(
'${cleanse(this.$data.action_domain)}',
'${cleanse(this.$data.scenario)}',
'${cleanse(this.$data.query)}'
).`.replace(/\n/gm, ""),
                () => {
                    this.$data.answer = true;
                }, () => {
                    this.$data.answer = false;
                }
            );
        }
    },
    mounted() {
        materialize_init();
    },
    watch: {
        action_domain: update_method,
        scenario: update_method,
        query: update_method
    }
});

// PROLOG
let verbose_command = (command, result_method, onfailure) => {
    getAllSolutions('concurrent', command, undefined, results => {
        console.log(command);
        console.log(results);
        if (result_method)
            result_method(results);
    }, () => {
        if (onfailure)
            onfailure();
    }, undefined, undefined, (par) => {
        M.toast({ html: par.data, classes: 'rounded' });
        console.error(par);
    }
    );
}