
// MATERIALIZE
let toinitialize = 0;
let materialize_init = () => {
    if (toinitialize == 0) {
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
// let setLoading = (loading) => advisements.loading = advisements.loading = loading;

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
    }
});
// let loader = new Vue({
//     el: '#loader',
//     data: {
//         loading: false
//     },
//     updated() {
//         materialize_init();
//     }
// });

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
    }
    ,
    updated() {
        materialize_init();
        M.updateTextFields();
        M.textareaAutoResize($('#action_domain'));
        M.textareaAutoResize($('#scenario'));
        M.textareaAutoResize($('#query'));
    }
});

// var advisements = new Vue({
//     el: '#advisements',
//     data: {
//         items: [],
//         loading: true
//     },
//     methods: {
//         delete_diagnosis: item => {
//             verbose_command(`removeAdvisement('${item[0].X}').`, () => refreshList());
//         },
//         add_universal_question: function (item) {
//             let answers = [];
//             for (let refkey in this.$refs) {
//                 let reference = this.$refs[refkey];
//                 let found = reference.find(el => el.id.startsWith(item[0].X + '$$universal$$answer-a'));
//                 if (found && found.value)
//                     answers.push(found.value);
//             }
//             console.log(answers);
//         }
//     },
//     updated() {
//         materialize_init();
//     }
// });

// var newdiagnosis = new Vue({
//     el: '#newdiagnosis',
//     data: {
//         diagnosis: ""
//     },
//     methods: {
//         addNewBlankDiagnosis: diagnosis => {
//             // console.log(diagnosis)
//             verbose_command(`addBlankAdvisement('${diagnosis}').`, () => refreshList())
//         }
//     },
//     updated() {
//         materialize_init();
//     }
// });


// PROLOG

let verbose_command = (command, result_method) => {
    console.log(command);
    getAllSolutions('concurrent', command, results => {
        console.log(results);
        if (result_method)
            result_method(results);
    }, undefined, undefined, undefined, (par) => {
        M.toast({ html: par.data, classes: 'rounded' });
        console.error(par);
    }
    );
}

// setLoading(true);
// let refreshList = () => {
//     getAllSolutions('concurrent', `getAdvisements(X,Y).`, results => {
//         console.log(results);
//         advisements.items = results;
//         setLoading(false);
//     }, failur => {
//         console.log('no items in database');
//         advisements.items = [];
//         setLoading(false);
//     });
// }

// refreshList();