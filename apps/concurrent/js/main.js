
// MATERIALIZE
let toinitialize = 2;
let materialize_init = () => {
    if (toinitialize == 2) {
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
let setLoading = (loading) => advisements.loading = advisements.loading = loading;

// var loader = new Vue({
//     el: '#loader',
//     data: {
//         loading: false
//     },
//     updated() {
//         materialize_init();
//     }
// });

var form = new Vue({
    el: '#form',
    data: {
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
LOAD3 causes NOT JAMMED3 if ALIVE3`,
        scenario: `({
(ALIVE1 and ALIVE2 and ALIVE3 and not JAMMED1 and not JAMMED2 and not JAMMED3 and FACING12 and FACING23 and FACING31,0),
(not JAMMED1 or not JAMMED2,1)
},
{
({LOAD1,LOAD2,LOAD3},0),
({SHOOT12,SHOOT23},1),
({ROTATE13,ROTATE21,SHOOT31},2),
({SHOOT13,SHOOT21,ROTATE32},3),
({SHOOT32},4)
})`,
        query: `possibly accessible ALIVE1 and not ALIVE2 and not ALIVE3 at 5`
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