
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
            form.action_domain = answer.action_domain;
            form.scenario = answer.scenario;
            form.query = answer.query;
        }
    },
    mounted() {
        materialize_init();
    }
});

let general_update = () => {
    M.updateTextFields();
    M.textareaAutoResize($('#action_domain'));
    M.textareaAutoResize($('#scenario'));
    M.textareaAutoResize($('#query'));
}
let update_method = function () {
    this.answer = undefined;
    general_update();
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
            verbose_command(`rw(` +
                `'${cleanse(this.action_domain)}',` +
                `'${cleanse(this.scenario)}',` +
                `'${cleanse(this.query)}').`
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
            this.scenario = ``;
            this.query = ``;
        }
    },
    mounted() {
        materialize_init();
    },
    watch: {
        action_domain: update_method,
        scenario: update_method,
        query: update_method
    },
    updated: general_update
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
