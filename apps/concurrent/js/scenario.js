
class Entry {
    constructor(data, time) {
        this.data = data;
        this.time = time;
    }

    isEmpty() {
        return !this.data
    }
}

var ScenarioSectionEventHandlers = {
    remove: function (elem, array) {
        let index = array.indexOf(elem);
        array.splice(index, 1);
        this.adjustCollection(array);
        this.answer = undefined;
    },
    clear_answer: function () {
        this.answer = undefined;
    },
    moveUp: function (elem, array) {
        this.move(elem, array, 1);
        this.answer = undefined;
    },
    moveDown: function (elem, array) {
        this.move(elem, array, -1);
        this.answer = undefined;
    },
    move: function (elem, array, direction /* 1 or -1 */) {
        elem.time += direction;
        let index = array.indexOf(elem);
        let neighbour = array[index + direction];
        if (neighbour && neighbour.time === elem.time) {
            if (index + direction === array.length - 1 && neighbour.isEmpty()) {
                neighbour.time += direction;
            } else {
                array[index] = neighbour;
                array[index + direction] = elem;
                neighbour.time -= direction;
            }
        }
    },
    adjustCollection: function (array) {
        if (array.length === 0) {
            array.push(new Entry("", 0));
            return;
        }
        let lastElem = array[array.length - 1];
        if (!lastElem.isEmpty())
            array.push(new Entry("", lastElem.time + 1));
    },
    addToCollection: function (array) {
        if (array.length === 0) {
            array.push(new Entry("", 0));
            return;
        }
        let lastElem = array[array.length - 1];
        if (!lastElem.isEmpty())
            array.push(new Entry("", lastElem.time + 1));
    },
    getScenarioString: function () {
        return "(" + this.getObservationsString() + "," + this.getActionsString() + ")";
    },
    getActionsString: function () {
        return "{" +
            this.actions
                .filter(act => !act.isEmpty())
                .map(act => "({" + act.data + "}," + act.time + ")")
                .join(",\n") +
            "}";
    },
    getActions: function() {
        return this.actions
            .filter(act => !act.isEmpty())
            .map(act => act.data + "|" + act.time)
            .join("\n");
    },
    getObservationsString: function () {
        return "{" +
            this.observations
                .filter(obs => !obs.isEmpty())
                .map(obs => "(" + obs.data + "," + obs.time + ")")
                .join(",\n") +
            "}";
    },
    getObservations: function() {
        return this.observations
            .filter(obs => !obs.isEmpty())
            .map(obs => obs.data + "|" + obs.time)
            .join("\n");
    }
};